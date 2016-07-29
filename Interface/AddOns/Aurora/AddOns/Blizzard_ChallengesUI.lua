local F, C = unpack(select(2, ...))

C.themes["Blizzard_ChallengesUI"] = function()
	ChallengesFrameInset:DisableDrawLayer("BORDER")
	ChallengesFrameInsetBg:Hide()
	
	--ChallengesModeWeeklyBest.Child.RuneBG:Hide()
	--ChallengesModeWeeklyBest.Child.Glow:Hide()
	--ChallengesModeWeeklyBest.Child.Star:Hide()
	ChallengesModeWeeklyBest.Child.Level:SetPoint("CENTER", ChallengesModeWeeklyBest.Child.Star, "CENTER", 0, 3)
	
	F.CreateBD(ChallengesFrame.GuildBest, .3)
	
	select(1, ChallengesFrame.GuildBest:GetRegions()):Hide()
	select(3, ChallengesFrame.GuildBest:GetRegions()):Hide()
	
	for i = 1, 2 do
		select(i, ChallengesFrame:GetRegions()):Hide()
	end
	
	hooksecurefunc("ChallengesFrame_Update", function()
		for i = 1, 9 do
			local bu = ChallengesFrame.DungeonIcons[i]
			if bu then
				select(1, bu:GetRegions()):Hide()
				bu.Icon:SetTexCoord(.08, .92, .08, .92)
				F.CreateBD(bu, .25)
			end
		end
	end)
end
