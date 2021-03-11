local T, C, L, G = unpack(select(2, ...))

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

local EJ_GetEncounterInfo = function(value)
	local a = EJ_GetEncounterInfo(value)
	return a
end

local AuraList = {
	["Buffs"] = {
	--牧师
		[GetSpellInfo(33206)]  = { id = 33206,  level = 15,}, -- 痛苦压制
        [GetSpellInfo(47788)]  = { id = 47788,  level = 15,}, -- 守护之魂
		[GetSpellInfo(47585)]  = { id = 47585,  level = 15,}, -- 消散		
	--小德
        [GetSpellInfo(102342)] = { id = 102342, level = 15,}, -- 铁木树皮
		[GetSpellInfo(22812)]  = { id = 22812,  level = 15,}, -- 树皮术
		[GetSpellInfo(61336)]  = { id = 61336,  level = 15,}, -- 生存本能
		[GetSpellInfo(22842)]  = { id = 22842,  level = 15,}, -- 狂暴回复
	--骑士
		[GetSpellInfo(1022)]   = { id = 1022,   level = 15,}, -- 保护之手
		[GetSpellInfo(31850)]  = { id = 31850,  level = 15,}, -- 炽热防御者
        [GetSpellInfo(498)]    = { id = 498,    level = 15,}, -- 圣佑术
		[GetSpellInfo(642)]    = { id = 642,    level = 15,}, -- 圣盾术
		[GetSpellInfo(86659)]  = { id = 86659,  level = 15,}, -- 远古列王守卫
		[GetSpellInfo(132403)] = { id = 132403, level = 13,}, -- 个人添加：正义盾击
		[GetSpellInfo(204018)] = { id = 204018, level = 15,}, -- 个人添加：破咒祝福
		[GetSpellInfo(6940)]   = { id = 6940,   level = 15,}, -- 个人添加：牺牲祝福
	--DK
		[GetSpellInfo(48707)]  = { id = 48707,  level = 15,}, -- 反魔法护罩
		[GetSpellInfo(48792)]  = { id = 48792,  level = 15,}, -- 冰封之韧
		[GetSpellInfo(49028)]  = { id = 49028,  level = 15,}, -- 吸血鬼之血
		[GetSpellInfo(55233)]  = { id = 55233,  level = 15,}, -- 符文刃舞
		[GetSpellInfo(194844)] = { id = 194844, level = 15,}, -- 个人添加：白骨风暴
	--战士
		[GetSpellInfo(12975)]  = { id = 12975,  level = 15,}, -- 破釜沉舟
		[GetSpellInfo(871)]    = { id = 871,    level = 15,}, -- 盾墙
		[GetSpellInfo(184364)]  = { id = 184364,  level = 15,}, -- 狂怒回复
		[GetSpellInfo(118038)]  = { id = 118038,  level = 15,}, -- 剑在人在
	--DH
		[GetSpellInfo(196555)]  = { id = 196555,  level = 15,}, -- 虚空行走 浩劫
		[GetSpellInfo(187827)]  = { id = 187827,  level = 15,}, -- 恶魔变形
		[GetSpellInfo(212084)]  = { id = 212084,  level = 15,}, -- 邪能毁灭
		[GetSpellInfo(204021)]  = { id = 204021,  level = 15,}, -- 烈火烙印
		[GetSpellInfo(203720)]  = { id = 203720,  level = 15,}, -- 恶魔尖刺
	--猎人
		[GetSpellInfo(186265)]  = { id = 186265,  level = 15,}, -- 灵龟守护
	--盗贼
		[GetSpellInfo(31224)]  = { id = 31224,  level = 15,}, -- 暗影斗篷
		[GetSpellInfo(1966)]  = { id = 1966,  level = 15,}, -- 佯攻
	--术士
		[GetSpellInfo(104773)]  = { id = 104773,  level = 15,}, -- 不灭决心
	--法师
		[GetSpellInfo(45438)]  = { id = 45438,  level = 15,}, -- 寒冰屏障
	--武僧
		[GetSpellInfo(116849)] = { id = 116849, level = 15,}, -- 作茧缚命
		[GetSpellInfo(115203)] = { id = 115203, level = 15,}, -- 壮胆酒
		[GetSpellInfo(122470)]  = { id = 122470,  level = 15,}, -- 业报之触
		[GetSpellInfo(122783)]  = { id = 122783,  level = 15,}, -- 散魔功
	--萨满
		[GetSpellInfo(108271)]  = { id = 108271,  level = 15,}, -- 星界转移
	--通用
		[GetSpellInfo(324867)]  = { id = 324867,  level = 6,}, -- 血肉铸造

	},
	["Debuffs"] = {
		[GetSpellInfo(240559)]  = { id = 240559,  level = 6,},  -- 重伤
		[GetSpellInfo(209858)]  = { id = 209858,  level = 6,},  -- 死疽
		
		--9.0
		[GetSpellInfo(240443)]  = { id = 240443,  level = 8,}, -- 爆裂词缀
		[GetSpellInfo(240447)]  = { id = 240447,  level = 8,}, -- 践踏，地震词缀
		[GetSpellInfo(342494)]  = { id = 342494,  level = 8,}, -- 狂妄吹嘘，昏迷
		[GetSpellInfo(342466)]  = { id = 342466,  level = 8,}, -- 狂妄吹嘘，点名
		[GetSpellInfo(225080)]  = { id = 225080,  level = 8,}, -- 萨满重生，可诈尸
		[GetSpellInfo(160029)]  = { id = 160029,  level = 6,}, -- 正在复活
		[GetSpellInfo(292910)]  = { id = 292910,  level = 8,}, -- 镣铐，爬塔
		[GetSpellInfo(1604)]  = { id = 1604,  level = 6,}, -- 眩晕
	},
	["Debuffs_Black"] = {
		[GetSpellInfo(57723)]  = { id = 57723,  level = 6,}, -- 筋疲力尽
		[GetSpellInfo(80354)]  = { id = 80354,  level = 6,}, -- 时空错位
		[GetSpellInfo(264689)] = { id = 264689,  level = 6,}, -- 疲倦
		[GetSpellInfo(340880)] = { id = 340880,  level = 6,}, -- 傲慢
		[GetSpellInfo(206151)] = { id = 206151,  level = 6,}, -- 挑战者的负担
		[GetSpellInfo(15007)] = { id = 15007,  level = 6,}, -- 复活虚弱
		[GetSpellInfo(113942)] = { id = 113942,  level = 6,}, -- 无法再用恶魔传送门
		[GetSpellInfo(209261)] = { id = 209261,  level = 6,}, -- 未被污染的邪能，DH假死
		[GetSpellInfo(87024)] = { id = 87024,  level = 6,}, -- 灸灼，法师假死
		[GetSpellInfo(41425)] = { id = 41425,  level = 6,}, -- 低温，法师不能再用冰箱
		[GetSpellInfo(326809)] = { id = 326809,  level = 6,}, -- 餍足，DK假死
		[GetSpellInfo(45181)] = { id = 45181,  level = 6,}, -- 装死，盗贼假死
		[GetSpellInfo(320227)]  = { id = 320227,  level = 6,}, -- 枯竭外壳，法夜诈尸
		[GetSpellInfo(340556)] = { id = 340556,  level = 6,}, -- 精确本能，导灵器
		[GetSpellInfo(344907)] = { id = 344907,  level = 6,}, -- 奥的裂解之心
		[GetSpellInfo(348254)] = { id = 348254,  level = 6,}, -- 典狱长之眼
		[GetSpellInfo(338606)] = { id = 338906,  level = 6,}, -- 典狱长之链
		[GetSpellInfo(26013)] = { id = 26013,  level = 6,}, -- 逃亡者
		[GetSpellInfo(187464)] = { id = 187464,  level = 6,}, -- 暗影愈合
		[GetSpellInfo(124275)] = { id = 124275,  level = 6,}, -- 轻度醉拳
		[GetSpellInfo(124274)] = { id = 124274,  level = 6,}, -- 中度醉拳
		[GetSpellInfo(25771)]  = { id = 25771,  level = 6,}, -- 自律
		[GetSpellInfo(340870)] = { id = 340870,  level = 6,}, -- 恐怖光环，圣物匠全屏aoe
		[GetSpellInfo(325184)] = { id = 325184,  level = 6,}, -- 自由心能，女勋爵全屏debuff
		[GetSpellInfo(334909)] = { id = 334909,  level = 6,}, -- 压制气场，议会全屏debuff
		[GetSpellInfo(346939)] = { id = 346939,  level = 6,}, -- 扭曲痛苦，议会全屏debuff
		[GetSpellInfo(332443)] = { id = 332443,  level = 6,}, -- 泥拳，震动的地基，全屏aoe
		[GetSpellInfo(343063)] = { id = 343063,  level = 6,}, -- 干将，大地之刺减速
		[GetSpellInfo(328276)] = { id = 328276,  level = 6,}, -- 悔悟之行，尾王没用debuff
		[GetSpellInfo(334228)] = { id = 334228,  level = 6,}, -- 不稳定的喷发，3号无需监控
		[GetSpellInfo(329725)] = { id = 329725,  level = 6,}, -- 根除，3号无需监控
	},
}

if G.myClass == "PALADIN"  then
	AuraList["Debuffs"][GetSpellInfo(25771)] = {id = 25771,  level = 6}  -- 自律
end

--instanceID, name, description, bgImage, buttonImage, loreImage, dungeonAreaMapID, link = EJ_GetInstanceByIndex(index, isRaid)
--name, description, encounterID, rootSectionID, link = EJ_GetEncounterInfoByIndex(index[, instanceID])

G.Raids = {
	[EJ_GetInstanceInfo(1187)] = { -- 伤逝剧场
		EJ_GetEncounterInfo(2397),
		EJ_GetEncounterInfo(2401),
		EJ_GetEncounterInfo(2390),
		EJ_GetEncounterInfo(2389),
		EJ_GetEncounterInfo(2417),
		"Trash",
	},
	
	[EJ_GetInstanceInfo(1183)] = { -- 凋魂之殇
		EJ_GetEncounterInfo(2419),
		EJ_GetEncounterInfo(2403),
		EJ_GetEncounterInfo(2423),
		EJ_GetEncounterInfo(2404),
		"Trash",
	},
	
	[EJ_GetInstanceInfo(1184)] = { -- 塞兹仙林的迷雾
		EJ_GetEncounterInfo(2400),
		EJ_GetEncounterInfo(2402),
		EJ_GetEncounterInfo(2405),
		"Trash",
	},
	
	[EJ_GetInstanceInfo(1188)] = { -- 彼界
		EJ_GetEncounterInfo(2408),
		EJ_GetEncounterInfo(2409),
		EJ_GetEncounterInfo(2398),
		EJ_GetEncounterInfo(2410),
		"Trash",
	},
	
	[EJ_GetInstanceInfo(1186)] = { -- 晋升高塔
		EJ_GetEncounterInfo(2399),
		EJ_GetEncounterInfo(2416),
		EJ_GetEncounterInfo(2414),
		EJ_GetEncounterInfo(2412),
		"Trash",
	},
	
	[EJ_GetInstanceInfo(1185)] = { -- 赎罪大厅
		EJ_GetEncounterInfo(2406),
		EJ_GetEncounterInfo(2387),
		EJ_GetEncounterInfo(2411),
		EJ_GetEncounterInfo(2413),
		"Trash",
	},
	
	[EJ_GetInstanceInfo(1189)] = { -- 赤红深渊
		EJ_GetEncounterInfo(2388),
		EJ_GetEncounterInfo(2415),
		EJ_GetEncounterInfo(2421),
		EJ_GetEncounterInfo(2407),
		"Trash",
	},
	
	[EJ_GetInstanceInfo(1182)] = { -- 通灵战潮
		EJ_GetEncounterInfo(2395),
		EJ_GetEncounterInfo(2391),
		EJ_GetEncounterInfo(2392),
		EJ_GetEncounterInfo(2396),
		"Trash",
	},
	
	[EJ_GetInstanceInfo(1192)] = { -- 世界Boss
		EJ_GetEncounterInfo(2430),
		EJ_GetEncounterInfo(2431),
		EJ_GetEncounterInfo(2432),
		EJ_GetEncounterInfo(2433),
	},
	
	[EJ_GetInstanceInfo(1190)] = { -- 纳斯利亚堡
		EJ_GetEncounterInfo(2393),
		EJ_GetEncounterInfo(2429),
		EJ_GetEncounterInfo(2422),
		EJ_GetEncounterInfo(2418),
		EJ_GetEncounterInfo(2428),
		EJ_GetEncounterInfo(2420),
		EJ_GetEncounterInfo(2426),
		EJ_GetEncounterInfo(2394),
		EJ_GetEncounterInfo(2425),
		EJ_GetEncounterInfo(2424),
		"Trash",
	},
}


G.DebuffList = {
	[EJ_GetInstanceInfo(1187)] = { -- 伤逝剧场
		[EJ_GetEncounterInfo(2397)] = { --> 狭路相逢
			[GetSpellInfo(326892)] = {id = 326892, level = 8,}, -- 锁定
			[GetSpellInfo(333231)] = {id = 333231, level = 8,}, -- 灼热之陨
			[GetSpellInfo(333540)] = {id = 333540, level = 8,}, -- 机会打击
			[GetSpellInfo(320069)] = {id = 320069, level = 8,}, -- 致死打击
		},
		[EJ_GetEncounterInfo(2401)] = { --> 斩血
			[GetSpellInfo(321768)] = {id = 321768, level = 8,}, -- 上钩了
			[GetSpellInfo(323406)] = {id = 323406, level = 8,}, -- 锯齿创口
		},
		[EJ_GetEncounterInfo(2390)] = { --> 无堕者哈夫
			[GetSpellInfo(320287)] = {id = 320287, level = 8,}, -- 鲜血与荣耀
			[GetSpellInfo(331606)] = {id = 331606, level = 8,}, -- 压制战旗
		},
		[EJ_GetEncounterInfo(2389)] = { --> 库尔萨洛克
			[GetSpellInfo(319539)] = {id = 319539, level = 8,}, -- 无魂者
			[GetSpellInfo(319521)] = {id = 319521, level = 8,}, -- 抽取灵魂
			[GetSpellInfo(319669)] = {id = 319669, level = 8,}, -- 幽灵界域
			[GetSpellInfo(319626)] = {id = 319626, level = 8,}, -- 幻影寄生
		},
		[EJ_GetEncounterInfo(2417)] = { --> 无尽女皇莫德雷莎
			[GetSpellInfo(323825)] = {id = 323825, level = 8,}, -- 攫取裂隙
			[GetSpellInfo(324449)] = {id = 324449, level = 8,}, -- 死亡具象
		},
		["Trash"] = {
			[GetSpellInfo(333299)] = {id = 333299, level = 8,}, -- 荒芜诅咒
			[GetSpellInfo(330532)] = {id = 330532, level = 8,}, -- 锯齿箭
			[GetSpellInfo(342675)] = {id = 342675, level = 8,}, -- 骨矛
			[GetSpellInfo(341949)] = {id = 341949, level = 8,}, -- 枯萎凋零
			[GetSpellInfo(333861)] = {id = 333861, level = 8,}, -- 回旋利刃
			[GetSpellInfo(333845)] = {id = 333845, level = 8,}, -- 失衡重击
			[GetSpellInfo(333708)] = {id = 333708, level = 8,}, -- 灵魂腐蚀
			[GetSpellInfo(332836)] = {id = 332836, level = 8,}, -- 劈砍
			[GetSpellInfo(332708)] = {id = 332708, level = 8,}, -- 大地猛击
			[GetSpellInfo(331288)] = {id = 331288, level = 8,}, -- 巨人打击
			[GetSpellInfo(330868)] = {id = 330868, level = 8,}, -- 通灵箭雨
			[GetSpellInfo(330810)] = {id = 330810, level = 8,}, -- 束缚灵魂
			[GetSpellInfo(330784)] = {id = 330784, level = 8,}, -- 通灵箭
			[GetSpellInfo(330700)] = {id = 330700, level = 8,}, -- 凋零腐烂
			[GetSpellInfo(330592)] = {id = 330592, level = 8,}, -- 邪恶爆发
			[GetSpellInfo(330562)] = {id = 330562, level = 8,}, -- 挫志怒吼
			[GetSpellInfo(320679)] = {id = 320679, level = 8,}, -- 冲锋
			[GetSpellInfo(320248)] = {id = 320248, level = 8,}, -- 基因变异
			[GetSpellInfo(320180)] = {id = 320180, level = 8,}, -- 剧毒孢子
			[GetSpellInfo(323130)] = {id = 323130, level = 8,}, -- 凝固淤泥
			[GetSpellInfo(323750)] = {id = 323750, level = 8,}, -- 邪恶毒气
		},
	},

	[EJ_GetInstanceInfo(1183)] = { -- 凋魂之殇
		[EJ_GetEncounterInfo(2419)] = { --> 酷团
			[GetSpellInfo(326242)] = {id = 326242, level = 8,}, -- 软泥浪潮
			[GetSpellInfo(324652)] = {id = 324652, level = 8,}, -- 衰弱魔药
		},
		[EJ_GetEncounterInfo(2403)] = { --> 伊库斯博士
			[GetSpellInfo(329110)] = {id = 329110, level = 8,}, -- 软泥注射
			[GetSpellInfo(322358)] = {id = 322358, level = 8,}, -- 燃灼菌株
			[GetSpellInfo(322410)] = {id = 322410, level = 8,}, -- 凋零污秽
		},
		[EJ_GetEncounterInfo(2423)] = { --> 多米娜
			[GetSpellInfo(336258)] = {id = 336258, level = 8,}, -- 落单狩猎
			[GetSpellInfo(331818)] = {id = 331818, level = 8,}, -- 暗影伏击
			[GetSpellInfo(333353)] = {id = 333353, level = 8,}, -- 暗影伏击2
			[GetSpellInfo(325552)] = {id = 325552, level = 8,}, -- 毒性裂击
			[GetSpellInfo(333406)] = {id = 333406, level = 8,}, -- 伏击
		},
		[EJ_GetEncounterInfo(2404)] = { --> 斯特拉达玛侯爵
			[GetSpellInfo(331399)] = {id = 331399, level = 8,}, -- 感染毒雨
			[GetSpellInfo(322492)] = {id = 322492, level = 8,}, -- 魔药溃烂
		},
		["Trash"] = {
			[GetSpellInfo(336301)] = {id = 336301, level = 8,}, -- 裹体之网
			[GetSpellInfo(340655)] = {id = 340655, level = 8,}, -- 灵魂腐化
			[GetSpellInfo(338183)] = {id = 338183, level = 8,}, -- 恶心
			[GetSpellInfo(334926)] = {id = 334926, level = 8,}, -- 猥琐痰液
			[GetSpellInfo(330513)] = {id = 330513, level = 8,}, -- 毁灭蘑菇
			[GetSpellInfo(330069)] = {id = 330069, level = 8,}, -- 凝结魔药
			[GetSpellInfo(328986)] = {id = 328986, level = 8,}, -- 剧烈爆炸
			[GetSpellInfo(328501)] = {id = 328501, level = 8,}, -- 魔药爆炸
			[GetSpellInfo(328429)] = {id = 328429, level = 8,}, -- 窒息勒压
			[GetSpellInfo(328409)] = {id = 328409, level = 8,}, -- 纠结缠网
			[GetSpellInfo(328395)] = {id = 328395, level = 8,}, -- 剧毒打击
			[GetSpellInfo(328180)] = {id = 328180, level = 8,}, -- 攫握感染
			[GetSpellInfo(328002)] = {id = 328002, level = 8,}, -- 孢子投掷
			[GetSpellInfo(327882)] = {id = 327882, level = 8,}, -- 凋零俯冲
			[GetSpellInfo(320542)] = {id = 320542, level = 8,}, -- 荒芜凋零
			[GetSpellInfo(320512)] = {id = 320512, level = 8,}, -- 侵蚀爪击
			[GetSpellInfo(320072)] = {id = 320072, level = 8,}, -- 剧毒之池
			[GetSpellInfo(319898)] = {id = 319898, level = 8,}, -- 邪恶喷吐
			[GetSpellInfo(319120)] = {id = 319120, level = 8,}, -- 腐烂胆汁
			[GetSpellInfo(319070)] = {id = 319070, level = 8,}, -- 腐蚀泥胶
			[GetSpellInfo(340355)] = {id = 340355, level = 8,}, -- 急速感染
			[GetSpellInfo(331871)] = {id = 331871, level = 8,}, -- 疫病之触
			[GetSpellInfo(335882)] = {id = 335882, level = 8,}, -- 附身感染
			[GetSpellInfo(344005)] = {id = 344005, level = 8,}, -- 幼体炸弹
			[GetSpellInfo(327515)] = {id = 327515, level = 8,}, -- 腐沼钉刺
		},
	},

	[EJ_GetInstanceInfo(1184)] = { -- 塞兹仙林的迷雾
		[EJ_GetEncounterInfo(2400)] = { --> 英格拉·马洛克
			[GetSpellInfo(328756)] = {id = 328756, level = 8,}, -- 憎恨之容
			[GetSpellInfo(323250)] = {id = 323250, level = 8,}, -- 心能泥浆
			[GetSpellInfo(323146)] = {id = 323146, level = 8,}, -- 死亡之拥
		},
		[EJ_GetEncounterInfo(2402)] = { --> 唤雾者
			[GetSpellInfo(321893)] = {id = 321893, level = 8,}, -- 冻结爆发
			[GetSpellInfo(321891)] = {id = 321891, level = 8,}, -- 鬼抓人锁定
			[GetSpellInfo(321828)] = {id = 321828, level = 8,}, -- 肉饼蛋糕
		},
		[EJ_GetEncounterInfo(2405)] = { --> 特雷德奥瓦
			[GetSpellInfo(331172)] = {id = 331172, level = 8,}, -- 心灵连接
			[GetSpellInfo(322648)] = {id = 322648, level = 8,}, -- 心灵连接2
			[GetSpellInfo(322614)] = {id = 322614, level = 8,}, -- 心灵连接3
			[GetSpellInfo(322563)] = {id = 322563, level = 8,}, -- 被标记的猎物
			[GetSpellInfo(341198)] = {id = 341198, level = 8,}, -- 易燃爆炸，这条可能有错误
			[GetSpellInfo(337253)] = {id = 337253, level = 8,}, -- 寄生占据
			[GetSpellInfo(337251)] = {id = 337251, level = 8,}, -- 寄生瘫痪
			[GetSpellInfo(337220)] = {id = 337220, level = 8,}, -- 寄生平静
			[GetSpellInfo(326309)] = {id = 326309, level = 8,}, -- 腐烂酸液
		},
		["Trash"] = {
			[GetSpellInfo(325027)] = {id = 325027, level = 8,}, -- 荆棘爆发
			[GetSpellInfo(323043)] = {id = 323043, level = 8,}, -- 放血
			[GetSpellInfo(322557)] = {id = 322557, level = 8,}, -- 灵魂分裂
			[GetSpellInfo(340288)] = {id = 340288, level = 8,}, -- 三重撕咬
			[GetSpellInfo(340283)] = {id = 340283, level = 8,}, -- 释放剧毒
			[GetSpellInfo(340208)] = {id = 340208, level = 8,}, -- 碎甲
			[GetSpellInfo(340160)] = {id = 340160, level = 8,}, -- 辐光之息
			[GetSpellInfo(338274)] = {id = 338274, level = 8,}, -- 多头蛇之种
			[GetSpellInfo(331721)] = {id = 331721, level = 8,}, -- 长矛乱舞
			[GetSpellInfo(326092)] = {id = 326092, level = 8,}, -- 衰弱毒药
			[GetSpellInfo(325418)] = {id = 325418, level = 8,}, -- 不稳定的酸液
			[GetSpellInfo(325224)] = {id = 325224, level = 8,}, -- 心能注入
			[GetSpellInfo(325021)] = {id = 325021, level = 8,}, -- 纱雾撕裂
			[GetSpellInfo(324859)] = {id = 324859, level = 8,}, -- 木棘缠绕
			[GetSpellInfo(322968)] = {id = 322968, level = 8,}, -- 濒死之息
			[GetSpellInfo(322939)] = {id = 322939, level = 8,}, -- 收割精魂
			[GetSpellInfo(322486)] = {id = 322486, level = 8,}, -- 过度生长
			[GetSpellInfo(321968)] = {id = 321968, level = 8,}, -- 迷乱花粉
			[GetSpellInfo(326017)] = {id = 326017, level = 8,}, -- 腐烂酸液
		},
	},

	[EJ_GetInstanceInfo(1188)] = { -- 彼界
		[EJ_GetEncounterInfo(2408)] = { --> 哈卡
			[GetSpellInfo(328987)] = {id = 328987, level = 8,}, -- 狂热
			[GetSpellInfo(322746)] = {id = 322746, level = 8,}, -- 堕落之血
			[GetSpellInfo(323118)] = {id = 323118, level = 8,}, -- 鲜血弹幕
			[GetSpellInfo(323569)] = {id = 323569, level = 8,}, -- 溅洒精魂1
			[GetSpellInfo(332332)] = {id = 332332, level = 8,}, -- 溅洒精魂2
		},
		[EJ_GetEncounterInfo(2409)] = { --> 法力风暴
			[GetSpellInfo(320786)] = {id = 320786, level = 8,}, -- 势不可挡
			[GetSpellInfo(320147)] = {id = 320147, level = 8,}, -- 流血
			[GetSpellInfo(324010)] = {id = 324010, level = 8,}, -- 发射
			[GetSpellInfo(320132)] = {id = 320132, level = 8,}, -- 暗影之怒
			[GetSpellInfo(323877)] = {id = 323877, level = 8,}, -- 反射手指型激光发射器究极版
			[GetSpellInfo(320144)] = {id = 320144, level = 8,}, -- 电锯
			[GetSpellInfo(320142)] = {id = 320142, level = 8,}, -- 末日魔王
			[GetSpellInfo(320008)] = {id = 320008, level = 8,}, -- 寒冰箭
		},
		[EJ_GetEncounterInfo(2398)] = { --> 艾柯莎
			[GetSpellInfo(323692)] = {id = 323692, level = 8,}, -- 奥术易伤
			[GetSpellInfo(321948)] = {id = 321948, level = 8,}, -- 定向爆破计划 --待确认
			[GetSpellInfo(342961)] = {id = 342961, level = 8,}, -- 定向爆破计谋
			[GetSpellInfo(323687)] = {id = 323687, level = 8,}, -- 奥术闪电
			[GetSpellInfo(320232)] = {id = 320232, level = 8,}, -- 爆破计谋
			},
		[EJ_GetEncounterInfo(2410)] = { --> 穆厄扎拉
			[GetSpellInfo(334913)] = {id = 334913, level = 8,}, -- 死亡之主
			[GetSpellInfo(325725)] = {id = 325725, level = 8,}, -- 寰宇操控
			[GetSpellInfo(327649)] = {id = 327649, level = 8,}, -- 粉碎灵魂
		},
		["Trash"] = {
			[GetSpellInfo(334496)] = {id = 334496, level = 8,}, -- 催眠光粉
			[GetSpellInfo(339978)] = {id = 339978, level = 8,}, -- 安抚迷雾，沉默
			[GetSpellInfo(333250)] = {id = 333250, level = 8,}, -- 放血之击
			[GetSpellInfo(332605)] = {id = 332605, level = 8,}, -- 妖术
			[GetSpellInfo(340026)] = {id = 340026, level = 8,}, -- 哀嚎之痛
			[GetSpellInfo(336838)] = {id = 336838, level = 8,}, -- 死亡饥渴
			[GetSpellInfo(334535)] = {id = 334535, level = 8,}, -- 啄裂
			[GetSpellInfo(334530)] = {id = 334530, level = 8,}, -- 诱捕淤血
			[GetSpellInfo(333711)] = {id = 333711, level = 8,}, -- 衰弱之咬
			[GetSpellInfo(332707)] = {id = 332707, level = 8,}, -- 痛
			[GetSpellInfo(332678)] = {id = 332678, level = 8,}, -- 龟裂创伤
			[GetSpellInfo(332236)] = {id = 332236, level = 8,}, -- 淤泥抓取
			[GetSpellInfo(331847)] = {id = 331847, level = 8,}, -- W-00F
			[GetSpellInfo(331379)] = {id = 331379, level = 8,}, -- 润滑剂
			[GetSpellInfo(331126)] = {id = 331126, level = 8,}, -- 超级黏黏弹
			[GetSpellInfo(331008)] = {id = 331008, level = 8,}, -- 黏黏弹
			[GetSpellInfo(328605)] = {id = 328605, level = 8,}, -- 不可阻挡的冲突
			[GetSpellInfo(321349)] = {id = 321349, level = 8,}, -- 吸收之雾
			[GetSpellInfo(323118)] = {id = 323118, level = 8,}, -- 鲜血弹幕
			[GetSpellInfo(334505)] = {id = 334505, level = 8,}, -- 光尘之梦
		},
	},
	
	[EJ_GetInstanceInfo(1186)] = { -- 晋升高塔
		[EJ_GetEncounterInfo(2399)] = { --> 金塔拉
			[GetSpellInfo(327481)] = {id = 327481, level = 8,}, -- 黑暗长枪
			[GetSpellInfo(331251)] = {id = 331251, level = 8,}, -- 深度联结
			[GetSpellInfo(324662)] = {id = 324662, level = 8,}, -- 离子电浆
		},
		[EJ_GetEncounterInfo(2416)] = { --> 雯图纳柯丝
			[GetSpellInfo(324154)] = {id = 324154, level = 8,}, -- 暗影迅步
			[GetSpellInfo(324205)] = {id = 324205, level = 8,}, -- 炫目闪光
		},
		[EJ_GetEncounterInfo(2414)] = { --> 奥莱芙莉安
			[GetSpellInfo(323195)] = {id = 323195, level = 8,}, -- 净化冲击波
			[GetSpellInfo(331997)] = {id = 331997, level = 8,}, -- 心能澎湃
			[GetSpellInfo(338729)] = {id = 338729, level = 8,}, -- 充能心能
			[GetSpellInfo(338731)] = {id = 338731, level = 8,}, -- 充能心能2
			[GetSpellInfo(323792)] = {id = 323792, level = 8,}, -- 心能力场
		},
		[EJ_GetEncounterInfo(2412)] = { --> 疑虑圣杰德沃斯
			[GetSpellInfo(322818)] = {id = 322818, level = 8,}, -- 失去信心
			[GetSpellInfo(322817)] = {id = 322817, level = 8,}, -- 疑云密布
			[GetSpellInfo(335805)] = {id = 335805, level = 8,}, -- 执政官的壁垒
		},
		["Trash"] = {
			[GetSpellInfo(317661)] = {id = 317661, level = 8,}, -- 险恶毒液
			[GetSpellInfo(328331)] = {id = 328331, level = 8,}, -- 严刑逼供
			[GetSpellInfo(328453)] = {id = 328453, level = 8,}, -- 压迫
			[GetSpellInfo(328434)] = {id = 328434, level = 8,}, -- 胁迫
			[GetSpellInfo(327648)] = {id = 327648, level = 8,}, -- 内爆
			[GetSpellInfo(323744)] = {id = 323744, level = 8,}, -- 突袭
			[GetSpellInfo(323739)] = {id = 323739, level = 8,}, -- 残留冲击
			[GetSpellInfo(317963)] = {id = 317963, level = 8,}, -- 知识烦扰
			[GetSpellInfo(317626)] = {id = 317626, level = 8,}, -- 渊触毒液
			[GetSpellInfo(341215)] = {id = 341215, level = 8,}, -- 动荡心能
			[GetSpellInfo(27638)] = {id = 27638, level = 8,}, -- 斜掠
		},
	},
	
	[EJ_GetInstanceInfo(1185)] = { -- 赎罪大厅
		[EJ_GetEncounterInfo(2406)] = { --> 罪污巨像
			[GetSpellInfo(339237)] = {id = 339237, level = 8,}, -- 罪光幻象
			[GetSpellInfo(323001)] = {id = 323001, level = 8,}, -- 玻璃裂片
		},
		[EJ_GetEncounterInfo(2387)] = { --> 艾谢郎
			[GetSpellInfo(319603)] = {id = 319603, level = 8,}, -- 羁石诅咒
			[GetSpellInfo(344874)] = {id = 344874, level = 8,}, -- 粉碎
			[GetSpellInfo(319703)] = {id = 319703, level = 8,}, -- 鲜血洪流
		},
		[EJ_GetEncounterInfo(2411)] = { --> 高阶裁决官阿丽兹
			[GetSpellInfo(323650)] = {id = 323650, level = 8,}, -- 萦绕锁定
		},
		[EJ_GetEncounterInfo(2413)] = { --> 宫务大臣
			[GetSpellInfo(335338)] = {id = 335338, level = 8,}, -- 哀伤仪式
			[GetSpellInfo(323437)] = {id = 323437, level = 8,}, -- 傲慢罪印
		},
		["Trash"] = {
			[GetSpellInfo(326891)] = {id = 326891, level = 8,}, -- 痛楚
			[GetSpellInfo(329321)] = {id = 329321, level = 8,}, -- 锯齿横扫
			[GetSpellInfo(344993)] = {id = 344993, level = 8,}, -- 锯齿横扫2
			[GetSpellInfo(319611)] = {id = 319611, level = 8,}, -- 变成石头
			[GetSpellInfo(325876)] = {id = 325876, level = 8,}, -- 湮灭诅咒
			[GetSpellInfo(326632)] = {id = 326632, level = 8,}, -- 石化血脉
			[GetSpellInfo(326874)] = {id = 326874, level = 8,}, -- 脚踝撕咬
			[GetSpellInfo(340446)] = {id = 340446, level = 8,}, -- 嫉妒之印
			[GetSpellInfo(326638)] = {id = 326638, level = 8,}, -- 投掷战刃
			[GetSpellInfo(325701)] = {id = 325701, level = 8,}, -- 生命虹吸
			[GetSpellInfo(325700)] = {id = 325700, level = 8,}, -- 收集罪恶
		},
	},
	
	[EJ_GetInstanceInfo(1189)] = { -- 赤红深渊
		[EJ_GetEncounterInfo(2388)] = { --> 贪食的克里克西斯

		},
		[EJ_GetEncounterInfo(2415)] = { --> 执行者塔沃德
			[GetSpellInfo(322554)] = {id = 322554, level = 8,}, -- 严惩
			[GetSpellInfo(323573)] = {id = 323573, level = 8,}, -- 残渣1
			[GetSpellInfo(323551)] = {id = 323551, level = 8,}, -- 残渣2
			[GetSpellInfo(328494)] = {id = 328494, level = 8,}, -- 罪触心能
		},
		[EJ_GetEncounterInfo(2421)] = { --> 大学监贝律莉娅
			[GetSpellInfo(325254)] = {id = 325254, level = 8,}, -- 钢铁尖刺
			[GetSpellInfo(328593)] = {id = 328593, level = 8,}, -- 苦痛刑罚
			[GetSpellInfo(325885)] = {id = 325885, level = 8,}, -- 苦恨痛哭
			[GetSpellInfo(328737)] = {id = 328737, level = 8,}, -- 光环碎片
		},
		[EJ_GetEncounterInfo(2407)] = { --> 卡尔将军
			[GetSpellInfo(327814)] = {id = 327814, level = 8,}, -- 邪恶创口1
			[GetSpellInfo(331415)] = {id = 331415, level = 8,}, -- 邪恶创口2
			[GetSpellInfo(326790)] = {id = 326790, level = 8,}, -- 辉光充能
			[GetSpellInfo(323845)] = {id = 323845, level = 8,}, -- 邪恶冲刺
			[GetSpellInfo(324092)] = {id = 324092, level = 8,}, -- 闪耀光辉
		},
		["Trash"] = {
			[GetSpellInfo(326827)] = {id = 326827, level = 8,}, -- 恐惧之缚
			[GetSpellInfo(326836)] = {id = 326836, level = 8,}, -- 镇压诅咒
			[GetSpellInfo(321038)] = {id = 321038, level = 8,}, -- 灵魂损毁
			[GetSpellInfo(335306)] = {id = 335306, level = 8,}, -- 尖刺镣铐
			[GetSpellInfo(336749)] = {id = 336749, level = 8,}, -- 灵魂撕裂
			[GetSpellInfo(336277)] = {id = 336277, level = 8,}, -- 愤怒爆炸
			[GetSpellInfo(334653)] = {id = 334653, level = 8,}, -- 饱餐
			[GetSpellInfo(325119)] = {id = 325119, level = 8,}, -- 英勇烈焰
			[GetSpellInfo(322429)] = {id = 322429, level = 8,}, -- 撕裂切割
			[GetSpellInfo(322212)] = {id = 322212, level = 8,}, -- 滋长猜忌
			[GetSpellInfo(326826)] = {id = 326826, level = 8,}, -- 压制气场
		},
	},
	
	[EJ_GetInstanceInfo(1182)] = { -- 通灵战潮
		[EJ_GetEncounterInfo(2395)] = { --> 凋骨
			[GetSpellInfo(320637)] = {id = 320637, level = 8,}, -- 恶臭气体
			[GetSpellInfo(320596)] = {id = 320596, level = 8,}, -- 深重呕吐
		},
		[EJ_GetEncounterInfo(2391)] = { --> 收割者阿玛厄斯
			[GetSpellInfo(320170)] = {id = 320170, level = 8,}, -- 通灵箭
			[GetSpellInfo(333489)] = {id = 333489, level = 8,}, -- 通灵吐息
			[GetSpellInfo(333492)] = {id = 333492, level = 8,}, -- 通灵粘液
		},
		[EJ_GetEncounterInfo(2392)] = { --> 外科医生缝肉
			[GetSpellInfo(343556)] = {id = 343556, level = 8,}, -- 病态凝视
			[GetSpellInfo(320200)] = {id = 320200, level = 8,}, -- 缝针
			[GetSpellInfo(320366)] = {id = 320366, level = 8,}, -- 防腐剂
		},
		[EJ_GetEncounterInfo(2396)] = { --> 缚霜者纳尔佐
			[GetSpellInfo(323198)] = {id = 323198, level = 8,}, -- 黑暗放逐
			[GetSpellInfo(320788)] = {id = 320788, level = 8,}, -- 冻结之缚
			[GetSpellInfo(321755)] = {id = 321755, level = 8,}, -- 冻缚之盾
			[GetSpellInfo(320784)] = {id = 320784, level = 8,}, -- 彗星风暴
			[GetSpellInfo(328181)] = {id = 328181, level = 8,}, -- 冷冽之寒
			[GetSpellInfo(328212)] = {id = 328212, level = 8,}, -- 冰峰碎片
		},
		["Trash"] = {
			[GetSpellInfo(321821)] = {id = 321821, level = 8,}, -- 作呕喷吐
			[GetSpellInfo(323365)] = {id = 323365, level = 8,}, -- 黑暗纠缠1
			[GetSpellInfo(323347)] = {id = 323347, level = 8,}, -- 黑暗纠缠2
			[GetSpellInfo(338353)] = {id = 338353, level = 8,}, -- 瘀液喷撒
			[GetSpellInfo(333485)] = {id = 333485, level = 8,}, -- 疾病之云
			[GetSpellInfo(338357)] = {id = 338357, level = 8,}, -- 暴锤
			[GetSpellInfo(323464)] = {id = 323464, level = 8,}, -- 黑暗脓液
			[GetSpellInfo(327401)] = {id = 327401, level = 8,}, -- 共受苦难
			[GetSpellInfo(327396)] = {id = 327396, level = 8,}, -- 严酷命运
			[GetSpellInfo(322681)] = {id = 322681, level = 8,}, -- 肉钩
			[GetSpellInfo(345625)] = {id = 345625, level = 8,}, -- 死亡爆发
			[GetSpellInfo(343504)] = {id = 343504, level = 8,}, -- 黑暗之握
			[GetSpellInfo(338606)] = {id = 338606, level = 8,}, -- 病态凝视
			[GetSpellInfo(320462)] = {id = 320462, level = 8,}, -- 通灵箭
			[GetSpellInfo(334748)] = {id = 334748, level = 8,}, -- 排干体液
			[GetSpellInfo(334610)] = {id = 334610, level = 8,}, -- 无脑锁定
			[GetSpellInfo(333477)] = {id = 333477, level = 8,}, -- 内脏切割
			[GetSpellInfo(328664)] = {id = 328664, level = 8,}, -- 冰冻
			[GetSpellInfo(324381)] = {id = 324381, level = 8,}, -- 霜寒之镰
			[GetSpellInfo(324293)] = {id = 324293, level = 8,}, -- 刺耳尖啸
			[GetSpellInfo(323471)] = {id = 323471, level = 8,}, -- 切肉飞刀
			[GetSpellInfo(322274)] = {id = 322274, level = 8,}, -- 衰弱
			[GetSpellInfo(321807)] = {id = 321807, level = 8,}, -- 白骨剥离
			[GetSpellInfo(320717)] = {id = 320717, level = 8,}, -- 鲜血饥渴
			[GetSpellInfo(320631)] = {id = 320631, level = 8,}, -- 腐肉爆发
			[GetSpellInfo(320573)] = {id = 320573, level = 8,}, -- 暗影之井
		},
	},
	
	[EJ_GetInstanceInfo(1192)] = { -- 世界Boss
		[EJ_GetEncounterInfo(2430)] = { --> 瓦里诺
			
		},
		[EJ_GetEncounterInfo(2431)] = { --> 莫塔尼斯

		},
		[EJ_GetEncounterInfo(2432)] = { --> 长青之枝
			
		},
		[EJ_GetEncounterInfo(2433)] = { --> 诺尔伽什
			
		},
	},
	
	[EJ_GetInstanceInfo(1190)] = { -- 纳斯利亚堡
		[EJ_GetEncounterInfo(2393)] = {  --> 啸翼
			[GetSpellInfo(328897)] = {id = 328897, level = 8,}, -- 抽干
			[GetSpellInfo(330713)] = {id = 330713, level = 8,}, -- 裂耳尖啸
			[GetSpellInfo(340324)] = {id = 340324, level = 8,}, -- 鲜血脓液
			[GetSpellInfo(342077)] = {id = 342077, level = 8,}, -- 回声定位
			[GetSpellInfo(345397)] = {id = 345397, level = 8,}, -- 赤红声浪
			[GetSpellInfo(346301)] = {id = 346301, level = 8,}, -- 血光
			[GetSpellInfo(343024)] = {id = 343024, level = 8,}, -- 惊骇
		},
		[EJ_GetEncounterInfo(2429)] = {  --> 猎手阿尔迪莫
			[GetSpellInfo(335304)] = {id = 335304, level = 8,}, -- 寻罪箭
			[GetSpellInfo(334971)] = {id = 334971, level = 8,}, -- 锯齿利爪
			[GetSpellInfo(335111)] = {id = 335111, level = 8,}, -- 猎手印记
			[GetSpellInfo(335112)] = {id = 335112, level = 8,}, -- 猎手印记
			[GetSpellInfo(335113)] = {id = 335113, level = 8,}, -- 猎手印记
			[GetSpellInfo(334945)] = {id = 334945, level = 8,}, -- 凶恶猛扑
			[GetSpellInfo(334852)] = {id = 334852, level = 8,}, -- 石化嚎叫
			[GetSpellInfo(334893)] = {id = 334893, level = 8,}, -- 尖石裂片
			[GetSpellInfo(334708)] = {id = 334708, level = 8,}, -- 致命咆哮
			[GetSpellInfo(334960)] = {id = 334960, level = 8,}, -- 恶毒之伤
		},
		[EJ_GetEncounterInfo(2422)] = {  --> 太阳之王的救赎
			[GetSpellInfo(333002)] = {id = 333002, level = 8,}, -- 劣民印记
			[GetSpellInfo(326078)] = {id = 326078, level = 8,}, -- 灌注者的恩赐
			[GetSpellInfo(325251)] = {id = 325251, level = 8,}, -- 骄傲之罪
			[GetSpellInfo(326430)] = {id = 326430, level = 8,}, -- 残留余烬
			[GetSpellInfo(341473)] = {id = 341473, level = 8,}, -- 猩红乱舞
			[GetSpellInfo(328479)] = {id = 328479, level = 8,}, -- 锁定目标
			[GetSpellInfo(326456)] = {id = 326456, level = 8,}, -- 炽燃残骸
			[GetSpellInfo(325873)] = {id = 325873, level = 8,}, -- 燃烬风暴
			[GetSpellInfo(325442)] = {id = 325442, level = 8,}, -- 征服
		},
		[EJ_GetEncounterInfo(2418)] = {  --> 圣物匠赛·墨克斯
			[GetSpellInfo(327902)] = {id = 327902, level = 8,}, -- 锁定
			[GetSpellInfo(326302)] = {id = 326302, level = 8,}, -- 静滞陷阱
			[GetSpellInfo(325236)] = {id = 325236, level = 8,}, -- 毁灭符文
			[GetSpellInfo(327414)] = {id = 327414, level = 8,}, -- 附身
			[GetSpellInfo(340860)] = {id = 340860, level = 8,}, -- 枯萎之触
			[GetSpellInfo(328468)] = {id = 328468, level = 8,}, -- 空间撕裂
			[GetSpellInfo(340533)] = {id = 340533, level = 8,}, -- 奥术易伤
		},
		[EJ_GetEncounterInfo(2428)] = {  --> 饥饿的毁灭者
			[GetSpellInfo(329298)] = {id = 329298, level = 8,}, -- 暴食瘴气
			[GetSpellInfo(334755)] = {id = 334755, level = 8,}, -- 精华液滴
		},
		[EJ_GetEncounterInfo(2420)] = {  --> 伊涅瓦·暗脉女勋爵
			[GetSpellInfo(325936)] = {id = 325936, level = 8,}, -- 共享认知Tank
			[GetSpellInfo(325908)] = {id = 325908, level = 8,}, -- 共享认知
			[GetSpellInfo(335396)] = {id = 335396, level = 8,}, -- 隐秘欲望
			[GetSpellInfo(324982)] = {id = 324982, level = 8,}, -- 共受苦难
			[GetSpellInfo(324983)] = {id = 324983, level = 8,}, -- 共受苦难
			[GetSpellInfo(332664)] = {id = 332664, level = 8,}, -- 浓缩心能
			[GetSpellInfo(325382)] = {id = 325382, level = 8,}, -- 扭曲欲望
			[GetSpellInfo(331573)] = {id = 331573, level = 8,}, -- 无边悔罪
			[GetSpellInfo(340477)] = {id = 340477, level = 8,}, -- 高度浓缩心能
			[GetSpellInfo(325713)] = {id = 325713, level = 8,}, -- 残留心能
			[GetSpellInfo(325117)] = {id = 325117, level = 8,}, -- 心能释放
			[GetSpellInfo(340452)] = {id = 340452, level = 8,}, -- 变心
			[GetSpellInfo(326538)] = {id = 326538, level = 8,}, -- 心能之网
		},
		[EJ_GetEncounterInfo(2426)] = {  --> 猩红议会
			[GetSpellInfo(327773)] = {id = 327773, level = 8,}, -- 吸取精华
			[GetSpellInfo(327052)] = {id = 327052, level = 8,}, -- 吸取精华
			[GetSpellInfo(346651)] = {id = 346651, level = 8,}, -- 吸取精华
			[GetSpellInfo(328334)] = {id = 328334, level = 8,}, -- 战术冲锋
			[GetSpellInfo(330848)] = {id = 330848, level = 8,}, -- 跳错了
			[GetSpellInfo(331706)] = {id = 331706, level = 8,}, -- 红字
			[GetSpellInfo(331636)] = {id = 331636, level = 8,}, -- 黑暗伴舞
			[GetSpellInfo(331637)] = {id = 331637, level = 8,}, -- 黑暗伴舞
			[GetSpellInfo(346945)] = {id = 346945, level = 8,}, -- 痛苦具象
			[GetSpellInfo(346690)] = {id = 346690, level = 8,}, -- 决斗者的还击
			[GetSpellInfo(346681)] = {id = 346681, level = 8,}, -- 灵魂尖刺
			[GetSpellInfo(337110)] = {id = 337110, level = 8,}, -- 惊骇箭雨
			[GetSpellInfo(327619)] = {id = 327619, level = 8,}, -- 鲜血华尔兹
			[GetSpellInfo(327610)] = {id = 327610, level = 8,}, -- 回闪步
		},
		[EJ_GetEncounterInfo(2394)] = {  --> 泥拳
			[GetSpellInfo(335470)] = {id = 335470, level = 8,}, -- 锁链猛击
			[GetSpellInfo(339181)] = {id = 339181, level = 8,}, -- 锁链猛击，定身
			[GetSpellInfo(331209)] = {id = 331209, level = 8,}, -- 怨恨凝视
			[GetSpellInfo(335293)] = {id = 335293, level = 8,}, -- 锁链联结
			[GetSpellInfo(335295)] = {id = 335295, level = 8,}, -- 粉碎锁链
			[GetSpellInfo(342420)] = {id = 342420, level = 8,}, -- 锁起来
			[GetSpellInfo(339067)] = {id = 339067, level = 8,}, -- 鲁莽冲锋
			[GetSpellInfo(332572)] = {id = 332572, level = 8,}, -- 碎石飞落
		},
		[EJ_GetEncounterInfo(2425)] = {  --> 顽石军团干将
			[GetSpellInfo(334498)] = {id = 334498, level = 8,}, -- 地震岩层
			[GetSpellInfo(337643)] = {id = 337643, level = 8,}, -- 立足不稳
			[GetSpellInfo(334765)] = {id = 334765, level = 8,}, -- 石化碎裂
			[GetSpellInfo(333377)] = {id = 333377, level = 8,}, -- 邪恶印记
			[GetSpellInfo(334616)] = {id = 334616, level = 8,}, -- 石化
			[GetSpellInfo(334541)] = {id = 334541, level = 8,}, -- 石化诅咒
			[GetSpellInfo(339690)] = {id = 339690, level = 8,}, -- 晶化
			[GetSpellInfo(342655)] = {id = 342655, level = 8,}, -- 不稳定的心能灌注
			[GetSpellInfo(342698)] = {id = 342698, level = 8,}, -- 不稳定的心能感染
			[GetSpellInfo(343881)] = {id = 343881, level = 8,}, -- 锯齿撕裂
			[GetSpellInfo(334771)] = {id = 334771, level = 8,}, -- 溢血之心
			[GetSpellInfo(344655)] = {id = 344655, level = 8,}, -- 震荡易伤
			[GetSpellInfo(343895)] = {id = 343895, level = 8,}, -- 魂殇
			[GetSpellInfo(342735)] = {id = 342735, level = 8,}, -- 贪婪盛宴
			[GetSpellInfo(342425)] = {id = 342425, level = 8,}, -- 石拳
			[GetSpellInfo(333913)] = {id = 333913, level = 8,}, -- 邪恶撕裂
		},
		[EJ_GetEncounterInfo(2424)] = {  --> 德纳修斯大帝
			[GetSpellInfo(326851)] = {id = 326851, level = 8,}, -- 血债
			[GetSpellInfo(327992)] = {id = 327992, level = 8,}, -- 荒芜
			[GetSpellInfo(326699)] = {id = 326699, level = 8,}, -- 罪孽烦扰
			[GetSpellInfo(332797)] = {id = 332797, level = 8,}, -- 致命灵巧1
			[GetSpellInfo(332794)] = {id = 332794, level = 8,}, -- 致命灵巧2
			[GetSpellInfo(334016)] = {id = 334016, level = 8,}, -- 落选者
			[GetSpellInfo(327039)] = {id = 327039, level = 8,}, -- 喂食时间
			[GetSpellInfo(329181)] = {id = 329181, level = 8,}, -- 毁灭痛苦
			[GetSpellInfo(329906)] = {id = 329906, level = 8,}, -- 屠戮
			[GetSpellInfo(329951)] = {id = 329951, level = 8,}, -- 穿刺
			[GetSpellInfo(315043)] = {id = 315043, level = 8,}, -- 猎物
			[GetSpellInfo(327796)] = {id = 327796, level = 8,}, -- 午夜猎手
			[GetSpellInfo(327842)] = {id = 327842, level = 8,}, -- 黑夜之触
		},
		["Trash"] = {
			[GetSpellInfo(338687)] = {id = 338687, level = 8,}, -- 暮虚，易伤
			[GetSpellInfo(345811)] = {id = 345811, level = 8,}, -- 偿罪
			[GetSpellInfo(343322)] = {id = 343322, level = 8,}, -- 摩多瓦克的诅咒
			[GetSpellInfo(343320)] = {id = 343320, level = 8,}, -- 卡拉梅恩的诅咒
			[GetSpellInfo(343164)] = {id = 343164, level = 8,}, -- 岩石崩裂
			[GetSpellInfo(343159)] = {id = 343159, level = 8,}, -- 石爪
			[GetSpellInfo(342794)] = {id = 342794, level = 8,}, -- 血之气息
			[GetSpellInfo(342752)] = {id = 342752, level = 8,}, -- 哭泣重担
			[GetSpellInfo(342307)] = {id = 342307, level = 8,}, -- 太阳之王的贪婪
			[GetSpellInfo(342250)] = {id = 342250, level = 8,}, -- 锯齿横扫
			[GetSpellInfo(341900)] = {id = 341900, level = 8,}, -- 黑暗印记
			[GetSpellInfo(341867)] = {id = 341867, level = 8,}, -- 制伏
			[GetSpellInfo(341864)] = {id = 341864, level = 8,}, -- 恐惧利箭
			[GetSpellInfo(341863)] = {id = 341863, level = 8,}, -- 流血
			[GetSpellInfo(341732)] = {id = 341732, level = 8,}, -- 灼热谴罚
			[GetSpellInfo(341730)] = {id = 341730, level = 8,}, -- 纳斯利亚赞歌-罪灼
			[GetSpellInfo(341714)] = {id = 341714, level = 8,}, -- 纳斯利亚赞歌-晦纱
			[GetSpellInfo(341651)] = {id = 341651, level = 8,}, -- 纳斯利亚赞歌-恒影
			[GetSpellInfo(341719)] = {id = 341719, level = 8,}, -- 晦暗纱幕
			[GetSpellInfo(341586)] = {id = 341586, level = 8,}, -- 伏击
			[GetSpellInfo(341435)] = {id = 341435, level = 8,}, -- 突袭
			[GetSpellInfo(341196)] = {id = 341196, level = 8,}, -- 暴露弱点
			[GetSpellInfo(341146)] = {id = 341146, level = 8,}, -- 罪邪箭雨
			[GetSpellInfo(341142)] = {id = 341142, level = 8,}, -- 压倒心能
			[GetSpellInfo(341133)] = {id = 341133, level = 8,}, -- 罪孽箭矢
			[GetSpellInfo(339975)] = {id = 339975, level = 8,}, -- 痛苦重击
			[GetSpellInfo(339553)] = {id = 339553, level = 8,}, -- 残留心能
			[GetSpellInfo(339525)] = {id = 339525, level = 8,}, -- 浓缩心能
			[GetSpellInfo(339447)] = {id = 339447, level = 8,}, -- 惩罚
			[GetSpellInfo(333612)] = {id = 333612, level = 8,}, -- 吞噬精华
			[GetSpellInfo(316859)] = {id = 316859, level = 8,}, -- 破甲一击
			[GetSpellInfo(341393)] = {id = 341393, level = 8,}, -- 天球引导
			[GetSpellInfo(341349)] = {id = 341349, level = 8,}, -- 狂野挥舞
			[GetSpellInfo(340630)] = {id = 340630, level = 8,}, -- 腐烂
			[GetSpellInfo(340622)] = {id = 340622, level = 8,}, -- 迎头冲撞
			[GetSpellInfo(332871)] = {id = 332871, level = 8,}, -- 至高惩戒
			[GetSpellInfo(331836)] = {id = 331836, level = 8,}, -- 救赎
		},
	},

}

--[[
			[GetSpellInfo()] = {id = , level = 8,}, -- 
			[GetSpellInfo()] = {id = , level = 8,}, -- 
			[GetSpellInfo()] = {id = , level = 8,}, -- 
			[GetSpellInfo()] = {id = , level = 8,}, -- 
]]

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

local Customitembuttons = {}

for i = 1, 30 do
	Customitembuttons[i] = {
		itemID = "",
		exactItem = false,
		showCount = false,
		All = true,
		OrderHall = false,
		Raid = false,
		Dungeon = false,
		PVP = false,
	}
end

local Customcoloredplates = {}

for i = 1, 50 do
	Customcoloredplates[i] = {
		name = L["空"],
		color = {r = 1, g = 1, b = 1},
	}
end

local Custompowerplates = {}

for i = 1, 50 do
	Custompowerplates[i] = {
		name = L["空"],
	}
end

local default_HealerIndicatorAuraList = {
	PRIEST = { 
        [17] = true,		-- 真言术盾
        [139] = true,		-- 恢复
        [41635] = true,		-- 愈合祷言
        [194384] = true,	-- 救赎
        [152118] = true,	-- 意志洞悉
	    [208065] = true,	-- 图雷之光	
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
}

local HealerIndicatorAuraList = default_HealerIndicatorAuraList[G.myClass]

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
		portraitalpha = 0.8,
		
		-- size
		height	= 18,
		width = 230,
		widthpet = 70,
		widthboss = 170,
		widthparty = 200,
		scale = 1.0, -- slider
		hpheight = 0.75, -- slider

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
		swoffhand = false,
		swtimer = true,
		swtimersize = 12,
		
		-- auras
		auras = true,
		auraborders = true,
		auraperrow = 8, -- slider
		playerdebuffenable = true,
		playerdebuffnum = 8, -- slider
		AuraFilterignoreBuff = false,
		AuraFilterignoreDebuff = false,
		AuraFilterwhitelist = {},
		usehotfilter = true,
		
		showthreatbar = true,

		-- show/hide boss
		bossframes = true,
		
		-- show/hide arena
		arenaframes = true,

		-- show player in party
		showplayerinparty = true,
		showpartypets = false,

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
		toggleForVehicle = true,
		autoswitch = false,
		raidonly = "healer",

		--[[ healer mode ]]--
		healerraidheight = 45,
		healerraidwidth = 120,
		raidmanabars = true,
		raidhpheight = 0.9, -- slider
		ind_party = true,
		hor_party = false,
		showgcd = true,
		showmisshp = true,
		healprediction = true,
		healtank_assisticon = false,
		hotind_style = "icon_ind",-- "icon_ind", "number_ind"
		hotind_size = 15,
		hotind_filtertype = "whitelist", -- "blacklist", "whitelist"
		hotind_auralist = HealerIndicatorAuraList,
		healerraidgroupby = "GROUP", -- "CLASS", "ROLE"
		healerraid_debuff_num = 2,
		healerraid_debuff_anchor_x = -50,
		healerraid_debuff_anchor_y = -5,
		healerraid_debuff_icon_size = 22,
		healerraid_debuff_icon_fontsize = 8,
		healerraid_buff_num = 1,
		healerraid_buff_anchor_x = 5,
		healerraid_buff_anchor_y = -5,
		healerraid_buff_icon_size = 22,
		healerraid_buff_icon_fontsize = 8,
		
		--[[ dps/tank mode ]]--
		dpsraidheight = 15,
		dpsraidwidth = 100,
		unitnumperline = 25,
		dpsraidgroupby = "GROUP", -- "CLASS", "ROLE"
		dpstank_assisticon = true,
		
		--[[ click cast ]]--
		enableClickCast = false,
		ClickCast = ClickCastDB,
		
		--[[ raid debuff ]]--
		debuff_auto_add = true,
		debuff_auto_add_level = 6,
	},
	ChatOptions = {
		chatbuttons_fade = true,
		chatbuttons_fade_alpha = .3,
		chattab_fade_minalpha = .3,
		chattab_fade_maxalpha = 1,
		channelreplacement = true,
		autoscroll = true,
		nogoldseller = true,
		goldkeywordnum = 2,
		showbg = false,
	},
	ItemOptions = {
		enablebag = true,
		bagiconsize = 30,
		bagiconperrow = 14,
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
		itembuttons_table = Customitembuttons,
	},
	ActionbarOptions = {
		growup = true,
		cooldown = true,
		cooldown_wa = true,
		cooldownsize = 20,
		rangecolor = true,
		keybindsize = 12,
		macronamesize = 8,
		countsize = 12,
		bar12size = 25,
		bar12space = 4,
		bar12mfade = true,
		bar12efade = true,
		bar12fademinaplha = 0.2,
		bar3layout = "layout322",
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
		Horizontalbar45 = true,
		bar45uselayout64 = true,
		petbaruselayout5x2 = false,
		petbarscale = .7,
		petbuttonspace = 4,
		petbarmfade = true,
		petbarefade = false,
		petbarfademinaplha = 0.2,
		stancebarinneranchor = "RIGHT",
		stancebarbuttonszie = 22,
		stancebarbuttonspace = 4,
		stancebarmfade = false,
		stancebarfademinaplha = 0.2,
		micromenuscale = 1,
		micromenufade = true,
		micromenuminalpha = 0,
		leave_vehiclebuttonsize = 30,
		extrabarbuttonsize = 30,
		cdflash_enable = true,
		cdflash_alpha = 100,
		cdflash_size = 60,
		caflash_bl = {
			item = {
				[6948] = true,
			},
			spell = {
			
			},
		},
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
		hideRealm = false,
		hideTitles = true,
		showspellID = true,
		showitemID = true,
		showtalent = true,
		combathide = true,	
		backdropOpacity = 0.8,
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
		acceptfriendlyinvites = false,
		autoinvite = false,
        autoinvitekeywords = "111 123",		
		autoquests = false,
		saysapped = true,
		showAFKtips = true,
		vignettealert = true,
		vignettealerthide = true,
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
		
		guiscale = .8,
		micromenuscale = 1,		
		infobar = true,
		infobarscale = 1,
		minimapheight = 175,
		collectminimapbuttons = true,
		MBCFpos = "BOTTOM",
		hidemap = false,
		hidechat = false,
		collapseWF = true,
		customobjectivetracker = false,
		afklogin = false,
		afkscreen = true,
	},
	RaidDebuff = G.DebuffList,
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
			if a == "RaidDebuff" then
				for k, v in pairs(b) do -- k 副本
					if aCoreCDB[a][k] == nil then -- 需要添加新副本
						aCoreCDB[a][k] = v
					else -- 需要添加新boss
						for k1, v1 in pairs(v) do
							if aCoreCDB[a][k][k1] == nil then
								aCoreCDB[a][k][k1] = v1
							end
						end
					end
				end
			else
				for k, v in pairs(b) do
					if aCoreCDB[a][k] == nil then
						aCoreCDB[a][k] = v
					end
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
					if OptionCategroy == "RaidDebuff" then -- 完全复制 6
						for boss, auratable in pairs(value) do
							for auraname, aurainfo in pairs (aCoreCDB["RaidDebuff"][setting][boss]) do
								str = str.."^"..OptionCategroy.."~"..setting.."~"..boss.."~"..auraname.."~"..aurainfo.id.."~"..aurainfo.level
							end
						end
					elseif OptionCategroy == "CooldownAura" then -- 完全复制 5
						for auraname, aurainfo in pairs (aCoreCDB["CooldownAura"][setting]) do
							str = str.."^"..OptionCategroy.."~"..setting.."~"..auraname.."~"..aurainfo.id.."~"..aurainfo.level
						end
					elseif OptionCategroy == "ItemOptions" then
						if setting == "autobuylist" then -- 完全复制 4
							for id, count in pairs(aCoreCDB["ItemOptions"]["autobuylist"]) do -- 默认是空的
								str = str.."^"..OptionCategroy.."~"..setting.."~"..id.."~"..count
							end
						elseif setting == "itembuttons_table" then -- 非空则复制 11
							for index, t in pairs(aCoreCDB["ItemOptions"]["itembuttons_table"]) do
								if t.itemID ~= "" then
									str = str.."^"..OptionCategroy.."~"..setting.."~"..index.."~"..t.itemID.."~"..(t.exactItem and "true" or "false").."~"..(t.showCount and "true" or "false").."~"..(t.All and "true" or "false").."~"..(t.OrderHall and "true" or "false").."~"..(t.Raid and "true" or "false").."~"..(t.Dungeon and "true" or "false").."~"..(t.PVP and "true" or "false")
								end
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
						for id, spellname in pairs(aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"]) do -- 默认是空的
							str = str.."^"..OptionCategroy.."~"..setting.."~"..id.."~"..spellname
						end
					elseif setting == "caflash_bl" then -- 完全复制 5
						for cdtpye, cdtable in pairs(aCoreCDB["ActionbarOptions"]["caflash_bl"]) do
							for id, _ in pairs(cdtable) do
								str = str.."^"..OptionCategroy.."~"..setting.."~"..cdtpye.."~"..id.."~true"
							end
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
				for instance, bosstable in pairs(G.Raids) do
					if aCoreCDB.RaidDebuff[instance] == nil then
						aCoreCDB.RaidDebuff[instance] = {}
					end
					for _, bossname in pairs(bosstable) do
						aCoreCDB.RaidDebuff[instance][bossname] = {}
					end
				end	
				
				aCoreCDB.CooldownAura = {}
				aCoreCDB.CooldownAura.Buffs = {}
				aCoreCDB.CooldownAura.Debuffs = {}
			end
			
			if sameclass then
				aCoreCDB.PlateOptions.myplateauralist = {}
				aCoreCDB.ActionbarOptions.caflash_bl.spell = {}
			end
			
			aCoreCDB.ActionbarOptions.caflash_bl.item = {}
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
						if OptionCategroy == "RaidDebuff" then -- 完全复制 6 OptionCategroy.."~"..setting.."~"..boss.."~"..auraname.."~"..aurainfo.id.."~"..aurainfo.level
							if sameclient then
								if aCoreCDB[OptionCategroy][setting][arg1][arg2] == nil then
									aCoreCDB[OptionCategroy][setting][arg1][arg2] = {}
									aCoreCDB[OptionCategroy][setting][arg1][arg2]["id"] = tonumber(arg3)
									aCoreCDB[OptionCategroy][setting][arg1][arg2]["level"] = tonumber(arg4)
								end
							end
						elseif OptionCategroy == "CooldownAura" then -- 完全复制 5 OptionCategroy.."~"..setting.."~"..auraname.."~"..aurainfo.id.."~"..aurainfo.level
							if sameclient then
								if aCoreCDB[OptionCategroy][setting][arg1] == nil then
									aCoreCDB[OptionCategroy][setting][arg1] = {}
									aCoreCDB[OptionCategroy][setting][arg1]["id"] = tonumber(arg2)
									aCoreCDB[OptionCategroy][setting][arg1]["level"] = tonumber(arg3)
								end
							end
						elseif OptionCategroy == "ItemOptions" then
							if setting == "autobuylist" then -- 完全复制 4 OptionCategroy.."~"..setting.."~"..id.."~"..count
								aCoreCDB[OptionCategroy][setting][arg1] = arg2
							elseif setting == "itembuttons_table" then -- 非空则复制 11 OptionCategroy.."~"..setting.."~"..index.."~"..t.itemID.."~"..t.exactItem.."~"..t.showCount.."~"..t.All.."~"..t.OrderHall.."~"..t.Raid.."~"..t.Dungeon.."~"..t.PVP
								local ID = tonumber(arg2)
								aCoreCDB[OptionCategroy][setting][tonumber(arg1)] = {
									itemID = ID,
									exactItem = ((arg3 == "true") and true or false),
									showCount = ((arg4 == "true") and true or false),
									All = ((arg5 == "true") and true or false),
									OrderHall = ((arg6 == "true") and true or false),
									Raid = ((arg7 == "true") and true or false),
									Dungeon = ((arg8 == "true") and true or false),
									PVP = ((arg9 == "true") and true or false),
								}
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
						elseif setting == "AuraFilterwhitelist" then -- 完全复制 4 OptionCategroy.."~"..setting.."~"..id.."~"..spellname
							if sameclient then
								aCoreCDB[OptionCategroy][setting][arg1] = arg2
							end
						elseif setting == "caflash_bl" then -- 完全复制 5 OptionCategroy.."~"..setting.."~"..cdtpye.."~"..id.."~true"
							if arg1 == "item" then
								aCoreCDB[OptionCategroy][setting][arg1][tonumber(arg2)] = true
							elseif sameclass then
								aCoreCDB[OptionCategroy][setting][arg1][tonumber(arg2)] = true
							end
						end
					end

				end
			end
		ReloadUI()
		end
		StaticPopup_Show(G.uiname.."Import Confirm")
	end
end