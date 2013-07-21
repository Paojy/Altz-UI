local T, C, L, G = unpack(select(2, ...))

local modifier = "shift" --- "alt" "ctrl"
local mouseButton = "1" --- 1 = leftbutton, 2 = tightbutton, 3 = middle button(mouse wheel)

local function SetFocusHotkey(frame) 
	frame:SetAttribute(modifier.."-type"..mouseButton,"focus") 
end 

local function CreateFrame_Hook(type, name, parent, template) 
	if name and template == "SecureUnitButtonTemplate" then
		SetFocusHotkey(_G[name])
	end 
end 

hooksecurefunc("CreateFrame", CreateFrame_Hook) 

-- Keybinding override so that models can be shift/alt/ctrl+clicked 
local f = CreateFrame("CheckButton", "FocuserButton", UIParent, "SecureActionButtonTemplate") 
f:SetAttribute("type1","macro") 
f:SetAttribute("macrotext","/focus mouseover") 
SetOverrideBindingClick(FocuserButton,true,modifier.."-BUTTON"..mouseButton,"FocuserButton") 

-- Set the keybindings on the default unit frames since we won't get any CreateFrame notification about them 
local duf = { 
	PlayerFrame, 
	PetFrame, 
	PartyMemberFrame1, 
	PartyMemberFrame2, 
	PartyMemberFrame3, 
	PartyMemberFrame4, 
	PartyMemberFrame1PetFrame, 
	PartyMemberFrame2PetFrame, 
	PartyMemberFrame3PetFrame, 
	PartyMemberFrame4PetFrame, 
	TargetFrame, 
	TargetofTargetFrame, 
	} 

for i,frame in pairs(duf) do 
	SetFocusHotkey(frame) 
end 