local T, C, L, G = unpack(select(2, ...))

--====================================================--
--[[                -- 脱战生效 --                  ]]--
--====================================================--

local delayframe = CreateFrame("Frame")
delayframe.func = {}

delayframe:RegisterEvent("PLAYER_REGEN_ENABLED")

delayframe:SetScript("OnEvent", function(self, event)
	while #delayframe.func > 0 do		
		local cur_func = delayframe.func[1]
		table.remove(delayframe.func, 1)
		cur_func()
	end
end)

T.CombatDelayFunc = function(func)
	if InCombatLockdown() then
		table.insert(delayframe.func, func)	
	else
		func()
	end
end
--====================================================--
--[[              -- 其他插件设置 --                ]]--
--====================================================--
local ResetAurora = function()
	if C_AddOns.IsAddOnLoaded("AuroraClassic") then
		AuroraClassicDB["Bags"] = true
	end
end

T.ResetClasscolors = function()
	if C_AddOns.IsAddOnLoaded("!ClassColors") then
		if ClassColorsDB then table.wipe(ClassColorsDB) end
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
				["b"] = 0.56,
				["g"] = 0.07,
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
				["hex"] = "ff7f44ff",
				["colorStr"] = "ff7f44ff",
				["b"] = 1,
				["g"] = 0.27,
				["r"] = 0.5,
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
			["DEMONHUNTER"] = {
				["r"] = 0.6,
				["colorStr"] = "ffa330c9",
				["g"] = 0.1,
				["b"] = 0.78,
			},
			["EVOKER"] = {
				["r"] = 0.12,
				["colorStr"] = "ff20b2aa",
				["g"] = 0.7,
				["b"] = 0.66,
			},
		}
	end
end

T.ResetBW =function()
	if C_AddOns.IsAddOnLoaded("Bigwigs") and BigWigs3DB then
		BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"]["Default"]["barStyle"] = "AltzUI"
		BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"]["Default"]["fill"] = true
		BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"]["Default"]["BigWigsAnchor_width"] = 150
		BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"]["Default"]["BigWigsEmphasizeAnchor_width"] = 200
	end
end

T.ResetAllAddonSettings = function()
	ResetAurora()
	T.ResetClasscolors()
	T.ResetBW()
end

--====================================================--
--[[                -- 依赖关系 --                  ]]--
--====================================================--
-- 启用依赖关系
local createDR = function(parent, ...)
	for i=1, select("#", ...) do
		local object = select(i, ...)
		parent:HookScript("OnShow", function(self)
			if self:GetChecked() and self:IsEnabled() then
				if object.Enable then
					object:Enable()
				end
			else
				if object.Disable then
					object:Disable()
				end
			end
		end)
		parent:HookScript("OnClick", function(self)
			if self:GetChecked() and self:IsEnabled() then
				if object.Enable then
					object:Enable()
				end
			else
				if object.Disable then
					object:Disable()
				end
			end
		end)		
		parent:HookScript("OnEnable", function(self)
			if self:GetChecked() and self:IsEnabled() then
				if object.Enable then
					object:Enable()
				end
			else
				if object.Disable then
					object:Disable()
				end
			end
		end)
		parent:HookScript("OnDisable", function()
			if object.Disable then
				object:Disable()
			end
		end)
	end
end
T.createDR = createDR

-- 显示依赖关系
local createVisibleDR = function(func, parent, ...)	
	local children = {...}
	parent:HookScript("OnShow", function(self)
		if func() then
			for _, object in pairs(children) do
				object:Show()
			end
		else
			for _, object in pairs(children) do
				object:Hide()
			end
		end
	end)
	
	
		local oldfunc = parent.visible_apply	
		parent.visible_apply = function()
			if oldfunc then
				oldfunc()
			end
			if func() then
				for _, object in pairs(children) do
					object:Show()
				end
			else
				for _, object in pairs(children) do
					object:Hide()
				end
			end
		end
end
T.createVisibleDR = createVisibleDR

--====================================================--
--[[                -- 标题/分割线 --                ]]--
--====================================================--
local function CreateGUITitle(parent, text, line, color)
	local fs = T.createtext(parent, "OVERLAY", 16, "OUTLINE", "LEFT")
	fs:SetText(text or " ")
	if line then
		local tex = parent:CreateTexture(nil, "ARTWORK")
		tex:SetSize(parent:GetWidth()-50, 1)
		tex:SetPoint("TOPLEFT", fs, "BOTTOMLEFT", 0, -5)
		tex:SetColorTexture(1, 1, 1, .2)
	end
	if color then
		fs:SetTextColor(unpack(color))
	else
		fs:SetTextColor(1, .82, 0)
	end
	return fs
end

--====================================================--
--[[                -- 普通按钮 --                ]]--
--====================================================--
local ClickButton = function(parent, width, height, points, text, tex, tip)
	local bu = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	
	if points then
		bu:SetPoint(unpack(points))
	end
	
	bu:SetText(text or "")
	
	T.ReskinButton(bu)

	if width == 0 then
		bu:SetSize(bu.Text:GetWidth() + 5, height or 25)
	else
		bu:SetSize(width, height or 25)
	end
	
	if tex then
		bu.tex = bu:CreateTexture(nil, "ARTWORK")
		bu.tex:SetAllPoints(bu)
		bu.tex:SetTexture(tex)
	end

	if tip then
		bu:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT",  -20, 10)
			GameTooltip:AddLine(tip)
			GameTooltip:Show() 
		end)
		bu:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
	end
	
	return bu
end
T.ClickButton = ClickButton

local ClickTexButton = function(parent, points, tex, text, tex_size, tip)
	local bu = CreateFrame("Button", nil, parent)
	bu:SetPoint(unpack(points))
	
	bu.tex = bu:CreateTexture(nil, "ARTWORK")
	bu.tex:SetPoint("LEFT", bu, "LEFT", 3, 0)
	bu.tex:SetTexture(tex)
	bu.tex:SetSize(tex_size or 15, tex_size or 15)
	bu.tex:SetVertexColor(.5, .5, .5)
	bu.tex:SetBlendMode("ADD")
	
	bu.hl_tex = bu:CreateTexture(nil, "HIGHLIGHT")
	bu.hl_tex:SetAllPoints(bu.tex)
	bu.hl_tex:SetTexture(tex)
	bu.hl_tex:SetVertexColor(unpack(G.addon_color))
	bu.hl_tex:SetBlendMode("ADD")
	
	bu.text = T.createtext(bu, "OVERLAY", 12, "OUTLINE", "LEFT")
	bu.text:SetPoint("LEFT", tex and bu.tex or bu,  tex and "RIGHT" or "LEFT", 2, 0)
	bu.text:SetTextColor(.5, .5, .5)
	bu.text:SetText(text)
	
	bu:SetHeight(20)
	bu:SetWidth((tex and 20) + bu.text:GetWidth() + (text and 2 or 0))
	
	bu:EnableMouse(true)
	
	if tip then
		bu:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT",  -20, 10)
			GameTooltip:AddLine(tip)
			GameTooltip:Show() 
		end)
		bu:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
	end
	
	return bu
end
T.ClickTexButton = ClickTexButton

--====================================================--
--[[                 -- 勾选按钮 --                 ]]--
--====================================================--
local Checkbutton = function(parent, points, text, tip)
	local bu = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
	
	if points then
		bu:SetPoint(unpack(points))
	end
	
	T.ReskinCheck(bu)
	bu.Text:SetText(text)
	bu.Text:SetTextColor(1, 1, 1)
	
	bu:SetScript("OnDisable", function(self)
		bu.Text:SetTextColor(.5, .5, .5)
	end)
	
	bu:SetScript("OnEnable", function(self)
		bu.Text:SetTextColor(1, 1, 1)
	end)
	
	if tip then
		bu:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT",  -20, 10)
			GameTooltip:AddLine(tip)
			GameTooltip:Show() 
		end)
		bu:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
	end
	
	return bu
end
T.Checkbutton = Checkbutton

local Checkbutton_DB = function(parent, path)
	local info = T.GetOptionInfo(path)
	local bu = Checkbutton(parent, nil, info.text, info.tip)
	
	bu:SetScript("OnShow", function(self)
		self:SetChecked(T.ValueFromPath(aCoreCDB, path))
	end)
	
	bu:SetScript("OnClick", function(self)
		T.ValueToPath(aCoreCDB, path, self:GetChecked())
		if info.apply then info.apply() end
		if self.visible_apply then self.visible_apply() end
	end)

	return bu
end
T.Checkbutton_DB = Checkbutton_DB

local CVarCheckButton = function(parent, path)
	local info = T.GetOptionInfo(path)
	local bu = Checkbutton(parent, nil, info.text, info.tip)
	
	bu:SetScript("OnShow", function(self)
		if GetCVar(info.key) == info.arg1 then
			self:SetChecked(true)
		else
			self:SetChecked(false)
		end
	end)
	
	bu:SetScript("OnClick", function(self)
		if not InCombatLockdown() or not info.secure then
			if self:GetChecked() then
				SetCVar(info.key, info.arg1)
			else
				SetCVar(info.key, info.arg2)
			end
			if info.apply then
				info.apply()
			end
		end
	end)
	
	return bu
end
T.CVarCheckButton = CVarCheckButton

--====================================================--
--[[                 -- 输入框 --                   ]]--
--====================================================--
local inputbox = {}

if not AltzUIEditBoxInsertLink then
	hooksecurefunc("ChatEdit_InsertLink", function(...) return AltzUIEditBoxInsertLink(...) end)
end

function AltzUIEditBoxInsertLink(text)
	for k, editbox in pairs(inputbox) do
		if editbox and editbox:IsVisible() and editbox:HasFocus() then
			editbox:Insert(text)
			return true
		end
	end
end

if not AltzUIStackSplitHook then
	hooksecurefunc(StackSplitFrame, "OpenStackSplitFrame", function(...) return AltzUIStackSplitHook(...) end)
end

function AltzUIStackSplitHook(text)
	for k, editbox in pairs(inputbox) do
		if editbox and editbox:IsVisible() and editbox:HasFocus() then
			StackSplitCancelButton_OnClick()
			return true
		end
	end
end

-- 输入框基础模板
local EditboxWithButton = function(parent, width, points, tip)	
	local box = CreateFrame("EditBox", nil, parent)
	if points then
		box:SetPoint(unpack(points))
	end
	
	box:SetSize(width or 200, 20)	
	box.bg = T.createPXBackdrop(box, .3)

	box:SetFont(G.norFont, 14, "OUTLINE")
	box:SetAutoFocus(false)
	box:SetTextInsets(3, 0, 0, 0)

	box.button = ClickButton(box, 0, 20, {"RIGHT", box, "RIGHT", -2, 0}, OKAY)
	box.button:Hide()
	box.button:SetScript("OnClick", function()
		if box:GetScript("OnEnterPressed") then
			box:GetScript("OnEnterPressed")(box)
		end
	end)
	
	box:SetScript("OnChar", function(self)
		self.button:Show()
		self.bg:SetBackdropBorderColor(1, 1, 0)
	end)
	
	box:SetScript("OnEditFocusGained", function(self)
		self.bg:SetBackdropBorderColor(1, 1, 1)
	end)
	
	box:SetScript("OnEditFocusLost", function(self)
		self.bg:SetBackdropBorderColor(0, 0, 0)
	end)
	
	box:SetScript("OnHide", function(self) 
		self.button:Hide()
	end)

	if tip then
		box:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -20, 10)
			GameTooltip:AddLine(tip)
			GameTooltip:Show() 
		end)
		box:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
	end
	
	box:SetScript("OnEnable", function(self)
		self:SetTextColor(1, 1, 1, 1)
	end)
	
	box:SetScript("OnDisable", function(self)
		self:SetTextColor(0.7, 0.7, 0.7, 0.5)
	end)

	return box
end

-- 带默认文字的输入框
local EditboxWithStr = function(parent, points, text, width, link)
	local box = EditboxWithButton(parent, width, points)
	
	box:SetScript("OnShow", function(self)
		self:SetText(text)
	end)
	
	box:SetScript("OnEscapePressed", function(self)
		self:SetText(text)
		self:ClearFocus()
	end)
	
	box:SetScript("OnEnterPressed", function(self) 			
		if self.apply then
			self:apply()
		end
		self:ClearFocus()
		self.button:Hide()
	end)
	
	if link then
		table.insert(inputbox, box) -- 支持链接/文字/数字
	end
	
	return box
end
T.EditboxWithStr = EditboxWithStr

-- 带标题的输入框组合
local EditFrame = function(parent, width, text, points, tip)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetSize(20, 20)
	if points then
		frame:SetPoint(unpack(points))
	end
	
	local name = T.createtext(frame, "OVERLAY", 14, "OUTLINE", "LEFT")
	name:SetPoint("LEFT", frame, "LEFT", 0, 0)
	name:SetText(text or "")	
	frame.name = name
	
	local box = EditboxWithButton(frame, width, {"LEFT", frame, "LEFT", 100, 0}, tip)
	frame.box = box
	
	return frame
end
T.EditFrame = EditFrame

local EditboxFrame_DB = function(parent, path)
	local info = T.GetOptionInfo(path)
	
	local frame = EditFrame(parent, 200, info.text, nil, info.tip, info.numeric)
	
	frame:SetScript("OnShow", function(self)
		self.box:SetText(T.ValueFromPath(aCoreCDB, path))
	end)
	
	frame.box:SetScript("OnEscapePressed", function(self)
		self:SetText(T.ValueFromPath(aCoreCDB, path))
		self:ClearFocus()
	end)
	
	frame.box:SetScript("OnEnterPressed", function(self)
		local val = self:GetText()
		self:ClearFocus()
		T.ValueToPath(aCoreCDB, path, info.numeric and tonumber(val) or val)
		if info.apply then
			info.apply()
		end
		self.button:Hide()
	end)
	
	frame.Enable = function()
		frame.name:SetTextColor(1, 1, 1)
		frame.box:Enable()
	end
	
	frame.Disable = function()
		frame.name:SetTextColor(.5, .5, .5)
		frame.box:Disable()
	end
	
	return frame
end

-- 多行模板
local EditboxMultiLine = function(parent, width, height, points, name, tip)
	local box = CreateFrame("ScrollFrame", nil, parent, "UIPanelScrollFrameTemplate")
	if points then
		box:SetPoint(unpack(points))
	end
	
	box:SetSize(width or 200, height or 100)
	box:SetFrameLevel(parent:GetFrameLevel()+3)
	T.ReskinScroll(box.ScrollBar)
	
	box:EnableMouse(true)
	box:SetScript("OnMouseDown", function(self)
		self.edit:SetFocus()
	end)

	box.bg = T.createPXBackdrop(box, .3)

	box.top_text = T.createtext(box, "OVERLAY", 14, "OUTLINE", "LEFT")
	box.top_text:SetPoint("BOTTOMLEFT", box, "TOPLEFT", 0, 3)
	box.top_text:SetText(name or "")
	
	box.bottom_text = T.createtext(box, "OVERLAY", 10, "OUTLINE", "RIGHT")
	box.bottom_text:SetPoint("BOTTOMRIGHT", box, "BOTTOMRIGHT", -2, 2)

	box.edit = CreateFrame("EditBox", nil, box)
	box.edit:SetSize(width or 200, height or 100)
	box:SetScrollChild(box.edit)

	box.edit:SetFont(G.norFont, 14, "OUTLINE")
	box.edit:SetTextInsets(5, 5, 5, 5)
	box.edit:SetMultiLine(true)
	box.edit:EnableMouse(true)
	box.edit:SetAutoFocus(false)
	
	box.edit:SetScript("OnChar", function(self) box.bg:SetBackdropBorderColor(1, 1, 0) end)
	box.edit:SetScript("OnEditFocusGained", function(self) box.bg:SetBackdropBorderColor(1, 1, 1) end)
	box.edit:SetScript("OnEditFocusLost", function(self) box.bg:SetBackdropBorderColor(0, 0, 0) end)

	box.button1 = ClickButton(box, 99, nil, {"TOPRIGHT", box, "BOTTOM", -1, -2}, ACCEPT)	
	box.button2 = ClickButton(box, 99, nil, {"TOPLEFT", box, "BOTTOM", 1, -2}, CANCEL)

	box.Enable = function()
		box.top_text:SetTextColor(1, 1, 1, 1)		
		box.edit:SetTextColor(1, 1, 1, 1)
		box.edit:Enable()
		box.button1:Enable()
		box.button2:Enable()
	end
	
	box.Disable = function()	
		box.top_text:SetTextColor(0.7, 0.7, 0.7, 0.5)
		box.edit:SetTextColor(0.7, 0.7, 0.7, 0.5)
		box.edit:Disable()
		box.button1:Disable()
		box.button2:Disable()
	end
	
	if tip then
		box.edit:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -20, 10)
			GameTooltip:AddLine(tip)
			GameTooltip:Show() 
		end)
		box.edit:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
	end
		
	return box
end
T.EditboxMultiLine = EditboxMultiLine

local EditboxMultiLine_DB = function(parent, path)
	local info = T.GetOptionInfo(path)
	
	local box = EditboxMultiLine(parent, info.edit_width or 200, info.edit_height or 70, nil, info.text, info.tip)

	box.edit:SetScript("OnShow", function(self)
		self:SetText(T.ValueFromPath(aCoreCDB, path))
	end)
	
	box.button1:SetScript("OnClick", function()
		box.edit:ClearFocus()
		T.ValueToPath(aCoreCDB, path, box.edit:GetText())	
		if info.apply then
			info.apply()
		end
	end)
	
	box.button2:SetScript("OnClick", function()
		self:SetText(T.ValueFromPath(aCoreCDB, path))
		box.edit:ClearFocus()
	end)
	
	return box
end

--====================================================--
--[[                 -- 滑动条 --                   ]]--
--====================================================--
local SliderWithValueText = function(parent, name, width, points, min, max, step, tip, button)
	local slider = CreateFrame("Slider", name and (G.uiname..name.."MiniSlider"), parent, "MinimalSliderTemplate")
	if points then
		slider:SetPoint(unpack(points))
	end
	
	slider.Text = T.createtext(slider, "OVERLAY", 10, "OUTLINE")
	slider.Text:SetPoint("LEFT", slider, "RIGHT", -5, 0)
	
	if width == "short" then
		slider:SetSize(170, 12)
	elseif width == "long" then
		slider:SetSize(170, 12)
	elseif type(width) == "number" then
		slider:SetSize(width, 12)
	end
	
	T.ReskinSlider(slider)
	
	slider:SetMinMaxValues(min, max)
	slider:SetValueStep(step)
	slider:SetObeyStepOnDrag(true)
	
	if button then
		slider.button = ClickButton(slider, 50, 20, {"LEFT", slider, "RIGHT", 30, 0}, APPLY)
		slider.button:Hide()
		
		slider:SetScript("OnHide", function(self)
			self.button:Hide()
		end)
	end
	
	slider.Enable = function()		
		slider:SetEnabled(true)
		slider.Text:SetTextColor(1, 1, 1, 1)
		slider.Thumb:Show()
	end
	
	slider.Disable = function()
		slider:SetEnabled(false)
		slider.Text:SetTextColor(0.7, 0.7, 0.7, 0.5)
		slider.Thumb:Hide()
		if slider.button then
			slider.button:Hide()
		end
	end
	
	if tip then
		slider:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -20, 10)
			GameTooltip:AddLine(tip)
			GameTooltip:Show() 
		end)
		slider:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
	end
	
	return slider
end
T.SliderWithValueText = SliderWithValueText

local SliderWithSteppers = function(parent, width, text, points, min, max, step, tip, button)
	local frame = CreateFrame("Slider", nil, parent, "MinimalSliderWithSteppersTemplate")
	if points then
		frame:SetPoint(unpack(points))
	end
	
	if width == "short" then
		frame:SetWidth(160)
	elseif width == "long" then
		frame:SetWidth(200)
	elseif type(width) == "number" then
		frame:SetWidth(width)
	end
	
	T.ReskinStepperSlider(frame)
	
	frame.LeftText:ClearAllPoints()
	frame.LeftText:SetPoint("LEFT", frame.Slider, "LEFT", -115, 0)
	frame.LeftText:SetJustifyH("LEFT")
	frame.LeftText:SetText(text)
	frame.LeftText:SetTextColor(1, 1, 1, 1)
	frame.LeftText:Show()
	
	frame.RightText:SetTextColor(1, 1, 1, 1)
	frame.RightText:Show()

	frame.Slider:SetMinMaxValues(min, max)
	frame.Slider:SetValueStep(step)
	frame.Slider:SetObeyStepOnDrag(true)
	
	frame.Enable = function()
		frame.Slider:SetEnabled(true)
		frame.Slider.Thumb:Show()
		frame.Back:Enable()
		frame.Forward:Enable()
		if frame.Back.__texture and frame.Forward.__texture then
			frame.Back.__texture:SetVertexColor(1, 1, 1, 1)
			frame.Forward.__texture:SetVertexColor(1, 1, 1, 1)
		end
		frame.LeftText:SetTextColor(1, 1, 1, 1)
		frame.RightText:SetTextColor(1, 1, 1, 1)
	end
	
	frame.Disable = function()
		frame.Slider:SetEnabled(false)
		frame.Slider.Thumb:Hide()
		frame.Back:Disable()
		frame.Forward:Disable()
		if frame.Back.__texture and frame.Forward.__texture then
			frame.Back.__texture:SetVertexColor(0.7, 0.7, 0.7, 0.5)
			frame.Forward.__texture:SetVertexColor(0.7, 0.7, 0.7, 0.5)
		end
		frame.LeftText:SetTextColor(0.7, 0.7, 0.7, 0.5)
		frame.RightText:SetTextColor(0.7, 0.7, 0.7, 0.5)
		if button then
			frame.button:Hide()
		end
	end
	
	if tip then
		frame:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -20, 10)
			GameTooltip:AddLine(tip)
			GameTooltip:Show() 
		end)
		frame:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
	end
	
	if button then
		frame.button = ClickButton(frame, 50, 20, {"LEFT", frame, "RIGHT", 30, 0}, APPLY)
		frame:SetScript("OnHide", function(self)
			self.button:Hide()
		end)
	end
	
	return frame
end
T.SliderWithSteppers = SliderWithSteppers

local Slider_DB = function(parent, width, path)
	local info = T.GetOptionInfo(path)
	local multipler = (info.min < 1 and info.min > 0 and 100) or 1

	local frame = SliderWithSteppers(parent, width, info.text, nil, info.min*multipler, info.max*multipler, info.step*multipler, info.tip)
	
	frame.Slider:SetScript("OnShow", function(self)
		local value = T.ValueFromPath(aCoreCDB, path)
		self:SetValue(value*multipler)
		frame.RightText:SetText(floor(value*multipler)..((multipler == 100 and "%") or ""))
	end)
	
	frame.Slider:SetScript("OnValueChanged", function(self, getvalue)
		T.ValueToPath(aCoreCDB, path, getvalue/multipler)
		frame.RightText:SetText(getvalue..((multipler == 100 and "%") or ""))
		if info.apply then info.apply() end
	end)
	
	return frame
end
T.Slider_DB = Slider_DB

--====================================================--
--[[                 -- 取色按钮 --                 ]]--
--====================================================--
local ColorPicker_OnClick = function(color_old, apply, points)
	ColorPickerFrame:ClearAllPoints()
	if points then
		ColorPickerFrame:SetPoint(unpack(points))
	else
		ColorPickerFrame:SetPoint("CENTER", UIParent, "CENTER")
	end
	
	ColorPickerFrame.previousValues = {r = color_old.r, g = color_old.g, b = color_old.b, opacity = color_old.a}
	
	ColorPickerFrame.swatchFunc = function()
		local r, g, b = ColorPickerFrame:GetColorRGB()
		apply(r, g, b)
	end
	
	ColorPickerFrame.cancelFunc = function()
		apply(color_old.r, color_old.g, color_old.b)
	end
	
	ColorPickerFrame.Content.ColorPicker:SetColorRGB(color_old.r, color_old.g, color_old.b)
	ColorPickerFrame:Hide()
	ColorPickerFrame:Show()
end
T.ColorPicker_OnClick = ColorPicker_OnClick

local ColorpickerButton = function(parent, text, points, tip)
	local cpb = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	cpb:SetSize(20, 20)
	T.ReskinButton(cpb)
	
	if points then
		cpb:SetPoint(unpack(points))
	end

	cpb.ctex = cpb:CreateTexture(nil, "OVERLAY")
	cpb.ctex:SetTexture(G.media.blank)
	cpb.ctex:SetPoint"CENTER"
	cpb.ctex:SetSize(15, 15)

	cpb.name = T.createtext(cpb, "OVERLAY", 14, "OUTLINE", "LEFT")
	cpb.name:SetPoint("LEFT", cpb, "RIGHT", 10, 1)
	cpb.name:SetText(text or "")

	cpb:SetScript("OnDisable", function(self)
		self.name:SetTextColor(0.7, 0.7, 0.7, 0.5)
	end)
	
	cpb:SetScript("OnEnable", function(self)
		self.name:SetTextColor(1, 1, 1, 1)
	end)
	
	if tip then
		cpb:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 10, 10)
			GameTooltip:AddLine(tip)
			GameTooltip:Show() 
		end)
		cpb:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
	end
	
	return cpb
end

local ColorpickerButton_DB = function(parent, path)
	local info = T.GetOptionInfo(path)
	
	local cpb = ColorpickerButton(parent, info.text, nil, info.tip)
	
	cpb:SetScript("OnShow", function(self)
		local color = T.ValueFromPath(aCoreCDB, path)
		self.ctex:SetVertexColor(color.r, color.g, color.b)	
	end)
	
	cpb:SetScript("OnClick", function(self)
		local color = T.ValueFromPath(aCoreCDB, path)
		ColorPicker_OnClick(color, function(r, g, b)
			self.ctex:SetVertexColor(r, g, b)
			T.TableValueToPath(aCoreCDB, path, {r = r, g = g, b = b})
			if info.apply then
				info.apply()
			end
		end)
	end)
	
	return cpb
end
--====================================================--
--[[                -- 多选一按钮 --                ]]--
--====================================================--
local ButtonGroup = function(parent, width, points, path, group)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetPoint(unpack(points))
	frame:SetSize(width, 25)
	frame.buttons = {}
	
	local button_width = (width+10)/#group-10
	
	frame.update_state = function()
		for i, bu in pairs(frame.buttons) do
			if not bu:IsEnabled() then 
				bu.Text:SetTextColor(.5, .5, .5)
			elseif bu.selected then
				bu.Text:SetTextColor(1, 1, 0)
			else
				bu.Text:SetTextColor(1, 1, 1)
			end
		end
	end
	
	frame:SetScript("OnShow", function(self)
		if path then
			for i, bu in pairs(self.buttons) do
				bu.selected = T.ValueFromPath(aCoreCDB, path) == bu.value_key
			end
		end
		self.update_state()
	end)
		
	for i, info in T.pairsByKeys(group) do
		local bu = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
		bu:SetSize(button_width, 25)
		T.ReskinButton(bu, nil, true)
		
		bu.hl = bu:CreateTexture(nil, "HIGHLIGHT")
		bu.hl:SetAllPoints()
		bu.hl:SetTexture(G.textureFile.."highlight.tga")
		bu.hl:SetVertexColor( 1, 1, 1, .3)
		bu.hl:SetBlendMode("ADD")
		
		if i == 1 then
			bu:SetPoint("LEFT", frame, "LEFT", 0, 0)
		else
			bu:SetPoint("LEFT", frame.buttons[i-1], "RIGHT", 10, 0)
		end
		
		bu.Text:SetText(info[2])
		bu.Text:SetTextColor(1, 1, 1)
		
		bu.value_key = info[1]
		bu:SetScript("OnClick", function(self)
			if not self.selected then
				for i, b in pairs(frame.buttons) do
					if b ~= self then
						b.selected = false
					else
						b.selected = true
					end
				end
				frame.update_state()
				
				if path then
					T.ValueToPath(aCoreCDB, path, self.value_key)
				end
				
				frame.apply(self.value_key)
			end
		end)
		
		table.insert(frame.buttons, bu)
	end
	
	frame.Enable = function()
		for i, bu in pairs(frame.buttons) do
			bu:Enable()
		end
		frame.update_state()
	end
	
	frame.Disable = function()
		for i, bu in pairs(frame.buttons) do
			bu:Disable()
		end
		frame.update_state()
	end
	
	return frame
end
T.ButtonGroup = ButtonGroup

--====================================================--
--[[                -- 下拉菜单 --                ]]--
--====================================================--
local UIDropDownMenu_SetSelectedValueText = function(frame, t, value)
	UIDropDownMenu_SetSelectedValue(frame.DropDown, value)
	for i, info in pairs(t) do
		if info[1] == value then
			frame:SetText(info[2])
			if info[3] then
				local index = string.match(info[3], "%d")
				if index then
					frame.Text:SetFont(G["combatFont"..index], 14, "NONE")
				else
					frame.Text:SetFont(G.norFont, 14, "OUTLINE")
				end
			end
			break
		end
	end
end
T.UIDropDownMenu_SetSelectedValueText = UIDropDownMenu_SetSelectedValueText

local SetupDropdown = function(parent, width, points)
	local button = CreateFrame("DropdownButton", nil, parent, "WowStyle1DropdownTemplate")
	
	if points then
		button:SetPoint(unpack(points))
	end
	
	button:SetWidth(width)
	T.ReskinDropDown(button)
	
	button.DropDown = CreateFrame("Frame", nil, parent, "UIDropDownMenuTemplate")
	button:SetScript("OnMouseDown", function(self)
		self.DropDown.point = "TOPLEFT"
		self.DropDown.relativePoint = "BOTTOMLEFT"
		ToggleDropDownMenu(1, nil, self.DropDown, self, 0, 5)	
	end)
	
	return button
end
T.SetupDropdown = SetupDropdown

local UIDropDownMenuFrame = function(parent, width, text, points)
	local w
	
	if width == "short" then
		w = 140
	elseif width == "long" then
		w = 190
	else
		w = width
	end
	
	local frame = SetupDropdown(parent, w, points)
	
	local name = T.createtext(frame, "OVERLAY", 14, "OUTLINE", "LEFT")
	name:SetPoint("LEFT", frame, "LEFT", -100, 0)
	name:SetTextColor(1, 1, 1)
	name:SetText(text or "")
	frame.name = name
	
	return frame
end
T.UIDropDownMenuFrame = UIDropDownMenuFrame

local UIDropDownMenuFrame_DB = function(parent, width, path)
	local info = T.GetOptionInfo(path)
	local option_table = info.option_table
	local frame = UIDropDownMenuFrame(parent, width, info.text)
	
	local function DD_UpdateChecked(self, arg1)
		return (T.ValueFromPath(aCoreCDB, path) == arg1)
	end
	
	local function DD_SetChecked(self, arg1, arg2)
		T.ValueToPath(aCoreCDB, path, arg1)
		T.UIDropDownMenu_SetSelectedValueText(frame, option_table, arg1)
		if info.apply then info.apply() end
		if frame.visible_apply then frame.visible_apply() end
	end
	
	UIDropDownMenu_Initialize(frame.DropDown, function(self, level)
		local dd_info = UIDropDownMenu_CreateInfo()
		for i = 1, #option_table do
			dd_info.value = option_table[i][1]
			dd_info.arg1 = option_table[i][1]
			dd_info.text = option_table[i][2]
			if option_table[i][3] then
				dd_info.fontObject = option_table[i][3]
			end
			dd_info.checked = DD_UpdateChecked
			dd_info.func = DD_SetChecked
			UIDropDownMenu_AddButton(dd_info)
		end
	end, "MENU")
	
	frame:SetScript("OnShow", function()
		T.UIDropDownMenu_SetSelectedValueText(frame, option_table, T.ValueFromPath(aCoreCDB, path))		
	end)
	
	return frame
end
T.UIDropDownMenuFrame_DB = UIDropDownMenuFrame_DB
--====================================================--
--[[                 -- 设置列表 --                 ]]--
--====================================================--
local lineuplist = function(list, button_list, parent)
	local t = {}
	
	for key, _ in pairs(list) do
		table.insert(t, key)		
	end
	
	table.sort(t)
	
	for i, key in pairs(t) do
		local bu = button_list[key]
		bu:ClearAllPoints()
		bu:SetPoint("TOPLEFT", parent, "TOPLEFT", 5, 25-i*30)
	end
end

local createscrolllist = function(parent, points, bg, width, height)
	local w = width or 370
	local h = height or 220
	
	local sf = CreateFrame("ScrollFrame", nil, parent, "UIPanelScrollFrameTemplate")
	if points then sf:SetPoint(unpack(points)) end	
	sf:SetSize(w, h)
	sf:SetFrameLevel(parent:GetFrameLevel()+1)

	sf.anchor = CreateFrame("Frame", nil, sf)
	sf.anchor:SetPoint("TOPLEFT", sf, "TOPLEFT", 0, -3)
	sf.anchor:SetWidth(sf:GetWidth()-30)
	sf.anchor:SetHeight(sf:GetHeight())
	sf.anchor:SetFrameLevel(sf:GetFrameLevel()+1)
	sf:SetScrollChild(sf.anchor)
	
	if bg then
		sf.bg = T.createPXBackdrop(sf, .3)
	end
	
	T.ReskinScroll(sf.ScrollBar)
	
	sf.list = {}
	
	return sf
end
T.createscrolllist = createscrolllist

local createscrollbutton = function(type, option_list, path, key)
	local key_path = {}
	T.CopyTableInsertElement(key_path, path, key)

	local bu = CreateFrame("Frame", nil, option_list.anchor, "BackdropTemplate")
	bu:SetSize(360, 28)
	bu:EnableMouse(true)
	T.setPXBackdrop(bu, .2)
	
	bu.icon = bu:CreateTexture(nil, "ARTWORK")
	bu.icon:SetSize(20, 20)
	bu.icon:SetTexCoord(0.1,0.9,0.1,0.9)
	bu.icon:SetPoint("LEFT", 5, 0)
	bu.icon:SetTexture(G.media.blank)
	
	bu.iconbg = bu:CreateTexture(nil, "BORDER")
	bu.iconbg:SetPoint("TOPLEFT", bu.icon, "TOPLEFT", -1, 1)
	bu.iconbg:SetPoint("BOTTOMRIGHT", bu.icon, "BOTTOMRIGHT", 1, -1)
	bu.iconbg:SetColorTexture(0, 0, 0, 1)
	
	bu.left = T.createtext(bu, "OVERLAY", 12, "OUTLINE", "LEFT")
	bu.left:SetPoint("LEFT", bu.icon, "RIGHT", 5, 0)
	bu.left:SetTextColor(1, .2, .6)
	
	bu.mid = T.createtext(bu, "OVERLAY", 12, "OUTLINE", "LEFT")
	bu.mid:SetPoint("LEFT", bu, "CENTER", 0, 0)
	
	bu.right = T.createtext(bu, "OVERLAY", 12, "OUTLINE", "LEFT")
	bu.right:SetTextColor(1, 1, 0)
	bu.right:SetPoint("LEFT", bu, "RIGHT", -80, 0)
	
	bu.close = CreateFrame("Button", nil, bu, "UIPanelCloseButton")
	bu.close:SetPoint("RIGHT", -5, 0)
	T.ReskinClose(bu.close)

	bu.close:SetScript("OnEnter", function(self)	
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(DELETE)
		GameTooltip:Show()
	end)
	bu.close:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	
	bu.close:SetScript("OnClick", function()
		bu:Hide()
		T.ValueToPath(aCoreCDB, key_path, nil)
		if option_list.lineuplist then
			option_list.lineuplist()
		else
			lineuplist(T.ValueFromPath(aCoreCDB, path), option_list.list, option_list.anchor)
		end
		if option_list.apply then
			option_list.apply()
		end
	end)
	
	bu.display = function(icon, text1, text2, text3, color)
		if icon then bu.icon:SetTexture(icon) end
		if text1 then bu.left:SetText(text1) end
		if text2 then bu.mid:SetText(text2) end		
		if text3 then bu.right:SetText(text3) end
		if color then bu.icon:SetVertexColor(color.r, color.g, color.b) end
		if not (icon or color) then
			bu.icon:Hide()
			bu.iconbg:Hide()
		else
			bu.icon:Show()
			bu.iconbg:Show()
		end
	end
	
	if type == "spell" or type == "item" then
		bu:SetScript("OnEnter", function(self)	
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			if type == "spell" then
				GameTooltip:SetSpellByID(key)
			elseif type == "item" then
				GameTooltip:SetItemByID(key)
			end
			GameTooltip:Show()
		end)
		
		bu:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)		
	end
	
	option_list.list[key] = bu
	
	return bu
end
T.createscrollbutton = createscrollbutton

-- 列表选项
local function CreateListOption(parent, points, height, text, path, input_text_1, input_text_2, filter_path)
	local frame = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	frame:SetSize(450, height)
	frame:SetPoint(unpack(points))

	frame.title = T.createtext(frame, "OVERLAY", 14, "OUTLINE", "LEFT")
	frame.title:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
	frame.title:SetText(text)
	frame.title:SetTextColor(1, .82, 0)
	
	frame.reset = ClickTexButton(frame, {"LEFT", frame.title, "RIGHT", 10, 0}, G.iconFile.."refresh.tga", L["重置"])
	frame.reset:SetScript("OnClick", function(self)
		StaticPopupDialogs[G.uiname.."Reset Confirm"].text = format(L["重置确认"], T.color_text(text))
		StaticPopupDialogs[G.uiname.."Reset Confirm"].OnAccept = function()
			T.ValueToPath(aCoreCDB, path, nil)			
			if filter_path then
				T.ValueToPath(aCoreCDB, filter_path, nil)
			end
			ReloadUI()
		end
		StaticPopup_Show(G.uiname.."Reset Confirm")
	end)
	
	if filter_path then
		local obj = UIDropDownMenuFrame_DB(frame, "long", filter_path)
		obj:SetPoint("TOPLEFT", frame, 0, -20)
	end
	
	frame.first_input = EditboxWithStr(frame, {"TOPLEFT", 0, filter_path and -45 or -20}, input_text_1, 199)
	
	if input_text_2 then
		frame.second_input = EditboxWithStr(frame, {"LEFT", frame.first_input, "RIGHT", 10, 0}, input_text_2, 80)
	end
	
	frame.addbutton = ClickButton(frame, 0, 22, {"LEFT", frame.second_input or frame.first_input, "RIGHT", 10, 0}, ADD)
	
	frame.option_list = createscrolllist(frame, {"TOPLEFT", 0, filter_path and -70 or -45}, true, nil, height - 70)
	
	return frame
end

-- 列表按钮
local function CreateListButton(type, frame, path, key, Icon, left_text, mid_text, right_text, color)
	local bu = frame.option_list.list[key]
	
	if not bu then
		bu = createscrollbutton(type, frame.option_list, path, key)
		if right_text or color then
			bu:SetScript("OnMouseDown", function()
				frame.first_input:SetText(bu.left:GetText())
				if frame.Button_OnClicked then
					frame.Button_OnClicked(bu)
				end
				
				if right_text then
					frame.second_input:SetText(bu.right:GetText())
				end
				
				if color then
					T.TableValueToPath(frame, {"cpb", "colors"}, {r = color.r, g = color.g, b = color.b})
					frame.cpb.ctex:SetVertexColor(color.r, color.g, color.b)
				end
			end)
		end
	end
	bu.display(Icon, left_text, mid_text, right_text, color)
	bu:Show()
end

-- 类型列表：法术
T.CreateAuraListOption = function(parent, points, height, text, path, input_text_2, filter_path)
	local frame = CreateListOption(parent, points, height, text, path, L["输入法术ID"], input_text_2, filter_path)
		
	frame.Button_OnClicked = function(bu)
		frame.first_input.current_spellID = tonumber(bu.mid:GetText())
	end
	
	frame:SetScript("OnShow", function()
		for spellID, level in pairs(T.ValueFromPath(aCoreCDB, path)) do
			local spellName, spellIcon = T.GetSpellInfo(spellID)
			
			if spellName then
				CreateListButton("spell", frame, path, spellID, spellIcon, spellName, spellID, input_text_2 and level)
			else
				local key_path = {}
				T.CopyTableInsertElement(key_path, path, spellID)
				print("spell ID "..spellID.." is gone, delete it.")
				T.ValueToPath(aCoreCDB, key_path, nil)
			end
		end
		lineuplist(T.ValueFromPath(aCoreCDB, path), frame.option_list.list, frame.option_list.anchor)
	end)
	
	frame.first_input:HookScript("OnChar", function(self) 
		self.current_spellID = nil
	end)
	
	function frame.first_input:apply()
		if self.current_spellID then
			return true
		else
			local spellText = self:GetText()		
			local spellName, spellIcon, _, spellID = T.GetSpellInfo(spellText)

			if spellName then
				self:SetText(spellName)
				self.current_spellID = spellID
				return true
			else
				StaticPopupDialogs[G.uiname.."incorrect spellID"].text = T.color_text((spellText == L["输入法术ID"] and "") or spellText)..L["不是一个有效的法术ID"]
				StaticPopup_Show(G.uiname.."incorrect spellID")
			end
		end
	end

	if input_text_2 then
		function frame.second_input:apply()
			local level = self:GetText()
			if tonumber(level) then
				self:SetText(level)
				return true
			else
				StaticPopupDialogs[G.uiname.."incorrect number"].text = T.color_text(level)..L["必须是一个数字"]
				StaticPopup_Show(G.uiname.."incorrect number")
			end
		end
	end
			
	frame.addbutton:SetScript("OnClick", function(self)
		if input_text_2 then -- 含层级设置
			frame.first_input:GetScript("OnEnterPressed")(frame.first_input)
			frame.second_input:GetScript("OnEnterPressed")(frame.second_input)
			if not frame.first_input:apply() or not frame.second_input:apply() then return end
			
			local spellName, spellIcon,  _, spellID = T.GetSpellInfo(frame.first_input.current_spellID)
			local level = frame.second_input:GetText()
			local key_path = {}
			T.CopyTableInsertElement(key_path, path, spellID)
			
			T.ValueToPath(aCoreCDB, key_path, tonumber(level))
			CreateListButton("spell", frame, path, spellID, spellIcon, spellName, spellID, level)
			
			lineuplist(T.ValueFromPath(aCoreCDB, path), frame.option_list.list, frame.option_list.anchor)
			
			frame.first_input:SetText(L["输入法术ID"])
			frame.first_input.current_spellID = nil
			frame.second_input:SetText(input_text_2)
			
			if frame.apply then
				frame.apply() -- 生效
			end
		else
			frame.first_input:GetScript("OnEnterPressed")(frame.first_input)
			if not frame.first_input:apply() then return end
			
			local spellName, spellIcon, _, spellID = T.GetSpellInfo(frame.first_input.current_spellID)
			
			local key_path = {}
			T.CopyTableInsertElement(key_path, path, spellID)

			T.ValueToPath(aCoreCDB, key_path, true)
			CreateListButton("spell", frame, path, spellID, spellIcon, spellName, spellID)
			
			lineuplist(T.ValueFromPath(aCoreCDB, path), frame.option_list.list, frame.option_list.anchor)
			
			frame.first_input:SetText(L["输入法术ID"])
			frame.first_input.current_spellID = nil
			
			if frame.apply then
				frame.apply() -- 生效
			end
		end
	end)
	
	return frame
end

-- 类型列表：物品
T.CreateItemListOption = function(parent, points, height, text, path, input_text_2, filter_path)
	local frame = CreateListOption(parent, points, height, text, path, L["物品名称ID链接"], input_text_2, filter_path)
	
	frame.Button_OnClicked = function(bu)
		frame.first_input.current_itemID = tonumber(bu.mid:GetText())
	end
	
	frame:SetScript("OnShow", function()
		for itemID, quantity in pairs(T.ValueFromPath(aCoreCDB, path)) do
			local itemName = GetItemInfo(itemID)
			local itemIcon = select(10, GetItemInfo(itemID))
			if itemName then
				CreateListButton("item", frame, path, itemID, itemIcon, itemName, itemID, input_text_2 and quantity)
			else
				local key_path = {}
				T.CopyTableInsertElement(key_path, path, itemID)
				print("item ID "..itemID.." is gone, delete it.")
				T.ValueToPath(aCoreCDB, key_path, nil)
			end
		end
		lineuplist(T.ValueFromPath(aCoreCDB, path), frame.option_list.list, frame.option_list.anchor)
	end)
	
	frame.first_input:HookScript("OnChar", function(self) 
		self.current_itemID = nil
	end)
	
	table.insert(inputbox, frame.first_input) -- 支持链接/文字/数字
	function frame.first_input:apply()
		if self.current_itemID then
			return true
		else
			local itemText = self:GetText()
			local itemID = GetItemInfoInstant(itemText)
			if itemID then
				local itemName = GetItemInfo(itemID)
				self.current_itemID = itemID
				self:SetText(itemName)
				return true
			else
				StaticPopupDialogs[G.uiname.."incorrect itemID"].text = T.color_text((itemText == L["物品名称ID链接"] and "") or itemText)..L["不正确的物品ID"]
				StaticPopup_Show(G.uiname.."incorrect itemID")
				self:SetText(L["物品名称ID链接"])
			end
		end
	end

	if input_text_2 then		
		function frame.second_input:apply()
			local quantity = self:GetText()
			if tonumber(quantity) then
				self:SetText(quantity)
				return true
			else
				StaticPopupDialogs[G.uiname.."incorrect number"].text = T.color_text(quantity)..L["必须是一个数字"]
				StaticPopup_Show(G.uiname.."incorrect number")
				self:SetText(input_text_2)
			end
		end
		
	end
			
	frame.addbutton:SetScript("OnClick", function(self)
		if input_text_2 then -- 含数量设置
			frame.first_input:GetScript("OnEnterPressed")(frame.first_input)
			frame.second_input:GetScript("OnEnterPressed")(frame.second_input)
			if not frame.first_input:apply() or not frame.second_input:apply() then return end
			
			local itemID, _, _, _, itemIcon = GetItemInfoInstant(frame.first_input.current_itemID)
			local quantity = frame.second_input:GetText()
			local itemName = GetItemInfo(itemID)
			local key_path = {}
			T.CopyTableInsertElement(key_path, path, itemID)
				
			T.ValueToPath(aCoreCDB, key_path, tonumber(quantity))
			CreateListButton("item", frame, path, itemID, itemIcon, itemName, itemID, quantity)
			
			lineuplist(T.ValueFromPath(aCoreCDB, path), frame.option_list.list, frame.option_list.anchor)
			
			frame.first_input:SetText(L["物品名称ID链接"])
			frame.first_input.current_itemID = nil
			frame.second_input:SetText(input_text_2)
			
			if frame.apply then
				frame.apply() -- 生效
			end
		else
			frame.first_input:GetScript("OnEnterPressed")(frame.first_input)
			if not frame.first_input:apply() then return end
			
			local itemID, _, _, _, itemIcon = GetItemInfoInstant(frame.first_input.current_itemID)
			local itemName = GetItemInfo(itemID)
			local key_path = {}
			T.CopyTableInsertElement(key_path, path, itemID)
			
			T.ValueToPath(aCoreCDB, key_path, true)
			CreateListButton("item", frame, path, itemID, itemIcon, itemName, itemID)
			
			lineuplist(T.ValueFromPath(aCoreCDB, path), frame.option_list.list, frame.option_list.anchor)
			
			frame.first_input:SetText(L["物品名称ID链接"])
			frame.first_input.current_itemID = nil
			
			if frame.apply then
				frame.apply() -- 生效
			end
		end
	end)

	return frame
end

-- 类型列表：颜色
T.CreatePlateColorListOption = function(parent, points, height, text, path, filter_path)
	local frame = CreateListOption(parent, points, height, text, path, L["输入npc名称"], nil, filter_path)
	
	frame:SetScript("OnShow", function()
		for name, color in pairs(T.ValueFromPath(aCoreCDB, path)) do
			CreateListButton("", frame, path, name, nil, name, nil, nil, color)
		end
		lineuplist(T.ValueFromPath(aCoreCDB, path), frame.option_list.list, frame.option_list.anchor)
	end)
	
	frame.cpb = ColorpickerButton(frame, nil, {"LEFT", frame.first_input, "RIGHT", 5, 0})	
	
	frame.cpb.colors = {r = 1, g = 1, b = 1}
	
	frame.cpb:SetScript("OnClick", function(self)
		ColorPicker_OnClick(frame.cpb.colors, function(r, g, b)
			T.TableValueToPath(frame, {"cpb", "colors"}, {r = r, g = g, b = b})
			frame.cpb.ctex:SetVertexColor(r, g, b)
		end, {"TOPLEFT", frame.cpb, "BOTTOMLEFT", 0, -5})
	end)
	
	frame.addbutton:ClearAllPoints()
	frame.addbutton:SetPoint("LEFT", frame.cpb, "RIGHT", 5, 0)
	
	frame.addbutton:SetScript("OnClick", function(self)
		frame.first_input:GetScript("OnEnterPressed")(frame.first_input)
		
		local name = frame.first_input:GetText()
		local key_path = {}
		T.CopyTableInsertElement(key_path, path, name)
		T.TableValueToPath(aCoreCDB, key_path, frame.cpb.colors)

		CreateListButton("", frame, path, name, nil, name, nil, nil, frame.cpb.colors)
		
		lineuplist(T.ValueFromPath(aCoreCDB, path), frame.option_list.list, frame.option_list.anchor)
		
		frame.first_input:SetText(L["输入npc名称"])
		frame.cpb.colors.r, frame.cpb.colors.g, frame.cpb.colors.b = 1, 1, 1
		frame.cpb.ctex:SetVertexColor(1, 1, 1)
		
		if frame.apply then
			frame.apply() -- 生效
		end
	end)

	return frame
end

-- 类型列表：名称
T.CreatePlatePowerListOption = function(parent, points, height, text, path, filter_path)
	local frame = CreateListOption(parent, points, height, text, path, L["输入npc名称"], nil, filter_path)

	frame:SetScript("OnShow", function()
		for name, _ in pairs(T.ValueFromPath(aCoreCDB, path)) do
			CreateListButton("", frame, path, name, nil, name)
		end
		lineuplist(T.ValueFromPath(aCoreCDB, path), frame.option_list.list, frame.option_list.anchor)
	end)
	
	frame.addbutton:SetScript("OnClick", function(self)
		frame.first_input:GetScript("OnEnterPressed")(frame.first_input)
		
		local name = frame.first_input:GetText()
		local key_path = {}
		T.CopyTableInsertElement(key_path, path, name)
		T.ValueToPath(aCoreCDB, key_path, true)
		
		CreateListButton("", frame, path, name, nil, name)

		lineuplist(T.ValueFromPath(aCoreCDB, path), frame.option_list.list, frame.option_list.anchor)
		
		frame.first_input:SetText(L["输入npc名称"])
		
		if frame.apply then
			frame.apply() -- 生效
		end
	end)

	return frame
end

--====================================================--
--[[              -- GUI 选项排列 --                ]]--
--====================================================--
-- GUI位置
local SetGUIPoint = function(parent, width_perc, obj, before_gap, after_gap, x_offset, y_offset)
	local width = parent:GetWidth() - 20
	local line_height = 30
	
	parent.option_x = parent.option_x or 0
	parent.option_y = parent.option_y or 0
	
	if before_gap then -- 与上一项之间的行间距
		parent.option_y = parent.option_y + before_gap
	end
		
	if parent.option_x + width_perc*width > width then -- 需要换行
		obj:SetPoint("TOPLEFT", parent, "TOPLEFT", 20 + (x_offset or 0), - parent.option_y - line_height + (y_offset or 0))
		
		-- 下一项的锚点
		parent.option_x = width_perc*width
		parent.option_y = parent.option_y + math.ceil(width_perc)*line_height
		
		if after_gap then -- 与下一项之间的行间距
			parent.option_y = parent.option_y + after_gap
		end
	else
		obj:SetPoint("TOPLEFT", parent, "TOPLEFT", 20 + (x_offset or 0) + parent.option_x, - parent.option_y + (y_offset or 0))
		
		-- 下一项的锚点
		parent.option_x = parent.option_x + width_perc*width
	end
end

-- GUI功能
local CreateGUIOpitons = function(parent, OptionCategroy, start_ind, end_ind)
	local start_ = start_ind or 1
	local end_ = end_ind or #G.Options[OptionCategroy]
	for i = start_, end_ do
		local info = G.Options[OptionCategroy][i]
		local path = {OptionCategroy, info.key}
		local obj
		
		if (not info.class or info.class[G.myClass]) and (not info.client or info.client[G.Client]) then
			if info.option_type == "title" then
				obj = CreateGUITitle(parent, info.text, info.line, info.color)
			elseif info.option_type == "ddmenu" then
				obj = UIDropDownMenuFrame_DB(parent, "long", path)
			elseif info.option_type == "check" then
				obj = Checkbutton_DB(parent, path)
			elseif info.option_type == "slider" then
				obj = Slider_DB(parent, "long", path)
			elseif info.option_type == "editbox" then
				obj = EditboxFrame_DB(parent, path)
			elseif info.option_type == "cvar_check" then
				obj = CVarCheckButton(parent, path)
			elseif info.option_type == "multi_editbox" then
				obj = EditboxMultiLine_DB(parent, path)
			elseif info.option_type == "color" then
				obj = ColorpickerButton_DB(parent, path)
			end
			
			if info.rely then
				createDR(parent[info.rely], obj)
			end
			
			local before_gap, after_gap, x_offset, y_offset = 0, 0, 0, 0
			
			-- 段前间距
			if info.option_type == "title" then
				if info.text then
					before_gap = 20
				else
					before_gap = -10
				end
			elseif info.option_type == "multi_editbox" then
				before_gap = 15
			end
			
			if info.skip then
				before_gap = -30
			end
			
			-- 水平调整
			if info.option_type == "check" or info.option_type == "cvar_check"  then
				x_offset = x_offset - 5
			elseif info.option_type == "slider" then
				x_offset = x_offset + 155
			elseif info.option_type == "ddmenu" then
				x_offset = x_offset + 155
				obj.name:SetPoint("LEFT", obj, "LEFT", -155, 0)
			end
			
			-- 缩进
			if info.rely and (not info.width or info.width > 1) then 
				if info.option_type == "slider" then
					obj.LeftText:SetPoint("LEFT", obj.Slider, "LEFT", -155, 0)
				end
				
				if info.option_type ~= "slider" then
					x_offset = x_offset + 20
				end
			else
				if info.option_type == "slider" then
					obj.LeftText:SetPoint("LEFT", obj.Slider, "LEFT", -175, 0)
				end
			end
			
			-- 垂直调整
			if info.option_type == "slider" then
				y_offset = 10
			elseif info.option_type == "ddmenu" then
				y_offset = -4
			end
			
			SetGUIPoint(parent, info.width or 1, obj, before_gap, after_gap, x_offset, y_offset)
			
			if info.key then
				parent[info.key] = obj
			end
		end
	end
end
T.CreateGUIOpitons = CreateGUIOpitons
