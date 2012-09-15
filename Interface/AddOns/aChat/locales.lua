local addon, ns = ...

local L = {}

L["Copy Name"] = "Copy Name"
L["Who"] = "Who"
L["Guild Invite"] = "Guild Invite"
L["Add Friend"] = "Add Friend"

if GetLocale() == "zhCN" then
	L["Copy Name"] = "复制名字"
	L["Who"] = "详情"
	L["Guild Invite"] = "公会邀请"
	L["Add Friend"] = "添加好友"
end

if GetLocale() == "zhTW" then
	L["Copy Name"] = "復制名字"
	L["Who"] = "詳情"
	L["Guild Invite"] = "公會邀請"
	L["Add Friend"] = "添加好友"
end

ns.L = L