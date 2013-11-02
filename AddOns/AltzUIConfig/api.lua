local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)

T.ShortValue = function(v)
	if v >= 1e6 then
		return ("%.1fm"):format(v / 1e6):gsub("%.?0+([km])$", "%1")
	elseif v >= 1e3 or v <= -1e3 then
		return ("%.1fk"):format(v / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return v
	end
end

T.FormatTime = function(time)
	if time >= 60 then
		return string.format('%.2d:%.2d', floor(time / 60), time % 60)
	else
		return string.format('%.2d', time)
	end
end

T.createtext = function(f, layer, fontsize, flag, justifyh)
	local text = f:CreateFontString(nil, layer)
	text:SetFont(G.norFont, fontsize, flag)
	text:SetJustifyH(justifyh)
	return text
end

T.createnumber = function(f, layer, fontsize, flag, justifyh)
	local text = f:CreateFontString(nil, layer)
	text:SetFont(G.numFont, fontsize, flag)
	text:SetJustifyH(justifyh)
	return text
end

T.pairsByKeys = function(t)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a)
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
		i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
      end
    return iter
end

T.hex = function(r, g, b)
    if not r then return "|cffFFFFFF" end

    if(type(r) == 'table') then
        if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
    end
    return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
end

T.SkinButton = function(button, tex, blend)
	local texture = button:CreateTexture(nil, "OVERLAY")
	texture:SetAllPoints(button)
	texture:SetTexture(tex)
	texture:SetVertexColor(1, 1, 1)
	
	if blend then
		texture:SetBlendMode("ADD")
	end
	
	if button:GetScript("OnEnter") then
		button:HookScript("OnEnter", function() texture:SetVertexColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b) end)
	else
		button:SetScript("OnEnter", function() texture:SetVertexColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b) end)
	end
	
	if button:GetScript("OnLeave") then
		button:HookScript("OnLeave", function() texture:SetVertexColor(1, 1, 1) end)
	else
		button:SetScript("OnLeave", function() texture:SetVertexColor(1, 1, 1) end)
	end
	
	return texture
end

T.dummy = function() end

--====================================================--
--[[           -- GUI Functions --                  ]]--
--====================================================--

function T.SetChatFrame()
	FCF_ResetChatWindows()
	
    FCF_SetLocked(ChatFrame1, nil)
    ChatFrame1:ClearAllPoints()
	ChatFrame1:SetSize(300, 130)
    ChatFrame1:SetPoint("BOTTOMLEFT", _G[G.uiname.."chatframe_pullback"], "BOTTOMLEFT", 5, 0)
	
	FCF_SavePositionAndDimensions(ChatFrame1)
	FCF_RestorePositionAndDimensions(ChatFrame1)
	
	FCF_SetLocked(ChatFrame1, 1)
	FCF_DockFrame(ChatFrame2)
	FCF_SetLocked(ChatFrame2, 1)
	FCF_OpenNewWindow(GUILD.."&"..WHISPER)
	FCF_SetLocked(ChatFrame3, 1)
	FCF_DockFrame(ChatFrame3)
	FCF_OpenNewWindow(LOOT)
	FCF_SetLocked(ChatFrame4, 1)
	FCF_DockFrame(ChatFrame4)
	
	local channels = {
		"SAY", "EMOTE", "YELL", "GUILD", "OFFICER", "GUILD_ACHIEVEMENT", "ACHIEVEMENT", "WHISPER","PARTY", "PARTY_LEADER", "RAID", "RAID_LEADER", "RAID_WARNING",
		"BATTLEGROUND", "BATTLEGROUND_LEADER", "CHANNEL1", "CHANNEL2", "CHANNEL3", "CHANNEL4", "CHANNEL5", "CHANNEL6", "CHANNEL7",
	}
	
	for i, v in ipairs(channels) do
		ToggleChatColorNamesByClassGroup(true, v)
	end
	
	ChatFrame_RemoveAllMessageGroups(ChatFrame3)
	ChatFrame_AddMessageGroup(ChatFrame3, "GUILD")
	ChatFrame_AddMessageGroup(ChatFrame3, "WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame3, "BN_WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame3, "BN_CONVERSATION")
	
	ChatFrame_RemoveAllMessageGroups(ChatFrame4)
	ChatFrame_AddMessageGroup(ChatFrame4, "COMBAT_XP_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame4, "COMBAT_HONOR_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame4, "COMBAT_FACTION_CHANGE")
	ChatFrame_AddMessageGroup(ChatFrame4, "LOOT")
	ChatFrame_AddMessageGroup(ChatFrame4, "MONEY")
	
	SELECTED_CHAT_FRAME = ChatFrame1
	FCF_SelectDockFrame(ChatFrame1)
	FCF_FadeInChatFrame(ChatFrame1)
end

T.ResetAllAddonSettings = function()
	if IsAddOnLoaded("Aurora") then
		AuroraConfig["tooltips"] = false
		AuroraConfig["bags"] = false
	end
	if aCoreCDB["SkinOptions"]["setClassColor"] and IsAddOnLoaded("!ClassColors") then
		if ClassColorsDB then wipe(ClassColorsDB) end
		ClassColorsDB = {
		["DEATHKNIGHT"] = {
			["hex"] = "ffb3040f",
			["colorStr"] = "ffb3040f",
			["b"] = 0.06,
			["g"] = 0.02,
			["r"] = 0.70,
		},
		["WARRIOR"] = {
			["hex"] = "ffcc6919",
			["colorStr"] = "ffcc6919",
			["b"] = 0.1,
			["g"] = 0.41,
			["r"] = 0.8,
		},
		["PALADIN"] = {
			["hex"] = "fff50a6c",
			["colorStr"] = "fff50a6c",
			["b"] = 0.41,
			["g"] = 0.18,
			["r"] = 1,
		},
		["MAGE"] = {
			["hex"] = "ff27f0f0",
			["colorStr"] = "ff27f0f0",
			["b"] = 0.94,
			["g"] = 0.94,
			["r"] = 0.15,
		},
		["PRIEST"] = {
			["hex"] = "ffffffff",
			["colorStr"] = "ffffffff",
			["b"] = 1,
			["g"] = 1,
			["r"] = 1,
		},
		["WARLOCK"] = {
			["hex"] = "ffe200ff",
			["colorStr"] = "ffe200ff",
			["b"] = 1,
			["g"] = 0.05,
			["r"] = 0.72,
		},
		["SHAMAN"] = {
			["hex"] = "ff0700ff",
			["colorStr"] = "ff0700ff",
			["b"] = 0.87,
			["g"] = 0.2,
			["r"] = 0.13,
		},
		["HUNTER"] = {
			["hex"] = "ff1d9b04",
			["colorStr"] = "ff1d9b04",
			["b"] = 0.02,
			["g"] = 0.61,
			["r"] = 0.11,
		},
		["DRUID"] = {
			["hex"] = "ffff9b00",
			["colorStr"] = "ffff9b00",
			["b"] = 0,
			["g"] = 0.61,
			["r"] = 1,
		},
		["MONK"] = {
			["hex"] = "ff00ff97",
			["colorStr"] = "ff00ff97",
			["b"] = 0.59,
			["g"] = 1,
			["r"] = 0,
		},
		["ROGUE"] = {
			["hex"] = "ffffe700",
			["colorStr"] = "ffffe700",
			["b"] = 0,
			["g"] = 0.91,
			["r"] = 1,
		},
	}
	end
	if aCoreCDB["SkinOptions"]["setDBM"] and IsAddOnLoaded("DBM-Core") then
		DBM_SavedOptions["ShowMinimapButton"] = false
		-- hp frame
		DBM_SavedOptions["AlwaysShowHealthFrame"] = false
		DBM_SavedOptions["HealthFrameGrowUp"] = false
		-- range
		DBM_SavedOptions["RangeFrameFrames"] = "radar"
		-- timersettings
		DBT_SavedOptions["DBM"]["IconLeft"] = true
		DBT_SavedOptions["DBM"]["IconRight"] = false
		DBT_SavedOptions["DBM"]["Texture"] = "Interface\\Buttons\\WHITE8x8"
		DBT_SavedOptions["DBM"]["ExpandUpwards"] = false
		DBT_SavedOptions["DBM"]["FontSize"] = 10
		-- smalltimer
		DBT_SavedOptions["DBM"]["Scale"] = 1
		DBT_SavedOptions["DBM"]["BarXOffset"] = 0
		DBT_SavedOptions["DBM"]["BarYOffset"] = 1
		-- hugetimer
		DBT_SavedOptions["DBM"]["HugeScale"] = 1
		DBT_SavedOptions["DBM"]["HugeBarXOffset"] = 0
		DBT_SavedOptions["DBM"]["HugeBarYOffset"] = 1
	end
	if aCoreCDB["SkinOptions"]["setSkada"] and IsAddOnLoaded("Skada") then
	if SkadaDB then wipe(SkadaDB["profiles"]) end
	SkadaDB	["profiles"] = {
		["Default"] = {
			["windows"] = {
					{
						["hidden"] = true,
						["classicons"] = false,
						["background"] = {
							["bordertexture"] = "Blizzard Tooltip",
						},
						["set"] = "total",
						["title"] = {
							["color"] = {
								["a"] = 0,
							},
							["borderthickness"] = 0,
						},
						["barbgcolor"] = {
							["a"] = 0,
							["r"] = 0.2,
							["g"] = 0.2,
							["b"] = 0.2,
						},
						["barcolor"] = {
							["a"] = 0.9,
							["r"] = 0.2,
							["g"] = 0.8,
							["b"] = 1,
						},
					}, -- [1]
				},
			["icon"] = {
				["hide"] = true,
			},
		},
	}
	end
	if aCoreCDB["SkinOptions"]["setNumeration"] and IsAddOnLoaded("Numeration") then
		NumerationCharOptions["forcehide"] = true
		NumerationCharOptions["minimap"]["hide"] = true
	end
end

T.createcheckbutton = function(parent, x, y, name, table, value, tip)
	local bu = CreateFrame("CheckButton", G.uiname..value.."Button", parent, "InterfaceOptionsCheckButtonTemplate")
	bu:SetPoint("TOPLEFT", x, -y)
	F.ReskinCheck(bu)
	
	_G[bu:GetName() .. "Text"]:SetText(name)
	
	bu:SetScript("OnShow", function(self) self:SetChecked(aCoreCDB[table][value]) end)
	bu:SetScript("OnClick", function(self)
		if self:GetChecked() then
			aCoreCDB[table][value] = true
		else
			aCoreCDB[table][value] = false
		end
	end)
	
	if tip then
		bu:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT",  -20, 10)
			GameTooltip:AddLine(tip)
			GameTooltip:Show() 
		end)
		bu:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	end
	
	parent[value] = bu
end

T.ABtogglebox = function(parent, x, y, id, name)
	local bu = CreateFrame("CheckButton", G.uiname.."Actionbar"..id.."Toggle", parent, "InterfaceOptionsCheckButtonTemplate")
	bu:SetPoint("TOPLEFT", x, -y)
	F.ReskinCheck(bu)
	
	_G[bu:GetName() .. "Text"]:SetText(name)
	
	bu:SetScript("OnShow", function(self)
		if select(id, GetActionBarToggles())== 1 then
			self:SetChecked(true)
		else
			self:SetChecked(false)
		end
	end)
	
	bu:SetScript("OnClick", function(self)
		if id == 1 then
			SHOW_MULTI_ACTIONBAR_1 = self:GetChecked()
		elseif id == 2 then
			SHOW_MULTI_ACTIONBAR_2 = self:GetChecked()
		elseif id == 3 then
			SHOW_MULTI_ACTIONBAR_3 = self:GetChecked()
		elseif id == 4 then
			SHOW_MULTI_ACTIONBAR_4 = self:GetChecked()
		end
		--InterfaceOptions_UpdateMultiActionBars()
	end)
	
	return bu
end

T.CVartogglebox = function(parent, x, y, value, name)
	local bu = CreateFrame("CheckButton", G.uiname..value.."Button", parent, "InterfaceOptionsCheckButtonTemplate")
	bu:SetPoint("TOPLEFT", x, -y)
	F.ReskinCheck(bu)
	
	_G[bu:GetName() .. "Text"]:SetText(name)
	
	bu:SetScript("OnShow", function(self)
		if GetCVar(value) == "1" then
			self:SetChecked(true)
		else
			self:SetChecked(false)
		end
	end)
	bu:SetScript("OnClick", function(self)
		if self:GetChecked() then
			SetCVar(value, "1")
		else
			SetCVar(value, "0")
		end
	end)
	return bu
end

T.createeditbox = function(parent, x, y, name, table, value, tip)
	local box = CreateFrame("EditBox", G.uiname..value.."EditBox", parent)
	box:SetSize(180, 20)
	box:SetPoint("TOPLEFT", x, -y)
	
	local bd = CreateFrame("Frame", nil, box)
	bd:SetPoint("TOPLEFT", -2, 0)
	bd:SetPoint("BOTTOMRIGHT")
	bd:SetFrameLevel(box:GetFrameLevel()-1)
	F.CreateBD(bd, 0)

	local gradient = F.CreateGradient(box)
	gradient:SetPoint("TOPLEFT", bd, 1, -1)
	gradient:SetPoint("BOTTOMRIGHT", bd, -1, 1)
	
	box.name = box:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	box.name:SetPoint("LEFT", box, "RIGHT", 10, 1)
	box.name:SetText(name)
	
	box:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
	box:SetAutoFocus(false)
	box:SetTextInsets(3, 0, 0, 0)
	
	box:SetScript("OnShow", function(self) self:SetText(aCoreCDB[table][value]) end)
	box:SetScript("OnEscapePressed", function(self) self:SetText(aCoreCDB[table][value]) self:ClearFocus() end)
	box:SetScript("OnEnterPressed", function(self) self:ClearFocus() aCoreCDB[table][value] = self:GetText() end)
	
	if tip then
		box:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -20, 10)
			GameTooltip:AddLine(tip)
			GameTooltip:Show() 
		end)
		box:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	end
	
	parent[value] = box
end

T.createmultilinebox = function(parent, width, height, x, y, name, table, value, tip)
	local scrollBG = CreateFrame("ScrollFrame", G.uiname..value.."MultiLineEditBox_BG", parent, "UIPanelScrollFrameTemplate")
	scrollBG:SetPoint("TOPLEFT", x, -y)
	scrollBG:SetSize(width, height)
	scrollBG:SetFrameLevel(parent:GetFrameLevel()+1)
	F.CreateBD(scrollBG, 0)
	
	local gradient = F.CreateGradient(scrollBG)
	gradient:SetPoint("TOPLEFT", scrollBG, 1, -1)
	gradient:SetPoint("BOTTOMRIGHT", scrollBG, -1, 1)
	
	scrollBG.name = scrollBG:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	scrollBG.name:SetPoint("BOTTOMLEFT", scrollBG, "TOPLEFT", 5, 8)
	scrollBG.name:SetJustifyH("LEFT")
	scrollBG.name:SetText(name)
	
	local scrollAC = CreateFrame("Frame", G.uiname..value.."MultiLineEditBox_ScrollAC", scrollBG)
	scrollAC:SetPoint("TOP", scrollBG, "TOP", 0, -3)
	scrollAC:SetWidth(scrollBG:GetWidth())
	scrollAC:SetHeight(scrollBG:GetHeight())
	scrollAC:SetFrameLevel(scrollBG:GetFrameLevel()+1)
	scrollBG:SetScrollChild(scrollAC)

	scrollBG.edit = CreateFrame("EditBox", G.uiname..value.."MultiLineEditBox", scrollAC)
	scrollBG.edit:SetTextInsets(0, 0, 3, 3)
	scrollBG.edit:SetFrameLevel(scrollAC:GetFrameLevel()+1)
	scrollBG.edit:SetAllPoints()
	scrollBG.edit:SetFontObject(ChatFontNormal)
	scrollBG.edit:SetMultiLine(true)
	scrollBG.edit:EnableMouse(true)
	scrollBG.edit:SetAutoFocus(false)
	
	scrollBG.edit:SetScript("OnShow", function(self) self:SetText(aCoreCDB[table][value]) end)
	scrollBG.edit:SetScript("OnEscapePressed", function(self) self:SetText(aCoreCDB[table][value]) self:ClearFocus() end)
	scrollBG.edit:SetScript("OnEnterPressed", function(self) self:ClearFocus() aCoreCDB[table][value] = self:GetText() end)
	
	F.ReskinScroll(_G[G.uiname..value.."MultiLineEditBox_BGScrollBar"])
		
	if tip then
		scrollBG.edit:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -20, 10)
			GameTooltip:AddLine(tip)
			GameTooltip:Show() 
		end)
		scrollBG.edit:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	end
	
	parent[value] = scrollBG
end

local function TestSlider_OnValueChanged(self, value)
   if not self._onsetting then   -- is single threaded 
     self._onsetting = true
     self:SetValue(self:GetValue())
     value = self:GetValue()     -- cant use original 'value' parameter
     self._onsetting = false
   else return end               -- ignore recursion for actual event handler
 end
 
T.createslider = function(parent, x, y, name, table, value, divisor, min, max, step, tip)
	local slider = CreateFrame("Slider", G.uiname..value.."Slider", parent, "OptionsSliderTemplate")
	slider:SetPoint("TOPLEFT", x, -y)
	slider:SetWidth(220)
	F.ReskinSlider(slider)
	
	BlizzardOptionsPanel_Slider_Enable(slider)
	
	slider:SetMinMaxValues(min, max)
	_G[slider:GetName()..'Low']:SetText(min/divisor)
	_G[slider:GetName()..'Low']:ClearAllPoints()
	_G[slider:GetName()..'Low']:SetPoint("RIGHT", slider, "LEFT", 10, 0)
	_G[slider:GetName()..'High']:SetText(max/divisor)
	_G[slider:GetName()..'High']:ClearAllPoints()
	_G[slider:GetName()..'High']:SetPoint("LEFT", slider, "RIGHT", -10, 0)
	
	_G[slider:GetName()..'Text']:ClearAllPoints()
	_G[slider:GetName()..'Text']:SetPoint("BOTTOM", slider, "TOP", 0, 3)
	_G[slider:GetName()..'Text']:SetFontObject(GameFontHighlight)
	--slider:SetStepsPerPage(step)
	slider:SetValueStep(step)
	
	slider:SetScript("OnShow", function(self)
		self:SetValue((aCoreCDB[table][value])*divisor)
		_G[slider:GetName()..'Text']:SetText(name.." |cFF00FFFF"..aCoreCDB[table][value].."|r")
	end)
	slider:SetScript("OnValueChanged", function(self, getvalue)
		aCoreCDB[table][value] = getvalue/divisor
		TestSlider_OnValueChanged(self, getvalue)
		_G[slider:GetName()..'Text']:SetText(name.." |cFF00FFFF"..aCoreCDB[table][value].."|r")
	end)
	
	if tip then slider.tooltipText = tip end
	
	parent[value] = slider
end

T.createcolorpickerbu = function(parent, x, y, name, table, value)
	local cpb = CreateFrame("Button", G.uiname..value.."ColorPickerButton", parent, "UIPanelButtonTemplate")
	cpb:SetPoint("TOPLEFT", x, -y)
	cpb:SetSize(25, 25)
	F.Reskin(cpb)
	
	cpb.ctex = cpb:CreateTexture(nil, "OVERLAY")
	cpb.ctex:SetTexture(G.media.blank)
	cpb.ctex:SetPoint"CENTER"
	cpb.ctex:SetSize(20, 20)

	cpb.name = cpb:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	cpb.name:SetPoint("LEFT", cpb, "RIGHT", 10, 1)
	cpb.name:SetText(name)
	
	cpb:SetScript("OnShow", function(self) self.ctex:SetVertexColor(aCoreCDB[table][value].r, aCoreCDB[table][value].g, aCoreCDB[table][value].b) end)
	cpb:SetScript("OnClick", function(self)
		local r, g, b, a = aCoreCDB[table][value].r, aCoreCDB[table][value].g, aCoreCDB[table][value].b, aCoreCDB[table][value].a
		
		ColorPickerFrame:ClearAllPoints()
		ColorPickerFrame:SetPoint("TOPLEFT", self, "TOPRIGHT", 20, 0)
		ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = aCoreCDB[table]["transparentmode"], a -- Opacity slider only available for reverse filling
		
		ColorPickerFrame.func = function()
			aCoreCDB[table][value].r, aCoreCDB[table][value].g, aCoreCDB[table][value].b = ColorPickerFrame:GetColorRGB()
			self.ctex:SetVertexColor(ColorPickerFrame:GetColorRGB())
		end
		
		ColorPickerFrame.opacityFunc = function()
			aCoreCDB[table][value].a = OpacitySliderFrame:GetValue()
		end
		
		ColorPickerFrame.previousValues = {r = r, g = g, b = b, opacity = a}
		
		ColorPickerFrame.cancelFunc = function()
			aCoreCDB[table][value].r, aCoreCDB[table][value].g, aCoreCDB[table][value].b, aCoreCDB[table][value].a = r, g, b, a
			self.ctex:SetVertexColor(aCoreCDB[table][value].r, aCoreCDB[table][value].g, aCoreCDB[table][value].b)
		end
		
		ColorPickerFrame:SetColorRGB(r, g, b)
		ColorPickerFrame:Hide()
		ColorPickerFrame:Show()
	end)
	
	if tip then
		cpb:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 10, 10)
			GameTooltip:AddLine(tip)
			GameTooltip:Show() 
		end)
		cpb:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	end
	
	parent[value] = cpb
end

T.createradiobuttongroup = function(parent, x, y, name, table, value, group)
	local frame = CreateFrame("Frame", G.uiname..value.."RadioButtonGroup", parent)
	frame:SetPoint("TOPLEFT", x, -y)
	frame:SetSize(150, 30)
	
	for k, v in pairs(group) do
		frame[k] = CreateFrame("CheckButton", G.uiname..value..k.."RadioButtonGroup", frame, "UIRadioButtonTemplate")
		F.ReskinRadio(frame[k])
		
		_G[frame[k]:GetName() .. "Text"]:SetText(v)
		
		frame[k]:SetScript("OnShow", function(self)
			self:SetChecked(aCoreCDB[table][value] == k)
		end)
		
		frame[k]:SetScript("OnClick", function(self)
			if self:GetChecked() then 
				aCoreCDB[table][value] = k
			else
				self:SetChecked(true)
			end
		end)		
	end
	
	for k, v in pairs(group) do
		frame[k]:HookScript("OnClick", function(self)
			if aCoreCDB[table][value] == k then
				for key, value in pairs(group) do
					if key ~= k then
						frame[key]:SetChecked(false)
					end
				end
			end
		end)
	end
	
	frame.name = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	frame.name:SetText(name)
	
	local buttons = {frame:GetChildren()}
	for i = 1, #buttons do
		if i == 1 then
			buttons[i]:SetPoint("LEFT", 5, 0)
		else
			buttons[i]:SetPoint("LEFT", _G[buttons[i-1]:GetName() .. "Text"], "RIGHT", 5, 0)
		end
		if i == #buttons then
			frame.name:SetPoint("LEFT", _G[buttons[i]:GetName() .. "Text"], "RIGHT", 10, 1)
		end
	end
	
	parent[value] = frame
end

-- dependency relationship
T.createDR = function(parent, ...)
    for i=1, select("#", ...) do
		local object = select(i, ...)
		if object:GetObjectType() == "Slider" then
			parent:HookScript("OnShow", function(self)
				if self:GetChecked() then
					BlizzardOptionsPanel_Slider_Enable(object)
				else
					BlizzardOptionsPanel_Slider_Disable(object)
				end
			end)
			parent:HookScript("OnClick", function(self)
				if self:GetChecked() then
					BlizzardOptionsPanel_Slider_Enable(object)
				else
					BlizzardOptionsPanel_Slider_Disable(object)
				end
			end)
		elseif object:GetObjectType() == "Frame" and object:GetName() then
			if object:GetName():match("RadioButtonGroup") then
				local children = {object:GetChildren()}
				parent:HookScript("OnShow", function(self)
					if self:GetChecked() then
						for i = 1, #children do
							children[i]:Enable()
						end
					else
						for i = 1, #children do
							children[i]:Disable()
						end
					end
				end)
				parent:HookScript("OnClick", function(self)
					if self:GetChecked() then
						for i = 1, #children do
							children[i]:Enable()
						end
					else
						for i = 1, #children do
							children[i]:Disable()
						end
					end
				end)
			end
		else
			parent:HookScript("OnShow", function(self)
				if self:GetChecked() then
					object:Enable()
				else
					object:Disable()
				end
			end)
			parent:HookScript("OnClick", function(self)
				if self:GetChecked() then
					object:Enable()
				else
					object:Disable()
				end
			end)
		end
    end
end
