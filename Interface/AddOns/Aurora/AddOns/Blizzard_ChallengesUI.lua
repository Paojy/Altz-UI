local F, C = unpack(select(2, ...))

C.themes["Blizzard_ChallengesUI"] = function()
	ChallengesFrameInset:DisableDrawLayer("BORDER")
	ChallengesFrameInsetBg:Hide()
	for i = 1, 2 do
		select(i, ChallengesFrame:GetRegions()):Hide()
	end

	select(1, ChallengesFrame.GuildBest:GetRegions()):Hide()
	select(3, ChallengesFrame.GuildBest:GetRegions()):Hide()
	F.CreateBD(ChallengesFrame.GuildBest, .3)

	local angryStyle
	ChallengesFrame:HookScript("OnShow", function()
		for i = 1, 9 do
			local bu = ChallengesFrame.DungeonIcons[i]
			if bu and not bu.styled then
				bu:GetRegions():Hide()
				bu.Icon:SetTexCoord(.08, .92, .08, .92)
				F.CreateBD(bu, .3)
				bu.styled = true
			end
		end

		if IsAddOnLoaded("AngryKeystones") and not angryStyle then
			local scheduel = select(6, ChallengesFrame:GetChildren())
			select(1, scheduel:GetRegions()):Hide()
			select(3, scheduel:GetRegions()):Hide()
			F.CreateBD(scheduel, .3)
			angryStyle = true
		end
	end)

	local keystone = ChallengesKeystoneFrame
	F.SetBD(keystone)
	F.ReskinClose(keystone.CloseButton)
	F.Reskin(keystone.StartButton)

	hooksecurefunc(keystone, "Reset", function(self)
		select(1, self:GetRegions()):SetAlpha(0)
		self.InstructionBackground:SetAlpha(0)
	end)

	hooksecurefunc(keystone, "OnKeystoneSlotted", function(self)
		for i, frame in ipairs(self.Affixes) do
			frame.Border:Hide()
			frame.Portrait:SetTexture(nil)
			F.ReskinIcon(frame.Portrait)

			if frame.info then
				frame.Portrait:SetTexture(CHALLENGE_MODE_EXTRA_AFFIX_INFO[frame.info.key].texture)
			elseif frame.affixID then
				local _, _, filedataid = C_ChallengeMode.GetAffixInfo(frame.affixID)
				frame.Portrait:SetTexture(filedataid)
			end
		end
	end)
end