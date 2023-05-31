local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)


local eframe = CreateFrame("Frame")
eframe:SetScript("OnEvent", function(self, event, arg1)
	if arg1 == "Blizzard_MacroUI" then
		MacroFrame:SetHeight(MacroFrame:GetHeight()+15)
		MacroFrameCharLimitText:ClearAllPoints()
		MacroFrameCharLimitText:SetPoint("BOTTOMRIGHT", MacroExitButton, "TOPRIGHT", 0, 10)
		
		local bu = CreateFrame("CheckButton", G.uiname.."Quick Delete Macro Button", MacroFrame, "InterfaceOptionsCheckButtonTemplate")
		bu:SetPoint("BOTTOMLEFT", MacroDeleteButton, "TOPLEFT", -3, 0)
		F.ReskinCheck(bu)
		bu.Text:SetText("快速删除")
		T.resize_font(bu.Text)
		
		bu:SetScript("OnClick", function(self) end)
		
		MacroDeleteButton:HookScript("OnClick", function()
			if bu:GetChecked() then
				StaticPopup_Hide("CONFIRM_DELETE_SELECTED_MACRO")
				MacroFrame:DeleteMacro()
			end
		end)
	end
end)
eframe:RegisterEvent("ADDON_LOADED")