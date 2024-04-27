local T, C, L, G = unpack(select(2, ...))

local modifier = "shift" --- "alt" "ctrl"
local mouseButton = "1" --- 1 = leftbutton, 2 = tightbutton, 3 = middle button(mouse wheel)

local function Init()	
	-- Keybinding override so that models can be shift/alt/ctrl+clicked 
	local f = CreateFrame("CheckButton", "FocuserButton", UIParent, "SecureActionButtonTemplate") 
	f:SetAttribute("type1","macro") 
	f:SetAttribute("macrotext","/focus mouseover") 
	SetOverrideBindingClick(FocuserButton, true, modifier.."-BUTTON"..mouseButton, "FocuserButton") 
end

T.RegisterInitCallback(Init)




