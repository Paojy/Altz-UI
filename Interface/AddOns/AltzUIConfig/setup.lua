local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)

local function ShowFinish(text, subtext)
    local levelUpTexCoords = {
        gLine = { 0.00195313, 0.81835938, 0.00195313, 0.01562500 },
        tint = {1, 0.996, 0.745},
        gLineDelay = 0,
    }

    local script = LevelUpDisplay:GetScript("OnShow")
    LevelUpDisplay.type = LEVEL_UP_TYPE_SCENARIO
    LevelUpDisplay:SetScript("OnShow", nil)
    LevelUpDisplay:Show()

    LevelUpDisplay.scenarioFrame.level:SetText(text)
    LevelUpDisplay.scenarioFrame.name:SetText(subtext)
    LevelUpDisplay.scenarioFrame.description:SetText("")
    LevelUpDisplay:SetPoint("TOP", 0, -250)

    LevelUpDisplay.gLine:SetTexCoord(unpack(levelUpTexCoords.gLine))
    LevelUpDisplay.gLine2:SetTexCoord(unpack(levelUpTexCoords.gLine))
    LevelUpDisplay.gLine:SetVertexColor(unpack(levelUpTexCoords.tint))
    LevelUpDisplay.gLine2:SetVertexColor(unpack(levelUpTexCoords.tint))
    LevelUpDisplay.levelFrame.levelText:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    LevelUpDisplay.gLine.grow.anim1:SetStartDelay(levelUpTexCoords.gLineDelay)
    LevelUpDisplay.gLine2.grow.anim1:SetStartDelay(levelUpTexCoords.gLineDelay)
    LevelUpDisplay.blackBg.grow.anim1:SetStartDelay(levelUpTexCoords.gLineDelay)
	
    LevelUpDisplay.scenarioFrame.newStage:Play()
    PlaySound(31749)
		
    LevelUpDisplay:SetScript("OnShow", script)
end

local BlackBg = CreateFrame("Frame", G.uiname.."BlackBg", WorldFrame)
BlackBg:SetFrameStrata("FULLSCREEN")
F.CreateBD(BlackBg, 1)
BlackBg:SetPoint("TOPLEFT",WorldFrame,"TOPLEFT", -5, 5)
BlackBg:SetPoint("BOTTOMRIGHT",WorldFrame,"BOTTOMRIGHT", 5, -5)
BlackBg:Hide()

BlackBg.titleframe = CreateFrame("Frame", G.uiname.."BlackBg Title", BlackBg)
BlackBg.titleframe:SetSize(400, 200)
BlackBg.titleframe:SetFrameLevel(2)
BlackBg.titleframe:SetPoint("CENTER")

BlackBg.titleframe.model = CreateFrame("PlayerModel", G.uiname.."BlackBg Title Model", BlackBg.titleframe)
BlackBg.titleframe.model:SetSize(800, 800)
BlackBg.titleframe.model:SetFrameLevel(1)
BlackBg.titleframe.model:SetPoint("CENTER", BlackBg, "CENTER", 0, -100)
BlackBg.titleframe.model:SetDisplayInfo(41039)
BlackBg.titleframe.model:SetCamDistanceScale(.7)
BlackBg.titleframe.model:SetPosition(-15, -0.1, -6.2)

BlackBg.titleframe.model:SetFogColor(0.1, 0.1, 0.1)
--BlackBg.titleframe.model:SetLight(true)--(enabled[, omni, dirX, dirY, dirZ, ambIntensity[, ambR, ambG, ambB], dirIntensity[, dirR, dirG, dirB]])

BlackBg.titleframe.uiname = T.createtext(BlackBg.titleframe, "OVERLAY", 35, "NONE", "CENTER")
BlackBg.titleframe.uiname:SetPoint("BOTTOM", BlackBg.titleframe, "CENTER")
BlackBg.titleframe.uiname:SetTextColor(1, 1, 1)
BlackBg.titleframe.uiname:SetText(L["欢迎使用"])

BlackBg.titleframe.author = T.createtext(BlackBg.titleframe, "OVERLAY", 15, "NONE", "CENTER")
BlackBg.titleframe.author:SetPoint("TOP", BlackBg.titleframe.uiname, "BOTTOM", 0, -10)
BlackBg.titleframe.author:SetTextColor(1, 1, 1)
BlackBg.titleframe.author:SetText("ver"..G.Version.." "..L["小泡泡"])

BlackBg.titleframe:SetScript("OnEnter", function(self)
	--self.model:SetLight(1, 0, 0, 1, 0, 1, .7, .7, .7, 1)
	self.model:ClearFog() 
end)

BlackBg.titleframe:SetScript("OnLeave", function(self)
	self.model:SetFogColor(0.1, 0.1, 0.1) 
	--self.model:SetLight(1, 1, 0, 1, 0, 1, .7, .7, .7, 1)
end)

BlackBg.introframe = CreateFrame("Button", G.uiname.."BlackBg Intro", BlackBg)
BlackBg.introframe:SetSize(400, 400)
BlackBg.introframe:SetFrameLevel(2)
BlackBg.introframe:SetPoint("CENTER")
BlackBg.introframe:Hide()

BlackBg.introframe.model = CreateFrame("PlayerModel", G.uiname.."BlackBg Title Model", BlackBg.introframe)
BlackBg.introframe.model:SetSize(400, 400)
BlackBg.introframe.model:SetFrameLevel(1)
BlackBg.introframe.model:SetPoint("RIGHT", BlackBg, "CENTER", 0, 0)
BlackBg.introframe.model:SetDisplayInfo(42522)
BlackBg.introframe.model:SetCamDistanceScale(.7)
BlackBg.introframe.model:SetPosition(-2,0,0)

BlackBg.introframe.text = T.createtext(BlackBg.introframe, "OVERLAY", 15, "NONE", "LEFT")
BlackBg.introframe.text:SetWidth(400)
BlackBg.introframe.text:SetPoint("LEFT", BlackBg, "CENTER", -100, 0)
BlackBg.introframe.text:SetText(L["简介"])

local FullStep, Curstep = 0, 0
local index = 0
local Instructions = {}

local function CreateInstruction(parent, button, title, text, anchor)
	index = index + 1
	
	local bu = CreateFrame("Button", nil, parent)
	
	if title == L["动作条"] then
		bu:SetParent(UIParent)
	end
	
	bu:SetSize(40, 40)
	bu:SetFrameStrata("FULLSCREEN")
	bu:SetFrameLevel(2)
	if not button then
		bu:SetPoint("CENTER", parent, "CENTER")
	else
		bu:SetPoint("CENTER", button, "CENTER")
	end
	
	local frame = CreateFrame("Button", nil, bu, "GlowBorderTemplate")
	frame:SetAllPoints(parent)
	frame:SetFrameLevel(1)
	
	bu:SetNormalTexture("Interface\\common\\help-i")
	bu:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
	
	bu:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, anchor)
		GameTooltip:AddLine(title, G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
		GameTooltip:AddLine(text, G.Ccolor.r, G.Ccolor.g, G.Ccolor.b, true)
		GameTooltip:Show()
	end)
	
	bu:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	bu:SetScript("OnMouseDown", function(self)
		self:Hide()
		Curstep = Curstep + 1
		if Curstep ~= FullStep then
			ActionStatus_DisplayMessage(format(L["已完成"], Curstep, FullStep), true)
		else
			ShowFinish(L["恭喜"], L["设置完成"])
		end
	end)

	bu:Hide()
	
	table.insert(Instructions, bu)
end

local function CreateInstructions()
	CreateInstruction(ChatFrame1, nil, L["聊天框"], L["聊天框tips"], "ANCHOR_TOPLEFT")
	CreateInstruction(_G[G.uiname.."Info Frame"], nil, L["信息栏"], L["信息栏tips"], "ANCHOR_RIGHT")
	CreateInstruction(Minimap, nil,L["小地图"], L["小地图tips"], "ANCHOR_LEFT")
	CreateInstruction(_G[G.uiname.."MicromenuBar"], nil, L["微型菜单"], L["微型菜单tips"], "ANCHOR_BOTTOMLEFT")
	CreateInstruction(_G[G.uiname.."MicromenuBar3"], nil, L["控制台"], L["控制台tips"], "ANCHOR_RIGHT")
	CreateInstruction(_G[G.uiname.."UnlockAllFramesButton"], nil, L["解锁按钮"], L["解锁按钮tips"], "ANCHOR_RIGHT")
	CreateInstruction(_G[G.uiname.."SpecMover"], nil, L["布局模式"], L["布局模式tips"], "ANCHOR_RIGHT")
	CreateInstruction(_G[G.uiname.."SpecMoverLockButton"], nil, L["锁定按钮"], L["锁定按钮tips"], "ANCHOR_RIGHT")
	CreateInstruction(_G["Altz_Bar1&2"], nil, L["动作条"], L["动作条tips"], "ANCHOR_RIGHT")
	
	FullStep = index
	Curstep = 0
	
	for i = 1, #Instructions do
		if i == 1 then
			Instructions[i]:Show()
		end
		if i ~= #Instructions then
			if i == (#Instructions-1) then
				_G[G.uiname.."SpecMover"]:SetScript("OnHide" ,function()
					Instructions[i+1]:Show()
				end)
			else
				Instructions[i]:SetScript("OnHide" ,function()
					Instructions[i+1]:Show()
				end)
			end
		end
	end
end

BlackBg.titleframe:SetScript("OnMouseDown", function(self)
	UIFrameFadeOut(self, 2, self:GetAlpha(), 0)
	self:EnableMouse(false)
	UIFrameFadeIn(BlackBg.introframe, 2, 0, 1)
end)

BlackBg.introframe:SetScript("OnClick", function(self)
	aCoreDB.meet = 1
	ReloadUI()
end)

local eventframe = CreateFrame("Frame")
eventframe:RegisterEvent("PLAYER_ENTERING_WORLD")
eventframe:SetScript("OnEvent", function() 
	if not aCoreDB.meet then
		T.SetChatFrame()
		T.ResetAllAddonSettings()
		SetCVar("useUiScale", 0)
		BlackBg:Show()
		UIParent:Hide()
	elseif aCoreDB.meet == 1 then
		CreateInstructions()
		aCoreDB.meet = 2
	end
end)

SlashCmdList['Tutorials'] = function()
	CreateInstructions()
end

SLASH_Tutorials1 = "/Tutorials"
SLASH_Tutorials2 = "/Tut"