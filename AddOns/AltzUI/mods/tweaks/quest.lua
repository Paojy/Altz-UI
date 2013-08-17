-- Original Author: Weasoug, etc
local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)

local autoquests = aCoreCDB["OtherOptions"]["autoquests"]

--显示任务等级
local function questlevel()
	local buttons = QuestLogScrollFrame.buttons
	local numButtons = #buttons
	local scrollOffset = HybridScrollFrame_GetOffset(QuestLogScrollFrame)
	local numEntries, numQuests = GetNumQuestLogEntries()

	for i = 1, numButtons do
		local questIndex = i + scrollOffset
		local questLogTitle = buttons[i]
		if questIndex <= numEntries then
			local title, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily = GetQuestLogTitle(questIndex)
			if not isHeader then
				questLogTitle:SetText("[" .. level .. "] " .. title)
				QuestLogTitleButton_Resize(questLogTitle)
			end
		end
	end
end
hooksecurefunc("QuestLog_Update", questlevel)
QuestLogScrollFrameScrollBar:HookScript("OnValueChanged", questlevel)
	
if autoquests then
  local Monomyth = CreateFrame("Frame")
    Monomyth:SetScript("OnEvent", function(self, event, ...) self[event](...) end)

	local DelayHandler
	do
		local currentInfo = {}

		local Delayer = Monomyth:CreateAnimationGroup()
		Delayer:CreateAnimation():SetDuration(.5)
		Delayer:SetLooping("NONE")
		Delayer:SetScript("OnFinished", function()
			DelayHandler(unpack(currentInfo))
		end)

		local delayed = true
		function DelayHandler(func, ...)
			if(delayed) then
				delayed = false

				table.wipe(currentInfo)
				table.insert(currentInfo, func)

				for index = 1, select("#", ...) do
					local argument = select(index, ...)
					table.insert(currentInfo, argument)
				end

				Delayer:Play()
			else
				delayed = true
				func(...)
			end
		end
	end

	local delayEvent = {
		GOSSIP_SHOW = true,
		GOSSIP_CONFIRM = true,
		QUEST_GREETING = true,
		QUEST_DETAIL = true,
		QUEST_ACCEPT_CONFIRM = true,
		QUEST_PROGRESS = true,
		QUEST_AUTOCOMPLETE = true,
	}

    function Monomyth:Register(event, func, override)
        self:RegisterEvent(event)
        self[event] = function(...)
            if override or not IsShiftKeyDown() then
                if delayEvent[event] then
					DelayHandler(func, ...)
				else
					func(...)
				end
            end
        end
    end

    local function IsTrackingTrivial()
        for index = 1, GetNumTrackingTypes() do
            local name, _, active = GetTrackingInfo(index)
            if(name == MINIMAP_TRACKING_TRIVIAL_QUESTS) then
                return active
            end
        end
    end

    Monomyth:Register("QUEST_GREETING", function()
        local active = GetNumActiveQuests()
        if(active > 0) then
            for index = 1, active do
                local _, complete = GetActiveTitle(index)
                if(complete) then
                    SelectActiveQuest(index)
                end
            end
        end

        local available = GetNumAvailableQuests()
        if(available > 0) then
            for index = 1, available do
                if(not IsAvailableQuestTrivial(index) or IsTrackingTrivial()) then
                    SelectAvailableQuest(index)
                end
            end
        end
    end)

    -- This should be part of the API, really
    local function IsGossipQuestCompleted(index)
        return not not select(((index * 5) - 5) + 4, GetGossipActiveQuests())
    end

    local function IsGossipQuestTrivial(index)
        return not not select(((index * 6) - 6) + 3, GetGossipAvailableQuests())
    end

    Monomyth:Register("GOSSIP_SHOW", function()
        local active = GetNumGossipActiveQuests()
        if(active > 0) then
            for index = 1, active do
                if(IsGossipQuestCompleted(index)) then
                    SelectGossipActiveQuest(index)
                end
            end
        end

        local available = GetNumGossipAvailableQuests()
        if(available > 0) then
            for index = 1, available do
                if(not IsGossipQuestTrivial(index) or IsTrackingTrivial()) then
                    SelectGossipAvailableQuest(index)
                end
            end
        end

		if(available == 0 and active == 0 and GetNumGossipOptions() == 1) then
			local _, instance = GetInstanceInfo()
			if instance ~= "raid" then
				local _, type = GetGossipOptions()
				if(type == "gossip") then
					SelectGossipOption(1)
					return
				end
			end
		end
    end)

	local ignoredItems = {
        -- Inscription weapons
        [31690] = true, -- Inscribed Tiger Staff
        [31691] = true, -- Inscribed Crane Staff
        [31692] = true, -- Inscribed Serpent Staff

        -- Darkmoon Faire artifacts
        [29443] = true, -- Imbued Crystal
        [29445] = true, -- Mysterious Grimoire
        [29451] = true, -- A Treatise on Strategy
        [29456] = true, -- Banner of the Fallen
        [29457] = true, -- Captured Insignia
        [29458] = true, -- Fallen Adventurer's Journal
        [29464] = true, -- Soothsayer's Runes
    }

	--/run print(("NPC ID of %s: %d"):format(UnitName("target"), tonumber(UnitGUID("target"):sub(6, 10), 16)))
    local darkmoonNPC = {
        [57850] = true, -- Teleportologist Fozlebub
        [55382] = true, -- Darkmoon Faire Mystic Mage (Horde)
        [54334] = true, -- Darkmoon Faire Mystic Mage (Alliance)
    }

    Monomyth:Register("GOSSIP_CONFIRM", function(index)
        local GUID = UnitGUID("target") or ""
        local creatureID = tonumber(string.sub(GUID, -12, -9), 16)

        if(creatureID and darkmoonNPC[creatureID]) then
            SelectGossipOption(index, "", true)
            StaticPopup_Hide("GOSSIP_CONFIRM")
        end
    end)

    QuestFrame:UnregisterEvent("QUEST_DETAIL")
    Monomyth:Register("QUEST_DETAIL", function()
        if(not QuestGetAutoAccept() and not QuestIsFromAreaTrigger()) then
            QuestFrame_OnEvent(QuestFrame, "QUEST_DETAIL")

            if not IsShiftKeyDown() then
                AcceptQuest()
            end
        end
    end, true)

    Monomyth:Register("QUEST_ACCEPT_CONFIRM", AcceptQuest)

    Monomyth:Register("QUEST_ACCEPTED", function(id)
        if(not GetCVarBool("autoQuestWatch")) then return end

        if(not IsQuestWatched(id) and GetNumQuestWatches() < MAX_WATCHABLE_QUESTS) then
            AddQuestWatch(id)
        end
    end)

    local choiceQueue
    Monomyth:Register("QUEST_ITEM_UPDATE", function(...)
        if(choiceQueue and Monomyth[choiceQueue]) then
			Monomyth[choiceQueue]()
		end
    end)

	Monomyth:Register("QUEST_PROGRESS", function()
        if(IsQuestCompletable()) then
			local requiredItems = GetNumQuestItems()
			if(requiredItems > 0) then
				for index = 1, requiredItems do
					local link = GetQuestItemLink("required", index)
					if(link) then
						local id = tonumber(string.match(link, "item:(%d+)"))
						for _, itemID in pairs(ignoredItems) do
							if(itemID == id) then
								return
							end
						end
					else
						choiceQueue = "QUEST_PROGRESS"
						return
					end
				end
			end

			CompleteQuest()
		end
    end)

    Monomyth:Register("QUEST_COMPLETE", function()
		local choices = GetNumQuestChoices()
		if(choices <= 1) then
			GetQuestReward(1)
		elseif(choices > 1) then
			local bestValue, bestIndex = 0

			for index = 1, choices do
				local link = GetQuestItemLink("choice", index)
				if(link) then
					local _, _, _, _, _, _, _, _, _, _, value = GetItemInfo(link)

					if(string.match(link, "item:45724:")) then
						-- Champion's Purse, contains 10 gold
						value = 1e5
					end

					if(value > bestValue) then
						bestValue, bestIndex = value, index
					end
				else
					choiceQueue = "QUEST_COMPLETE"
					return GetQuestItemInfo("choice", index)
				end
			end

			if(bestIndex) then
				_G["QuestInfoItem" .. bestIndex]:Click()
			end
		end
	end)

    Monomyth:Register("QUEST_FINISHED", function()
        choiceQueue = nil
    end)

    Monomyth:Register("QUEST_AUTOCOMPLETE", function(id)
        local index = GetQuestLogIndexByID(id)
		if(GetQuestLogIsAutoComplete(index)) then
			-- The quest might not be considered complete, investigate later
			ShowQuestComplete(index)
		end
    end)

	local atBank, atMail, atMerchant
		
    Monomyth:Register("MERCHANT_SHOW", function()
        atMerchant = true
    end)

    Monomyth:Register("MERCHANT_CLOSED", function()
        atMerchant = false
    end)

    Monomyth:Register("BANKFRAME_OPENED", function()
        atBank = true
    end)

    Monomyth:Register("BANKFRAME_CLOSED", function()
        atBank = false
    end)

    Monomyth:Register("GUILDBANKFRAME_OPENED", function()
        atBank = true
    end)

    Monomyth:Register("GUILDBANKFRAME_CLOSED", function()
        atBank = false
    end)

    Monomyth:Register("MAIL_SHOW", function()
        atMail = true
    end)

    Monomyth:Register("MAIL_CLOSED", function()
        atMail = false
    end)

	local questTip = CreateFrame("GameTooltip", "MonomythTip", UIParent, "GameTooltipTemplate")
	local questLevel = string.gsub(ITEM_MIN_LEVEL, "%%d", "(%%d+)")

	local function GetQuestItemLevel()
		for index = 1, questTip:NumLines() do
			local level = string.match(_G["MonomythTipTextLeft" .. index]:GetText(), questLevel)
			if(level and tonumber(level)) then
				return tonumber(level)
			end
		end
	end

	local function BagUpdate(bag)
		if(atBank or atMail or atMerchant) then return end

        for slot = 1, GetContainerNumSlots(bag) do
            local _, id, active = GetContainerItemQuestInfo(bag, slot)
            if(id and not active and not IsQuestFlaggedCompleted(id) and not ignoredItems[id]) then
                questTip:SetOwner(UIParent, "ANCHOR_NONE")
                questTip:ClearLines()
                questTip:SetBagItem(bag, slot)
				questTip:Show()

				local level = GetQuestItemLevel()
				questTip:Hide()
				if(not level or level <= UnitLevel("player")) then
					UseContainerItem(bag, slot)
				end
            end
        end
	end

    Monomyth:Register("PLAYER_LOGIN", function()
		Monomyth:Register("BAG_UPDATE", BagUpdate)
	end)

    local errors = {
        [ERR_QUEST_ALREADY_DONE] = true,
        [ERR_QUEST_FAILED_LOW_LEVEL] = true,
        [ERR_QUEST_NEED_PREREQS] = true,
    }

    ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(self, event, message)
        return errors[message]
    end)

    QuestInfoDescriptionText.SetAlphaGradient = function() return false end
end