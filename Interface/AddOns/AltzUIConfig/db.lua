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
	
	[EJ_GetInstanceInfo(669)] = { -- 地狱火
		EJ_GetEncounterInfo(1426),
		EJ_GetEncounterInfo(1425),
		EJ_GetEncounterInfo(1392),
		EJ_GetEncounterInfo(1432),
		
		EJ_GetEncounterInfo(1396),
		EJ_GetEncounterInfo(1372),
		EJ_GetEncounterInfo(1433),
		EJ_GetEncounterInfo(1427),
		
		EJ_GetEncounterInfo(1391),
		EJ_GetEncounterInfo(1447),
		EJ_GetEncounterInfo(1394),
		EJ_GetEncounterInfo(1395),
		
		EJ_GetEncounterInfo(1438),
		"Trash",	
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
	[EJ_GetInstanceInfo(669)] = { -- 地狱火堡垒
		["Trash"] = {
		},
		
		[EJ_GetEncounterInfo(1426)] = { --奇袭地狱火
			[GetSpellInfo(186016)] = {id = 186016, level = 8,}, -- 邪火弹药 拿彈藥的dot
			[GetSpellInfo(185090)] = {id = 185090, level = 8,}, -- 英姿勃发
			[GetSpellInfo(180319)] = {id = 180319, level = 8,}, -- 振奋狂哮
			[GetSpellInfo(184379)] = {id = 184379, level = 8,}, -- 啸风战斧 boss aoe 點名出人群三角站位
			[GetSpellInfo(184238)] = {id = 184238, level = 8,}, -- 颤抖！ 減速
			[GetSpellInfo(184243)] = {id = 184243, level = 8,}, -- 猛击 易傷
			[GetSpellInfo(181968)] = {id = 181968, level = 8,}, -- 恶魔变形 術士變身
			[GetSpellInfo(185816)] = {id = 185816, level = 8,}, -- 修复 工程師修理坦克，打斷
			[GetSpellInfo(185806)] = {id = 185806, level = 8,}, -- 导电冲击脉冲 擊暈
			[GetSpellInfo(180022)] = {id = 180022, level = 8,}, -- 钻孔 你要被車碾了
			[GetSpellInfo(185157)] = {id = 185157, level = 8,}, -- 灼烧 正面錐形aoe dot
			[GetSpellInfo(187655)] = {id = 187655, level = 8,}, -- 腐化虹吸
		},
		
		[EJ_GetEncounterInfo(1425)] = { --钢铁掠夺者
			[GetSpellInfo(182074)] = {id = 182074, level = 8,}, -- 焚燒/献祭	踩到火
			[GetSpellInfo(182020)] = {id = 182020, level = 8,}, -- 猛擊/重击	aoe
			[GetSpellInfo(182001)] = {id = 182001, level = 8,}, -- 不穩定的球體/不稳定的宝珠	8碼分散
			[GetSpellInfo(182280)] = {id = 182280, level = 8,}, -- 砲擊/炮击	離boss越遠傷害越低，p1只點坦，p2點全部
			[GetSpellInfo(182003)] = {id = 182003, level = 8,}, -- 燃料污漬/燃料尾痕	踩到水減速
			[GetSpellInfo(179897)] = {id = 179897, level = 8,}, -- 閃擊/迅猛突袭	 被夾住啦
			[GetSpellInfo(185242)] = {id = 185242, level = 8,}, 	
			[GetSpellInfo(185978)] = {id = 185978, level = 8,}, -- 火焰彈易傷/易爆火焰炸弹	火焰炸彈爆炸易傷
		},
		
		[EJ_GetEncounterInfo(1392)] = { --考莫克
			[GetSpellInfo(180115)] = {id = 180115, level = 8,}, -- 暗影能量/暗影能量	吃水buff，放一次強化技能消一層
			[GetSpellInfo(180116)] = {id = 180116, level = 8,}, -- 炸裂能量/爆炸能量	吃水buff，放一次強化技能消一層
			[GetSpellInfo(180117)] = {id = 180117, level = 8,}, -- 邪惡能量/邪恶能量	吃水buff，放一次強化技能消一層
			[GetSpellInfo(180244)] = {id = 180244, level = 8,}, -- 猛擊/重击	aoe，4碼分散
			[GetSpellInfo(181345)] = {id = 181345, level = 8,}, -- 邪惡碎擊/攫取之手	被手抓
			[GetSpellInfo(181321)] = {id = 181321, level = 8,}, -- 魔化之觸/邪能之触	擊飛+50%法易傷
			[GetSpellInfo(181306)] = {id = 181306, level = 8,}, -- 炸裂爆發/爆裂冲击	定身，10秒爆炸，40碼aoe
			[GetSpellInfo(187819)] = {id = 187819, level = 8,}, -- 粉碎/邪污碾压	被手抓
			[GetSpellInfo(180270)] = {id = 180270, level = 8,}, -- 暗影團塊/暗影血球	強化紫色暗影波
			[GetSpellInfo(185519)] = {id = 185519, level = 8,}, -- 熾熱團塊/炽热血球	強化黃色暗影波
			[GetSpellInfo(185521)] = {id = 185521, level = 8,}, -- 邪惡團塊/邪污血球	強化綠色暗影波
			[GetSpellInfo(181082)] = {id = 181082, level = 8,}, -- 暗影池/暗影之池	掉進水池(誰沒事去踩這個抓id啊)
			[GetSpellInfo(186559)] = {id = 186559, level = 8,}, -- 熾焰火池/火焰之池	掉進水池
			[GetSpellInfo(186560)] = {id = 186560, level = 8,}, -- 邪惡池塘/邪污之池	掉進水池
			[GetSpellInfo(181208)] = {id = 181208, level = 8,}, -- 暗影殘渣/暗影残渣	接水dot
			[GetSpellInfo(185686)] = {id = 185686, level = 8,}, -- 熾熱殘渣/爆炸残渣	接水dot
			[GetSpellInfo(185687)] = {id = 185687, level = 8,}, -- 腐惡殘渣/邪恶残渣	接水dot
		},
		[EJ_GetEncounterInfo(1432)] = { --高阶地狱	 
			[GetSpellInfo(184449)] = {id = 184449, level = 8,}, -- 死靈法師印記/死灵印记	可驅散，5個分別是紫/紫/紫/黃/紅，傷害由低到高(我也不知道為啥紫燈這麼多個)火议会
			[GetSpellInfo(184450)] = {id = 184450, level = 8,}, -- 
			[GetSpellInfo(184676)] = {id = 184676, level = 8,}, -- 
			[GetSpellInfo(185065)] = {id = 185065, level = 8,}, -- 
			[GetSpellInfo(185066)] = {id = 185066, level = 8,}, -- 
			[GetSpellInfo(184657)] = {id = 184657, level = 8,}, -- 夢魘幻貌/梦魇幻影	暗牧亂舞
			[GetSpellInfo(184673)] = {id = 184673, level = 8,}, -- 	 
			[GetSpellInfo(183701)] = {id = 183701, level = 8,}, --  魔化風暴/邪能風暴	劍聖aoe
			[GetSpellInfo(184359)] = {id = 184359, level = 8,}, --  憤怒/愤怒	血沸增傷，驅散
			[GetSpellInfo(184360)] = {id = 184360, level = 8,}, -- 
			[GetSpellInfo(184358)] = {id = 184358, level = 8,}, --  惡魔之怒/堕落狂怒	血沸點名
			[GetSpellInfo(184365)] = {id = 184365, level = 8,}, --  破壞躍擊/毁灭飞跃	血沸跳躍
			[GetSpellInfo(183885)] = {id = 183885, level = 8,}, --  镜像/镜像	劍聖鏡像
			[GetSpellInfo(184847)] = {id = 184847, level = 8,}, --  強酸創傷/酸性创伤	破甲
			[GetSpellInfo(184652)] = {id = 184652, level = 8,}, --  收割/暗影收割	踩圈
			[GetSpellInfo(184357)] = {id = 184357, level = 8,}, --  腐壞之血/污血	降低血量上限
			[GetSpellInfo(184355)] = {id = 184355, level = 8,}, --  血液沸騰/血液沸腾	血沸對最遠的5人上流血dot
		},
		[EJ_GetEncounterInfo(1396)] = { --基尔罗格·死眼
			[GetSpellInfo(180389)] = {id = 180389, level = 8,}, --  
			[GetSpellInfo(188929)] = {id = 188929, level = 8,}, --  追心飛刀/剖心飞刀	點名飛刀/流血DOT
			[GetSpellInfo(184396)] = {id = 184396, level = 8,}, --  
			[GetSpellInfo(182159)] = {id = 182159, level = 8,}, --  惡魔腐化/邪能腐蚀	特殊能量，疊滿被心控
			[GetSpellInfo(180313)] = {id = 180313, level = 8,}, --  惡魔附身/恶魔附身	被心控
			[GetSpellInfo(180718)] = {id = 180718, level = 8,}, --  不朽決心/永痕的决心	增傷，可疊20層
			[GetSpellInfo(181488)] = {id = 181488, level = 8,}, --  死亡幻象/死亡幻象	
			[GetSpellInfo(185563)] = {id = 185563, level = 8,}, --  不死救贖/永恒的救赎	一個光圈，站進去清腐化
			[GetSpellInfo(180200)] = {id = 180200, level = 8,}, --  撕碎護甲/碎甲	不該中；身上有主動減傷就不會中(同萊登)
			[GetSpellInfo(180575)] = {id = 180575, level = 8,}, --  魔化烈焰/邪能烈焰	
			[GetSpellInfo(183917)] = {id = 183917, level = 8,}, --  撕裂嚎叫/撕裂嚎叫	施法加速/流血dot
			[GetSpellInfo(186919)] = {id = 186919, level = 8,}, --  
			[GetSpellInfo(188852)] = {id = 188852, level = 8,}, --  濺血/溅血	踩水
			[GetSpellInfo(180224)] = {id = 180224, level = 8,}, --  死亡掙扎/死亡挣扎	aoe
			[GetSpellInfo(184551)] = {id = 184551, level = 8,}, --  死亡之門/死亡之门	aoe增傷
			[GetSpellInfo(180163)] = {id = 180163, level = 8,}, --  猛烈強擊/野蛮打击	大怪連擊，疊腐化
			[GetSpellInfo(184067)] = {id = 184067, level = 8,}, --  魔化之沼/邪能腐液	踩水
		},
		[EJ_GetEncounterInfo(1372)] = { --血魔
			[GetSpellInfo(180093)] = {id = 180093, level = 8,}, --  靈魂箭雨/灵魂箭雨	緩速
			[GetSpellInfo(179864)] = {id = 179864, level = 8,}, --  死亡之影/死亡之影	點名進場
			[GetSpellInfo(179867)] = {id = 179867, level = 8,}, --  血魔的腐化/血魔的腐化	進過場，不能再次進場
			[GetSpellInfo(181295)] = {id = 181295, level = 8,}, --  消化/消化	內場，debuff結束秒殺，剩3秒出場
			[GetSpellInfo(185038)] = {id = 185038, level = 8,}, --  
			[GetSpellInfo(180148)] = {id = 180148, level = 8,}, --  嗜命/生命渴望	傀儡(小怪)盯人，追上10碼爆炸
			[GetSpellInfo(179977)] = {id = 179977, level = 8,}, --  末日之觸/毁灭之触	去角落放圈
			[GetSpellInfo(179995)] = {id = 179995, level = 8,}, --  末日之井/末日井	踩到圈
			[GetSpellInfo(185190)] = {id = 185190, level = 8,}, --  魔化烈焰/邪能烈焰	大怪buff
			[GetSpellInfo(185189)] = {id = 185189, level = 8,}, --  魔化之怒/邪能之怒	大怪dot
			[GetSpellInfo(179909)] = {id = 179909, level = 8,}, --  命運共享/命运相连	能動/定身，找被定身的集合消連線
			[GetSpellInfo(179908)] = {id = 179908, level = 8,}, --  	 
			[GetSpellInfo(186770)] = {id = 186770, level = 8,}, --  靈魂之池/灵魂之池	碰到血魔的洗澡水
			[GetSpellInfo(180491)] = {id = 180491, level = 8,}, --  靈魂之核/灵魂纽带	暗牧(中怪)暗影箭增傷
			[GetSpellInfo(181582)] = {id = 181582, level = 8,}, --  低沉怒吼/狂野怒吼	大怪增傷
			[GetSpellInfo(181973)] = {id = 181973, level = 8,}, --  靈魂饗宴/灵魂盛宴	100%易傷1分鐘
		},
		[EJ_GetEncounterInfo(1433)] = { --暗影领主艾斯卡
			[GetSpellInfo(185239)] = {id = 185239, level = 8,}, --  安祖烈光/安苏之光	拿球疊dot
			[GetSpellInfo(182325)] = {id = 182325, level = 8,}, --  幻魅之傷/幻影之伤	dot，hp90%以上消失或拿球消
			[GetSpellInfo(182600)] = {id = 182600, level = 8,}, --  魔化火焰/邪能焚化	踩火
			[GetSpellInfo(181957)] = {id = 181957, level = 8,}, --  幻魅之風/幻影之风	吹下去，拿球消
			[GetSpellInfo(182178)] = {id = 182200, level = 8,}, --  魔化戰輪/邪能飞轮	出人群
			[GetSpellInfo(182178)] = {id = 182200, level = 8,}, --   
			[GetSpellInfo(179219)] = {id = 179219, level = 8,}, --  幻魅魔化炸彈/幻影邪能炸弹	別驅
			[GetSpellInfo(181753)] = {id = 181753, level = 8,}, --  魔化炸彈/邪能炸弹	拿球驅散
			[GetSpellInfo(181824)] = {id = 181824, level = 8,}, --  幻魅腐化/幻影腐蚀	10秒後爆炸，拿球清
			[GetSpellInfo(187344)] = {id = 187344, level = 8,}, --  幻魅火葬/幻影焚化	幻魅腐化給附近的人的易傷
			[GetSpellInfo(185456)] = {id = 185456, level = 8,}, --  絕望之鍊/绝望之链	配對(無誤)
			[GetSpellInfo(185510)] = {id = 185510, level = 8,}, --  黑暗束縛/暗影之缚	把鍊子綁在一起，沒有鍊子的人靠近會引爆
		},
		[EJ_GetEncounterInfo(1427)] = { --永恒者索克雷萨
			[GetSpellInfo(182038)] = {id = 182038, level = 8,}, -- 粉碎防禦/粉碎防御	迴盪之擊易傷，分攤，坦克2次換
			[GetSpellInfo(189627)] = {id = 189627, level = 8,}, -- 烈性魔珠/易爆的邪能宝珠	點名球追人，追到爆炸
			[GetSpellInfo(182218)] = {id = 182218, level = 8,}, -- 魔炎殘渣/	衝鋒留下綠火，75%減速
			[GetSpellInfo(180415)] = {id = 180415, level = 8,}, -- 魔化牢籠/邪能牢笼	水晶暈人
			[GetSpellInfo(183017)] = {id = 183017, level = 8,}, -- 
			[GetSpellInfo(189540)] = {id = 189540, level = 8,}, --	 極限威能/压倒能量	傀儡隨便電人，6秒dot
			[GetSpellInfo(184124)] = {id = 184124, level = 8,}, --	 曼那瑞之賜/堕落者之赐	綠圈aoe，別靠近別人
			[GetSpellInfo(182769)] = {id = 182769, level = 8,}, --	 恐怖凝視/魅影重重	p2被小怪追
			[GetSpellInfo(184239)] = {id = 184239, level = 8,}, --暗言術：痛苦/暗言术：恶	喚影師施放，驅散
			[GetSpellInfo(184053)] = {id = 184053, level = 8,}, --魔化屏障/邪能壁垒	支配者替boss套盾
			[GetSpellInfo(182900)] = {id = 182900, level = 8,}, --惡性糾纏/恶毒鬼魅	小怪恐懼
			[GetSpellInfo(182925)] = {id = 182925, level = 8,}, -- 
			[GetSpellInfo(188666)] = {id = 188666, level = 8,}, -- 永世饑渴/无尽饥渴	潛獵者追人，正面秒殺
			[GetSpellInfo(190776)] = {id = 190776, level = 8,}, -- 索奎薩爾的應變之計/索克雷萨之咒	潛獵者傀儡易傷
			[GetSpellInfo(188767)] = {id = 188767, level = 8,}, -- 染血追蹤者/步履蹒跚	潛獵者跑速加快
		},
		[EJ_GetEncounterInfo(1391)] = { --邪能领主扎昆
			[GetSpellInfo(180000)] = {id = 180000, level = 8,}, --凋零徽印/凋零契印	2-4層換坦
			[GetSpellInfo(179987)] = {id = 179987, level = 8,}, --蔑視光環/蔑视光环	p1光環，移動扣血
			[GetSpellInfo(181683)] = {id = 181683, level = 8,}, -- 壓迫光環/抑制光环	p2光環
			[GetSpellInfo(179993)] = {id = 179993, level = 8,}, -- 惡意光環/怨恨光环	p3光環
			[GetSpellInfo(180526)] = {id = 180526, level = 8,}, -- 腐化洗禮/腐蚀序列	P2 aoe標記，被標記的人會5碼aoe
			[GetSpellInfo(180166)] = {id = 180166, level = 8,}, -- 傷害之觸/裂伤之触	吸收治療量，驅散跳到別人身上
			[GetSpellInfo(180164)] = {id = 180164, level = 8,}, -- 
			[GetSpellInfo(182459)] = {id = 182459, level = 8,}, -- 定罪赦令/谴责法令	分攤
			[GetSpellInfo(180604)] = {id = 180604, level = 8,}, -- 剝奪之地/亵渎之地	P3地板紫圈
			[GetSpellInfo(180040)] = {id = 180040, level = 8,}, -- 統御者之禦/统御者壁垒	P3大怪給暴君90%減傷
			[GetSpellInfo(180300)] = {id = 180300, level = 8,}, -- 煉獄風暴/地火风暴	P1三豆AOE
		},
		[EJ_GetEncounterInfo(1447)] = { --祖霍拉克
			[GetSpellInfo(189260)] = {id = 189260, level = 8,}, -- 裂魂/破碎之魂	進場的暗影易傷
			[GetSpellInfo(179407)] = {id = 179407, level = 8,}, -- 虛體/魂不附体	進場debuff
			[GetSpellInfo(182008)] = {id = 182008, level = 8,}, -- 潛在能量/潜伏能量	撞到波爆炸
			[GetSpellInfo(189032)] = {id = 189032, level = 8,}, --被污染/玷污	吸收盾，分別是綠/黃/紅燈，刷滿6碼爆炸
			[GetSpellInfo(189031)] = {id = 189031, level = 8,}, --
			[GetSpellInfo(189030)] = {id = 189030, level = 8,}, --	 
			[GetSpellInfo(179428)] = {id = 179428, level = 8,}, -- 轟隆裂隙/轰鸣的裂隙	站在漩渦上，一個漩渦只要一個人踩
			[GetSpellInfo(181508)] = {id = 181508, level = 8,}, --
			[GetSpellInfo(181515)] = {id = 181515, level = 8,}, --  毀滅種子/毁灭之种	出人群
			[GetSpellInfo(181653)] = {id = 181653, level = 8,}, -- 惡魔水晶/邪能水晶	
			[GetSpellInfo(188998)] = {id = 188998, level = 8,}, -- 耗竭靈魂/枯竭灵魂	不能再次進場
		},
		[EJ_GetEncounterInfo(1394)] = { --暴君维哈里
			[GetSpellInfo(186134)] = {id = 186134, level = 8,}, --魔化之觸/邪蚀	受到火焰傷害的標記，持續15秒，碰到暗影傷害會爆炸
			[GetSpellInfo(186135)] = {id = 186135, level = 8,}, -- 虛無之觸/灵媒	受到暗影傷害的標記，持續15秒，碰到火焰傷害會爆炸
			[GetSpellInfo(185656)] = {id = 185656, level = 8,}, -- 影魔殲滅/邪影屠戮	觸發爆炸&5碼內玩家獲得的易傷
			[GetSpellInfo(186073)] = {id = 186073, level = 8,}, -- 魔化焦灼/邪能炙烤	踩到綠火
			[GetSpellInfo(186063)] = {id = 186063, level = 8,}, -- 破滅虛空/虚空消耗	踩到紫水
			[GetSpellInfo(186407)] = {id = 186407, level = 8,}, -- 惡魔奔騰/魔能喷涌	點名，5秒後腳下出綠火
			[GetSpellInfo(186333)] = {id = 186333, level = 8,}, -- 虛無怒濤/灵能涌动	點名，5秒後腳下出紫水
			[GetSpellInfo(186448)] = {id = 186448, level = 8,}, --魔炎亂舞/邪焰乱舞	綠色大怪易傷
			[GetSpellInfo(186453)] = {id = 186453, level = 8,}, -- 
			[GetSpellInfo(186785)] = {id = 186785, level = 8,}, --	枯萎凝視/凋零凝视	紫色大怪易傷
			[GetSpellInfo(186783)] = {id = 186783, level = 8,}, --	 
			[GetSpellInfo(188208)] = {id = 188208, level = 8,}, --	 著火/点燃	小鬼火球砸中的dot
			[GetSpellInfo(186547)] = {id = 186547, level = 8,}, --	 黑洞/黑洞	全團aoe直到踩掉為止
			[GetSpellInfo(186500)] = {id = 186500, level = 8,}, --	 魔化鎖鍊/邪能锁链	跑遠拉斷
			[GetSpellInfo(187204)] = {id = 187204, level = 8,}, --	 極度混沌/混乱压制	P4增傷，10秒一層
			[GetSpellInfo(189775)] = {id = 189775, level = 8,}, --	 強化魔化鎖鍊/	
		},
		[EJ_GetEncounterInfo(1395)] = { --玛诺洛斯
			[GetSpellInfo(181275)] = {id = 181275, level = 8,}, --	 軍團的詛咒/军团诅咒	驅散召喚領主
			[GetSpellInfo(181099)] = {id = 181099, level = 8,}, --	 毀滅印記/末日印记	受到傷害移除並爆炸，20碼AOE
			[GetSpellInfo(181119)] = {id = 181119, level = 8,}, --	 末日尖刺/末日之刺	層數越高，結束時的傷害越高
			[GetSpellInfo(189717)] = {id = 189717, level = 8,}, --	
			[GetSpellInfo(182171)] = {id = 182171, level = 8,}, --	 瑪諾洛斯之血/玛洛诺斯之血	踩到P1綠水
			[GetSpellInfo(184252)] = {id = 184252, level = 8,}, --	刺傷/穿刺之伤	(p2p3/p4)不該中；旋刃戳刺時身上有主動減傷就不會中(同萊登)
			[GetSpellInfo(191231)] = {id = 191231, level = 8,}, --	 
			[GetSpellInfo(181359)] = {id = 181359, level = 8,}, --	 巨力衝擊/巨力冲击	擊飛
			[GetSpellInfo(181597)] = {id = 181597, level = 8,}, --	 瑪諾洛斯的凝視/玛诺洛斯凝视	恐懼，分攤傷害
			[GetSpellInfo(181841)] = {id = 181841, level = 8,}, --	 暗影之力/暗影之力	推人(小心加速)
			[GetSpellInfo(182006)] = {id = 182006, level = 8,}, --	 瑪諾洛斯的強力凝視/强化玛诺洛斯凝视	恐懼，分攤傷害產生白水
			[GetSpellInfo(182088)] = {id = 182088, level = 8,}, --	 強化暗影之力/强化暗影之力	p4推人
			[GetSpellInfo(182031)] = {id = 182031, level = 8,}, --	 凝視之影/凝视暗影	踩到白色
			[GetSpellInfo(190482)] = {id = 190482, level = 8,}, --	 擁抱暗影/束缚暗影	
		},
		[EJ_GetEncounterInfo(1438)] = { --阿克蒙德
			[GetSpellInfo(183634)] = {id = 183634, level = 8,}, --	 影魔衝擊/暗影冲击	擊飛，分攤落地傷害
			[GetSpellInfo(187742)] = {id = 187742, level = 8,}, --	暗影爆破/暗影冲击	大怪易傷，坦克2層換
			[GetSpellInfo(183864)] = {id = 183864, level = 8,}, --	 
			[GetSpellInfo(183828)] = {id = 183828, level = 8,}, --	 死亡烙印/死亡烙印	大怪死才消失
			[GetSpellInfo(183586)] = {id = 183586, level = 8,}, --	 毀滅之火/魔火	踩火dot
			[GetSpellInfo(182879)] = {id = 182879, level = 8,}, --	 毀滅之火鎖定/魔火锁定	追人
			[GetSpellInfo(183963)] = {id = 183963, level = 8,}, --	 那魯之光/纳鲁之光	伊芮爾的小球，免疫暗影傷害
			[GetSpellInfo(185014)] = {id = 185014, level = 8,}, --	 聚集混沌/聚焦混乱	即將被傳遞塑形混沌
			[GetSpellInfo(186123)] = {id = 186123, level = 8,}, --	 塑型混沌/精炼混乱	正面直線aoe，傳遞給箭頭指向的人
			[GetSpellInfo(184964)] = {id = 184964, level = 8,}, --	 束縛折磨/枷锁酷刑	遠離靈魂30碼消除
			[GetSpellInfo(186952)] = {id = 186952, level = 8,}, -- 	虛空放逐/虚空放逐	進場
			[GetSpellInfo(186961)] = {id = 186961, level = 8,}, --	
			[GetSpellInfo(187047)] = {id = 187047, level = 8,}, --	 吞噬生命/吞噬声明	內場，降低受到的治療量
			[GetSpellInfo(189891)] = {id = 189891, level = 8,}, --	 虛空裂隙/虚空撕裂	傳送門在外場變成的水池
			[GetSpellInfo(190049)] = {id = 190049, level = 8,}, --	 虛空腐化/虚空腐化	內場易傷
			[GetSpellInfo(188796)] = {id = 188796, level = 8,}, --	 惡魔腐化/邪能腐蚀	場邊綠水
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
		copychat = true,
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
		autosell = true,
		alreadyknown = true,
		showitemlevel = true,
		autobuy = false,
		autobuylist = {},
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
		firendlyCR = true,
		enemyCR = true,
		playerplate = true,
		classresource_show = true,
		classresource = "player", --"player", "target"
		plateaura = false,
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
		hours24 = true,
		worldmapcoords = false,
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
					elseif OptionCategroy == "PlateOptions" then
						if setting == "customcoloredplates" then -- 非空则复制 7
							for index, t in pairs(aCoreCDB["PlateOptions"]["customcoloredplates"]) do
								if t.name ~= L["空"] then
									str = str.."^"..OptionCategroy.."~"..setting.."~"..index.."~"..t.name.."~"..t.color.r.."~"..t.color.g.."~"..t.color.b
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
					elseif setting == "autobuylist" then -- 完全复制 4
						for id, count in pairs(aCoreCDB["ItemOptions"]["autobuylist"]) do -- 默认是空的
							str = str.."^"..OptionCategroy.."~"..setting.."~"..id.."~"..count
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
				if f then
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
					local OptionCategroy, setting, arg1, arg2, arg3, arg4, arg5 = string.split("~", v)	
					local count = select(2, string.gsub(v, "~", "~")) + 1
	
					if count == 3 then -- 可以直接赋值
						if aCoreCDB[OptionCategroy][setting] then
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
							elseif arg1 == "otherplateauralist" then -- 完全复制 4 OptionCategroy.."~"..setting.."~"..id.."~true"
								aCoreCDB[OptionCategroy][setting][tonumber(arg1)] = true
							elseif sameclass then
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
						elseif setting == "autobuylist" then -- 完全复制 4 OptionCategroy.."~"..setting.."~"..id.."~"..count
							aCoreCDB[OptionCategroy][setting][arg1] = arg2
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