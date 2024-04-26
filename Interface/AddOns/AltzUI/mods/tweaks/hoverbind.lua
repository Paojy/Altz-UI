--ncHoverBind
local T, C, L, G = unpack(select(2, ...))

local hooked
-- SLASH COMMAND
SlashCmdList.MOUSEOVERBIND = function()
	EditModeManagerFrame:ClearSelectedSystem();
	EditModeManagerFrame:SetEditModeLockState("hideSelections");
	HideUIPanel(EditModeManagerFrame);
	QuickKeybindFrame:Show()
	
	if not hooked then
		QuickKeybindFrame:HookScript("OnHide", function()
			HideUIPanel(SettingsPanel)
		end)
		SettingsPanel:HookScript("OnHide", function()
			HideUIPanel(GameMenuFrame)
		end)
		hooked = true
	end
end

SLASH_MOUSEOVERBIND1 = "/hb"
SLASH_MOUSEOVERBIND2 = "/hoverbind"