local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local function styleRewardButton(button)
		if not button or button.styled then return end

		local buttonName = button:GetName()
		local icon = _G[buttonName.."IconTexture"]
		local shortageBorder = _G[buttonName.."ShortageBorder"]
		local count = _G[buttonName.."Count"]
		local nameFrame = _G[buttonName.."NameFrame"]
		local border = button.IconBorder

		if shortageBorder then shortageBorder:SetAlpha(0) end
		if count then count:SetDrawLayer("OVERLAY") end
		if nameFrame then nameFrame:SetAlpha(0) end
		if border then border:SetAlpha(0) end

		local icbg = F.ReskinIcon(icon)
		icon:SetDrawLayer("OVERLAY")
		local bg = F.CreateBDFrame(button, .25)
		bg:SetPoint("TOPLEFT", icbg, "TOPRIGHT")
		bg:SetPoint("BOTTOMRIGHT", icbg, "BOTTOMRIGHT", 100, 0)

		button.styled = true
	end

	hooksecurefunc("LFGRewardsFrame_SetItemButton", function(parentFrame, _, index)
		local parentName = parentFrame:GetName()
		local button = _G[parentName.."Item"..index]
		styleRewardButton(button)

		local moneyReward = parentFrame.MoneyReward
		styleRewardButton(moneyReward)
	end)

	LFGDungeonReadyDialogRoleIconLeaderIcon:SetTexture(nil)
	local leaderFrame = CreateFrame("Frame", nil, LFGDungeonReadyDialog)
	leaderFrame:SetFrameLevel(5)
	leaderFrame:SetPoint("TOPLEFT", LFGDungeonReadyDialogRoleIcon, 4, -4)
	leaderFrame:SetSize(19, 19)
	local leaderIcon = leaderFrame:CreateTexture(nil, "ARTWORK")
	leaderIcon:SetAllPoints()
	F.ReskinRole(leaderIcon, "LEADER")

	local iconTexture = LFGDungeonReadyDialogRoleIconTexture
	iconTexture:SetTexture(C.media.roleIcons)
	local bg = F.CreateBDFrame(iconTexture)

	hooksecurefunc("LFGDungeonReadyPopup_Update", function()
		LFGDungeonReadyDialog:SetBackdrop(nil)
		leaderFrame:SetShown(LFGDungeonReadyDialogRoleIconLeaderIcon:IsShown())

		if LFGDungeonReadyDialogRoleIcon:IsShown() then
			local role = select(7, GetLFGProposal())
			if not role or role == "NONE" then role = "DAMAGER" end
			iconTexture:SetTexCoord(F.GetRoleTexCoord(role))
			bg:Show()
		else
			bg:Hide()
		end
	end)

	local function reskinDialogReward(button)
		if button.styled then return end

		local border = _G[button:GetName().."Border"]
		button.texture:SetTexCoord(.08, .92, .08, .92)
		border:SetColorTexture(0, 0, 0)
		border:SetDrawLayer("BACKGROUND")
		border:SetPoint("TOPLEFT", button.texture, -C.mult, C.mult)
		border:SetPoint("BOTTOMRIGHT", button.texture, C.mult, -C.mult)
		button.styled = true
	end

	hooksecurefunc("LFGDungeonReadyDialogReward_SetMisc", function(button)
		reskinDialogReward(button)
		button.texture:SetTexture("Interface\\Icons\\inv_misc_coin_02")
	end)

	hooksecurefunc("LFGDungeonReadyDialogReward_SetReward", function(button, dungeonID, rewardIndex, rewardType, rewardArg)
		reskinDialogReward(button)

		local texturePath
		if rewardType == "reward" then
			texturePath = select(2, GetLFGDungeonRewardInfo(dungeonID, rewardIndex))
		elseif rewardType == "shortage" then
			texturePath = select(2, GetLFGDungeonShortageRewardInfo(dungeonID, rewardArg, rewardIndex))
		end
		if texturePath then
			button.texture:SetTexture(texturePath)
		end
	end)

	F.StripTextures(LFGDungeonReadyDialog, 0)
	F.SetBD(LFGDungeonReadyDialog)
	F.StripTextures(LFGInvitePopup)
	F.CreateBD(LFGInvitePopup)
	F.CreateSD(LFGInvitePopup)
	F.CreateBD(LFGDungeonReadyStatus)
	F.CreateSD(LFGDungeonReadyStatus)

	F.Reskin(LFGDungeonReadyDialogEnterDungeonButton)
	F.Reskin(LFGDungeonReadyDialogLeaveQueueButton)
	F.Reskin(LFGInvitePopupAcceptButton)
	F.Reskin(LFGInvitePopupDeclineButton)
	F.ReskinClose(LFGDungeonReadyDialogCloseButton)
	F.ReskinClose(LFGDungeonReadyStatusCloseButton)

	local function reskinRoleButton(buttons, role)
		for _, roleButton in pairs(buttons) do
			F.ReskinRole(roleButton, role)
		end
	end

	local tanks = {
		LFDQueueFrameRoleButtonTank,
		LFDRoleCheckPopupRoleButtonTank,
		RaidFinderQueueFrameRoleButtonTank,
		LFGInvitePopupRoleButtonTank,
		LFGListApplicationDialog.TankButton,
		LFGDungeonReadyStatusGroupedTank,
	}
	reskinRoleButton(tanks, "TANK")

	local healers = {
		LFDQueueFrameRoleButtonHealer,
		LFDRoleCheckPopupRoleButtonHealer,
		RaidFinderQueueFrameRoleButtonHealer,
		LFGInvitePopupRoleButtonHealer,
		LFGListApplicationDialog.HealerButton,
		LFGDungeonReadyStatusGroupedHealer,
	}
	reskinRoleButton(healers, "HEALER")

	local dps = {
		LFDQueueFrameRoleButtonDPS,
		LFDRoleCheckPopupRoleButtonDPS,
		RaidFinderQueueFrameRoleButtonDPS,
		LFGInvitePopupRoleButtonDPS,
		LFGListApplicationDialog.DamagerButton,
		LFGDungeonReadyStatusGroupedDamager,
	}
	reskinRoleButton(dps, "DPS")

	F.ReskinRole(LFDQueueFrameRoleButtonLeader, "LEADER")
	F.ReskinRole(RaidFinderQueueFrameRoleButtonLeader, "LEADER")
	F.ReskinRole(LFGDungeonReadyStatusRolelessReady, "READY")

	hooksecurefunc("SetCheckButtonIsRadio", function(button)
		button:SetNormalTexture("")
		button:SetHighlightTexture(C.media.backdrop)
		button:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
		button:GetCheckedTexture():SetTexCoord(0, 1, 0, 1)
		button:SetPushedTexture("")
		button:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
		button:GetDisabledCheckedTexture():SetTexCoord(0, 1, 0, 1)
	end)

	local function updateRoleBonus(roleButton)
		if not roleButton.bg then return end
		if roleButton.shortageBorder and roleButton.shortageBorder:IsShown() then
			if roleButton.cover:IsShown() then
				roleButton.bg:SetBackdropBorderColor(.5, .45, .03)
			else
				roleButton.bg:SetBackdropBorderColor(1, .9, .06)
			end
		else
			roleButton.bg:SetBackdropBorderColor(0, 0, 0)
		end
	end

	hooksecurefunc("LFG_SetRoleIconIncentive", function(roleButton, incentiveIndex)
		if incentiveIndex then
			local tex
			if incentiveIndex == LFG_ROLE_SHORTAGE_PLENTIFUL then
				tex = "Interface\\Icons\\INV_Misc_Coin_19"
			elseif incentiveIndex == LFG_ROLE_SHORTAGE_UNCOMMON then
				tex = "Interface\\Icons\\INV_Misc_Coin_18"
			elseif incentiveIndex == LFG_ROLE_SHORTAGE_RARE then
				tex = "Interface\\Icons\\INV_Misc_Coin_17"
			end
			roleButton.incentiveIcon.texture:SetTexture(tex)
		end

		updateRoleBonus(roleButton)
	end)

	hooksecurefunc("LFG_EnableRoleButton", updateRoleBonus)

	for i = 1, 5 do
		local roleButton = _G["LFGDungeonReadyStatusIndividualPlayer"..i]
		roleButton.texture:SetTexture(C.media.roleIcons)
		F.CreateBDFrame(roleButton)
		if i == 1 then
			roleButton:SetPoint("LEFT", 7, 0)
		else
			roleButton:SetPoint("LEFT", _G["LFGDungeonReadyStatusIndividualPlayer"..(i-1)], "RIGHT", 4, 0)
		end
	end

	hooksecurefunc("LFGDungeonReadyStatusIndividual_UpdateIcon", function(button)
		local role = select(2, GetLFGProposalMember(button:GetID()))
		button.texture:SetTexCoord(F.GetRoleTexCoord(role))
	end)

	hooksecurefunc("LFGDungeonReadyStatusGrouped_UpdateIcon", function(button, role)
		button.texture:SetTexCoord(F.GetRoleTexCoord(role))
	end)
end)