--Author: Moolgar
local ADDON_NAME, ns = ...
local cfg = ns.cfg

if not cfg.tabtargetplayer then return end

TabTargetPlayerEventFrame = CreateFrame("Frame")
TabTargetPlayerEventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA");

function RebindTab_OnEvent(self,event,...)
	if event=="ZONE_CHANGED_NEW_AREA" then
		SetMapToCurrentZone()
		local CurrentTabBind = GetCurrentBindingSet();
		local pvpType = GetZonePVPInfo();
		local z = GetCurrentMapAreaID();
		TabBinderTargetKey = GetBindingKey("TARGETNEARESTENEMYPLAYER");
		if TabBinderTargetKey == nil then
			TabBinderTargetKey = GetBindingKey("TARGETNEARESTENEMY");
		end
		if TabBinderTargetKey == nil then
			TabBinderTargetKey = "TAB"
		end
		local CurrentTargetBind = GetBindingAction(TabBinderTargetKey);
		if (pvpType == "arena") or (z == 443 or z == 30 or z == 4 or z == 461 or z == 401 or z == 482 or z == 512 or z == 540 or z == 736 or z == 626) then
			if CurrentTargetBind ~= "TARGETNEARESTENEMYPLAYER" then
				TargetBindSet = SetBinding(TabBinderTargetKey,"TARGETNEARESTENEMYPLAYER");
				if TargetBindSet == 1 then
					SaveBindings(CurrentTabBind);
				else
					DEFAULT_CHAT_FRAME:AddMessage("failed to update bind");
				end
			end
		else
			if CurrentTargetBind ~= "TARGETNEARESTENEMY" then
				TargetBindSet = SetBinding(TabBinderTargetKey,"TARGETNEARESTENEMY");
				if TargetBindSet == 1 then
					SaveBindings(CurrentTabBind);
				else
					DEFAULT_CHAT_FRAME:AddMessage("failed to update bind");
				end
			end
		end
	end
end

TabTargetPlayerEventFrame:SetScript("OnEvent", RebindTab_OnEvent)