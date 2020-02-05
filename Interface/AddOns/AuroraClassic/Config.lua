local _, ns = ...
local F, C, L = unpack(ns)

-- Media
local mediaPath = "Interface\\AddOns\\AuroraClassic\\media\\"

C.media = {
	font = mediaPath.."font.ttf",
	bgTex = mediaPath.."bgTex",
	glowTex = mediaPath.."glowTex",
	gradient = mediaPath.."gradient",
	checked = mediaPath.."CheckButtonHilight",
	roleIcons = mediaPath.."UI-LFG-ICON-ROLES",
	arrowUp = mediaPath.."arrow-up-active",
	arrowDown = mediaPath.."arrow-down-active",
	arrowLeft = mediaPath.."arrow-left-active",
	arrowRight = mediaPath.."arrow-right-active",
	backdrop = "Interface\\ChatFrame\\ChatFrameBackground",
}

C.options = {
	Alpha = .5,
	Bags = false,
	FlatMode = false,
	FlatColor = {.2, .2, .2, .6},
	GradientColor = {.3, .3, .3, .3},
	ChatBubbles = true,
	FontOutline = true,
	FontScale = 1,
	Loot = true,
	UseCustomColor = false,
	CustomColor = {r = 1, g = 1, b = 1},
	Tooltips = false,
	Shadow = true,
	ObjectiveTracker = true,
	UIScale = 0,
}

C.frames = {}
C.themes = {}
C.themes["AuroraClassic"] = {}
C.isNewPatch = GetBuildInfo() == "8.3.0" -- keep it for future purpose
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
BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_POOR] = {r = .61, g = .61, b = .61}
BAG_ITEM_QUALITY_COLORS[-1] = {r = 0, g = 0, b = 0}
BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_COMMON] = {r = 0, g = 0, b = 0}

NORMAL_QUEST_DISPLAY = gsub(NORMAL_QUEST_DISPLAY, "000000", "ffffff")
TRIVIAL_QUEST_DISPLAY = gsub(TRIVIAL_QUEST_DISPLAY, "000000", "ffffff")
IGNORED_QUEST_DISPLAY = gsub(IGNORED_QUEST_DISPLAY, "000000", "ffffff")