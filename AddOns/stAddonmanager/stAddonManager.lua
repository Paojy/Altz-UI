local ADDON_NAME = ...
local F, C = unpack(Aurora)
local ns = select(2, ...)
local L = ns.L

------------------------------------------------------
-- MEDIA & CONFIG ------------------------------------
------------------------------------------------------
local font = { GameFontHighlight:GetFont(), 12, "OUTLINE" }

------------------------------------------------------
-- INITIAL FRAME CREATION ----------------------------
------------------------------------------------------
stAddonManager = CreateFrame("Frame", "stAddonManager", UIParent)
stAddonManager:SetFrameStrata("DIALOG")
stAddonManager.header = CreateFrame("Frame", "stAddonmanager_Header", stAddonManager)

stAddonManager.header:SetPoint("CENTER", UIParent, "CENTER", 0, 100)
stAddonManager:SetPoint("TOP", stAddonManager.header, "TOP", 0, -30)

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
	
	button.text = button:CreateFontString(nil, "OVERLAY")
	button.text:SetFont(unpack(font))
	button.text:SetPoint("CENTER", 1, 0)
	if text then button.text:SetText(text) end
	
	return button
end

function stAddonManager:UpdateAddonList(queryString)
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


function stAddonManager:LoadProfileWindow()
	local self = stAddonManager
	if not stAddonProfiles then stAddonProfiles = {} end
	
	if self.ProfileWindow then ToggleFrame(self.ProfileWindow) return end
	
	local window = CreateFrame("Frame", "stAddonManager_ProfileWindow", self)
	window:SetPoint("TOPLEFT", self, "TOPRIGHT", 15, -2)
	window:SetSize(175, 20)
	F.SetBD(window)
		
	local title = window:CreateFontString(nil, "OVERLAY")
	title:SetFont(unpack(font))
	title:SetPoint("CENTER")
	title:SetText(L.Profiles)
	window.title = title
	
	local EnableAll = CreateMenuButton(window, (window:GetWidth()-15)/2, 20, L.Enable_All, "TOPLEFT", window, "BOTTOMLEFT", 5, -15)
	EnableAll:SetScript("OnClick", function(self)
		for i, addon in pairs(stAddonManager.AllAddons) do
			EnableAddOn(addon.name)
			stAddonManager.Buttons[i]:SetBackdropColor(0/255, 170/255, 255/255)
			addon.enabled = true
		end
	end)
	self.EnableAll = EnableAll
	
	local DisableAll = CreateMenuButton(window, EnableAll:GetWidth(), EnableAll:GetHeight(), L.Disable_All, "TOPRIGHT", window, "BOTTOMRIGHT", -5, -15)
	DisableAll:SetScript("OnClick", function(self)
		for i, addon in pairs(stAddonManager.AllAddons) do
			if addon.name ~= "Aurora" and addon.name ~= ADDON_NAME then
				DisableAddOn(addon.name)
				stAddonManager.Buttons[i]:SetBackdropColor(50/255, 50/255, 50/255)
				addon.enabled = false
			end
		end
	end)
	self.DisableAll = DisableAll
	
	local SaveProfile = CreateMenuButton(window, window:GetWidth()-10, 20, L.New_Profile, "TOPLEFT", EnableAll, "BOTTOMLEFT", 0, -5)
	SaveProfile:SetScript("OnClick", function(self)
		if not self.editbox then
			local editbox = CreateFrame("EditBox", nil, self)
			F.CreateBD(editbox, .5)
			editbox:SetAllPoints(self)
			editbox:SetFont(unpack(font))
			editbox:SetText(L.Profile_Name)
			editbox:SetAutoFocus(false)
			editbox:SetFocus(true)
			editbox:HighlightText()
			editbox:SetTextInsets(3, 0, 0, 0)
			editbox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
			editbox:SetScript("OnEscapePressed", function(self) self:SetText(L.Profile_Name) self:ClearFocus() self:Hide() end)
			editbox:SetScript("OnEnterPressed", function(self)
				local profileName = self:GetText()
				self:ClearFocus()
				self:SetText(L.Profile_Name)
				self:Hide()
				if not profileName then return end
				stAddonProfiles[profileName] = GetEnabledAddons()
				stAddonManager:UpdateProfileList()
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
	function stAddonManager:UpdateProfileList()
		
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
		for profileName, addonList in sort(stAddonProfiles, function(a, b) return strlower(b) > strlower(a) end) do
			if not buttons[i] then
				local button = CreateMenuButton(window, window:GetWidth()-10, 20, "<"..L.Profile_Name..">")
				button.text:ClearAllPoints()
				button.text:SetPoint("CENTER", button, "TOP", 0, -10)
				
				local overlay = CreateFrame("Frame", nil, button)
				overlay:SetHeight(1)
				overlay:SetPoint("TOP", button, "TOP", 0, -18)
				overlay:SetWidth(button:GetWidth()-10)
				overlay:SetFrameLevel(button:GetFrameLevel()+1)
				overlay:Hide()

				overlay.set = CreateMenuButton(overlay, overlay:GetWidth(), 20, L.Set_To, "TOP", button, "TOP", 0, -18)
				overlay.add = CreateMenuButton(overlay, overlay:GetWidth(), 20, L.Add_To, "TOP", overlay.set, "BOTTOM", 0, 1)
				overlay.remove = CreateMenuButton(overlay, overlay:GetWidth(), 20, L.Remove_From, "TOP", overlay.add, "BOTTOM", 0, 1)
				overlay.delete = CreateMenuButton(overlay, overlay:GetWidth(), 20, L.Delete_Profile, "TOP", overlay.remove, "BOTTOM", 0, 1)
				
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
				EnableAddOn(ADDON_NAME)
				for i, name in pairs(addonList) do EnableAddOn(name) end
				stAddonManager.AllAddons = stAddonManager:UpdateAddonList()
				stAddonManager:UpdateList(stAddonManager.AllAddons)
				CollapseAllProfiles()
			end)
			overlay.add:SetScript("OnClick", function(self)
				for i, name in pairs(addonList) do EnableAddOn(name) end
				stAddonManager.AllAddons = stAddonManager:UpdateAddonList()
				stAddonManager:UpdateList(stAddonManager.AllAddons)
				CollapseAllProfiles()
			end)
			overlay.remove:SetScript("OnClick", function(self)
				for i, name in pairs(addonList) do if name ~= ADDON_NAME then DisableAddOn(name) end end
				stAddonManager.AllAddons = stAddonManager:UpdateAddonList()
				stAddonManager:UpdateList(stAddonManager.AllAddons)
				CollapseAllProfiles()
			end)
			overlay.delete:SetScript("OnClick", function(self)
				if IsShiftKeyDown() then
					stAddonProfiles[profileName] = nil
					stAddonManager:UpdateProfileList()
					CollapseAllProfiles()
				else
					print("|cff00aaffst|rAddonManager: "..L.Confirm_Delete)
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
	
	stAddonManager:UpdateProfileList()
end

function stAddonManager:LoadWindow()
	if stAddonManager.Loaded then stAddonManager:Show(); return  end
	local window = stAddonManager
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
	
	local hTitle = stAddonManager.header:CreateFontString(nil, "OVERLAY")
	hTitle:SetFont(unpack(font))
	hTitle:SetPoint("CENTER")
	hTitle:SetText("|cff00aaffst|rAddonManager")
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
	stAddonManager.AllAddons = stAddonManager:UpdateAddonList()
	stAddonManager.FilteredAddons = stAddonManager:UpdateAddonList()
	stAddonManager.showEnabled = true
	stAddonManager.showDisabled = true
	
	stAddonManager.Buttons = {}
	
	--Create initial list
	for i, addon in pairs(stAddonManager.AllAddons) do
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
			button:SetPoint("TOP", stAddonManager.Buttons[i-1], "BOTTOM", 0, -3)
		end
		button.text = button:CreateFontString(nil, "OVERLAY")
		button.text:SetFont(unpack(font))
		button.text:SetJustifyH("LEFT")
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
			
		stAddonManager.Buttons[i] = button
	end
		
	function stAddonManager:UpdateList(AddonsTable)
		--Start off by hiding all of the buttons
		for _, b in pairs(stAddonManager.Buttons) do b:Hide() end
		local i = 1
		for _, addon in pairs(AddonsTable) do
			local button = stAddonManager.Buttons[i]
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
	searchBar:SetFont(unpack(font))
	searchBar:SetText(L.Search)
	searchBar:SetAutoFocus(false)
	searchBar:SetTextInsets(3, 0, 0 ,0)
	searchBar:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
	searchBar:SetScript("OnEscapePressed", function(self) searchBar:SetText(L.Search) stAddonManager:UpdateList(stAddonManager.AllAddons) searchBar:ClearFocus() end)
	searchBar:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
	searchBar:SetScript("OnTextChanged", function(self, input)
		if input then
			stAddonManager.FilteredAddons = stAddonManager:UpdateAddonList(self:GetText())
			stAddonManager:UpdateList(stAddonManager.FilteredAddons)
		end
	end)

	stAddonManager.searchBar = searchBar
	local profileButton = CreateMenuButton(window, 70, searchBar:GetHeight(), L.Profiles, "TOPRIGHT", header, "BOTTOMRIGHT", -15, -20)
	profileButton:SetScript("OnClick", function(self)
		stAddonManager:LoadProfileWindow()
	end)
	stAddonManager.profileButton = profileButton
	
	local reloadButton = CreateMenuButton(window, 1, searchBar:GetHeight(), L.ReloadUI, "LEFT", searchBar, "RIGHT", 5, 0)
	reloadButton:SetPoint("RIGHT", profileButton, "LEFT", -5, 0)
	reloadButton:SetScript("OnClick", function(self)
		if InCombatLockdown() then return end
		ReloadUI()
	end)
	stAddonManager.reloadButton = reloadButton
	
	stAddonManager.Loaded = true
end

SLASH_STADDONMANAGER1, SLASH_STADDONMANAGER2, SLASH_STADDONMANAGER3 = "/staddonmanager", "/stam", "/staddon"
SlashCmdList["STADDONMANAGER"] = function() stAddonManager:LoadWindow() end

local gmbAddOns = CreateFrame("Button", "GameMenuButtonAddOns", GameMenuFrame, "GameMenuButtonTemplate")
gmbAddOns:SetSize(GameMenuButtonMacros:GetWidth(), GameMenuButtonMacros:GetHeight())
GameMenuFrame:SetHeight(GameMenuFrame:GetHeight()+GameMenuButtonMacros:GetHeight());
GameMenuButtonLogout:SetPoint("TOP", gmbAddOns, "BOTTOM", 0, -1)
gmbAddOns:SetPoint("TOP", GameMenuButtonMacros, "BOTTOM", 0, -1)
gmbAddOns:SetText(ADDONS)
F.Reskin(gmbAddOns)
gmbAddOns:SetScript("OnClick", function()
	HideUIPanel(GameMenuFrame);
	stAddonManager:LoadWindow()
end)