local T, C, L, G = unpack(select(2, ...))

StaticPopupDialogs[G.uiname.."incorrect item ID"] = {
	text = L["不正确的物品ID"],
	button1 = ACCEPT, 
	hideOnEscape = 1, 
	whileDead = true,
	preferredIndex = 3,
}

StaticPopupDialogs[G.uiname.."incorrect item quantity"]= {
	text = L["不正确的数量"],
	button1 = ACCEPT, 
	hideOnEscape = 1, 
	whileDead = true,
	preferredIndex = 3,
}

StaticPopupDialogs[G.uiname.."incorrect spellid"] = {
	text = L["不正确的法术名称"],
	button1 = ACCEPT, 
	hideOnEscape = 1, 
	whileDead = true,
	preferredIndex = 3,
}

StaticPopupDialogs[G.uiname.."incorrect spell"] = {
	text = L["不正确的法术名称"],
	button1 = ACCEPT, 
	hideOnEscape = 1, 
	whileDead = true,
	preferredIndex = 3,
}

StaticPopupDialogs[G.uiname.."incorrect level"] = {
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