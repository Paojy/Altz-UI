local T, C, L, G = unpack(select(2, ...))

----------------------------
--     	   默认设置	      --
----------------------------

T.SetChatFrame = function ()
	FCF_ResetChatWindows()
	
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

T.ResetAurora = function(reload)
	if IsAddOnLoaded("AuroraClassic") then
		AuroraClassicDB["Bags"] = true
	end
	if reload then ReloadUI() end
end

T.ResetClasscolors = function(reload)
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
				["hex"] = "ffe200ff",
				["colorStr"] = "ffe200ff",
				["b"] = 0.95,
				["g"] = 0.56,
				["r"] = 0.76,
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
	if reload then ReloadUI() end
end

T.ResetSkada =function(reload)
	if aCoreCDB["SkinOptions"]["setSkada"] and IsAddOnLoaded("Skada") then
		local Skada = Skada
		local windows = Skada:GetWindows()
		if #windows == 0 then
			Skada:CreateWindow("altz_1", nil, "bar")
			Skada:CreateWindow("altz_2", nil, "bar")		
		elseif #windows == 1 then
			Skada:CreateWindow("altz_1", nil, "bar")
		end
		SkadaDB["profiles"] = {
				["Default"] = {
					["autostop"] = true,
					["windows"] = {
						{
							["barheight"] = 21,
							["classicons"] = false,
							["barslocked"] = true,
							["y"] = 46,
							["x"] = -195,
							["name"] = "1",
							["point"] = "BOTTOMRIGHT",
							["buttons"] = {
								["menu"] = false,
								["mode"] = false,
								["reset"] = false,
							},
							["barwidth"] = 155,
							["barfontflags"] = "",
							["background"] = {
								["color"] = {
									["a"] = 0,
								},
								["height"] = 175,
							},
							["title"] = {
								["color"] = {
									["a"] = 0,
									["b"] = 0.3,
									["g"] = 0.1,
									["r"] = 0.1,
								},
								["bordertexture"] = "None",
								["font"] = "Accidental Presidency",
								["borderthickness"] = 2,
								["fontsize"] = 11,
								["fontflags"] = "",
								["height"] = 24,
								["margin"] = 0,
								["texture"] = "Aluminium",
							},
						}, -- [1]
						{
							["titleset"] = true,
							["barheight"] = 21,
							["classicons"] = false,
							["barslocked"] = true,
							["enabletitle"] = true,
							["wipemode"] = "",
							["set"] = "current",
							["hidden"] = false,
							["y"] = 46,
							["barfont"] = "Accidental Presidency",
							["name"] = "2",
							["display"] = "bar",
							["barfontflags"] = "",
							["classcolortext"] = false,
							["scale"] = 1,
							["reversegrowth"] = false,
							["returnaftercombat"] = false,
							["roleicons"] = false,
							["barorientation"] = 1,
							["snapto"] = true,
							["version"] = 1,
							["modeincombat"] = "",
							["bartexture"] = "BantoBar",
							["barwidth"] = 155,
							["barspacing"] = 0,
							["clickthrough"] = false,
							["barfontsize"] = 11,
							["barbgcolor"] = {
								["a"] = 0.6,
								["b"] = 0.3,
								["g"] = 0.3,
								["r"] = 0.3,
							},
							["background"] = {
								["borderthickness"] = 0,
								["height"] = 175,
								["color"] = {
									["a"] = 0,
									["b"] = 0.5,
									["g"] = 0,
									["r"] = 0,
								},
								["bordertexture"] = "None",
								["margin"] = 0,
								["texture"] = "Solid",
							},
							["barcolor"] = {
								["a"] = 1,
								["b"] = 0.8,
								["g"] = 0.3,
								["r"] = 0.3,
							},
							["classcolorbars"] = true,
							["title"] = {
								["color"] = {
									["a"] = 0,
									["b"] = 0.3,
									["g"] = 0.1,
									["r"] = 0.1,
								},
								["bordertexture"] = "None",
								["font"] = "Accidental Presidency",
								["borderthickness"] = 2,
								["fontsize"] = 11,
								["fontflags"] = "",
								["height"] = 24,
								["margin"] = 0,
								["texture"] = "Aluminium",
							},
							["buttons"] = {
								["segment"] = true,
								["menu"] = false,
								["mode"] = false,
								["report"] = true,
								["reset"] = false,
							},
							["x"] = -351,
							["point"] = "BOTTOMRIGHT",
						}, -- [2]
					},
				},
			}
		local Skada_L = LibStub("AceLocale-3.0"):GetLocale("Skada", false)
		SkadaDB["profiles"]["Default"]["columns"] = {}
		SkadaDB["profiles"]["Default"]["columns"][Skada_L["Damage"].."_Percent"] = false
		SkadaDB["profiles"]["Default"]["columns"][Skada_L["Healing"].."_Percent"] = false
		SkadaDB["profiles"]["Default"]["columns"][Skada_L["Damage taken"].."_Percent"] = false
		SkadaDB["profiles"]["Default"]["showranks"] = false
		if reload then ReloadUI() end
	end	
end

T.ResetDBM =function(reload)
	if aCoreCDB["SkinOptions"]["setDBM"] and IsAddOnLoaded("DBM-Core") then
		if DBM_AllSavedOptions then
			--DBM.Bars:SetSkin("AltzUI")		
			DBM_AllSavedOptions["Default"]["ShowMinimapButton"] = false
			-- BOSS血条
			DBM_AllSavedOptions["Default"]["HPFramePoint"] = "BOTTOM"			
			DBM_AllSavedOptions["Default"]["HPFrameY"] = 120
			DBM_AllSavedOptions["Default"]["HPFrameX"] = -375
			DBM_AllSavedOptions["Default"]["HealthFrameWidth"] = 200
			DBM_AllSavedOptions["Default"]["AlwaysShowHealthFrame"] = false
			DBM_AllSavedOptions["Default"]["HealthFrameGrowUp"] = false
			-- 信息框
			DBM_AllSavedOptions["Default"]["InfoFramePoint"] = "BOTTOM"
			DBM_AllSavedOptions["Default"]["InfoFrameX"] = -310
			DBM_AllSavedOptions["Default"]["InfoFrameY"] = 195
			-- 距离框
			DBM_AllSavedOptions["Default"]["RangeFramePoint"] = "BOTTOM"
			DBM_AllSavedOptions["Default"]["RangeFrameX"] = 450
			DBM_AllSavedOptions["Default"]["RangeFrameY"] = 270
			DBM_AllSavedOptions["Default"]["RangeFrameRadarPoint"] = "BOTTOM"
			DBM_AllSavedOptions["Default"]["RangeFrameRadarX"] = 300
			DBM_AllSavedOptions["Default"]["RangeFrameRadarY"] = 180
			DBM_AllSavedOptions["Default"]["RangeFrameFrames"] = "radar"
			-- 一般计时条
			DBT_AllPersistentOptions["Default"]["DBM"]["TimerPoint"] = "LEFT"
			DBT_AllPersistentOptions["Default"]["DBM"]["TimerY"] = 50
			DBT_AllPersistentOptions["Default"]["DBM"]["TimerX"] = 150
			DBT_AllPersistentOptions["Default"]["DBM"]["FillUpBars"] = true
			-- 大型计时条
			DBT_AllPersistentOptions["Default"]["DBM"]["HugeTimerPoint"] = "CENTER"
			DBT_AllPersistentOptions["Default"]["DBM"]["HugeTimerX"] = -330
			DBT_AllPersistentOptions["Default"]["DBM"]["HugeTimerY"] = 0			
			-- 一般警报
			DBM_AllSavedOptions["Default"]["WarningIconRight"] = true
			DBM_AllSavedOptions["Default"]["WarningIconLeft"] = true
			DBM_AllSavedOptions["Default"]["WarningFontStyle"] = "THICKOUTLINE"
			DBM_AllSavedOptions["Default"]["WarningFont"] = G.norFont
			DBM_AllSavedOptions["Default"]["WarningFontShadow"] = true
			DBM_AllSavedOptions["Default"]["WarningPoint"] = "TOP"
			DBM_AllSavedOptions["Default"]["WarningY"] = -150
			DBM_AllSavedOptions["Default"]["WarningX"] = -0
			-- 特殊警报
			DBM_AllSavedOptions["Default"]["SpecialWarningFontSize"] = 65
			DBM_AllSavedOptions["Default"]["SpecialWarningFont"] = G.norFont
			DBM_AllSavedOptions["Default"]["SpecialWarningFontStyle"] = "THICKOUTLINE"
			DBM_AllSavedOptions["Default"]["SpecialWarningFontShadow"] = true
			DBM_AllSavedOptions["Default"]["SpecialWarningPoint"] = "CENTER"
			DBM_AllSavedOptions["Default"]["SpecialWarningX"] = 0
			DBM_AllSavedOptions["Default"]["SpecialWarningY"] = 150
		end
		if reload then ReloadUI() end
	end
end

T.ResetBW =function(reload)
	if aCoreCDB["SkinOptions"]["setBW"] and IsAddOnLoaded("Bigwigs") then
		if BigWigs3DB then
			BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"]["Default"]["barStyle"] = "AltzUI"

			--BigWigs3DB["namespaces"]["BigWigs_Plugins_Alt Power"]["profiles"]["Default"]["posx"] = 420
			--BigWigs3DB["namespaces"]["BigWigs_Plugins_Alt Power"]["profiles"]["Default"]["posy"] = 160
			
			BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"]["Default"]["fill"] = true
			BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"]["Default"]["BigWigsAnchor_width"] = 150
			
			--BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"]["Default"]["BigWigsAnchor_x"] = 38.4006290244915
			--BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"]["Default"]["BigWigsAnchor_y"] = 504.53291841031
			
			BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"]["Default"]["BigWigsEmphasizeAnchor_width"] = 200
			BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"]["Default"]["emphasizeScale"] = 1
			--BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"]["Default"]["BigWigsEmphasizeAnchor_x"] = 356.266867036815			
			--BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"]["Default"]["BigWigsEmphasizeAnchor_y"] = 432.000146594044
			
			--BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"]["Default"]["BWMessageAnchor_x"] = 617.066548707488
			--BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"]["Default"]["BWMessageAnchor_y"] = 584.533190059665
			
			--BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"]["Default"]["BWEmphasizeMessageAnchor_x"] = 615.99986904383
			--BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"]["Default"]["BWEmphasizeMessageAnchor_y"] = 496.000067038534
			
			--BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"]["Default"]["BWEmphasizeCountdownMessageAnchor_x"] = 668.799985051155
			--BigWigs3DB["namespaces"]["BigWigs_Plugins_Messages"]["profiles"]["Default"]["BWEmphasizeCountdownMessageAnchor_y"] = 449.066786837575
			
			--BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"]["Default"]["width"] = 140.00016784668
			--BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"]["Default"]["height"] = 119.999984741211
			
			--BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"]["Default"]["posy"] = 143.999772171979
			--BigWigs3DB["namespaces"]["BigWigs_Plugins_Proximity"]["profiles"]["Default"]["posx"] = 817.067012987129

		end
		if reload then ReloadUI() end
	end
end

T.ResetAllAddonSettings = function()
	T.ResetAurora()
	T.ResetClasscolors()
	T.ResetSkada()
	T.ResetDBM()
	T.ResetBW()
end

----------------------------
-- 			控制台		  --
----------------------------
-- dependency relationship
T.createDR = function(parent, ...)
    for i=1, select("#", ...) do
		local object = select(i, ...)
		parent:HookScript("OnShow", function(self)
			if self:GetChecked() and self:IsEnabled() then
				object:Enable()
			else
				object:Disable()
			end
		end)
		parent:HookScript("OnClick", function(self)
			if self:GetChecked() and self:IsEnabled() then
				object:Enable()
			else
				object:Disable()
			end
		end)
	end
end

-- 勾选按钮
T.createcheckbutton = function(parent, x, y, name, table, value, tip)
	local bu = CreateFrame("CheckButton", G.uiname..value.."Button", parent, "UICheckButtonTemplate")
	bu:SetPoint("TOPLEFT", x, -y)
	T.ReskinCheck(bu)
	
	bu.Text:SetText(name)
	
	bu:SetScript("OnShow", function(self) self:SetChecked(aCoreCDB[table][value]) end)
	bu:SetScript("OnClick", function(self)
		if self:GetChecked() then
			aCoreCDB[table][value] = true
		else
			aCoreCDB[table][value] = false
		end
		if self.apply then
			self.apply()
		end
	end)
	
	bu:SetScript("OnDisable", function(self)
		bu.Text:SetTextColor(.5, .5, .5)
	end)
	
	bu:SetScript("OnEnable", function(self)
		bu.Text:SetTextColor(1, .82, 0)
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

T.CVartogglebox = function(parent, x, y, value, name, arg1, arg2, tip)
	local bu = CreateFrame("CheckButton", G.uiname..value.."Button", parent, "UICheckButtonTemplate")
	bu:SetPoint("TOPLEFT", x, -y)
	T.ReskinCheck(bu)
	
	bu.Text:SetText(name)
	
	bu:SetScript("OnShow", function(self)
		if GetCVar(value) == arg1 then
			self:SetChecked(true)
		else
			self:SetChecked(false)
		end
	end)
	bu:SetScript("OnClick", function(self)
		if self:GetChecked() then
			SetCVar(value, arg1)
		else
			SetCVar(value, arg2)
		end
	end)
	
	bu:SetScript("OnDisable", function(self)
		bu.Text:SetTextColor(.5, .5, .5)
	end)
	
	bu:SetScript("OnEnable", function(self)
		bu.Text:SetTextColor(1, .82, 0)
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

-- 输入框
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

T.createinputbox = function(parent, points, text, width, link)
	local box = CreateFrame("EditBox", nil, parent, "BackdropTemplate")
	box:SetSize(width or 100, 20)
	if points then box:SetPoint(unpack(points)) end
	
	T.setPXBackdrop(box, .3)
	box:SetBackdropBorderColor(.5, .5, .5)
		
	box:SetFont(G.norFont, 12, "OUTLINE")
	box:SetAutoFocus(false)
	box:SetTextInsets(3, 0, 0, 0)
	
	box:SetScript("OnChar", function(self) 
		self.button:Show()
		self:SetBackdropBorderColor(1, 1, 0)		
	end)
	
	box:SetScript("OnEditFocusGained", function(self)
		self:SetBackdropBorderColor(1, 1, 1)
	end)
	
	box:SetScript("OnEditFocusLost", function(self)
		self:SetBackdropBorderColor(.5, .5, .5)
	end)
	
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
	
	box.button = T.createclickbutton(box, 0, {"RIGHT", box, "RIGHT", 0, 0}, OKAY)
	box.button:Hide()
	box.button:SetScript("OnClick", function()		
		box:GetScript("OnEnterPressed")(box)
	end)
	
	box:SetScript("OnEnable", function(self)	
		self:SetTextColor(1, 1, 1, 1)	
	end)
	
	box:SetScript("OnDisable", function(self)	
		self:SetTextColor(.7, .7, .7, .5)
	end)
	
	if link then
		table.insert(inputbox, box) -- 支持链接/文字/数字
	end
	
	return box
end

T.createeditbox = function(parent, x, y, name, table, value, tip)
	local box = CreateFrame("EditBox", nil, parent, "BackdropTemplate")
	box:SetSize(200, 20)
	
	T.setPXBackdrop(box, .3)
	box:SetBackdropBorderColor(.5, .5, .5)
	
	box:SetFont(G.norFont, 12, "OUTLINE")
	box:SetAutoFocus(false)
	box:SetTextInsets(3, 0, 0, 0)
	
	box.name = T.createtext(box, "OVERLAY", 12, "OUTLINE", "LEFT")
	box.name:SetPoint("LEFT", box, "RIGHT", 10, 1)
	box.name:SetText(name or "")
	
	box.button = T.createclickbutton(box, 0, {"RIGHT", box, "RIGHT", -2, 0}, OKAY)
	box.button:Hide()
	
	if x and y then
		box.name:SetPoint("TOPLEFT", parent, "TOPLEFT", x, -y)
		box:SetPoint("TOPLEFT", parent, "TOPLEFT", x+box.name:GetWidth()+5, -y+4)
	end
	
	box:SetScript("OnChar", function(self) self:SetBackdropBorderColor(1, 1, 0) end)
	box:SetScript("OnEditFocusGained", function(self) self:SetBackdropBorderColor(1, 1, 1) end)
	box:SetScript("OnEditFocusLost", function(self) self:SetBackdropBorderColor(.5, .5, .5) end)
	
	if table and value then
		box:SetScript("OnShow", function(self) 
			self:SetText(aCoreCDB[table][value])
		end)
		
		box:SetScript("OnEscapePressed", function(self)
			self:SetText(aCoreCDB[table][value])
			self:ClearFocus()
		end)
		
		box:SetScript("OnEnterPressed", function(self)
			self:ClearFocus()
			aCoreCDB[table][value] = self:GetText()
			if self.apply then
				self.apply()
			end
			self.button:Hide()
		end)
		
		box.button:SetScript("OnClick", function()
			box:ClearFocus()
			aCoreCDB[table][value] = box:GetText()
			if box.apply then
				box:apply()
			end
			box.button:Hide()
		end)
		
		parent[value] = box
	end
	
	box:SetScript("OnEnable", function(self)
		self.name:SetTextColor(1, 1, 1, 1)
		self:SetTextColor(1, 1, 1, 1)
		
	end)
	
	box:SetScript("OnDisable", function(self)
		self.name:SetTextColor(0.7, 0.7, 0.7, 0.5)
		self:SetTextColor(.7, .7, .7, .5)
	end)
	
	if tip then
		box:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -20, 10)
			GameTooltip:AddLine(tip)
			GameTooltip:Show() 
		end)
		box:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	end
	
	return box
end

T.createmultilinebox = function(parent, width, height, x, y, name, table, value, tip)
	local box = CreateFrame("ScrollFrame", nil, parent, "UIPanelScrollFrameTemplate")
	
	if x and y then
		box:SetPoint("TOPLEFT", x, -y)
	end
	
	box:SetSize(width or 200, height or 100)
	box:SetFrameLevel(parent:GetFrameLevel()+3)
	
	box.bg = T.createPXBackdrop(box, 1)

	box.top_text = T.createtext(box, "OVERLAY", 12, "OUTLINE", "LEFT")
	box.top_text:SetPoint("BOTTOMLEFT", box, "TOPLEFT", 5, 3)
	box.top_text:SetText(name or "")
	
	box.bottom_text = T.createtext(box, "OVERLAY", 10, "OUTLINE", "RIGHT")
	box.bottom_text:SetPoint("BOTTOMRIGHT", box, "BOTTOMRIGHT", -2, 2)

	box.anchor = CreateFrame("Frame", nil, box)
	box.anchor:SetPoint("TOP", box, "TOP", 0, -3)
	box.anchor:SetWidth(box:GetWidth())
	box.anchor:SetHeight(box:GetHeight())
	box.anchor:SetFrameLevel(box:GetFrameLevel()+1)
	box:SetScrollChild(box.anchor)

	box.edit = CreateFrame("EditBox", nil, box.anchor)
	box.edit:SetTextInsets(5, 5, 5, 5)
	box.edit:SetFrameLevel(box.anchor:GetFrameLevel()+1)
	box.edit:SetAllPoints()
	
	box.edit:SetFont(G.norFont, 12, "OUTLINE")
	box.edit:SetMultiLine(true)
	box.edit:EnableMouse(true)
	box.edit:SetAutoFocus(false)
	
	box.edit:SetScript("OnChar", function(self) box.bg:SetBackdropBorderColor(1, 1, 0) end)
	box.edit:SetScript("OnEditFocusGained", function(self) box.bg:SetBackdropBorderColor(1, 1, 1) end)
	box.edit:SetScript("OnEditFocusLost", function(self) box.bg:SetBackdropBorderColor(.5, .5, .5) end)
		
	box.button1 = T.createclickbutton(box, 99, {"TOPRIGHT", box, "BOTTOM", -1, -2}, ACCEPT)	
	box.button2 = T.createclickbutton(box, 99, {"TOPLEFT", box, "BOTTOM", 1, -2}, CANCEL)	
	
	if table and value then
		box.edit:SetScript("OnShow", function(self)
			self:SetText(aCoreCDB[table][value])
		end)
	
		box.button1:SetScript("OnClick", function()
			box.edit:ClearFocus()
			aCoreCDB[table][value] = box.edit:GetText()
			if box.apply then
				box:apply()
			end
		end)
		
		box.button2:SetScript("OnClick", function()
			box.edit:ClearFocus()
			box.edit:SetText(aCoreCDB[table][value])
		end)
		
		parent[value] = box
	end
	
	T.ReskinScroll(box.ScrollBar)

	box.Enable = function()
		box.top_text:SetTextColor(1, 1, 1, 1)		
		box.edit:SetTextColor(1, 1, 1, 1)
		box.edit:Enable()
	end
	
	box.Disable = function()	
		box.top_text:SetTextColor(0.7, 0.7, 0.7, 0.5)
		box.edit:SetTextColor(0.7, 0.7, 0.7, 0.5)
		box.edit:Disable()
	end
	
	if tip then
		box.edit:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -20, 10)
			GameTooltip:AddLine(tip)
			GameTooltip:Show() 
		end)
		box.edit:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	end
		
	return box
end

-- 滑动条
local function TestSlider_OnValueChanged(self, value)
   if not self._onsetting then   -- is single threaded 
     self._onsetting = true
     self:SetValue(self:GetValue())
     value = self:GetValue()     -- cant use original 'value' parameter
     self._onsetting = false
   else return end               -- ignore recursion for actual event handler
 end
T.TestSlider_OnValueChanged = TestSlider_OnValueChanged

T.createslider = function(parent, width, x, y, name, table, value, divisor, min, max, step, tip)
	local slider = CreateFrame("Slider", G.uiname..value.."Slider", parent, "OptionsSliderTemplate")
	slider:SetPoint("TOPLEFT", x, -y)
	slider:SetSize((width == "short" and 170) or (width == "long" and 220) or width, 8)

	T.ReskinSlider(slider)
	
	getmetatable(slider).__index.Enable(slider)
	
	slider:SetMinMaxValues(min, max)
	slider:SetValueStep(step)
	
	slider.Low:SetText(min/divisor)
	slider.High:SetText(max/divisor)
	
	slider:SetScript("OnShow", function(self)
		self:SetValue((aCoreCDB[table][value])*divisor)
		self.Text:SetText(name.." |cFF00FFFF"..aCoreCDB[table][value].."|r")
	end)
	
	slider:SetScript("OnValueChanged", function(self, getvalue)
		aCoreCDB[table][value] = getvalue/divisor
		TestSlider_OnValueChanged(self, getvalue)
		self.Text:SetText(name.." |cFF00FFFF"..aCoreCDB[table][value].."|r")
		if self.apply then
			self.apply()
		end
	end)
	
	if tip then slider.tooltipText = tip end
	
	slider.Enable = function()
		getmetatable(slider).__index.Enable(slider)
		slider.Text:SetTextColor(1, 1, 1, 1)
		slider.Low:SetTextColor(1, 1, 1, 1)
		slider.High:SetTextColor(1, 1, 1, 1)
		slider.Thumb:Show()
	end
	
	slider.Disable = function()
		getmetatable(slider).__index.Disable(slider)
		slider.Text:SetTextColor(0.7, 0.7, 0.7, 0.5)
		slider.Low:SetTextColor(0.7, 0.7, 0.7, 0.5)
		slider.High:SetTextColor(0.7, 0.7, 0.7, 0.5)
		slider.Thumb:Hide()
	end
	
	parent[value] = slider
end

-- 取色按钮
T.ColorPicker_OnClick = function(colors, has_opacity, points, apply)
	local r, g, b, a = colors.r, colors.g, colors.b, colors.a
	
	ColorPickerFrame:ClearAllPoints()
	if points then
		ColorPickerFrame:SetPoint(unpack(points))
	else
		ColorPickerFrame:SetPoint("CENTER", UIParent, "CENTER")
	end
	
	ColorPickerFrame.previousValues = {r = r, g = g, b = b, opacity = a}
	
	ColorPickerFrame.swatchFunc = function()
		colors.r, colors.g, colors.b = ColorPickerFrame:GetColorRGB()
		if apply then
			apply()
		end
	end
	
	ColorPickerFrame.cancelFunc = function()
		colors.r, colors.g, colors.b, colors.a = r, g, b, a
		if apply then
			apply()
		end
	end

	if a then
		ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = true, a		
		ColorPickerFrame.opacityFunc = function()
			colors.a = ColorPickerFrame:GetColorAlpha()
		end
	end
	
	ColorPickerFrame.Content.ColorPicker:SetColorRGB(r, g, b)
	ColorPickerFrame:Hide()
	ColorPickerFrame:Show()
end

T.createcolorpickerbu = function(parent, x, y, name, table, value)
	local cpb = CreateFrame("Button", G.uiname..value.."ColorPickerButton", parent, "UIPanelButtonTemplate")
	cpb:SetPoint("TOPLEFT", x+3, -y)
	cpb:SetSize(20, 20)
	T.ReskinButton(cpb)
	
	cpb.ctex = cpb:CreateTexture(nil, "OVERLAY")
	cpb.ctex:SetTexture(G.media.blank)
	cpb.ctex:SetPoint"CENTER"
	cpb.ctex:SetSize(15, 15)

	cpb.name = T.createtext(cpb, "OVERLAY", 12, "OUTLINE", "LEFT")
	cpb.name:SetPoint("LEFT", cpb, "RIGHT", 10, 1)
	cpb.name:SetText(name)

	cpb.apply_settings = function()
		cpb.ctex:SetVertexColor(aCoreCDB[table][value].r, aCoreCDB[table][value].g, aCoreCDB[table][value].b)
		if cpb.apply then
			cpb.apply()
		end
	end
	
	cpb:SetScript("OnShow", function(self) 
		self.ctex:SetVertexColor(aCoreCDB[table][value].r, aCoreCDB[table][value].g, aCoreCDB[table][value].b)
	end)
	
	cpb:SetScript("OnClick", function(self)
		T.ColorPicker_OnClick(aCoreCDB[table][value], nil, nil, cpb.apply_settings)
	end)
	
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
		cpb:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	end
	
	parent[value] = cpb
end

-- 多选一按钮
T.createradiobuttongroup = function(parent, x, y, name, value, group)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetPoint("TOPLEFT", x, -y)
	frame:SetSize(150, 30)
	frame.buttons = {}
	
	frame.text = T.createtext(frame, "OVERLAY", 12, "OUTLINE", "LEFT")
	frame.text:SetPoint("LEFT", 0, 0)
	frame.text:SetText(name)
	
	for i, info in T.pairsByKeys(group) do
		local bu = CreateFrame("CheckButton", nil, frame, "UIRadioButtonTemplate")
		T.ReskinRadio(bu)
		
		if i == 1 then			
			bu:SetPoint("LEFT", frame.text, "RIGHT", 10, 1)	
		else
			bu:SetPoint("LEFT", frame.buttons[i-1].text, "RIGHT", 5, 0)
		end

		bu.text:SetText(info[2])
		
		bu:SetScript("OnShow", function(self)
			self:SetChecked(aCoreCDB[parent.db_key][value] == info[1])
		end)
		
		bu:SetScript("OnClick", function(self)
			if self:GetChecked() then
				aCoreCDB[parent.db_key][value] = info[1]
				if frame.apply then
					frame.apply()
				end
				for i, b in pairs(frame.buttons) do
					if b ~= self then
						b:SetChecked(false)
					end
				end
			else
				self:SetChecked(true)
			end
		end)
		
		bu:SetScript("OnDisable", function(self)
			self:GetCheckedTexture():SetVertexColor(.5, .5, .5, 1)
			self.text:SetTextColor(.5, .5, .5)
		end)
		
		bu:SetScript("OnEnable", function(self)
			self:GetCheckedTexture():SetVertexColor(0, .9, .3, 1)
			self.text:SetTextColor(1, .82, 0)
		end)
		
		frame.buttons[i] = bu
	end
		
	frame.Enable = function()
		frame.text:SetTextColor(1, 1, 1, 1)
		for i, bu in pairs(frame.buttons) do
			bu:Enable()
		end
	end
	
	frame.Disable = function()
		frame.text:SetTextColor(0.7, 0.7, 0.7, 0.5)
		for i, bu in pairs(frame.buttons) do
			bu:Disable()
		end		
	end
	
	parent[value] = frame
end

T.createbuttongroup = function(parent, width, x, y, hasvalue, table, value, group, order)
	local frame = CreateFrame("Frame", G.uiname..value.."BoxGroup", parent)
	frame:SetPoint("TOPLEFT", x, -y)
	frame:SetSize(width, 25)
	
	local num = 0
	for key, value in pairs(group) do
		num = num + 1
	end
	button_width = (width+10)/num-10
	
	local key = 1
	for k, v in T.pairsByKeys(group) do
		frame[k] = CreateFrame("Button", G.uiname..value..k.."BoxGroup", frame, "UIPanelButtonTemplate")
		frame[k]:SetSize(button_width, 25)
		frame[k].order = order and order[k] or key
		T.ReskinButton(frame[k], nil, true)
		
		frame[k].Text:SetText(v)
		frame[k].Text:SetTextColor(1, 1, 1)
		
		if hasvalue then
			frame[k]:SetScript("OnShow", function(self)
				if self:IsEnabled() then 
					if aCoreCDB[table][value] == k then
						frame[k].Text:SetTextColor(1, 1, 0)
					else
						frame[k].Text:SetTextColor(1, 1, 1)
					end
				end
			end)
			
			frame[k]:SetScript("OnClick", function(self)
				aCoreCDB[table][value] = k
				frame[k].Text:SetTextColor(1, 1, 0)
			end)
		end
		
		local function Button_OnEnter(self)
			if not self:IsEnabled() then return end
	
			if AuroraClassicDB.FlatMode then
				self.__gradient:SetVertexColor(G.Ccolor.r / 4, G.Ccolor.g / 4, G.Ccolor.b / 4)
			else
				self.__bg:SetBackdropColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b, .25)
			end
			self.__bg:SetBackdropBorderColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
		end
		local function Button_OnLeave(self)
			if not self:IsEnabled() then return end
			
			if AuroraClassicDB.FlatMode then
				self.__gradient:SetVertexColor(.3, .3, .3, .25)
			else
				self.__bg:SetBackdropColor(0, 0, 0, 0)
			end
			self.__bg:SetBackdropBorderColor(0, 0, 0)
		end
	
		frame[k]:HookScript("OnEnable", function(self)
			if self:IsMouseOver() then
				Button_OnEnter(self)
			else
				Button_OnLeave(self)
			end
			if hasvalue then
				if aCoreCDB[table][value] == k then
					self.Text:SetTextColor(1, 1, 0)
				else
					self.Text:SetTextColor(1, 1, 1)
				end
			else
				self.Text:SetTextColor(1, 1, 1)
			end
		end)
		
		frame[k]:HookScript("OnDisable", function(self)
			if AuroraClassicDB.FlatMode then
				self.__gradient:SetVertexColor(.3, .3, .3, .25)
			else
				self.__bg:SetBackdropColor(.3, .3, .3, .5)
			end
			self.__bg:SetBackdropBorderColor(.3, .3, .3)
			self.Text:SetTextColor(.3, .3, .3)
		end)
		
		frame[k]:HookScript("OnEnter", Button_OnEnter)		
		frame[k]:HookScript("OnLeave", Button_OnLeave)
		
		key = key + 1
	end
	
	if hasvalue then
		for k, v in T.pairsByKeys(group) do
			frame[k]:HookScript("OnClick", function(self)
				if aCoreCDB[table][value] == k then
					for key, value in T.pairsByKeys(group) do
						if key ~= k then
							frame[key].Text:SetTextColor(1, 1, 1)
						end
					end
				end
			end)
		end
	end
	
	local buttons = {frame:GetChildren()}
	
	if order then
		sort(buttons, function(a,b) return a.order < b.order end)
	end
	
	for i = 1, #buttons do
		if i == 1 then
			buttons[i]:SetPoint("LEFT", frame, "LEFT", 0, 0)
		else
			buttons[i]:SetPoint("LEFT", buttons[i-1], "RIGHT", 10, 0)
		end

	end
	
	parent[value] = frame
end

-- 普通按钮
T.createclickbutton = function(parent, width, points, text, tex)
	local bu = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	
	if points then
		bu:SetPoint(unpack(points))
	end
	
	bu:SetText(text or "")
	
	T.ReskinButton(bu)

	if width == 0 then
		bu:SetSize(bu.Text:GetWidth() + 5, 20)
	else
		bu:SetSize(width, 20)
	end
	
	if tex then
		bu.tex = bu:CreateTexture(nil, "ARTWORK")
		bu.tex:SetAllPoints(bu)
		bu.tex:SetTexture(tex)
	end

	return bu
end

T.createclicktexbutton = function(parent, points, tex, text, tex_size)
	local bu = CreateFrame("Button", nil, parent)
	bu:SetPoint(unpack(points))
	
	bu.tex = bu:CreateTexture(nil, "ARTWORK")
	bu.tex:SetPoint("LEFT", bu, "LEFT", 3, 0)
	bu.tex:SetTexture(tex)
	bu.tex:SetSize(tex_size or 15, tex_size or 15)
	bu.tex:SetVertexColor(.5, .5, .5)
	bu.tex:SetBlendMode("ADD")
	
	bu.hl_tex = bu:CreateTexture(nil, "HIGHLIGHT")
	bu.hl_tex:SetAllPoints()
	bu.hl_tex:SetColorTexture(.7, .7, .7, .2)
	
	bu.text = T.createtext(bu, "OVERLAY", 12, "OUTLINE", "LEFT")
	bu.text:SetPoint("LEFT", tex and bu.tex or bu,  tex and "RIGHT" or "LEFT", 2, 0)
	bu.text:SetTextColor(.5, .5, .5)
	bu.text:SetText(text)
	
	bu:SetHeight(20)
	bu:SetWidth((tex and 22) + bu.text:GetWidth() + (text and 2 or 0))
	
	bu:EnableMouse(true)
	
	return bu
end
-----------------------------
--        设置列表         --
-----------------------------
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
	local w = width or 320
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
		sf.bg = T.createBackdrop(sf, .3)
	end
	
	T.ReskinScroll(sf.ScrollBar)
	
	sf.cover = CreateFrame("Frame", nil, sf)
	sf.cover:SetAllPoints()
	sf.cover:SetFrameLevel(sf.anchor:GetFrameLevel()+5)
	
	sf.cover.tex = sf.cover:CreateTexture(nil, "OVERLAY")
	sf.cover.tex:SetAllPoints()
	sf.cover.tex:SetColorTexture(.3, .3, .3, .7)
	sf.cover:EnableMouse(true)
	sf.cover:Hide()
	
	sf.Enable = function()
		sf.cover:Hide()
	end
	
	sf.Disable = function()
		sf.cover:Show()
	end
	
	sf.list = {}
	
	return sf
end
T.createscrolllist = createscrolllist

local createscrollbutton = function(type, option_list, table, value, key)
	local bu = CreateFrame("Frame", nil, option_list.anchor, "BackdropTemplate")
	bu:SetSize(300, 28)
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
		aCoreCDB[table][value][key] = nil
		lineuplist(aCoreCDB[table][value], option_list.list, option_list.anchor)
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
local function CreateListOption(parent, points, height, text, OptionName, input_text_1, input_text_2)
	local frame = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	frame:SetSize(400, height)
	frame:SetPoint(unpack(points))
	frame.options = {}
	frame.db_key = parent.db_key
	
	frame.title = T.createtext(frame, "OVERLAY", 14, "OUTLINE", "LEFT")
	frame.title:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
	frame.title:SetText(text)
	
	frame.reset = T.createclicktexbutton(frame, {"LEFT", frame.title, "RIGHT", 10, 0}, [[Interface\AddOns\AltzUI\media\icons\refresh.tga]], L["重置"])
	table.insert(frame.options, frame.reset)
	frame.reset:SetScript("OnClick", function(self)
		StaticPopupDialogs[G.uiname.."Reset Confirm"].text = format(L["重置确认"], T.color_text(parent.title:GetText()..text))
		StaticPopupDialogs[G.uiname.."Reset Confirm"].OnAccept = function()
			aCoreCDB[frame.db_key][OptionName] = nil
			if frame.reset.apply then
				frame.reset.apply()
			end
			ReloadUI()
		end
		StaticPopup_Show(G.uiname.."Reset Confirm")
	end)

	frame.option_list = createscrolllist(frame, {"TOPLEFT", 0, -45}, true, nil, height - 70)
	table.insert(frame.options, frame.option_list)
	frame.first_input = T.createinputbox(frame, {"TOPLEFT", 0, -20}, input_text_1, 160)
	table.insert(frame.options, frame.first_input)
	if input_text_2 then
		frame.second_input = T.createinputbox(frame, {"LEFT", frame.first_input, "RIGHT", 10, 0}, input_text_2, 80)
		table.insert(frame.options, frame.second_input)
	end
	frame.addbutton = T.createclickbutton(frame, 0, {"LEFT", frame.second_input or frame.first_input, "RIGHT", 10, 0}, ADD)
	table.insert(frame.options, frame.first_input)
	
	frame.Enable = function()		
		for k, v in pairs(frame.options) do
			v:Enable()
		end
	end
	
	frame.Disable = function()
		for k, v in pairs(frame.options) do
			v:Disable()
		end
	end
	
	return frame
end

-- 列表按钮
local function CreateListButton(type, frame, OptionName, key, Icon, left_text, mid_text, right_text, color)
	local bu = frame.option_list.list[key]
	
	if not bu then
		bu = createscrollbutton(type, frame.option_list, frame.db_key, OptionName, key)
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
					frame.cpb.colors.r, frame.cpb.colors.g, frame.cpb.colors.b = color.r, color.g, color.b
					frame.cpb.update_texcolor()
				end
			end)
		end
	end
	bu.display(Icon, left_text, mid_text, right_text, color)
	bu:Show()
end

T.CreateAuraListOption = function(parent, points, height, text, OptionName, input_text_2)
	local frame = CreateListOption(parent, points, height, text, OptionName, L["输入法术ID"], input_text_2)

	frame.Button_OnClicked = function(bu)
		frame.first_input.current_spellID = tonumber(bu.mid:GetText())
	end
	
	frame:SetScript("OnShow", function()
		for spellID, level in pairs(aCoreCDB[frame.db_key][OptionName]) do
			local spellName, _, spellIcon = GetSpellInfo(spellID)
			if spellName then
				CreateListButton("spell", frame, OptionName, spellID, spellIcon, spellName, spellID, input_text_2 and level)
			else
				print("spell ID "..spellID.." is gone, delete it.")
				aCoreCDB[frame.db_key][OptionName][spellID] = nil
			end
		end
		lineuplist(aCoreCDB[frame.db_key][OptionName], frame.option_list.list, frame.option_list.anchor)
	end)
	
	frame.first_input:HookScript("OnChar", function(self) 
		self.current_spellID = nil
	end)
	
	function frame.first_input:apply()
		if self.current_spellID then
			return true
		else
			local spellText = self:GetText()		
			local spellName, _, spellIcon, _, _, _, spellID = GetSpellInfo(spellText)
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
			
			local spellName, _, spellIcon, _, _, _, spellID = GetSpellInfo(frame.first_input.current_spellID)
			local level = frame.second_input:GetText()
			
			aCoreCDB[frame.db_key][OptionName][spellID] = tonumber(level)
			CreateListButton("spell", frame, OptionName, spellID, spellIcon, spellName, spellID, level)
			
			lineuplist(aCoreCDB[frame.db_key][OptionName], frame.option_list.list, frame.option_list.anchor)
			
			frame.first_input:SetText(L["输入法术ID"])
			frame.first_input.current_spellID = nil
			frame.second_input:SetText(input_text_2)
			
			frame.apply() -- 生效
		else
			frame.first_input:GetScript("OnEnterPressed")(frame.first_input)
			if not frame.first_input:apply() then return end
			
			local spellName, _, spellIcon, _, _, _, spellID = GetSpellInfo(frame.first_input.current_spellID)
			
			aCoreCDB[frame.db_key][OptionName][spellID] = true
			CreateListButton("spell", frame, OptionName, spellID, spellIcon, spellName, spellID)
			
			lineuplist(aCoreCDB[frame.db_key][OptionName], frame.option_list.list, frame.option_list.anchor)
			frame.first_input:SetText(L["输入法术ID"])
			frame.first_input.current_spellID = nil
			
			frame.apply() -- 生效
		end
	end)
	
	return frame
end

T.CreateItemListOption = function(parent, points, height, text, OptionName, input_text_2)
	local frame = CreateListOption(parent, points, height, text, OptionName, L["物品名称ID链接"], input_text_2)
	
	frame:SetScript("OnShow", function()
		for itemID, quantity in pairs(aCoreCDB[frame.db_key][OptionName]) do
			local itemName = GetItemInfo(itemID)
			local itemIcon = select(10, GetItemInfo(itemID))
			if itemName then
				CreateListButton("item", frame, OptionName, itemID, itemIcon, itemName, nil, input_text_2 and quantity)
			else
				print("item ID "..itemID.." is gone, delete it.")
				aCoreCDB[frame.db_key][OptionName][itemID] = nil
			end
		end
		lineuplist(aCoreCDB[frame.db_key][OptionName], frame.option_list.list, frame.option_list.anchor)
	end)
	
	table.insert(inputbox, frame.first_input) -- 支持链接/文字/数字
	function frame.first_input:apply()
		local itemText = self:GetText()
		local itemID = GetItemInfoInstant(itemText)
		if itemID then
			local itemName = GetItemInfo(itemID)
			self:SetText(itemName)
			return true
		else
			StaticPopupDialogs[G.uiname.."incorrect itemID"].text = T.color_text((itemText == L["物品名称ID链接"] and "") or itemText)..L["不正确的物品ID"]
			StaticPopup_Show(G.uiname.."incorrect itemID")
			self:SetText(L["物品名称ID链接"])
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
			
			local itemText = frame.first_input:GetText()
			local quantity = frame.second_input:GetText()
			local itemID, _, _, _, itemIcon = GetItemInfoInstant(itemText)
			
			local itemName = GetItemInfo(itemID)
			aCoreCDB[frame.db_key][OptionName][itemID] = quantity
			CreateListButton("item", frame, OptionName, itemID, itemIcon, itemName, nil, quantity)
			
			lineuplist(aCoreCDB[frame.db_key][OptionName], frame.option_list.list, frame.option_list.anchor)
			frame.first_input:SetText(L["物品名称ID链接"])
			frame.second_input:SetText(input_text_2)
			
			frame.apply() -- 生效
		else
			frame.first_input:GetScript("OnEnterPressed")(frame.first_input)
			if not frame.first_input:apply() then return end
			
			local itemText = frame.first_input:GetText()	
			local itemID, _, _, _, itemIcon = GetItemInfoInstant(itemText) 
			
			local itemName = GetItemInfo(itemID)
			aCoreCDB[frame.db_key][OptionName][itemID] = true
			CreateListButton("item", frame, OptionName, itemID, itemIcon, itemName)
			
			lineuplist(aCoreCDB[frame.db_key][OptionName], frame.option_list.list, frame.option_list.anchor)
			frame.first_input:SetText(L["物品名称ID链接"])
			
			frame.apply() -- 生效
		end
	end)

	return frame
end

T.CreatePlateColorListOption = function(parent, points, height, text, OptionName)
	local frame = CreateListOption(parent, points, height, text, OptionName, L["输入npc名称"])
	
	frame:SetScript("OnShow", function()
		for name, color in pairs(aCoreCDB[frame.db_key][OptionName]) do
			CreateListButton("", frame, OptionName, name, nil, name, nil, nil, color)
		end
		lineuplist(aCoreCDB[frame.db_key][OptionName], frame.option_list.list, frame.option_list.anchor)
	end)
	
	frame.cpb = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	frame.cpb:SetPoint("LEFT", frame.first_input, "RIGHT", 5, 0)
	frame.cpb:SetSize(40, 20)
	T.ReskinButton(frame.cpb)
	
	frame.cpb.ctex = frame.cpb:CreateTexture(nil, "OVERLAY")
	frame.cpb.ctex:SetTexture(G.media.blank)
	frame.cpb.ctex:SetPoint("CENTER")
	frame.cpb.ctex:SetSize(35, 15)
	
	frame.cpb.colors = {r = 1, g = 1, b = 1}
	frame.cpb.update_texcolor = function()
		frame.cpb.ctex:SetVertexColor(frame.cpb.colors.r, frame.cpb.colors.g, frame.cpb.colors.b)
	end
	
	frame.cpb:SetScript("OnClick", function(self)
		T.ColorPicker_OnClick(frame.cpb.colors, false, {"TOPLEFT", frame.cpb, "BOTTOMLEFT", 0, -5}, frame.cpb.update_texcolor)
	end)
	
	frame.addbutton:ClearAllPoints()
	frame.addbutton:SetPoint("LEFT", frame.cpb, "RIGHT", 5, 0)
	
	frame.addbutton:SetScript("OnClick", function(self)
		frame.first_input:GetScript("OnEnterPressed")(frame.first_input)
		
		local name = frame.first_input:GetText()
		if not aCoreCDB[frame.db_key][OptionName][name] then
			aCoreCDB[frame.db_key][OptionName][name] = {}		
		end
		aCoreCDB[frame.db_key][OptionName][name].r = frame.cpb.colors.r
		aCoreCDB[frame.db_key][OptionName][name].g = frame.cpb.colors.g
		aCoreCDB[frame.db_key][OptionName][name].b = frame.cpb.colors.b
		
		CreateListButton("", frame, OptionName, name, nil, name, nil, nil, frame.cpb.colors)
		
		lineuplist(aCoreCDB[frame.db_key][OptionName], frame.option_list.list, frame.option_list.anchor)
		
		frame.first_input:SetText(L["输入npc名称"])
		frame.cpb.colors.r, frame.cpb.colors.g, frame.cpb.colors.b = 1, 1, 1
		frame.cpb.update_texcolor()
		
		frame.apply() -- 生效
	end)

	return frame
end

T.CreatePlatePowerListOption = function(parent, points, height, text, OptionName)
	local frame = CreateListOption(parent, points, height, text, OptionName, L["输入npc名称"])

	frame:SetScript("OnShow", function()
		for name, _ in pairs(aCoreCDB[frame.db_key][OptionName]) do
			CreateListButton("", frame, OptionName, name, nil, name)
		end
		lineuplist(aCoreCDB[frame.db_key][OptionName], frame.option_list.list, frame.option_list.anchor)
	end)
	
	frame.addbutton:SetScript("OnClick", function(self)
		frame.first_input:GetScript("OnEnterPressed")(frame.first_input)
		
		local name = frame.first_input:GetText()	
		aCoreCDB[frame.db_key][OptionName][name] = true
		
		CreateListButton("", frame, OptionName, name, nil, name)

		lineuplist(aCoreCDB[frame.db_key][OptionName], frame.option_list.list, frame.option_list.anchor)
		
		frame.first_input:SetText(L["输入npc名称"])
		
		frame.apply() -- 生效
	end)

	return frame
end