
-- local T, C, L, G = unpack(select(2, ...))

local addon, ns = ...
ns[1] = {} -- T, functions, constants, variables
ns[2] = {} -- C, config
ns[3] = {} -- L, localization
ns[4] = {} -- G, globals (Optionnal)

local T, C, L, G = unpack(select(2, ...))

G.uiname = "AltzUI_"

G.norFont = "Interface\\AddOns\\AltzUI\\media\\font.ttf"
G.numFont = "Interface\\AddOns\\AltzUI\\media\\number.ttf"

G.combatFont = {}
for i = 1, 3 do
	G.combatFont["combat"..i] = "Interface\\AddOns\\AltzUI\\media\\combat"..i..".ttf"
end

G.media = {
	blank = "Interface\\Buttons\\WHITE8x8",
	bar = "Interface\\AddOns\\AltzUI\\media\\statusbar",
	glow = "Interface\\AddOns\\AltzUI\\media\\glow",
	checked = "Interface\\AddOns\\AltzUI\\media\\CheckButtonHilight",
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

G.Discord = "discord.gg/bt2jQ7kPBd"
G.Nga = "bbs.nga.cn/read.php?tid=4729675&_ff=200"
G.WoWInterface = "www.wowinterface.com/downloads/info21263-AltzUIforShadowlands.html"
