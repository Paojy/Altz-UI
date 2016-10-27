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
end)