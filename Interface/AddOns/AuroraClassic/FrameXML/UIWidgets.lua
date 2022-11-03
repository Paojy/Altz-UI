local _, ns = ...
local B, C, L, DB = unpack(ns)

local Type_StatusBar = _G.Enum.UIWidgetVisualizationType.StatusBar
local Type_CaptureBar = _G.Enum.UIWidgetVisualizationType.CaptureBar
local Type_SpellDisplay = _G.Enum.UIWidgetVisualizationType.SpellDisplay
local Type_DoubleStatusBar = _G.Enum.UIWidgetVisualizationType.DoubleStatusBar

local atlasColors = {
	["UI-Frame-Bar-Fill-Blue"] = {.2, .6, 1},
	["UI-Frame-Bar-Fill-Red"] = {.9, .2, .2},
	["UI-Frame-Bar-Fill-Yellow"] = {1, .6, 0},
	["objectivewidget-bar-fill-left"] = {.2, .6, 1},
	["objectivewidget-bar-fill-right"] = {.9, .2, .2},
	["EmberCourtScenario-Tracker-barfill"] = {.9, .2, .2},
}

function B:ReplaceWidgetBarTexture(atlas)
	if atlasColors[atlas] then
		self:SetStatusBarTexture(DB.normTex)
		self:SetStatusBarColor(unpack(atlasColors[atlas]))
	end
end

local function ResetLabelColor(text, _, _, _, _, force)
	if not force then
		text:SetTextColor(1, 1, 1, 1, true)
	end
end

local function ReskinWidgetStatusBar(bar)
	if bar and not bar.styled then
		if bar.BG then bar.BG:SetAlpha(0) end
		if bar.BGLeft then bar.BGLeft:SetAlpha(0) end
		if bar.BGRight then bar.BGRight:SetAlpha(0) end
		if bar.BGCenter then bar.BGCenter:SetAlpha(0) end
		if bar.BorderLeft then bar.BorderLeft:SetAlpha(0) end
		if bar.BorderRight then bar.BorderRight:SetAlpha(0) end
		if bar.BorderCenter then bar.BorderCenter:SetAlpha(0) end
		if bar.Spark then bar.Spark:SetAlpha(0) end
		if bar.SparkGlow then bar.SparkGlow:SetAlpha(0) end
		if bar.BorderGlow then bar.BorderGlow:SetAlpha(0) end
		if bar.Label then
			bar.Label:SetPoint("CENTER", 0, -5)
			bar.Label:SetFontObject(Game12Font)
			ResetLabelColor(bar.Label)
			hooksecurefunc(bar.Label, "SetTextColor", ResetLabelColor)
		end
		B.SetBD(bar)
		if bar.GetStatusBarAtlas then
			B.ReplaceWidgetBarTexture(bar, bar:GetStatusBarAtlas())
			hooksecurefunc(bar, "SetStatusBarAtlas", B.ReplaceWidgetBarTexture)
		end

		bar.styled = true
	end
end

local function ReskinDoubleStatusBarWidget(self)
	if not self.styled then
		ReskinWidgetStatusBar(self.LeftBar)
		ReskinWidgetStatusBar(self.RightBar)

		self.styled = true
	end
end

local function ReskinPVPCaptureBar(self)
	self.LeftBar:SetTexture(DB.normTex)
	self.NeutralBar:SetTexture(DB.normTex)
	self.RightBar:SetTexture(DB.normTex)

	self.LeftBar:SetVertexColor(.2, .6, 1)
	self.NeutralBar:SetVertexColor(.8, .8, .8)
	self.RightBar:SetVertexColor(.9, .2, .2)

	self.LeftLine:SetAlpha(0)
	self.RightLine:SetAlpha(0)
	self.BarBackground:SetAlpha(0)
	self.Glow1:SetAlpha(0)
	self.Glow2:SetAlpha(0)
	self.Glow3:SetAlpha(0)

	if not self.bg then
		self.bg = B.SetBD(self)
		self.bg:SetPoint("TOPLEFT", self.LeftBar, -2, 2)
		self.bg:SetPoint("BOTTOMRIGHT", self.RightBar, 2, -2)
	end
end

local function ReskinSpellDisplayWidget(spell)
	if not spell.bg then
		spell.Border:SetAlpha(0)
		spell.DebuffBorder:SetAlpha(0)
		spell.bg = B.ReskinIcon(spell.Icon)
	end
	spell.IconMask:Hide()
end

local function ReskinPowerBarWidget(self)
	for _, widgetFrame in pairs(self.widgetFrames) do
		if widgetFrame.widgetType == Type_StatusBar then
			if not widgetFrame:IsForbidden() then
				ReskinWidgetStatusBar(widgetFrame.Bar)
			end
		end
	end
end

local function ReskinWidgetGroups(self)
	for _, widgetFrame in pairs(self.widgetFrames) do
		if not widgetFrame:IsForbidden() then
			local widgetType = widgetFrame.widgetType
			if widgetType == Type_DoubleStatusBar then
				ReskinDoubleStatusBarWidget(widgetFrame)
			elseif widgetType == Type_SpellDisplay then
				ReskinSpellDisplayWidget(widgetFrame.Spell)
			elseif widgetType == Type_StatusBar then
				ReskinWidgetStatusBar(widgetFrame.Bar)
			end
		end
	end
end

tinsert(C.defaultThemes, function()
	hooksecurefunc(_G.UIWidgetTopCenterContainerFrame, "UpdateWidgetLayout", ReskinWidgetGroups)
	ReskinWidgetGroups(_G.UIWidgetTopCenterContainerFrame)

	hooksecurefunc(_G.UIWidgetBelowMinimapContainerFrame, "UpdateWidgetLayout", function(self)
		for _, widgetFrame in pairs(self.widgetFrames) do
			if widgetFrame.widgetType == Type_CaptureBar then
				if not widgetFrame:IsForbidden() then
					ReskinPVPCaptureBar(widgetFrame)
				end
			end
		end
	end)

	hooksecurefunc(_G.UIWidgetPowerBarContainerFrame, "UpdateWidgetLayout", ReskinPowerBarWidget)
	ReskinPowerBarWidget(_G.UIWidgetPowerBarContainerFrame)

	hooksecurefunc(_G.TopScenarioWidgetContainerBlock.WidgetContainer, "UpdateWidgetLayout", ReskinPowerBarWidget)

	hooksecurefunc(_G.BottomScenarioWidgetContainerBlock.WidgetContainer, "UpdateWidgetLayout", function(self)
		for _, widgetFrame in pairs(self.widgetFrames) do
			if widgetFrame.widgetType == Type_SpellDisplay then
				if not widgetFrame:IsForbidden() then
					ReskinSpellDisplayWidget(widgetFrame.Spell)
				end
			end
		end
	end)

	-- if font outline enabled in tooltip, fix text shows in two lines on Torghast info
	hooksecurefunc(_G.UIWidgetTemplateTextWithStateMixin, "Setup", function(self)
		self.Text:SetWidth(self.Text:GetStringWidth() + 2)
	end)

	-- needs review, might remove this in the future
	hooksecurefunc(_G.UIWidgetTemplateStatusBarMixin, "Setup", function(self)
		if self:IsForbidden() then return end
		ReskinWidgetStatusBar(self.Bar)
	end)
end)