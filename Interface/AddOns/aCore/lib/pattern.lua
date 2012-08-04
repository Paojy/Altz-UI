
---------------------------------------------------------------
-------------------[[        media        ]]------------------
---------------------------------------------------------------
local font = GameFontHighlight:GetFont()
local Ccolor = GetClassColor()
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
	border:SetPoint("TOPLEFT", -1, 1)
	border:SetPoint("BOTTOMRIGHT", 1, -1)
    border:SetBackdrop(frame1pxBD)
    border:SetBackdropColor(0.05, 0.05, 0.05, a)
    border:SetBackdropBorderColor(0, 0, 0, ba)
	if f:GetFrameLevel() - 1 >= 0 then
		border:SetFrameLevel(f:GetFrameLevel() - 1)
	else
		border:SetFrameLevel(0)
	end
	f.pxborder = border
end

function createskinpxBD(f)
	if f.skinpxborder == true then return end
	local border = CreateFrame("Frame", nil ,f)
	border:SetPoint("TOPLEFT", -1, 1)
	border:SetPoint("BOTTOMRIGHT", 1, -1)
    border:SetBackdrop(frame1pxBD)
    border:SetBackdropColor(0, 0, 0, 0)
    border:SetBackdropBorderColor(0, 0, 0, 1)
	if f:GetFrameLevel() - 1 >= 0 then
		border:SetFrameLevel(f:GetFrameLevel() - 1)
	else
		border:SetFrameLevel(0)
	end
	f.skinpxborder = true
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

function createskingrowBD(f)
	if f.skinborder == true then return end
	local border = CreateFrame("Frame", nil ,f)
	border:SetPoint("TOPLEFT", -3, 3)
	border:SetPoint("BOTTOMRIGHT", 3, -3)
    border:SetBackdrop(framegrowBD)
    border:SetBackdropColor(0, 0, 0, 0.7)
    border:SetBackdropBorderColor(0, 0, 0, 1)
	if f:GetFrameLevel() - 1 >= 0 then
		border:SetFrameLevel(f:GetFrameLevel() - 1)
	else
		border:SetFrameLevel(0)
	end
	f.skinborder = true
end

function createnameplateBD(f, r, g, b, a, ba, anchor)
    if not anchor then anchor = f end
	local border = CreateFrame("Frame", nil ,f)
	border:SetPoint("TOPLEFT", anchor, "TOPLEFT", -4, 4)
	border:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", 4, -4)
    border:SetBackdrop(framegrowBD)
    border:SetBackdropColor(r, g, b, a)
    border:SetBackdropBorderColor(0, 0, 0, ba)
	local pxbd = CreateFrame("Frame", nil ,f)
	pxbd:SetPoint("TOPLEFT", anchor, "TOPLEFT", -1, 1)
	pxbd:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", 1, -1)
    pxbd:SetBackdrop(frame1pxBD)
    pxbd:SetBackdropColor(0, 0, 0, 1)
    pxbd:SetBackdropBorderColor(0, 0, 0, ba)
	if f:GetFrameLevel() - 1 >= 0 then
		border:SetFrameLevel(f:GetFrameLevel() - 1)
		pxbd:SetFrameLevel(f:GetFrameLevel() - 1)
	else
		border:SetFrameLevel(0)
		pxbd:SetFrameLevel(0)
	end
end

function createtipBD(tip)
    tip:SetBackdrop(framegrowBD)
	tip.border = true
end

function createdbmBD(f)
	if f.dbmborder then return end
	local border = CreateFrame("Frame", nil ,f)
	border:SetPoint("TOPLEFT", -1, 1)
	border:SetPoint("BOTTOMRIGHT", 1, -1)
    border:SetBackdrop(framegrowBD)
    border:SetBackdropColor(0, 0, 0, 0.5)
    border:SetBackdropBorderColor(0, 0, 0, 1)
	if f:GetFrameLevel() - 1 >= 0 then
		border:SetFrameLevel(f:GetFrameLevel() - 1)
	else
		border:SetFrameLevel(0)
	end
	f.dbmborder = border
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