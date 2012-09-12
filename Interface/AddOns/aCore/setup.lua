-- Load varriables on demand
local addon, ns = ...
local L = ns.L

local function LoadVariables()
	aCoreCDB = {
		fade = true
	}
	if IsAddOnLoaded("Aurora") then
		AuroraConfig["tooltips"] = false
		AuroraConfig["bags"] = false
	end
	if IsAddOnLoaded("!ClassColors") then
		if(ClassColorsDB) then table.wipe(wipe(ClassColorsDB)) end
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
			["b"] = 0.41,
			["g"] = 0.18,
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
			["b"] = 1,
			["g"] = 0.05,
			["r"] = 0.72,
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
	}
	end
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
	if IsAddOnLoaded("Skada") then
	if(SkadaDB) then table.wipe(wipe(SkadaDB["profiles"])) end
	SkadaDB	["profiles"] = {
		["Default"] = {
			["windows"] = {
					{
						["hidden"] = true,
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
	if IsAddOnLoaded("Numeration") then
		NumerationCharOptions["forcehide"] = true
		NumerationCharOptions["minimap"] = {
			["hide"] = true,
		}
	end
end

function SetupAltzui()

	LoadVariables()

	FCF_ResetChatWindows()

	ChatFrame1:SetSize(300, 120)
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 17, 20)

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
	
	ChatFrame_RemoveAllMessageGroups(ChatFrame4)
	ChatFrame_AddMessageGroup(ChatFrame4, "COMBAT_XP_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame4, "COMBAT_HONOR_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame4, "COMBAT_FACTION_CHANGE")
	ChatFrame_AddMessageGroup(ChatFrame4, "LOOT")
	ChatFrame_AddMessageGroup(ChatFrame4, "MONEY")
end
ns.SetupAltzui = SetupAltzui

StaticPopupDialogs["SetupAltzUI"] = {
	text = L["SetupEnsure"],
 	button1 = ACCEPT,
 	button2 = CANCEL,
	OnAccept = function() SetupAltzui() ReloadUI() end,
	OnCancel = function() end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = true
}
SLASH_SETUPALTZ1 = "/setup"
SlashCmdList["SETUPALTZ"] = function() StaticPopup_Show("SetupAltzUI") end