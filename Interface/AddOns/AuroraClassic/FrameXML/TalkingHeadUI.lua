local _, ns = ...
local B, C, L, DB = unpack(ns)

tinsert(C.defaultThemes, function()
	local TalkingHeadFrame = TalkingHeadFrame
	TalkingHeadFrame:SetScale(.9)

	local portraitFrame = TalkingHeadFrame.PortraitFrame
	B.StripTextures(portraitFrame)
	portraitFrame.Portrait:SetAtlas(nil)
	portraitFrame.Portrait.SetAtlas = B.Dummy

	local model = TalkingHeadFrame.MainFrame.Model
	model:SetPoint("TOPLEFT", 30, -27)
	model:SetSize(100, 100)
	model.PortraitBg:SetAtlas(nil)
	model.PortraitBg.SetAtlas = B.Dummy

	local name = TalkingHeadFrame.NameFrame.Name
	name:SetTextColor(1, .8, 0)
	name.SetTextColor = B.Dummy
	name:SetShadowColor(0, 0, 0, 0)

	local text = TalkingHeadFrame.TextFrame.Text
	text:SetTextColor(1, 1, 1)
	text.SetTextColor = B.Dummy
	text:SetShadowColor(0, 0, 0, 0)

	B.ReskinClose(TalkingHeadFrame.MainFrame.CloseButton, nil, -25, -25)
end)