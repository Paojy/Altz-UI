local F, C = unpack(select(2, ...))

C.themes["Blizzard_OrderHallUI"] = function()
	F.Reskin(OrderHallMissionFrameMissions.CompleteDialog.BorderFrame.ViewButton)
	F.Reskin(OrderHallMissionFrameMissions.CombatAllyUI.InProgress.Unassign)
	F.Reskin(OrderHallMissionFrame.MissionTab.MissionPage.StartMissionButton)
	F.ReskinClose(OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage.CloseButton)
	F.ReskinClose(OrderHallMissionFrame.CloseButton)
	F.ReskinClose(OrderHallMissionFrame.MissionTab.MissionPage.CloseButton)
	
	F.ReskinTab(OrderHallMissionFrameTab1)
	F.ReskinTab(OrderHallMissionFrameTab2)
	F.ReskinTab(OrderHallMissionFrameTab3)
	
	F.ReskinTab(OrderHallMissionFrameMissionsTab1)
	OrderHallMissionFrameMissionsTab1.Middle:SetAlpha(0)
	OrderHallMissionFrameMissionsTab1.SelectedMid:SetAlpha(0)
	OrderHallMissionFrameMissionsTab1.Left:SetAlpha(0)
	OrderHallMissionFrameMissionsTab1.SelectedLeft:SetAlpha(0)
	OrderHallMissionFrameMissionsTab1.Right:SetAlpha(0)
	OrderHallMissionFrameMissionsTab1.SelectedRight:SetAlpha(0)
	
	F.ReskinTab(OrderHallMissionFrameMissionsTab2)
	OrderHallMissionFrameMissionsTab2.Middle:SetAlpha(0)
	OrderHallMissionFrameMissionsTab2.SelectedMid:SetAlpha(0)
	OrderHallMissionFrameMissionsTab2.Left:SetAlpha(0)
	OrderHallMissionFrameMissionsTab2.SelectedLeft:SetAlpha(0)
	OrderHallMissionFrameMissionsTab2.Right:SetAlpha(0)
	OrderHallMissionFrameMissionsTab2.SelectedRight:SetAlpha(0)
	
	F.ReskinScroll(OrderHallMissionFrameMissionsListScrollFrameScrollBar)
	F.ReskinScroll(OrderHallMissionFrameFollowersListScrollFrameScrollBar)
	
	for i = 1, 9 do
		local bu = _G["OrderHallMissionFrameMissionsListScrollFrameButton"..i]
		bu.Overlay:SetAlpha(0)
		bu.LocBG:SetAlpha(0)
		bu.Highlight:SetAlpha(0)
		for j = 1, 20 do
			texture = select(j, bu:GetRegions())
			if texture:GetObjectType() == "Texture" then
				texture:Hide()
			end
		end
		F.Reskin(bu)
	end
	
	for i = 1, 18 do
		select(i, OrderHallMissionFrameMissions:GetRegions()):Hide()
	end
	do
		OrderHallMissionFrameMissions.MaterialFrame.Icon:SetTexCoord(.08, .92, .08, .92)
		OrderHallMissionFrameMissions.MaterialFrame:GetRegions():Hide()
		local bg = F.CreateBDFrame(OrderHallMissionFrameMissions.MaterialFrame, .25)
		bg:SetPoint("TOPLEFT", 5, -5)
		bg:SetPoint("BOTTOMRIGHT", -5, 6)
	end
	OrderHallMissionFrameMissions.CombatAllyUI:GetRegions():Hide()
	F.CreateBDFrame(OrderHallMissionFrameMissions.CombatAllyUI, .25)

	for i = 1, 14 do
		select(i, OrderHallMissionFrame:GetRegions()):Hide()
	end
	OrderHallMissionFrame.TitleText:Show()
	F.SetBD(OrderHallMissionFrame)
	OrderHallMissionFrame.ClassHallIcon:Hide()
	OrderHallMissionFrame.GarrCorners:Hide()
	OrderHallMissionFrame.BackgroundTile:Hide()
	OrderHallMissionFrame.BackgroundTile.Show = F.dummy

	for i = 1, 20 do
		select(i, OrderHallMissionFrameFollowers:GetRegions()):Hide()
	end
	F.ReskinInput(OrderHallMissionFrameFollowers.SearchBox)

	do
		OrderHallMissionFrameFollowers.MaterialFrame.Icon:SetTexCoord(.08, .92, .08, .92)
		OrderHallMissionFrameFollowers.MaterialFrame:GetRegions():Hide()
		local bg = F.CreateBDFrame(OrderHallMissionFrameFollowers.MaterialFrame, .25)
		bg:SetPoint("TOPLEFT", 5, -5)
		bg:SetPoint("BOTTOMRIGHT", -5, 6)
	end

	local FollowerTab = OrderHallMissionFrame.FollowerTab
	FollowerTab:DisableDrawLayer("BORDER")
	do
		local xpBar = FollowerTab.XPBar
		select(1, xpBar:GetRegions()):Hide()
		xpBar.XPLeft:Hide()
		xpBar.XPRight:Hide()
		select(4, xpBar:GetRegions()):Hide()
		xpBar:SetStatusBarTexture(C.media.backdrop)
		F.CreateBDFrame(xpBar)
	end

	-- Mission UI

	local MissionPage = OrderHallMissionFrame.MissionTab.MissionPage
	for i = 1, 15 do
		select(i, MissionPage:GetRegions()):Hide()
	end
	select(18, MissionPage:GetRegions()):Hide()
	select(19, MissionPage:GetRegions()):Hide()
	select(20, MissionPage:GetRegions()):Hide()
	MissionPage.StartMissionButton.Flash:SetTexture("")
	F.Reskin(MissionPage.StartMissionButton)
	F.ReskinClose(MissionPage.CloseButton)
	MissionPage.CloseButton:ClearAllPoints()
	MissionPage.CloseButton:SetPoint("TOPRIGHT", -10, -5)
	select(4, MissionPage.Stage:GetRegions()):Hide()
	select(5, MissionPage.Stage:GetRegions()):Hide()
	MissionPage.CostFrame.CostIcon:SetTexCoord(.08, .92, .08, .92)
	do
		local bg = CreateFrame("Frame", nil, MissionPage.Stage)
		bg:SetPoint("TOPLEFT", 4, 1)
		bg:SetPoint("BOTTOMRIGHT", -4, -1)
		bg:SetFrameLevel(MissionPage.Stage:GetFrameLevel() - 1)
		F.CreateBD(bg)

		local overlay = MissionPage.Stage:CreateTexture()
		overlay:SetDrawLayer("ARTWORK", 3)
		overlay:SetAllPoints(bg)
		overlay:SetColorTexture(0, 0, 0, .5)

		local iconbg = select(16, MissionPage:GetRegions())
		iconbg:ClearAllPoints()
		iconbg:SetPoint("TOPLEFT", 3, -1)
	end

	for i = 1, 3 do
		local follower = MissionPage.Followers[i]
		follower:GetRegions():Hide()
		F.CreateBD(follower, .25)
		
		follower.PortraitFrame.Highlight:Hide()
		follower.PortraitFrame.PortraitFeedbackGlow:Hide()
		
		follower.PortraitFrame.PortraitRing:SetAlpha(0)
		follower.PortraitFrame.PortraitRingQuality:SetAlpha(0)
		follower.PortraitFrame.LevelBorder:SetAlpha(0)
		follower.PortraitFrame.Level:SetText("")
		
		follower.PortraitFrame.Empty:SetColorTexture(0,0,0)
		follower.PortraitFrame.Empty:SetAllPoints(follower.PortraitFrame.Portrait)
	end

	for i = 1, 3 do
		local num = 1
		local enemy = MissionPage.Enemies[i].Mechanics
		local mec = enemy[num]
		while mec do
			mec.Icon:SetTexCoord(.08,.92,.08,.92)
			num = num + 1
			mec = enemy[num]
		end
	end
	
	OrderHallMissionFrame.MissionTab.MissionPage.RewardsFrame:GetRegions():SetAlpha(0)
	OrderHallMissionFrame.MissionTab.MissionPage.RewardsFrame:DisableDrawLayer("BORDER")
	F.CreateBD(OrderHallMissionFrame.MissionTab.MissionPage.RewardsFrame)
	
	for i = 1, 2 do
		local reward = MissionPage.RewardsFrame.Rewards[i]
		local icon = reward.Icon
		reward.BG:Hide()
		icon:SetTexCoord(.08, .92, .08, .92)
		icon:SetDrawLayer("BORDER", 1)
		F.CreateBG(icon)
		reward.ItemBurst:SetDrawLayer("BORDER", 2)
		F.CreateBD(reward, .15)
	end

	-- Add Ally

	
	F.CreateBD(OrderHallMissionFrameMissions.CombatAllyUI.InProgress.CombatAllySpell)
	OrderHallMissionFrameMissions.CombatAllyUI.InProgress.CombatAllySpell.iconTexture:SetTexCoord(.08, .92, .08, .92)
	
	OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage.Follower1.PortraitFrame.Highlight:Hide()
	OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage.Follower1.PortraitFrame.PortraitFeedbackGlow:Hide()
	
	OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage.Follower1.PortraitFrame.PortraitRing:SetAlpha(0)
	OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage.Follower1.PortraitFrame.PortraitRingQuality:SetAlpha(0)
	OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage.Follower1.PortraitFrame.LevelBorder:SetAlpha(0)
	OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage.Follower1.PortraitFrame.Level:SetText("")
	
	OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage.Follower1.PortraitFrame.Empty:SetColorTexture(0,0,0)
	OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage.Follower1.PortraitFrame.Empty:SetAllPoints(OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage.Follower1.PortraitFrame.Portrait)
	
	local allyPortrait = OrderHallMissionFrameMissions.CombatAllyUI.InProgress.PortraitFrame
	
	F.ReskinGarrisonPortrait(allyPortrait)
	OrderHallMissionFrame:HookScript("OnShow", function(self)
		if allyPortrait:IsShown() then
			allyPortrait.squareBG:SetBackdropBorderColor(allyPortrait.PortraitRingQuality:GetVertexColor())
		end
		
		OrderHallMissionFrameMissions.CombatAllyUI.Available.AddFollowerButton.EmptyPortrait:SetAlpha(0)
		OrderHallMissionFrameMissions.CombatAllyUI.Available.AddFollowerButton.PortraitHighlight:SetAlpha(0)
	end)

	hooksecurefunc(OrderHallCombatAllyMixin, "SetMission", function(self)
		self.InProgress.PortraitFrame.LevelBorder:SetAlpha(0)
	end)

	hooksecurefunc(OrderHallCombatAllyMixin, "UnassignAlly", function(self)
		if self.InProgress.PortraitFrame.squareBG then
			self.InProgress.PortraitFrame.squareBG:Hide()
		end
	end)
	
	OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage.CombatAllyLabel.TextBackground:SetAlpha(0)
	for i = 1, 11 do
		texture = select(i, OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage:GetRegions())
		if texture:GetObjectType() == "Texture" then
			texture:Hide()
		end
	end
	for i = 1, 3 do
		texture = select(i, OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage.Follower1:GetRegions())
		texture:Hide()
	end

	F.CreateBD(OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage)
	F.Reskin(OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage.StartMissionButton)
	OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage.CombatAllySpell.iconTexture:SetTexCoord(.08, .92, .08, .92)

	-- Talent Frame

	F.ReskinClose(OrderHallTalentFrameCloseButton)
	for i = 1, 15 do
		select(i, OrderHallTalentFrame:GetRegions()):Hide()
	end
	OrderHallTalentFrameTitleText:Show()
	OrderHallTalentFrameBg:Hide()
	F.CreateBD(OrderHallTalentFrame)
	ClassHallTalentInset:Hide()
	OrderHallTalentFramePortrait:Hide()
	OrderHallTalentFramePortraitFrame:Hide()

	hooksecurefunc(OrderHallTalentFrame, "RefreshAllData", function()
		for i = 34, 38 do
			select(i, OrderHallTalentFrame:GetRegions()):SetAlpha(0)
		end

		for i = 5, 15 do
			local bu = select(i, OrderHallTalentFrame:GetChildren())
			if not bu.styled then
				bu.Icon:SetTexCoord(.08, .92, .08, .92)
				bu.Border:SetAlpha(0)
				bu.Highlight:SetColorTexture(1, 1, 1, .25)
				bu.bg = F.CreateBDFrame(bu.Border)
				bu.bg:SetPoint("TOPLEFT", -1.2, 1.2)
				bu.bg:SetPoint("BOTTOMRIGHT", 1.2, -1.2)
				bu.styled = true
			end

			if bu.talent.selected then
				bu.bg:SetBackdropBorderColor(1, 1, 0)
			else
				bu.bg:SetBackdropBorderColor(0, 0, 0)
			end
		end
	end)
end