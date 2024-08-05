
-- local T, C, L, G = unpack(select(2, ...))
local addon, ns = ...
ns[1] = {} -- T, functions, constants, variables
ns[2] = {} -- C, config
ns[3] = {} -- L, localization
ns[4] = {} -- G, globals (Optionnal)

AltzUI = ns

local T, C, L, G = unpack(select(2, ...))

--====================================================--
--[[                 -- Globals --                  ]]--
--====================================================--
G.uiname = "AltzUI_"
G.Client = GetLocale()
G.Version = C_AddOns.GetAddOnMetadata("AltzUI", "Version")

G.PlayerRealm = GetRealmName()
G.PlayerName = UnitName("player")
G.myClass = select(2, UnitClass("player"))

G.links = {
	GitHub = "github.com/Paojy/Altz-UI",
	WoWInterface = "www.wowinterface.com/downloads/info21263-AltzUI",
	Curse = "www.curseforge.com/wow/addons/altzui",
}
--====================================================--
--[[                  -- Media --                   ]]--
--====================================================--
G.fontFile = [[Interface\AddOns\AltzUI\media\fonts\]]
G.textureFile = [[Interface\AddOns\AltzUI\media\]]
G.iconFile = [[Interface\AddOns\AltzUI\media\icons\]]

G.norFont = G.fontFile.."font.ttf"
G.numFont = G.fontFile.."number.ttf"
G.symbols = G.fontFile.."PIZZADUDEBULLETS.ttf"
G.plateFont = G.fontFile.."Infinity Gears.ttf"
G.combatFont1 = G.fontFile.."combat1.ttf"
G.combatFont2 = G.fontFile.."combat2.ttf"
G.combatFont3 = G.fontFile.."combat3.ttf"

G.media = {
	addon_icon = G.iconFile.."addon_icon.png",
	blank = [[Interface\Buttons\WHITE8x8]],
	glow = G.textureFile.."glow",
	statusbar = G.textureFile.."statusbar",
	ufbar = G.textureFile.."ufbar",	
}

local LSM = LibStub("LibSharedMedia-3.0")

LSM.MediaTable.font["AltzUI"]							= G.norFont
LSM.MediaTable.font["AltzUI_number"]					= G.numFont
LSM.MediaTable.border["AltzUI_glow"]					= G.media.glow
LSM.MediaTable.statusbar["AltzUI_bar"]					= G.media.statusbar
LSM.MediaTable.statusbar["AltzUI_ufbar"]				= G.media.ufbar

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


-- TO DO LIST

-- 技能书拖动