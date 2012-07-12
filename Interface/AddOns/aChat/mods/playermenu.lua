local ADDON_NAME, ns = ...
local cfg = ns.cfg


if not cfg.playermenu then return end

-- name copy and guild invite 

local function insertbefore(t, before, val)
	for k,v in ipairs(t) do if v == before then return table.insert(t, k, val) end end
	table.insert(t, val)
end

local clickers = {["COPYNAME"] = function(a1) ChatFrameShow(a1) end, ["WHO"] = SendWho, ["GUILD_INVITE"] = GuildInvite}

UnitPopupButtons["COPYNAME"] = {text = "Copy Name", dist = 0}
UnitPopupButtons["GUILD_INVITE"] = {text = "Guild Invite", dist = 0}
UnitPopupButtons["WHO"] = {text = "Who", dist = 0}

insertbefore(UnitPopupMenus["FRIEND"], "GUILD_PROMOTE", "GUILD_INVITE")
insertbefore(UnitPopupMenus["FRIEND"], "IGNORE", "COPYNAME")
insertbefore(UnitPopupMenus["FRIEND"], "IGNORE", "WHO")

hooksecurefunc("UnitPopup_HideButtons", function()
	local dropdownMenu = UIDROPDOWNMENU_INIT_MENU
	for i,v in pairs(UnitPopupMenus[dropdownMenu.which]) do
		if v == "GUILD_INVITE" then UnitPopupShown[i] = (not CanGuildInvite() or dropdownMenu.name == UnitName("player")) and 0 or 1
		elseif clickers[v] then UnitPopupShown[i] = (dropdownMenu.name == UnitName("player") and 0) or 1 end
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


local EasyAddFriend = CreateFrame("Frame","EasyAddFriendFrame")
EasyAddFriend:SetScript("OnEvent", function() hooksecurefunc("UnitPopup_ShowMenu", EasyAddFriendCheck) EasyAddFriendSlash() end)
EasyAddFriend:RegisterEvent("PLAYER_LOGIN")

local PopupUnits = {"PARTY", "PLAYER", "RAID_PLAYER", "RAID", "FRIEND", "TEAM", "CHAT_ROSTER", "TARGET", "FOCUS"}

local AddFriendButtonInfo = {
	text = "Add friend",
	value = "ADD_FRIEND",
	func = function() AddFriend(UIDROPDOWNMENU_OPEN_MENU.name) end,
	notCheckable = 1,
}

local CancelButtonInfo = {
	text = "Cancel",
	value = "CANCEL",
	notCheckable = 1
}

function EasyAddFriendSlash()
	SLASH_EASYADDFRIEND1 = "/add";
	SlashCmdList["EASYADDFRIEND"] = function(msg) if #msg == 0 then DEFAULT_CHAT_FRAME:AddMessage("EasyAddFriend: Use '/add' followed by a character's name to add them to your friends list.") else AddFriend(msg) end end
end

function EasyAddFriendCheck()		
	local PossibleButton = getglobal("DropDownList1Button"..(DropDownList1.numButtons)-1)
	if PossibleButton["value"] ~= "ADD_FRIEND" then
		local GoodUnit = false
		for i=1, #PopupUnits do	
		if OPEN_DROPDOWNMENUS[1]["which"] == PopupUnits[i] then	
			GoodUnit = true
			end
		end
		if UIDROPDOWNMENU_OPEN_MENU["unit"] == "target" and ((not UnitIsPlayer("target")) or (not UnitIsFriend("player", "target"))) then
			GoodUnit = false
		end
		if GoodUnit then				
			local IsAlreadyFriend = false
			for z=1, GetNumFriends() do
				if GetFriendInfo(z) == UIDROPDOWNMENU_OPEN_MENU["name"] or UIDROPDOWNMENU_OPEN_MENU["name"] == UnitName("player") then
					IsAlreadyFriend = true
				end
			end
			if not IsAlreadyFriend then				
				CreateAddFriendButton()
			
			end
		end
	end		
end

function CreateAddFriendButton()

		local CancelButtonFrame = getglobal("DropDownList1Button"..DropDownList1.numButtons)
		CancelButtonFrame:Hide()
		DropDownList1.numButtons = DropDownList1.numButtons - 1
		UIDropDownMenu_AddButton(AddFriendButtonInfo)
		UIDropDownMenu_AddButton(CancelButtonInfo)
	
   end