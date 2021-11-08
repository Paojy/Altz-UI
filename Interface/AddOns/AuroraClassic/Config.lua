local _, ns = ...
local F, C, L = unpack(ns)

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

-- Media
local mediaPath = "Interface\\AddOns\\AuroraClassic\\media\\"

C.bgTex = mediaPath.."bgTex"
C.pushed = mediaPath.."pushed"
C.ArrowUp = mediaPath.."arrow"
C.closeTex = mediaPath.."close"
C.normTex = mediaPath.."normTex"
C.glowTex = mediaPath.."glowTex"
C.rolesTex = mediaPath.."RoleIcons"
C.bdTex = "Interface\\ChatFrame\\ChatFrameBackground"
C.sparkTex = "Interface\\CastingBar\\UI-CastingBar-Spark"
C.TexCoord = {.08, .92, .08, .92}
C.Font = {STANDARD_TEXT_FONT, 12, "OUTLINE"}

C.defaultThemes = {}
C.themes = {}
C.isNewPatch = select(4, GetBuildInfo()) >= 90105 -- 9.1.5
C.MyClass = select(2, UnitClass("player"))
C.ClassColors = {}

local colors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
for class, value in pairs(colors) do
	C.ClassColors[class] = {}
	C.ClassColors[class].r = value.r
	C.ClassColors[class].g = value.g
	C.ClassColors[class].b = value.b
	C.ClassColors[class].colorStr = value.colorStr
end
C.r = C.ClassColors[C.MyClass].r
C.g = C.ClassColors[C.MyClass].g
C.b = C.ClassColors[C.MyClass].b

-- Replace default contants
LE_ITEM_QUALITY_POOR = Enum.ItemQuality.Poor
LE_ITEM_QUALITY_COMMON = Enum.ItemQuality.Common
LE_ITEM_QUALITY_UNCOMMON = Enum.ItemQuality.Uncommon
LE_ITEM_QUALITY_RARE = Enum.ItemQuality.Rare
LE_ITEM_QUALITY_EPIC = Enum.ItemQuality.Epic
LE_ITEM_QUALITY_LEGENDARY = Enum.ItemQuality.Legendary
LE_ITEM_QUALITY_ARTIFACT = Enum.ItemQuality.Artifact
LE_ITEM_QUALITY_HEIRLOOM = Enum.ItemQuality.Heirloom

C.QualityColors = {}
local qualityColors = BAG_ITEM_QUALITY_COLORS
for index, value in pairs(qualityColors) do
	C.QualityColors[index] = {r = value.r, g = value.g, b = value.b}
end
C.QualityColors[-1] = {r = 0, g = 0, b = 0}
C.QualityColors[LE_ITEM_QUALITY_POOR] = {r = .61, g = .61, b = .61}
C.QualityColors[LE_ITEM_QUALITY_COMMON] = {r = 0, g = 0, b = 0}
C.QualityColors[99] = {r = 1, g = 0, b = 0}

NORMAL_QUEST_DISPLAY = gsub(NORMAL_QUEST_DISPLAY, "000000", "ffffff")
TRIVIAL_QUEST_DISPLAY = gsub(TRIVIAL_QUEST_DISPLAY, "000000", "ffffff")
IGNORED_QUEST_DISPLAY = gsub(IGNORED_QUEST_DISPLAY, "000000", "ffffff")