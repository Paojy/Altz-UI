local T, C, L, G = unpack(select(2, ...))

local default_uf = { 
	oUF_AltzPlayer, 
	oUF_AltzPet,
	oUF_AltzTarget, 
	oUF_AltzTargetTarget, 
}

local modifier = "shift" --- "alt" "ctrl"
local mouseButton = "1" --- 1 = leftbutton, 2 = tightbutton, 3 = middle button(mouse wheel)

local function Init()
	if not aCoreCDB["OtherOptions"]["shiftfocus"] then return end
	
	-- Keybinding override so that models can be shift/alt/ctrl+clicked 
	local f = CreateFrame("CheckButton", "FocuserButton", UIParent, "SecureActionButtonTemplate") 
	f:SetAttribute("type1","macro") 
	f:SetAttribute("macrotext","/focus mouseover") 
	SetOverrideBindingClick(FocuserButton, true, modifier.."-BUTTON"..mouseButton, "FocuserButton") 
	
	-- Set the keybindings on the default unit frames
	for i, frame in pairs(default_uf) do
		frame:SetAttribute(modifier.."-type"..mouseButton,"focus") 
	end
end

T.RegisterInitCallback(Init)




