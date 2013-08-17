local T, C, L, G = unpack(select(2, ...))
local F, C = unpack(Aurora)

local Profit, Spent, OldMoney = 0, 0, 0

local function formatMoney(money)
	local gold = floor(math.abs(money) / 10000)
	local silver = mod(floor(math.abs(money) / 100), 100)
	local copper = mod(floor(math.abs(money)), 100)
	if gold ~= 0 then
		return format("%s".."|cffffd700g|r".." %s".."|cffc7c7cfs|r".." %s".."|cffeda55fc|r", gold, silver, copper)
	elseif silver ~= 0 then
		return format("%s".."|cffc7c7cfs|r".." %s".."|cffeda55fc|r", silver, copper)
	else
		return format("%s".."|cffeda55fc|r", copper)
	end
end

local function FormatTooltipMoney(money)
	local gold, silver, copper = abs(money / 10000), abs(mod(money / 100, 100)), abs(mod(money, 100))
	local cash = ""
	cash = format("%d".."|cffffd700g|r".." %d".."|cffc7c7cfs|r".." %d".."|cffeda55fc|r", gold, silver, copper)		
	return cash
end	
	
local eventframe = CreateFrame("Frame")

eventframe:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		OldMoney = GetMoney()
		if aCoreDB.gold[G.PlayerRealm] == nil then 
			aCoreDB.gold[G.PlayerRealm] = {}
		end	
	end
		
	local NewMoney	= GetMoney()
	local Change = NewMoney - OldMoney -- Positive if we gain money
		
	if OldMoney > NewMoney then		-- Lost Money
		Spent = Spent - Change
	else							-- Gained Moeny
		Profit = Profit + Change
	end
	
	OldMoney = NewMoney

	aCoreDB.gold[G.PlayerRealm][G.PlayerName] = GetMoney()
end)

eventframe:RegisterEvent("PLAYER_MONEY")
eventframe:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
eventframe:RegisterEvent("SEND_MAIL_COD_CHANGED")
eventframe:RegisterEvent("PLAYER_TRADE_MONEY")
eventframe:RegisterEvent("TRADE_MONEY_CHANGED")
eventframe:RegisterEvent("PLAYER_ENTERING_WORLD")

local Gold = ContainerFrame1MoneyFrame

local function ShowMoneyTooltip()
	GameTooltip:SetOwner(Gold, "ANCHOR_NONE")
	GameTooltip:SetPoint("BOTTOMLEFT", _G[G.uiname.."bag"], "TOPLEFT", -3, 5)
	GameTooltip:AddLine(L["本次登陆"]..": ", G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
	GameTooltip:AddDoubleLine(L["赚得"], formatMoney(Profit), 1, 1, 1, 1, 1, 1)
	GameTooltip:AddDoubleLine(L["消费"], formatMoney(Spent), 1, 1, 1, 1, 1, 1)
	if Profit < Spent then
		GameTooltip:AddDoubleLine(L["赤字"], formatMoney(Profit-Spent), 1, 0, 0, 1, 1, 1)
	elseif (Profit-Spent)>0 then
		GameTooltip:AddDoubleLine(L["盈利"], formatMoney(Profit-Spent), 0, 1, 0, 1, 1, 1)
	end				
	GameTooltip:AddLine(" ")
	local totalGold = 0				
	GameTooltip:AddLine(L["角色"]..": ", G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
	for k,v in pairs(aCoreDB.gold[G.PlayerRealm]) do
		GameTooltip:AddDoubleLine(k, FormatTooltipMoney(v), 1, 1, 1, 1, 1, 1)
		totalGold = totalGold + v
	end 
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(L["服务器"]..": ", G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
	GameTooltip:AddDoubleLine(TOTAL..": ", FormatTooltipMoney(totalGold), 1, 1, 1, 1, 1, 1)
	for i = 1, MAX_WATCHED_TOKENS do
		local name, count, extraCurrencyType, icon, itemID = GetBackpackCurrencyInfo(i)
		if name and i == 1 then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(CURRENCY, G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
		end
		local r, g, b = 1 ,1 ,1
		if itemID then r, g, b = GetItemQualityColor(select(3, GetItemInfo(itemID))) end
		if name and count then GameTooltip:AddDoubleLine(name, count, 1, 1, 1, 1, 1, 1) end
	end
	GameTooltip:Show()
end

Gold:SetScript("OnEnter", function() ShowMoneyTooltip() end)
Gold:SetScript("OnLeave", function() GameTooltip:Hide() end)

for i, child in ipairs({Gold:GetChildren()}) do
	child:SetScript("OnEnter", function() ShowMoneyTooltip() end)
	child:SetScript("OnLeave", function() GameTooltip:Hide() end)
end