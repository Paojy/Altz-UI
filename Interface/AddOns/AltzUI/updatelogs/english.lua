local T, C, L, G = unpack(select(2, ...))
if G.Client == "zhCN" or G.Client == "zhTW" then return end

L["UpdateLogs"] = {
[[11.18
Show the concentration value statistics of the professions in the Warbands.
Alliance The MOTHERLODE!! teleportation button correction.
Add Cvar option to only displays the name on friendly nameplates in instance.
Improvement of the raid frame healing indicators.
Improvement of the raid frame Click-casting spell options.
Aurora update.
Other error corrections.
]],

[[11.17
The group finder updates the S2 mythic+ filtering button.
Update S2 score information and portal button on the mythic+ interface.
]],

[[11.16
Add filtering buttons to the LFG list.
Automatically purchase goods without buying items that require other currencies.
The totem bar displays it's tooltip.
Correction of major reputation monitoring errors.
Close the equipment list when viewing the reputation of the character frame.
The Raid frames refreshes health when hovering over the mouse.
The Raid frames healer indicators updates (Holy Paladin, Mistweaver Monk, Augmentation Evoker).
Add some spell options for click casting to the Raid frames.
]],

[[11.15
Add Preservation Evoker talent Golden Hour heal prediction bar on raid frames(requires manual enable).
The Preservation Evoker raid frames heal indicators (numbers/symbols) are complete.
GUI options display error correction.
Raid frames overlap error correction.
]],

[[11.14
When the countdown button for pull is clicked again, the countdown can be canceled.
New item not separately classified error corrected.
GUI Add Update Log Page.]],

[[11.13
Raid frames click casting and aura filter spell data correction, cleaning expired spells.
Appearance adjustment of the Mythic+ interface, correction of misalignment of the portal button.
Error correction for automatic invitation of monitoring keywords into groups.
Error correction for automatically accepting friend invitations.
Correction of the error where the input box does not display when player names are clicked in the chat box.
Unit offline health color display error correction.
The player's unit frame add essence of Evokers.
Add rank display in the cast bar.
Add the option to the display buff/debuff icons' duration text.(GUI - Others)
Add the option to display/hide the player's debuff icon on the unitframe (GUI - Unit Frame - Aura)]],
}