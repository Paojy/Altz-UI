--ncHoverBind
local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)

local bind, localmacros = CreateFrame("Frame", "ncHoverBind", UIParent), 0
-- SLASH COMMAND
SlashCmdList.MOUSEOVERBIND = function()
	LoadAddOn("Blizzard_BindingUI")
	KeyBindingFrame.keyID = 1; 
	KeyBindingFrame:EnterQuickKeybind();
end

SLASH_MOUSEOVERBIND1 = "/hb"
SLASH_MOUSEOVERBIND2 = "/hoverbind"