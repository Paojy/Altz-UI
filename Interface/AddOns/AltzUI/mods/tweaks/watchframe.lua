--Original Author: Nibelheim
local T, C, L, G = unpack(select(2, ...))
local dragFrameList = G.dragFrameList

local eventframe = CreateFrame("Frame")
eventframe:RegisterEvent("PLAYER_ENTERING_WORLD")
eventframe:SetScript("OnEvent", function()
	if aCoreCDB["SkinOptions"]["collapseWF"] then
		if IsInInstance() then
			ObjectiveTracker_Collapse()
		else
			ObjectiveTracker_Expand()
		end
	end
end)

local anchorframe = CreateFrame("Frame", "Altz_WFanchorframe", UIParent)
local customobjectivetracker = aCoreCDB["SkinOptions"]["customobjectivetracker"]
if customobjectivetracker then return end
 
anchorframe.movingname = L["任务追踪"]
anchorframe.point = {
	healer = {a1 = "TOPLEFT", parent = "UIParent", a2 = "TOPLEFT", x = 20, y = -200},
	dpser = {a1 = "TOPLEFT", parent = "UIParent", a2 = "TOPLEFT", x = 20, y = -200},
}
T.CreateDragFrame(anchorframe) --frame, dragFrameList, inset, clamp	
anchorframe:SetSize(240, 20)


OBJECTIVE_TRACKER_COLOR["Normal"]["r"] = 1
OBJECTIVE_TRACKER_COLOR["Normal"]["g"] = 1
OBJECTIVE_TRACKER_COLOR["Normal"]["b"] = 1

OBJECTIVE_TRACKER_COLOR["NormalHighlight"]["r"] = 1
OBJECTIVE_TRACKER_COLOR["NormalHighlight"]["g"] = 1
OBJECTIVE_TRACKER_COLOR["NormalHighlight"]["b"] = 0

OBJECTIVE_TRACKER_COLOR["Header"]["r"] = G.Ccolor.r
OBJECTIVE_TRACKER_COLOR["Header"]["g"] = G.Ccolor.g
OBJECTIVE_TRACKER_COLOR["Header"]["b"] = G.Ccolor.b

OBJECTIVE_TRACKER_COLOR["HeaderHighlight"]["r"] = G.Ccolor.r
OBJECTIVE_TRACKER_COLOR["HeaderHighlight"]["g"] = G.Ccolor.g
OBJECTIVE_TRACKER_COLOR["HeaderHighlight"]["b"] = G.Ccolor.b

OBJECTIVE_TRACKER_COLOR["Complete"]["r"] = 1
OBJECTIVE_TRACKER_COLOR["Complete"]["g"] = 1
OBJECTIVE_TRACKER_COLOR["Complete"]["b"] = 1


local vm = ObjectiveTrackerFrame

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
				
				vm.MODULES[i].Header.Background = vm.MODULES[i].Header:CreateTexture(nil, "BACKGROUND")
				vm.MODULES[i].Header.Background:SetPoint("TOPLEFT", 10, 2)
				vm.MODULES[i].Header.Background:SetPoint("BOTTOMRIGHT", -10, -2)
				vm.MODULES[i].Header.Background:SetTexture("Interface\\PVPFrame\\PvPMegaQueue")
				vm.MODULES[i].Header.Background:SetTexCoord(0.00195313,0.63867188,0.76953125,0.83207813)
				vm.MODULES[i].Header.Background:SetBlendMode("ADD")
				vm.MODULES[i].Header.Background:SetDesaturated(true)
				vm.MODULES[i].Header.Background:SetVertexColor(1, .81, 0)
				
				local bg = select(7, vm.MODULES[i].Header:GetRegions()) -- 隐藏Aurora加的bg
				bg:Hide()
				
		        vm.MODULES[i].Header.Text:SetFont(G.norFont, 14, "NONE")
				vm.MODULES[i].Header.Text:SetTextColor(1, .9, 0)
		        vm.MODULES[i].Header.Text:ClearAllPoints()
		        vm.MODULES[i].Header.Text:SetPoint("CENTER", vm.MODULES[i].Header, 0, 0)
		        vm.MODULES[i].Header.Text:SetJustifyH("CENTER")
	        end
	    end
	end)
end

hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", function(_, block)
	block.HeaderText:SetFont(G.norFont, 12, "OUTLINE")
    block.HeaderText:SetShadowColor(0, 0, 0, 1)
	block.HeaderText:SetShadowOffset(0, 0)
    block.HeaderText:SetJustifyH("LEFT")
    block.HeaderText:SetWidth(200)
    block.HeaderText:SetHeight(15)
	local heightcheck = block.HeaderText:GetNumLines()      
    if heightcheck==2 then
        local height = block:GetHeight()     
        block:SetHeight(height + 2)
    end
end)
    
hooksecurefunc(ACHIEVEMENT_TRACKER_MODULE, "SetBlockHeader", function(_, block)
    local trackedAchievements = {GetTrackedAchievements()}
        
    for i = 1, #trackedAchievements do
		local achieveID = trackedAchievements[i]
		local _, achievementName, _, completed, _, _, _, description, _, icon, _, _, wasEarnedByMe = GetAchievementInfo(achieveID)
	        
		if not wasEarnedByMe then
	        block.HeaderText:SetFont(G.norFont, 12, "OUTLINE")
            block.HeaderText:SetShadowColor(0, 0, 0, 1)
			block.HeaderText:SetShadowOffset(0, 0)
            block.HeaderText:SetJustifyH("LEFT")
            block.HeaderText:SetWidth(200)
        end
	end
end)

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
