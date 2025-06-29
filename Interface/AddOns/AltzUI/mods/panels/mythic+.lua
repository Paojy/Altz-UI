local T, C, L, G = unpack(select(2, ...))

local KeyFrame
local GroupFrames = {}
local GroupFramesByName = {}
local ListHeight = 0

local function GetKeyInfo(mapID, level)
	local text
	if mapID and level then
		local name, _, _, icon = C_ChallengeMode.GetMapUIInfo(mapID)
		text = string.format("%s%d%s", T.GetTexStr(icon), level, name)
	else
		text = string.format("%s%s", T.GetTexStr(525134), "?")
	end
	return text
end

local function FormatRunText(icon, level, name, completed)
	local colored_level
	if completed then
		colored_level = string.format("|cff00ff00%d|r", level)
	else
		colored_level = string.format("|cffff0000%d|r", level)
	end
	return T.GetTexStr(icon)..colored_level..name
end

local function UpdateHistory()
	local week_start = C_DateAndTime.GetWeeklyResetStartTime()
	for player, info in pairs(aCoreDB.mythic_info) do
		if info.last_update - week_start < 0 then
			aCoreDB.mythic_info[player] = nil
		end
	end
end

local function UpdatePlayerDB()
	local player = G.PlayerName
	if aCoreDB.mythic_info[player] == nil then
		aCoreDB.mythic_info[player] = {}
	end
	
	if aCoreDB.mythic_info[player].last_update == nil then
		aCoreDB.mythic_info[player].last_update = 0
	end
	
	if aCoreDB.mythic_info[player].details == nil then
		aCoreDB.mythic_info[player].details = {}
	end

	aCoreDB.mythic_info[player].details = table.wipe(aCoreDB.mythic_info[player].details)
	
	local runHistory = C_MythicPlus.GetRunHistory(false, true)
	local total = #runHistory
	local displayRuns = min(8, total)
	
	table.sort(runHistory, function(a, b)
		if a.level ~= b.level then
			return a.level > b.level
		else
			return a.mapChallengeModeID > b.mapChallengeModeID
		end
	end)
	
	for index = 1, displayRuns do
        local run = runHistory[index]
       
        local info = {
			mapID = run.mapChallengeModeID,
			level = run.level,
			completed = run.completed,
		}
		
		table.insert(aCoreDB.mythic_info[player].details, info)
    end
	
	aCoreDB.mythic_info[player].last_update = C_DateAndTime.GetServerTimeLocal()
	aCoreDB.mythic_info[player].ChallengeMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
	aCoreDB.mythic_info[player].keyStoneLevel = C_MythicPlus.GetOwnedKeystoneLevel()
	aCoreDB.mythic_info[player].runs = total
end

local function Lineup()
	table.sort(GroupFrames, function(a, b)
		if a.key_level ~= b.key_level then
			return a.key_level > b.key_level
		elseif a.runs ~= b.runs then
			return a.runs > b.runs
		else
			return a.player > b.player
		end
	end)
	
	for index, f in pairs(GroupFrames) do
		f:ClearAllPoints()
		f:SetPoint("TOPLEFT", KeyFrame, "TOPLEFT", 5, -25-20*index)
		ListHeight = -50-20*index
	end
end

local function Reset()
	aCoreDB.mythic_info = table.wipe(aCoreDB.mythic_info)
	
	for index, f in pairs(GroupFrames) do
		f:Hide()
	end
	
	GroupFrames = table.wipe(GroupFrames)
	GroupFramesByName = table.wipe(GroupFramesByName)
end

local function CreateCharacterFrame(playerName)
	local f = CreateFrame("Frame", nil, KeyFrame)
	f:SetSize(240, 20)
	
	f.left = T.createtext(f, "OVERLAY", 14, "OUTLINE", "LEFT")
	f.left:SetPoint("LEFT", f, "LEFT", 0, 0)
	
	f.right = T.createtext(f, "OVERLAY", 14, "OUTLINE", "RIGHT")
	f.right:SetPoint("RIGHT", f, "RIGHT", 0, 0)
	
	f.player = playerName
	f.key_level = 0
	f.runs = -1
	
	function f:UpdateInfo()
		local player = self.player
		local playerName = aCoreDB.character_info[player].name
		local mapID = aCoreDB.mythic_info[player] and aCoreDB.mythic_info[player].ChallengeMapID
		local key_level = aCoreDB.mythic_info[player] and aCoreDB.mythic_info[player].keyStoneLevel
		local key_str = GetKeyInfo(mapID, key_level)
		local runs = aCoreDB.mythic_info[player] and aCoreDB.mythic_info[player].runs
		local details = aCoreDB.mythic_info[player] and aCoreDB.mythic_info[player].details 

		self.runs = runs or -1
		self.key_level = key_level or 0
		self.left:SetText(playerName..key_str)
		self.right:SetText(runs and string.format("|cffffff00[%s]|r", runs) or "")
		
		if details and #details > 0 then
			self:SetScript("OnEnter", function(self) 
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 5, 20)
				GameTooltip:AddLine(playerName)
				for index, run in pairs(details) do
					local name, _, _, icon = C_ChallengeMode.GetMapUIInfo(run.mapID)
					local level = run.level
					local completed = run.completed
					
					GameTooltip:AddLine(FormatRunText(icon, level, name, completed))
				end
				GameTooltip:Show()
			end)
		else
			self:SetScript("OnEnter", function(self) 
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 5, 20)
				GameTooltip:AddLine(playerName..L["无大秘境记录"])
				GameTooltip:Show()
			end)
		end
		
		self:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
	end
	
	table.insert(GroupFrames, f)
	GroupFramesByName[playerName] = f
end

local function GetRunInfo()
	local player_name = aCoreDB.character_info[G.PlayerName].name
	local runHistory = C_MythicPlus.GetRunHistory(false, true)
    local total = #runHistory

	if total > 0 then
		local vaultRuns = ""
		local displayRuns = min(8, total)
		
		for index = 1, displayRuns do
            local run = runHistory[index]
            local name, _, _, icon = C_ChallengeMode.GetMapUIInfo(run.mapChallengeModeID)
            local completed = run.completed
            local level = run.level
            
            vaultRuns = vaultRuns .. FormatRunText(icon, level, name, completed).."\n"
        end
		
		return string.format("%s%s:", player_name, L["大秘境记录"]), vaultRuns
	else
		return string.format("%s%s", player_name, L["无大秘境记录"]), ""
	end
end

local function UpdateLayout()
	for player, info in pairs(aCoreDB.mythic_info) do
		if not GroupFramesByName[player] then
			CreateCharacterFrame(player)
		end
		local f = GroupFramesByName[player]
		f:UpdateInfo()
	end
	Lineup()
	
	local title, records = GetRunInfo()
	KeyFrame.line:SetPoint("TOPLEFT", KeyFrame, "TOPLEFT", 5, ListHeight-10)
	KeyFrame.text2:SetText(title)
	KeyFrame.text3:SetText(records)
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")

local function Init()
	if not KeyFrame then
		KeyFrame = CreateFrame("Frame", nil, ChallengesFrame.WeeklyInfo)
		KeyFrame:SetPoint("TOPLEFT", ChallengesFrame, "TOPRIGHT", 5, -1)
		KeyFrame:SetPoint("BOTTOMLEFT", ChallengesFrame, "BOTTOMRIGHT", 5, 1)
		KeyFrame:SetWidth(250)
		
		T.setStripBD(KeyFrame)
		
		local path = {"SkinOptions", "mythicInfo"}
		
		KeyFrame.close = CreateFrame("Button", nil, KeyFrame, "UIPanelCloseButton")
		KeyFrame.close:SetPoint("TOPRIGHT", -6, -6)
		T.ReskinClose(KeyFrame.close)
		
		KeyFrame.toggle = CreateFrame("Button", nil, ChallengesFrame.WeeklyInfo)
		KeyFrame.toggle:SetPoint("BOTTOMRIGHT", ChallengesFrame.WeeklyInfo, "BOTTOMRIGHT", 5, 40)
		KeyFrame.toggle:SetSize(25, 25)
		
		KeyFrame.toggle.tex = KeyFrame.toggle:CreateTexture(nil, "ARTWORK")
		KeyFrame.toggle.tex:SetAllPoints()
		KeyFrame.toggle.tex:SetTexture(G.textureFile.."arrow.tga")
		KeyFrame.toggle.tex:SetRotation(rad(-135))
		
		KeyFrame.toggle:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT",  -20, 10)
			GameTooltip:AddLine(L["大秘境信息"])
			GameTooltip:Show()
			self.tex:SetVertexColor(unpack(G.addon_color))
		end)
		
		KeyFrame.toggle:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
			self.tex:SetVertexColor(1, 1, 1)
		end)
		
		KeyFrame.close:SetScript("OnClick", function()
			T.ValueToPath(aCoreCDB, path, false)
			KeyFrame:Hide()
			KeyFrame.toggle:Show()
		end)
	
		KeyFrame.toggle:SetScript("OnClick", function()
			T.ValueToPath(aCoreCDB, path, true)
			KeyFrame:Show()
		end)
		
		KeyFrame:SetScript("OnShow", function()
			KeyFrame.toggle:Hide()
		end)
		
		KeyFrame.text = T.createtext(KeyFrame, "OVERLAY", 14, "OUTLINE", "LEFT")
		KeyFrame.text:SetPoint("TOPLEFT", KeyFrame, "TOPLEFT", 5, -25)
		KeyFrame.text:SetText(L["当前钥匙"])
		
		KeyFrame.text = T.createtext(KeyFrame, "OVERLAY", 14, "OUTLINE", "LEFT")
		KeyFrame.text:SetPoint("TOPRIGHT", KeyFrame, "TOPRIGHT", -5, -25)
		KeyFrame.text:SetText(string.format("|cffffff00[%s]|r", L["完成次数"]))
		
		KeyFrame.line = KeyFrame:CreateTexture(nil, "ARTWORK")
		KeyFrame.line:SetSize(240, 1)
		KeyFrame.line:SetColorTexture(1, 1, 1, .2)
			
		KeyFrame.text2 = T.createtext(KeyFrame, "OVERLAY", 14, "OUTLINE", "LEFT")
		KeyFrame.text2:SetPoint("TOPLEFT", KeyFrame.line, "BOTTOMLEFT", 0, -10)	
		
		KeyFrame.text3 = T.createtext(KeyFrame, "OVERLAY", 14, "OUTLINE", "LEFT")
		KeyFrame.text3:SetPoint("TOPLEFT", KeyFrame.text2, "BOTTOMLEFT", 0, -5)
		
		KeyFrame.ResetButton = T.ClickTexButton(KeyFrame, {"BOTTOMRIGHT", KeyFrame, "BOTTOMRIGHT", -5, 5}, G.iconFile.."refresh.tga", nil, nil, L["重置"])
		KeyFrame.ResetButton:SetScript("OnClick", function()		
			Reset()
			UpdateHistory()
			UpdatePlayerDB()
			UpdateLayout()
		end)
		
		UpdateHistory()
		UpdatePlayerDB()
		UpdateLayout()
		
		eventFrame:RegisterEvent("WEEKLY_REWARDS_UPDATE")
		eventFrame:RegisterEvent("CHALLENGE_MODE_COMPLETED")
	end
end

eventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" then
		local addon = ...
		if addon == "Blizzard_ChallengesUI" and ChallengesFrame then	
			if not WeeklyRewardsFrame then
				WeeklyRewards_LoadUI()
			end
			
			C_Timer.After(.5, Init)
		end
	elseif event == "WEEKLY_REWARDS_UPDATE" or event == "CHALLENGE_MODE_COMPLETED" then
		UpdatePlayerDB()
		UpdateLayout()
	end
end)