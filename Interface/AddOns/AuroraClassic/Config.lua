local _, ns = ...
local B, C, L, DB = unpack(ns)

-- Default settings
C.options = {
	Alpha = .5,
	Bags = true,
	FlatMode = false,
	ChatBubbles = true,
	FontOutline = true,
	FontScale = 1,
	Loot = true,
	Tooltips = true,
	Shadow = true,
	ObjectiveTracker = true,
	UIScale = 0,
}

C.defaultThemes = {}
C.themes = {}

-- Data
DB.isNewPatch = select(4, GetBuildInfo()) >= 100007 -- 10.0.7
DB.isPatch10_1 = select(4, GetBuildInfo()) >= 100100 -- 10.1.0
DB.MyClass = select(2, UnitClass("player"))
DB.ClassColors = {}

local colors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
for class, value in pairs(colors) do
	DB.ClassColors[class] = {}
	DB.ClassColors[class].r = value.r
	DB.ClassColors[class].g = value.g
	DB.ClassColors[class].b = value.b
	DB.ClassColors[class].colorStr = value.colorStr
end
DB.r = DB.ClassColors[DB.MyClass].r
DB.g = DB.ClassColors[DB.MyClass].g
DB.b = DB.ClassColors[DB.MyClass].b

DB.QualityColors = {}
local qualityColors = BAG_ITEM_QUALITY_COLORS
for index, value in pairs(qualityColors) do
	DB.QualityColors[index] = {r = value.r, g = value.g, b = value.b}
end
DB.QualityColors[-1] = {r = 0, g = 0, b = 0}
DB.QualityColors[Enum.ItemQuality.Poor] = {r = COMMON_GRAY_COLOR.r, g = COMMON_GRAY_COLOR.g, b = COMMON_GRAY_COLOR.b}
DB.QualityColors[Enum.ItemQuality.Common] = {r = 0, g = 0, b = 0}
DB.QualityColors[99] = {r = 1, g = 0, b = 0}

-- Media
local mediaPath = "Interface\\AddOns\\AuroraClassic\\media\\"
DB.bdTex = "Interface\\ChatFrame\\ChatFrameBackground"
DB.glowTex = mediaPath.."glowTex"
DB.normTex = mediaPath.."normTex"
DB.bgTex = mediaPath.."bgTex"
DB.pushedTex = mediaPath.."pushed"
DB.ArrowUp = mediaPath.."arrow"
DB.closeTex = mediaPath.."close"
DB.rolesTex = mediaPath.."RoleIcons"
DB.tankTex = mediaPath.."Tank"
DB.healTex = mediaPath.."Healer"
DB.dpsTex = mediaPath.."DPS"
DB.sparkTex = "Interface\\CastingBar\\UI-CastingBar-Spark"
DB.TexCoord = {.08, .92, .08, .92}
DB.Font = {STANDARD_TEXT_FONT, 12, "OUTLINE"}