# ScrollWheelEquip

## DESCRIPTION

**Scroll Wheel Equip** is a first person shooter-style weapon and equipment switching mod, allowing you to scroll through available gear using your mouse's scroll wheel. It was inspired by a post by /u/blastmafia on the /r/skyrimmods subreddit.


## INSTALL

Use a mod manager. **DO NOT** UNPACK THE BSA ARCHIVE. If you choose to not follow either of these instructions, I will not help you.


## REQUIREMENTS

SkyUI 4.1+ and SKSE 1.7.3+ required. SkyUI-Away is OK.


## HOW TO USE

Open the Mod Configuration Menu and set a hotkey for Enable Equipment Scrolling for the left or right hands (or both). When holding this hotkey, you can use your mouse scroll wheel to quickly switch between your weapons (including unarmed / fists) and magic staves in your inventory.

When scrolling while using the left hand hotkey, you will also switch between available shields, and a torch, if you have one.

You can limit the gear that is switched to when scrolling by enabling "Favorites Only" in the MCM. Only equipment that has been favorited will be switched to.

Two-handed weapons and bows can sometimes cause undesirable behavior (unequipping your off-hand weapon, etc) when scrolling through your gear. If you don't need access to a bow or two-handed weapon, select "Ignore Two-Handed Weapons & Bows" in the MCM. This should prevent things being unexpectedly unequipped from your off-hand.

When holding one of the hotkeys, your camera 1st / 3rd person switch controls will be temporarily disabled. When you release the hotkey, normal camera switch controls will be re-enabled. The hotkey does not prevent camera zooming if you are already in 3rd person view. The intended audience of this mod are players that play primarily in 1st person mode.


## COMPATIBILITY

**Wearable Lanterns**: If you use the Carried option, it is suggested that you disable "Automatically Drop Lit Lanterns" to prevent dropping your lantern when scrolling the left hand.
**Mods that add their own carried lights / torches**: These light items won't be detected and won't be switched to when scrolling the left hand. Only vanilla torches are supported.

Otherwise, the answer is "yes, it's compatible". If you find something that isn't, please report it.


## TROUBLESHOOTING

*"I pressed the hotkey and started scrolling, but my camera zoomed out anyway."*

Press and hold the hotkey down for a moment or two before starting to scroll. You'll need to get a feel for the timing. Play with it for a bit.

*"I pressed the hotkey and started scrolling, but nothing happened / the weapons switch really slowly or in a delayed way."*

How well this mod performs is highly dependent on how well the game's scripting subsystem is performing, and your framerate. If you have a few mods that are trashing the scripting system and clogging everything up, this mod will be prevented from working. This mod uses fairly simple scripting that only runs when you scroll your scroll wheel, or when picking up / dropping things that the mod cares about. It is "dormant" at all other times.

*"I entered the game and the MCM never showed up."*

It can take some time for SkyUI to pick up and register new menus. Give it at least a few minutes.

*"I entered the game and the MCM never showed up, even after waiting."*

Make sure you followed the installation instructions. This is a fairly simple mod; if nothing shows up when you start even after giving things a chance to register, you made an installation mistake and must resolve it. This isn't a problem with the mod itself.


## FAQ

*"Can I add my own features to the mod or change it, and then distribute it?"*

This mod is distributed under the MIT license. The MIT license permits you to "use, copy, modify, merge, publish, distribute, sublicense" the "software". You can take this mod and change it and reupload it without any permission from me, for any reason. Please see ScrollWheelEquip_license.txt for more information. You should read the license and understand it, as it is not without some restriction. The MIT license was meant to be read by ordinary people, unlike other licenses that are very complex.

If it would be useful for your development, you can also fork the existing GitHub repo in order to do your development. It's located here: https://github.com/chesko256/ScrollWheelEquip

*"Will you make a version that can scroll through my spells?"*

I'm not planning on it right now. See above for feature additions and changes.

*"Will you make it so that scrolling up is the left hand / scrolling down is the right hand / make it so that NOT holding the hotkey scrolls / some other very specific alternate control method?"*

No, sorry. What you see is what you get. I consider the mod to be functionally complete. I think it works fairly well and intuitively as it is. See above for feature additions and changes.

*"My favorite mod isn't compatible, for whatever reason. Will you make it compatible?"*

If it's trivial, possibly. If I decide not to do it, you can do it. See above for feature additions and changes.


## CONSOLE SUPPORT

This mod will not be made available for consoles as it relies heavily on features enabled by SKSE in order to function. If I could have created it without relying on SKSE, I would have already done so.


## UNINSTALL

You can uninstall the mod at any time without taking any special steps.
