local _, ns = ...
local F, C = unpack(ns)

C.themes["Blizzard_Contribution"] = function()
	local frame = ContributionCollectionFrame
	F.SetBD(frame)
	F.ReskinClose(frame.CloseButton)
	frame.CloseButton.CloseButtonBackground:Hide()
	frame.Background:Hide()

	hooksecurefunc(ContributionMixin, "Update", function(self)
		if not self.styled then
			self.Header.Text:SetTextColor(1, .8, 0)
			F.Reskin(self.ContributeButton)
			F.ReplaceIconString(self.ContributeButton)
			hooksecurefunc(self.ContributeButton, "SetText", F.ReplaceIconString)

			F.StripTextures(self.Status)
			F.CreateBDFrame(self.Status, .25)

			self.styled = true
		end
	end)

	hooksecurefunc(ContributionRewardMixin, "Setup", function(self)
		if not self.styled then
			self.RewardName:SetTextColor(1, 1, 1)
			self.Border:Hide()
			self:GetRegions():Hide()
			F.ReskinIcon(self.Icon)

			self.styled = true
		end
	end)

	if F.ReskinTooltip then
		F.ReskinTooltip(ContributionBuffTooltip)
		ContributionBuffTooltip.Icon:SetTexCoord(unpack(C.TexCoord))
		ContributionBuffTooltip.Border:SetAlpha(0)
	end
end