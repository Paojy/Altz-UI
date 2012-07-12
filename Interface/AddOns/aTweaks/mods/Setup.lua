---------------- > style DBM (huge props to Affli and his DBM-Styler plug-in)
local dummy = function()end
local styled = true

local buttonsize=20--23
local tex="Interface\\TargetingFrame\\UI-StatusBar.blp"
local backdropcolor={.3,.3,.3}
local backdrop={
		bgFile = "Interface\\Buttons\\WHITE8x8",
		edgeFile = "Interface\\Buttons\\WHITE8x8",
		tile = false, tileSize = 0, edgeSize = 1, 
		insets = { left = 1, right = 1, top = 1, bottom = 1}
	}
local function gen_backdrop(ds)
	if ds then
		ds:SetBackdrop(backdrop)
		ds:SetBackdropColor(.1,.1,.1,0.5)
		ds:SetBackdropBorderColor(0,0,0,1)
	end
end
-- make sure vars are available.
local ds=CreateFrame"Frame"
ds:RegisterEvent"VARIABLES_LOADED"
ds:SetScript("OnEvent", function()
-- this will inject our code to all dbm bars.
function SkinBars(self)
	for bar in self:GetBarIterator() do
		if not (bar.injected==styled) then
			bar.ApplyStyle=function()
			local frame = bar.frame
			local tbar = _G[frame:GetName().."Bar"]
			local spark = _G[frame:GetName().."BarSpark"]
			local texture = _G[frame:GetName().."BarTexture"]
			local icon1 = _G[frame:GetName().."BarIcon1"]
			local icon2 = _G[frame:GetName().."BarIcon2"]
			local name = _G[frame:GetName().."BarName"]
			local timer = _G[frame:GetName().."BarTimer"]
			if (icon1.overlay) then
				icon1.overlay = _G[icon1.overlay:GetName()]
			else
				icon1.overlay = CreateFrame("Frame", "$parentIcon1Overlay", tbar)
				icon1.overlay:SetWidth(buttonsize)
				icon1.overlay:SetHeight(buttonsize)
				icon1.overlay:SetFrameStrata("BACKGROUND")
				icon1.overlay:SetPoint("BOTTOMRIGHT", tbar, "BOTTOMLEFT", -buttonsize/4, -2)
				gen_backdrop(icon1.overlay)				
			end
			if (icon2.overlay) then
				icon2.overlay = _G[icon2.overlay:GetName()]
			else
				icon2.overlay = CreateFrame("Frame", "$parentIcon2Overlay", tbar)
				icon2.overlay:SetWidth(buttonsize)
				icon2.overlay:SetHeight(buttonsize)
				icon2.overlay:SetFrameStrata("BACKGROUND")
				icon2.overlay:SetPoint("BOTTOMLEFT", tbar, "BOTTOMRIGHT", buttonsize/4, -2)
				gen_backdrop(icon2.overlay)
			end
			if bar.color then
				tbar:SetStatusBarColor(bar.color.r, bar.color.g, bar.color.b)
			else
				tbar:SetStatusBarColor(bar.owner.options.StartColorR, bar.owner.options.StartColorG, bar.owner.options.StartColorB)
			end
			if bar.enlarged then frame:SetWidth(bar.owner.options.HugeWidth) else frame:SetWidth(bar.owner.options.Width) end
			if bar.enlarged then tbar:SetWidth(bar.owner.options.HugeWidth) else tbar:SetWidth(bar.owner.options.Width) end
			frame:SetScale(1)
			if not (frame.style==styled) then
				frame:SetHeight(buttonsize/2.5)
				gen_backdrop(frame)
				frame.style=styled
			end
			if not (spark.style==styled) then
				spark:SetAlpha(0)
				spark:SetTexture(nil)
				spark.style=styled
			end
			if not (icon1.style==styled) then
				icon1:SetTexCoord(0.08, 0.92, 0.08, 0.92)
				icon1:ClearAllPoints()
				icon1:SetPoint("TOPLEFT", icon1.overlay, 2, -2)
				icon1:SetPoint("BOTTOMRIGHT", icon1.overlay, -2, 2)
				icon1.style=styled
			end
			if not (icon2.style==styled) then
				icon2:SetTexCoord(0.08, 0.92, 0.08, 0.92)
				icon2:ClearAllPoints()
				icon2:SetPoint("TOPLEFT", icon2.overlay, 2, -2)
				icon2:SetPoint("BOTTOMRIGHT", icon2.overlay, -2, 2)
				icon2.style=styled
			end
			texture:SetTexture(tex)
			if not (tbar.style==styled) then
				tbar:ClearAllPoints()
				tbar:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
				tbar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
				tbar.style=styled
			end
			if not (name.style==styled) then
				name:ClearAllPoints()
				name:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 4)
				name:SetWidth(165)
				name:SetHeight(8)
				name:SetFontObject(GameTooltipTextSmall)
				name:SetJustifyH("LEFT")
				name:SetShadowColor(0, 0, 0, 0)
				name.SetFont = dummy
				name.style=styled
			end
			if not (timer.style==styled) then	
				timer:ClearAllPoints()
				timer:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -1, 2)
				timer:SetFontObject(GameTooltipTextSmall)
				timer:SetJustifyH("RIGHT")
				timer:SetShadowColor(0, 0, 0, 0)
				timer.SetFont = dummy
				timer.style=styled
			end
			if bar.owner.options.IconLeft then icon1:Show() icon1.overlay:Show() else icon1:Hide() icon1.overlay:Hide() end
			if bar.owner.options.IconRight then icon2:Show() icon2.overlay:Show() else icon2:Hide() icon2.overlay:Hide() end
			tbar:SetAlpha(1)
			frame:SetAlpha(1)
			texture:SetAlpha(1)
			frame:Show()
			bar:Update(0)
			styled = true
			bar.injected=styled
			end
			bar:ApplyStyle()
		end
	end
end
-- apply range check style
SkinRange = function(self)
	gen_backdrop(self)
end
ds:UnregisterEvent"VARIABLES_LOADED"
end)

-- apply bars style
local ApplyStyle=function()
    if IsAddOnLoaded("DBM-Core") then
	if SkinBars and type(SkinBars)=="function" then
		SkinBars=SkinBars
	end
	if SkinRange and type(SkinRange)=="function" then
		SkinRange=SkinRange
	end
	hooksecurefunc(DBT,"CreateBar", SkinBars)
	DBM.RangeCheck:Show()
	DBM.RangeCheck:Hide()
	DBMRangeCheck:HookScript("OnShow",SkinRange)
	end
end

local apply=CreateFrame"Frame"
apply:RegisterEvent"VARIABLES_LOADED"
apply:SetScript("OnEvent", function(self) ApplyStyle()
	self:UnregisterEvent"VARIABLES_LOADED"
end)

-- Load DBM varriables on demand
SetDBM = function()
if IsAddOnLoaded("DBM-Core") then
if(DBM_SavedOptions) then table.wipe(DBM_SavedOptions) end
	DBM_SavedOptions = {
	["SpecialWarningFontSize"] = 50,
	["ShowWarningsInChat"] = false,
	["DontSetIcons"] = false,
	["BigBrotherAnnounceToRaid"] = false,
	["ArrowPosX"] = 0,
	["InfoFrameY"] = 210,
	["SpecialWarningSound"] = "Sound\\Spells\\PVPFlagTaken.wav",
	["AutoRespond"] = true,
	["HealthFrameGrowUp"] = false,
	["StatusEnabled"] = true,
	["HideBossEmoteFrame"] = false,
	["InfoFrameX"] = 250,
	["ShowBigBrotherOnCombatStart"] = false,
	["BlockVersionUpdatePopup"] = true,
	["HideTrivializedWarnings"] = false,
	["WarningIconRight"] = true,
	["AlwaysShowSpeedKillTimer"] = false,
	["RangeFrameY"] = -923,
	["InfoFrameShowSelf"] = true,
	["SpecialWarningFont"] = "Fonts\\ZYKai_T.TTF",
	["SpamBlockBossWhispers"] = false,
	["ShowSpecialWarnings"] = true,
	["SpamBlockRaidWarning"] = true,
	["ShowFakedRaidWarnings"] = true,
	["LatencyThreshold"] = 200,
	["SpecialWarningSound2"] = "Sound\\Creature\\AlgalonTheObserver\\UR_Algalon_BHole01.wav",
	["InfoFramePoint"] = "BOTTOM",
	["DontSendBossAnnounces"] = false,
	["DontShowBossAnnounces"] = false,
	["ShowMinimapButton"] = false,
	["HPFrameMaxEntries"] = 5,
	["RangeFramePoint"] = "TOPLEFT",
	["SpecialWarningPoint"] = "CENTER",
	["SetCurrentMapOnPull"] = true,
	["RaidWarningSound"] = "Sound\\interface\\AlarmClockWarning3.wav",
	["RangeFrameX"] = 1337,
	["RangeFrameLocked"] = false,
	["WarningIconLeft"] = true,
	["SpecialWarningX"] = 0,
	["SpecialWarningY"] = 222,
	["RaidWarningPosition"] = {
		["Y"] = -219,
		["X"] = 0,
		["Point"] = "TOP",
	},
	["RangeFrameSound1"] = "none",
	["Enabled"] = true,
	["HPFramePoint"] = "TOPLEFT",
	["HealthFrameLocked"] = false,
	["HealthFrameWidth"] = 156,
	["RangeFrameSound2"] = "none",
	["DontSendBossWhispers"] = false,
	["SpecialWarningFontColor"] = {
		0.2, -- [1]
		0.8, -- [2]
		1, -- [3]
	},
	["HPFrameY"] = -5,
	["FixCLEUOnCombatStart"] = false,
	["ArrowPosY"] = -150,
	["AlwaysShowHealthFrame"] = false,
	["HPFrameX"] = 76,
	["ArrowPoint"] = "TOP",
	["SettingsMessageShown"] = true,
	["ArchaeologyHumor"] = true,
	["UseMasterVolume"] = true,
	}
if(DBT_SavedOptions) then table.wipe(DBT_SavedOptions) end
	DBT_SavedOptions = {
		["DBM"] = {
		["FontSize"] = 10,
		["HugeTimerY"] = 400,
		["HugeBarXOffset"] = 0,
		["Scale"] = 0.8,
		["IconLeft"] = true,
		["StartColorR"] = 0,
		["HugeWidth"] = 187,
		["TimerX"] = -160,
		["ClickThrough"] = true,
		["IconRight"] = false,
		["EndColorG"] = 0,
		["ExpandUpwards"] = false,
		["TimerPoint"] = "TOPRIGHT",
		["StartColorG"] = 0.7,
		["StartColorB"] = 1,
		["HugeScale"] = 1,
		["EndColorR"] = 1,
		["Width"] = 140,
		["HugeTimerPoint"] = "BOTTOM",
		["Font"] = "Fonts\\ZYKai_T.TTF",
		["HugeBarYOffset"] = 0,
		["TimerY"] = -230,
		["HugeTimerX"] = 262,
		["BarYOffset"] = 17,
		["BarXOffset"] = 0,
		["EndColorB"] = 0.8,
		},
	}
end

if IsAddOnLoaded("Skada") then
if(SkadaDB) then table.wipe(wipe(SkadaDB["profiles"])) end
	SkadaDB	["profiles"] = {
		["Default"] = {
			["windows"] = {
				{
					["classicons"] = false,
					["barslocked"] = true,
					["background"] = {
						["height"] = 130,
						["bordertexture"] = "Blizzard Tooltip",
					},
					["set"] = "total",
					["y"] = 60,
					["x"] = -10,
					["title"] = {
						["color"] = {
							["a"] = 0,
						},
						["borderthickness"] = 0,
					},
					["point"] = "BOTTOMRIGHT",
					["barbgcolor"] = {
						["a"] = 0,
						["r"] = 0.2,
						["g"] = 0.2,
						["b"] = 0.2,
					},
					["barwidth"] = 168,
					["barcolor"] = {
						["a"] = 0.5,
						["r"] = 0.3,
						["g"] = 0.4,
						["b"] = 0.7,
					},
				}, -- [1]
			},
			["icon"] = {
				["hide"] = true,
			},
		},
	}
end

if IsAddOnLoaded("Numeration") then
if(NumerationCharOptions) then 
table.wipe(wipe(NumerationCharOptions))
end
NumerationCharOptions = {
	["onlyinstance"] = true,
	["keeponlybosses"] = true,
	["forcehide"] = true,
	["nav"] = {
		["view"] = "Units",
		["type"] = 1,
		["set"] = "current",
	},
	["petsmerged"] = true,
	["minimap"] = {
		["hide"] = true,
	},
}
end

local SetDefaultChatPosition = function(frame)
	if frame then
		local id = frame:GetID()
		local name = FCF_GetChatWindowInfo(id)
		local fontSize = select(2, frame:GetFont())
		
		if id == 1 then
			frame:ClearAllPoints()
			frame:SetPoint("TOPLEFT", "UIParent", "LEFT", 180, -20)
		end
		
		-- lock them if unlocked
		if not frame.isLocked then FCF_SetLocked(frame, 1) end
	end
end
hooksecurefunc("FCF_RestorePositionAndDimensions", SetDefaultChatPosition)

	-- setting chat frames			
	FCF_ResetChatWindows()
	FCF_SetLocked(ChatFrame1, 1)
	FCF_DockFrame(ChatFrame2)
	FCF_SetLocked(ChatFrame2, 1)
	FCF_OpenNewWindow(LOOT)
	FCF_SetLocked(ChatFrame3, 1)
	FCF_DockFrame(ChatFrame3)

	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G[format("ChatFrame%s", i)]
		local id = frame:GetID()

		-- set default tukui font size
		FCF_SetChatWindowFontSize(nil, frame, 12)
		
		-- set the size of chat frames
		frame:SetSize(350,120)
		
		-- tell wow that we are using new size
		SetChatWindowSavedDimensions(id, 350, 120)
		
		SetDefaultChatPosition(frame)
		
		-- save new default position and dimension
		FCF_SavePositionAndDimensions(frame)
		
		ChatFrame_RemoveAllMessageGroups(ChatFrame3)
		ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_XP_GAIN")
		ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_HONOR_GAIN")
		ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_FACTION_CHANGE")
		ChatFrame_AddMessageGroup(ChatFrame3, "LOOT")
		ChatFrame_AddMessageGroup(ChatFrame3, "MONEY")
	end

end

SLASH_SETDBM1 = "/setup"
SlashCmdList["SETDBM"] = function() SetDBM() ReloadUI() end