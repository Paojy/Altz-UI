local F, C = unpack(select(2, ...))

C.modules["Blizzard_LookingForGuildUI"] = function()
	local r, g, b = C.r, C.g, C.b

	F.SetBD(LookingForGuildFrame)
	F.CreateBD(LookingForGuildInterestFrame, .25)
	LookingForGuildInterestFrameBg:Hide()
	F.CreateBD(LookingForGuildAvailabilityFrame, .25)
	LookingForGuildAvailabilityFrameBg:Hide()
	F.CreateBD(LookingForGuildRolesFrame, .25)
	LookingForGuildRolesFrameBg:Hide()
	F.CreateBD(LookingForGuildCommentFrame, .25)
	LookingForGuildCommentFrameBg:Hide()
	F.CreateBD(LookingForGuildCommentInputFrame, .12)
	LookingForGuildFrame:DisableDrawLayer("BACKGROUND")
	LookingForGuildFrame:DisableDrawLayer("BORDER")
	LookingForGuildFrameInset:DisableDrawLayer("BACKGROUND")
	LookingForGuildFrameInset:DisableDrawLayer("BORDER")
	F.CreateBD(GuildFinderRequestMembershipFrame)
	F.CreateSD(GuildFinderRequestMembershipFrame)
	for i = 1, 5 do
		local bu = _G["LookingForGuildBrowseFrameContainerButton"..i]
		F.CreateBD(bu, .25)
		bu:SetHighlightTexture("")
		bu:GetRegions():SetTexture(C.media.backdrop)
		bu:GetRegions():SetVertexColor(r, g, b, .2)
	end
	for i = 1, 9 do
		select(i, LookingForGuildCommentInputFrame:GetRegions()):Hide()
	end
	for i = 1, 3 do
		for j = 1, 6 do
			select(j, _G["LookingForGuildFrameTab"..i]:GetRegions()):Hide()
			select(j, _G["LookingForGuildFrameTab"..i]:GetRegions()).Show = F.dummy
		end
	end
	for i = 1, 6 do
		select(i, GuildFinderRequestMembershipFrameInputFrame:GetRegions()):Hide()
	end
	LookingForGuildFrameTabardBackground:Hide()
	LookingForGuildFrameTabardEmblem:Hide()
	LookingForGuildFrameTabardBorder:Hide()
	LookingForGuildFramePortraitFrame:Hide()
	LookingForGuildFrameTopBorder:Hide()
	LookingForGuildFrameTopRightCorner:Hide()

	F.Reskin(LookingForGuildBrowseButton)
	F.Reskin(LookingForGuildRequestButton)
	F.Reskin(GuildFinderRequestMembershipFrameAcceptButton)
	F.Reskin(GuildFinderRequestMembershipFrameCancelButton)

	F.ReskinScroll(LookingForGuildBrowseFrameContainerScrollBar)
	F.ReskinClose(LookingForGuildFrameCloseButton)
	F.ReskinCheck(LookingForGuildQuestButton)
	F.ReskinCheck(LookingForGuildDungeonButton)
	F.ReskinCheck(LookingForGuildRaidButton)
	F.ReskinCheck(LookingForGuildPvPButton)
	F.ReskinCheck(LookingForGuildRPButton)
	F.ReskinCheck(LookingForGuildWeekdaysButton)
	F.ReskinCheck(LookingForGuildWeekendsButton)
	F.ReskinCheck(LookingForGuildTankButton:GetChildren())
	F.ReskinCheck(LookingForGuildHealerButton:GetChildren())
	F.ReskinCheck(LookingForGuildDamagerButton:GetChildren())
	F.ReskinInput(GuildFinderRequestMembershipFrameInputFrame)
end