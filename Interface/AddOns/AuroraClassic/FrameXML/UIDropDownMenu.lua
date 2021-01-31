local _, ns = ...
local F, C = unpack(ns)
local r, g, b = C.r, C.g, C.b

local function toggleBackdrop(bu, show)
	bu.bg:SetShown(show)
end

local function isCheckTexture(check)
	if check:GetTexture() == "Interface\\Common\\UI-DropDownRadioChecks" then
		return true
	end
end

tinsert(C.defaultThemes, function()
	local tooltipsEnabled = AuroraClassicDB.Tooltips

	hooksecurefunc("UIDropDownMenu_CreateFrames", function()
		for _, name in next, {"DropDownList", "L_DropDownList", "Lib_DropDownList"} do
			for i = 1, UIDROPDOWNMENU_MAXLEVELS do
				local menu = _G[name..i.."MenuBackdrop"]
				if tooltipsEnabled then
					if menu and not menu.styled then
						F.ReskinTooltip(menu)
						menu.styled = true
					end
				end
				local backdrop = _G[name..i.."Backdrop"]
				if backdrop and not backdrop.styled then
					F.StripTextures(backdrop)
					F.SetBD(backdrop, .7)
	
					backdrop.styled = true
				end
			end
		end
	end)

	hooksecurefunc("ToggleDropDownMenu", function(level)
		if not level then level = 1 end

		local listFrame = _G["DropDownList"..level]
		for i = 1, UIDROPDOWNMENU_MAXBUTTONS do
			local bu = _G["DropDownList"..level.."Button"..i]
			local _, _, _, x = bu:GetPoint()
			if bu:IsShown() and x then
				local hl = _G["DropDownList"..level.."Button"..i.."Highlight"]
				local check = _G["DropDownList"..level.."Button"..i.."Check"]
				hl:SetPoint("TOPLEFT", -x + 1, 0)
				hl:SetPoint("BOTTOMRIGHT", listFrame:GetWidth() - bu:GetWidth() - x - 1, 0)

				if not bu.bg then
					bu.bg = F.CreateBDFrame(bu)
					bu.bg:ClearAllPoints()
					bu.bg:SetPoint("CENTER", check)
					bu.bg:SetSize(12, 12)
					hl:SetColorTexture(r, g, b, .25)

					local arrow = _G["DropDownList"..level.."Button"..i.."ExpandArrow"]
					F.SetupArrow(arrow:GetNormalTexture(), "right")
					arrow:SetSize(14, 14)
				end
				toggleBackdrop(bu, false)

				local uncheck = _G["DropDownList"..level.."Button"..i.."UnCheck"]
				if isCheckTexture(uncheck) then uncheck:SetTexture("") end

				if isCheckTexture(check) then
					if not bu.notCheckable then
						toggleBackdrop(bu, true)

						-- only reliable way to see if button is radio or or check...
						local _, co = check:GetTexCoord()
						if co == 0 then
							check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
							check:SetVertexColor(r, g, b, 1)
							check:SetSize(20, 20)
							check:SetDesaturated(true)
						else
							check:SetTexture(C.bdTex)
							check:SetVertexColor(r, g, b, .6)
							check:SetSize(10, 10)
							check:SetDesaturated(false)
						end

						check:SetTexCoord(0, 1, 0, 1)
					end
				else
					check:SetSize(16, 16)
				end
			end
		end
	end)

	hooksecurefunc("UIDropDownMenu_SetIconImage", function(icon, texture)
		if texture:find("Divider") then
			icon:SetColorTexture(1, 1, 1, .2)
			icon:SetHeight(1)
		end
	end)
end)