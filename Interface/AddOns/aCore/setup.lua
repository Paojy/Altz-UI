-- Load varriables on demand
local addon, ns = ...
local function SetupAltzui()
if IsAddOnLoaded("Aurora") then
	AuroraConfig["tooltips"] = false
	AuroraConfig["bags"] = false
end
if IsAddOnLoaded("!ClassColors") then
	if(ClassColorsDB) then table.wipe(wipe(ClassColorsDB)) end
	ClassColorsDB = {
	["DEATHKNIGHT"] = {
		["hex"] = "ffc41e3a",
		["colorStr"] = "ffb3040f",
		["b"] = 0.06,
		["g"] = 0.02,
		["r"] = 0.70,
	},
	["WARRIOR"] = {
		["hex"] = "ffc69b6d",
		["colorStr"] = "ffffb171",
		["b"] = 0.45,
		["g"] = 0.69,
		["r"] = 1,
	},
	["PALADIN"] = {
		["hex"] = "fff48cba",
		["colorStr"] = "fff50a6c",
		["b"] = 0.41,
		["g"] = 0.18,
		["r"] = 1,
	},
	["MAGE"] = {
		["hex"] = "ff68ccef",
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
		["hex"] = "ff9382c9",
		["colorStr"] = "ffe200ff",
		["b"] = 1,
		["g"] = 0.05,
		["r"] = 0.72,
	},
	["SHAMAN"] = {
		["hex"] = "ff0070dd",
		["colorStr"] = "ff445dff",
		["b"] = 1,
		["g"] = 0.36,
		["r"] = 0.27,
	},
	["HUNTER"] = {
		["hex"] = "ffaad372",
		["colorStr"] = "ffd3d012",
		["b"] = 0.10,
		["g"] = 1,
		["r"] = 0.5,
	},
	["DRUID"] = {
		["hex"] = "ffff7c0a",
		["colorStr"] = "ffff9b00",
		["b"] = 0,
		["g"] = 0.61,
		["r"] = 1,
	},
	["MONK"] = {
		["hex"] = "ff00ff96",
		["colorStr"] = "ff00ff97",
		["b"] = 0.59,
		["g"] = 1,
		["r"] = 0,
	},
	["ROGUE"] = {
		["hex"] = "fffff468",
		["colorStr"] = "ffffe700",
		["b"] = 0,
		["g"] = 0.91,
		["r"] = 1,
	},
	}
end
-- DBM
	if IsAddOnLoaded("DBM-Core") then
		DBM_SavedOptions["ShowMinimapButton"] = false
		-- warning
		DBM_SavedOptions.RaidWarningPosition = {
			["Y"] = -60,
			["X"] = 0,
			["Point"] = "TOP",
		}
		-- special warning
		DBM_SavedOptions["SpecialWarningPoint"] = "CENTER"
		DBM_SavedOptions["SpecialWarningX"] = 0
		DBM_SavedOptions["SpecialWarningY"] = 75
		DBM_SavedOptions["SpecialWarningFontColor"] = {
			0.2, -- [1]
			0.8, -- [2]
			1, -- [3]
		}
		-- hp frame
		DBM_SavedOptions["AlwaysShowHealthFrame"] = false
		DBM_SavedOptions["HealthFrameGrowUp"] = false
		DBM_SavedOptions["HealthFrameWidth"] = 160
		DBM_SavedOptions["HPFramePoint"] = "TOPRIGHT"
		DBM_SavedOptions["HPFrameX"] = -170
		DBM_SavedOptions["HPFrameY"] = -180
		-- info
		DBM_SavedOptions["InfoFramePoint"] = "LEFT"
		DBM_SavedOptions["InfoFrameX"] = 300
		DBM_SavedOptions["InfoFrameY"] = -60
		-- range
		DBM_SavedOptions["RangeFrameRadarPoint"] = "RIGHT"
		DBM_SavedOptions["RangeFrameRadarX"] = -115
		DBM_SavedOptions["RangeFrameRadarY"] = 20
		DBM_SavedOptions["RangeFramePoint"] = "RIGHT"
		DBM_SavedOptions["RangeFrameX"] = -115
		DBM_SavedOptions["RangeFrameY"] = -60
		DBM_SavedOptions["RangeFrameFrames"] = "radar"
		-- timersettings
		DBT_SavedOptions["DBM"]["IconLeft"] = true
		DBT_SavedOptions["DBM"]["IconRight"] = false
		DBT_SavedOptions["DBM"]["Texture"] = "Interface\\Buttons\\WHITE8x8"
		DBT_SavedOptions["DBM"]["ExpandUpwards"] = false
		DBT_SavedOptions["DBM"]["FontSize"] = 10
		-- smalltimer
		DBT_SavedOptions["DBM"]["Scale"] = 1
		DBT_SavedOptions["DBM"]["Width"] = 165
		DBT_SavedOptions["DBM"]["TimerPoint"] = "TOPLEFT"
		DBT_SavedOptions["DBM"]["TimerX"] = 253
		DBT_SavedOptions["DBM"]["TimerY"] = -15
		DBT_SavedOptions["DBM"]["BarXOffset"] = 0
		DBT_SavedOptions["DBM"]["BarYOffset"] = 1
		-- hugetimer
		DBT_SavedOptions["DBM"]["HugeScale"] = 1
		DBT_SavedOptions["DBM"]["HugeWidth"] = 200
		DBT_SavedOptions["DBM"]["HugeTimerPoint"] = "CENTER"
		DBT_SavedOptions["DBM"]["HugeTimerX"] = -265
		DBT_SavedOptions["DBM"]["HugeTimerY"] = 30
		DBT_SavedOptions["DBM"]["HugeBarXOffset"] = 0
		DBT_SavedOptions["DBM"]["HugeBarYOffset"] = 1
	end
-- Skada
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
						["y"] = 18,
						["x"] = -16,
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
						["barwidth"] = 171,
						["barcolor"] = {
							["a"] = 0.9,
							["r"] = 0.2,
							["g"] = 0.8,
							["b"] = 1,
						},
					}, -- [1]
				},
			["icon"] = {
				["hide"] = true,
			},
		},
	}
	end
-- Numeration
	if IsAddOnLoaded("Numeration") then
		NumerationCharOptions["forcehide"] = true
		NumerationCharOptions["minimap"] = {
			["hide"] = true,
		}
	end
-- Chat settings
	local SetDefaultChatPosition = function(frame)
		if frame then
			local id = frame:GetID()
			local name = FCF_GetChatWindowInfo(id)
			local fontSize = select(2, frame:GetFont())
		
			if id == 1 then
				frame:ClearAllPoints()
				frame:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 17, 20)
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
		frame:SetSize(320,120)
		
		-- tell wow that we are using new size
		SetChatWindowSavedDimensions(id, 320, 120)
		
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
-- Load Variables
		aCoreCDB = {
		fade = true
		}
end
ns.SetupAltzui = SetupAltzui

StaticPopupDialogs["SetupAltzUI"] = {
	text = "Do you want to set to Deflaut Options and Reload UI?",
	button1 = "yes",
	button2 = "cancel",
	OnAccept = function() SetupAltzui() ReloadUI() end,
	OnCancel = function() 
	UIFrameFadeOut(TOPPANEL, 2, 1, 0)
	UIFrameFadeOut(BOTTOMPANEL, 2, 1, 0) 
	BOTTOMPANEL:EnableMouse(false)
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = true
}
SLASH_SETUPALTZ1 = "/setup"
SlashCmdList["SETUPALTZ"] = function() StaticPopup_Show("SetupAltzUI") end