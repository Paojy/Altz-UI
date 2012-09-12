local addon, ns = ...

local L = {}

L["Sort"] = "S"
L["Bag"] = "B"


if GetLocale() == "zhCN" then
	L["Sort"] = "理"
	L["Bag"] = "包"
end

if GetLocale() == "zhTW" then
	L["Sort"] = "理"
	L["Bag"] = "包"
end

ns.L = L