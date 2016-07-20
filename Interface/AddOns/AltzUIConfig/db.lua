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

local EJ_GetEncounterInfo = function(value)
	local a = EJ_GetEncounterInfo(value)
	return a
end

local AuraList = {
	["Buffs"] = {
	--牧师
		[GetSpellInfo(33206)]  = { id = 33206,  level = 15,}, -- 痛苦压制
        [GetSpellInfo(47788)]  = { id = 47788,  level = 15,}, -- 守护之魂
	--小德
        [GetSpellInfo(102342)] = { id = 102342, level = 15,}, -- 铁木树皮
		[GetSpellInfo(22812)]  = { id = 22812,  level = 15,}, -- 树皮术
		[GetSpellInfo(61336)]  = { id = 61336,  level = 15,}, -- 生存本能
		[GetSpellInfo(105737)] = { id = 105737, level = 15,}, -- 乌索克之力
		[GetSpellInfo(22842)]  = { id = 22842,  level = 15,}, -- 狂暴回复
	--骑士
		[GetSpellInfo(1022)]   = { id = 1022,   level = 15,}, -- 保护之手
		[GetSpellInfo(31850)]  = { id = 31850,  level = 15,}, -- 炽热防御者
        [GetSpellInfo(498)]    = { id = 498,    level = 15,}, -- 圣佑术
		[GetSpellInfo(642)]    = { id = 642,    level = 15,}, -- 圣盾术
		[GetSpellInfo(86659)]  = { id = 86659,  level = 15,}, -- 远古列王守卫
	--武僧
		[GetSpellInfo(116849)] = { id = 116849, level = 15,}, -- 作茧缚命
		[GetSpellInfo(115203)] = { id = 115203, level = 15,}, -- 壮胆酒	
	--DK
        [GetSpellInfo(50397)]  = { id = 50397,  level = 15,}, -- 巫妖之躯
		[GetSpellInfo(48707)]  = { id = 48707,  level = 15,}, -- 反魔法护罩
		[GetSpellInfo(48792)]  = { id = 48792,  level = 15,}, -- 冰封之韧
		[GetSpellInfo(49028)]  = { id = 49028,  level = 15,}, -- 吸血鬼之血
		[GetSpellInfo(55233)]  = { id = 55233,  level = 15,}, -- 符文刃舞
	--战士
		[GetSpellInfo(12975)]  = { id = 12975,  level = 15,}, -- 破釜沉舟
		[GetSpellInfo(871)]    = { id = 871,    level = 15,}, -- 盾墙
	},
	["Debuffs"] = {
	},
}

--instanceID, name, description, bgImage, buttonImage, loreImage, dungeonAreaMapID, link = EJ_GetInstanceByIndex(index, isRaid)
--name, description, encounterID, rootSectionID, link = EJ_GetEncounterInfoByIndex(index[, instanceID])

G.Raids = {
	[EJ_GetInstanceInfo(727)] = { -- 噬魂之喉
		EJ_GetEncounterInfo(1502),
		EJ_GetEncounterInfo(1512),
		EJ_GetEncounterInfo(1663),
	},
	
	[EJ_GetInstanceInfo(767)] = { -- 耐萨里奥的巢穴
		EJ_GetEncounterInfo(1662),
		EJ_GetEncounterInfo(1665),
		EJ_GetEncounterInfo(1673),
		EJ_GetEncounterInfo(1687),
	},
	
	[EJ_GetInstanceInfo(707)] = { -- 守望者地窟
		EJ_GetEncounterInfo(1467),
		EJ_GetEncounterInfo(1695),
		EJ_GetEncounterInfo(1468),
		EJ_GetEncounterInfo(1469),
		EJ_GetEncounterInfo(1470),
	},
	
	[EJ_GetInstanceInfo(777)] = { -- 突袭紫罗兰监狱
		EJ_GetEncounterInfo(1693),
		EJ_GetEncounterInfo(1694),
		EJ_GetEncounterInfo(1702),
		EJ_GetEncounterInfo(1686),
		EJ_GetEncounterInfo(1688),
		EJ_GetEncounterInfo(1696),
		EJ_GetEncounterInfo(1697),
		EJ_GetEncounterInfo(1711),
	},
	
	[EJ_GetInstanceInfo(800)] = { -- 群星庭院
		EJ_GetEncounterInfo(1718),
		EJ_GetEncounterInfo(1719),
		EJ_GetEncounterInfo(1720),
	},
	
	[EJ_GetInstanceInfo(716)] = { -- 艾萨拉之眼
		EJ_GetEncounterInfo(1480),
		EJ_GetEncounterInfo(1490),
		EJ_GetEncounterInfo(1491),
		EJ_GetEncounterInfo(1479),
		EJ_GetEncounterInfo(1492),
	},
	
	[EJ_GetInstanceInfo(721)] = { -- 英灵殿
		EJ_GetEncounterInfo(1485),
		EJ_GetEncounterInfo(1486),
		EJ_GetEncounterInfo(1487),
		EJ_GetEncounterInfo(1488),
		EJ_GetEncounterInfo(1489),
	},
	
	[EJ_GetInstanceInfo(726)] = { -- 魔法回廊
		EJ_GetEncounterInfo(1497),
		EJ_GetEncounterInfo(1498),
		EJ_GetEncounterInfo(1499),
		EJ_GetEncounterInfo(1500),
		EJ_GetEncounterInfo(1501),
	},
	
	[EJ_GetInstanceInfo(762)] = { -- 黑心林地
		EJ_GetEncounterInfo(1654),
		EJ_GetEncounterInfo(1655),
		EJ_GetEncounterInfo(1656),
		EJ_GetEncounterInfo(1657),
	},
	
	[EJ_GetInstanceInfo(740)] = { -- 黑鸦堡垒
		EJ_GetEncounterInfo(1518),
		EJ_GetEncounterInfo(1653),
		EJ_GetEncounterInfo(1664),
		EJ_GetEncounterInfo(1672),
	},
	
	[EJ_GetInstanceInfo(822)] = { -- 破碎群岛
		EJ_GetEncounterInfo(1790),
		EJ_GetEncounterInfo(1774),
		EJ_GetEncounterInfo(1789),
		EJ_GetEncounterInfo(1795),
		EJ_GetEncounterInfo(1770),
		EJ_GetEncounterInfo(1769),
		EJ_GetEncounterInfo(1774),
		EJ_GetEncounterInfo(1783),
		EJ_GetEncounterInfo(1749),
		EJ_GetEncounterInfo(1763),
		EJ_GetEncounterInfo(1756),
		EJ_GetEncounterInfo(1796),
	},
	
	[EJ_GetInstanceInfo(768)] = { -- 翡翠梦魇
		EJ_GetEncounterInfo(1703),
		EJ_GetEncounterInfo(1738),
		EJ_GetEncounterInfo(1744),
		EJ_GetEncounterInfo(1667),
		EJ_GetEncounterInfo(1704),
		EJ_GetEncounterInfo(1750),
		EJ_GetEncounterInfo(1726),
	},

	[EJ_GetInstanceInfo(786)] = { -- 暗夜要塞
		EJ_GetEncounterInfo(1706),
		EJ_GetEncounterInfo(1725),
		EJ_GetEncounterInfo(1731),
		EJ_GetEncounterInfo(1751),
		EJ_GetEncounterInfo(1762),
		EJ_GetEncounterInfo(1713),
		EJ_GetEncounterInfo(1761),
		EJ_GetEncounterInfo(1732),
		EJ_GetEncounterInfo(1743),
		EJ_GetEncounterInfo(1737),
	},
	
}

G.DebuffList = {
	[EJ_GetInstanceInfo(727)] = { -- 噬魂之喉
		[EJ_GetEncounterInfo(1502)] = {
			--[GetSpellInfo(185090)] = {id = 185090, level = 8,}, -- 英姿勃发
		},
		[EJ_GetEncounterInfo(1512)] = {
		
		},
		[EJ_GetEncounterInfo(1663)] = {
		
		},
	},
	
	[EJ_GetInstanceInfo(767)] = { -- 耐萨里奥的巢穴
		[EJ_GetEncounterInfo(1662)] = {
		
		},
		[EJ_GetEncounterInfo(1665)] = {
		
		},
		[EJ_GetEncounterInfo(1673)] = {
		
		},
		[EJ_GetEncounterInfo(1687)] = {
		
		},
	},
	
	[EJ_GetInstanceInfo(707)] = { -- 守望者地窟
		[EJ_GetEncounterInfo(1467)] = {
		
		},
		[EJ_GetEncounterInfo(1695)] = {
		
		},
		[EJ_GetEncounterInfo(1468)] = {
		
		},
		[EJ_GetEncounterInfo(1469)] = {
		
		},
		[EJ_GetEncounterInfo(1470)] = {
		
		},
	},
	
	[EJ_GetInstanceInfo(777)] = { -- 突袭紫罗兰监狱
		[EJ_GetEncounterInfo(1693)] = {
		
		},
		[EJ_GetEncounterInfo(1694)] = {
		
		},
		[EJ_GetEncounterInfo(1702)] = {
		
		},
		[EJ_GetEncounterInfo(1686)] = {
		
		},
		[EJ_GetEncounterInfo(1688)] = {
		
		},
		[EJ_GetEncounterInfo(1696)] = {
		
		},
		[EJ_GetEncounterInfo(1697)] = {
		
		},
		[EJ_GetEncounterInfo(1711)] = {
		
		},
	},
	
	[EJ_GetInstanceInfo(800)] = { -- 群星庭院
		[EJ_GetEncounterInfo(1718)] = {
		
		},
		[EJ_GetEncounterInfo(1719)] = {
		
		},
		[EJ_GetEncounterInfo(1720)] = {
		
		},
	},
	
	[EJ_GetInstanceInfo(716)] = { -- 艾萨拉之眼
		[EJ_GetEncounterInfo(1480)] = {
		
		},
		[EJ_GetEncounterInfo(1490)] = {
		
		},
		[EJ_GetEncounterInfo(1491)] = {
		
		},
		[EJ_GetEncounterInfo(1479)] = {
		
		},
		[EJ_GetEncounterInfo(1492)] = {
		
		},
	},
	
	[EJ_GetInstanceInfo(721)] = { -- 英灵殿
		[EJ_GetEncounterInfo(1485)] = {
		
		},
		[EJ_GetEncounterInfo(1486)] = {
		
		},
		[EJ_GetEncounterInfo(1487)] = {
		
		},
		[EJ_GetEncounterInfo(1488)] = {
		
		},
		[EJ_GetEncounterInfo(1489)] = {
		
		},
	},
	
	[EJ_GetInstanceInfo(726)] = { -- 魔法回廊
		[EJ_GetEncounterInfo(1497)] = {
		
		},
		[EJ_GetEncounterInfo(1498)] = {
		
		},
		[EJ_GetEncounterInfo(1499)] = {
		
		},
		[EJ_GetEncounterInfo(1500)] = {
		
		},
		[EJ_GetEncounterInfo(1501)] = {
		
		},
	},
	
	[EJ_GetInstanceInfo(762)] = { -- 黑心林地
		[EJ_GetEncounterInfo(1654)] = {
		
		},
		[EJ_GetEncounterInfo(1655)] = {
		
		},
		[EJ_GetEncounterInfo(1656)] = {
		
		},
		[EJ_GetEncounterInfo(1657)] = {
		
		},
	},
	
	[EJ_GetInstanceInfo(740)] = { -- 黑鸦堡垒
		[EJ_GetEncounterInfo(1518)] = {
		
		},
		[EJ_GetEncounterInfo(1653)] = {
		
		},
		[EJ_GetEncounterInfo(1664)] = {
		
		},
		[EJ_GetEncounterInfo(1672)] = {
		
		},
	},
	
	[EJ_GetInstanceInfo(822)] = { -- 破碎群岛
		[EJ_GetEncounterInfo(1790)] = {
			
		},
		[EJ_GetEncounterInfo(1774)] = {

		},
		[EJ_GetEncounterInfo(1789)] = {

		},
		[EJ_GetEncounterInfo(1795)] = {

		},
		[EJ_GetEncounterInfo(1770)] = {

		},
		[EJ_GetEncounterInfo(1769)] = {

		},
		[EJ_GetEncounterInfo(1774)] = {

		},
		[EJ_GetEncounterInfo(1783)] = {

		},
		[EJ_GetEncounterInfo(1749)] = {

		},
		[EJ_GetEncounterInfo(1763)] = {

		},
		[EJ_GetEncounterInfo(1756)] = {

		},
		[EJ_GetEncounterInfo(1796)] = {

		},
	},
	
	[EJ_GetInstanceInfo(768)] = { -- 翡翠梦魇
		[EJ_GetEncounterInfo(1703)] = {

		},
		[EJ_GetEncounterInfo(1738)] = {

		},
		[EJ_GetEncounterInfo(1744)] = {

		},
		[EJ_GetEncounterInfo(1667)] = {

		},
		[EJ_GetEncounterInfo(1704)] = {

		},
		[EJ_GetEncounterInfo(1750)] = {

		},
		[EJ_GetEncounterInfo(1726)] = {

		},
	},

	[EJ_GetInstanceInfo(786)] = { -- 暗夜要塞
		[EJ_GetEncounterInfo(1706)] = {

		},
		[EJ_GetEncounterInfo(1725)] = {

		},
		[EJ_GetEncounterInfo(1731)] = {

		},
		[EJ_GetEncounterInfo(1751)] = {

		},
		[EJ_GetEncounterInfo(1762)] = {

		},
		[EJ_GetEncounterInfo(1713)] = {

		},
		[EJ_GetEncounterInfo(1761)] = {

		},
		[EJ_GetEncounterInfo(1732)] = {

		},
		[EJ_GetEncounterInfo(1743)] = {

		},
		[EJ_GetEncounterInfo(1737)] = {

		},
	},
}

G.WhiteList = {
	--BUFF
	[61336] = true, -- 求生本能
	[22812] = true, -- 樹皮術
	[22842] = true, -- 狂暴恢復
	[1850] = true, -- 疾奔
	--[50334] = true, -- 狂暴
	[31821] = true, -- 光環精通
	[1022] = true, -- 保護
	[1044] = true, -- 自由
	[642] = true, -- 無敵
	[6940] = true, -- 犧牲祝福
	[31884] = true,--翅膀
	--[114039] = true, --纯净之手
	[105809] = true,--狂热
	--[114917] = true, -- 怜悯治疗
	[85499]= true,--加速
	--[51713] = true, -- 暗影之舞
	[2983] = true, -- 疾跑
	[31224] = true, -- 斗篷
	[13750] = true, -- 衝動
	[5277] = true, -- 閃避
	[74001] = true, -- 戰鬥就緒
	--[55694] = true, -- 狂怒恢復
	[871] = true, --盾墻
	[18499] = true, -- 狂暴之怒
	[23920] = true, -- 盾反
	[1719] = true, -- 魯莽
	[114028] = true, --群体反射
	--[114029] = true, --捍卫
	[114030] = true, --警戒
	[107574] = true,--天神下凡
	[12292] = true, -- old death wish
	[33206] = true, -- 痛苦壓制
	[37274] = true, -- 能量灌注
	--[6346] = true, -- 反恐
	[47585] = true, -- 消散
	--[81700] = true, -- 天使长
	[47788] = true,--翅膀
	[10060] = true,--能量灌注
	--[30823] = true, -- 薩滿之怒
	--[974] = true, -- 大地之盾
	--[16188] = true, -- 自然迅捷
	[79206] = true, --移动施法
	[16166] = true, --元素掌握
	[8178] = true,--根基
	[114050] = true,
	[114051] = true,
	[114052] = true,
	[45438] = true, -- 寒冰屏障
	[12042] = true, -- 奥强
	[12472] = true, --冰脈
	--[12043] = true,--气定
	[108839] = true,
	[110909] = true,--时间操控
	[49039] = true, -- 巫妖之軀
	[48792] = true, -- 冰固
	[55233] = true, -- 血族之裔
	[51271] = true, --冰霜之
	[48707] = true,
	[115989] = true,
	[19263] = true, -- 威懾
	[3045] = true,
	[54216] = true,--主人召唤
	[108416] = true,
	[108503] = true,
	--[113858] = true,
	--[113861] = true,
	--[113860] = true,
	[104773] = true,
	[122278] = true,
	[122783] = true,
	[120954] = true,
	[115176] = true,
	[116849] = true,
	[108359] = true,
	-- DEBUFF
	[78675] = true, -- 太陽光束
	[108194] = true,-- 窒息
	[47481] =true, -- 啃（食尸鬼）
	[91797] =true, -- 怪物重击（超级食尸鬼）
	[47476] =true, -- 绞杀
	[5211] =true, -- 强力重击
	[33786] =true, -- 旋风
	[81261] =true, -- 太阳光束
	[19386] =true, -- 翼龙钉刺
	[5116] =true, -- 震荡射击
	--[61394] =true, -- 冰冻陷阱雕文
	--[44572] =true, -- 深度冻结
	[31661] =true, -- 龙之吐息
	[118] =true, -- 变形
	[82691] =true, -- 霜之环
	[105421] =true, -- 盲目之光
	--[105593] =true, -- 正义之拳
	[853] =true, -- 制裁之锤
	[20066] =true, -- 忏悔
	[605] =true, -- 主宰心灵
	[64044] =true, -- 心理恐怖片
	[8122] =true, -- 心灵尖啸
	[9484] =true, -- 束缚亡灵
	[87204] =true, -- 罪与罚
	[15487] =true, -- 沉默
	[2094] =true, -- 盲
	[76577] =true, --烟雾弹
	[6770] =true, -- SAP
	[1330] =true, -- 绞喉 - 沉默
	[118905] =true, -- 静电
	[5782] =true, -- 恐惧
	[5484] =true, -- 恐惧嚎叫
	[6358] =true, -- 诱惑（魅魔）
	[30283] =true, -- 暗影之怒
	[31117] =true, -- 痛苦无常
	[5246] =true, -- 破胆怒吼
	[46968] =true, --冲击波
	--[18498] =true, -- 沉默 - GAG订单
	[20549] =true, -- 战争践踏
	[25046] =true, -- 奥术洪流
}

G.BlackList = {
	[15407] = true, -- 精神鞭笞
}

local Customcoloredplates = {}

for i = 1, 50 do
	Customcoloredplates[i] = {
		name = L["空"],
		color = {r = 1, g = 1, b = 1},
	}
end

local Account_default_Settings = {
	meet = false,
	gold = {},
	goldkeywordlist = "",
}

local Character_default_Settings = {
	FramePoints = {},
	UnitframeOptions = {
		style = 1, -- 1: tansparent , 2:dark bg reverse, 3:dark bg normal -- 加入
		enablefade = true,
		fadingalpha = 0.2,
		valuefontsize = 16,
		
		-- health/power
		tenthousand = false,
		alwayshp = false,
		alwayspp = false,
		classcolormode = false,
		nameclasscolormode = true,
		
		-- portrait
		portrait = false,
		portraitalpha = 0.6,
		
		-- size
		height	= 18,
		width = 230,
		widthpet = 70,
		widthboss = 170,
		scale = 1.0, -- slider
		hpheight = 0.75, -- slider

		-- castbar
		castbars = true,
		cbIconsize = 32,
		independentcb = false,
		namepos = "LEFT",
		timepos = "RIGHT",
		cbheight = 8,
		cbwidth = 230,
		channelticks = false,
		
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
		
		-- show value
		runecooldown = true,
		shamanmana = true,
		valuefs = 12,
		
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
		healergroupfilter = '1,2,3,4,5,6',
		healerraidheight = 45,
		healerraidwidth = 70,
		raidmanabars = true,
		raidhpheight = 0.85, -- slider
		anchor = "TOP", -- dropdown
		partyanchor = "LEFT", -- dropdown
		showgcd = true,
		showmisshp = true,
		healprediction = true,
		healtank_assisticon = false,
		
		--[[ dps/tank mode ]]--
		dpsgroupfilter = '1,2,3,4,5,6',
		dpsraidheight = 15,
		dpsraidwidth = 100,
		unitnumperline = 25,
		dpsraidgroupbyclass = true,
		dpstank_assisticon = true,
		
		--[[ click cast ]]--
		enableClickCast = false,
		ClickCast = ClickCastDB,
	},
	ChatOptions = {
		channelreplacement = true,
		autoscroll = true,
		nogoldseller = true,
		goldkeywordnum = 2,
	},
	ItemOptions = {
		enablebag = true,
		bagiconsize = 30,
		bagiconperrow = 14,
		autorepair = true,
		autorepair_guild = true,
		autosell = true,
		alreadyknown = true,
		showitemlevel = true,
		autobuy = false,
		autobuylist = {
		["79249"] = 20, -- 清心书卷
		},
		itemlevels = {},
	},
	ActionbarOptions = {
		cooldown = true,
		cooldownsize = 20,
		rangecolor = true,
		keybindsize = 12,
		macronamesize = 8,
		countsize = 12,
		bar1top = true,
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
		enableplate = true,
		autotoggleplates = true,
		plateauranum = 5,
		plateaurasize = 25,
		numberstyle = true,
		threatcolor = true,
		firendlyCR = false,
		enemyCR = true,
		myplateauralist = G.BlackList,		
		otherplateauralist = G.WhiteList,
		myfiltertype = "blacklist", -- "blacklist", "whitelist", "none"
		otherfiltertype = "none", -- "whitelist", "none"
		customcoloredplates = Customcoloredplates,
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
		colorborderClass = false,
		combathide = true,	
	},
	CombattextOptions = {
		combattext = true,
		showreceivedct = true,
		showoutputct = true,
		formattype = "k",
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
		minimapheight = 175,
		micromenuscale = 1,
		infobarscale = 1,
		collectminimapbuttons = true,
		MBCFpos = "BOTTOM",
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
		showAFKtips = true,
		vignettealert = true,
		flashtaskbar = true,
		autopet = true,
		LFGRewards = true,
		autoacceptproposal = true,
		hidemapandchat = false,
	},
	SkinOptions = {
		setClassColor = true,
		setDBM = true,
		setSkada = true,
		setBW = true,
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