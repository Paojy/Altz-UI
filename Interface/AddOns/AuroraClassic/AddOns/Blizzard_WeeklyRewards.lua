local _, ns = ...
local F, C = unpack(ns)
local r, g, b = C.r, C.g, C.b

-- /run UIParent_OnEvent({}, "WEEKLY_REWARDS_SHOW")

local function updateSelection(frame)
	if not frame.bg then return end

	if frame.SelectedTexture:IsShown() then
		frame.bg:SetBackdropBorderColor(1, .8, 0)
	else
		frame.bg:SetBackdropBorderColor(0, 0, 0)
	end
end

local iconColor = C.QualityColors[LE_ITEM_QUALITY_EPIC or 4] -- epic color only
local function reskinRewardIcon(itemFrame)
	if not itemFrame.bg then
		itemFrame:DisableDrawLayer("BORDER")
		itemFrame.Icon:SetPoint("LEFT", 6, 0)
		itemFrame.bg = F.ReskinIcon(itemFrame.Icon)
		itemFrame.bg:SetBackdropBorderColor(iconColor.r, iconColor.g, iconColor.b)
		F.CreateBDFrame(itemFrame, .25)
	end
end

local function ReskinActivityFrame(frame, isObject)
	if frame.Border then
		if isObject then
			frame.Border:SetAlpha(0)
			frame.SelectedTexture:SetAlpha(0)
			frame.LockIcon:SetVertexColor(r, g, b)
			hooksecurefunc(frame, "SetSelectionState", updateSelection)
			hooksecurefunc(frame.ItemFrame, "SetDisplayedItem", reskinRewardIcon)
		else
			frame.Border:SetTexCoord(.926, 1, 0, 1)
			frame.Border:SetSize(25, 137)
			frame.Border:SetPoint("LEFT", frame, "RIGHT", 3, 0)
		end
	end

	if frame.Background then
		frame.bg = F.CreateBDFrame(frame.Background, 1)
	end
end

C.themes["Blizzard_WeeklyRewards"] = function()
	local WeeklyRewardsFrame = WeeklyRewardsFrame

	F.StripTextures(WeeklyRewardsFrame)
	F.SetBD(WeeklyRewardsFrame)
	F.ReskinClose(WeeklyRewardsFrame.CloseButton)
	F.StripTextures(WeeklyRewardsFrame.SelectRewardButton)
	F.Reskin(WeeklyRewardsFrame.SelectRewardButton)

	local headerFrame = WeeklyRewardsFrame.HeaderFrame
	F.StripTextures(headerFrame)
	F.CreateBDFrame(headerFrame, .25)
	headerFrame:SetPoint("TOP", 1, -42)
	headerFrame.Text:SetFontObject(SystemFont_Huge1)

	ReskinActivityFrame(WeeklyRewardsFrame.RaidFrame)
	ReskinActivityFrame(WeeklyRewardsFrame.MythicFrame)
	ReskinActivityFrame(WeeklyRewardsFrame.PVPFrame)

	for _, frame in pairs(WeeklyRewardsFrame.Activities) do
		ReskinActivityFrame(frame, true)
	end

	hooksecurefunc(WeeklyRewardsFrame, "SelectReward", function(self)
		local confirmSelectionFrame = self.confirmSelectionFrame
		if confirmSelectionFrame and not confirmSelectionFrame.styled then
			local itemFrame = confirmSelectionFrame.ItemFrame
			itemFrame.bg = F.ReskinIcon(itemFrame.Icon)
			F.ReskinIconBorder(itemFrame.IconBorder)

			local nameframe = _G[confirmSelectionFrame:GetName().."NameFrame"]
			if nameframe then
				nameframe:Hide() -- not sure about the name, need reviewed
			end

			confirmSelectionFrame.styled = true
		end
	end)
end