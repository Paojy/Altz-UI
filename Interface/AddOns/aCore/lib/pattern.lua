
---------------------------------------------------------------
-------------------[[        media        ]]------------------
---------------------------------------------------------------
local font = GameFontHighlight:GetFont()
local Ccolor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
local aMedia = "Interface\\AddOns\\aCore\\media\\"
local blank = "Interface\\Buttons\\WHITE8x8"

---------------------------------------------------------------
--------------[[     global frame fuctions    ]]---------------
---------------------------------------------------------------

local frame1pxBD = {
    edgeFile = blank, edgeSize = 1,
    bgFile = blank,
    insets = {left = 1, right = 1, top = 1, bottom = 1}
}

local framegrowBD = {
    edgeFile = aMedia.."grow", edgeSize = 3,
    bgFile = blank,
    insets = {left = 3, right = 3, top = 3, bottom = 3}
}

function createpxBD(f, a, ba)
	if f.pxborder then return end
	local border = CreateFrame("Frame", nil ,f)
	border:SetPoint("TOPLEFT", -3, 3)
	border:SetPoint("BOTTOMRIGHT", 3, -3)
    border:SetBackdrop(framegrowBD)
    border:SetBackdropColor(0.05, 0.05, 0.05, a)
    border:SetBackdropBorderColor(0, 0, 0, ba)
	if f:GetFrameLevel() - 1 >= 0 then
		border:SetFrameLevel(f:GetFrameLevel() - 1)
	else
		border:SetFrameLevel(0)
	end
	f.pxborder = border
end

function creategrowBD(f, r, g, b, a, ba)
	if f.border then return end
	local border = CreateFrame("Frame", nil ,f)
	border:SetPoint("TOPLEFT", -3, 3)
	border:SetPoint("BOTTOMRIGHT", 3, -3)
    border:SetBackdrop(framegrowBD)
    border:SetBackdropColor(r, g, b, a)
    border:SetBackdropBorderColor(0, 0, 0, ba)
	if f:GetFrameLevel() - 1 >= 0 then
		border:SetFrameLevel(f:GetFrameLevel() - 1)
	else
		border:SetFrameLevel(0)
	end
	f.border = border
end

function createnameplateBD(f, r, g, b, a, ba, anchor)
    if not anchor then anchor = f end
	local border = CreateFrame("Frame", nil ,f)
	border:SetPoint("TOPLEFT", anchor, "TOPLEFT", -4, 4)
	border:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", 4, -4)
    border:SetBackdrop(framegrowBD)
    border:SetBackdropColor(r, g, b, a)
    border:SetBackdropBorderColor(0, 0, 0, ba)
	if f:GetFrameLevel() - 1 >= 0 then
		border:SetFrameLevel(f:GetFrameLevel() - 1)
	else
		border:SetFrameLevel(0)
	end
end

function createtipBD(tip)
    tip:SetBackdrop(framegrowBD)
	tip.border = true
end

function creategradient(f, r, g, b, n, a)
	local gradient = f:CreateTexture(nil, "BACKGROUND")
	gradient:SetPoint("TOPLEFT")
	gradient:SetPoint("BOTTOMRIGHT")
	gradient:SetTexture(blank)
	gradient:SetGradientAlpha("VERTICAL",  r, g, b, a, r/n, g/n, b/n, a)
end

function createbargradient(bar, r, g, b, n)
	bar:SetStatusBarTexture(blank)
	bar:GetStatusBarTexture():SetGradient("VERTICAL",  r, g, b, r/n, g/n, b/n)
end

function createtex(f, texpath, blend)
	local tex = f:CreateTexture(nil, "OVERLAY")
	tex:SetAllPoints()
	tex:SetTexture(texpath)
	if blend then
		tex:SetBlendMode(blend)
	end
	return tex
end

function createtext(f, fontsize, flag, center)
	local text = f:CreateFontString(nil, "OVERLAY")
	text:SetFont(font, fontsize, flag)
	text:SetJustifyH("CENTER")
	if center then
	text:SetAllPoints()
	end
	return text
end

-- fadeout and hide
local function FandH(f, t)
if InCombatLockdown() then return end
local fadeInfo1 = {}
		fadeInfo1.mode = "OUT"
		fadeInfo1.timeToFade = t
		fadeInfo1.finishedFunc = function() f:Hide() end	--隐藏
		fadeInfo1.startAlpha = f:GetAlpha()
		fadeInfo1.endAlpha = 0
UIFrameFade(f, fadeInfo1)
end