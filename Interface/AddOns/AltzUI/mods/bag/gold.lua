local T, C, L, G = unpack(select(2, ...))

local Profit, Spent, OldMoney = 0, 0, 0

--====================================================--
--[[                   -- API --                    ]]--
--====================================================--

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

--====================================================--
--[[                -- Update --                    ]]--
--====================================================--
local eventframe = CreateFrame("Frame")

eventframe:SetScript("OnEvent", function(self, event)
	local NewMoney	= GetMoney()
	local Change = NewMoney - OldMoney -- Positive if we gain money
	
	if OldMoney > NewMoney then		-- Lost Money
		Spent = Spent - Change
	else							-- Gained Moeny
		Profit = Profit + Change
	end
	
	OldMoney = NewMoney
	aCoreDB.money[G.PlayerName] = GetMoney()
end)

eventframe:RegisterEvent("PLAYER_MONEY")
eventframe:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
eventframe:RegisterEvent("SEND_MAIL_COD_CHANGED")
eventframe:RegisterEvent("PLAYER_TRADE_MONEY")
eventframe:RegisterEvent("TRADE_MONEY_CHANGED")

local Gold = ContainerFrameCombinedBags.MoneyFrame

local function ShowMoneyTooltip()
	GameTooltip:SetOwner(Gold, "ANCHOR_TOPLEFT")
	GameTooltip:AddLine(L["本次登陆"]..": ", unpack(G.addon_color))
	GameTooltip:AddDoubleLine(L["赚得"], formatMoney(Profit), 1, 1, 1, 1, 1, 1)
	GameTooltip:AddDoubleLine(L["消费"], formatMoney(Spent), 1, 1, 1, 1, 1, 1)
	if Profit < Spent then
		GameTooltip:AddDoubleLine(L["赤字"], formatMoney(Profit-Spent), 1, 0, 0, 1, 1, 1)
	elseif (Profit-Spent)>0 then
		GameTooltip:AddDoubleLine(L["盈利"], formatMoney(Profit-Spent), 0, 1, 0, 1, 1, 1)
	end				
	GameTooltip:AddLine(" ")
	local totalGold = 0
	GameTooltip:AddLine(L["角色"]..": ", unpack(G.addon_color))
	for k,v in pairs(aCoreDB.money) do
		GameTooltip:AddDoubleLine(k, FormatTooltipMoney(v), 1, 1, 1, 1, 1, 1)
		totalGold = totalGold + v
	end 
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(L["服务器"]..": ", unpack(G.addon_color))
	GameTooltip:AddDoubleLine(TOTAL..": ", FormatTooltipMoney(totalGold), 1, 1, 1, 1, 1, 1)
	
	GameTooltip:Show()
end

local function HookTooltip(frame)
	frame:SetScript("OnEnter", function() ShowMoneyTooltip() end)
	frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

local buttons = {Gold, Gold.CopperButton, Gold.SilverButton, Gold.GoldButton}

for i, bu in ipairs(buttons) do
	HookTooltip(bu)
end

local ResetButton = T.ClickTexButton(Gold, {"RIGHT", Gold, "RIGHT", 0, 0}, G.iconFile.."refresh.tga", nil, nil, L["重置金币信息"])

ResetButton:SetScript("OnClick", function(self)
	aCoreDB.money = table.wipe(aCoreDB.money)
	aCoreDB.money[G.PlayerName] = GetMoney()
	ShowMoneyTooltip()
end)

hooksecurefunc("MoneyFrame_Update", function()
	Gold.CopperButton:ClearAllPoints()
	Gold.CopperButton:SetPoint("RIGHT", Gold, "RIGHT", -23, 0)
end)

T.RegisterEnteringWorldCallback(function()
	OldMoney = GetMoney()
	MONEY_TEXT_VADJUST = 0
end)

