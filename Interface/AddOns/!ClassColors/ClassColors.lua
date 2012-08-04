--[[--------------------------------------------------------------------
	!ClassColors
	Change class colors without breaking the Blizzard UI.
	Copyright (c) 2009–2012 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info12513-ClassColors.html
	http://www.curse.com/addons/wow/classcolors
----------------------------------------------------------------------]]

local _, ns = ...
if CUSTOM_CLASS_COLORS then
	ns.alreadyLoaded = true
	return
end

------------------------------------------------------------------------

local L = {
	TITLE = GetAddOnMetadata("!ClassColors", "Title"),
	NOTES = GetAddOnMetadata("!ClassColors", "Notes"),
	NOTES_DESC = "Note that not all addons support this, and you may need to reload the UI before your changes are recognized by all compatible addons.",
	RESET = RESET,
	RESET_DESC = "Reset all class colors to their Blizzard defaults.",
}

do
	local GAME_LOCALE = GetLocale()
	if GAME_LOCALE == "deDE" then
	--	L.NOTES_DESC = ""
		L.RESET_DESC = "Klassenfarben auf Standard zurücksetzen."

	elseif GetLocale() == "esES" or GetLocale() == "esMX" then
		L.NOTES_DESC = "Observe que no todos los accesorios son compatibles con este sistema, y es posible que tengas a volver a cargar la interfaz para que los cambios a ser reconocidos por todos accesorios compatibles."
		L.RESET_DESC = "Restaurar los colores de clase por defecto."

	elseif GAME_LOCALE == "frFR" then
	--	L.NOTES_DESC = ""
		L.RESET_DESC = "Réinitialisez la couleur des classes par défaut."

	elseif GAME_LOCALE == "itIT" then
	--	L.NOTES_DESC = ""
	--	L.RESET_DEST = ""

	elseif GAME_LOCALE == "ptBR" then
		L.NOTES_DESC = "Observe que nem todos os addons são compatíveis com este sistema, e você pode ter que recarregar a interface antes de suas alterações são reconhecidos por todos os addons compatíveis."
		L.RESET_DESC = "Redefinir todas as cores classe para seus valores padrão."

	elseif GAME_LOCALE == "ruRU" then
	--	L.NOTES_DESC = ""
		L.RESET_DESC = "Сбросить окраску классов на значение по умолчанию."

	elseif GAME_LOCALE == "koKR" then
	--	L.NOTES_DESC = ""
		L.RESET_DESC = "직업 색상을 기본값으로 되돌립니다."

	elseif GAME_LOCALE == "zhCN" then
	--	L.NOTES_DESC = ""
		L.RESET_DESC = "重置职业颜色为默认"

	elseif GAME_LOCALE == "zhTW" then
	--	L.NOTES_DESC = ""
		L.RESET_DESC = "重置職業顔色為默認"
	end
end

FillLocalizedClassList(L, false)

------------------------------------------------------------------------

CUSTOM_CLASS_COLORS = { }

------------------------------------------------------------------------

local callbacks = { }
local numCallbacks = 0

local function RegisterCallback(self, method, handler)
	if type(method) ~= "string" and type(method) ~= "function" then
		error("Bad argument #1 to :RegisterCallback (string or function expected)")
	end

	if type(method) == "string" then
		if type(handler) ~= "table" then
			error("Bad argument #2 to :RegisterCallback (table expected)")
		elseif type(handler[method]) ~= "function" then
			error("Bad argument #1 to :RegisterCallback (method \"" .. method .. "\" not found)")
		end

		method = handler[method]
	end

	if callbacks[method] then
	--	Nobody cares. Shut up and play along.
	--	error("Callback already registered!")
		return
	end

	callbacks[method] = handler or true
	numCallbacks = numCallbacks + 1
end

local function UnregisterCallback(self, method, handler)
	if type(method) ~= "string" and type(method) ~= "function" then
		error("Bad argument #1 to :RegisterCallback (string or function expected)")
	end

	if type(method) == "string" then
		if type(handler) ~= "table" then
			error("Bad argument #2 to :RegisterCallback (table expected)")
		elseif type(handler[method]) ~= "function" then
			error("Bad argument #1 to :RegisterCallback (method \"" .. method .. "\" not found)")
		end

		method = handler[method]
	end

	if not callbacks[method] then
	--	Nobody cares. Shut up and play along.
	--	error("Callback not registered!")
		return
	end

	callbacks[method] = nil
	numCallbacks = numCallbacks - 1
end

local function DispatchCallbacks()
	if numCallbacks < 1 then return end
	-- print("CUSTOM_CLASS_COLORS, DispatchCallbacks")

	for method, handler in pairs(callbacks) do
		method(handler ~= true and handler)
	end
end

------------------------------------------------------------------------

local classes = { }
for class in pairs(RAID_CLASS_COLORS) do
	table.insert(classes, class)
end
table.sort(classes)

local classTokens = { }
for i, class in ipairs(classes) do
	classTokens[L[class]] = class
end

local function GetClassToken(self, className)
	return className and classTokens[className]
end

------------------------------------------------------------------------

setmetatable(CUSTOM_CLASS_COLORS, { __index = function(t, k)
	if k == "GetClassToken" then return GetClassToken end
	if k == "RegisterCallback" then return RegisterCallback end
	if k == "UnregisterCallback" then return UnregisterCallback end
end })

------------------------------------------------------------------------

local f = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon ~= "!ClassColors" then return end
	-- print("ClassColors: ADDON_LOADED")

	--------------------------------------------------------------------

	local db
	local defaults = { }

	--------------------------------------------------------------------

	if not ClassColorsDB then ClassColorsDB = { } end
	db = ClassColorsDB

	for i, class in ipairs(classes) do
		local color = RAID_CLASS_COLORS[class]
		local r, g, b = color.r, color.g, color.b
		local hex = ("ff%02x%02x%02x"):format(r * 255, g * 255, b * 255)

		defaults[class] = {
			r = r,
			g = g,
			b = b,
			colorStr = hex,
		}

		if not db[class] or not db[class].r or not db[class].g or not db[class].b then
			db[class] = {
				r = r,
				g = g,
				b = b,
				colorStr = hex,
			}
		elseif not db[class].hex then
			db[class].hex = ("ff%02x%02x%02x"):format(db[class].r * 255, db[class].g * 255, db[class].b * 255)
		end

		CUSTOM_CLASS_COLORS[class] = {
			r = db[class].r,
			g = db[class].g,
			b = db[class].b,
			colorStr = db[class].hex,
		}
	end

	--------------------------------------------------------------------

	local fire
	local shown
	local cache = { }
	local pickers = { }

	self.name = L.TITLE
	self:Hide()

	local title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetPoint("TOPRIGHT", -16, -16)
	title:SetJustifyH("LEFT")
	title:SetText(L.TITLE)

	local notes = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	notes:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	notes:SetPoint("TOPRIGHT", title, "BOTTOMRIGHT", 0, -8)
	notes:SetHeight(28)
	notes:SetJustifyH("LEFT")
	notes:SetJustifyV("TOP")
	notes:SetNonSpaceWrap(true)
	notes:SetText(L.NOTES)

	for i, class in ipairs(classes) do
		local color = db[class]

		cache[i] = { }

		pickers[i] = self:CreateColorPicker(L[class])
		pickers[i].class = class

		pickers[i].GetValue = function()
			return color.r, color.g, color.b
		end

		pickers[i].SetValue = function(self, r, g, b)
			self.label:SetTextColor(r, g, b)

			color.r = r
			color.g = g
			color.b = b
			color.colorStr = ("ff%02x%02x%02x"):format(r * 255, g * 255, b * 255)

			CUSTOM_CLASS_COLORS[class].r = r
			CUSTOM_CLASS_COLORS[class].g = g
			CUSTOM_CLASS_COLORS[class].b = b
			CUSTOM_CLASS_COLORS[class].colorStr = ("ff%02x%02x%02x"):format(r * 255, g * 255, b * 255)

			if cache[i].r ~= r or cache[i].g ~= g or cache[i].b ~= b then
				DispatchCallbacks()
			end
		end

		pickers[i]:SetColor(color.r, color.g, color.b)
		pickers[i].label:SetTextColor(color.r, color.g, color.b)

		if i == 1 then
			pickers[i]:SetPoint("TOPLEFT", notes, "BOTTOMLEFT", 0, -12)
		elseif i == 2 then
			pickers[i]:SetPoint("TOPLEFT", notes, "BOTTOMLEFT", 200, -16)
		else
			pickers[i]:SetPoint("TOPLEFT", pickers[i-2], "BOTTOMLEFT", 0, -8)
		end
	end

	--------------------------------------------------------------------

	self:SetScript("OnShow", function(self)
		-- print("ClassColors: OnShow")

		for i, picker in ipairs(pickers) do
			local r, g, b = picker:GetValue()
			cache[i].r = r
			cache[i].g = g
			cache[i].b = b
		end

		shown = true
	end)

	self.okay = function()
		if not shown then return end
		-- print("ClassColors: okay")

		for i, t in ipairs(cache) do
			wipe(t)
		end

		shown = false
	end

	self.cancel = function()
		if not shown then return end
		-- print("ClassColors: cancel")

		local changed

		for i, picker in ipairs(pickers) do
			local class = picker.class

			if db[class].r ~= cache[i].r or db[class].r ~= cache[i].r or db[class].r ~= cache[i].r then
				changed = true

				picker:SetColor(cache[class].r, cache[class].g, cache[class].b)

				local r, g, b = cache[i].r, cache[i].g, cache[i].b
				local hex = ("ff%02x%02x%02x"):format(r * 255, g * 255, b * 255)

				db[class].r = r
				db[class].g = r
				db[class].b = g
				db[class].colorStr = hex

				CUSTOM_CLASS_COLORS[class].r = r
				CUSTOM_CLASS_COLORS[class].g = g
				CUSTOM_CLASS_COLORS[class].b = b
				CUSTOM_CLASS_COLORS[class].colorStr = hex
			end

			wipe(cache[i])
		end

		if changed then
			DispatchCallbacks()
		end

		shown = false
	end

	self.defaults = function()
		-- print("ClassColors: defaults")

		local changed

		for i, picker in ipairs(pickers) do
			local class = picker.class
			local color = RAID_CLASS_COLORS[class]

			if db[class].r ~= color.r or db[class].g ~= color.g or db[class].b ~= color.b then
				changed = true

				local r, g, b = color.r, color.g, color.b
				local hex = ("ff%02x%02x%02x"):format(r * 255, g * 255, b * 255)

				picker:SetColor(r, g, b)

				cache[i].r = r
				cache[i].g = g
				cache[i].b = b

				db[class].r = r
				db[class].g = g
				db[class].b = b
				db[class].colorStr = hex

				CUSTOM_CLASS_COLORS[class].r = r
				CUSTOM_CLASS_COLORS[class].g = g
				CUSTOM_CLASS_COLORS[class].b = b
				CUSTOM_CLASS_COLORS[class].colorStr = hex
			end
		end

		if changed then
			DispatchCallbacks()
		end
	end

	--------------------------------------------------------------------

	local reset = CreateFrame("Button", nil, self)
	reset:SetPoint("BOTTOMLEFT", self, 16, 16)
	reset:SetWidth(96)
	reset:SetHeight(22)
	reset:SetNormalFontObject(GameFontNormal)
	reset:SetHighlightFontObject(GameFontHighlight)
	reset:SetDisabledFontObject(GameFontDisable)
	reset:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	reset:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Down")
	reset:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
	reset:SetDisabledTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
	reset:GetNormalTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	reset:GetPushedTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	reset:GetHighlightTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	reset:GetDisabledTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	reset:GetHighlightTexture():SetBlendMode("ADD")
	reset:SetScript("OnEnter", function(self)
		if self.hint then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self.hint, nil, nil, nil, nil, true)
		end
	end)
	reset:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	reset:SetText(L.RESET)
	reset.hint = L.RESET_DESC
	reset:SetScript("OnClick", self.defaults)

	--------------------------------------------------------------------

	local help = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	help:SetPoint("TOP", pickers[#pickers], "BOTTOM", 0, -16)
	help:SetPoint("BOTTOMLEFT", 16, 54)
	help:SetPoint("BOTTOMRIGHT", -16, 54)
	help:SetHeight(84)
	help:SetJustifyH("LEFT")
	help:SetJustifyV("TOP")
	help:SetNonSpaceWrap(true)
	help:SetText(L.NOTES_DESC)

	--------------------------------------------------------------------

	InterfaceOptions_AddCategory(self)

	--------------------------------------------------------------------

	SLASH_CLASSCOLORS1 = "/classcolors"
	SlashCmdList.CLASSCOLORS = function()
		InterfaceOptionsFrame_OpenToCategory(self)
	end

	--------------------------------------------------------------------

	self:UnregisterEvent("ADDON_LOADED")
	self:SetScript("OnEvent", nil)
end)

------------------------------------------------------------------------

do
	local NORMAL_FONT_COLOR = NORMAL_FONT_COLOR
	local HIGHLIGHT_FONT_COLOR = HIGHLIGHT_FONT_COLOR
	local ColorPickerFrame = ColorPickerFrame
	local GameTooltip = GameTooltip

	local function OnEnter(self)
		local color = NORMAL_FONT_COLOR
		self.bg:SetVertexColor(color.r, color.g, color.b)

		if self.hint then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self.hint, nil, nil, nil, nil, true)
		end
	end

	local function OnLeave(self)
		local color = HIGHLIGHT_FONT_COLOR
		self.bg:SetVertexColor(color.r, color.g, color.b)

		GameTooltip:Hide()
	end

	local function OnClick(self)
		OnLeave(self)

		if ColorPickerFrame:IsShown() then
			ColorPickerFrame:Hide()
		else
			self.r, self.g, self.b = self:GetValue()

			UIDropDownMenuButton_OpenColorPicker(self)
			ColorPickerFrame:SetFrameStrata("TOOLTIP")
			ColorPickerFrame:Raise()
		end
	end

	local function SetColor(self, r, g, b)
		self.swatch:SetVertexColor(r, g, b)
		if not ColorPickerFrame:IsShown() then
			self:SetValue(r, g, b)
		end
	end

	local function SetSize(f, x, y)
		f:SetHeight(y or x)
		f.swatch:SetWidth(y or x)
	end

	function f:CreateColorPicker(name)
		local frame = CreateFrame("Button", nil, self)
		frame:SetHeight(19)
		frame:SetWidth(100)

		frame.SetSize = SetSize

		local swatch = frame:CreateTexture(nil, "OVERLAY")
		swatch:SetTexture("Interface\\ChatFrame\\ChatFrameColorSwatch")
		swatch:SetPoint("TOPLEFT")
		swatch:SetPoint("BOTTOMLEFT")
		swatch:SetWidth(19)
		frame.swatch = swatch

		local bg = frame:CreateTexture(nil, "BACKGROUND")
		bg:SetTexture(1, 1, 1)
		bg:SetPoint("TOPLEFT", swatch, 1, -1)
		bg:SetPoint("BOTTOMRIGHT", swatch, -1, 1)
		frame.bg = bg

		local label = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		label:SetPoint("TOPLEFT", swatch, "TOPRIGHT", 4, 1)
		label:SetPoint("BOTTOMLEFT", swatch, "BOTTOMRIGHT", 4, 1)
		label:SetText(name)
		frame.label = label

		frame.SetColor = SetColor
		frame.swatchFunc = function() frame:SetColor(ColorPickerFrame:GetColorRGB()) end
		frame.cancelFunc = function() frame:SetColor(frame.r, frame.g, frame.b) end

		frame:SetScript("OnClick", OnClick)
		frame:SetScript("OnEnter", OnEnter)
		frame:SetScript("OnLeave", OnLeave)

		local width = 19 + 4 + label:GetStringWidth()
		if width > 100 then
			frame:SetWidth(width)
		end

		return frame
	end
end

------------------------------------------------------------------------