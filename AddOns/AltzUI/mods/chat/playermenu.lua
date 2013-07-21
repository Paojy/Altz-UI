local T, C, L, G = unpack(select(2, ...))

local function insertbefore(t, before, val)
	for k,v in ipairs(t) do if v == before then return table.insert(t, k, val) end end
	table.insert(t, val)
end

local clickers = {
	["COPYNAME"] = function(a1) ChatFrameShow(a1) end, 
	["WHO"] = SendWho,
	["GUILD_INVITE"] = GuildInvite,
	["ADDFRIEND"] = AddFriend,
}

UnitPopupButtons["COPYNAME"] = {text = L["Copy Name"], dist = 0}
UnitPopupButtons["WHO"] = {text = L["Who"], dist = 0}
UnitPopupButtons["GUILD_INVITE"] = {text = L["Guild Invite"], dist = 0}
UnitPopupButtons["ADDFRIEND"] = {text = L["Add Friend"], dist = 0}

insertbefore(UnitPopupMenus["FRIEND"], "IGNORE", "COPYNAME")
insertbefore(UnitPopupMenus["FRIEND"], "COPYNAME", "WHO")
insertbefore(UnitPopupMenus["FRIEND"], "WHO", "GUILD_INVITE")
insertbefore(UnitPopupMenus["FRIEND"], "GUILD_INVITE", "ADDFRIEND")

hooksecurefunc("UnitPopup_HideButtons", function()
	local dropdownMenu = UIDROPDOWNMENU_INIT_MENU
	for index, value in ipairs(UnitPopupMenus[dropdownMenu.which]) do
		if ( value == "WHO" ) then
			if ( haveBattleTag or dropdownMenu.name == UnitName("player")) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "GUILD_INVITE" ) then
			if ( haveBattleTag or not CanGuildInvite() or dropdownMenu.name == UnitName("player")) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		elseif ( value == "ADDFRIEND" ) then
			if ( haveBattleTag or dropdownMenu.name == UnitName("player")) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		end
	end
end)

hooksecurefunc("UnitPopup_OnClick", function(self)
	local dropdownFrame = UIDROPDOWNMENU_INIT_MENU
	local button = self.value
	if clickers[button] then clickers[button](dropdownFrame.name) end
	PlaySound("UChatScrollButton")
end)

function ChatFrameShow(name)
    local eb = LAST_ACTIVE_CHAT_EDIT_BOX
    if eb then
      eb:SetText(name or "")
      eb:SetFocus()
      eb:HighlightText()
    end
end