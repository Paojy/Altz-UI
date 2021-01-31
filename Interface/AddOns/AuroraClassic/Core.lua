local _, ns = ...
local F, C, L = unpack(ns)
local cr, cg, cb = C.r, C.g, C.b

-- Kill regions
do
	function F:Dummy()
		return
	end

	F.HiddenFrame = CreateFrame("Frame")
	F.HiddenFrame:Hide()

	function F:HideObject()
		if self.UnregisterAllEvents then
			self:UnregisterAllEvents()
			self:SetParent(F.HiddenFrame)
		else
			self.Show = self.Hide
		end
		self:Hide()
	end

	function F:HideOption()
		self:SetAlpha(0)
		self:SetScale(.0001)
	end

	local blizzTextures = {
		"Inset",
		"inset",
		"InsetFrame",
		"LeftInset",
		"RightInset",
		"NineSlice",
		"BG",
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
	function F:StripTextures(kill)
		local frameName = self.GetName and self:GetName()
		for _, texture in pairs(blizzTextures) do
			local blizzFrame = self[texture] or (frameName and _G[frameName..texture])
			if blizzFrame then
				F.StripTextures(blizzFrame, kill)
			end
		end

		if self.GetNumRegions then
			for i = 1, self:GetNumRegions() do
				local region = select(i, self:GetRegions())
				if region and region.IsObjectType and region:IsObjectType("Texture") then
					if kill and type(kill) == "boolean" then
						F.HideObject(region)
					elseif tonumber(kill) then
						if kill == 0 then
							region:SetAlpha(0)
						elseif i ~= kill then
							region:SetTexture("")
						end
					else
						region:SetTexture("")
					end
				end
			end
		end
	end
end

-- UI widgets
do
	function F:CreateTex()
		if self.__bgTex then return end

		local frame = self
		if self:IsObjectType("Texture") then frame = self:GetParent() end

		local tex = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
		tex:SetAllPoints(self)
		tex:SetTexture(C.bgTex, true, true)
		tex:SetHorizTile(true)
		tex:SetVertTile(true)
		tex:SetBlendMode("ADD")

		self.__bgTex = tex
	end

	local shadowBackdrop = {edgeFile = C.glowTex}
	function F:CreateSD()
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
	local defaultBackdrop = {bgFile = C.bdTex, edgeFile = C.bdTex}

	function F:CreateBD(a)
		defaultBackdrop.edgeSize = C.mult
		self:SetBackdrop(defaultBackdrop)
		self:SetBackdropColor(0, 0, 0, a or AuroraClassicDB.Alpha)
		self:SetBackdropBorderColor(0, 0, 0)
		if not a then tinsert(C.frames, self) end
	end

	function F:CreateGradient()
		local tex = self:CreateTexture(nil, "BORDER")
		tex:SetInside()
		tex:SetTexture(C.bdTex)
		if AuroraClassicDB.FlatMode then
			tex:SetVertexColor(.3, .3, .3, .25)
		else
			tex:SetGradientAlpha("Vertical", 0, 0, 0, .5, .3, .3, .3, .3)
		end

		return tex
	end

	-- Handle frame
	function F:CreateBDFrame(a, gradient)
		local frame = self
		if self:IsObjectType("Texture") then frame = self:GetParent() end
		local lvl = frame:GetFrameLevel()

		local bg = CreateFrame("Frame", nil, frame, "BackdropTemplate")
		bg:SetOutside(self)
		bg:SetFrameLevel(lvl == 0 and 0 or lvl - 1)
		F.CreateBD(bg, a)
		if gradient then
			self.__gradient = F.CreateGradient(bg)
		end

		return bg
	end

	function F:SetBD(a, x, y, x2, y2)
		local bg = F.CreateBDFrame(self, a)
		if x then
			bg:SetPoint("TOPLEFT", self, x, y)
			bg:SetPoint("BOTTOMRIGHT", self, x2, y2)
		end
		F.CreateSD(bg)
		F.CreateTex(bg)

		return bg
	end

	-- Handle icons
	function F:ReskinIcon(shadow)
		self:SetTexCoord(unpack(C.TexCoord))
		local bg = F.CreateBDFrame(self)
		if shadow then F.CreateSD(bg) end
		return bg
	end

	local AtlasToQuality = {
		["auctionhouse-itemicon-border-gray"] = LE_ITEM_QUALITY_POOR,
		["auctionhouse-itemicon-border-white"] = LE_ITEM_QUALITY_COMMON,
		["auctionhouse-itemicon-border-green"] = LE_ITEM_QUALITY_UNCOMMON,
		["auctionhouse-itemicon-border-blue"] = LE_ITEM_QUALITY_RARE,
		["auctionhouse-itemicon-border-purple"] = LE_ITEM_QUALITY_EPIC,
		["auctionhouse-itemicon-border-orange"] = LE_ITEM_QUALITY_LEGENDARY,
		["auctionhouse-itemicon-border-artifact"] = LE_ITEM_QUALITY_ARTIFACT,
		["auctionhouse-itemicon-border-account"] = LE_ITEM_QUALITY_HEIRLOOM,
	}
	local function updateIconBorderColorByAtlas(self, atlas)
		local quality = AtlasToQuality[atlas]
		local color = C.QualityColors[quality or 1]
		self.__owner.bg:SetBackdropBorderColor(color.r, color.g, color.b)
	end
	local function updateIconBorderColor(self, r, g, b)
		if not r or (r==.65882 and g==.65882 and b==.65882) or (r>.99 and g>.99 and b>.99) then
			r, g, b = 0, 0, 0
		end
		self.__owner.bg:SetBackdropBorderColor(r, g, b)
	end
	local function resetIconBorderColor(self)
		self.__owner.bg:SetBackdropBorderColor(0, 0, 0)
	end
	function F:ReskinIconBorder(needInit)
		self:SetAlpha(0)
		self.__owner = self:GetParent()
		if not self.__owner.bg then return end
		if self.__owner.useCircularIconBorder then -- for auction item display
			hooksecurefunc(self, "SetAtlas", updateIconBorderColorByAtlas)
		else
			hooksecurefunc(self, "SetVertexColor", updateIconBorderColor)
			if needInit then
				self:SetVertexColor(self:GetVertexColor()) -- for border with color before hook
			end
		end
		hooksecurefunc(self, "Hide", resetIconBorderColor)
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
	function F:Reskin(noHighlight, override)
		if self.SetNormalTexture and not override then self:SetNormalTexture("") end
		if self.SetHighlightTexture then self:SetHighlightTexture("") end
		if self.SetPushedTexture then self:SetPushedTexture("") end
		if self.SetDisabledTexture then self:SetDisabledTexture("") end

		local buttonName = self.GetName and self:GetName()
		for _, region in pairs(blizzRegions) do
			region = buttonName and _G[buttonName..region] or self[region]
			if region then
				region:SetAlpha(0)
			end
		end

		self.__bg = F.CreateBDFrame(self, 0, true)
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

	function F:ReskinMenuButton()
		F.StripTextures(self)
		self.bg = F.SetBD(self)
		self:SetScript("OnEnter", Menu_OnEnter)
		self:SetScript("OnLeave", Menu_OnLeave)
		self:HookScript("OnMouseUp", Menu_OnMouseUp)
		self:HookScript("OnMouseDown", Menu_OnMouseDown)
	end

	-- Handle tabs
	function F:ReskinTab()
		self:DisableDrawLayer("BACKGROUND")

		local bg = F.CreateBDFrame(self)
		bg:SetPoint("TOPLEFT", 8, -3)
		bg:SetPoint("BOTTOMRIGHT", -8, 0)
		self.bg = bg

		self:SetHighlightTexture(C.bdTex)
		local hl = self:GetHighlightTexture()
		hl:ClearAllPoints()
		hl:SetInside(bg)
		hl:SetVertexColor(cr, cg, cb, .25)
	end

	function F:ResetTabAnchor()
		local text = self.Text or (self.GetName and _G[self:GetName().."Text"])
		if text then
			text:SetPoint("CENTER", self)
		end
	end
	hooksecurefunc("PanelTemplates_SelectTab", F.ResetTabAnchor)
	hooksecurefunc("PanelTemplates_DeselectTab", F.ResetTabAnchor)

	-- Handle scrollframe
	local function Scroll_OnEnter(self)
		local thumb = self.thumb
		if not thumb then return end
		thumb.bg:SetBackdropColor(cr, cg, cb, .25)
		thumb.bg:SetBackdropBorderColor(cr, cg, cb)
	end

	local function Scroll_OnLeave(self)
		local thumb = self.thumb
		if not thumb then return end
		thumb.bg:SetBackdropColor(0, 0, 0, 0)
		thumb.bg:SetBackdropBorderColor(0, 0, 0)
	end

	local function GrabScrollBarElement(frame, element)
		local frameName = frame:GetDebugName()
		return frame[element] or frameName and (_G[frameName..element] or strfind(frameName, element)) or nil
	end

	function F:ReskinScroll()
		F.StripTextures(self:GetParent())
		F.StripTextures(self)

		local thumb = GrabScrollBarElement(self, "ThumbTexture") or GrabScrollBarElement(self, "thumbTexture") or self.GetThumbTexture and self:GetThumbTexture()
		if thumb then
			thumb:SetAlpha(0)
			thumb:SetWidth(16)
			self.thumb = thumb

			local bg = F.CreateBDFrame(self, 0, true)
			bg:SetPoint("TOPLEFT", thumb, 0, -2)
			bg:SetPoint("BOTTOMRIGHT", thumb, 0, 4)
			thumb.bg = bg
		end

		local up, down = self:GetChildren()
		F.ReskinArrow(up, "up")
		F.ReskinArrow(down, "down")

		self:HookScript("OnEnter", Scroll_OnEnter)
		self:HookScript("OnLeave", Scroll_OnLeave)
	end

	-- Handle dropdown
	function F:ReskinDropDown()
		F.StripTextures(self)

		local frameName = self.GetName and self:GetName()
		local down = self.Button or frameName and (_G[frameName.."Button"] or _G[frameName.."_Button"])

		local bg = F.CreateBDFrame(self, 0, true)
		bg:SetPoint("TOPLEFT", 16, -4)
		bg:SetPoint("BOTTOMRIGHT", -18, 8)

		down:ClearAllPoints()
		down:SetPoint("RIGHT", bg, -2, 0)
		F.ReskinArrow(down, "down")
	end

	-- Handle close button
	function F:Texture_OnEnter()
		if self:IsEnabled() then
			if self.bg then
				self.bg:SetBackdropColor(cr, cg, cb, .25)
			else
				self.__texture:SetVertexColor(cr, cg, cb)
			end
		end
	end

	function F:Texture_OnLeave()
		if self.bg then
			self.bg:SetBackdropColor(0, 0, 0, .25)
		else
			self.__texture:SetVertexColor(1, 1, 1)
		end
	end

	function F:ReskinClose(parent, xOffset, yOffset)
		parent = parent or self:GetParent()
		xOffset = xOffset or -6
		yOffset = yOffset or -6

		self:SetSize(16, 16)
		self:ClearAllPoints()
		self:SetPoint("TOPRIGHT", parent, "TOPRIGHT", xOffset, yOffset)

		F.StripTextures(self)
		local bg = F.CreateBDFrame(self, 0, true)
		bg:SetAllPoints()

		self:SetDisabledTexture(C.bdTex)
		local dis = self:GetDisabledTexture()
		dis:SetVertexColor(0, 0, 0, .4)
		dis:SetDrawLayer("OVERLAY")
		dis:SetAllPoints()

		local tex = self:CreateTexture()
		tex:SetTexture(C.closeTex)
		tex:SetAllPoints()
		self.__texture = tex

		self:HookScript("OnEnter", F.Texture_OnEnter)
		self:HookScript("OnLeave", F.Texture_OnLeave)
	end

	-- Handle editbox
	function F:ReskinEditBox(height, width)
		local frameName = self.GetName and self:GetName()
		for _, region in pairs(blizzRegions) do
			region = frameName and _G[frameName..region] or self[region]
			if region then
				region:SetAlpha(0)
			end
		end

		local bg = F.CreateBDFrame(self, 0, true)
		bg:SetPoint("TOPLEFT", -2, 0)
		bg:SetPoint("BOTTOMRIGHT")

		if height then self:SetHeight(height) end
		if width then self:SetWidth(width) end
	end
	F.ReskinInput = F.ReskinEditBox -- Deprecated

	-- Handle arrows
	local arrowDegree = {
		["up"] = 0,
		["down"] = 180,
		["left"] = 90,
		["right"] = -90,
	}
	function F:SetupArrow(direction)
		self:SetTexture(C.ArrowUp)
		self:SetRotation(rad(arrowDegree[direction]))
	end

	function F:ReskinArrow(direction)
		self:SetSize(16, 16)
		F.Reskin(self, true)

		self:SetDisabledTexture(C.bdTex)
		local dis = self:GetDisabledTexture()
		dis:SetVertexColor(0, 0, 0, .3)
		dis:SetDrawLayer("OVERLAY")
		dis:SetAllPoints()

		local tex = self:CreateTexture(nil, "ARTWORK")
		tex:SetAllPoints()
		F.SetupArrow(tex, direction)
		self.__texture = tex

		self:HookScript("OnEnter", F.Texture_OnEnter)
		self:HookScript("OnLeave", F.Texture_OnLeave)
	end

	function F:ReskinFilterButton()
		F.StripTextures(self)
		F.Reskin(self)
		self.Text:SetPoint("CENTER")
		F.SetupArrow(self.Icon, "right")
		self.Icon:SetPoint("RIGHT")
		self.Icon:SetSize(14, 14)
	end

	function F:ReskinNavBar()
		if self.navBarStyled then return end

		local homeButton = self.homeButton
		local overflowButton = self.overflowButton

		self:GetRegions():Hide()
		self:DisableDrawLayer("BORDER")
		self.overlay:Hide()
		homeButton:GetRegions():Hide()
		F.Reskin(homeButton)
		F.Reskin(overflowButton, true)

		local tex = overflowButton:CreateTexture(nil, "ARTWORK")
		F.SetupArrow(tex, "left")
		tex:SetSize(14, 14)
		tex:SetPoint("CENTER")
		overflowButton.__texture = tex

		overflowButton:HookScript("OnEnter", F.Texture_OnEnter)
		overflowButton:HookScript("OnLeave", F.Texture_OnLeave)

		self.navBarStyled = true
	end

	-- Handle checkbox and radio
	function F:ReskinCheck(forceSaturation)
		self:SetNormalTexture("")
		self:SetPushedTexture("")

		local bg = F.CreateBDFrame(self, 0, true)
		bg:SetInside(self, 4, 4)
		self.bg = bg

		self:SetHighlightTexture(C.bdTex)
		local hl = self:GetHighlightTexture()
		hl:SetInside(bg)
		hl:SetVertexColor(cr, cg, cb, .25)

		local ch = self:GetCheckedTexture()
		ch:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
		ch:SetTexCoord(0, 1, 0, 1)
		ch:SetDesaturated(true)
		ch:SetVertexColor(cr, cg, cb)

		self.forceSaturation = forceSaturation
	end

	function F:ReskinRadio()
		self:SetNormalTexture("")
		self:SetHighlightTexture("")
		self:SetCheckedTexture(C.bdTex)

		local ch = self:GetCheckedTexture()
		ch:SetInside(self, 4, 4)
		ch:SetVertexColor(cr, cg, cb, .6)

		local bg = F.CreateBDFrame(self, 0, true)
		bg:SetInside(self, 3, 3)
		self.bg = bg

		self:HookScript("OnEnter", Menu_OnEnter)
		self:HookScript("OnLeave", Menu_OnLeave)
	end

	-- Color swatch
	function F:ReskinColorSwatch()
		local frameName = self.GetName and self:GetName()
		local swatchBg = frameName and _G[frameName.."SwatchBg"]
		if swatchBg then
			swatchBg:SetColorTexture(0, 0, 0)
			swatchBg:SetInside(nil, 2, 2)
		end

		self:SetNormalTexture(C.bdTex)
		self:GetNormalTexture():SetInside(self, 3, 3)
	end

	-- Handle slider
	function F:ReskinSlider(vertical)
		self:SetBackdrop(nil)
		F.StripTextures(self)

		local bg = F.CreateBDFrame(self, 0, true)
		bg:SetPoint("TOPLEFT", 14, -2)
		bg:SetPoint("BOTTOMRIGHT", -15, 3)

		local thumb = self:GetThumbTexture()
		thumb:SetTexture(C.sparkTex)
		thumb:SetBlendMode("ADD")
		if vertical then thumb:SetRotation(rad(90)) end
	end

	-- Handle collapse
	local function updateCollapseTexture(texture, collapsed)
		local atlas = collapsed and "Soulbinds_Collection_CategoryHeader_Expand" or "Soulbinds_Collection_CategoryHeader_Collapse"
		texture:SetAtlas(atlas, true)
	end

	local function resetCollapseTexture(self, texture)
		if self.settingTexture then return end
		self.settingTexture = true
		self:SetNormalTexture("")

		if texture and texture ~= "" then
			if strfind(texture, "Plus") or strfind(texture, "Closed") then
				self.__texture:DoCollapse(true)
			elseif strfind(texture, "Minus") or strfind(texture, "Open") then
				self.__texture:DoCollapse(false)
			end
			self.bg:Show()
		else
			self.bg:Hide()
		end
		self.settingTexture = nil
	end

	function F:ReskinCollapse(isAtlas)
		self:SetHighlightTexture("")
		self:SetPushedTexture("")

		local bg = F.CreateBDFrame(self, .25, true)
		bg:ClearAllPoints()
		bg:SetSize(13, 13)
		bg:SetPoint("TOPLEFT", self:GetNormalTexture())
		self.bg = bg

		self.__texture = bg:CreateTexture(nil, "OVERLAY")
		self.__texture:SetPoint("CENTER")
		self.__texture.DoCollapse = updateCollapseTexture

		self:HookScript("OnEnter", F.Texture_OnEnter)
		self:HookScript("OnLeave", F.Texture_OnLeave)
		if isAtlas then
			hooksecurefunc(self, "SetNormalAtlas", resetCollapseTexture)
		else
			hooksecurefunc(self, "SetNormalTexture", resetCollapseTexture)
		end
	end

	local buttonNames = {"MaximizeButton", "MinimizeButton"}
	function F:ReskinMinMax()
		for _, name in next, buttonNames do
			local button = self[name]
			if button then
				button:SetSize(16, 16)
				button:ClearAllPoints()
				button:SetPoint("CENTER", -3, 0)
				F.Reskin(button)

				local tex = button:CreateTexture()
				tex:SetAllPoints()
				if name == "MaximizeButton" then
					F.SetupArrow(tex, "up")
				else
					F.SetupArrow(tex, "down")
				end
				button.__texture = tex

				button:SetScript("OnEnter", F.Texture_OnEnter)
				button:SetScript("OnLeave", F.Texture_OnLeave)
			end
		end
	end

	-- UI templates
	function F:ReskinPortraitFrame()
		F.StripTextures(self)
		local bg = F.SetBD(self)
		local frameName = self.GetName and self:GetName()
		local portrait = self.PortraitTexture or self.portrait or (frameName and _G[frameName.."Portrait"])
		if portrait then
			portrait:SetAlpha(0)
		end
		local closeButton = self.CloseButton or (frameName and _G[frameName.."CloseButton"])
		if closeButton then
			F.ReskinClose(closeButton)
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

	function F:ReskinGarrisonPortrait()
		local level = self.Level or self.LevelText
		if level then
			level:ClearAllPoints()
			level:SetPoint("BOTTOM", self, 0, 12)
			if self.LevelCircle then self.LevelCircle:Hide() end
			if self.LevelBorder then self.LevelBorder:SetScale(.0001) end
		end

		self.squareBG = F.CreateBDFrame(self.Portrait, 1)

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

		if self.HealthBar then
			self.HealthBar.Border:Hide()

			local roleIcon = self.HealthBar.RoleIcon
			roleIcon:ClearAllPoints()
			roleIcon:SetPoint("CENTER", self.squareBG, "TOPRIGHT")
			replaceFollowerRole(roleIcon, roleIcon:GetAtlas())
			hooksecurefunc(roleIcon, "SetAtlas", replaceFollowerRole)

			local background = self.HealthBar.Background
			background:SetAlpha(0)
			background:ClearAllPoints()
			background:SetPoint("TOPLEFT", self.squareBG, "BOTTOMLEFT", C.mult, 6)
			background:SetPoint("BOTTOMRIGHT", self.squareBG, "BOTTOMRIGHT", -C.mult, C.mult)
			self.HealthBar.Health:SetTexture(C.normTex)
		end
	end

	function F:StyleSearchButton()
		F.StripTextures(self)
		if self.icon then F.ReskinIcon(self.icon) end
		F.CreateBDFrame(self, .25)

		self:SetHighlightTexture(C.bdTex)
		local hl = self:GetHighlightTexture()
		hl:SetVertexColor(cr, cg, cb, .25)
		hl:SetInside()
	end

	function F:AffixesSetup()
		for _, frame in ipairs(self.Affixes) do
			frame.Border:SetTexture(nil)
			frame.Portrait:SetTexture(nil)
			if not frame.bg then
				frame.bg = F.ReskinIcon(frame.Portrait)
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
	function F:GetRoleTexCoord()
		if self == "TANK" then
			return .34/9.03, 2.86/9.03, 3.16/9.03, 5.68/9.03
		elseif self == "DPS" or self == "DAMAGER" then
			return 3.26/9.03, 5.78/9.03, 3.16/9.03, 5.68/9.03
		elseif self == "HEALER" then
			return 3.26/9.03, 5.78/9.03, .28/9.03, 2.78/9.03
		elseif self == "LEADER" then
			return .34/9.03, 2.86/9.03, .28/9.03, 2.78/9.03
		elseif self == "READY" then
			return 6.17/9.03, 8.75/9.03, .28/9.03, 2.78/9.03
		elseif self == "PENDING" then
			return 6.17/9.03, 8.75/9.03, 3.16/9.03, 5.68/9.03
		elseif self == "REFUSE" then
			return 3.26/9.03, 5.78/9.03, 6.03/9.03, 8.61/9.03
		end
	end

	function F:ReskinRole(role)
		if self.background then self.background:SetTexture("") end
		local cover = self.cover or self.Cover
		if cover then cover:SetTexture("") end
		local texture = self.GetNormalTexture and self:GetNormalTexture() or self.texture or self.Texture or (self.SetTexture and self) or self.Icon
		if texture then
			texture:SetTexture(C.rolesTex)
			texture:SetTexCoord(F.GetRoleTexCoord(role))
		end
		self.bg = F.CreateBDFrame(self)

		local checkButton = self.checkButton or self.CheckButton or self.CheckBox
		if checkButton then
			checkButton:SetFrameLevel(self:GetFrameLevel() + 2)
			checkButton:SetPoint("BOTTOMLEFT", -2, -2)
			F.ReskinCheck(checkButton)
		end

		local shortageBorder = self.shortageBorder
		if shortageBorder then
			shortageBorder:SetTexture("")
			local icon = self.incentiveIcon
			icon:SetPoint("BOTTOMRIGHT")
			icon:SetSize(14, 14)
			icon.texture:SetSize(14, 14)
			F.ReskinIcon(icon.texture)
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

	local function addapi(object)
		local mt = getmetatable(object).__index
		if not object.SetInside then mt.SetInside = SetInside end
		if not object.SetOutside then mt.SetOutside = SetOutside end
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