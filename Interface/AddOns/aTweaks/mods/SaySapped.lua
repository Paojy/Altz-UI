local ADDON_NAME, ns = ...
local cfg = ns.cfg
local L = ns.L

if not cfg.saysapped then return end

local SaySapped = CreateFrame("Frame")
SaySapped.playername = UnitName("player")

SaySapped:SetScript("OnEvent",function(...)

	if ((select(14,...) == 6770)
	and (select(11,...) == SaySapped.playername)
	and (select(4,...) == "SPELL_AURA_APPLIED" or select(4,...) == "SPELL_AURA_REFRESH"))
	then
		SendChatMessage(L["Sapped!"], "SAY")
		DEFAULT_CHAT_FRAME:AddMessage(L["sapped by:"].." "..(select(7,...) or "(unknown)"))
	end
end)

SaySapped:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
