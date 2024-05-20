local T, C, L, G = unpack(select(2, ...))

--====================================================--
--[[                 -- API --                      ]]--
--====================================================--
local delayframe = CreateFrame("Frame")
delayframe.t = 0
delayframe.func = {}

local DelayFunc = function(delay, func)
	table.insert(delayframe.func, {action = func, wait = delay})	
	if not delayframe:GetScript("OnUpdate") then
		delayframe:SetScript("OnUpdate", function(self, elapsed)
			self.t = self.t + elapsed
			if self.t > 0.1 then
				if delayframe.func[1] then
					delayframe.func[1].wait = delayframe.func[1].wait - self.t
					if delayframe.func[1].wait <= 0 then
						local cur_func = delayframe.func[1].action
						table.remove(delayframe.func, 1)
						cur_func()	
					end
				else
					self:SetScript("OnUpdate", nil)
				end
				self.t = 0
			end
		end)
	end
end

--====================================================--
--[[               -- 自动ROLL --                   ]]--
--====================================================--
local roll_cache = {}
local roll_begin
local rollTypes = {
	[0] = PASS,
	[1] = NEED,
	[2] = GREED,
}

local function SetRollCache(rollID, itemName, canNeed, canGreed)	
	local value = IsInGuildGroup() and aCoreCDB.ItemOptions.autoloot_guild or aCoreCDB.ItemOptions.autoloot_noguild
    if value == 1 then -- Pass
        roll_cache[rollID] = {name = itemName, action = 0}
    elseif value == 2 then -- Need/Greed
        if canNeed then
            roll_cache[rollID] = {name = itemName, action = 1}			
        elseif canGreed then
            roll_cache[rollID] = {name = itemName, action = 2}
		else
			roll_cache[rollID] = {name = itemName, action = 0}
		end
	end	
end

local eventFrame = CreateFrame('Frame')
local recent_encounterID

local function FoundEncounterLootInfo(encounterID)
	local encounters = C_LootHistory.GetAllEncounterInfos()
	local encounterFound = false
	for _, encounter in ipairs(encounters) do
		if encounter.encounterID == encounterID then
			encounterFound = true
			break
		end
	end
	return encounterFound
end

local function TakeLootScreenshot(encounterID)
	GroupLootHistoryFrame:Show()
	if GroupLootHistoryFrame.selectedEncounterID ~= encounterID then
		SetLootHistoryFrameToEncounter(encounterID)
	end
	
	local frames = GroupLootHistoryFrame.ScrollBox.view:GetFrames()
	for index, frame in pairs(frames) do
		if frame.SetTooltip then
			DelayFunc(1, function()
				frame:SetTooltip()
				Screenshot()
				T.msg(string.format(L["自动截图%s"], frame.dropInfo.itemHyperlink))
				if index == #frames then
					C_Timer.After(.5, function() 
						GameTooltip:Hide()
						if aCoreCDB.ItemOptions.lootroll_screenshot_close then
							GroupLootHistoryFrame:Hide()
						end
					end)
				end
			end)
		end
	end
end

eventFrame:SetScript('OnEvent', function(self, event, ...)
	if event == "ENCOUNTER_END" then	
		roll_begin = true
		roll_cache = table.wipe(roll_cache)
		recent_encounterID = ...
	elseif event == "START_LOOT_ROLL" then
		local rollID = ...
		
		local _, itemName, _, _, _, canNeed, canGreed = GetLootRollItemInfo(rollID)
		
		SetRollCache(rollID, itemName, canNeed, canGreed)
		
		if roll_begin then
            roll_begin = false			
            C_Timer.After(1, function()
                for ind, info in pairs(roll_cache) do                   
                    DelayFunc(.3, function() 
						RollOnLoot(ind, info.action)
						T.msg(string.format(L["自动ROLL%s"], info.name, rollTypes[info.action]))
					end)
                end
            end)
        end
		
	elseif event == "LOOT_ROLLS_COMPLETE" then
		if FoundEncounterLootInfo(recent_encounterID) then
			local allRollsFinished = true
			local drops = C_LootHistory.GetSortedDropsForEncounter(GroupLootHistoryFrame.selectedEncounterID)
			for _, drop in ipairs(drops) do
				if not (drop.winner or drop.allPassed) then
					allRollsFinished = false
					break
				end
			end
			
			if allRollsFinished then
				TakeLootScreenshot(recent_encounterID)
			end
		end
	end
end)

T.UpdatedLootScreenShotEnabled = function()
	if aCoreCDB.ItemOptions.lootroll_screenshot then
		eventFrame:RegisterEvent("LOOT_ROLLS_COMPLETE")
	else
		eventFrame:UnregisterEvent("LOOT_ROLLS_COMPLETE")
	end
end

eventFrame:RegisterEvent("START_LOOT_ROLL")
eventFrame:RegisterEvent("ENCOUNTER_END")

T.RegisterInitCallback(T.UpdatedLootScreenShotEnabled)