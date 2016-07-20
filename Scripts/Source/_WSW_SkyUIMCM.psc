scriptname _WSW_SkyUIMCM extends SKI_ConfigBase

GlobalVariable property _WSW_WheelHotkeyRight auto
GlobalVariable property _WSW_WheelHotkeyLeft auto
GlobalVariable property _WSW_WheelHotkeySetting_FavoritesOnly auto
GlobalVariable property _WSW_WheelHotkeySetting_Ignore2Hand auto
ReferenceAlias property PlayerAlias auto

int Gameplay_HotkeyEnableWheelRight_OID
int Gameplay_HotkeyEnableWheelLeft_OID
int Gameplay_ToggleFavoritesOnly_OID
int Gameplay_ToggleIgnore2Hand_OID

Event OnConfigInit()
	Pages = new string[1]
	Pages[0] = "$WSWGameplayPage"
endEvent

int function GetVersion()
	return 1
endFunction

Event OnVersionUpdate(int a_version)
	; pass
EndEvent

event OnPageReset(string page)
	if page == ""
		LoadCustomContent("ScrollWheelEquip/logo.dds")
	else
		UnloadCustomContent()
	endif

	if !Pages
		OnConfigInit()
	endif

	if page == "$WSWGameplayPage"
		PageReset_Gameplay()
	endif
endEvent

event OnOptionHighlight(int option)
	if option == Gameplay_HotkeyEnableWheelRight_OID
		SetInfoText("$WSWGameplayHotkeyWheelRightHighlight")
	elseif option == Gameplay_HotkeyEnableWheelLeft_OID
		SetInfoText("$WSWGameplayHotkeyWheelLeftHighlight")
	elseif option == Gameplay_ToggleFavoritesOnly_OID
		SetInfoText("$WSWGameplayFavoritesOnlyHighlight")
	elseif option == Gameplay_ToggleIgnore2Hand_OID
		SetInfoText("$WSWGameplayIgnore2HandHighlight")
	endif
endEvent

function PageReset_Gameplay()
	SetCursorFillMode(TOP_TO_BOTTOM)

	AddHeaderOption("$WSWHotkeysHeader")
	Gameplay_HotkeyEnableWheelRight_OID = AddKeyMapOption("$WSWGameplayHotkeyWheelRight", _WSW_WheelHotkeyRight.GetValueInt())
	Gameplay_HotkeyEnableWheelLeft_OID = AddKeyMapOption("$WSWGameplayHotkeyWheelLeft", _WSW_WheelHotkeyLeft.GetValueInt())
	AddEmptyOption()
	AddHeaderOption("$WSWOptionsHeader")
	if _WSW_WheelHotkeySetting_FavoritesOnly.GetValueInt() == 2
		Gameplay_ToggleFavoritesOnly_OID = AddToggleOption("$WSWGameplayFavoritesOnly", true)
	else
		Gameplay_ToggleFavoritesOnly_OID = AddToggleOption("$WSWGameplayFavoritesOnly", false)
	endif
	if _WSW_WheelHotkeySetting_Ignore2Hand.GetValueInt() == 2
		Gameplay_ToggleIgnore2Hand_OID = AddToggleOption("$WSWGameplayIgnore2Hand", true)
	else
		Gameplay_ToggleIgnore2Hand_OID = AddToggleOption("$WSWGameplayIgnore2Hand", false)
	endif
endFunction

Event OnOptionSelect(int option)
	if option == Gameplay_ToggleFavoritesOnly_OID
		OnOptionSelectAction(_WSW_WheelHotkeySetting_FavoritesOnly, Gameplay_ToggleFavoritesOnly_OID)
	elseif option == Gameplay_ToggleIgnore2Hand_OID
		OnOptionSelectAction(_WSW_WheelHotkeySetting_Ignore2Hand, Gameplay_ToggleIgnore2Hand_OID)
	endif
EndEvent

function OnOptionSelectAction(GlobalVariable akSettingsGlobal, int aiOID)
	if akSettingsGlobal.GetValueInt() == 2
		akSettingsGlobal.SetValueInt(1)
		SetToggleOptionValue(aiOID, false)
	else
		akSettingsGlobal.SetValueInt(2)
		SetToggleOptionValue(aiOID, true)
	endif
endFunction

event OnOptionKeyMapChange(int option, int keyCode, string conflictControl, string conflictName)
	if keyCode == 264 || keyCode == 265
		ShowMessage("You cannot set the hotkey to mousewheel scroll up or down.", false)
		return
	endif

	bool success
	if option == Gameplay_HotkeyEnableWheelRight_OID
		SetKey(_WSW_WheelHotkeyRight, keyCode, conflictControl, conflictName)
	elseif option == Gameplay_HotkeyEnableWheelLeft_OID
		SetKey(_WSW_WheelHotkeyLeft, keyCode, conflictControl, conflictName)
	endif
endEvent

function SetKey(GlobalVariable akGlobal, int keyCode, string conflictControl, string conflictName)
	if conflictControl != ""
		if conflictName != ""
			bool b = ShowMessage("This key is already bound to " + conflictControl + " in " + conflictName + ". Undesirable behavior may occur; use with caution, or assign to a different control.")
			if b
				akGlobal.SetValueInt(keyCode)
				(PlayerAlias as _WSW_PlayerAlias).RegisterForKey(akGlobal.GetValueInt())
				ForcePageReset()
			endif
		else
			ShowMessage("This key is already bound to " + conflictControl + " in Skyrim. Please select a different key.")
		endif
	else
		akGlobal.SetValueInt(keyCode)
		(PlayerAlias as _WSW_PlayerAlias).RegisterForKey(akGlobal.GetValueInt())
		ForcePageReset()
	endif
endFunction

event OnOptionDefault(int option)
	if option == Gameplay_ToggleFavoritesOnly_OID
		_WSW_WheelHotkeySetting_FavoritesOnly.SetValueInt(1)
		SetToggleOptionValue(Gameplay_ToggleFavoritesOnly_OID, false)
	elseif option == Gameplay_ToggleIgnore2Hand_OID
		_WSW_WheelHotkeySetting_Ignore2Hand.SetValueInt(1)
		SetToggleOptionValue(Gameplay_ToggleIgnore2Hand_OID, false)
	elseif option == Gameplay_HotkeyEnableWheelRight_OID
		_WSW_WheelHotkeyRight.SetValue(0)
		(PlayerAlias as _WSW_PlayerAlias).UnregisterForKey(_WSW_WheelHotkeyRight.GetValueInt())
		ForcePageReset()
	elseif option == Gameplay_HotkeyEnableWheelLeft_OID
		_WSW_WheelHotkeyLeft.SetValue(0)
		(PlayerAlias as _WSW_PlayerAlias).UnregisterForKey(_WSW_WheelHotkeyLeft.GetValueInt())
		ForcePageReset()
	endif
endEvent

string function GetCustomControl(int keyCode)
	if (keyCode == _WSW_WheelHotkeyRight.GetValueInt())
		return "Enable Equipment Scrolling (Right Hand)"
	elseif (keyCode == _WSW_WheelHotkeyLeft.GetValueInt())
		return "Enable Equipment Scrolling (Left Hand)"
	else
		return ""
	endIf
endFunction