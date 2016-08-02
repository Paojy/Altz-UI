
-- local T, C, L, G = unpack(select(2, ...))

local addon, ns = ...
ns[1] = {} -- T, functions, constants, variables
ns[2] = {} -- C, config
ns[3] = {} -- L, localization
ns[4] = {} -- G, globals (Optionnal)

local T, C, L, G = unpack(select(2, ...))

G.uiname = "AltzUI_"

G.norFont = GameFontHighlight:GetFont()
G.numFont = "Interface\\AddOns\\AltzUI\\media\\number.ttf"

G.media = {
	blank = "Interface\\Buttons\\WHITE8x8",
	bar = "Interface\\AddOns\\AltzUI\\media\\statusbar",
	glow = "Interface\\AddOns\\Aurora\\media\\glow",
	checked = "Interface\\AddOns\\Aurora\\media\\CheckButtonHilight",
	left = "Interface\\AddOns\\AltzUI\\media\\left",
	right = "Interface\\AddOns\\AltzUI\\media\\right",
}

G.Iconpath = "Interface\\AddOns\\AltzUI\\media\\icons\\"

G.Version = GetAddOnMetadata("AltzUIConfig", "Version")
G.Client = GetLocale()

G.resolution = GetCVar("gxFullscreenResolution")
G.screenheight = tonumber(string.match(G.resolution, "%d+x(%d+)"))
G.screenwidth = tonumber(string.match(G.resolution, "(%d+)x+%d"))

G.myClass = select(2, UnitClass("player"))

G.Ccolor = {}
if(IsAddOnLoaded'!ClassColors' and CUSTOM_CLASS_COLORS) then
	G.Ccolor = CUSTOM_CLASS_COLORS[select(2, UnitClass("player"))]
else
	G.Ccolor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
end

G.Ccolors = {}
if(IsAddOnLoaded'!ClassColors' and CUSTOM_CLASS_COLORS) then
	G.Ccolors = CUSTOM_CLASS_COLORS
else
	G.Ccolors = RAID_CLASS_COLORS
end

G.classcolor = ('|cff%02x%02x%02x'):format(G.Ccolor.r * 255, G.Ccolor.g * 255, G.Ccolor.b * 255)

G.ClassInfo = {}

for i = 1, GetNumClasses() do
	local classDisplayName, classTag, classID = GetClassInfo(i)
	local color = G.Ccolors[classTag]
	G.ClassInfo[classTag] =  ('|cff%02x%02x%02x'..classDisplayName.."|r"):format(color.r * 255, color.g * 255, color.b * 255)
end