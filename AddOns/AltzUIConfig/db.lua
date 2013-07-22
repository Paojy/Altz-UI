local T, C, L, G = unpack(select(2, ...))

local default_ClassClick = {
	PRIEST = { 
		["1"] = {
			["Click"]		= {
				["action"]	= "target",
							},
			["shift-"]		= {
				["action"]	= 139,--"恢復",
							},
			["ctrl-"]		= {
				["action"]	= 527,--"驅散魔法",
							},
			["alt-"]		= {
				["action"]	= 2061,--"快速治療",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]		= 17,--"真言術:盾",
							},
			["shift-"]		= {
				["action"]	= 33076,--"癒合禱言",
							},
			["ctrl-"]		= {
				["action"]	= 528,--"驅除疾病", 
							},
			["alt-"]		= {
				["action"]	= 2060,--"強效治療術",
							},
		},
		["3"] = {
			["Click"]			= {
				["action"]	= 34861,--"治療之環",
							},
			["shift-"]		= {
				["action"]	= 2050, --治疗术
							},
			["alt-"]		= {
				["action"]	= 1706, --漂浮术
							},
			["ctrl-"]		= {
				["action"]	= 21562,--耐
							},
		},
		["4"] = {
			["Click"]		= {
				["action"]		= 596, --治疗祷言
							},
			["shift-"]		= {
				["action"]	= 47758, -- 苦修
							},
			["ctrl-"]		= {
				["action"]	= 73325, -- 信仰飞跃
							},
		},
		["5"] = {
			["Click"]			= {
				["action"]	= 48153, -- 守护之魂
							},
			["shift-"]		= {
				["action"]	= 88625, -- 圣言术
							},
			["ctrl-"]		= {
				["action"]	= 33206,--痛苦压制
							},
		},
	},
	DRUID = { 
		["1"] = {
			["Click"]		= {
				["action"]	= "target",
							},
			["shift-"]		= {
				["action"]	= 774,--"回春術",
							},
			["ctrl-"]		= {
				["action"]	= 2782,--"净化腐蚀",
							},
			["alt-"]		= {
				["action"]	= 8936,--"癒合",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 48438,--"野性成长",
							},
			["shift-"]		= {
				["action"]	= 18562,--"迅捷治愈",
							},
			["ctrl-"]		= {
				["action"]	= 88423, -- 自然治愈
							},
			["alt-"]		= {
				["action"]	= 50464,--"滋補術",
							},
		},
		["3"] = {
			["Click"]			= {
				["action"]	= 33763,--"生命之花",
							},
			["shift-"]		= {
				["action"]	= 5185,--治疗之触
							},
			["ctrl-"]		= {
				["action"]	= 20484,--复生,
							},
		},
		["4"] = {
			["Click"]			= {
				["action"]	= 29166,----激活
							},
			["alt-"]		= {
				["action"]		= 33763,----生命之花
							},
		},
	},
	SHAMAN = { 
		["1"] = {
			["Click"]		= {
				["action"]	= "target",
							},
			["ctrl-"]		= {
				["action"]	= 2008,		--"先祖之魂",
							},
			["alt-"]		= {
				["action"]	= 8004,		--"治疗之涌",
							},
			["shift-"]		= {
				["action"]	= 1064,		--"治疗链",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 51886,	--"净化灵魂",
							},
			["ctrl-"]		= {
				["action"]	= 546,		--水上行走
							},
			["alt-"]		= {
				["action"]	= 131,		--水下呼吸
							},
		},
		["3"] = {
			["Click"]			= {
				["action"]	= 61295,	--"激流",
							},
		},
		["4"] = {
			["Click"]			= {
				["action"]	= 73680,	--"元素释放",
							},
		},
	},
	PALADIN = { 
		["1"] = {
			["Click"]		= {
				["action"]	= "target",
							},
			["shift-"]		= {
				["action"]	= 635,--"聖光術",
							},
			["alt-"]		= {
				["action"]	= 19750,--"聖光閃現",
							},
			["ctrl-"]		= {
				["action"]	= 53563,--"圣光信标",
							},
		},
		["2"] = {
		    ["Click"]			= {
				["action"]	= 20473,--"神聖震擊",
							},
			["shift-"]		= {
				["action"]	= 82326,--"神圣之光",
							},
			["ctrl-"]		= {
				["action"]	= 4987,--"淨化術",
							},
			["alt-"]		= {
				["action"]	= 85673,--"荣耀圣令",
							},
		},
		["3"] = {
		    ["Click"]			= {
				["action"]	= 31789,--正義防護
							},
			["alt-"]		= {
				["action"]	= 1044,--自由之手
							},
			["ctrl-"]	= {
				["action"]	= 31789, -- 正义防御
							},
		},
		["4"] = {
			["Click"]			= {
				["action"]	= 1022,	--"保护之手",
							},
			["alt-"]		= {
				["action"]	= 6940,  --牺牲之手
							},
		},
		["5"] = {
			["Click"]			= {
				["action"]	= 1038,	--"拯救之手",
							},
		},
	},
	WARRIOR = { 
		["1"] = {
			["Click"]			= {
				["action"]	= "target",
							},
			["ctrl-"]		= {
				["action"]	= 50720,--"戒備守護",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 3411,--"阻擾",
							},
		},
	},
	MAGE = { 
		["1"] = {
			["Click"]			= {
				["action"]	= "target",
							},
			["alt-"]		= {
				["action"]	= 1459,--"秘法智力",
							},
			["ctrl-"]		= {
				["action"]	= 54646,--"专注",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 475,--"解除詛咒",
							},
			["shift-"]		= {
				["action"]	= 130,--"缓落",
							},
		},
	},
	WARLOCK = { 
		["1"] = {
			["Click"]			= {
				["action"]	= "target",
							},
			["alt-"]		= {
				["action"]	= 80398,--"黑暗意图",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 5697,--"无尽呼吸",
							},
		},
	},
	HUNTER = { 
		["1"] = {
			["Click"]			= {
				["action"]	= "target",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 34477,--"誤導",
							},
		},
	},
	ROGUE = { 
		["1"] = {
			["Click"]			= {
				["action"]	= "target",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 57933,--"偷天換日",
							},
		},
	},
	DEATHKNIGHT = {
		["1"] = {
			["Click"]			= {
				["action"]	= "target",
							},
			["shift-"]		= {
				["action"]	= 61999, --复活盟友
							},
		},
	},
	MONK = {
		["1"] = {
			["Click"]			= {
				["action"]	= "target",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 119611,--"复苏之雾",
							},
		},
	},
}

local classClickdb = default_ClassClick[select(2, UnitClass("player"))]
local modifiers = { "Click", "shift-", "ctrl-", "alt-"}

local ClickCastDB = {}

for i = 1, 13  do
	ClickCastDB[tostring(i)] = {}
	if i < 6 then
		for _, modifier in ipairs(modifiers) do
			ClickCastDB[tostring(i)][modifier] = {}
			ClickCastDB[tostring(i)][modifier]["action"] = "NONE"
			ClickCastDB[tostring(i)][modifier]["macro"] = ""
		end
	else -- 滚轮用的
		ClickCastDB[tostring(i)]["Click"] = {}
		ClickCastDB[tostring(i)]["Click"]["action"] = "NONE"
		ClickCastDB[tostring(i)]["Click"]["macro"] = ""
	end
end

for k, _ in pairs(classClickdb) do
	for j, _ in pairs(classClickdb[k]) do
		local var = classClickdb[k][j]["action"]
		local spellname = GetSpellInfo(var)
		if (var == "target" or var == "tot" or var == "follow" or var == "macro") then
			ClickCastDB[k][j]["action"] = var
		elseif spellname then
			ClickCastDB[k][j]["action"] = spellname
		end
	end
end

local Account_default_Settings = {
	meet = false,
	gold = {},
}

local Character_default_Settings = {
	FramePoints = {},
	UnitframeOptions = {
		enablefade = true,
		fadingalpha = 0.2,
		
		fontsize = 13,
		
		-- health/power
		alwayshp = false,
		alwayspp = false,
		classcolormode = true,
		transparentmode = true,
		nameclasscolormode = true,
		startcolor = {r = 0, g = 0, b = 0, a = 0},
		endcolor = {r = .5, g = .5, b = .5, a = 0.5},
		
		-- portrait
		portrait = false,
		portraitalpha = 0.6,
		
		-- size
		height	= 16,
		width = 230,
		widthpet = 70,
		widthboss = 170,
		scale = 1.0, -- slider
		hpheight = 0.9, -- slider

		-- castbar
		castbars = true,
		cbIconsize = 32,

		-- auras
		auras = true,
		auraborders = true,
		auraperrow = 9, -- slider
		playerdebuffenable = true,
		playerdebuffnum = 7, -- slider

		AuraFilterignoreBuff = false,
		AuraFilterignoreDebuff = false,
		AuraFilterwhitelist = {},

		showthreatbar = true,

		-- show/hide boss
		bossframes = true,
		
		-- show/hide arena
		arenaframs = true,
		
		-- show pvp timer
		pvpicon = false,

		--[[ share ]]--
		enableraid = true,
		showraidpet = false,
		raidfontsize = 10,
		namelength = 4,
		showsolo = false,
		autoswitch = false,
		raidonly = "healer",
		
		enablearrow = true,
		arrowsacle = 1.0,

		--[[ healer mode ]]--
		healergroupfilter = '1,2,3,4,5',
		healerraidheight = 30,
		healerraidwidth = 70,
		raidmanabars = true,
		raidhpheight = 0.9, -- slider
		anchor = "TOP", -- dropdown
		partyanchor = "LEFT", -- dropdown
		showgcd = true,
		showmisshp = true,
		healprediction = true,

		--[[ dps/tank mode ]]--
		dpsgroupfilter = '1,2,3,4,5',
		dpsraidheight = 15,
		dpsraidwidth = 100,
		unitnumperline = 25,
		dpsraidgroupbyclass = true,
		
		--[[ click cast ]]--
		enableClickCast = false,
		ClickCast = ClickCastDB
	},
	ChatOptions = {
		channelreplacement = true,
		autoscroll = true,
		nogoldseller = true,
		keywordnum = 2,
		keywordlist = {},
	},
	ItemOptions = {
		enablebag = true,
		autorepair = true,
		autorepair_guild = true,
		autosell = true,
		alreadyknown = true,
		autobuy = false,
		autobuylist = {
		["79249"] = 20, -- 清心书卷
		}
	},
	ActionbarOptions = {
		cooldown = true,
		rangecolor = true,
		keybindsize = 12,
		macronamesize = 8,
		countsize = 12,
		bar12size = 25,
		bar12space = 4,
		bar12mfade = true,
		bar12efade = true,
		bar12fademinaplha = 0.2,
		bar3uselayout322 = true,
		space1 = 5,
		bar3size = 25,
		bar3space = 4,
		bar3mfade = true,
		bar3efade = false,
		bar3fademinaplha = 0.2,
		bar45size = 25,
		bar45space = 4,
		bar45mfade = true,
		bar45efade = false,
		bar45fademinaplha = 0,
		petbaruselayout5x2 = false,
		petbarscale = .7,
		petbuttonspace = 4,
		petbarmfade = true,
		petbarefade = false,
		petbarfademinaplha = 0.2,
		stancebarbuttonszie = 22,
		stancebarbuttonspace = 4,
		micromenuscale = 1,
		micromenufade = true,
		micromenuminalpha = 0,
		leave_vehiclebuttonsize = 30,
		extrabarbuttonsize = 30,
	},
	BuffFrameOptions = {
		seperate = true,
		buffsize = 30,
		debuffsize = 35,
		buffrowspace = 10,
		debuffrowspace = 10, -- 上下间距
		buffcolspace = 5,
		debuffcolspace = 5, -- 左右间距
		bufftimesize = 13,
		debufftimesize = 16,
		buffcountsize = 14,
		debuffcountsize = 18,
		buffsPerRow = 14,
		debuffsPerRow = 10,
	},
	PlateOptions = {
		enableplate = true,
		autotoggleplates = true,
		threatplates = true,
		platewidth = 150,
		plateheight = 7,
		platedebuff = true,
		platebuff = false,
		plateauranum = 5,
		plateaurasize = 25,	
	},
	TooltipOptions = {
		enabletip = true,
		cursor = false,
		hideRealm = false,
		hideTitles = true,
		showspellID = true,
		showitemID = true,
		showtalent = true,
		colorborderClass = false,
		combathide = true,	
	},
	CombattextOptions = {
		combattext = true,
		showreceivedct = true,
		showoutputct = true,
		ctfliter = true,
		cticonsize = 13,
		ctbigiconsize = 25,
		ctshowdots = false,
		ctshowhots = false,
		ctshowpet = true,
		ctfadetime = 3,	
	},
	RaidToolOptions = {
		onlyactive = true,
		unlockraidmarks = false,
		potion = false,
		potionblacklist = "",
		pulltime = 8,
	},
	OtherOptions = {
		minimapheight = 130,
		collectminimapbuttons = true,
		collecthidingminimapbuttons = false,
		hideerrors = true,		
		autoscreenshot = true,
		collectgarbage = true,
		camera = true,		
		acceptres = true,
		battlegroundres = true,
		acceptfriendlyinvites = false,
		autoinvite = false,
        autoinvitekeywords = "111 123",		
		autoquests = false,
		saysapped = true,
	},
	SkinOptions = {
		editsettings = true,
		setClassColor = true,
		setDBM = true,
		setSkada = true,
		setNumeration = true,
		setRecount = true,
	},
}

function T.LoadVariables()
	for a, b in pairs(Character_default_Settings) do
		if type(b) ~= "table" then
			if aCoreCDB[a] == nil then
				aCoreCDB[a] = b
			end
		else
			if aCoreCDB[a] == nil then
				aCoreCDB[a] = {}
			end
			for k, v in pairs(b) do
				if aCoreCDB[a][k] == nil then
					aCoreCDB[a][k] = v
				end
			end
		end
	end
end

function T.LoadAccountVariables()
	for a, b in pairs(Account_default_Settings) do
		if type(b) ~= "table" then
			if aCoreDB[a] == nil then
				aCoreDB[a] = b
			end
		else
			if aCoreDB[a] == nil then
				aCoreDB[a] = {}
			end
			for k, v in pairs(b) do
				if aCoreDB[a][k] == nil then
					aCoreDB[a][k] = v
				end
			end
		end
	end
end