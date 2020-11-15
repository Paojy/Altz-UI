﻿local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)

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

T.resize_font = function(t, size)
	if not size then
		t:SetFont(G.norFont, 12, "OUTLINE")
	else
		t:SetFont(G.norFont, size, "OUTLINE")
	end
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

T.CreateOptionSwitchButton = function(parent, width, height, ...)
	local bu = CreateFrame("Button", nil, bu, "UIPanelButtonTemplate")
	bu:SetSize(width, height)
	bu:SetPoint(...)
	F.Reskin(bu)
	_G[bu:GetName() .. "Text"]:SetFont(G.norFont, 10, "NONE")
	_G[bu:GetName() .. "Text"]:SetWidth(80)
	_G[bu:GetName() .. "Text"]:SetHeight(18)
	
	return bu
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
	ChatFrame1:SetSize(300, 150)
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

T.ResetAurora = function(reload)
	if IsAddOnLoaded("AuroraClassic") then
		AuroraClassicDB["Bags"] = false
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
			DBM.Bars:SetSkin("AltzUI")		
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
			DBM_AllSavedOptions["Default"]["WarningFont"] = "Interface\\AddOns\\AuroraClassic\\media\\font.ttf"
			DBM_AllSavedOptions["Default"]["WarningFontShadow"] = true
			DBM_AllSavedOptions["Default"]["WarningPoint"] = "TOP"
			DBM_AllSavedOptions["Default"]["WarningY"] = -150
			DBM_AllSavedOptions["Default"]["WarningX"] = -0
			-- 特殊警报
			DBM_AllSavedOptions["Default"]["SpecialWarningFontSize"] = 65
			DBM_AllSavedOptions["Default"]["SpecialWarningFont"] = "Interface\\AddOns\\AuroraClassic\\media\\font.ttf"
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

T.createcheckbutton = function(parent, x, y, name, table, value, tip)
	local bu = CreateFrame("CheckButton", G.uiname..value.."Button", parent, "InterfaceOptionsCheckButtonTemplate")
	bu:SetPoint("TOPLEFT", x, -y)
	F.ReskinCheck(bu)
	
	bu.Text:SetText(name)
	T.resize_font(bu.Text)
	
	bu:SetScript("OnShow", function(self) self:SetChecked(aCoreCDB[table][value]) end)
	bu:SetScript("OnClick", function(self)
		if self:GetChecked() then
			aCoreCDB[table][value] = true
		else
			aCoreCDB[table][value] = false
		end
	end)
	
	bu:SetScript("OnDisable", function(self)
		local tex = select(6, bu:GetRegions())
		tex:SetVertexColor(.7, .7, .7, .5)
	end)
	
	bu:SetScript("OnEnable", function(self)
		local tex = select(6, bu:GetRegions())
		tex:SetVertexColor(1, 1, 1, 1)
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
	
	bu.Text:SetText(name)
	T.resize_font(bu.Text)
	
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

T.CVartogglebox = function(parent, x, y, value, name, arg1, arg2, tip)
	local bu = CreateFrame("CheckButton", G.uiname..value.."Button", parent, "InterfaceOptionsCheckButtonTemplate")
	bu:SetPoint("TOPLEFT", x, -y)
	F.ReskinCheck(bu)
	
	bu.Text:SetText(name)
	T.resize_font(bu.Text)
	
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

T.createeditbox = function(parent, x, y, name, table, value, tip)
	local box = CreateFrame("EditBox", G.uiname..value.."EditBox", parent)
	box:SetSize(180, 20)
	box:SetPoint("TOPLEFT", x, -y)
	
	local bd = CreateFrame("Frame", nil, box, "BackdropTemplate")
	bd:SetPoint("TOPLEFT", -2, 0)
	bd:SetPoint("BOTTOMRIGHT")
	bd:SetFrameLevel(box:GetFrameLevel()-1)
	F.CreateBD(bd, 0)
	
	local gradient = F.CreateGradient(box)
	gradient:SetPoint("TOPLEFT", bd, 0, 0)
	gradient:SetPoint("BOTTOMRIGHT", bd, 0, 0)
	
	box.name = box:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	box.name:SetPoint("LEFT", box, "RIGHT", 10, 1)
	box.name:SetText(name)
	T.resize_font(box.name)
	
	box:SetFont(GameFontHighlight:GetFont(), 12, "OUTLINE")
	box:SetAutoFocus(false)
	box:SetTextInsets(3, 0, 0, 0)
	
	box:SetScript("OnShow", function(self) self:SetText(aCoreCDB[table][value]) end)
	box:SetScript("OnEscapePressed", function(self) self:SetText(aCoreCDB[table][value]) self:ClearFocus() end)
	box:SetScript("OnEnterPressed", function(self) self:ClearFocus() aCoreCDB[table][value] = self:GetText() end)
	
	box:SetScript("OnEnable", function(self)
		self.name:SetTextColor(1, 1, 1, 1)
		self:SetTextColor(1, 1, 1, 1)
		gradient:SetGradientAlpha("Vertical", 0, 0, 0, .5, .3, .3, .3, .3)
	end)
	
	box:SetScript("OnDisable", function(self)
		self.name:SetTextColor(0.7, 0.7, 0.7, 0.5)
		self:SetTextColor(.7, .7, .7, .5)
		gradient:SetVertexColor(.5, .5, .5, .3)
	end)
	
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
	scrollBG.bg = CreateFrame("Frame", nil, scrollBG, "BackdropTemplate")
	scrollBG.bg:SetAllPoints(scrollBG)
	F.CreateBD(scrollBG.bg, 0)
	
	local gradient = F.CreateGradient(scrollBG.bg)
	gradient:SetPoint("TOPLEFT", scrollBG.bg, 0, 0)
	gradient:SetPoint("BOTTOMRIGHT", scrollBG.bg, 0, 0)
	
	if name then
		scrollBG.name = scrollBG:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		scrollBG.name:SetPoint("BOTTOMLEFT", scrollBG, "TOPLEFT", 5, 8)
		scrollBG.name:SetJustifyH("LEFT")
		scrollBG.name:SetText(name)
		T.resize_font(scrollBG.name)
	end
	
	local scrollAC = CreateFrame("Frame", G.uiname..value.."MultiLineEditBox_ScrollAC", scrollBG)
	scrollAC:SetPoint("TOP", scrollBG, "TOP", 0, -3)
	scrollAC:SetWidth(scrollBG:GetWidth())
	scrollAC:SetHeight(scrollBG:GetHeight())
	scrollAC:SetFrameLevel(scrollBG:GetFrameLevel()+1)
	scrollBG:SetScrollChild(scrollAC)

	scrollBG.edit = CreateFrame("EditBox", G.uiname..value.."MultiLineEditBox", scrollAC)
	scrollBG.edit:SetTextInsets(5, 5, 5, 5)
	scrollBG.edit:SetFrameLevel(scrollAC:GetFrameLevel()+1)
	scrollBG.edit:SetAllPoints()
	if value == "Import" then
		scrollBG.edit:SetFont(G.norFont, 10, "NONE")
	else
		scrollBG.edit:SetFontObject(ChatFontNormal)
	end
	scrollBG.edit:SetMultiLine(true)
	scrollBG.edit:EnableMouse(true)
	scrollBG.edit:SetAutoFocus(false)
	
	if table then
		scrollBG.edit:SetScript("OnShow", function(self) self:SetText(aCoreCDB[table][value]) end)
		scrollBG.edit:SetScript("OnEscapePressed", function(self) self:SetText(aCoreCDB[table][value]) self:ClearFocus() end)
		scrollBG.edit:SetScript("OnEnterPressed", function(self) self:ClearFocus() aCoreCDB[table][value] = self:GetText() end)
	end
	
	F.ReskinScroll(_G[G.uiname..value.."MultiLineEditBox_BGScrollBar"])
		
	if tip then
		scrollBG.edit:SetScript("OnEnter", function(self) 
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -20, 10)
			GameTooltip:AddLine(tip)
			GameTooltip:Show() 
		end)
		scrollBG.edit:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	end
	
	scrollBG.Enable = function()
		if name then
			scrollBG.name:SetTextColor(1, 1, 1, 1)
		end
		gradient:SetGradientAlpha("Vertical", 0, 0, 0, .5, .3, .3, .3, .3)
		scrollBG.edit:SetTextColor(1, 1, 1, 1)
		scrollBG.edit:Enable()
	end
	
	scrollBG.Disable = function()	
		if name then
			scrollBG.name:SetTextColor(0.7, 0.7, 0.7, 0.5)
		end
		gradient:SetVertexColor(.5, .5, .5, .3)
		scrollBG.edit:SetTextColor(0.7, 0.7, 0.7, 0.5)
		scrollBG.edit:Disable()
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
	slider:SetSize(220, 8)
	F.ReskinSlider(slider)
	BlizzardOptionsPanel_Slider_Enable(slider)
	slider:SetMinMaxValues(min, max)
	
	slider.Low:SetText(min/divisor)
	slider.Low:ClearAllPoints()
	slider.Low:SetPoint("RIGHT", slider, "LEFT", 15, 0)
	slider.Low:SetFont(G.norFont, 10, "OUTLINE")
	
	slider.High:SetText(max/divisor)
	slider.High:ClearAllPoints()
	slider.High:SetPoint("LEFT", slider, "RIGHT", -15, 0)
	slider.High:SetFont(G.norFont, 10, "OUTLINE")
	
	slider.Text:ClearAllPoints()
	slider.Text:SetPoint("BOTTOM", slider, "TOP", 0, 3)
	slider.Text:SetFontObject(GameFontHighlight)
	T.resize_font(slider.Text)
	
	slider.Thumb:SetSize(25, 16)
	
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
	
	slider.Enable = function()
		BlizzardOptionsPanel_Slider_Enable(slider)
	end
	
	slider.Disable = function()
		BlizzardOptionsPanel_Slider_Disable(slider)
	end
	
	parent[value] = slider
end

T.createcolorpickerbu = function(parent, x, y, name, table, value)
	local cpb = CreateFrame("Button", G.uiname..value.."ColorPickerButton", parent, "UIPanelButtonTemplate")
	cpb:SetPoint("TOPLEFT", x+3, -y)
	cpb:SetSize(20, 20)
	F.Reskin(cpb)
	
	cpb.ctex = cpb:CreateTexture(nil, "OVERLAY")
	cpb.ctex:SetTexture(G.media.blank)
	cpb.ctex:SetPoint"CENTER"
	cpb.ctex:SetSize(15, 15)

	cpb.name = cpb:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	cpb.name:SetPoint("LEFT", cpb, "RIGHT", 10, 1)
	cpb.name:SetText(name)
	T.resize_font(cpb.name)
	
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

T.createradiobuttongroup = function(parent, x, y, name, table, value, group, newline, order)
	local frame = CreateFrame("Frame", G.uiname..value.."RadioButtonGroup", parent)
	frame:SetPoint("TOPLEFT", x, -y)
	frame:SetSize(150, 30)
	
	local key = 1
	for k, v in T.pairsByKeys(group) do
		frame[k] = CreateFrame("CheckButton", G.uiname..value..k.."RadioButtonGroup", frame, "UIRadioButtonTemplate")
		frame[k].order = order and order[k] or key
		F.ReskinRadio(frame[k])
		
		frame[k].text:SetText(v)
		T.resize_font(frame[k].text)
		
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
		
		frame[k]:SetScript("OnDisable", function(self)
			local tex = self:GetCheckedTexture()
			tex:SetVertexColor(.7, .7, .7, .5)
			frame[k].text:SetTextColor(.7, .7, .7, .5)
		end)
		
		frame[k]:SetScript("OnEnable", function(self)
			local tex = self:GetCheckedTexture()
			tex:SetVertexColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b)
			frame[k].text:SetTextColor(1, .82, 0, 1)
		end)
		
		key = key + 1
	end
	
	for k, v in T.pairsByKeys(group) do
		frame[k]:HookScript("OnClick", function(self)
			if aCoreCDB[table][value] == k then
				for key, value in T.pairsByKeys(group) do
					if key ~= k then
						frame[key]:SetChecked(false)
					end
				end
			end
		end)
	end
	
	frame.name = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	frame.name:SetText(name)
	T.resize_font(frame.name)
	
	local buttons = {frame:GetChildren()}
	
	if order then
		sort(buttons, function(a,b) return a.order < b.order end)
	end
	
	for i = 1, #buttons do
		if i == 1 then
			frame.name:SetPoint("LEFT", 5, 0)
			buttons[i]:SetPoint("LEFT", frame.name, "RIGHT", 10, 1)
		elseif newline and i == newline then
			buttons[i]:SetPoint("TOPLEFT", frame.name, "BOTTOMRIGHT", 10, -10)
		else
			buttons[i]:SetPoint("LEFT", buttons[i-1].text, "RIGHT", 5, 0)
		end

	end
	
	frame.Enable = function()
		for i = 1, #buttons do
			buttons[i]:Enable()
		end
		frame.name:SetTextColor(1, 1, 1, 1)
	end
	
	frame.Disable = function()
		for i = 1, #buttons do
			buttons[i]:Disable()
		end
		frame.name:SetTextColor(0.7, 0.7, 0.7, 0.5)
	end
	
	parent[value] = frame
end

T.createboxgroup = function(parent, width, x, y, hasvalue, table, value, group, order)
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
		F.Reskin(frame[k], true)
		
		frame[k].Text:SetText(v)
		frame[k].Text:SetTextColor(1, 1, 1)
		T.resize_font(frame[k].Text)
		
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