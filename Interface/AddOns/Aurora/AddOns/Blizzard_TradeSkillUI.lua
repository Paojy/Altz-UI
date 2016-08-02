local F, C = unpack(select(2, ...))


local function colourScroll(f)
	if f:IsEnabled() then
		f.tex:SetVertexColor(r, g, b)
	end
end

local function clearScroll(f)
	f.tex:SetVertexColor(1, 1, 1)
end

local function SkinScrollBar(f)
	for k, v in pairs{f:GetChildren()} do
		v:SetWidth(17)
		F.Reskin(v, true)
		
		v:SetDisabledTexture(C.media.backdrop)
		local dis = v:GetDisabledTexture()
		dis:SetVertexColor(0, 0, 0, .4)
		dis:SetDrawLayer("OVERLAY")

		v.tex = v:CreateTexture(nil, "ARTWORK")
		v.tex:SetSize(8, 8)
		v.tex:SetPoint("CENTER")
		v.tex:SetVertexColor(1, 1, 1)
		
		v:HookScript("OnEnter", colourScroll)
		v:HookScript("OnLeave", clearScroll)
			
		if v:GetName() == "TradeSkillFrameScrollUpButton" then
			v.tex:SetTexture(C.media.arrowUp)
		else
			v.tex:SetTexture(C.media.arrowDown)
		end
	end
	
	for k, bu in pairs{f:GetRegions()} do
		if bu:GetName() == "TradeSkillFrameThumbTexture" then
			bu:SetAlpha(0)
			bu:SetWidth(17)

			bu.bg = CreateFrame("Frame", nil, f)
			bu.bg:SetPoint("TOPLEFT", bu, 0, -2)
			bu.bg:SetPoint("BOTTOMRIGHT", bu, 0, 4)
			F.CreateBD(bu.bg, 0)
			
			local tex = F.CreateGradient(f)
			tex:SetPoint("TOPLEFT", bu.bg, 1, -1)
			tex:SetPoint("BOTTOMRIGHT", bu.bg, -1, 1)
		else
			 bu:Hide()
		end
	end
end

C.themes["Blizzard_TradeSkillUI"] = function()
	F.ReskinPortraitFrame(TradeSkillFrame, false)
	TradeSkillFramePortrait:Hide()
	TradeSkillFramePortrait.Show = F.dummy
	TradeSkillFramePortraitFrame:Hide()
	TradeSkillFramePortraitFrame.Show = F.dummy

	F.Reskin(TradeSkillFrame.DetailsFrame.CreateButton)
	F.Reskin(TradeSkillFrame.DetailsFrame.CreateAllButton)
	F.Reskin(TradeSkillFrame.DetailsFrame.ExitButton)
	F.ReskinFilterButton(TradeSkillFrame.FilterButton)

	TradeSkillFrame.RankFrame:SetStatusBarTexture(C.media.backdrop)
	TradeSkillFrame.RankFrame.SetStatusBarColor = F.dummy
	TradeSkillFrame.RankFrame:GetStatusBarTexture():SetGradient("VERTICAL", .1, .3, .9, .2, .4, 1)
	TradeSkillFrame.RankFrame.BorderLeft:Hide()
	TradeSkillFrame.RankFrame.BorderRight:Hide()
	TradeSkillFrame.RankFrame.BorderMid:Hide()
	
	local bg = CreateFrame("Frame", nil, TradeSkillFrame.RankFrame)
	bg:SetPoint("TOPLEFT", -1, 1)
	bg:SetPoint("BOTTOMRIGHT", 1, -1)
	bg:SetFrameLevel(TradeSkillFrame.RankFrame:GetFrameLevel()-1)
	F.CreateBD(bg, .25)

	for i = 1, 8 do
		local bu = TradeSkillFrame.DetailsFrame.Contents["Reagent"..i]
		local ic = bu.Icon
		ic:SetTexCoord(.08, .92, .08, .92)
		ic:SetDrawLayer("ARTWORK")
		F.CreateBG(ic)
		
		bu.NameFrame:SetAlpha(0)

		local bd = CreateFrame("Frame", nil, bu)
		bd:SetPoint("TOPLEFT", 39, -1)
		bd:SetPoint("BOTTOMRIGHT", 0, 1)
		bd:SetFrameLevel(0)
		F.CreateBD(bd, .25)

		bu.Name:SetParent(bd)
	end
	
	TradeSkillFrame.DetailsFrame:SetScript("OnUpdate", function(self)
		if self.pendingRefresh then
			self:RefreshDisplay();
			self.pendingRefresh = false;
		
			local ic = TradeSkillFrame.DetailsFrame.Contents.ResultIcon:GetNormalTexture()
			if ic then
				ic:SetTexCoord(.08, .92, .08, .92)
				ic:SetPoint("TOPLEFT", 1, -1)
				ic:SetPoint("BOTTOMRIGHT", -1, 1)
			end
		end
	end)
	
	F.CreateBD(TradeSkillFrame.DetailsFrame.Contents.ResultIcon)
	TradeSkillFrame.DetailsFrame.Contents.ResultIcon.Background:Hide()
	
	local r, g, b = C.r, C.g, C.b
	
	local function onEnable(self)
		self:SetHeight(self.storedHeight) -- prevent it from resizing
		self:SetBackdropColor(0, 0, 0, 0)
	end

	local function onDisable(self)
		self:SetBackdropColor(r, g, b, .2)
	end

	local function onClick(self)
		self:GetFontString():SetTextColor(1, 1, 1)
	end
	
	for _, tab in pairs({TradeSkillFrame.RecipeList.LearnedTab, TradeSkillFrame.RecipeList.UnlearnedTab}) do
		tab.LeftDisabled:SetAlpha(0)
		tab.MiddleDisabled:SetAlpha(0)
		tab.RightDisabled:SetAlpha(0)

		tab.Left:SetAlpha(0)
		tab.Middle:SetAlpha(0)
		tab.Right:SetAlpha(0)

		tab.Text:SetPoint("CENTER")
		tab.Text:SetTextColor(1, 1, 1)

		tab:HookScript("OnEnable", onEnable)
		tab:HookScript("OnDisable", onDisable)
		tab:HookScript("OnClick", onClick)
		
		tab:SetHeight(25)
		tab.SetHeight = function() end

		F.Reskin(tab)
	end
	
	TradeSkillFrame.RecipeList.LearnedTab:SetBackdropColor(r, g, b, .2)
	
	TradeSkillFrame.DetailsFrame.Background:SetAlpha(0)
	TradeSkillFrame.RecipeInset:Hide()
	TradeSkillFrame.DetailsInset:Hide()
	
	SkinScrollBar(TradeSkillFrame.RecipeList.scrollBar)
	SkinScrollBar(TradeSkillFrame.DetailsFrame.ScrollBar)
	F.ReskinInput(TradeSkillFrame.SearchBox)
	F.ReskinInput(TradeSkillFrame.DetailsFrame.CreateMultipleInputBox)
	TradeSkillFrame.DetailsFrame.CreateMultipleInputBox.Left:Hide()
	TradeSkillFrame.DetailsFrame.CreateMultipleInputBox.Middle:Hide()
	TradeSkillFrame.DetailsFrame.CreateMultipleInputBox.Right:Hide()
	select(3, TradeSkillFrame.DetailsFrame.CreateMultipleInputBox:GetRegions()):Hide()
	select(4, TradeSkillFrame.DetailsFrame.CreateMultipleInputBox:GetRegions()):Hide()
	select(5, TradeSkillFrame.DetailsFrame.CreateMultipleInputBox:GetRegions()):Hide()
	TradeSkillFrame.DetailsFrame.CreateMultipleInputBox:SetPoint("LEFT", TradeSkillFrame.DetailsFrame.CreateAllButton, "RIGHT", 27, 0)
	
	F.ReskinArrow(TradeSkillFrame.LinkToButton, "right")
	F.ReskinArrow(TradeSkillFrame.DetailsFrame.CreateMultipleInputBox.IncrementButton, "right")
	TradeSkillFrame.DetailsFrame.CreateMultipleInputBox.IncrementButton:SetPoint("LEFT", TradeSkillFrame.DetailsFrame.CreateMultipleInputBox, "RIGHT", 1, 0)
	F.ReskinArrow(TradeSkillFrame.DetailsFrame.CreateMultipleInputBox.DecrementButton, "left")
	TradeSkillFrame.DetailsFrame.CreateMultipleInputBox.DecrementButton:SetPoint("RIGHT", TradeSkillFrame.DetailsFrame.CreateMultipleInputBox, "LEFT", -3, 0)
	
	TradeSkillFrame.LinkToButton:SetPoint("BOTTOMRIGHT", TradeSkillFrame.FilterButton, "TOPRIGHT", 0, 2)

	TradeSkillFrame.SearchBox:SetPoint("TOPLEFT", 190, -60)
end