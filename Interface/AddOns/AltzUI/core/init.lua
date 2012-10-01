
-- local T, C, L, G = unpack(select(2, ...))

local addon, ns = ...
ns[1] = {} -- T, functions, constants, variables
ns[2] = {} -- C, config
ns[3] = {} -- L, localization
ns[4] = {} -- G, globals (Optionnal)

--[[--------------
--     init     --
--------------]]--

local T, C, L, G = unpack(select(2, ...))

G.dragFrameList = {}

G.norFont = GameFontHighlight:GetFont()
G.numFont = "Interface\\AddOns\\AltzUI\\media\\number.ttf"

G.Client = GetLocale()
G.Version = GetAddOnMetadata("AltzUIConfig", "Version")

G.resolution = GetCVar("gxResolution")
G.screenheight = tonumber(string.match(G.resolution, "%d+x(%d+)"))
G.screenwidth = tonumber(string.match(G.resolution, "(%d+)x+%d"))

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