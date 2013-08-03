local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)

------------------------------------------------------
-- INITIAL FRAME CREATION ----------------------------
------------------------------------------------------
AddonManager = CreateFrame("Frame", G.uiname.."AddonManager", UIParent)
AddonManager:SetFrameStrata("HIGH")
AddonManager.header = CreateFrame("Frame", "Addonmanager_Header", AddonManager)

AddonManager.header:SetPoint("CENTER", UIParent, "CENTER", 0, 100)
AddonManager:SetPoint("TOP", AddonManager.header, "TOP", 0, -30)

local My_Addons = {
	["!ClassColors"] = true,
	["Aurora"] = true,
	["AltzUI"] = true,
	["AltzUIConfig"] = true,
	["oGlow"] = true,
}
------------------------------------------------------
-- FUNCTIONS -----------------------------------------
------------------------------------------------------
local function GetEnabledAddons()
	local EnabledAddons = {}
		for i=1, GetNumAddOns() do
			local name, _, _, enabled = GetAddOnInfo(i)
			if enabled then
				tinsert(EnabledAddons, name)
			end
		end
	return EnabledAddons
end

local function CreateMenuButton(parent, width, height, text, ...)
	local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	button:SetFrameLevel(parent:GetFrameLevel()+1)
	button:SetSize(width, height)
	F.Reskin(button)
	if ... then button:SetPoint(...) end
	
	button.text = T.createtext(button, "OVERLAY", 12, "OUTLINE", "CENTER")
	button.text:SetPoint("CENTER", 1, 0)
	if text then button.text:SetText(text) end
	
	return button
end

function AddonManager:UpdateAddonList(queryString)
	local addons = {}
	for i=1, GetNumAddOns() do
		local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(i)
		local lwrTitle, lwrName = strlower(title), strlower(name)
		if (queryString and (strfind(lwrTitle,strlower(queryString)) or strfind(lwrName,strlower(queryString)))) or (not queryString) then
			addons[i] = {}
			addons[i].name = name
			addons[i].title = title
			addons[i].notes = notes
			addons[i].enabled = enabled
			if GetAddOnMetadata(i, "version") then
				addons[i].version = GetAddOnMetadata(i, "version")
			end
			if GetAddOnDependencies(i) then
				addons[i].dependencies = {GetAddOnDependencies(i)}
			end
			if GetAddOnOptionalDependencies(i) then
				addons[i].optionaldependencies = {GetAddOnOptionalDependencies(i)}
			end
		end
	end
	return addons
end


function AddonManager:LoadProfileWindow()
	local self = AddonManager
	
	if self.ProfileWindow then ToggleFrame(self.ProfileWindow) return end
	
	local window = CreateFrame("Frame", "AddonManager_ProfileWindow", self)
	window:SetPoint("TOPLEFT", self, "TOPRIGHT", 15, -2)
	window:SetSize(175, 20)
	F.SetBD(window)
		
	local title = T.createtext(window, "OVERLAY", 12, "OUTLINE", "CENTER")
	title:SetPoint("CENTER")
	title:SetText(L["配置"])
	window.title = title
	
	local EnableAll = CreateMenuButton(window, (window:GetWidth()-15)/2, 20, L["启用全部"], "TOPLEFT", window, "BOTTOMLEFT", 5, -15)
	EnableAll:SetScript("OnClick", function(self)
		for i, addon in pairs(AddonManager.AllAddons) do
			EnableAddOn(addon.name)
			AddonManager.Buttons[i]:SetBackdropColor(0/255, 170/255, 255/255)
			addon.enabled = true
		end
	end)
	self.EnableAll = EnableAll
	
	local DisableAll = CreateMenuButton(window, EnableAll:GetWidth(), EnableAll:GetHeight(), L["禁用全部"], "TOPRIGHT", window, "BOTTOMRIGHT", -5, -15)
	DisableAll:SetScript("OnClick", function(self)
		for i, addon in pairs(AddonManager.AllAddons) do
			if not My_Addons[addon.name] then
				DisableAddOn(addon.name)
				AddonManager.Buttons[i]:SetBackdropColor(50/255, 50/255, 50/255)
				addon.enabled = false
			end
		end
	end)
	self.DisableAll = DisableAll
	
	local SaveProfile = CreateMenuButton(window, window:GetWidth()-10, 20, L["新配置文件"], "TOPLEFT", EnableAll, "BOTTOMLEFT", 0, -5)
	SaveProfile:SetScript("OnClick", function(self)
		if not self.editbox then
			local editbox = CreateFrame("EditBox", nil, self)
			F.CreateBD(editbox, .5)
			editbox:SetAllPoints(self)
			editbox:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
			editbox:SetText(L["配置文件名字"])
			editbox:SetAutoFocus(false)
			editbox:SetFocus(true)
			editbox:HighlightText()
			editbox:SetTextInsets(3, 0, 0, 0)
			editbox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
			editbox:SetScript("OnEscapePressed", function(self) self:SetText(L["配置文件名字"]) self:ClearFocus() self:Hide() end)
			editbox:SetScript("OnEnterPressed", function(self)
				local profileName = self:GetText()
				self:ClearFocus()
				self:SetText(L["配置文件名字"])
				self:Hide()
				if not profileName then return end
				aCoreCDB["AddonProfiles"][profileName] = GetEnabledAddons()
				AddonManager:UpdateProfileList()
			end)
	
			self.editbox = editbox
		else
			self.editbox:Show()
			self.editbox:SetFocus(true)
			self.editbox:HighlightText()
		end
	end)
	self.SaveProfile = SaveProfile
	
	self:SetScript("OnHide", function(self)
		if self.SaveProfile.editbox then self.SaveProfile.editbox:Hide() end
		window:Hide()
	end)
	
	local buttons = {}
	function AddonManager:UpdateProfileList()
		
		--Thanks for hydra for this sort code
		local sort = function(t, func)
			local temp = {}
			local i = 0

			for n in pairs(t) do
				table.insert(temp, n)
			end

			table.sort(temp, func)
			
			local iter = function()
				i = i + 1
				if temp[i] == nil then
					return nil
				else
					return temp[i], t[temp[i]]
				end
			end

			return iter
		end
		
		local function CollapseAllProfiles()
			for i=1, #buttons do
				buttons[i].overlay:Hide()
				buttons[i]:SetHeight(20)
			end
		end
		
		for i=1, #buttons do
			buttons[i]:Hide()
			CollapseAllProfiles()
		end

		local i = 1
		for profileName, addonList in sort(aCoreCDB["AddonProfiles"], function(a, b) return strlower(b) > strlower(a) end) do
			if not buttons[i] then
				local button = CreateMenuButton(window, window:GetWidth()-10, 20, "<"..L["配置文件名字"]..">")
				button.text:ClearAllPoints()
				button.text:SetPoint("CENTER", button, "TOP", 0, -10)
				
				local overlay = CreateFrame("Frame", nil, button)
				overlay:SetHeight(1)
				overlay:SetPoint("TOP", button, "TOP", 0, -18)
				overlay:SetWidth(button:GetWidth()-10)
				overlay:SetFrameLevel(button:GetFrameLevel()+1)
				overlay:Hide()

				overlay.set = CreateMenuButton(overlay, overlay:GetWidth(), 20, L["设置到"], "TOP", button, "TOP", 0, -18)
				overlay.add = CreateMenuButton(overlay, overlay:GetWidth(), 20, L["增加到"], "TOP", overlay.set, "BOTTOM", 0, 1)
				overlay.remove = CreateMenuButton(overlay, overlay:GetWidth(), 20, L["移除自"], "TOP", overlay.add, "BOTTOM", 0, 1)
				overlay.delete = CreateMenuButton(overlay, overlay:GetWidth(), 20, L["删除配置文件"], "TOP", overlay.remove, "BOTTOM", 0, 1)
				
				button.overlay = overlay
				
				button:SetScript("OnClick", function(self)
					
					
					if self.overlay:IsShown() then
						CollapseAllProfiles()
					else
						CollapseAllProfiles()
						self.overlay:Show()
						self:SetHeight(20*5)
					end
				end)
				
				buttons[i] = button
			end
			
			buttons[i]:Show()
			buttons[i].text:SetText(profileName)
			local overlay = buttons[i].overlay
			overlay.set:SetScript("OnClick", function(self)
				DisableAllAddOns()
				EnableAddOn("AltzUIConfig")
				EnableAddOn("AltzUI")
				for i, name in pairs(addonList) do EnableAddOn(name) end
				AddonManager.AllAddons = AddonManager:UpdateAddonList()
				AddonManager:UpdateList(AddonManager.AllAddons)
				CollapseAllProfiles()
			end)
			overlay.add:SetScript("OnClick", function(self)
				for i, name in pairs(addonList) do EnableAddOn(name) end
				AddonManager.AllAddons = AddonManager:UpdateAddonList()
				AddonManager:UpdateList(AddonManager.AllAddons)
				CollapseAllProfiles()
			end)
			overlay.remove:SetScript("OnClick", function(self)
				for i, name in pairs(addonList) do if (name ~= "AltzUIConfig" and name ~= "AltzUI") then DisableAddOn(name) end end
				AddonManager.AllAddons = AddonManager:UpdateAddonList()
				AddonManager:UpdateList(AddonManager.AllAddons)
				CollapseAllProfiles()
			end)
			overlay.delete:SetScript("OnClick", function(self)
				if IsShiftKeyDown() then
					aCoreCDB["AddonProfiles"][profileName] = nil
					AddonManager:UpdateProfileList()
					CollapseAllProfiles()
				else
					print(L["删除配置文件确认"])
				end
			end)
			i = i + 1
		end

		local prevButton
		for i,button in pairs(buttons) do
			if i == 1 then
				button:SetPoint("TOP", SaveProfile, "BOTTOM", 0, -5)
			else
				button:SetPoint("TOP", prevButton, "BOTTOM", 0, 1)
			end
			prevButton = button
		end

		if not prevButton then prevButton = SaveProfile end
	end
	self.ProfileWindow = window
	
	AddonManager:UpdateProfileList()
end

T.LoadAddonManagerWindow = function()
	if AddonManager.Loaded then AddonManager:Show(); return  end
	local window = AddonManager
	local header = window.header
	
	tinsert(UISpecialFrames,window:GetName());
	
	window:SetSize(300,320)
	header:SetSize(window:GetWidth(),20)
	
	F.SetBD(window)
	F.SetBD(header)
	
	header:EnableMouse(true)
	header:SetMovable(true)
	header:SetScript("OnMouseDown", function(self) self:StartMoving() end)
	header:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
	
	local hTitle = T.createtext(AddonManager.header, "OVERLAY", 12, "OUTLINE", "CENTER")
	hTitle:SetPoint("CENTER")
	hTitle:SetText(L["插件管理"])
	header.title = hTitle 
	
	local addonListBG = CreateFrame("Frame", window:GetName().."_ScrollBackground", window)
	addonListBG:SetPoint("TOPLEFT", header, "TOPLEFT", 10, -70)
	addonListBG:SetWidth(window:GetWidth()-20)
	addonListBG:SetHeight(window:GetHeight()-58)
	F.CreateBD(addonListBG, 0)
	
	--Create scroll frame (God damn these things are a pain)
	local scrollFrame = CreateFrame("ScrollFrame", window:GetName().."_ScrollFrame", window, "UIPanelScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", addonListBG, "TOPLEFT", 0, -5)
	scrollFrame:SetWidth(addonListBG:GetWidth()-25)
	scrollFrame:SetHeight(addonListBG:GetHeight()-10)
	F.ReskinScroll(_G[window:GetName().."_ScrollFrameScrollBar"])
	scrollFrame:SetFrameLevel(window:GetFrameLevel()+1)
	
	scrollFrame.Anchor = CreateFrame("Frame", window:GetName().."_ScrollAnchor", scrollFrame)
	scrollFrame.Anchor:SetPoint("TOPLEFT", scrollFrame, "TOPLEFT", 0, -3)
	scrollFrame.Anchor:SetWidth(window:GetWidth()-40)
	scrollFrame.Anchor:SetHeight(scrollFrame:GetHeight())
	scrollFrame.Anchor:SetFrameLevel(scrollFrame:GetFrameLevel()+1)
	scrollFrame:SetScrollChild(scrollFrame.Anchor)
	
	--Load up addon information
	AddonManager.AllAddons = AddonManager:UpdateAddonList()
	AddonManager.FilteredAddons = AddonManager:UpdateAddonList()
	AddonManager.showEnabled = true
	AddonManager.showDisabled = true
	
	AddonManager.Buttons = {}
	
	--Create initial list
	for i, addon in pairs(AddonManager.AllAddons) do
		local button = CreateFrame("Frame", nil, scrollFrame.Anchor)
		button:SetFrameLevel(scrollFrame.Anchor:GetFrameLevel() + 1)
		button:SetSize(16, 16)
		F.CreateBD(button, 0)
		if addon.enabled then
			button:SetBackdropColor(0/255, 170/255, 255/255)
		else
			button:SetBackdropColor(50/255, 50/255, 50/255)
		end
		
		if i == 1 then
			button:SetPoint("TOPLEFT", scrollFrame.Anchor, "TOPLEFT", 5, -5)
		else
			button:SetPoint("TOP", AddonManager.Buttons[i-1], "BOTTOM", 0, -3)
		end
		button.text = T.createtext(button, "OVERLAY", 12, "OUTLINE", "LEFT")
		button.text:SetPoint("LEFT", button, "RIGHT", 8, 0)
		button.text:SetPoint("RIGHT", scrollFrame.Anchor, "RIGHT", 0, 0)
		button.text:SetText(addon.title)
		
		button:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT", -3, self:GetHeight())
			GameTooltip:ClearLines()
			
			if addon.version then GameTooltip:AddDoubleLine(addon.title, addon.version)
			else GameTooltip:AddLine(addon.title) end
			if addon.notes then	GameTooltip:AddLine(addon.notes, nil, nil, nil, true) end
			if addon.dependencies then GameTooltip:AddLine("Dependencies: "..unpack(addon.dependencies), 1, .5, 0, true) end
			if addon.optionaldependencies then GameTooltip:AddLine("Optional Dependencies: "..unpack(addon.optionaldependencies), 1, .5, 0, true) end
			
			GameTooltip:Show()
		end)
		button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
		
		button:SetScript("OnMouseDown", function(self)
			if addon.enabled then
				self:SetBackdropColor(50/255, 50/255, 50/255)
				DisableAddOn(addon.name)
				addon.enabled = false
			else
				self:SetBackdropColor(0/255, 170/255, 255/255)
				EnableAddOn(addon.name)
				addon.enabled = true
			end
		end)
			
		AddonManager.Buttons[i] = button
	end
		
	function AddonManager:UpdateList(AddonsTable)
		--Start off by hiding all of the buttons
		for _, b in pairs(AddonManager.Buttons) do b:Hide() end
		local i = 1
		for _, addon in pairs(AddonsTable) do
			local button = AddonManager.Buttons[i]
			button:Show()
			if addon.enabled then
				button:SetBackdropColor(0/255, 170/255, 255/255)
			else
				button:SetBackdropColor(50/255, 50/255, 50/255)
			end
			
			button:SetScript("OnMouseDown", function(self)
				if addon.enabled then
					self:SetBackdropColor(50/255, 50/255, 50/255)
					DisableAddOn(addon.name)
					addon.enabled = false
				else
					self:SetBackdropColor(0/255, 170/255, 255/255)
					EnableAddOn(addon.name)
					addon.enabled = true
				end
			end)
			
			button.text:SetText(addon.title)
			i = i+1
		end
	end
		
	--Search Bar
	local searchBar = CreateFrame("EditBox", window:GetName().."_SearchBar", window)
	searchBar:SetFrameLevel(window:GetFrameLevel()+1)
	searchBar:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 10, -20)
	searchBar:SetWidth(120)
	searchBar:SetHeight(23)
	F.CreateBD(searchBar, .3)
	searchBar:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
	searchBar:SetText(L[" 搜索"])
	searchBar:SetAutoFocus(false)
	searchBar:SetTextInsets(3, 0, 0 ,0)
	searchBar:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
	searchBar:SetScript("OnEscapePressed", function(self) searchBar:SetText(L[" 搜索"]) AddonManager:UpdateList(AddonManager.AllAddons) searchBar:ClearFocus() end)
	searchBar:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
	searchBar:SetScript("OnTextChanged", function(self, input)
		if input then
			AddonManager.FilteredAddons = AddonManager:UpdateAddonList(self:GetText())
			AddonManager:UpdateList(AddonManager.FilteredAddons)
		end
	end)

	AddonManager.searchBar = searchBar
	local profileButton = CreateMenuButton(window, 70, searchBar:GetHeight(), L["配置"], "TOPRIGHT", header, "BOTTOMRIGHT", -15, -20)
	profileButton:SetScript("OnClick", function(self)
		AddonManager:LoadProfileWindow()
	end)
	AddonManager.profileButton = profileButton
	
	local reloadButton = CreateMenuButton(window, 1, searchBar:GetHeight(), L["重载插件"], "LEFT", searchBar, "RIGHT", 5, 0)
	reloadButton:SetPoint("RIGHT", profileButton, "LEFT", -5, 0)
	reloadButton:SetScript("OnClick", function(self)
		if InCombatLockdown() then return end
		ReloadUI()
	end)
	AddonManager.reloadButton = reloadButton
	
	AddonManager.Loaded = true
end