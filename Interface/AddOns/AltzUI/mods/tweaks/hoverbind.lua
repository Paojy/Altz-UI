--ncHoverBind
local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)

local hide
-- SLASH COMMAND
SlashCmdList.MOUSEOVERBIND = function()
	LoadAddOn("Blizzard_BindingUI")
	KeyBindingFrame.keyID = 1; 
	KeyBindingFrame:EnterQuickKeybind();
	
	if not hide then
		QuickKeybindFrame:HookScript("OnHide", function()
			HideUIPanel(KeyBindingFrame)
		end)
		KeyBindingFrame:HookScript("OnHide", function()
			HideUIPanel(GameMenuFrame)
		end)
		hide = true
	end
end

SLASH_MOUSEOVERBIND1 = "/hb"
SLASH_MOUSEOVERBIND2 = "/hoverbind"