local T, C, L, G = unpack(select(2, ...))

--====================================================--
--[[                 -- 单位框架 --                 ]]--
--====================================================--

local testmode = false

local textures = {
	bar = [[Interface\AddOns\AltzUI\media\statusbar.tga]],
	icon = [[Interface\AddOns\AltzUI\media\pushed.tga]],
}

local frame = PetBattleFrame
local wf = frame.WeatherFrame
local bf = frame.BottomFrame

frame.TopArtLeft:Hide()
frame.TopArtRight:Hide()
frame.TopVersus:Hide()

frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, -60)
frame.TopVersusText:SetPoint("TOP", frame, "TOP", 0, -46)

wf.Icon:Hide()
wf.Name:Hide()
wf.DurationShadow:Hide()
wf.Label:Hide()
wf.Duration:SetPoint("CENTER", wf, 0, 8)
wf:ClearAllPoints()
wf:SetPoint("TOP", UIParent, 0, -15)

for index, unit in pairs({frame.ActiveAlly, frame.ActiveEnemy}) do
	unit.HealthBarBG:Hide()
	unit.HealthBarFrame:Hide()
	unit.LevelUnderlay:Hide()
	unit.SpeedUnderlay:SetAlpha(0)
	unit.PetType:Hide()
	
	unit.Border:SetTexture(textures.icon)
	unit.Border:SetTexCoord(0, 1, 0, 1)
	unit.Border:SetPoint("TOPLEFT", unit.Icon, -1, 1)
	unit.Border:SetPoint("BOTTOMRIGHT", unit.Icon, 1, -1)
	
	unit.Border2:SetTexture(textures.icon)
	unit.Border2:SetTexCoord(0, 1, 0, 1)
	unit.Border2:SetPoint("TOPLEFT", unit.Icon, -1, 1)
	unit.Border2:SetPoint("BOTTOMRIGHT", unit.Icon, 1, -1)
	
	unit.Icon:SetSize(82, 82)
	T.createBackdrop(unit.Icon, .3, nil, unit)
	
	local hp = unit.ActualHealthBar
	hp:ClearAllPoints()
	hp:SetTexture(textures.bar)
	T.createBackdrop(hp, .3, nil, unit)
	
	if index == 1 then
		hp:SetPoint("BOTTOMLEFT", unit.Icon, "BOTTOMRIGHT", 10, 0)
		hp:SetVertexColor(.26, 1, .22)
	else	
		hp:SetPoint("BOTTOMRIGHT", unit.Icon, "BOTTOMLEFT", -10, 0)
		hp:SetVertexColor(1, .12, .24)
	end
		
	unit.HealthText:ClearAllPoints()
	unit.HealthText:SetPoint("CENTER", hp, "CENTER", 0, 0)

	unit.Level:SetFont(G.norFont, 16, "OUTLINE")
	unit.Level:SetTextColor(1, 1, 1)
	unit.Level:ClearAllPoints()
	if index == 1 then
		unit.Level:SetPoint("BOTTOMLEFT", hp, "TOPLEFT", 0, 4)
	else
		unit.Level:SetPoint("BOTTOMRIGHT", hp, "TOPRIGHT", 0, 4)
	end
	
	unit.PetTypeString = T.createtext(unit, "ARTWORK", 16, "OUTLINE", "CENTER")
	if index == 1 then
		unit.PetTypeString:SetPoint("LEFT", unit.Level, "RIGHT", 0, 0)
		unit.PetTypeString:SetJustifyH("LEFT")
	else
		unit.PetTypeString:SetPoint("RIGHT", unit.Level, "LEFT", 0, 0)
		unit.PetTypeString:SetJustifyH("RIGHT")
	end
	
	unit.Name:ClearAllPoints()
	if index == 1 then
		unit.Name:SetPoint("BOTTOMLEFT", unit.Level, "TOPLEFT", 0, 4)
	else
		unit.Name:SetPoint("BOTTOMRIGHT", unit.Level, "TOPRIGHT", 0, 4)
	end
	
end

for index, unit in pairs({frame.Ally2, frame.Ally3, frame.Enemy2, frame.Enemy3}) do
	unit.HealthBarBG:SetAlpha(0)
	unit.BorderDead:SetAlpha(0)
	unit.HealthDivider:SetAlpha(0)
	T.createBackdrop(unit, .3)
	
	if index == 1 then
		unit:ClearAllPoints()
		unit:SetPoint("TOPRIGHT", frame.ActiveAlly, "TOPLEFT", -10, 0)
	elseif index == 3 then
		unit:ClearAllPoints()
		unit:SetPoint("TOPLEFT", frame.ActiveEnemy, "TOPRIGHT", 10, 0)
	end
	
	unit.BorderAlive:SetTexture(textures.icon)
	unit.BorderAlive:SetTexCoord(0, 1, 0, 1)
	unit.BorderAlive:SetAllPoints(unit.Icon)
end

for i = 1, NUM_BATTLE_PETS_IN_BATTLE  do
	local unit = bf.PetSelectionFrame["Pet"..i]

	unit.HealthBarBG:Hide()
	unit.Framing:Hide()
	unit.HealthDivider:Hide()
	
	unit.Icon:SetTexCoord(.08, .92, .08, .92)
	T.createBackdrop(unit.Icon, .3, nil, unit)

	unit.ActualHealthBar:SetPoint("BOTTOMLEFT", unit.Icon, "BOTTOMRIGHT", 3, 0)
	unit.ActualHealthBar:SetTexture(G.media.blank)
	T.createBackdrop(unit.ActualHealthBar, .3, nil, unit)
	
	unit.Name:SetPoint("TOPLEFT", unit.Icon, "TOPRIGHT", 3, -3)
end

hooksecurefunc("PetBattleUnitFrame_UpdateDisplay", function(self)
	local petOwner = self.petOwner

	if (not petOwner) or self.petIndex > C_PetBattles.GetNumPets(petOwner) then return end

	if self.Icon then
		if petOwner == LE_BATTLE_PET_ALLY then
			self.Icon:SetTexCoord(.92, .08, .08, .92)
		else
			self.Icon:SetTexCoord(.08, .92, .08, .92)
		end
	end
end)

hooksecurefunc("PetBattleUnitFrame_UpdatePetType", function(self)
	if self.PetType and self.PetTypeString then
		local petType = C_PetBattles.GetPetType(self.petOwner, self.petIndex)
		self.PetTypeString:SetText(PET_TYPE_SUFFIX[petType])
	end
end)

hooksecurefunc("PetBattleAuraHolder_Update", function(self)
	if not self.petOwner or not self.petIndex then return end

	local nextFrame = 1
	for i = 1, C_PetBattles.GetNumAuras(self.petOwner, self.petIndex) do
		local _, _, turnsRemaining, isBuff = C_PetBattles.GetAuraInfo(self.petOwner, self.petIndex, i)
		if (isBuff and self.displayBuffs) or (not isBuff and self.displayDebuffs) then
			local frame = self.frames[nextFrame]

			frame.DebuffBorder:Hide()

			if not frame.reskinned then
				frame.Icon:SetTexCoord(.08, .92, .08, .92)
				frame.bg = T.createBackdrop(frame.Icon, .3, nil, frame)
			end
			
			if isBuff then
				frame.bg:SetBackdropBorderColor(0, 1, 0)
			else
				frame.bg:SetBackdropBorderColor(1, 0, 0)
			end
			
			frame.Duration:SetFont(G.norFont, 8, "OUTLINE")
			frame.Duration:SetShadowOffset(0, 0)
			frame.Duration:ClearAllPoints()
			frame.Duration:SetPoint("BOTTOM", frame.Icon, 1, -1)

			if turnsRemaining > 0 then
				frame.Duration:SetText(turnsRemaining)
			end
			
			nextFrame = nextFrame + 1
		end
	end
end)

if testmode then 
	for index, unit in pairs({frame.ActiveAlly, frame.ActiveEnemy}) do
		unit.Name:SetText("Lol pets")
		unit.HealthText:SetText("140/200")
		unit.Level:SetText("5")
		unit.PetTypeString:SetText("Martian")
		unit.Icon:SetTexture(135940)	
	end
	for index, unit in pairs({frame.Ally2, frame.Ally3, frame.Enemy2, frame.Enemy3}) do
		unit:Show()
		unit.Icon:SetTexture(135940)
		--unit.BorderAlive:Show()
	end
	frame:Show()
end

--====================================================--
--[[                  -- 动作条 --                  ]]--
--====================================================--

bf.RightEndCap:Hide()
bf.LeftEndCap:Hide()
bf.Background:Hide()
bf.Delimiter:Hide()
bf.TurnTimer.TimerBG:SetTexture("")
bf.TurnTimer.ArtFrame:SetTexture("")
bf.TurnTimer.ArtFrame2:SetTexture("")
bf.FlowFrame.LeftEndCap:Hide()
bf.FlowFrame.RightEndCap:Hide()
select(3, bf.FlowFrame:GetRegions()):Hide()
bf.MicroButtonFrame:Hide()

PetBattleFrameXPBarLeft:Hide()
PetBattleFrameXPBarRight:Hide()
PetBattleFrameXPBarMiddle:Hide()

local bar = CreateFrame("Frame", "AltzPetBattleActionBar", UIParent, "SecureHandlerStateTemplate")
bar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 50)
bar:SetSize(6 * 43, 40)
RegisterStateDriver(bar, "visibility", "[petbattle] show; hide")

bf.TurnTimer.SkipButton:SetParent(bar)
bf.TurnTimer.SkipButton:SetWidth(bar:GetWidth())
bf.TurnTimer.SkipButton:ClearAllPoints()
bf.TurnTimer.SkipButton:SetPoint("BOTTOM", bar, "TOP", 0, 2)
bf.TurnTimer.SkipButton.ClearAllPoints = T.dummy
bf.TurnTimer.SkipButton.SetPoint = T.dummy
T.ReskinButton(bf.TurnTimer.SkipButton)

bf.TurnTimer.Bar:ClearAllPoints()
bf.TurnTimer.Bar:SetPoint("LEFT")

bf.TurnTimer:SetParent(bar)
bf.TurnTimer:SetSize(bf.TurnTimer.SkipButton:GetWidth() - 3, bf.TurnTimer.SkipButton:GetHeight())
bf.TurnTimer:ClearAllPoints()
bf.TurnTimer:SetPoint("BOTTOM", bf.TurnTimer.SkipButton, "TOP", 0, 5)
bf.TurnTimer.bg = T.createBackdrop(bf.TurnTimer, .3)

bf.xpBar:SetParent(bar)
bf.xpBar:SetWidth(bar:GetWidth() - 3)
bf.xpBar:ClearAllPoints()
bf.xpBar:SetPoint("BOTTOM", bf.TurnTimer, "TOP", 0, 5)
bf.xpBar:SetStatusBarTexture(textures.bar)
bf.xpBar.bg = T.createBackdrop(bf.xpBar)
	
for i = 7, 12 do
	select(i, bf.xpBar:GetRegions()):Hide()
end

hooksecurefunc("PetBattlePetSelectionFrame_Show", function()
	bf.PetSelectionFrame:ClearAllPoints()
	bf.PetSelectionFrame:SetPoint("BOTTOM", bf.xpBar, "TOP", 0, 8)
end)

hooksecurefunc("PetBattleFrame_UpdatePassButtonAndTimer", function()
	local pveBattle = C_PetBattles.IsPlayerNPC(LE_BATTLE_PET_ENEMY)

	bf.TurnTimer.bg:SetShown(not pveBattle)

	bf.xpBar:ClearAllPoints()

	if pveBattle then
		bf.xpBar:SetPoint("BOTTOM", bf.TurnTimer.SkipButton, "TOP", 0, 2)
	else
		bf.xpBar:SetPoint("BOTTOM", bf.TurnTimer, "TOP", 0, 4)
	end
end)

local function stylePetBattleButton(bu)
	if bu.reskinned then return end

	bu:SetNormalTexture("")
	bu:SetPushedTexture("")
	bu:SetHighlightTexture("")

	T.createBackdrop(bu)

	bu.Icon:SetDrawLayer("BACKGROUND", 2)
	bu.Icon:SetTexCoord(.08, .92, .08, .92)

	bu.CooldownShadow:SetAllPoints()
	bu.CooldownFlash:SetAllPoints()

	bu.SelectedHighlight:SetTexture(1, 1, 0)
	bu.SelectedHighlight:SetDrawLayer("BACKGROUND")
	bu.SelectedHighlight:SetAllPoints()

	bu.HotKey:SetFont(G.norFont, 12, "OUTLINE")
	bu.HotKey:SetJustifyH("CENTER")
	bu.HotKey:ClearAllPoints()
	bu.HotKey:SetPoint("TOP", 1, -2)

	bu.Cooldown:SetFont(G.norFont, 20, "OUTLINE")
	bu.Cooldown:SetJustifyH("CENTER")
	bu.Cooldown:SetDrawLayer("OVERLAY", 5)
	bu.Cooldown:SetTextColor(1, 1, 1)
	bu.Cooldown:SetShadowOffset(0, 0)
	bu.Cooldown:ClearAllPoints()
	bu.Cooldown:SetPoint("BOTTOM", 1, -1)

	bu.BetterIcon:SetSize(45, 45)
	bu.BetterIcon:ClearAllPoints()
	bu.BetterIcon:SetPoint("BOTTOM", 6, -9)

	bu.reskinned = true
end

local first = true
hooksecurefunc("PetBattleFrame_UpdateActionBarLayout", function(self)
	for i = 1, NUM_BATTLE_PET_ABILITIES do
		local bu = bf.abilityButtons[i]
		stylePetBattleButton(bu)
		bu:SetParent(bar)
		bu:SetSize(40, 40)
		bu:ClearAllPoints()
		if i == 1 then
			bu:SetPoint("BOTTOMLEFT", bar)
		else
			local previous = bf.abilityButtons[i-1]
			bu:SetPoint("LEFT", previous, "RIGHT", 3, 0)
		end
	end

	stylePetBattleButton(bf.SwitchPetButton)
	stylePetBattleButton(bf.CatchButton)
	stylePetBattleButton(bf.ForfeitButton)

	if first then
		first = false
		bf.SwitchPetButton:SetScript("OnClick", function()
			if bf.PetSelectionFrame:IsShown() then
				PetBattlePetSelectionFrame_Hide(bf.PetSelectionFrame)
			else
				PetBattlePetSelectionFrame_Show(bf.PetSelectionFrame)
			end
		end)
	end

	bf.SwitchPetButton:SetParent(bar)
	bf.SwitchPetButton:SetSize(40, 40)
	bf.SwitchPetButton:ClearAllPoints()
	bf.SwitchPetButton:SetPoint("LEFT", bf.abilityButtons[NUM_BATTLE_PET_ABILITIES], "RIGHT", 3, 0)
	bf.SwitchPetButton:SetCheckedTexture(textures.checked)
	
	bf.CatchButton:SetParent(bar)
	bf.CatchButton:SetSize(40, 40)
	bf.CatchButton:ClearAllPoints()
	bf.CatchButton:SetPoint("LEFT", bf.SwitchPetButton, "RIGHT", 3, 0)
	
	bf.ForfeitButton:SetParent(bar)
	bf.ForfeitButton:SetSize(40, 40)
	bf.ForfeitButton:ClearAllPoints()
	bf.ForfeitButton:SetPoint("LEFT", bf.CatchButton, "RIGHT", 3, 0)
end)