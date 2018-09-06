--Original Author: Nibelheim
local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)
local dragFrameList = G.dragFrameList

local anchorframe = CreateFrame("Frame", "Altz_WFanchorframe", UIParent)
anchorframe.movingname = L["任务追踪"]
anchorframe.point = {
	healer = {a1 = "TOPRIGHT", parent = "UIParent", a2 = "TOPRIGHT", x = -250, y = -180},
	dpser = {a1 = "TOPRIGHT", parent = "UIParent", a2 = "TOPRIGHT", x = -250, y = -180},
}
T.CreateDragFrame(anchorframe) --frame, dragFrameList, inset, clamp	
anchorframe:SetSize(240, 20)

local vm = ObjectiveTrackerFrame

F.ReskinArrow(vm.HeaderMenu.MinimizeButton, "down")
vm:SetFrameStrata("MEDIUM")
vm:SetFrameLevel(15) -- higher than multiright actionbar
vm:ClearAllPoints()
vm:SetPoint("TOPLEFT", anchorframe, "TOPLEFT")
vm:SetHeight(G.screenheight - 300)
vm.ClearAllPoints = function() end
vm.SetPoint = function() end

if IsAddOnLoaded("Blizzard_ObjectiveTracker") then
    hooksecurefunc("ObjectiveTracker_Update", function(reason, id)
       if vm.MODULES then  
            for i = 1, #vm.MODULES do                               
		        vm.MODULES[i].Header.Background:SetAtlas(nil)
		        vm.MODULES[i].Header.Text:SetFont(G.norFont, 12, "OUTLINE")
		        vm.MODULES[i].Header.Text:ClearAllPoints()
		        vm.MODULES[i].Header.Text:SetPoint("LEFT", vm.MODULES[i].Header, 10, 0)
		        vm.MODULES[i].Header.Text:SetJustifyH("LEFT")
	        end
	    end
	end)
end

hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", function(_, block)
	block.HeaderText:SetFont(G.norFont, 12, "OUTLINE")
    block.HeaderText:SetShadowColor(0, 0, 0, 1)
    block.HeaderText:SetTextColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
    block.HeaderText:SetJustifyH("LEFT")
    block.HeaderText:SetWidth(200)
    block.HeaderText:SetHeight(15)
		local heightcheck = block.HeaderText:GetNumLines()      
    if heightcheck==2 then
        local height = block:GetHeight()     
        block:SetHeight(height + 2)
    end
end)
    
local function hoverquest(_, block)
	block.HeaderText:SetTextColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
end
hooksecurefunc(QUEST_TRACKER_MODULE, "OnBlockHeaderEnter", hoverquest)  
hooksecurefunc(QUEST_TRACKER_MODULE, "OnBlockHeaderLeave", hoverquest)

hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, "SetBlockHeader", function(_, block)
    local trackedAchievements = {GetTrackedAchievements()}
        
    for i = 1, #trackedAchievements do
		local achieveID = trackedAchievements[i]
		local _, achievementName, _, completed, _, _, _, description, _, icon, _, _, wasEarnedByMe = GetAchievementInfo(achieveID)
	        
		if not wasEarnedByMe then
	        block.HeaderText:SetFont(G.norFont, 12, "OUTLINE")
            block.HeaderText:SetShadowColor(0, 0, 0, 1)
            block.HeaderText:SetTextColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
            block.HeaderText:SetJustifyH("LEFT")
            block.HeaderText:SetWidth(200)
        end
	end
end)
local function hoverachieve(_, block)
	block.HeaderText:SetTextColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
end
      
hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, "OnBlockHeaderEnter", hoverachieve)
hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, "OnBlockHeaderLeave", hoverachieve)


ScenarioStageBlock:HookScript("OnShow", function()
	if not ScenarioStageBlock.skinned then
		ScenarioStageBlock.NormalBG:SetAlpha(0)
		ScenarioStageBlock.FinalBG:SetAlpha(0)
		ScenarioStageBlock.GlowTexture:SetTexture(nil)
		
		ScenarioStageBlock.Stage:SetFont(G.norFont, 18, "OUTLINE")
		ScenarioStageBlock.Stage:SetTextColor(1, 1, 1)
		
		ScenarioStageBlock.Name:SetFont(G.norFont, 12, "OUTLINE")
		
		ScenarioStageBlock.CompleteLabel:SetFont(G.norFont, 18, "OUTLINE")
		ScenarioStageBlock.CompleteLabel:SetTextColor(1, 1, 1)
		ScenarioStageBlock.skinned = true
	end
end)

--ScenarioChallengeModeBlock
--ScenarioProvingGroundsBlock

local eventframe = CreateFrame("Frame")
eventframe:RegisterEvent("PLAYER_ENTERING_WORLD")
eventframe:SetScript("OnEvent", function()
	if aCoreCDB["OtherOptions"]["collapseWF"] then
		if IsInInstance() then
			ObjectiveTracker_Collapse()
		else
			ObjectiveTracker_Expand()
		end
	end
end)
