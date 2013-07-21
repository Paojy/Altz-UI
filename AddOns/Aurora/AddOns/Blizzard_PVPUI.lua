local F, C = unpack(select(2, ...))

C.modules["Blizzard_PVPUI"] = function()
	local r, g, b = C.r, C.g, C.b

	local PVPUIFrame = PVPUIFrame
	local PVPQueueFrame = PVPQueueFrame
	local HonorFrame = HonorFrame
	local ConquestFrame = ConquestFrame
	local WarGamesFrame = WarGamesFrame
	local PVPArenaTeamsFrame = PVPArenaTeamsFrame

	PVPUIFrame:DisableDrawLayer("ARTWORK")
	PVPUIFrame.LeftInset:DisableDrawLayer("BORDER")
	PVPUIFrame.Background:Hide()
	PVPUIFrame.Shadows:Hide()
	PVPUIFrame.LeftInset:GetRegions():Hide()
	select(24, PVPUIFrame:GetRegions()):Hide()
	select(25, PVPUIFrame:GetRegions()):Hide()

	PVPUIFrameTab2:SetPoint("LEFT", PVPUIFrameTab1, "RIGHT", -15, 0)

	-- Category buttons

	for i = 1, 3 do
		local bu = PVPQueueFrame["CategoryButton"..i]
		local icon = bu.Icon
		local cu = bu.CurrencyIcon

		bu.Ring:Hide()

		F.Reskin(bu, true)

		bu.Background:SetAllPoints()
		bu.Background:SetTexture(r, g, b, .2)
		bu.Background:Hide()

		icon:SetTexCoord(.08, .92, .08, .92)
		icon:SetPoint("LEFT", bu, "LEFT")
		icon:SetDrawLayer("OVERLAY")
		icon.bg = F.CreateBG(icon)
		icon.bg:SetDrawLayer("ARTWORK")

		if cu then
			cu:SetSize(16, 16)
			cu:SetPoint("TOPLEFT", bu.Name, "BOTTOMLEFT", 0, -8)
			bu.CurrencyAmount:SetPoint("LEFT", cu, "RIGHT", 4, 0)

			cu:SetTexCoord(.08, .92, .08, .92)
			cu.bg = F.CreateBG(cu)
			cu.bg:SetDrawLayer("BACKGROUND", 1)
		end
	end

	PVPQueueFrame.CategoryButton1.Icon:SetTexture("Interface\\Icons\\achievement_bg_winwsg")
	PVPQueueFrame.CategoryButton2.Icon:SetTexture("Interface\\Icons\\achievement_bg_killxenemies_generalsroom")
	PVPQueueFrame.CategoryButton3.Icon:SetTexture("Interface\\Icons\\ability_warrior_offensivestance")

	local englishFaction = UnitFactionGroup("player")
	PVPQueueFrame.CategoryButton1.CurrencyIcon:SetTexture("Interface\\Icons\\PVPCurrency-Honor-"..englishFaction)
	PVPQueueFrame.CategoryButton2.CurrencyIcon:SetTexture("Interface\\Icons\\PVPCurrency-Conquest-"..englishFaction)

	hooksecurefunc("PVPQueueFrame_SelectButton", function(index)
		local self = PVPQueueFrame
		for i = 1, 3 do
			local bu = self["CategoryButton"..i]
			if i == index then
				bu.Background:Show()
			else
				bu.Background:Hide()
			end
		end
	end)

	-- Honor frame

	local Inset = HonorFrame.Inset
	local BonusFrame = HonorFrame.BonusFrame

	for i = 1, 9 do
		select(i, Inset:GetRegions()):Hide()
	end
	BonusFrame.BattlegroundTexture:Hide()
	BonusFrame.WorldBattlesTexture:Hide()
	BonusFrame.BattlegroundHeader:Hide()
	BonusFrame.WorldPVPHeader:Hide()
	BonusFrame.ShadowOverlay:Hide()

	--BonusFrame.DiceButton:SetNormalTexture("")
	--BonusFrame.DiceButton:SetPushedTexture("")
	F.Reskin(BonusFrame.DiceButton)

	for _, bu in pairs({BonusFrame.RandomBGButton, BonusFrame.CallToArmsButton, BonusFrame.WorldPVP1Button, BonusFrame.WorldPVP2Button}) do
		F.Reskin(bu, true)

		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetTexture(r, g, b, .2)
		bu.SelectedTexture:SetAllPoints()
	end

	BonusFrame.BattlegroundReward1.Amount:SetPoint("RIGHT", BonusFrame.BattlegroundReward1.Icon, "LEFT", -2, 0)
	BonusFrame.BattlegroundReward1.Icon:SetTexCoord(.08, .92, .08, .92)
	BonusFrame.BattlegroundReward1.Icon:SetSize(16, 16)
	F.CreateBG(BonusFrame.BattlegroundReward1.Icon)
	BonusFrame.BattlegroundReward2.Amount:SetPoint("RIGHT", BonusFrame.BattlegroundReward2.Icon, "LEFT", -2, 0)
	BonusFrame.BattlegroundReward2.Icon:SetTexCoord(.08, .92, .08, .92)
	BonusFrame.BattlegroundReward2.Icon:SetSize(16, 16)
	F.CreateBG(BonusFrame.BattlegroundReward2.Icon)

	hooksecurefunc("HonorFrameBonusFrame_Update", function()
		local canQueue, bgName, battleGroundID, hasWon, winHonorAmount, winConquestAmount = GetHolidayBGInfo()
		local rewardIndex = 0
		if winConquestAmount and winConquestAmount > 0 then
			rewardIndex = rewardIndex + 1
			local frame = HonorFrame.BonusFrame["BattlegroundReward"..rewardIndex]
			frame.Icon:SetTexture("Interface\\Icons\\PVPCurrency-Conquest-"..englishFaction)
		end
		if winHonorAmount and winHonorAmount > 0 then
			rewardIndex = rewardIndex + 1
			local frame = HonorFrame.BonusFrame["BattlegroundReward"..rewardIndex]
			frame.Icon:SetTexture("Interface\\Icons\\PVPCurrency-Honor-"..englishFaction)
		end
	end)

	-- Role buttons

	local RoleInset = HonorFrame.RoleInset

	RoleInset:DisableDrawLayer("BACKGROUND")
	RoleInset:DisableDrawLayer("BORDER")

	for _, roleButton in pairs({RoleInset.HealerIcon, RoleInset.TankIcon, RoleInset.DPSIcon}) do
		roleButton.cover:SetTexture(C.media.roleIcons)
		roleButton:SetNormalTexture(C.media.roleIcons)

		roleButton.checkButton:SetFrameLevel(roleButton:GetFrameLevel() + 2)

		for i = 1, 2 do
			local left = roleButton:CreateTexture()
			left:SetDrawLayer("OVERLAY", i)
			left:SetWidth(1)
			left:SetTexture(C.media.backdrop)
			left:SetVertexColor(0, 0, 0)
			left:SetPoint("TOPLEFT", roleButton, 6, -4)
			left:SetPoint("BOTTOMLEFT", roleButton, 6, 7)
			roleButton["leftLine"..i] = left

			local right = roleButton:CreateTexture()
			right:SetDrawLayer("OVERLAY", i)
			right:SetWidth(1)
			right:SetTexture(C.media.backdrop)
			right:SetVertexColor(0, 0, 0)
			right:SetPoint("TOPRIGHT", roleButton, -6, -4)
			right:SetPoint("BOTTOMRIGHT", roleButton, -6, 7)
			roleButton["rightLine"..i] = right

			local top = roleButton:CreateTexture()
			top:SetDrawLayer("OVERLAY", i)
			top:SetHeight(1)
			top:SetTexture(C.media.backdrop)
			top:SetVertexColor(0, 0, 0)
			top:SetPoint("TOPLEFT", roleButton, 6, -4)
			top:SetPoint("TOPRIGHT", roleButton, -6, -4)
			roleButton["topLine"..i] = top

			local bottom = roleButton:CreateTexture()
			bottom:SetDrawLayer("OVERLAY", i)
			bottom:SetHeight(1)
			bottom:SetTexture(C.media.backdrop)
			bottom:SetVertexColor(0, 0, 0)
			bottom:SetPoint("BOTTOMLEFT", roleButton, 6, 7)
			bottom:SetPoint("BOTTOMRIGHT", roleButton, -6, 7)
			roleButton["bottomLine"..i] = bottom
		end

		roleButton.leftLine2:Hide()
		roleButton.rightLine2:Hide()
		roleButton.topLine2:Hide()
		roleButton.bottomLine2:Hide()

		F.ReskinCheck(roleButton.checkButton)
	end

	-- Honor frame specific

	for _, bu in pairs(HonorFrame.SpecificFrame.buttons) do
		bu.Bg:Hide()
		bu.Border:Hide()

		bu:SetNormalTexture("")
		bu:SetHighlightTexture("")

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", 0, 2)
		F.CreateBD(bg, 0)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)

		bu.tex = F.CreateGradient(bu)
		bu.tex:SetDrawLayer("BACKGROUND")
		bu.tex:SetPoint("TOPLEFT", 3, -1)
		bu.tex:SetPoint("BOTTOMRIGHT", -1, 3)

		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetTexture(r, g, b, .2)
		bu.SelectedTexture:SetPoint("TOPLEFT", 2, 0)
		bu.SelectedTexture:SetPoint("BOTTOMRIGHT", 0, 2)

		bu.Icon:SetTexCoord(.08, .92, .08, .92)
		bu.Icon.bg = F.CreateBG(bu.Icon)
		bu.Icon.bg:SetDrawLayer("BACKGROUND", 1)
		bu.Icon:SetPoint("TOPLEFT", 5, -3)
	end

	-- if scroll frames aren't bugged then they are terribly implemented
	local bu1 = HonorFrame.SpecificFrame.buttons[1]
	bu1.tex:SetPoint("TOPLEFT", 3, 0)
	bu1.tex:SetPoint("BOTTOMRIGHT", -1, 3)
	bu1.Icon:SetPoint("TOPLEFT", 4, -2)
	bu1.SelectedTexture:SetPoint("BOTTOMRIGHT", 0, 3)

	-- Conquest Frame

	local Inset = ConquestFrame.Inset
	local ConquestBar = ConquestFrame.ConquestBar

	for i = 1, 9 do
		select(i, Inset:GetRegions()):Hide()
	end
	ConquestFrame.ArenaTexture:Hide()
	ConquestFrame.RatedBGTexture:Hide()
	ConquestFrame.ArenaHeader:Hide()
	ConquestFrame.RatedBGHeader:Hide()
	ConquestFrame.ShadowOverlay:Hide()

	for _, bu in pairs({ConquestFrame.Arena2v2, ConquestFrame.Arena3v3, ConquestFrame.Arena5v5, ConquestFrame.RatedBG}) do
		F.Reskin(bu, true)

		bu.SelectedTexture:SetDrawLayer("BACKGROUND")
		bu.SelectedTexture:SetTexture(r, g, b, .2)
		bu.SelectedTexture:SetAllPoints()
	end

	ConquestFrame.Arena3v3:SetPoint("TOP", ConquestFrame.Arena2v2, "BOTTOM", 0, -1)
	ConquestFrame.Arena5v5:SetPoint("TOP", ConquestFrame.Arena3v3, "BOTTOM", 0, -1)

	local classColour = C.classcolours[select(2, UnitClass("player"))]
	ConquestFrame.RatedBG.TeamNameText:SetText(UnitName("player"))
	ConquestFrame.RatedBG.TeamNameText:SetTextColor(classColour.r, classColour.g, classColour.b)

	ConquestFrame.ArenaReward.Amount:SetPoint("RIGHT", ConquestFrame.ArenaReward.Icon, "LEFT", -2, 0)
	ConquestFrame.ArenaReward.Icon:SetTexCoord(.08, .92, .08, .92)
	ConquestFrame.ArenaReward.Icon:SetSize(16, 16)
	F.CreateBG(ConquestFrame.ArenaReward.Icon)
	ConquestFrame.RatedBGReward.Amount:SetPoint("RIGHT", ConquestFrame.RatedBGReward.Icon, "LEFT", -2, 0)
	ConquestFrame.RatedBGReward.Icon:SetTexCoord(.08, .92, .08, .92)
	ConquestFrame.RatedBGReward.Icon:SetSize(16, 16)
	F.CreateBG(ConquestFrame.RatedBGReward.Icon)

	ConquestFrame.ArenaReward.Icon:SetTexture("Interface\\Icons\\PVPCurrency-Honor-"..englishFaction)
	ConquestFrame.RatedBGReward.Icon:SetTexture("Interface\\Icons\\PVPCurrency-Conquest-"..englishFaction)

	for i = 1, 4 do
		select(i, ConquestBar:GetRegions()):Hide()
		_G["ConquestPointsBarDivider"..i]:Hide()
	end

	ConquestBar.shadow:Hide()

	ConquestBar.progress:SetTexture(C.media.backdrop)
	ConquestBar.progress:SetGradient("VERTICAL", .8, 0, 0, 1, 0, 0)

	local bg = F.CreateBDFrame(ConquestBar, .25)
	bg:SetPoint("TOPLEFT", -1, -2)
	bg:SetPoint("BOTTOMRIGHT", 1, 2)

	-- War games

	local Inset = WarGamesFrame.RightInset

	for i = 1, 9 do
		select(i, Inset:GetRegions()):Hide()
	end
	WarGamesFrame.InfoBG:Hide()
	WarGamesFrame.HorizontalBar:Hide()
	WarGamesFrameInfoScrollFrame.scrollBarBackground:Hide()
	WarGamesFrameInfoScrollFrame.scrollBarArtTop:Hide()
	WarGamesFrameInfoScrollFrame.scrollBarArtBottom:Hide()

	WarGamesFrameDescription:SetTextColor(.9, .9, .9)

	local function onSetNormalTexture(self, texture)
		if texture:find("Plus") then
			self.plus:Show()
		else
			self.plus:Hide()
		end
	end

	for _, button in pairs(WarGamesFrame.scrollFrame.buttons) do
		local bu = button.Entry
		local SelectedTexture = bu.SelectedTexture

		bu.Bg:Hide()
		bu.Border:Hide()

		bu:SetNormalTexture("")
		bu:SetHighlightTexture("")

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -1, 2)
		F.CreateBD(bg, 0)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)

		local tex = F.CreateGradient(bu)
		tex:SetDrawLayer("BACKGROUND")
		tex:SetPoint("TOPLEFT", 3, -1)
		tex:SetPoint("BOTTOMRIGHT", -2, 3)

		SelectedTexture:SetDrawLayer("BACKGROUND")
		SelectedTexture:SetTexture(r, g, b, .2)
		SelectedTexture:SetPoint("TOPLEFT", 2, 0)
		SelectedTexture:SetPoint("BOTTOMRIGHT", -1, 2)

		bu.Icon:SetTexCoord(.08, .92, .08, .92)
		bu.Icon.bg = F.CreateBG(bu.Icon)
		bu.Icon.bg:SetDrawLayer("BACKGROUND", 1)
		bu.Icon:SetPoint("TOPLEFT", 5, -3)

		local header = button.Header

		header:GetNormalTexture():SetAlpha(0)
		header:SetHighlightTexture("")
		header:SetPushedTexture("")

		local headerBg = CreateFrame("Frame", nil, header)
		headerBg:SetSize(13, 13)
		headerBg:SetPoint("LEFT", 4, 0)
		headerBg:SetFrameLevel(header:GetFrameLevel()-1)
		F.CreateBD(headerBg, 0)

		local headerTex = F.CreateGradient(header)
		headerTex:SetAllPoints(headerBg)

		local minus = header:CreateTexture(nil, "OVERLAY")
		minus:SetSize(7, 1)
		minus:SetPoint("CENTER", headerBg)
		minus:SetTexture(C.media.backdrop)
		minus:SetVertexColor(1, 1, 1)

		local plus = header:CreateTexture(nil, "OVERLAY")
		plus:SetSize(1, 7)
		plus:SetPoint("CENTER", headerBg)
		plus:SetTexture(C.media.backdrop)
		plus:SetVertexColor(1, 1, 1)
		header.plus = plus

		hooksecurefunc(header, "SetNormalTexture", onSetNormalTexture)
	end

	-- Arena

	local ArenaTeamFrame = ArenaTeamFrame
	local TopInset = ArenaTeamFrame.TopInset
	local WeeklyDisplay = ArenaTeamFrame.WeeklyDisplay
	local BottomInset = ArenaTeamFrame.BottomInset

	for i = 1, 9 do
		select(i, TopInset:GetRegions()):Hide()
		select(i, WeeklyDisplay:GetRegions()):Hide()
		select(i, BottomInset:GetRegions()):Hide()
	end

	ArenaTeamFrame.TeamNameHeader:Hide()
	ArenaTeamFrame.ArenaTexture:Hide()
	ArenaTeamFrame.TopShadowOverlay:Hide()

	for i = 1, 3 do
		local bu = PVPArenaTeamsFrame["Team"..i]

		bu.Flag.FlagGrabber:Hide()
		bu.Flag:SetPoint("TOPLEFT", 10, -1)

		bu.Background:SetTexture(r, g, b, .2)
		bu.Background:SetAllPoints()
		bu.Background:Hide()

		F.Reskin(bu, true)
	end

	hooksecurefunc("PVPArenaTeamsFrame_SelectButton", function(button)
		for i = 1, MAX_ARENA_TEAMS do
			local teamButton = PVPArenaTeamsFrame["Team"..i]
			if teamButton == button then
				teamButton.Background:Show()
			else
				teamButton.Background:Hide()
			end
		end
	end)

	local function onEnter(self)
		self.bg:SetBackdropColor(r, g, b, .2)
	end

	local function onLeave(self)
		self.bg:SetBackdropColor(0, 0, 0, .25)
	end

	for i = 1, 4 do
		local header = ArenaTeamFrame["Header"..i]

		for j = 1, 3 do
			select(j, header:GetRegions()):Hide()
		end

		header:SetHighlightTexture("")

		local bg = CreateFrame("Frame", nil, header)
		bg:SetPoint("TOPLEFT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -1, 0)
		bg:SetFrameLevel(header:GetFrameLevel()-1)
		F.CreateBD(bg, .25)

		header.bg = bg

		header:HookScript("OnEnter", onEnter)
		header:HookScript("OnLeave", onLeave)
	end

	hooksecurefunc("PVPArenaTeamsFrame_ShowTeam", function(self)
		local frame = ArenaTeamFrame
		if not self.selectedButton then
			return
		end

		for i = 1, MAX_ARENA_TEAM_MEMBERS do
			local button = frame["TeamMember"..i]

			if button:IsEnabled() then
				local name, rank, level, class, online = GetArenaTeamRosterInfo(frame.teamIndex, i);
				local color = ConvertRGBtoColorString(C.classcolours[class])
				if online then
					button.NameText:SetText(color..name..FONT_COLOR_CODE_CLOSE)
				else
					button.NameText:SetText(GRAY_FONT_COLOR_CODE..name..FONT_COLOR_CODE_CLOSE)
				end
			end
		end
	end)

	local INVITE_DROPDOWN = 1;
	function ArenaInviteMenu_Init(self, level, team)
		local info = UIDropDownMenu_CreateInfo();
		info.notCheckable = true;
		info.value = nil;

		if (level == 1 and (not team or not team[1])) then
			info.text = INVITE_TEAM_MEMBERS;
			info.disabled = true;
			info.func =  nil;
			info.hasArrow = true;
			info.value = INVITE_DROPDOWN;
			UIDropDownMenu_AddButton(info, level)

			info.text = CANCEL
			info.disabled = nil;
			info.hasArrow = nil;
			info.value = nil;
			info.func = nil
			UIDropDownMenu_AddButton(info, level)
			return;
		end

		if (UIDROPDOWNMENU_MENU_VALUE == INVITE_DROPDOWN) then
			if (not team) then
				return
			end
			for i=1, #team do
				if (team[i].online) then
					local color = C.classcolours[team[i].class]
					info.text = ConvertRGBtoColorString(color)..team[i].name..FONT_COLOR_CODE_CLOSE;
					info.func = function (menu, name) InviteToGroup(name); end
					info.arg1 = team[i].name;
					info.disabled = nil;
				else
					info.disabled = true;
					info.text = team[i].name;
				end
				UIDropDownMenu_AddButton(info, level)
			end
		end

		if (level == 1) then
			info.text = INVITE_TEAM_MEMBERS;
			info.func =  nil;
			info.hasArrow = true;
			info.value = INVITE_DROPDOWN;
			info.menuList = team;
			UIDropDownMenu_AddButton(info, level)
			info.text = CANCEL
			info.value = nil;
			info.hasArrow = nil;
			info.menuList = nil;
			UIDropDownMenu_AddButton(info, level)
		end
	end

	ArenaTeamFrame.Flag:SetPoint("TOPLEFT", 25, -3)

	F.CreateBD(TopInset, .25)
	F.ReskinArrow(ArenaTeamFrame.weeklyToggleRight, "RIGHT")
	F.ReskinArrow(ArenaTeamFrame.weeklyToggleLeft, "LEFT")

	-- Main style

	F.ReskinPortraitFrame(PVPUIFrame)
	F.ReskinTab(PVPUIFrame.Tab1)
	F.ReskinTab(PVPUIFrame.Tab2)
	F.Reskin(HonorFrame.SoloQueueButton)
	F.Reskin(HonorFrame.GroupQueueButton)
	F.Reskin(ConquestFrame.JoinButton)
	F.Reskin(WarGameStartButton)
	F.Reskin(ArenaTeamFrame.AddMemberButton)
	F.ReskinDropDown(HonorFrameTypeDropDown)
	F.ReskinScroll(HonorFrameSpecificFrameScrollBar)
	F.ReskinScroll(WarGamesFrameScrollFrameScrollBar)
	F.ReskinScroll(WarGamesFrameInfoScrollFrameScrollBar)
end