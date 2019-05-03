local T, C, L, G = unpack(select(2, ...))
local F, C = unpack(AuroraClassic)

if not aCoreCDB["ItemOptions"]["enablebag"] then return end

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

local ResetButton = CreateFrame("Button", "Reset_Statistics", Gold)
ResetButton:SetSize(15, 15)
ResetButton:SetPoint("LEFT", Gold, "RIGHT", -5, 0)
ResetButton:SetFrameLevel(Gold:GetFrameLevel()+2)
ResetButton:SetAlpha(0)

ResetButton.tex = ResetButton:CreateTexture(nil, "ARTWORK")
ResetButton.tex:SetAllPoints()
ResetButton.tex:SetTexture("Interface\\Buttons\\UI-RefreshButton")
ResetButton:RegisterForClicks("AnyDown")

local function ShowMoneyTooltip()
	GameTooltip:SetOwner(Gold, "ANCHOR_NONE")
	GameTooltip:SetPoint("BOTTOMLEFT", _G[G.uiname.."bag"], "TOPLEFT", -1, 2)
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
	ResetButton:SetAlpha(1)
end

Gold:SetScript("OnEnter", function() ShowMoneyTooltip() end)
Gold:SetScript("OnLeave", function() GameTooltip:Hide() end)

for i, child in ipairs({Gold:GetChildren()}) do
	child:SetScript("OnEnter", function() ShowMoneyTooltip() end)
	child:SetScript("OnLeave", function() GameTooltip:Hide() ResetButton:SetAlpha(0) end)
end

ResetButton:SetScript("OnClick", function(self)
	aCoreDB.gold[G.PlayerRealm] = {}
	aCoreDB.gold[G.PlayerRealm][G.PlayerName] = GetMoney()
	ShowMoneyTooltip()
end)

ResetButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("BOTTOMLEFT", _G[G.uiname.."bag"], "TOPLEFT", -1, 2)
	GameTooltip:AddLine(L["重置金币信息"])
	GameTooltip:Show()
	self:SetAlpha(1)
end)

ResetButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
	self:SetAlpha(0)
end)