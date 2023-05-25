local _, ns = ...
local B, C, L, DB = unpack(ns)

tinsert(C.defaultThemes, function()
	if not AuroraClassicDB.Tooltips then return end

	if not GameTooltip.StatusBar then
		GameTooltip.StatusBar = GameTooltipStatusBar
	end

	local function ReskinStatusBar(self)
		self.StatusBar:ClearAllPoints()
		self.StatusBar:SetPoint("BOTTOMLEFT", self.bg, "TOPLEFT", C.mult, 3)
		self.StatusBar:SetPoint("BOTTOMRIGHT", self.bg, "TOPRIGHT", -C.mult, 3)
		self.StatusBar:SetStatusBarTexture(DB.normTex)
		self.StatusBar:SetHeight(5)
		B.SetBD(self.StatusBar)
	end

	local fakeBg = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	fakeBg:SetBackdrop({ bgFile = DB.bdTex, edgeFile = DB.bdTex, edgeSize = 1 })
	local function __GetBackdrop() return fakeBg:GetBackdrop() end
	local function __GetBackdropColor() return 0, 0, 0, .7 end
	local function __GetBackdropBorderColor() return 0, 0, 0 end

	function B:ReskinTooltip()
		if self:IsForbidden() then return end

		if not self.auroraTip then
			self:HideBackdrop()
			self:DisableDrawLayer("BACKGROUND")
			self.bg = B.SetBD(self, .7)
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

	hooksecurefunc("GameTooltip_ShowStatusBar", function(self)
		if not self or self:IsForbidden() then return end
		if not self.statusBarPool then return end

		local bar = self.statusBarPool:GetNextActive()
		if bar and not bar.styled then
			B.StripTextures(bar)
			B.CreateBDFrame(bar, .25)
			bar:SetStatusBarTexture(DB.normTex)

			bar.styled = true
		end
	end)

	hooksecurefunc("GameTooltip_ShowProgressBar", function(self)
		if not self or self:IsForbidden() then return end
		if not self.progressBarPool then return end

		local bar = self.progressBarPool:GetNextActive()
		if bar and not bar.styled then
			B.StripTextures(bar.Bar)
			B.CreateBDFrame(bar.Bar, .25)
			bar.Bar:SetStatusBarTexture(DB.normTex)

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
		QuickKeybindTooltip,
		SettingsTooltip,
	}
	for _, tooltip in pairs(tooltips) do
		B.ReskinTooltip(tooltip)
	end

	C_Timer.After(5, function()
		-- BagSync
		if BSYC_EventAlertTooltip then
			B.ReskinTooltip(BSYC_EventAlertTooltip)
		end
		-- Libs
		if LibDBIconTooltip then
			B.ReskinTooltip(LibDBIconTooltip)
		end
		if AceConfigDialogTooltip then
			B.ReskinTooltip(AceConfigDialogTooltip)
		end
		-- TomTom
		if TomTomTooltip then
			B.ReskinTooltip(TomTomTooltip)
		end
		-- RareScanner
		if RSMapItemToolTip then
			B.ReskinTooltip(RSMapItemToolTip)
		end
		if LootBarToolTip then
			B.ReskinTooltip(LootBarToolTip)
		end
		-- Narcissus
		if NarciGameTooltip then
			B.ReskinTooltip(NarciGameTooltip)
		end
		-- Altoholic
		if AltoTooltip then
			B.ReskinTooltip(AltoTooltip)
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
		self.Icon:SetTexCoord(unpack(DB.TexCoord))
		self.bg = B.CreateBDFrame(self.Icon, 0)
		B.ReskinIconBorder(self.IconBorder)
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
					B.ReskinTooltip(MDT.tooltip)
					B.ReskinTooltip(MDT.pullTooltip)
					styledMDT = true
				end
			end)
		elseif addon == "BattlePetBreedID" then
			hooksecurefunc("BPBID_SetBreedTooltip", function(parent)
				if parent == FloatingBattlePetTooltip then
					B.ReskinTooltip(BPBID_BreedTooltip2)
				else
					B.ReskinTooltip(BPBID_BreedTooltip)
				end
			end)
		end
	end)
end)