scriptname _WSW_PlayerAlias extends ReferenceAlias

import CommonArrayHelper

Actor property PlayerRef Auto
GlobalVariable property _WSW_WheelHotkeyRight auto
GlobalVariable property _WSW_WheelHotkeyLeft auto
GlobalVariable property _WSW_WheelHotkeySetting_FavoritesOnly auto
GlobalVariable property _WSW_WheelHotkeySetting_Ignore2Hand auto
Message property _WSW_SKSE_Error auto
Message property _WSW_SKYUI_Error auto
Weapon property _WSW_DummyWeapon auto
Light property Torch01 auto
int property SKSE_MIN_VERSION = 10703 autoReadOnly
Form[] heldItems
Form[] heldItemsPrecached
int MOUSEWHEEL_UP = 264
int MOUSEWHEEL_DN = 265
int currentIndexRight = 0
int currentIndexLeft = 0
bool processing = false
bool leftHotkeyHeld = false
bool rightHotkeyHeld = false

Event OnInit()
	CheckSKSE()
	CheckSkyUI()
	if !self.GetOwningQuest().IsRunning()
		self.GetOwningQuest().Start()
	else
		heldItems = new Form[128]
		heldItemsPrecached = new Form[128]
		self.RegisterForKey(264)
		self.RegisterForKey(265)
		GetPlayerHeldItems()
	endif
EndEvent

Event OnPlayerLoadGame()
	CheckSKSE()
	CheckSkyUI()
	heldItems = new Form[128]
	heldItemsPrecached = new Form[128]
	self.RegisterForKey(264)
	self.RegisterForKey(265)
	int right_hotkey = _WSW_WheelHotkeyRight.GetValueInt()
	int left_hotkey = _WSW_WheelHotkeyLeft.GetValueInt()
	if right_hotkey != 0
		self.RegisterForKey(right_hotkey)
	endif
	if left_hotkey != 0
		self.RegisterForKey(left_hotkey)
	endif
	GetPlayerHeldItems()
EndEvent

function GetPlayerHeldItems()
	; Fist is always available
	bool r = ArrayAddForm(heldItems, _WSW_DummyWeapon)

	int torch_count = PlayerRef.GetItemCount(Torch01)
	if torch_count > 0
		ArrayAddForm(heldItems, Torch01)
	endif

	int itemCount = PlayerRef.GetNumItems()
	int i = 1
	while i < itemCount
		Form baseObject = PlayerRef.GetNthForm(i)
		if baseObject as Weapon || ((baseObject as Armor) && (baseObject as Armor).IsShield())
			r = ArrayAddForm(heldItems, baseObject)
		endif
		i += 1
	endWhile
	;debug.trace("Result of initial check: " + heldItems)
endFunction

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	if akBaseItem as Weapon || akBaseItem == Torch01 || ((akBaseItem as Armor) && (akBaseItem as Armor).IsShield())
		int searchResult = heldItems.Find(akBaseItem)
		;debug.trace("searchResult = " + searchResult)
		if searchResult == -1
			bool r = ArrayAddForm(heldItems, akBaseItem)
			;debug.trace(heldItems)
		endif
	endif
EndEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	if akBaseItem as Weapon || akBaseItem == Torch01 || ((akBaseItem as Armor) && (akBaseItem as Armor).IsShield())
		int searchResult = heldItems.Find(akBaseItem)
		;debug.trace("searchResult = " + searchResult)
		if searchResult != -1 && PlayerRef.GetItemCount(akBaseItem) == 0
			bool r = ArrayRemoveForm(heldItems, akBaseItem, true)
			;debug.trace(heldItems)
		endif
	endif
EndEvent

Event OnKeyDown(int keyCode)
	if !processing
		processing = true
		if keyCode == MOUSEWHEEL_UP
			PrevWeapon()
		elseif keyCode == MOUSEWHEEL_DN
			NextWeapon()
		elseif KeyCode == _WSW_WheelHotkeyRight.GetValueInt()
			HotkeyDownRight()
		elseif keyCode == _WSW_WheelHotkeyLeft.GetValueInt()
			HotkeyDownLeft()
		endif
		processing = false
	endif
EndEvent

Event OnKeyUp(int keyCode, float holdTime)
	if KeyCode == _WSW_WheelHotkeyRight.GetValueInt()
		Utility.Wait(0.25)
		;debug.trace("ScrollWheel Right Disabled")
		Game.EnablePlayerControls()
		rightHotkeyHeld = false
	elseif KeyCode == _WSW_WheelHotkeyLeft.GetValueInt()
		Utility.Wait(0.25)
		;debug.trace("ScrollWheel Left Disabled")
		Game.EnablePlayerControls()
		leftHotkeyHeld = false
	endif
EndEvent

function PrevWeapon(bool bContinued = false)
	if rightHotkeyHeld || leftHotkeyHeld
		int itemCount = ArrayCountForm(heldItems)
		;debug.trace("itemCount = " + itemCount)
		if itemCount == 0
			return
		endif
		
		if rightHotkeyHeld
			currentIndexRight -= 1
			if currentIndexRight < 0
				currentIndexRight = itemCount - 1
			endif
		elseif leftHotkeyHeld
			currentIndexLeft -= 1
			if currentIndexLeft < 0
				currentIndexLeft = itemCount - 1
			endif
		endif

		;debug.trace("prev currentIndexRight = " + currentIndexRight + " , currentIndexLeft = " + currentIndexLeft)
		if rightHotkeyHeld
			EquipItemAtIndex(currentIndexRight, false, false, bContinued)
		elseif leftHotkeyHeld
			EquipItemAtIndex(currentIndexLeft, true, false, bContinued)
		endif
	endif
endFunction

function NextWeapon(bool bContinued = false)
	if rightHotkeyHeld || leftHotkeyHeld
		int itemCount = ArrayCountForm(heldItems)
		;debug.trace("itemCount = " + itemCount)
		if itemCount == 0
			return
		endif
		
		if rightHotkeyHeld
			currentIndexRight += 1
			if currentIndexRight >= itemCount
				currentIndexRight = 0
			endif
		elseif leftHotkeyHeld
			currentIndexLeft += 1
			if currentIndexLeft >= itemCount
				currentIndexLeft = 0
			endif
		endif

		;debug.trace("next currentIndexRight = " + currentIndexRight + " , currentIndexLeft = " + currentIndexLeft)
		if rightHotkeyHeld
			EquipItemAtIndex(currentIndexRight, false, true, bContinued)
		elseif leftHotkeyHeld
			EquipItemAtIndex(currentIndexLeft, true, true, bContinued)
		endif
	endif
endFunction

function SwitchToFist(bool left = false)
	Weapon currentWeapon
	Armor currentShield
	currentWeapon = PlayerRef.GetEquippedWeapon(left)
	if currentWeapon
		if left
			PlayerRef.UnequipItemEx(currentWeapon, 2)
		else
			PlayerRef.UnequipItemEx(currentWeapon, 1)
		endif
	elseif left
		currentShield = PlayerRef.GetEquippedShield()
		if currentShield
			PlayerRef.UnequipItem(currentShield, abSilent = true)
		elseif PlayerRef.GetEquippedObject(0) == Torch01
			PlayerRef.UnequipItem(Torch01, abSilent = true)
		endif
	endif
endFunction

function EquipItemAtIndex(int index, bool left = false, bool next = false, bool bContinued = false)
	Form newItem = heldItems[index]
	
	if newItem
		Weapon newItemAsWeapon = newItem as Weapon
		Armor newItemAsArmor = newItem as Armor
		; Hand-to-Hand
		if newItem == _WSW_DummyWeapon
			SwitchToFist(left)
			return
		else
			bool can_equip = true
			
			; Favorites Only
			if _WSW_WheelHotkeySetting_FavoritesOnly.GetValueInt() == 2
				if !Game.IsObjectFavorited(newItem)
					can_equip = false
				endif
			endif	

			; One-handed / shield / torch detection
			if can_equip
				if newItemAsWeapon
					if _WSW_WheelHotkeySetting_Ignore2Hand.GetValueInt() == 2
						int newWeaponType = newItemAsWeapon.GetWeaponType()
						if newWeaponType != 8 && newWeaponType >= 5
							can_equip = false
						endif
					endif
				elseif !left
					if newItem == Torch01 || (newItemAsArmor && newItemAsArmor.IsShield())
						can_equip = false
					endif
				endif
			endif

			; Is this already equipped? If so, do they have more than one?
			if can_equip
				if newItem != _WSW_DummyWeapon && newItemAsWeapon && (PlayerRef.GetEquippedWeapon() == newItem || PlayerRef.GetEquippedWeapon(true) == newItem)
					if PlayerRef.GetItemCount(newItem) < 2
						can_equip = false
					endif
				endif
			endif

			; Loop around if no qualifying equipment found.
			; The fist weapon is always valid, so there is no risk of infinite loop here.
			if !can_equip
				if next
					NextWeapon(true)
				else
					PrevWeapon(true)
				endif
				return
			endif	

			; Fall-through case - Equip the item
			if left
				PlayerRef.EquipItemEx(newItem, equipSlot = 2)
			else
				PlayerRef.EquipItemEx(newItem)
			endif
		endif
	endif
endFunction

function HotkeyDownRight()
	if UI.IsMenuOpen("Console") || UI.IsMenuOpen("Book Menu") || UI.IsMenuOpen("BarterMenu") || UI.IsMenuOpen("ContainerMenu") || UI.IsMenuOpen("Crafting Menu") || UI.IsMenuOpen("Dialogue Menu") || UI.IsMenuOpen("FavoritesMenu") || UI.IsMenuOpen("InventoryMenu") || UI.IsMenuOpen("Journal Menu") || UI.IsMenuOpen("Lockpicking Menu") || UI.IsMenuOpen("MagicMenu") || UI.IsMenuOpen("MapMenu") || UI.IsMenuOpen("MessageBoxMenu") || UI.IsMenuOpen("Sleep/Wait Menu") || UI.IsMenuOpen("StatsMenu")
		return
	else
		;debug.trace("ScrollWheel Enabled (Right)")
		rightHotkeyHeld = true
		leftHotkeyHeld = false
		Game.DisablePlayerControls(false, false, true, false, false, false, false, false)
	endif
endFunction

function HotkeyDownLeft()
	if UI.IsMenuOpen("Console") || UI.IsMenuOpen("Book Menu") || UI.IsMenuOpen("BarterMenu") || UI.IsMenuOpen("ContainerMenu") || UI.IsMenuOpen("Crafting Menu") || UI.IsMenuOpen("Dialogue Menu") || UI.IsMenuOpen("FavoritesMenu") || UI.IsMenuOpen("InventoryMenu") || UI.IsMenuOpen("Journal Menu") || UI.IsMenuOpen("Lockpicking Menu") || UI.IsMenuOpen("MagicMenu") || UI.IsMenuOpen("MapMenu") || UI.IsMenuOpen("MessageBoxMenu") || UI.IsMenuOpen("Sleep/Wait Menu") || UI.IsMenuOpen("StatsMenu")
		return
	else
		;debug.trace("ScrollWheel Enabled (Left)")
		leftHotkeyHeld = true
		rightHotkeyHeld = false
		Game.DisablePlayerControls(false, false, true, false, false, false, false, false)
	endif
endFunction


; Compatibility =====================================

function CheckSKSE()
	bool skse_loaded = SKSE.GetVersion()
	if skse_loaded
		int skse_version = (SKSE.GetVersion() * 10000) + (SKSE.GetVersionMinor() * 100) + SKSE.GetVersionBeta()
		if skse_version < SKSE_MIN_VERSION
			_WSW_SKSE_Error.Show(((skse_version as float) / 10000), ((SKSE_MIN_VERSION as float) / 10000))
			debug.trace("[Scroll Wheel Equip][Error] Detected SKSE version " + ((skse_version as float) / 10000) + ", expected " + ((SKSE_MIN_VERSION as float) / 10000) + " or newer.")			
		else
			debug.trace("[Scroll Wheel Equip] Detected SKSE version " + ((skse_version as float) / 10000) + " (expected " + ((SKSE_MIN_VERSION as float) / 10000) + " or newer, success!)")
		endif
	else
		_WSW_SKSE_Error.Show(((0.0) / 10000), ((SKSE_MIN_VERSION as float) / 10000))
		debug.trace("[Scroll Wheel Equip][Error] Detected SKSE version " + ((0.0) / 10000) + ", expected " + ((SKSE_MIN_VERSION as float) / 10000) + " or newer.")
	endif
endFunction

function CheckSkyUI()
	bool isSKYUILoaded = IsPluginLoaded(0x01000814, "SkyUI.esp")
	if !isSKYUILoaded
		_WSW_SKYUI_Error.Show()
	endif
endFunction

bool function IsPluginLoaded(int iFormID, string sPluginName)
	int i = Game.GetModByName(sPluginName)
	if i != 255
		debug.trace("[Scroll Wheel Equip] Loaded: " + sPluginName)
		return true
	else
		return false
	endif
endFunction