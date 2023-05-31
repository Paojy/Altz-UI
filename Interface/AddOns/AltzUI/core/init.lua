
-- local T, C, L, G = unpack(select(2, ...))
local addon, ns = ...
ns[1] = {} -- T, functions, constants, variables
ns[2] = {} -- C, config
ns[3] = {} -- L, localization
ns[4] = {} -- G, globals (Optionnal)

AltzUI = ns
--[[--------------
-- init --
--------------]]--

local T, C, L, G = unpack(select(2, ...))

G.uiname = "AltzUI_"

G.dragFrameList = {}

G.norFont = "Interface\\AddOns\\AltzUI\\media\\font.ttf"
G.numFont = "Interface\\AddOns\\AltzUI\\media\\number.ttf"
G.symbols = "Interface\\Addons\\AltzUI\\media\\PIZZADUDEBULLETS.ttf"
G.plateFont = "Interface\\AddOns\\AltzUI\\media\\Infinity Gears.ttf"

G.combatFont = {}
for i = 1, 3 do
	G.combatFont["combat"..i] = "Interface\\AddOns\\AltzUI\\media\\combat"..i..".ttf"
end

G.media = {
	blank = "Interface\\Buttons\\WHITE8x8",
	bar = "Interface\\AddOns\\AltzUI\\media\\statusbar",
	ufbar = "Interface\\AddOns\\AltzUI\\media\\ufbar",
	glow = "Interface\\AddOns\\AltzUI\\media\\glow",
	checked = "Interface\\AddOns\\AltzUI\\media\\CheckButtonHilight",
	barhightlight = "Interface\\AddOns\\AltzUI\\media\\highlight",
	buttonhighlight = "Interface\\AddOns\\AltzUI\\media\\highlight2",
	reseting = "Interface\\AddOns\\AltzUI\\media\\resting",
	combat = "Interface\\AddOns\\AltzUI\\media\\combat",
	iconcastbar = "Interface\\AddOns\\AltzUI\\media\\dM3",
}

local LSM = LibStub("LibSharedMedia-3.0")

LSM.MediaTable.font["AltzUI"]							= [[Interface\AddOns\AltzUI\media\font.ttf]]
LSM.MediaTable.font["AltzUI_number"]					= [[Interface\AddOns\AltzUI\media\number.ttf]]
LSM.MediaTable.border["AltzUI_glow"]					= [[Interface\AddOns\AltzUI\media\glow]]
LSM.MediaTable.statusbar["AltzUI_bar"]					= [[Interface\AddOns\AltzUI\media\statusbar]]
LSM.MediaTable.statusbar["AltzUI_ufbar"]				= [[Interface\AddOns\AltzUI\media\ufbar]]

G.Iconpath = "Interface\\AddOns\\AltzUI\\media\\icons\\"

G.Client = GetLocale()
G.Version = C_AddOns.GetAddOnMetadata("AltzUIConfig", "Version")

G.PlayerRealm = GetRealmName()
G.PlayerName = UnitName("player");

local width, height = GetPhysicalScreenSize();
local renderScale = GetCVar("RenderScale")
G.screenheight = tonumber(math.floor(height * renderScale))
G.screenwidth = tonumber(math.floor(width * renderScale))

G.myClass = select(2, UnitClass("player"))

G.Ccolor = {}
if(IsAddOnLoaded'!ClassColors' and CUSTOM_CLASS_COLORS) then
	G.Ccolor = CUSTOM_CLASS_COLORS[G.myClass]
else
	G.Ccolor = RAID_CLASS_COLORS[G.myClass]
end

G.Ccolors = {}
if(IsAddOnLoaded'!ClassColors' and CUSTOM_CLASS_COLORS) then
	G.Ccolors = CUSTOM_CLASS_COLORS
else
	G.Ccolors = RAID_CLASS_COLORS
end

G.classcolor = ('|cff%02x%02x%02x'):format(G.Ccolor.r * 255, G.Ccolor.g * 255, G.Ccolor.b * 255)

BACKDROP_ALTZ_3 = {
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\AddOns\\AltzUI\\media\\glow",
	edgeSize = 3,
	insets = { left = 3, right = 3, top = 3, bottom = 3 },
}

BACKDROP_ALTZ_COLOR_0	= CreateColor(0, 0, 0, 1)
BACKDROP_ALTZ_COLOR_15	= CreateColor(.15, .15, .15, 1)


