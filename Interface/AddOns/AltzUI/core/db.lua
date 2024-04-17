local T, C, L, G = unpack(select(2, ...))

-- 点击施法
local default_ClassClick = {
	PRIEST = { 
		["1"] = {
			["Click"]		= {
				["action"]	= "target",
							},
			["ctrl-"]		= {
				["action"]	= 47788,--"守护之魂",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]		= 17,--"真言術:盾",
							},
		},
		["6"] = {
			["Click"]			= {
				["action"]	= 33076,	--"愈合",
							},
		},
		["10"] = {
			["Click"]			= {
				["action"]	= 527,	--"驱散",
							},
		},
	},
	DRUID = { 
		["1"] = {
			["Click"]		= {
				["action"]	= "target",
							},
			["ctrl-"]		= {
				["action"]	= 102342,--"铁木树皮",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]		= 774,--"回春",
							},
			["ctrl-"]		= {
				["action"]	= 20484,--"战复",
							},				
		},
		["6"] = {
			["Click"]			= {
				["action"]	= 18562,	--"迅捷治愈",
							},
		},
		["10"] = {
			["Click"]			= {
				["action"]	= 33763,	--"生命绽放",
							},
		},					
		["12"] = {
			["Click"]			= {
				["action"]	= 88423,	--"驱散",
							},						
		},
	},
	SHAMAN = { 
		["1"] = {
			["Click"]		= {
				["action"]	= "target",
							},
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 61295,	--"激流",
							},
			["ctrl-"]		= {
				["action"]	= 546,		--水上行走
							},
		},
		["6"] = {
			["Click"]			= {
				["action"]	= 8004,	--"治疗之涌",
							},
		},
		["10"] = {
			["Click"]			= {
				["action"]	= 77130,	--"净化灵魂",
							},
		},
	},
	PALADIN = { 
		["1"] = {
			["Click"]			= {
				["action"]	= "target",
							},
			["ctrl-"]		= {
				["action"]	= 6940,		--牺牲祝福
							},		
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 20476,  --"神圣震击",
							},
			["ctrl-"]		= {
				["action"]	= 1022,		--保护祝福
							},	
		},
		["6"] = {
			["Click"]			= {
				["action"]	= 183998,	--"殉道者之光",
							},
		},
		["8"] = {
			["Click"]			= {
				["action"]	= 53563,	--"圣光道标",
							},
		},			
		["10"] = {
			["Click"]			= {
				["action"]	= 4987,	--"驱散",
							},
		},
		["12"] = {
			["Click"]			= {
				["action"]	= 115450,	--"自由祝福",
							},		
		},
							
	},
	WARRIOR = { 
		["1"] = {
			["Click"]			= {
				["action"]	= "target",
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
		},
	},
	WARLOCK = { 
		["1"] = {
			["Click"]			= {
				["action"]	= "target",
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
				["action"]	= 57933,--"偷天換日", ---
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
			["ctrl-"]		= {
				["action"]	= 116849,		--作茧缚命
							},		
		},
		["2"] = {
			["Click"]			= {
				["action"]	= 119611,--"复苏之雾",
							},
		},
		["6"] = {
			["Click"]			= {
				["action"]	= 115450,	--"神器",
							},
		},
		["10"] = {
			["Click"]			= {
				["action"]	= 115450,	--"驱散",
							},
		},
		
	},
	DEMONHUNTER = {
		["1"] = {
			["Click"]			= {
				["action"]	= "target",
							},
		},
	},
	EVOKER = {
		["1"] = {
			["Click"]			= {
				["action"]	= "target",
							},
		},
	},
}

local classClickdb = default_ClassClick[G.myClass]
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

-- 团队框架光环
local AuraList = {
	["Buffs"] = {
	--牧师
		[33206]   = 15, -- 痛苦压制
        [47788]   = 15, -- 守护之魂
		[47585]   = 15, -- 消散		
	--小德        
        [102342]  = 15, -- 铁木树皮
		[22812]   = 15, -- 树皮术
		[61336]   = 15, -- 生存本能
		[22842]   = 15, -- 狂暴回复
	--骑士        
		[1022]    = 15, -- 保护之手
		[31850]   = 15, -- 炽热防御者
        [498]     = 15, -- 圣佑术
		[642]     = 15, -- 圣盾术
		[86659]   = 15, -- 远古列王守卫
		[132403]  = 13, -- 个人添加：正义盾击
		[204018]  = 15, -- 个人添加：破咒祝福
		[6940]    = 15, -- 个人添加：牺牲祝福
	--DK          
		[48707]   = 15, -- 反魔法护罩
		[48792]   = 15, -- 冰封之韧
		[49028]   = 15, -- 吸血鬼之血
		[55233]   = 15, -- 符文刃舞
		[194844]  = 15, -- 个人添加：白骨风暴
	--战士        
		[12975]   = 15, -- 破釜沉舟
		[871]     = 15, -- 盾墙
		[184364]  = 15, -- 狂怒回复
		[118038]  = 15, -- 剑在人在
	--DH            
		[196555]  = 15, -- 虚空行走 浩劫
		[187827]  = 15, -- 恶魔变形
		[212084]  = 15, -- 邪能毁灭
		[204021]  = 15, -- 烈火烙印
		[203720]  = 15, -- 恶魔尖刺
	--猎人
		[186265]  = 15, -- 灵龟守护
	--盗贼
		[31224]   = 15, -- 暗影斗篷
		[1966]    = 15, -- 佯攻
	--术士       
		[104773]  = 15, -- 不灭决心
	--法师       
		[45438]   = 15, -- 寒冰屏障
	--武僧       
		[116849]  = 15, -- 作茧缚命
		[115203]  = 15, -- 壮胆酒
		[122470]  = 15, -- 业报之触
		[122783]  = 15, -- 散魔功
	--萨满       
		[108271]  = 15, -- 星界转移
	--通用       
		[324867]  = 6, -- 血肉铸造
	},
	["Debuffs"] = {
		[240559]  = 6,  -- 重伤
		[209858]  = 6,  -- 死疽
					
		--9.0       
		[240443]  = 8, -- 爆裂词缀
		[240447]  = 8, -- 践踏，地震词缀
		[342494]  = 8, -- 狂妄吹嘘，昏迷
		[342466]  = 8, -- 狂妄吹嘘，点名
		[225080]  = 8, -- 萨满重生，可诈尸
		[160029]  = 6, -- 正在复活
		[292910]  = 8, -- 镣铐，爬塔
		[1604]    = 6, -- 眩晕
	},
	["Debuffs_Black"] = {
		[57723]   = 6, -- 筋疲力尽
		[80354]   = 6, -- 时空错位
		[264689]  = 6, -- 疲倦
		[340880]  = 6, -- 傲慢
		[206151]  = 6, -- 挑战者的负担
		[15007]   = 6, -- 复活虚弱
		[113942]  = 6, -- 无法再用恶魔传送门
		[209261]  = 6, -- 未被污染的邪能，DH假死
		[87024]   = 6, -- 灸灼，法师假死
		[41425]   = 6, -- 低温，法师不能再用冰箱
		[326809]  = 6, -- 餍足，DK假死
		[45181]   = 6, -- 装死，盗贼假死
		[320227]  = 6, -- 枯竭外壳，法夜诈尸
		[340556]  = 6, -- 精确本能，导灵器
		[348254]  = 6, -- 典狱长之眼
		[338606]  = 6, -- 典狱长之链
		[26013]   = 6, -- 逃亡者
		[124275]  = 6, -- 轻度醉拳
		[124274]  = 6, -- 中度醉拳
		[340870]  = 6, -- 恐怖光环，圣物匠全屏aoe
		[325184]  = 6, -- 自由心能，女勋爵全屏debuff
		[334909]  = 6, -- 压制气场，议会全屏debuff
		[346939]  = 6, -- 扭曲痛苦，议会全屏debuff
		[332443]  = 6, -- 泥拳，震动的地基，全屏aoe
		[343063]  = 6, -- 干将，大地之刺减速
	},
}

if G.myClass == "PALADIN"  then
	AuraList["Debuffs"][25771] = 6  -- 自律
end

-- 姓名板光环
G.WhiteList = {
	--BUFF
	[209859] = true, -- 激励
	-- DEBUFF
	[118] = true, -- 变形术
	[51514] = true, -- 妖术
	[217832] = true, -- 禁锢
	[605] = true, -- 精神控制
	[710] = true, -- 放逐
	[2094] = true, -- 致盲
	[6770] = true, -- 闷棍
	[9484] = true, -- 束缚亡灵
	[20066] = true, -- 忏悔
	
	[339] = true, -- 根须纠缠
	[102359] = true, -- 群体缠绕
	[3355] = true, -- 冰冻陷阱
	[64695] = true, -- 陷地图腾
	
	[5211] = true, -- 蛮力猛击
	[853] = true, -- 制裁之锤	
	[221562] = true, -- 窒息
	
	[118905] = true, -- 电能图腾	
	[132168] = true, -- 震荡波
	[179057] = true, -- 混沌新星
	[30283] = true, -- 暗影之怒
 	[207171] = true, -- 凛冬将至	
	[117405] = true, -- 束缚射击
	[119381] = true, -- 扫堂腿
	[127797] = true, -- 乌索尔旋风
	[205369] = true, --  精神炸弹 
	[81261] = true, -- 日光术
}

G.BlackList = {
	[15407] = true, -- 精神鞭笞
}

-- 姓名板颜色
local Customcoloredplates = {}

for i = 1, 50 do
	Customcoloredplates[i] = {
		name = L["空"],
		color = {r = 1, g = 1, b = 1},
	}
end

-- 姓名板能量
local Custompowerplates = {}

for i = 1, 50 do
	Custompowerplates[i] = {
		name = L["空"],
	}
end

-- 团队框架治疗边角提示（图标）
local default_HealerIndicatorAuraList = {
	PRIEST = { 
        [17] = true,		-- 真言术盾
        [139] = true,		-- 恢复
        [41635] = true,		-- 愈合祷言
        [194384] = true,	-- 救赎
	},
	DRUID = { 
	    [774] = true,		-- 回春
        [155777] = true,	-- 萌芽
        [8936] = true,		-- 愈合
        [33763] = true,		-- 生命绽放
        [48438] = true,		-- 野性成长
		[102351] = true,	-- 塞纳里奥结界
        [102352] = true,	-- 塞纳里奥结界
        [200389] = true,	-- 栽培
	},
	SHAMAN = { 
		[61295] = true,		-- 激流
		[974] = true,		-- 大地之盾
	},
	PALADIN = {
	    [53563] = true,		-- 圣光道标
        [156910] = true,	-- 信仰道标
		[25771] = true,		-- 自律
		[223306] = true,	-- 赋予信仰
		[287280] = true,	-- 圣光闪烁
	},
	WARRIOR = { 
		[12975] = true,		-- 援护
		[114030] = true,	-- 警戒
	},
	MAGE = { 
	
	},
	WARLOCK = { 
	
	},
	HUNTER = { 
		[34477] = true,		-- 误导
	},
	ROGUE = { 
		[57934] = true,		-- 嫁祸
	},
	DEATHKNIGHT = {
	
	},
	MONK = {
	    [119611] = true,	-- 复苏之雾
        [124682] = true,	-- 氤氲之雾
        [124081] = true,	-- 禅意波
		[191840] = true,	-- 精华之泉
		[115175] = true,	-- 抚慰之雾
	},
	DEMONHUNTER = {
	
	},
	EVOKER = {
	
	},
}

local HealerIndicatorAuraList = default_HealerIndicatorAuraList[G.myClass]

-----------------------------------
----          默认配置         ----
-----------------------------------
local Account_default_Settings = {
	meet = false,
	gold = {},
	goldkeywordlist = "",
}

local Character_default_Settings = {
	FramePoints = {},
	UnitframeOptions = {
		style = 1, 
		enablefade = true,
		fadingalpha = 0.2,
		valuefontsize = 16,
		
		-- health/power
		alwayshp = false,
		alwayspp = false,
		classcolormode = false,
		nameclasscolormode = true,
		
		-- portrait
		portrait = true,
	
		-- size
		height	= 18,
		width = 230,
		widthpet = 70,
		widthboss = 170,
		widthparty = 200,
		ppheight = 0.25, -- slider

		-- castbar
		castbars = true,
		cbIconsize = 33,
		independentcb = true,
		namepos = "LEFT",
		timepos = "RIGHT",
		cbheight = 16,
		cbwidth = 230,
		target_cbheight = 5,
		target_cbwidth = 230,
		focus_cbheight = 5,
		focus_cbwidth = 230,
		channelticks = false,
		hideplayercastbaricon = false,
		Interruptible_color = {r =.6 , g = .4, b = .8},	
		notInterruptible_color = {r =.9 , g = 0, b = 1},	
		
		-- swing timer
		swing = false,
		swheight = 12,
		swwidth = 230,
		swtimer = true,
		swtimersize = 12,
		
		-- auras
		aura_size = 20,
		playerdebuffenable = true,
		AuraFilterignoreBuff = false,
		AuraFilterignoreDebuff = false,
		AuraFilterwhitelist = {},
		
		showthreatbar = true,

		-- show/hide boss
		bossframes = true,
		
		-- show/hide arena
		arenaframes = true,

		-- show player in party
		showplayerinparty = true,
		showpartypet = false,
		
		-- show pvp timer
		pvpicon = false,
		
		-- show value
		runecooldown = true,
		dpsmana = true,
		stagger = true,
		valuefs = 12,
		
		-- totems
		totems = true,
		totemsize = 25,
		growthDirection = 'HORIZONTAL',
		sortDirection = 'ASCENDING',
		
		--[[ share ]]--
		enableraid = true,
		raidframe_inparty = false,
		party_num = 4,
		showraidpet = false,
		raidfontsize = 10,
		namelength = 4,
		showsolo = false,
		raidtool = true,
		raidtool_show = true,
		
		--[[ style ]]--
		raidheight = 45,
		raidwidth = 120,
		raidmanabars = true,
		raidppheight = 0.1, -- slider
		party_connected = true,
		hor_party = false,
		showgcd = true,
		showmisshp = true,
		healprediction = true,
		raidrole_icon = false,
		hotind_style = "icon_ind",-- "icon_ind", "number_ind"
		hotind_size = 15,
		hotind_filtertype = "whitelist", -- "blacklist", "whitelist"
		hotind_auralist = HealerIndicatorAuraList,
		raid_debuff_num = 2,
		raid_debuff_anchor_x = -50,
		raid_debuff_anchor_y = -5,
		raid_debuff_icon_size = 22,
		raid_debuff_icon_fontsize = 8,
		raid_buff_num = 1,
		raid_buff_anchor_x = 5,
		raid_buff_anchor_y = -5,
		raid_buff_icon_size = 22,
		raid_buff_icon_fontsize = 8,
		
		--[[ click cast ]]--
		enableClickCast = false,
		ClickCast = ClickCastDB,
		
		--[[ raid debuff ]]--
		debuff_auto_add = true,
		debuff_auto_add_level = 6,
	},
	ChatOptions = {
		channelreplacement = true,
		autoscroll = true,
		nogoldseller = true,
		goldkeywordnum = 2,
		showbg = false,
	},
	ItemOptions = {
		autorepair = true,
		autorepair_guild = true,
		autorepair_guild_auto = true,
		autosell = true,
		alreadyknown = true,
		showitemlevel = true,
		autobuy = false,
		autobuylist = {},
		itemlevels = {},
		itembuttons = false,
		itembuttons_size = 32,
		itembuttons_fsize = 15,
		growdirection_h = "LEFT",
		growdirection_v = "UP",
		number_perline = 6,
		button_space = 2,
	},
	ActionbarOptions = {
		cooldown = true,
		cooldown_wa = true,
		cooldownsize = 20,
		rangecolor = true,
		keybindsize = 12,
		macronamesize = 8,
		countsize = 12,
		cdflash_enable = true,
		cdflash_alpha = 100,
		cdflash_size = 60,
		cdflash_ignorespells = {},
		cdflash_ignoreitems = {
			[6948] = true,
		},
	},
	PlateOptions = {
		-- 通用
		enableplate = true,
		theme = "class", -- "dark" "class" "number"	
		fontsize = 8,
		numfontsize = 10,
		threatcolor = true,		
		plateauranum = 5,
		plateaurasize = 15,	
		Interruptible_color = {r =.6 , g = .4, b = .8},	
		notInterruptible_color = {r =.9 , g = 0, b = 1},	
		focuscolored = true,
		focus_color = {r = .5, g = .4, b = .9},
		
		bar_width = 100,-- 条形
		bar_height = 8,
		bar_hp_perc = "perc", -- 数值样式  "perc" "value_perc"
		bar_alwayshp = false, -- 满血显示生命值
		bar_onlyname = false, -- 友方只显示名字
		
		number_size = 23,-- 数字型
		number_alwayshp = false, -- 满血显示生命值	
		number_cpwidth = 15, -- 职业能量长度
		number_colorheperc = false,
		
		-- 玩家姓名板
		playerplate = false,
		plateaura = false,
		platecastbar = false,
		classresource_show = false,
		classresource_pos = "player", --"player", "target"		
		
		-- 光环列表
		myplateauralist = G.BlackList,		
		otherplateauralist = G.WhiteList,
		myfiltertype = "blacklist", -- "blacklist", "whitelist", "none"
		otherfiltertype = "none", -- "whitelist", "none"
		
		-- 染色列表
		customcoloredplates = Customcoloredplates,
		
		-- 能量列表
		custompowerplates = Custompowerplates,
	},
	TooltipOptions = {
		enabletip = true,
		size = 1,
		cursor = false,
		combathide = true,
	},
	CombattextOptions = {
		combattext = true,
		hidblz = true,
		hidblz_receive = false,
		showreceivedct = true,
		showoutputct = true,
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
		hideerrors = true,
		autoscreenshot = true,
		acceptres = true,
		battlegroundres = true,
		autoinvite = false,
        autoinvitekeywords = "111 123",		
		autoquests = false,
		showAFKtips = true,
		vignettealert = true,
		flashtaskbar = true,
		autopet = true,
		LFGRewards = true,
		autoacceptproposal = true,	
		shiftfocus = false,	
		ctrlmenu = false,
	},
	SkinOptions = {
		combattext = "none",
		setClassColor = true,
		setDBM = true,
		setSkada = true,
		setBW = true,
		showtopbar = true,
		showbottombar = true,
		showtopconerbar = true,
		showbottomconerbar = true,
		formattype = "k", -- w, w_chinese, none
		gui_x = 300,
		gui_y = 300,
		gui_scale = 100,		
		infobar = true,
		infobarscale = 1,
		collectminimapbuttons = true,
		MBCFalwaysshow = false,
		MBCFpos = "BOTTOM",
		collapseWF = true,
		customobjectivetracker = false,
		afklogin = false,
		afkscreen = true,
		minimapbutton = true,
	},
	RaidDebuff = {},
	CooldownAura = AuraList,
	AddonProfiles = {},
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

-----------------------------------
----         导出、导入        ----
-----------------------------------

T.ExportSettings = function(editbox)
	local str = "AltzUI Export".."~"..G.Version.."~"..G.Client.."~"..G.myClass
	for OptionCategroy, OptionTable in pairs(Character_default_Settings) do
		if type(OptionTable) == "table" then
			for setting, value in pairs(OptionTable) do
				if type(value) ~= "table" then -- 3
					if aCoreCDB[OptionCategroy][setting] ~= value then
						local valuetext
						if aCoreCDB[OptionCategroy][setting] == false then
							valuetext = "false"
						elseif aCoreCDB[OptionCategroy][setting] == true then
							valuetext = "true"
						else
							valuetext = aCoreCDB[OptionCategroy][setting]
						end
						str = str.."^"..OptionCategroy.."~"..setting.."~"..valuetext
					end
				else
					if OptionCategroy == "RaidDebuff" then -- 完全复制 5
						for boss, auratable in pairs(value) do
							for spellID, level in pairs (aCoreCDB["RaidDebuff"][setting][boss]) do
								str = str.."^"..OptionCategroy.."~"..setting.."~"..boss.."~"..spellID.."~"..level
							end
						end
					elseif OptionCategroy == "CooldownAura" then -- 完全复制 5
						if setting == "Debuffs_Black" then
							for spellID, bool in pairs (aCoreCDB["CooldownAura"][setting]) do
								str = str.."^"..OptionCategroy.."~"..setting.."~"..spellID
							end
						else
							for spellID, level in pairs (aCoreCDB["CooldownAura"][setting]) do
								str = str.."^"..OptionCategroy.."~"..setting.."~"..spellID.."~"..level
							end
						end
					elseif OptionCategroy == "ItemOptions" then
						if setting == "autobuylist" then -- 完全复制 4
							for id, count in pairs(aCoreCDB["ItemOptions"]["autobuylist"]) do -- 默认是空的
								str = str.."^"..OptionCategroy.."~"..setting.."~"..id.."~"..count
							end
						end
					elseif OptionCategroy == "PlateOptions" then
						if setting == "customcoloredplates" then -- 非空则复制 7
							for index, t in pairs(aCoreCDB["PlateOptions"]["customcoloredplates"]) do
								if t.name ~= L["空"] then
									str = str.."^"..OptionCategroy.."~"..setting.."~"..index.."~"..t.name.."~"..t.color.r.."~"..t.color.g.."~"..t.color.b
								end
							end
						elseif setting == "custompowerplates" then -- 非空则复制 4
							for index, t in pairs(aCoreCDB["PlateOptions"]["custompowerplates"]) do
								if t.name ~= L["空"] then
									str = str.."^"..OptionCategroy.."~"..setting.."~"..index..t.name
								end
							end
						else -- 完全复制 4
							for id, _ in pairs(aCoreCDB["PlateOptions"][setting]) do
								str = str.."^"..OptionCategroy.."~"..setting.."~"..id.."~true"
							end
						end
					elseif setting == "ClickCast" then -- 6
						for k, _ in pairs(value) do
							for j, v in pairs(value[k]) do -- j  Click ctrl- shift- alt-
								local action = aCoreCDB["UnitframeOptions"]["ClickCast"][k][j].action
								local macro = aCoreCDB["UnitframeOptions"]["ClickCast"][k][j].macro
								if action ~= v.action or macro ~= v.macro then
									str = str.."^"..OptionCategroy.."~"..setting.."~"..k.."~"..j.."~"..action.."~"..macro
								end
							end
						end
					elseif setting == "AuraFilterwhitelist" then -- 完全复制 4
						for id, _ in pairs(aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"]) do -- 默认是空的
							str = str.."^"..OptionCategroy.."~"..setting.."~"..id.."~true"
						end
					elseif setting == "cdflash_ignorespells" then -- 完全复制 4
						for spellID, _ in pairs(aCoreCDB["ActionbarOptions"]["cdflash_ignorespells"]) do
							str = str.."^"..OptionCategroy.."~"..setting.."~"..spellID.."~true"
						end
					elseif setting == "cdflash_ignoreitems" then -- 完全复制 4
						for itemID, _ in pairs(aCoreCDB["ActionbarOptions"]["cdflash_ignoreitems"]) do
							str = str.."^"..OptionCategroy.."~"..setting.."~"..itemID.."~true"
						end	
					end
				end
			end
		end
	end
	for frame, info in pairs (aCoreCDB["FramePoints"]) do
		for mode, xy in pairs(info) do
			for key, _ in pairs(xy) do
				local f = _G[frame]
				if f and f["point"] then
					if xy[key] ~= f["point"][mode][key] then
						str = str.."^FramePoints~"..frame.."~"..mode.."~"..key.."~"..xy[key]
						--print(frame.."~"..mode.."~"..key.."~"..xy[key])
					end
				else -- 框体在当前配置尚未创建
					str = str.."^FramePoints~"..frame.."~"..mode.."~"..key.."~"..xy[key]
					--print(frame.."~"..mode.."~"..key.."~"..xy[key])
				end
			end
		end
	end
	editbox:SetText(str)
	editbox:HighlightText()
end

T.ImportSettings = function(str)
	local optionlines = {string.split("^", str)}
	local uiname, version, client, class = string.split("~", optionlines[1])
	local sameversion, sameclient, sameclass
	
	if uiname ~= "AltzUI Export" then
		StaticPopup_Show(G.uiname.."Cannot Import")
	else
		local import_str = ""
		if version ~= G.Version then
			import_str = import_str..format(L["版本不符合"], version, G.Version)
		else
			sameversion = true
		end
		
		if client ~= G.Client then
			import_str = import_str..format(L["客户端不符合"], client, G.Client)
		else
			sameclient = true
		end
		
		if class ~= G.myClass then
			import_str = import_str..format(L["职业不符合"], G.ClassInfo[class], G.ClassInfo[G.myClass])
		else
			sameclass = true
		end
		
		if not (sameversion and sameclient and sameclass) then
			import_str = import_str..L["不完整导入"]
		end
		StaticPopupDialogs[G.uiname.."Import Confirm"].text = format(L["导入确认"]..import_str, "Altz UI")
		StaticPopupDialogs[G.uiname.."Import Confirm"].OnAccept = function()
			aCoreCDB = {}
			T.SetChatFrame()
			T.LoadVariables()
			
			-- 完全复制的设置
			if sameclient then
				aCoreCDB.RaidDebuff = {}
				aCoreCDB.CooldownAura = {}
				aCoreCDB.CooldownAura.Buffs = {}
				aCoreCDB.CooldownAura.Debuffs = {}
				aCoreCDB.CooldownAura.Debuffs_Black = {}
			end
			
			if sameclass then
				aCoreCDB.PlateOptions.myplateauralist = {}
				aCoreCDB.ActionbarOptions.cdflash_ignorespells = {}
			end
			
			aCoreCDB.ActionbarOptions.cdflash_ignoreitems = {}
			aCoreCDB.PlateOptions.otherplateauralist = {}
			
			for index, v in pairs(optionlines) do
				if index ~= 1 then
					local OptionCategroy, setting, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 = string.split("~", v)	
					local count = select(2, string.gsub(v, "~", "~")) + 1
	
					if count == 3 then -- 可以直接赋值
						if aCoreCDB[OptionCategroy][setting] ~= nil then
							if arg1 == "true" then
								aCoreCDB[OptionCategroy][setting] = true	
							elseif arg1 == "false" then
								aCoreCDB[OptionCategroy][setting] = false
							elseif tonumber(arg1) and setting ~= "autoinvitekeywords" and setting ~= "goldkeywordlist" then
								aCoreCDB[OptionCategroy][setting] = tonumber(arg1)
							else
								aCoreCDB[OptionCategroy][setting] = arg1
							end
						end
					else -- 是个表格 sameclient sameclass
						if OptionCategroy == "RaidDebuff" then -- 完全复制 6 OptionCategroy.."~"..setting.."~"..boss.."~"..spellID.."~"..level
							if not aCoreCDB[OptionCategroy][tonumber(setting)] then
								aCoreCDB[OptionCategroy][tonumber(setting)] = {}
							end
							if not aCoreCDB[OptionCategroy][tonumber(setting)][tonumber(arg1)] then
								aCoreCDB[OptionCategroy][tonumber(setting)][tonumber(arg1)] = {}
							end
							aCoreCDB[OptionCategroy][tonumber(setting)][tonumber(arg1)][tonumber(arg2)] = tonumber(arg3)
						elseif OptionCategroy == "CooldownAura" then -- 完全复制 5 OptionCategroy.."~"..setting.."~"..spellID.."~"..level
							if setting ~= "Debuffs_Black" then
								aCoreCDB[OptionCategroy][setting][arg1] = tonumber(arg2)
							else 
								aCoreCDB[OptionCategroy][setting][arg1] = true
							end
						elseif OptionCategroy == "ItemOptions" then
							if setting == "autobuylist" then -- 完全复制 4 OptionCategroy.."~"..setting.."~"..id.."~"..count
								aCoreCDB[OptionCategroy][setting][arg1] = arg2
							end
						elseif OptionCategroy == "PlateOptions" then
							if setting == "customcoloredplates" then -- 非空则复制 7 OptionCategroy.."~"..setting.."~"..index.."~"..t.name.."~"..t.color.r.."~"..t.color.g.."~"..t.color.b
								if sameclient then
									aCoreCDB[OptionCategroy][setting][tonumber(arg1)] = {
										name = arg2,
										color = {
											r = tonumber(arg3),
											g = tonumber(arg4),
											b = tonumber(arg5),
										},
									}
								end
							elseif setting == "custompowerplates" then -- 非空则复制 4
								if sameclient then
									aCoreCDB[OptionCategroy][setting][tonumber(arg1)] = {
										name = arg2,
									}
								end
							elseif setting == "otherplateauralist" then -- 完全复制 4 OptionCategroy.."~"..setting.."~"..id.."~true"
								aCoreCDB[OptionCategroy][setting][tonumber(arg1)] = true
							elseif sameclass and setting then
								aCoreCDB[OptionCategroy][setting][tonumber(arg1)] = true
							end
						elseif OptionCategroy == "FramePoints" then -- 5 ^FramePoints~"..frame.."~"..mode.."~"..key.."~"..xy[key]
							if aCoreCDB[OptionCategroy][setting] == nil then
								aCoreCDB[OptionCategroy][setting] = {}
							end
							if aCoreCDB[OptionCategroy][setting][arg1] == nil then
								aCoreCDB[OptionCategroy][setting][arg1] = {}
							end
							if arg2 == "x" or arg2 == "y" then
								aCoreCDB[OptionCategroy][setting][arg1][arg2] = tonumber(arg3)
							else
								aCoreCDB[OptionCategroy][setting][arg1][arg2] = arg3
							end
						elseif setting == "ClickCast" then -- 6 OptionCategroy.."~"..setting.."~"..k.."~"..j.."~"..action.."~"..macro
							if sameclient and sameclass then
								aCoreCDB[OptionCategroy][setting][tostring(arg1)][arg2]["action"] = arg3
								aCoreCDB[OptionCategroy][setting][tostring(arg1)][arg2]["macro"] = arg4
							end
						elseif setting == "AuraFilterwhitelist" then -- 完全复制 4 OptionCategroy.."~"..setting.."~"..id.."~true"
							if sameclient then
								aCoreCDB[OptionCategroy][setting][arg1] = true
							end
						elseif setting == "cdflash_ignorespells" and sameclass then -- 完全复制 4 OptionCategroy.."~"..setting.."~"..spellID.."~true"	
							aCoreCDB[OptionCategroy][setting][tonumber(arg1)] = true
						elseif setting == "cdflash_ignoreitems" then -- 完全复制 4 OptionCategroy.."~"..setting.."~"..spellID.."~true"	
							aCoreCDB[OptionCategroy][setting][tonumber(arg1)] = true
						end
					end

				end
			end
		ReloadUI()
		end
		StaticPopup_Show(G.uiname.."Import Confirm")
	end
end