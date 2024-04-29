
-- local T, C, L, G = unpack(select(2, ...))
local addon, ns = ...
ns[1] = {} -- T, functions, constants, variables
ns[2] = {} -- C, config
ns[3] = {} -- L, localization
ns[4] = {} -- G, globals (Optionnal)

AltzUI = ns

local T, C, L, G = unpack(select(2, ...))

--====================================================--
--[[                 -- Globals --                   ]]--
--====================================================--
G.uiname = "AltzUI_"
G.Client = GetLocale()
G.Version = C_AddOns.GetAddOnMetadata("AltzUI", "Version")

G.PlayerRealm = GetRealmName()
G.PlayerName = UnitName("player")
G.myClass = select(2, UnitClass("player"))

G.links = {
	GitHub = "github.com/Paojy/Altz-UI",
	WoWInterface = "www.wowinterface.com/downloads/info21263-AltzUIforShadowlands.html",
	Curse = "www.curseforge.com/wow/addons",
}
--====================================================--
--[[                  -- Media --                   ]]--
--====================================================--
G.norFont = "Interface\\AddOns\\AltzUI\\media\\font.ttf"
G.numFont = "Interface\\AddOns\\AltzUI\\media\\number.ttf"
G.symbols = "Interface\\Addons\\AltzUI\\media\\PIZZADUDEBULLETS.ttf"
G.plateFont = "Interface\\AddOns\\AltzUI\\media\\Infinity Gears.ttf"
G.combatFont1 = "Interface\\AddOns\\AltzUI\\media\\combat1.ttf"
G.combatFont2 = "Interface\\AddOns\\AltzUI\\media\\combat2.ttf"
G.combatFont3 = "Interface\\AddOns\\AltzUI\\media\\combat3.ttf"

G.media = {
	blank = "Interface\\Buttons\\WHITE8x8",
	ufbar = "Interface\\AddOns\\AltzUI\\media\\ufbar",
	glow = "Interface\\AddOns\\AltzUI\\media\\glow",
}

local LSM = LibStub("LibSharedMedia-3.0")

LSM.MediaTable.font["AltzUI"]							= [[Interface\AddOns\AltzUI\media\font.ttf]]
LSM.MediaTable.font["AltzUI_number"]					= [[Interface\AddOns\AltzUI\media\number.ttf]]
LSM.MediaTable.border["AltzUI_glow"]					= [[Interface\AddOns\AltzUI\media\glow]]
LSM.MediaTable.statusbar["AltzUI_bar"]					= [[Interface\AddOns\AltzUI\media\statusbar]]
LSM.MediaTable.statusbar["AltzUI_ufbar"]				= [[Interface\AddOns\AltzUI\media\ufbar]]

--====================================================--
--[[                  -- Color --                   ]]--
--====================================================--
G.ClassColors = {}
if IsAddOnLoaded'!ClassColors' and CUSTOM_CLASS_COLORS then
	G.ClassColors = CUSTOM_CLASS_COLORS
else
	G.ClassColors = RAID_CLASS_COLORS
end

G.addon_color = {G.ClassColors[G.myClass].r, G.ClassColors[G.myClass].g, G.ClassColors[G.myClass].b}
G.addon_colorStr = "|c"..G.ClassColors[G.myClass].colorStr

--====================================================--
--[[                -- Callbacks --                 ]]--
--====================================================--
G.Init_callbacks = {}
T.RegisterInitCallback = function(func)
	table.insert(G.Init_callbacks, func)
end

G.EnteringWorld_callbacks = {}
T.RegisterEnteringWorldCallback = function(func)
	table.insert(G.EnteringWorld_callbacks, func)
end