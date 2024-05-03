local T, C, L, G = unpack(select(2, ...))

StaticPopupDialogs[G.uiname.."incorrect itemID"] = {
	text = L["不正确的物品ID"],
	button1 = ACCEPT, 
	hideOnEscape = 1, 
	whileDead = true,
	preferredIndex = 3,
}

StaticPopupDialogs[G.uiname.."incorrect spellID"] = {
	text = L["不是一个有效的法术ID"],
	button1 = ACCEPT, 
	hideOnEscape = 1, 
	whileDead = true,
	preferredIndex = 3,
}

StaticPopupDialogs[G.uiname.."incorrect number"] = {
	text = L["必须是一个数字"],
	button1 = ACCEPT, 
	hideOnEscape = 1, 
	whileDead = true,
	preferredIndex = 3,
}

StaticPopupDialogs[G.uiname.."Reset Confirm"] = {
	text = L["重置确认"],
	button1 = ACCEPT,
	button2 = CANCEL,
	showAlert = true,
	hideOnEscape = 1, 
	whileDead = true,
	preferredIndex = 3,
}

StaticPopupDialogs[G.uiname.."Import Confirm"] = {
	text = L["导入确认"],
	button1 = ACCEPT,
	button2 = CANCEL,
	hideOnEscape = 1, 
	whileDead = true,
	preferredIndex = 3,
}

StaticPopupDialogs[G.uiname.."Cannot Import"] = {
	text = L["无法导入"],
	button1 = ACCEPT,
	hideOnEscape = 1, 
	whileDead = true,
	preferredIndex = 3,
}

StaticPopupDialogs[G.uiname.."Run Setup"] = {
	text = "/setup "..L["设置向导"],
	button1 = ACCEPT,
	hideOnEscape = 1, 
	whileDead = true,
	preferredIndex = 3,
}

StaticPopupDialogs[G.uiname.."Reload Alert"] = {
	text = RELOADUI..L["生效"],
	button1 = RELOADUI,
	button2 = L["稍后重载"],
	OnAccept = ReloadUI,
	showAlert = 1,
}

StaticPopupDialogs[G.uiname.."InCombat Alert"] = {
	text = L["脱离战斗"]..L["生效"],
	button1 = RELOADUI,
	button2 = L["稍后重载"],
	OnAccept = ReloadUI,
	showAlert = 1,
}

StaticPopupDialogs[G.uiname.."hideAFKtips"] = {
	text = L["隐藏提示的提示"],
	button1 = ACCEPT, 
	hideOnEscape = 1, 
	whileDead = true,
	preferredIndex = 3,
}

--====================================================--
--[[                 -- Blz fix --                  ]]--
--====================================================--

T.RegisterEnteringWorldCallback(function()
	if UnitIsDead("player") then
		StaticPopup_Show("DEATH")
	end
end)