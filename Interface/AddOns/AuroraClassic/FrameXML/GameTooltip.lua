local F, C = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	if not AuroraClassicDB.Tooltips then return end

	GameTooltip.StatusBar = GameTooltipStatusBar

	local function ReskinStatusBar(self)
		self.StatusBar:ClearAllPoints()
		self.StatusBar:SetPoint("BOTTOMLEFT", self.bg, "TOPLEFT", C.mult, 3)
		self.StatusBar:SetPoint("BOTTOMRIGHT", self.bg, "TOPRIGHT", -C.mult, 3)
		self.StatusBar:SetStatusBarTexture(C.normTex)
		self.StatusBar:SetHeight(5)
		F.SetBD(self.StatusBar)
	end

	local fakeBg = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	fakeBg:SetBackdrop({ bgFile = C.bdTex, edgeFile = C.bdTex, edgeSize = 1 })
	local function __GetBackdrop() return fakeBg:GetBackdrop() end
	local function __GetBackdropColor() return 0, 0, 0, .7 end
	local function __GetBackdropBorderColor() return 0, 0, 0 end

	function F:ReskinTooltip()
		if self:IsForbidden() then return end

		if not self.auroraTip then
			if self.SetBackdrop then self:SetBackdrop(nil) end
			self:DisableDrawLayer("BACKGROUND")
			self.bg = F.SetBD(self, .7)
			self.bg:SetInside(self)
			self.bg:SetFrameLevel(self:GetFrameLevel())
			if self.StatusBar then ReskinStatusBar(self) end

			if self.GetBackdrop then
				self.GetBackdrop = __GetBackdrop
				self.GetBackdropColor = __GetBackdropColor
				self.GetBackdropBorderColor = __GetBackdropBorderColor
			end

			self.auroraTip = true
		end
	end

	hooksecurefunc("SharedTooltip_SetBackdropStyle", function(self)
		if not self.auroraTip then return end
		self:SetBackdrop(nil)
	end)

	hooksecurefunc("GameTooltip_ShowStatusBar", function(self)
		if not self or self:IsForbidden() then return end
		if not self.statusBarPool then return end
	
		local bar = self.statusBarPool:GetNextActive()
		if bar and not bar.styled then
			F.StripTextures(bar)
			F.CreateBDFrame(bar, .25)
			bar:SetStatusBarTexture(C.normTex)
	
			bar.styled = true
		end
	end)

	hooksecurefunc("GameTooltip_ShowProgressBar", function(self)
		if not self or self:IsForbidden() then return end
		if not self.progressBarPool then return end
	
		local bar = self.progressBarPool:GetNextActive()
		if bar and not bar.styled then
			F.StripTextures(bar.Bar)
			F.CreateBDFrame(bar.Bar, .25)
			bar.Bar:SetStatusBarTexture(C.normTex)
	
			bar.styled = true
		end
	end)

	local tooltips = {
		ChatMenu,
		EmoteMenu,
		LanguageMenu,
		VoiceMacroMenu,
		GameTooltip,
		EmbeddedItemTooltip,
		ItemRefTooltip,
		ItemRefShoppingTooltip1,
		ItemRefShoppingTooltip2,
		ShoppingTooltip1,
		ShoppingTooltip2,
		AutoCompleteBox,
		FriendsTooltip,
		QuestScrollFrame.StoryTooltip,
		QuestScrollFrame.CampaignTooltip,
		GeneralDockManagerOverflowButtonList,
		ReputationParagonTooltip,
		NamePlateTooltip,
		QueueStatusFrame,
		FloatingGarrisonFollowerTooltip,
		FloatingGarrisonFollowerAbilityTooltip,
		FloatingGarrisonMissionTooltip,
		GarrisonFollowerAbilityTooltip,
		GarrisonFollowerTooltip,
		FloatingGarrisonShipyardFollowerTooltip,
		GarrisonShipyardFollowerTooltip,
		BattlePetTooltip,
		PetBattlePrimaryAbilityTooltip,
		PetBattlePrimaryUnitTooltip,
		FloatingBattlePetTooltip,
		FloatingPetBattleAbilityTooltip,
		IMECandidatesFrame,
		QuickKeybindTooltip
	}
	for _, tooltip in pairs(tooltips) do
		F.ReskinTooltip(tooltip)
	end

	C_Timer.After(5, function()
		if LibDBIconTooltip then
			F.ReskinTooltip(LibDBIconTooltip)
		end
	end)

	PetBattlePrimaryUnitTooltip.Delimiter:SetColorTexture(0, 0, 0)
	PetBattlePrimaryUnitTooltip.Delimiter:SetHeight(1)
	PetBattlePrimaryAbilityTooltip.Delimiter1:SetHeight(1)
	PetBattlePrimaryAbilityTooltip.Delimiter1:SetColorTexture(0, 0, 0)
	PetBattlePrimaryAbilityTooltip.Delimiter2:SetHeight(1)
	PetBattlePrimaryAbilityTooltip.Delimiter2:SetColorTexture(0, 0, 0)
	FloatingPetBattleAbilityTooltip.Delimiter1:SetHeight(1)
	FloatingPetBattleAbilityTooltip.Delimiter1:SetColorTexture(0, 0, 0)
	FloatingPetBattleAbilityTooltip.Delimiter2:SetHeight(1)
	FloatingPetBattleAbilityTooltip.Delimiter2:SetColorTexture(0, 0, 0)
	FloatingBattlePetTooltip.Delimiter:SetColorTexture(0, 0, 0)
	FloatingBattlePetTooltip.Delimiter:SetHeight(1)

	-- Tooltip rewards icon
	local function reskinRewardIcon(self)
		self.Icon:SetTexCoord(unpack(C.TexCoord))
		self.bg = F.CreateBDFrame(self.Icon, 0)
		F.ReskinIconBorder(self.IconBorder)
	end

	reskinRewardIcon(GameTooltip.ItemTooltip)
	reskinRewardIcon(EmbeddedItemTooltip.ItemTooltip)

	-- Other addons
	local listener = CreateFrame("Frame")
	listener:RegisterEvent("ADDON_LOADED")
	listener:SetScript("OnEvent", function(_, _, addon)
		if addon == "MythicDungeonTools" then
			local styledMDT
			hooksecurefunc(MDT, "ShowInterface", function()
				if not styledMDT then
					F.ReskinTooltip(MDT.tooltip)
					F.ReskinTooltip(MDT.pullTooltip)
					styledMDT = true
				end
			end)
		elseif addon == "BattlePetBreedID" then
			hooksecurefunc("BPBID_SetBreedTooltip", function(parent)
				if parent == FloatingBattlePetTooltip then
					F.ReskinTooltip(BPBID_BreedTooltip2)
				else
					F.ReskinTooltip(BPBID_BreedTooltip)
				end
			end)
		end
	end)
end)