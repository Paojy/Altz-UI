local T, C, L, G = unpack(select(2, ...))

local function GetProfessionTag(parentProfessionID)
	local professions = {GetProfessions()}
	for _, index in pairs(professions) do
		local name, icon, _, _, _, _, skillLine = GetProfessionInfo(index)
		if skillLine == parentProfessionID then
			return "|T"..icon..":12:12:0:0:64:64:4:60:4:60|t"..name
		end
	end
end

local function GetProfessionConcentration()
	local professionInfo = Professions.GetProfessionInfo()
	local concentrationCurrency = C_TradeSkillUI.GetConcentrationCurrencyID(professionInfo.professionID);
	local hasConcentration = concentrationCurrency ~= 0;
	if hasConcentration then
		local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(concentrationCurrency)
		local quantity = currencyInfo.quantity
		local tag = GetProfessionTag(professionInfo.parentProfessionID)
		return professionInfo.parentProfessionID, tag, quantity
	end
end

local function ShowConcentrationTooltip()
	local Button = ProfessionsFrame.CraftingPage.ConcentrationDisplay
	GameTooltip:SetOwner(Button, "ANCHOR_BOTTOMRIGHT")
	GameTooltip:AddLine(PROFESSIONS_CRAFTING_STAT_CONCENTRATION..": ", unpack(G.addon_color))
	
	local t = {}
	for player, v in pairs(aCoreDB.concentration) do
		for parentProfessionID, info in pairs(v) do
			table.insert(t, {player = player, parentProfessionID = parentProfessionID, tag = info.tag, quantity = info.quantity})
		end
	end
	
	table.sort(t, function(a, b)
		if a.quantity ~= b.quantity then
			return a.quantity > b.quantity
		elseif a.parentProfessionID ~= b.parentProfessionID then
			return a.parentProfessionID > b.parentProfessionID
		else
			return a.player > b.player
		end
	end)
	
	for i, info in pairs(t) do
		GameTooltip:AddDoubleLine(info.player, info.tag.." "..info.quantity, 1, 1, 1, 1, 1, 1)
	end
	
	GameTooltip:Show()
end

local function UpdateConcentrationInfo()
	local parentProfessionID, tag, quantity = GetProfessionConcentration()
	if parentProfessionID and tag and quantity then
		if aCoreDB.concentration[G.PlayerName] == nil then
			aCoreDB.concentration[G.PlayerName] = {}
		end
		if not aCoreDB.concentration[G.PlayerName][parentProfessionID] then
			aCoreDB.concentration[G.PlayerName][parentProfessionID] = {}
		end
		aCoreDB.concentration[G.PlayerName][parentProfessionID]["tag"] = tag
		aCoreDB.concentration[G.PlayerName][parentProfessionID]["quantity"] = quantity
	end
end

local function CreateResetButton()
	local Button = ProfessionsFrame.CraftingPage.ConcentrationDisplay
	local ResetButton = T.ClickTexButton(Button, {"LEFT", Button, "RIGHT", 0, 0}, G.iconFile.."refresh.tga", nil, nil, L["重置专注信息"])
	
	ResetButton:SetScript("OnClick", function(self)
		aCoreDB.concentration = table.wipe(aCoreDB.concentration)
		UpdateConcentrationInfo()
	end)
end

local function HookTooltip(frame)
	frame:HookScript("OnEnter", function() ShowConcentrationTooltip() end)
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")

eventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" then
		local addon = ...
		if addon == "Blizzard_Professions" then
			CreateResetButton()
			HookTooltip(ProfessionsFrame.CraftingPage.ConcentrationDisplay)
			hooksecurefunc(ProfessionsFrame.CraftingPage, "Init", function()
				UpdateConcentrationInfo()
			end)
		end
	end
end)

