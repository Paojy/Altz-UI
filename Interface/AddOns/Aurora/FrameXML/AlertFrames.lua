local F, C = unpack(select(2, ...))

-- GuildChallengeAlertSystem = AlertFrame:AddSimpleAlertFrameSubSystem(GuildChallengeAlertFrame, GuildChallengeAlertFrame_SetUp)
-- DungeonCompletionAlertSystem = AlertFrame:AddSimpleAlertFrameSubSystem(DungeonCompletionAlertFrame, DungeonCompletionAlertFrame_SetUp)
-- ScenarioAlertSystem = AlertFrame:AddSimpleAlertFrameSubSystem(ScenarioAlertFrame, ScenarioAlertFrame_SetUp)
-- InvasionAlertSystem = AlertFrame:AddSimpleAlertFrameSubSystem(ScenarioLegionInvasionAlertFrame, ScenarioLegionInvasionAlertFrame_SetUp, ScenarioLegionInvasionAlertFrame_Coalesce)
-- DigsiteCompleteAlertSystem = AlertFrame:AddSimpleAlertFrameSubSystem(DigsiteCompleteToastFrame, DigsiteCompleteToastFrame_SetUp)
-- StorePurchaseAlertSystem = AlertFrame:AddSimpleAlertFrameSubSystem(StorePurchaseAlertFrame, StorePurchaseAlertFrame_SetUp)
-- GarrisonBuildingAlertSystem = AlertFrame:AddSimpleAlertFrameSubSystem(GarrisonBuildingAlertFrame, GarrisonBuildingAlertFrame_SetUp)
-- GarrisonMissionAlertSystem = AlertFrame:AddSimpleAlertFrameSubSystem(GarrisonMissionAlertFrame, GarrisonMissionAlertFrame_SetUp)
-- GarrisonShipMissionAlertSystem = AlertFrame:AddSimpleAlertFrameSubSystem(GarrisonShipMissionAlertFrame, GarrisonMissionAlertFrame_SetUp)
-- GarrisonRandomMissionAlertSystem = AlertFrame:AddSimpleAlertFrameSubSystem(GarrisonRandomMissionAlertFrame, GarrisonRandomMissionAlertFrame_SetUp)
-- GarrisonFollowerAlertSystem = AlertFrame:AddSimpleAlertFrameSubSystem(GarrisonFollowerAlertFrame, GarrisonFollowerAlertFrame_SetUp)
-- GarrisonShipFollowerAlertSystem = AlertFrame:AddSimpleAlertFrameSubSystem(GarrisonShipFollowerAlertFrame, GarrisonShipFollowerAlertFrame_SetUp)
-- GarrisonTalentAlertSystem = AlertFrame:AddSimpleAlertFrameSubSystem(GarrisonTalentAlertFrame, GarrisonTalentAlertFrame_SetUp)
-- WorldQuestCompleteAlertSystem = AlertFrame:AddSimpleAlertFrameSubSystem(WorldQuestCompleteAlertFrame, WorldQuestCompleteAlertFrame_SetUp, WorldQuestCompleteAlertFrame_Coalesce)
-- LegendaryItemAlertSystem = AlertFrame:AddSimpleAlertFrameSubSystem(LegendaryItemAlertFrame, LegendaryItemAlertFrame_SetUp)
-- AchievementAlertSystem = AlertFrame:AddQueuedAlertFrameSubSystem("AchievementAlertFrameTemplate", AchievementAlertFrame_SetUp, 2, 6);
-- CriteriaAlertSystem = AlertFrame:AddQueuedAlertFrameSubSystem("CriteriaAlertFrameTemplate", CriteriaAlertFrame_SetUp, 2, 0);
-- LootAlertSystem = AlertFrame:AddQueuedAlertFrameSubSystem("LootWonAlertFrameTemplate", LootWonAlertFrame_SetUp, 6, math.huge);
-- LootUpgradeAlertSystem = AlertFrame:AddQueuedAlertFrameSubSystem("LootUpgradeFrameTemplate", LootUpgradeFrame_SetUp, 6, math.huge);
-- MoneyWonAlertSystem = AlertFrame:AddQueuedAlertFrameSubSystem("MoneyWonAlertFrameTemplate", MoneyWonAlertFrame_SetUp, 6, math.huge);
-- NewRecipeLearnedAlertSystem = AlertFrame:AddQueuedAlertFrameSubSystem("NewRecipeLearnedAlertFrameTemplate", NewRecipeLearnedAlertFrame_SetUp, 2, 6);
	
--[[:SetTexture(135940)

local f = CreateFrame("Button", "Azt", UIParent)
f:ClearAllPoints()
f:SetPoint("CENTER", UIParent,"CENTER")
f.SetPoint = F.dummy
f:Show()
f:SetScript("OnClick", nil)
f:SetScript("OnLeave", nil)

OnPlay
<AnimationGroup parentKey="animIn">
	<Alpha fromAlpha="1" toAlpha="0" duration="0" order="1"/>
	<Alpha fromAlpha="0" toAlpha="1" duration="0.2" order="2"/>
</AnimationGroup>

OnFinished
<AnimationGroup name="$parentAnimIn" parentKey="animIn">
	<Alpha fromAlpha="1" toAlpha="0" duration="0" order="1"/>
	<Alpha fromAlpha="0" toAlpha="1" duration="0.2" order="2"/>
</AnimationGroup>

AchievementFrame_LoadUI()
AchievementAlertSystem:ShowAlert(839)
CriteriaAlertSystem:ShowAlert(1470460934)
NewRecipeLearnedAlertSystem:ShowAlert(196387)
]]

local function TakeScreen(delay, func, ...) 
	local waitTable = {} 
	local waitFrame = CreateFrame("Frame", "WaitFrame", UIParent) 
	waitFrame:SetScript("onUpdate", function (self, elapse) 
		local count = #waitTable 
		local i = 1 
		while (i <= count) do 
			local waitRecord = tremove(waitTable, i) 
			local d = tremove(waitRecord, 1) 
			local f = tremove(waitRecord, 1) 
			local p = tremove(waitRecord, 1) 
			if (d > elapse) then 
				tinsert(waitTable, i, {d-elapse, f, p}) 
				i = i + 1 
			else 
				count = count - 1 
				f(unpack(p)) 
			end 
		end 
	end) 
	tinsert(waitTable, {delay, func, {...} }) 
end

tinsert(C.themes["Aurora"], function()
	hooksecurefunc(AlertFrame, "AddAlertFrame", function(self, f)
		if f.queue == AchievementAlertSystem then
			if not f.skin then
				F.CreateBD(f, .5) 
				f.animIn:HookScript("OnPlay", function() f:SetBackdropColor(0, 0, 0, .5) end)
				f.animIn:HookScript("OnFinished", function() f:SetBackdropColor(0, 0, 0, .5) end)
				
				f.GuildBanner:SetTexture(nil)
				f.OldAchievement:SetTexture(nil)
				f.GuildBorder:SetTexture(nil)

				f.Unlocked:SetFont(C.media.font, 10, "OUTLINE")
				f.Unlocked:SetShadowOffset(0, 0)
				f.Unlocked:SetTextColor(1,1,1)

				f.Name:SetFont(C.media.font, 15, "OUTLINE")
				f.Name:SetShadowOffset(0, 0)
				f.Name:SetTextColor(1,1,1)

				f.GuildName:SetFont(C.media.font, 15, "OUTLINE")
				f.GuildName:SetShadowOffset(0, 0)
				f.GuildName:SetTextColor(1,1,1)
				f.GuildName:ClearAllPoints()

				f.Icon.Bling:SetTexture(nil)
				
				f.Icon.Texture:SetTexCoord(.1, .9, .1, .9)
				F.CreateBG(f.Icon.Texture)
	
				f.Shield.Points:SetFont(C.media.font, 20, "OUTLINE")
				f.Shield.Points:SetShadowOffset(0, 0)
				f.Shield.Points:SetTextColor(1,1,0)
				
				f.skin = true
			end
			
			f.Background:SetTexture(nil)
			f.Icon.Overlay:SetTexture(nil)
			f.glow:SetTexture(nil)
			f.shine:SetTexture(nil)
			f.Shield.Icon:SetTexture(nil)
			
		elseif f.queue == CriteriaAlertSystem then
			if not f.skin then
				F.CreateBD(f, .5) 
				f.animIn:HookScript("OnPlay", function() f:SetBackdropColor(0, 0, 0, .5) end)
				f.animIn:HookScript("OnFinished", function() f:SetBackdropColor(0, 0, 0, .5) end)
				
				f.Background:SetTexture(nil)
				
				f.Unlocked:SetFont(C.media.font, 10, "OUTLINE")
				f.Unlocked:SetShadowOffset(0, 0)
				f.Unlocked:SetTextColor(1,1,1)

				f.Name:SetFont(C.media.font, 15, "OUTLINE")
				f.Name:SetShadowOffset(0, 0)
				f.Name:SetTextColor(1,1,1)

				f.Icon.Bling:SetTexture(nil)
				f.Icon.Overlay:SetTexture(nil)
				f.Icon.Texture:SetTexCoord(.1, .9, .1, .9)
				f.Icon.Texture:ClearAllPoints()
				f.Icon.Texture:SetPoint("TOPLEFT", f, "TOPLEFT")
				f.Icon.Texture:SetSize(52, 52)
				f.Icon.Texture:SetDrawLayer("ARTWORK")
				F.CreateBG(f.Icon.Texture)

				f.glow:SetTexture(nil)
				f.shine:SetTexture(nil)
				
				f.skin = true
			end
			
		elseif f.queue == LootAlertSystem then
			if not f.skin then
				F.CreateBD(f, .5) 
				f.animIn:HookScript("OnPlay", function() f:SetBackdropColor(0, 0, 0, .5) end)
				f.animIn:HookScript("OnFinished", function() f:SetBackdropColor(0, 0, 0, .5) end)
				f:HookScript("OnEnter", function() f:SetBackdropColor(0, 0, 0, .5) end)
				
				f.shine:SetTexture(nil)
				f.glow:SetTexture(nil)
				
				f.Icon:SetDrawLayer("ARTWORK")
				f.Icon:SetTexCoord(.08, .92, .08, .92)
				F.CreateBG(f.Icon)
				
				f.SpecRing:SetTexture(nil)
				f.SpecIcon:SetTexCoord(.08, .92, .08, .92)
				f.SpecIcon.bg = F.CreateBG(f.SpecIcon)
				f.SpecIcon.bg:SetDrawLayer("BORDER", 2)
				
				f.skin = true
			end
			
			f.SpecIcon.bg:SetShown(f.SpecIcon:IsShown() and f.SpecIcon:GetTexture() ~= nil)
			f.Background:SetTexture(nil)
			f.PvPBackground:SetTexture(nil)
			f.BGAtlas:SetTexture(nil)			
			f.IconBorder:SetTexture(nil)
			
		elseif f.queue == LootUpgradeAlertSystem then
			if not f.skin then
				F.CreateBD(f, .5) 
				f.animIn:HookScript("OnPlay", function() f:SetBackdropColor(0, 0, 0, .5) end)
				f.animIn:HookScript("OnFinished", function() f:SetBackdropColor(0, 0, 0, .5) end)
				f:HookScript("OnEnter", function() f:SetBackdropColor(0, 0, 0, .5) end)
				
				f.Background:SetTexture(nil)
				f.Sheen:SetTexture(nil)
				f.BorderGlow:SetTexture(nil)
				
				f.Icon:SetDrawLayer("BORDER", 5)
				f.Icon:SetTexCoord(.08, .92, .08, .92)
				F.CreateBG(f.Icon)
				
				f.Icon:ClearAllPoints()
				f.Icon:SetPoint("CENTER", f.BaseQualityBorder)
				
				f.BaseQualityBorder:SetSize(52, 52)
				f.BaseQualityBorder:SetTexture(C.media.backdrop)
				f.UpgradeQualityBorder:SetTexture(C.media.backdrop)
				f.UpgradeQualityBorder:SetSize(52, 52)
				
				f.skin = true
			end
			
			f.BaseQualityBorder:SetTexture(nil)
			f.UpgradeQualityBorder:SetTexture(nil)
			
		elseif f.queue == MoneyWonAlertSystem then
			if not f.skin then
				F.CreateBD(f, .5) 
				f.animIn:HookScript("OnPlay", function() f:SetBackdropColor(0, 0, 0, .5) end)
				f.animIn:HookScript("OnFinished", function() f:SetBackdropColor(0, 0, 0, .5) end)
				
				f.Background:SetTexture(nil)
				
				f.Icon:SetTexCoord(.1, .9, .1, .9)
				f.Icon:SetDrawLayer("ARTWORK")
				F.CreateBG(f.Icon)
				f.IconBorder:SetTexture(nil)
				
				f.Label:SetFont(C.media.font, 12, "OUTLINE")
				f.Label:SetShadowOffset(0, 0)
				f.Label:SetTextColor(1,1,1)
				
				f.Amount:SetFont(C.media.font, 15, "OUTLINE")
				f.Amount:SetShadowOffset(0, 0)
				f.Amount:SetTextColor(1,1,1)
				
				f.skin = true
			end
			
		elseif f.queue == NewRecipeLearnedAlertSystem then
			if not f.skin then
				F.CreateBD(f, .5) 
				f.animIn:HookScript("OnPlay", function() f:SetBackdropColor(0, 0, 0, .5) end)
				f.animIn:HookScript("OnFinished", function() f:SetBackdropColor(0, 0, 0, .5) end)
		
				select(1, f:GetRegions()):SetTexture(nil)
				f.Icon:SetDrawLayer("ARTWORK")
				
				F.CreateBG(f.Icon)

				f.glow:SetTexture(nil)
				f.shine:SetTexture(nil)

				f.skin = true
			end
			
			f.Icon:SetMask(nil)
			f.Icon:SetTexCoord(.1, .9, .1, .9)
		end
	end)
	
	-- BonusRollLootWonFrame
	
	hooksecurefunc("LootWonAlertFrame_SetUp", function(f)
		if not f.skin then
			F.CreateBD(f, .5) 
			f.animIn:HookScript("OnPlay", function() f:SetBackdropColor(0, 0, 0, .5) end)
			f.animIn:HookScript("OnFinished", function() f:SetBackdropColor(0, 0, 0, .5) end)
							
			f.shine:SetTexture(nil)
			f.glow:SetTexture(nil)
			
			f.Icon:SetDrawLayer("ARTWORK")
			f.Icon:SetTexCoord(.08, .92, .08, .92)
			F.CreateBG(f.Icon)
			
			f.SpecRing:SetTexture(nil)
			f.SpecIcon:SetTexCoord(.08, .92, .08, .92)
			f.SpecIcon.bg = F.CreateBG(f.SpecIcon)
			f.SpecIcon.bg:SetDrawLayer("BORDER", 2)
			
			f.skin = true
		end
		
		f.SpecIcon.bg:SetShown(f.SpecIcon:IsShown() and f.SpecIcon:GetTexture() ~= nil)
		f.Background:SetTexture(nil)
		f.PvPBackground:SetTexture(nil)
		f.BGAtlas:SetTexture(nil)			
		f.IconBorder:SetTexture(nil)
	end)
	
	-- BonusRollMoneyWonFrame
	
	hooksecurefunc("MoneyWonAlertFrame_SetUp", function(f)	
		if not f.skin then
			F.CreateBD(f, .5) 
			f.animIn:HookScript("OnPlay", function() f:SetBackdropColor(0, 0, 0, .5) end)
			f.animIn:HookScript("OnFinished", function() f:SetBackdropColor(0, 0, 0, .5) end)
			
			f.Background:SetTexture(nil)
			
			f.Icon:SetTexCoord(.1, .9, .1, .9)
			f.Icon:SetDrawLayer("ARTWORK")
			F.CreateBG(f.Icon)
			f.IconBorder:SetTexture(nil)
			
			f.Label:SetFont(C.media.font, 12, "OUTLINE")
			f.Label:SetShadowOffset(0, 0)
			f.Label:SetTextColor(1,1,1)
			
			f.Amount:SetFont(C.media.font, 15, "OUTLINE")
			f.Amount:SetShadowOffset(0, 0)
			f.Amount:SetTextColor(1,1,1)
			
			f.skin = true
		end
	end)
	
	-- Guild challenges

	local challenge = CreateFrame("Frame", nil, GuildChallengeAlertFrame)
	challenge:SetFrameLevel(GuildChallengeAlertFrame:GetFrameLevel()-1)
	challenge:SetPoint("TOPLEFT", 8, -12)
	challenge:SetPoint("BOTTOMRIGHT", -8, 13)
	challenge:SetFrameLevel(GuildChallengeAlertFrame:GetFrameLevel()-1)
	F.CreateBD(challenge, .5)
	GuildChallengeAlertFrame.animIn:HookScript("OnPlay", function() challenge:SetBackdropColor(0, 0, 0, .5) end)
	GuildChallengeAlertFrame.animIn:HookScript("OnFinished", function() challenge:SetBackdropColor(0, 0, 0, .5) end)
				
	GuildChallengeAlertFrameEmblemBackground:SetTexture(nil)
	select(2, GuildChallengeAlertFrame:GetRegions()):SetTexture(nil)
	GuildChallengeAlertFrameEmblemBorder:SetTexture(nil)
	
	GuildChallengeAlertFrameEmblemIcon:SetTexCoord(.1, .9, .1, .9)
	F.CreateBG(GuildChallengeAlertFrameEmblemIcon)
	
	local fs = select(5, GuildChallengeAlertFrame:GetRegions())
	fs:SetFont(C.media.font, 14, "OUTLINE")
	fs:SetShadowOffset(0, 0)
	fs:SetTextColor(1,1,1)
	
	GuildChallengeAlertFrameType:SetFont(C.media.font, 12, "OUTLINE")
	GuildChallengeAlertFrameType:SetShadowOffset(0, 0)
	GuildChallengeAlertFrameType:SetTextColor(1,1,1)
	
	GuildChallengeAlertFrameCount:SetFont(C.media.font, 15, "OUTLINE")
	GuildChallengeAlertFrameCount:SetShadowOffset(0, 0)
	GuildChallengeAlertFrameCount:SetTextColor(1,1,0)
	
	GuildChallengeAlertFrameGlow:SetTexture(nil)
	GuildChallengeAlertFrameShine:SetTexture(nil)
	
	-- Dungeon completion rewards
	
	DungeonCompletionAlertFrame.dungeonTexture:SetTexCoord(.1, .9, .1, .9)
	F.CreateBG(DungeonCompletionAlertFrame.dungeonTexture)

	DungeonCompletionAlertFrame.raidArt:SetTexture(nil)
	DungeonCompletionAlertFrame.dungeonArt1:SetTexture(nil)
	DungeonCompletionAlertFrame.dungeonArt2:SetTexture(nil)
	DungeonCompletionAlertFrame.dungeonArt3:SetTexture(nil)
	DungeonCompletionAlertFrame.dungeonArt4:SetTexture(nil)

	local fs = select(7, DungeonCompletionAlertFrame:GetRegions())
	fs:SetFont(C.media.font, 10, "OUTLINE")
	fs:SetShadowOffset(0, 0)
	fs:SetTextColor(1,1,1)

	local InstanceName = select(8, DungeonCompletionAlertFrame:GetRegions())
	InstanceName:SetFont(C.media.font, 15, "OUTLINE")
	InstanceName:SetShadowOffset(0, 0)
	InstanceName:SetTextColor(1,1,1)

	DungeonCompletionAlertFrame.heroicIcon:SetTexture(nil)
	DungeonCompletionAlertFrame.glowFrame.glow:SetTexture(nil)
	DungeonCompletionAlertFrame.shine:SetTexture(nil)
	
	local DungeonCompletionAlertFramebg = CreateFrame("Frame", nil, DungeonCompletionAlertFrame)
	DungeonCompletionAlertFramebg:SetPoint("TOPLEFT", 0, -8)
	DungeonCompletionAlertFramebg:SetPoint("BOTTOMRIGHT", 0, 0)
	DungeonCompletionAlertFramebg:SetFrameLevel(DungeonCompletionAlertFrame:GetFrameLevel()-1)
	F.CreateBD(DungeonCompletionAlertFramebg)
	
	DungeonCompletionAlertFrame:SetScript("OnShow", function(f)
		local name, typeID, subtypeID, textureFilename, moneyBase, moneyVar, experienceBase, experienceVar, numStrangers, numRewards = GetLFGCompletionReward()
		
		for i = 1, numRewards+1 do
			local reward = _G["DungeonCompletionAlertFrameReward"..i]
			if reward then
				select(2, reward:GetRegions()):SetTexture(nil)
				reward.texture:SetTexCoord(.1, .9, .1, .9)
				reward.texture:ClearAllPoints()
				reward.texture:SetPoint("TOPLEFT", 6, -6)
				reward.texture:SetPoint("BOTTOMRIGHT", -6, 6)
				F.CreateBG(reward.texture)
				
				if i == 1 then
					reward:SetPoint("TOPRIGHT", f, "TOPRIGHT", -10, 0)
				else
					reward:SetPoint("RIGHT", _G["DungeonCompletionAlertFrameReward"..(i-1)], "LEFT", 0, 0)
				end
			end
		end
	end)
	
	-- Scenario alert
	F.CreateBD(ScenarioAlertFrame, .5)
	ScenarioAlertFrame.animIn:HookScript("OnPlay", function() ScenarioAlertFrame:SetBackdropColor(0, 0, 0, .5) end)
	ScenarioAlertFrame.animIn:HookScript("OnFinished", function() ScenarioAlertFrame:SetBackdropColor(0, 0, 0, .5) end)
			
	select(1, ScenarioAlertFrame:GetRegions()):Hide()
	select(3, ScenarioAlertFrame:GetRegions()):Hide()

	ScenarioAlertFrame.dungeonTexture:SetTexCoord(.1, .9, .1, .9)
	F.CreateBG(ScenarioAlertFrame.dungeonTexture)

	local fs = select(4, ScenarioAlertFrame:GetRegions())
	fs:SetFont(C.media.font, 10, "OUTLINE")
	fs:SetShadowOffset(0, 0)
	fs:SetTextColor(1,1,1)

	local ScenarioName = select(5, ScenarioAlertFrame:GetRegions())
	ScenarioName:SetFont(C.media.font, 15, "OUTLINE")
	ScenarioName:SetShadowOffset(0, 0)
	ScenarioName:SetTextColor(1,1,1)

	ScenarioAlertFrame.glowFrame.glow:SetTexture(nil)
	ScenarioAlertFrame.shine:SetTexture(nil)
	
	ScenarioAlertFrame:SetScript("OnShow", function(f)
		local name, typeID, subtypeID, textureFilename, moneyBase, moneyVar, experienceBase, experienceVar, numStrangers, numRewards = GetLFGCompletionReward()
		
		for i = 1, numRewards+1 do
			local reward = _G["ScenarioAlertFrameReward"..i]
			if reward then
				select(2, reward:GetRegions()):SetTexture(nil)
				reward.texture:SetTexCoord(.1, .9, .1, .9)
				reward.texture:ClearAllPoints()
				reward.texture:SetPoint("TOPLEFT", 6, -6)
				reward.texture:SetPoint("BOTTOMRIGHT", -6, 6)
				F.CreateBG(reward.texture)
				
				if i == 1 then
					reward:SetPoint("TOPRIGHT", f, "TOPRIGHT", -10, 0)
				else
					reward:SetPoint("RIGHT", _G["ScenarioAlertFrameReward"..(i-1)], "LEFT", 0, 0)
				end
			end
		end
	end)
	
	-- Scenario Legion Invasion Alert Frame
	
	do
		local frame = ScenarioLegionInvasionAlertFrame
		select(1, frame:GetRegions()):Hide()
		
		local icon = select(2, frame:GetRegions())
		icon:SetTexCoord(.1, .9, .1, .9)
		icon:SetDrawLayer("ARTWORK")
		F.CreateBG(icon)
		
		local bg = CreateFrame("Frame", nil, frame)
		bg:SetPoint("TOPLEFT", 8, -8)
		bg:SetPoint("BOTTOMRIGHT", -8, 6)
		bg:SetFrameLevel(frame:GetFrameLevel()-1)
		F.CreateBD(bg, .5)
		frame.animIn:HookScript("OnPlay", function() bg:SetBackdropColor(0, 0, 0, .5) end)
		frame.animIn:HookScript("OnFinished", function() bg:SetBackdropColor(0, 0, 0, .5) end)
		
		frame:SetScript("OnShow", function(f)
			local rewards = f:GetChildren()
			for i = 1, #rewards do
				local reward = rewards[i]
				if reward then
					select(2, reward:GetRegions()):SetTexture(nil)
					reward.texture:SetTexCoord(.1, .9, .1, .9)
					reward.texture:ClearAllPoints()
					reward.texture:SetPoint("TOPLEFT", 6, -6)
					reward.texture:SetPoint("BOTTOMRIGHT", -6, 6)
					F.CreateBG(reward.texture)
					
					if i == 1 then
						reward:SetPoint("TOPRIGHT", f, "TOPRIGHT", -10, 0)
					else
						reward:SetPoint("RIGHT", rewards[i-1], "LEFT", 0, 0)
					end
				end
			end
		end)
	end
	
	-- World Quest alert
	
	do
		local frame = WorldQuestCompleteAlertFrame
		frame.QuestTexture:SetTexCoord(.1, .9, .1, .9)
		frame.QuestTexture:SetDrawLayer("ARTWORK")
		F.CreateBG(frame.QuestTexture)
		
		for i = 2, 5 do
			select(i, frame:GetRegions()):Hide()
		end
		
		frame.shine:SetTexture("")
		
		local bg = CreateFrame("Frame", nil, frame)
		bg:SetPoint("TOPLEFT", 8, -8)
		bg:SetPoint("BOTTOMRIGHT", -8, 6)
		bg:SetFrameLevel(frame:GetFrameLevel()-1)
		F.CreateBD(bg, .5)
		frame.animIn:HookScript("OnPlay", function() bg:SetBackdropColor(0, 0, 0, .5) end)
		frame.animIn:HookScript("OnFinished", function() bg:SetBackdropColor(0, 0, 0, .5) end)
		
		frame:SetScript("OnShow", function(f)
			local rewards = f:GetChildren()
			for i = 1, #rewards do
				local reward = rewards[i]
				if reward then
					select(2, reward:GetRegions()):SetTexture(nil)
					reward.texture:SetTexCoord(.1, .9, .1, .9)
					reward.texture:ClearAllPoints()
					reward.texture:SetPoint("TOPLEFT", 6, -6)
					reward.texture:SetPoint("BOTTOMRIGHT", -6, 6)
					F.CreateBG(reward.texture)
					
					if i == 1 then
						reward:SetPoint("TOPRIGHT", f, "TOPRIGHT", -10, 0)
					else
						reward:SetPoint("RIGHT", rewards[i-1], "LEFT", 0, 0)
					end
				end
			end
		end)
	end
	
	-- Digsite completion alert

	do
		local frame = DigsiteCompleteToastFrame
		local icon = frame.DigsiteTypeTexture

		F.CreateBD(frame, .5)
		frame.animIn:HookScript("OnPlay", function() frame:SetBackdropColor(0, 0, 0, .5) end)
		frame.animIn:HookScript("OnFinished", function() frame:SetBackdropColor(0, 0, 0, .5) end)
		
		frame:GetRegions():Hide()

		frame.glow:SetTexture(nil)
		frame.shine:SetTexture(nil)
	end

	-- Garrison building alert

	do
		local frame = GarrisonBuildingAlertFrame
		local icon = frame.Icon

		frame:GetRegions():Hide()
		frame.glow:SetTexture("")
		frame.shine:SetTexture("")

		local bg = CreateFrame("Frame", nil, frame)
		bg:SetPoint("TOPLEFT", 8, -8)
		bg:SetPoint("BOTTOMRIGHT", -8, 10)
		bg:SetFrameLevel(frame:GetFrameLevel()-1)
		F.CreateBD(bg, .5)
		frame.animIn:HookScript("OnPlay", function() bg:SetBackdropColor(0, 0, 0, .5) end)
		frame.animIn:HookScript("OnFinished", function() bg:SetBackdropColor(0, 0, 0, .5) end)

		icon:SetTexCoord(.08, .92, .08, .92)
		icon:SetDrawLayer("ARTWORK")
		F.CreateBG(icon)
	end

	-- Garrison mission alert

	do
		local frame = GarrisonMissionAlertFrame

		frame.Background:Hide()
		frame.IconBG:Hide()
		frame.glow:SetTexture("")
		frame.shine:SetTexture("")

		local bg = CreateFrame("Frame", nil, frame)
		bg:SetPoint("TOPLEFT", 8, -8)
		bg:SetPoint("BOTTOMRIGHT", -8, 10)
		bg:SetFrameLevel(frame:GetFrameLevel()-1)
		F.CreateBD(bg, .5)
	end

	-- Garrison shipyard mission alert

	do
		local frame = GarrisonShipMissionAlertFrame

		frame.Background:Hide()
		frame.glow:SetTexture("")
		frame.shine:SetTexture("")

		local bg = CreateFrame("Frame", nil, frame)
		bg:SetPoint("TOPLEFT", 8, -8)
		bg:SetPoint("BOTTOMRIGHT", -8, 10)
		bg:SetFrameLevel(frame:GetFrameLevel()-1)
		F.CreateBD(bg, .5)
	end
	
	-- Garrison Random Mission alert
	
	do
		local frame = GarrisonRandomMissionAlertFrame

		frame.Background:Hide()
		frame.Blank:Hide()
		frame.IconBG:Hide()
		frame.glow:SetTexture("")
		frame.shine:SetTexture("")

		local bg = CreateFrame("Frame", nil, frame)
		bg:SetPoint("TOPLEFT", 8, -8)
		bg:SetPoint("BOTTOMRIGHT", -8, 10)
		bg:SetFrameLevel(frame:GetFrameLevel()-1)
		F.CreateBD(bg, .5)
		frame.animIn:HookScript("OnPlay", function() bg:SetBackdropColor(0, 0, 0, .5) end)
		frame.animIn:HookScript("OnFinished", function() bg:SetBackdropColor(0, 0, 0, .5) end)
	end
	
	-- Garrison follower alert

	do
		local frame = GarrisonFollowerAlertFrame
		
		select(5, frame:GetRegions()):Hide()
		frame.FollowerBG:SetAlpha(0)
		frame.glow:SetTexture("")
		frame.shine:SetTexture("")

		local bg = CreateFrame("Frame", nil, frame)
		bg:SetPoint("TOPLEFT", 16, -3)
		bg:SetPoint("BOTTOMRIGHT", -16, 16)
		bg:SetFrameLevel(frame:GetFrameLevel()-1)
		F.CreateBD(bg, .5)

		F.ReskinGarrisonPortrait(frame.PortraitFrame)
	end

	hooksecurefunc("GarrisonFollowerAlertFrame_SetUp", function(_, _, _, _, quality)
		local color = BAG_ITEM_QUALITY_COLORS[quality]
		if color then
			GarrisonFollowerAlertFrame.PortraitFrame.squareBG:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			GarrisonFollowerAlertFrame.PortraitFrame.squareBG:SetBackdropBorderColor(0, 0, 0)
		end
	end)

	-- Garrison ship follower alert
	
	do
		local frame = GarrisonShipFollowerAlertFrame
		
		frame.Background:Hide()
		frame.FollowerBG:SetAlpha(0)
		
		frame.glow:SetTexture("")
		frame.shine:SetTexture("")
		
		local bg = CreateFrame("Frame", nil, frame)
		bg:SetPoint("TOPLEFT", 10, -3)
		bg:SetPoint("BOTTOMRIGHT", -16, 16)
		bg:SetFrameLevel(frame:GetFrameLevel()-1)
		F.CreateBD(bg, .5)
	end
	
	-- Garrison talent alert
	
	do
		local frame = GarrisonTalentAlertFrame
		select(1, frame:GetRegions()):Hide()
		frame.Icon:SetTexCoord(.1, .9, .1, .9)
		frame.Icon:SetDrawLayer("ARTWORK")
		F.CreateBG(frame.Icon)
		
		frame.glow:SetTexture("")
		frame.shine:SetTexture("")
		
		local bg = CreateFrame("Frame", nil, frame)
		bg:SetPoint("TOPLEFT", 8, -8)
		bg:SetPoint("BOTTOMRIGHT", -8, 10)
		bg:SetFrameLevel(frame:GetFrameLevel()-1)
		F.CreateBD(bg, .5)
		frame.animIn:HookScript("OnPlay", function() bg:SetBackdropColor(0, 0, 0, .5) end)
		frame.animIn:HookScript("OnFinished", function() bg:SetBackdropColor(0, 0, 0, .5) end)
	end
	
	-- Store Purchase alert
	do
		local frame = StorePurchaseAlertFrame
		frame.Background:Hide()
		frame.Icon:SetTexCoord(.1, .9, .1, .9)
		F.CreateBG(frame.Icon)
		
		frame.glow:SetTexture("")
		frame.shine:SetTexture("")
		
		local bg = CreateFrame("Frame", nil, frame)
		bg:SetPoint("TOPLEFT", 8, -8)
		bg:SetPoint("BOTTOMRIGHT", -8, 8)
		bg:SetFrameLevel(frame:GetFrameLevel()-1)
		F.CreateBD(bg, .5)
		frame.animIn:HookScript("OnPlay", function() bg:SetBackdropColor(0, 0, 0, .5) end)
		frame.animIn:HookScript("OnFinished", function() bg:SetBackdropColor(0, 0, 0, .5) end)
	end
	
	-- Legendary Item Alert
	
	do
		local frame = LegendaryItemAlertFrame
		
		frame.Icon:SetTexCoord(.1, .9, .1, .9)
		frame.Icon:SetDrawLayer("ARTWORK")
		F.CreateBG(frame.Icon)
		
		frame.glow:SetTexture("")
		frame.shine:SetTexture("")
				
		select(2, LegendaryItemAlertFrame:GetRegions()):Hide()
		select(8, LegendaryItemAlertFrame:GetRegions()):Hide()
		select(9, LegendaryItemAlertFrame:GetRegions()):Hide()
		
		local bg = CreateFrame("Frame", nil, frame)
		bg:SetPoint("TOPLEFT", 35, -18)
		bg:SetPoint("BOTTOMRIGHT", -10, 22)
		bg:SetFrameLevel(frame:GetFrameLevel()-1)
		F.CreateBD(bg, .5)
		frame.animIn:HookScript("OnPlay", function() bg:SetBackdropColor(0, 0, 0, .5) end)
		frame.animIn:HookScript("OnFinished", function() bg:SetBackdropColor(0, 0, 0, .5) end)
	end
end)