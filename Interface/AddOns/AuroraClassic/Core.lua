local _, ns = ...
local B, C, L, DB = unpack(ns)
local cr, cg, cb = DB.r, DB.g, DB.b

-- Kill regions
do
	function B:Dummy()
		return
	end

	B.HiddenFrame = CreateFrame("Frame")
	B.HiddenFrame:Hide()

	function B:HideObject()
		if self.UnregisterAllEvents then
			self:UnregisterAllEvents()
			self:SetParent(B.HiddenFrame)
		else
			self.Show = self.Hide
		end
		self:Hide()
	end

	function B:HideOption()
		self:SetAlpha(0)
		self:SetScale(.0001)
	end

	function B:Round(number, idp)
		idp = idp or 0
		local mult = 10 ^ idp
		return floor(number * mult + .5) / mult
	end

	local blizzTextures = {
		"Inset",
		"inset",
		"InsetFrame",
		"LeftInset",
		"RightInset",
		"NineSlice",
		"BG",
		"Bg",
		"border",
		"Border",
		"Background",
		"BorderFrame",
		"bottomInset",
		"BottomInset",
		"bgLeft",
		"bgRight",
		"FilligreeOverlay",
		"PortraitOverlay",
		"ArtOverlayFrame",
		"Portrait",
		"portrait",
		"ScrollFrameBorder",
		"ScrollUpBorder",
		"ScrollDownBorder",
	}
	function B:StripTextures(kill)
		local frameName = self.GetName and self:GetName()
		for _, texture in pairs(blizzTextures) do
			local blizzFrame = self[texture] or (frameName and _G[frameName..texture])
			if blizzFrame then
				B.StripTextures(blizzFrame, kill)
			end
		end

		if self.GetNumRegions then
			for i = 1, self:GetNumRegions() do
				local region = select(i, self:GetRegions())
				if region and region.IsObjectType and region:IsObjectType("Texture") then
					if kill and type(kill) == "boolean" then
						B.HideObject(region)
					elseif tonumber(kill) then
						if kill == 0 then
							region:SetAlpha(0)
						elseif i ~= kill then
							region:SetTexture("")
							region:SetAtlas("")
						end
					else
						region:SetTexture("")
						region:SetAtlas("")
					end
				end
			end
		end
	end
end

-- UI widgets
do
	function B:SetFontSize(size)
		self:SetFont(DB.Font[1], size, DB.Font[3])
	end

	function B:CreateTex()
		if self.__bgTex then return end

		local frame = self
		if self:IsObjectType("Texture") then frame = self:GetParent() end

		local tex = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
		tex:SetAllPoints(self)
		tex:SetTexture(DB.bgTex, true, true)
		tex:SetHorizTile(true)
		tex:SetVertTile(true)
		tex:SetBlendMode("ADD")

		self.__bgTex = tex
	end

	local shadowBackdrop = {edgeFile = DB.glowTex}
	function B:CreateSD()
		if not AuroraClassicDB.Shadow then return end
		if self.__shadow then return end

		local frame = self
		if self:IsObjectType("Texture") then frame = self:GetParent() end

		shadowBackdrop.edgeSize = size or 5
		self.__shadow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
		self.__shadow:SetOutside(self, size or 4, size or 4)
		self.__shadow:SetBackdrop(shadowBackdrop)
		self.__shadow:SetBackdropBorderColor(0, 0, 0, size and 1 or .4)
		self.__shadow:SetFrameLevel(1)

		return self.__shadow
	end
end

-- UI skins
do
	-- Setup backdrop
	C.frames = {}
	local defaultBackdrop = {bgFile = DB.bdTex, edgeFile = DB.bdTex}

	function B:CreateBD(a)
		defaultBackdrop.edgeSize = C.mult
		self:SetBackdrop(defaultBackdrop)
		self:SetBackdropColor(0, 0, 0, a or AuroraClassicDB.Alpha)
		self:SetBackdropBorderColor(0, 0, 0)
		if not a then tinsert(C.frames, self) end
	end

	local gradientFrom, gradientTo = CreateColor(0, 0, 0, .5), CreateColor(.3, .3, .3, .3)
	function B:CreateGradient()
		local tex = self:CreateTexture(nil, "BORDER")
		tex:SetInside()
		tex:SetTexture(DB.bdTex)
		if AuroraClassicDB.FlatMode then
			tex:SetVertexColor(.3, .3, .3, .25)
		else
			tex:SetGradient("Vertical", gradientFrom, gradientTo)
		end

		return tex
	end

	-- Handle frame
	function B:CreateBDFrame(a, gradient)
		local frame = self
		if self:IsObjectType("Texture") then frame = self:GetParent() end
		local lvl = frame:GetFrameLevel()

		local bg = CreateFrame("Frame", nil, frame, "BackdropTemplate")
		bg:SetOutside(self)
		bg:SetFrameLevel(lvl == 0 and 0 or lvl - 1)
		B.CreateBD(bg, a)
		if gradient then
			self.__gradient = B.CreateGradient(bg)
		end

		return bg
	end

	function B:SetBD(a, x, y, x2, y2)
		local bg = B.CreateBDFrame(self, a)
		if x then
			bg:SetPoint("TOPLEFT", self, x, y)
			bg:SetPoint("BOTTOMRIGHT", self, x2, y2)
		end
		B.CreateSD(bg)
		B.CreateTex(bg)

		return bg
	end

	-- Handle icons
	local x1, x2, y1, y2 = unpack(DB.TexCoord)

	function B:ReskinIcon(shadow)
		self:SetTexCoord(x1, x2, y1, y2)
		local bg = B.CreateBDFrame(self, .25) -- exclude from opacity control
		if shadow then B.CreateSD(bg) end
		return bg
	end

	local AtlasToQuality = {
		["error"] = 99,
		["uncollected"] = LE_ITEM_QUALITY_POOR,
		["gray"] = LE_ITEM_QUALITY_POOR,
		["white"] = LE_ITEM_QUALITY_COMMON,
		["green"] = LE_ITEM_QUALITY_UNCOMMON,
		["blue"] = LE_ITEM_QUALITY_RARE,
		["purple"] = LE_ITEM_QUALITY_EPIC,
		["orange"] = LE_ITEM_QUALITY_LEGENDARY,
		["artifact"] = LE_ITEM_QUALITY_ARTIFACT,
		["account"] = LE_ITEM_QUALITY_HEIRLOOM,
	}
	local function updateIconBorderColorByAtlas(border, atlas)
		local atlasAbbr = atlas and strmatch(atlas, "%-(%w+)$")
		local quality = atlasAbbr and AtlasToQuality[atlasAbbr]
		local color = DB.QualityColors[quality or 1]
		border.__owner.bg:SetBackdropBorderColor(color.r, color.g, color.b)
	end

	local greyRGB = DB.QualityColors[0].r
	local function updateIconBorderColor(border, r, g, b)
		if not r or r == greyRGB or (r>.99 and g>.99 and b>.99) then
			r, g, b = 0, 0, 0
		end
		border.__owner.bg:SetBackdropBorderColor(r, g, b)
		border:Hide(true) -- fix icon border
	end
	local function resetIconBorderColor(border, texture)
		if not texture then
			border.__owner.bg:SetBackdropBorderColor(0, 0, 0)
		end
	end
	local function resetIconBorder(button, quality)
		if not quality then
			button.IconBorder:Hide()
		end
	end
	local function iconBorderShown(border, show)
		if not show then
			resetIconBorderColor(border)
		end
	end
	function B:ReskinIconBorder(needInit, useAtlas)
		self:SetAlpha(0)
		self.__owner = self:GetParent()
		if not self.__owner.bg then return end
		if useAtlas or self.__owner.useCircularIconBorder then -- for auction item display
			hooksecurefunc(self, "SetAtlas", updateIconBorderColorByAtlas)
			hooksecurefunc(self, "SetTexture", resetIconBorderColor)
			if needInit then
				self:SetAtlas(self:GetAtlas()) -- for border with color before hook
			end
		else
			hooksecurefunc(self, "SetVertexColor", updateIconBorderColor)
			if needInit then
				self:SetVertexColor(self:GetVertexColor()) -- for border with color before hook
			end
		end
		hooksecurefunc(self, "Hide", resetIconBorderColor)
		hooksecurefunc(self, "SetShown", iconBorderShown)

		-- disable this and see how it goes, needs review
		--if self.__owner.SetItemButtonQuality then
		--	hooksecurefunc(self.__owner, "SetItemButtonQuality", resetIconBorder)
		--end
	end

	local CLASS_ICON_TCOORDS = CLASS_ICON_TCOORDS
	function B:ClassIconTexCoord(class)
		local tcoords = CLASS_ICON_TCOORDS[class]
		self:SetTexCoord(tcoords[1] + .022, tcoords[2] - .025, tcoords[3] + .022, tcoords[4] - .025)
	end

	function B:CreateAndUpdateBarTicks(bar, ticks, numTicks)
		for i = 1, #ticks do
			ticks[i]:Hide()
		end

		if numTicks and numTicks > 0 then
			local width, height = bar:GetSize()
			local delta = width / numTicks
			for i = 1, numTicks-1 do
				if not ticks[i] then
					ticks[i] = bar:CreateTexture(nil, "OVERLAY")
					ticks[i]:SetTexture(DB.normTex)
					ticks[i]:SetVertexColor(0, 0, 0, .7)
					ticks[i]:SetWidth(C.mult)
					ticks[i]:SetHeight(height)
				end
				ticks[i]:ClearAllPoints()
				ticks[i]:SetPoint("RIGHT", bar, "LEFT", delta * i, 0 )
				ticks[i]:Show()
			end
		end
	end

	-- Handle button
	local function Button_OnEnter(self)
		if not self:IsEnabled() then return end

		if AuroraClassicDB.FlatMode then
			self.__gradient:SetVertexColor(cr / 4, cg / 4, cb / 4)
		else
			self.__bg:SetBackdropColor(cr, cg, cb, .25)
		end
		self.__bg:SetBackdropBorderColor(cr, cg, cb)
	end
	local function Button_OnLeave(self)
		if AuroraClassicDB.FlatMode then
			self.__gradient:SetVertexColor(.3, .3, .3, .25)
		else
			self.__bg:SetBackdropColor(0, 0, 0, 0)
		end
		self.__bg:SetBackdropBorderColor(0, 0, 0)
	end

	local blizzRegions = {
		"Left",
		"Middle",
		"Right",
		"Mid",
		"LeftDisabled",
		"MiddleDisabled",
		"RightDisabled",
		"TopLeft",
		"TopRight",
		"BottomLeft",
		"BottomRight",
		"TopMiddle",
		"MiddleLeft",
		"MiddleRight",
		"BottomMiddle",
		"MiddleMiddle",
		"TabSpacer",
		"TabSpacer1",
		"TabSpacer2",
		"_RightSeparator",
		"_LeftSeparator",
		"Cover",
		"Border",
		"Background",
		"TopTex",
		"TopLeftTex",
		"TopRightTex",
		"LeftTex",
		"BottomTex",
		"BottomLeftTex",
		"BottomRightTex",
		"RightTex",
		"MiddleTex",
		"Center",
	}
	function B:Reskin(noHighlight, override)
		if self.SetNormalTexture and not override then self:SetNormalTexture(0) end
		if self.SetHighlightTexture then self:SetHighlightTexture(0) end
		if self.SetPushedTexture then self:SetPushedTexture(0) end
		if self.SetDisabledTexture then self:SetDisabledTexture(0) end

		local buttonName = self.GetName and self:GetName()
		for _, region in pairs(blizzRegions) do
			region = buttonName and _G[buttonName..region] or self[region]
			if region then
				region:SetAlpha(0)
				region:Hide()
			end
		end

		self.__bg = B.CreateBDFrame(self, 0, true)
		self.__bg:SetFrameLevel(self:GetFrameLevel())
		self.__bg:SetAllPoints()

		if not noHighlight then
			self:HookScript("OnEnter", Button_OnEnter)
			self:HookScript("OnLeave", Button_OnLeave)
		end
	end

	local function Menu_OnEnter(self)
		self.bg:SetBackdropBorderColor(cr, cg, cb)
	end
	local function Menu_OnLeave(self)
		self.bg:SetBackdropBorderColor(0, 0, 0)
	end
	local function Menu_OnMouseUp(self)
		self.bg:SetBackdropColor(0, 0, 0, AuroraClassicDB.Alpha)
	end
	local function Menu_OnMouseDown(self)
		self.bg:SetBackdropColor(cr, cg, cb, .25)
	end

	function B:ReskinMenuButton()
		B.StripTextures(self)
		self.bg = B.SetBD(self)
		self:SetScript("OnEnter", Menu_OnEnter)
		self:SetScript("OnLeave", Menu_OnLeave)
		self:HookScript("OnMouseUp", Menu_OnMouseUp)
		self:HookScript("OnMouseDown", Menu_OnMouseDown)
	end

	-- Handle tabs
	function B:ReskinTab()
		self:DisableDrawLayer("BACKGROUND")
		if self.LeftHighlight then
			self.LeftHighlight:SetAlpha(0)
		end
		if self.RightHighlight then
			self.RightHighlight:SetAlpha(0)
		end
		if self.MiddleHighlight then
			self.MiddleHighlight:SetAlpha(0)
		end

		local bg = B.CreateBDFrame(self)
		bg:SetPoint("TOPLEFT", 8, -3)
		bg:SetPoint("BOTTOMRIGHT", -8, 0)
		self.bg = bg

		self:SetHighlightTexture(DB.bdTex)
		local hl = self:GetHighlightTexture()
		hl:ClearAllPoints()
		hl:SetInside(bg)
		hl:SetVertexColor(cr, cg, cb, .25)
	end

	function B:ResetTabAnchor()
		local text = self.Text or (self.GetName and _G[self:GetName().."Text"])
		if text then
			text:SetPoint("CENTER", self)
		end
	end
	hooksecurefunc("PanelTemplates_SelectTab", B.ResetTabAnchor)
	hooksecurefunc("PanelTemplates_DeselectTab", B.ResetTabAnchor)

	-- Handle scrollframe
	local function Thumb_OnEnter(self)
		local thumb = self.thumb or self
		thumb.bg:SetBackdropColor(cr, cg, cb, .75)
	end
	local function Thumb_OnLeave(self)
		local thumb = self.thumb or self
		if thumb.__isActive then return end
		thumb.bg:SetBackdropColor(cr, cg, cb, .25)
	end
	local function Thumb_OnMouseDown(self)
		local thumb = self.thumb or self
		thumb.__isActive = true
		thumb.bg:SetBackdropColor(cr, cg, cb, .75)
	end
	local function Thumb_OnMouseUp(self)
		local thumb = self.thumb or self
		thumb.__isActive = nil
		thumb.bg:SetBackdropColor(cr, cg, cb, .25)
	end

	local function updateScrollArrow(arrow)
		if not arrow.__texture then return end

		if arrow:IsEnabled() then
			arrow.__texture:SetVertexColor(1, 1, 1)
		else
			arrow.__texture:SetVertexColor(.5, .5, .5)
		end
	end
	local function updateTrimScrollArrow(self, atlas)
		local arrow = self.__owner
		if not arrow.__texture then return end

		if atlas == arrow.disabledTexture then
			arrow.__texture:SetVertexColor(.5, .5, .5)
		else
			arrow.__texture:SetVertexColor(1, 1, 1)
		end
	end

	local function reskinScrollArrow(self, direction, minimal)
		if not self then return end

		if self.Texture then
			self.Texture:SetAlpha(0)
			if self.Overlay then self.Overlay:SetAlpha(0) end
			if minimal then self:SetHeight(17) end
		else
			B.StripTextures(self)
		end

		local tex = self:CreateTexture(nil, "ARTWORK")
		tex:SetAllPoints()
		B.SetupArrow(tex, direction)
		self.__texture = tex

		self:HookScript("OnEnter", B.Texture_OnEnter)
		self:HookScript("OnLeave", B.Texture_OnLeave)

		if self.Texture then
			if minimal then return end
			self.Texture.__owner = self
			hooksecurefunc(self.Texture, "SetAtlas", updateTrimScrollArrow)
			updateTrimScrollArrow(self.Texture, self.Texture:GetAtlas())
		else
			hooksecurefunc(self, "Enable", updateScrollArrow)
			hooksecurefunc(self, "Disable", updateScrollArrow)
		end
	end

	function B:ReskinScroll()
		B.StripTextures(self:GetParent())
		B.StripTextures(self)

		local thumb = self:GetThumbTexture()
		if thumb then
			thumb:SetAlpha(0)
			thumb.bg = B.CreateBDFrame(thumb, .25)
			thumb.bg:SetBackdropColor(cr, cg, cb, .25)
			thumb.bg:SetPoint("TOPLEFT", thumb, 4, -1)
			thumb.bg:SetPoint("BOTTOMRIGHT", thumb, -4, 1)
			self.thumb = thumb

			self:HookScript("OnEnter", Thumb_OnEnter)
			self:HookScript("OnLeave", Thumb_OnLeave)
			self:HookScript("OnMouseDown", Thumb_OnMouseDown)
			self:HookScript("OnMouseUp", Thumb_OnMouseUp)
		end

		local up, down = self:GetChildren()
		reskinScrollArrow(up, "up")
		reskinScrollArrow(down, "down")
	end

	-- WowTrimScrollBar
	function B:ReskinTrimScroll()
		local minimal = self:GetWidth() < 10

		B.StripTextures(self)
		reskinScrollArrow(self.Back, "up", minimal)
		reskinScrollArrow(self.Forward, "down", minimal)
		if self.Track then
			self.Track:DisableDrawLayer("ARTWORK")
		end

		local thumb = self:GetThumb()
		if thumb then
			thumb:DisableDrawLayer("ARTWORK")
			thumb:DisableDrawLayer("BACKGROUND")
			thumb.bg = B.CreateBDFrame(thumb, .25)
			thumb.bg:SetBackdropColor(cr, cg, cb, .25)
			if not minimal then
				thumb.bg:SetPoint("TOPLEFT", 4, -1)
				thumb.bg:SetPoint("BOTTOMRIGHT", -4, 1)
			end

			thumb:HookScript("OnEnter", Thumb_OnEnter)
			thumb:HookScript("OnLeave", Thumb_OnLeave)
			thumb:HookScript("OnMouseDown", Thumb_OnMouseDown)
			thumb:HookScript("OnMouseUp", Thumb_OnMouseUp)
		end
	end

	-- Handle dropdown
	function B:ReskinDropDown()
		B.StripTextures(self)

		local frameName = self.GetName and self:GetName()
		local down = self.Button or frameName and (_G[frameName.."Button"] or _G[frameName.."_Button"])

		local bg = B.CreateBDFrame(self, 0, true)
		bg:SetPoint("TOPLEFT", 16, -4)
		bg:SetPoint("BOTTOMRIGHT", -18, 8)

		down:ClearAllPoints()
		down:SetPoint("RIGHT", bg, -2, 0)
		B.ReskinArrow(down, "down")
	end

	-- Handle close button
	function B:Texture_OnEnter()
		if self:IsEnabled() then
			if self.bg then
				self.bg:SetBackdropColor(cr, cg, cb, .25)
			else
				self.__texture:SetVertexColor(0, .6, 1)
			end
		end
	end

	function B:Texture_OnLeave()
		if self.bg then
			self.bg:SetBackdropColor(0, 0, 0, .25)
		else
			self.__texture:SetVertexColor(1, 1, 1)
		end
	end

	local function resetCloseButtonAnchor(button)
		if button.isSetting then return end
		button.isSetting = true
		button:ClearAllPoints()
		button:SetPoint("TOPRIGHT", button.__owner, "TOPRIGHT", button.__xOffset, button.__yOffset)
		button.isSetting = nil
	end
	function B:ReskinClose(parent, xOffset, yOffset, override)
		parent = parent or self:GetParent()
		xOffset = xOffset or -6
		yOffset = yOffset or -6

		self:SetSize(16, 16)
		if not override then
			self:ClearAllPoints()
			self:SetPoint("TOPRIGHT", parent, "TOPRIGHT", xOffset, yOffset)
			self.__owner = parent
			self.__xOffset = xOffset
			self.__yOffset = yOffset
			hooksecurefunc(self, "SetPoint", resetCloseButtonAnchor)
		end

		B.StripTextures(self)
		if self.Border then self.Border:SetAlpha(0) end
		local bg = B.CreateBDFrame(self, 0, true)
		bg:SetAllPoints()

		self:SetDisabledTexture(DB.bdTex)
		local dis = self:GetDisabledTexture()
		dis:SetVertexColor(0, 0, 0, .4)
		dis:SetDrawLayer("OVERLAY")
		dis:SetAllPoints()

		local tex = self:CreateTexture()
		tex:SetTexture(DB.closeTex)
		tex:SetAllPoints()
		self.__texture = tex

		self:HookScript("OnEnter", B.Texture_OnEnter)
		self:HookScript("OnLeave", B.Texture_OnLeave)
	end

	-- Handle editbox
	function B:ReskinEditBox(height, width)
		local frameName = self.GetName and self:GetName()
		for _, region in pairs(blizzRegions) do
			region = frameName and _G[frameName..region] or self[region]
			if region then
				region:SetAlpha(0)
			end
		end

		local bg = B.CreateBDFrame(self, 0, true)
		bg:SetPoint("TOPLEFT", -2, 0)
		bg:SetPoint("BOTTOMRIGHT")
		self.__bg = bg

		if height then self:SetHeight(height) end
		if width then self:SetWidth(width) end
	end
	B.ReskinInput = B.ReskinEditBox -- Deprecated

	-- Handle arrows
	local arrowDegree = {
		["up"] = 0,
		["down"] = 180,
		["left"] = 90,
		["right"] = -90,
	}
	function B:SetupArrow(direction)
		self:SetTexture(DB.ArrowUp)
		self:SetRotation(rad(arrowDegree[direction]))
	end

	function B:ReskinArrow(direction)
		self:SetSize(16, 16)
		B.Reskin(self, true)

		self:SetDisabledTexture(DB.bdTex)
		local dis = self:GetDisabledTexture()
		dis:SetVertexColor(0, 0, 0, .3)
		dis:SetDrawLayer("OVERLAY")
		dis:SetAllPoints()

		local tex = self:CreateTexture(nil, "ARTWORK")
		tex:SetAllPoints()
		B.SetupArrow(tex, direction)
		self.__texture = tex

		self:HookScript("OnEnter", B.Texture_OnEnter)
		self:HookScript("OnLeave", B.Texture_OnLeave)
	end

	function B:ReskinFilterReset()
		B.StripTextures(self)
		self:ClearAllPoints()
		self:SetPoint("TOPRIGHT", -5, 10)

		local tex = self:CreateTexture(nil, "ARTWORK")
		tex:SetInside(nil, 2, 2)
		tex:SetTexture(DB.closeTex)
		tex:SetVertexColor(1, 0, 0)
	end

	function B:ReskinFilterButton()
		B.StripTextures(self)
		B.Reskin(self)
		if self.Text then
			self.Text:SetPoint("CENTER")
		end
		if self.Icon then
			B.SetupArrow(self.Icon, "right")
			self.Icon:SetPoint("RIGHT")
			self.Icon:SetSize(14, 14)
		end
		if self.ResetButton then
			B.ReskinFilterReset(self.ResetButton)
		end
	end

	function B:ReskinNavBar()
		if self.navBarStyled then return end

		local homeButton = self.homeButton
		local overflowButton = self.overflowButton

		self:GetRegions():Hide()
		self:DisableDrawLayer("BORDER")
		self.overlay:Hide()
		homeButton:GetRegions():Hide()
		B.Reskin(homeButton)
		B.Reskin(overflowButton, true)

		local tex = overflowButton:CreateTexture(nil, "ARTWORK")
		B.SetupArrow(tex, "left")
		tex:SetSize(14, 14)
		tex:SetPoint("CENTER")
		overflowButton.__texture = tex

		overflowButton:HookScript("OnEnter", B.Texture_OnEnter)
		overflowButton:HookScript("OnLeave", B.Texture_OnLeave)

		self.navBarStyled = true
	end

	-- Handle checkbox and radio
	function B:ReskinCheck(forceSaturation)
		self:SetNormalTexture(0)
		self:SetPushedTexture(0)

		local bg = B.CreateBDFrame(self, 0, true)
		bg:SetInside(self, 4, 4)
		self.bg = bg

		self:SetHighlightTexture(DB.bdTex)
		local hl = self:GetHighlightTexture()
		hl:SetInside(bg)
		hl:SetVertexColor(cr, cg, cb, .25)

		local ch = self:GetCheckedTexture()
		ch:SetAtlas("checkmark-minimal")
		ch:SetDesaturated(true)
		ch:SetTexCoord(0, 1, 0, 1)
		ch:SetVertexColor(cr, cg, cb)

		self.forceSaturation = forceSaturation
	end

	function B:ReskinRadio()
		self:GetNormalTexture():SetAlpha(0)
		self:GetHighlightTexture():SetAlpha(0)
		self:SetCheckedTexture(DB.bdTex)

		local ch = self:GetCheckedTexture()
		ch:SetInside(self, 4, 4)
		ch:SetVertexColor(cr, cg, cb, .6)

		local bg = B.CreateBDFrame(self, 0, true)
		bg:SetInside(self, 3, 3)
		self.bg = bg

		self:HookScript("OnEnter", Menu_OnEnter)
		self:HookScript("OnLeave", Menu_OnLeave)
	end

	-- Color swatch
	function B:ReskinColorSwatch()
		local frameName = self.GetName and self:GetName()
		local swatchBg = frameName and _G[frameName.."SwatchBg"]
		if swatchBg then
			swatchBg:SetColorTexture(0, 0, 0)
			swatchBg:SetInside(nil, 2, 2)
		end

		self:SetNormalTexture(DB.bdTex)
		self:GetNormalTexture():SetInside(self, 3, 3)
	end

	-- Handle slider
	function B:ReskinSlider(vertical)
		B.StripTextures(self)

		local bg = B.CreateBDFrame(self, 0, true)
		bg:SetPoint("TOPLEFT", 14, -2)
		bg:SetPoint("BOTTOMRIGHT", -15, 3)

		local thumb = self:GetThumbTexture()
		thumb:SetTexture(DB.sparkTex)
		thumb:SetBlendMode("ADD")
		if vertical then thumb:SetRotation(rad(90)) end

		local bar = CreateFrame("StatusBar", nil, bg)
		bar:SetStatusBarTexture(DB.normTex)
		bar:SetStatusBarColor(1, .8, 0, .5)
		if vertical then
			bar:SetPoint("BOTTOMLEFT", bg, C.mult, C.mult)
			bar:SetPoint("BOTTOMRIGHT", bg, -C.mult, C.mult)
			bar:SetPoint("TOP", thumb, "CENTER")
			bar:SetOrientation("VERTICAL")
		else
			bar:SetPoint("TOPLEFT", bg, C.mult, -C.mult)
			bar:SetPoint("BOTTOMLEFT", bg, C.mult, C.mult)
			bar:SetPoint("RIGHT", thumb, "CENTER")
		end
	end

	local function reskinStepper(stepper, direction)
		B.StripTextures(stepper)
		stepper:SetWidth(19)

		local tex = stepper:CreateTexture(nil, "ARTWORK")
		tex:SetAllPoints()
		B.SetupArrow(tex, direction)
		stepper.__texture = tex

		stepper:HookScript("OnEnter", B.Texture_OnEnter)
		stepper:HookScript("OnLeave", B.Texture_OnLeave)
	end

	function B:ReskinStepperSlider(minimal)
		B.StripTextures(self)
		reskinStepper(self.Back, "left")
		reskinStepper(self.Forward, "right")
		self.Slider:DisableDrawLayer("ARTWORK")

		local thumb = self.Slider.Thumb
		thumb:SetTexture(DB.sparkTex)
		thumb:SetBlendMode("ADD")
		thumb:SetSize(20, 30)

		local bg = B.CreateBDFrame(self.Slider, 0, true)
		local offset = minimal and 10 or 13
		bg:SetPoint("TOPLEFT", 10, -offset)
		bg:SetPoint("BOTTOMRIGHT", -10, offset)
		local bar = CreateFrame("StatusBar", nil, bg)
		bar:SetStatusBarTexture(DB.normTex)
		bar:SetStatusBarColor(1, .8, 0, .5)
		bar:SetPoint("TOPLEFT", bg, C.mult, -C.mult)
		bar:SetPoint("BOTTOMLEFT", bg, C.mult, C.mult)
		bar:SetPoint("RIGHT", thumb, "CENTER")
	end

	-- Handle collapse
	local function updateCollapseTexture(texture, collapsed)
		local atlas = collapsed and "Soulbinds_Collection_CategoryHeader_Expand" or "Soulbinds_Collection_CategoryHeader_Collapse"
		texture:SetAtlas(atlas, true)
	end

	local function resetCollapseTexture(self, texture)
		if self.settingTexture then return end
		self.settingTexture = true
		self:SetNormalTexture(0)

		if texture and texture ~= "" then
			if strfind(texture, "Plus") or strfind(texture, "[Cc]losed") then
				self.__texture:DoCollapse(true)
			elseif strfind(texture, "Minus") or strfind(texture, "[Oo]pen") then
				self.__texture:DoCollapse(false)
			end
			self.bg:Show()
		else
			self.bg:Hide()
		end
		self.settingTexture = nil
	end

	function B:ReskinCollapse(isAtlas)
		self:SetNormalTexture(0)
		self:SetHighlightTexture(0)
		self:SetPushedTexture(0)

		local bg = B.CreateBDFrame(self, .25, true)
		bg:ClearAllPoints()
		bg:SetSize(13, 13)
		bg:SetPoint("TOPLEFT", self:GetNormalTexture())
		self.bg = bg

		self.__texture = bg:CreateTexture(nil, "OVERLAY")
		self.__texture:SetPoint("CENTER")
		self.__texture.DoCollapse = updateCollapseTexture

		self:HookScript("OnEnter", B.Texture_OnEnter)
		self:HookScript("OnLeave", B.Texture_OnLeave)
		if isAtlas then
			hooksecurefunc(self, "SetNormalAtlas", resetCollapseTexture)
		else
			hooksecurefunc(self, "SetNormalTexture", resetCollapseTexture)
		end
	end

	local buttonNames = {"MaximizeButton", "MinimizeButton"}
	function B:ReskinMinMax()
		for _, name in next, buttonNames do
			local button = self[name]
			if button then
				button:SetSize(16, 16)
				button:ClearAllPoints()
				button:SetPoint("CENTER", -3, 0)
				button:SetHitRectInsets(1, 1, 1, 1)
				B.Reskin(button)

				local tex = button:CreateTexture()
				tex:SetAllPoints()
				if name == "MaximizeButton" then
					B.SetupArrow(tex, "up")
				else
					B.SetupArrow(tex, "down")
				end
				button.__texture = tex

				button:SetScript("OnEnter", B.Texture_OnEnter)
				button:SetScript("OnLeave", B.Texture_OnLeave)
			end
		end
	end

	-- UI templates
	function B:ReskinPortraitFrame()
		B.StripTextures(self)
		local bg = B.SetBD(self)
		bg:SetAllPoints(self)
		local frameName = self.GetName and self:GetName()
		local portrait = self.PortraitTexture or self.portrait or (frameName and _G[frameName.."Portrait"])
		if portrait then
			portrait:SetAlpha(0)
		end
		local closeButton = self.CloseButton or (frameName and _G[frameName.."CloseButton"])
		if closeButton then
			B.ReskinClose(closeButton)
		end
		return bg
	end

	local ReplacedRoleTex = {
		["Adventures-Tank"] = "Soulbinds_Tree_Conduit_Icon_Protect",
		["Adventures-Healer"] = "ui_adv_health",
		["Adventures-DPS"] = "ui_adv_atk",
		["Adventures-DPS-Ranged"] = "Soulbinds_Tree_Conduit_Icon_Utility",
	}
	local function replaceFollowerRole(roleIcon, atlas)
		local newAtlas = ReplacedRoleTex[atlas]
		if newAtlas then
			roleIcon:SetAtlas(newAtlas)
		end
	end

	function B:ReskinGarrisonPortrait()
		local level = self.Level or self.LevelText
		if level then
			level:ClearAllPoints()
			level:SetPoint("BOTTOM", self, 0, 15)
			if self.LevelCircle then self.LevelCircle:Hide() end
			if self.LevelBorder then self.LevelBorder:SetScale(.0001) end
		end

		self.squareBG = B.CreateBDFrame(self.Portrait, 1)

		if self.PortraitRing then
			self.PortraitRing:Hide()
			self.PortraitRingQuality:SetTexture("")
			self.PortraitRingCover:SetColorTexture(0, 0, 0)
			self.PortraitRingCover:SetAllPoints(self.squareBG)
		end

		if self.Empty then
			self.Empty:SetColorTexture(0, 0, 0)
			self.Empty:SetAllPoints(self.Portrait)
		end
		if self.Highlight then self.Highlight:Hide() end
		if self.PuckBorder then self.PuckBorder:SetAlpha(0) end
		if self.TroopStackBorder1 then self.TroopStackBorder1:SetAlpha(0) end
		if self.TroopStackBorder2 then self.TroopStackBorder2:SetAlpha(0) end

		if self.HealthBar then
			self.HealthBar.Border:Hide()

			local roleIcon = self.HealthBar.RoleIcon
			roleIcon:ClearAllPoints()
			roleIcon:SetPoint("CENTER", self.squareBG, "TOPRIGHT", -2, -2)
			replaceFollowerRole(roleIcon, roleIcon:GetAtlas())
			hooksecurefunc(roleIcon, "SetAtlas", replaceFollowerRole)

			local background = self.HealthBar.Background
			background:SetAlpha(0)
			background:ClearAllPoints()
			background:SetPoint("TOPLEFT", self.squareBG, "BOTTOMLEFT", C.mult, 6)
			background:SetPoint("BOTTOMRIGHT", self.squareBG, "BOTTOMRIGHT", -C.mult, C.mult)
			self.HealthBar.Health:SetTexture(DB.normTex)
		end
	end

	function B:StyleSearchButton()
		B.StripTextures(self)
		local bg = B.CreateBDFrame(self, .25)
		bg:SetInside()
		local icon = self.icon or self.Icon
		if icon then
			B.ReskinIcon(icon)
		end

		self:SetHighlightTexture(DB.bdTex)
		local hl = self:GetHighlightTexture()
		hl:SetVertexColor(cr, cg, cb, .25)
		hl:SetInside(bg)
	end

	function B:AffixesSetup()
		for _, frame in ipairs(self.Affixes) do
			frame.Border:SetTexture(nil)
			frame.Portrait:SetTexture(nil)
			if not frame.bg then
				frame.bg = B.ReskinIcon(frame.Portrait)
			end

			if frame.info then
				frame.Portrait:SetTexture(CHALLENGE_MODE_EXTRA_AFFIX_INFO[frame.info.key].texture)
			elseif frame.affixID then
				local _, _, filedataid = C_ChallengeMode.GetAffixInfo(frame.affixID)
				frame.Portrait:SetTexture(filedataid)
			end
		end
	end

	-- Role Icons
	function B:GetRoleTexCoord()
		if self == "TANK" then
			return .34/9.03, 2.85/9.03, 3.16/9.03, 5.67/9.03
		elseif self == "DPS" or self == "DAMAGER" then
			return 3.27/9.03, 5.78/9.03, 3.16/9.03, 5.67/9.03
		elseif self == "HEALER" then
			return 3.27/9.03, 5.78/9.03, .27/9.03, 2.78/9.03
		elseif self == "LEADER" then
			return .34/9.03, 2.85/9.03, .27/9.03, 2.78/9.03
		elseif self == "READY" then
			return 6.17/9.03, 8.68/9.03, .27/9.03, 2.78/9.03
		elseif self == "PENDING" then
			return 6.17/9.03, 8.68/9.03, 3.16/9.03, 5.67/9.03
		elseif self == "REFUSE" then
			return 3.27/9.03, 5.78/9.03, 6.04/9.03, 8.55/9.03
		end
	end

	function B:GetRoleTex()
		if self == "TANK" then
			return DB.tankTex
		elseif self == "DPS" or self == "DAMAGER" then
			return DB.dpsTex
		elseif self == "HEALER" then
			return DB.healTex
		end
	end

	function B:ReskinSmallRole(role)
		self:SetTexture(B.GetRoleTex(role))
		self:SetTexCoord(0, 1, 0, 1)
	end

	function B:ReskinRole(role)
		if self.background then self.background:SetTexture("") end

		local cover = self.cover or self.Cover
		if cover then cover:SetTexture("") end

		local texture = self.GetNormalTexture and self:GetNormalTexture() or self.texture or self.Texture or (self.SetTexture and self) or self.Icon
		if texture then
			texture:SetTexture(DB.rolesTex)
			texture:SetTexCoord(B.GetRoleTexCoord(role))
		end
		self.bg = B.CreateBDFrame(self)

		local checkButton = self.checkButton or self.CheckButton or self.CheckBox
		if checkButton then
			checkButton:SetFrameLevel(self:GetFrameLevel() + 2)
			checkButton:SetPoint("BOTTOMLEFT", -2, -2)
			B.ReskinCheck(checkButton)
		end

		local shortageBorder = self.shortageBorder
		if shortageBorder then
			shortageBorder:SetTexture("")
			local icon = self.incentiveIcon
			icon:SetPoint("BOTTOMRIGHT")
			icon:SetSize(14, 14)
			icon.texture:SetSize(14, 14)
			B.ReskinIcon(icon.texture)
			icon.border:SetTexture("")
		end
	end
end

-- Add API
do
	local function WatchPixelSnap(frame, snap)
		if (frame and not frame:IsForbidden()) and frame.PixelSnapDisabled and snap then
			frame.PixelSnapDisabled = nil
		end
	end

	local function DisablePixelSnap(frame)
		if (frame and not frame:IsForbidden()) and not frame.PixelSnapDisabled then
			if frame.SetSnapToPixelGrid then
				frame:SetSnapToPixelGrid(false)
				frame:SetTexelSnappingBias(0)
			elseif frame.GetStatusBarTexture then
				local texture = frame:GetStatusBarTexture()
				if texture and texture.SetSnapToPixelGrid then
					texture:SetSnapToPixelGrid(false)
					texture:SetTexelSnappingBias(0)
				end
			end

			frame.PixelSnapDisabled = true
		end
	end

	local function SetInside(frame, anchor, xOffset, yOffset, anchor2)
		xOffset = xOffset or C.mult
		yOffset = yOffset or C.mult
		anchor = anchor or frame:GetParent()

		DisablePixelSnap(frame)
		frame:ClearAllPoints()
		frame:SetPoint("TOPLEFT", anchor, "TOPLEFT", xOffset, -yOffset)
		frame:SetPoint("BOTTOMRIGHT", anchor2 or anchor, "BOTTOMRIGHT", -xOffset, yOffset)
	end

	local function SetOutside(frame, anchor, xOffset, yOffset, anchor2)
		xOffset = xOffset or C.mult
		yOffset = yOffset or C.mult
		anchor = anchor or frame:GetParent()

		DisablePixelSnap(frame)
		frame:ClearAllPoints()
		frame:SetPoint("TOPLEFT", anchor, "TOPLEFT", -xOffset, yOffset)
		frame:SetPoint("BOTTOMRIGHT", anchor2 or anchor, "BOTTOMRIGHT", xOffset, -yOffset)
	end

	local function HideBackdrop(frame)
		if frame.NineSlice then frame.NineSlice:SetAlpha(0) end
		if frame.SetBackdrop then frame:SetBackdrop(nil) end
	end

	local function addapi(object)
		local mt = getmetatable(object).__index
		if not object.SetInside then mt.SetInside = SetInside end
		if not object.SetOutside then mt.SetOutside = SetOutside end
		if not object.HideBackdrop then mt.HideBackdrop = HideBackdrop end
		if not object.DisabledPixelSnap then
			if mt.SetTexture then hooksecurefunc(mt, "SetTexture", DisablePixelSnap) end
			if mt.SetTexCoord then hooksecurefunc(mt, "SetTexCoord", DisablePixelSnap) end
			if mt.CreateTexture then hooksecurefunc(mt, "CreateTexture", DisablePixelSnap) end
			if mt.SetVertexColor then hooksecurefunc(mt, "SetVertexColor", DisablePixelSnap) end
			if mt.SetColorTexture then hooksecurefunc(mt, "SetColorTexture", DisablePixelSnap) end
			if mt.SetSnapToPixelGrid then hooksecurefunc(mt, "SetSnapToPixelGrid", WatchPixelSnap) end
			if mt.SetStatusBarTexture then hooksecurefunc(mt, "SetStatusBarTexture", DisablePixelSnap) end
			mt.DisabledPixelSnap = true
		end
	end

	local handled = {["Frame"] = true}
	local object = CreateFrame("Frame")
	addapi(object)
	addapi(object:CreateTexture())
	addapi(object:CreateMaskTexture())

	object = EnumerateFrames()
	while object do
		if not object:IsForbidden() and not handled[object:GetObjectType()] then
			addapi(object)
			handled[object:GetObjectType()] = true
		end

		object = EnumerateFrames(object)
	end
end