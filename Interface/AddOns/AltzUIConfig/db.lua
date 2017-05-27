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
	
	[EJ_GetInstanceInfo(860)] = { -- 重返卡拉赞
		EJ_GetEncounterInfo(1820),
		EJ_GetEncounterInfo(1826),
		EJ_GetEncounterInfo(1827),
		EJ_GetEncounterInfo(1825),
		EJ_GetEncounterInfo(1835),
		EJ_GetEncounterInfo(1837),
		EJ_GetEncounterInfo(1836),
		EJ_GetEncounterInfo(1817),
		EJ_GetEncounterInfo(1818),
		EJ_GetEncounterInfo(1838),
	},
	
	[EJ_GetInstanceInfo(900)] = { -- 永夜大教堂
		EJ_GetEncounterInfo(1905),
		EJ_GetEncounterInfo(1906),
		EJ_GetEncounterInfo(1904),
		EJ_GetEncounterInfo(1878),
	},
	
	[EJ_GetInstanceInfo(822)] = { -- 破碎群岛
		EJ_GetEncounterInfo(1790),
		EJ_GetEncounterInfo(1774),
		EJ_GetEncounterInfo(1789),
		EJ_GetEncounterInfo(1795),
		EJ_GetEncounterInfo(1770),
		EJ_GetEncounterInfo(1769),
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
	
	[EJ_GetInstanceInfo(861)] = { -- 勇气试炼
		EJ_GetEncounterInfo(1819),
		EJ_GetEncounterInfo(1830),
		EJ_GetEncounterInfo(1829),
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
	[EJ_GetInstanceInfo(875)] = { -- 萨格拉斯之墓
		EJ_GetEncounterInfo(1862),
		EJ_GetEncounterInfo(1867),
		EJ_GetEncounterInfo(1856),
		EJ_GetEncounterInfo(1903),
		EJ_GetEncounterInfo(1861),
		EJ_GetEncounterInfo(1896),
		EJ_GetEncounterInfo(1897),
		EJ_GetEncounterInfo(1873),
		EJ_GetEncounterInfo(1898),
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
	
	[EJ_GetInstanceInfo(860)] = { -- 重返卡拉赞
		[EJ_GetEncounterInfo(1820)] = {
			
		},
		[EJ_GetEncounterInfo(1826)] = {
			
		},
		[EJ_GetEncounterInfo(1827)] = {
			
		},
		[EJ_GetEncounterInfo(1825)] = {
			
		},
		[EJ_GetEncounterInfo(1835)] = {
			
		},
		[EJ_GetEncounterInfo(1837)] = {
			
		},
		[EJ_GetEncounterInfo(1836)] = {
			
		},
		[EJ_GetEncounterInfo(1817)] = {
			
		},
		[EJ_GetEncounterInfo(1818)] = {
			
		},
		[EJ_GetEncounterInfo(1838)] = {
			
		},
	},
	
	[EJ_GetInstanceInfo(900)] = { -- 永夜大教堂
		[EJ_GetEncounterInfo(1905)] = {
			
		},
		[EJ_GetEncounterInfo(1906)] = {
			
		},
		[EJ_GetEncounterInfo(1904)] = {
			
		},
		[EJ_GetEncounterInfo(1878)] = {
			
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
	
		[EJ_GetEncounterInfo(1703)]={
			[GetSpellInfo(204504)] = {id = 204504, level = 8,},
			[GetSpellInfo(203045)] = {id = 203045, level = 8,},
			[GetSpellInfo(203096)] = {id = 203096, level = 8,},
			[GetSpellInfo(204463)] = {id = 204463, level = 8,},
			[GetSpellInfo(203646)] = {id = 203646, level = 8,},
			[GetSpellInfo(202978)] = {id = 202978, level = 8,},
			[GetSpellInfo(205043)] = {id = 205043, level = 8,},
		},
		[EJ_GetEncounterInfo(1738)]={
			[GetSpellInfo(210099)] = {id = 210099, level = 8,},
			[GetSpellInfo(209469)] = {id = 209469, level = 8,},
			[GetSpellInfo(210984)] = {id = 210984, level = 8,},
			[GetSpellInfo(208697)] = {id = 208697, level = 8,},
			[GetSpellInfo(208929)] = {id = 208929, level = 8,},
			[GetSpellInfo(212886)] = {id = 212886, level = 8,},
			[GetSpellInfo(215128)] = {id = 215128, level = 8,},
			[GetSpellInfo(215836)] = {id = 215836, level = 8,},
			[GetSpellInfo(215845)] = {id = 215845, level = 8,},
			[GetSpellInfo(209471)] = {id = 209471, level = 8,},
		},
		[EJ_GetEncounterInfo(1744)]={
			[GetSpellInfo(210228)] = {id = 210228, level = 8,},
			[GetSpellInfo(215300)] = {id = 215300, level = 8,},
			--[GetSpellInfo(215307)] = {id = 215307, level = 8,},
			[GetSpellInfo(213124)] = {id = 213124, level = 8,},
			--[GetSpellInfo(215489)] = {id = 215489, level = 8,},
			[GetSpellInfo(215460)] = {id = 215460, level = 8,},
			[GetSpellInfo(215582)] = {id = 215582, level = 8,},
			[GetSpellInfo(210850)] = {id = 210850, level = 8,},
			[GetSpellInfo(218124)] = {id = 218124, level = 8,},
			--[GetSpellInfo(218144)] = {id = 218144, level = 8,},
			[GetSpellInfo(218519)] = {id = 218519, level = 8,},
		},
		[EJ_GetEncounterInfo(1667)]={
			[GetSpellInfo(197943)] = {id = 197943, level = 8,},
			[GetSpellInfo(204859)] = {id = 204859, level = 8,},
			[GetSpellInfo(198006)] = {id = 198006, level = 8,},
			[GetSpellInfo(198108)] = {id = 198108, level = 8,},
			[GetSpellInfo(198388)] = {id = 198388, level = 8,},
			[GetSpellInfo(198392)] = {id = 198392, level = 8,},
			[GetSpellInfo(205611)] = {id = 205611, level = 8,},
			[GetSpellInfo(197980)] = {id = 197980, level = 8,},
		},
		[EJ_GetEncounterInfo(1704)]={
			[GetSpellInfo(207681)] = {id = 207681, level = 8,},
			[GetSpellInfo(204731)] = {id = 204731, level = 8,},
			[GetSpellInfo(204044)] = {id = 204044, level = 8,},
			[GetSpellInfo(205341)] = {id = 205341, level = 8,},
			[GetSpellInfo(203121)] = {id = 203121, level = 8,},
			[GetSpellInfo(203124)] = {id = 203124, level = 8,},
			[GetSpellInfo(203125)] = {id = 203125, level = 8,},
			[GetSpellInfo(203102)] = {id = 203102, level = 8,},
			[GetSpellInfo(203110)] = {id = 203110, level = 8,},
			[GetSpellInfo(203770)] = {id = 203770, level = 8,},
			[GetSpellInfo(203787)] = {id = 203787, level = 8,},
			[GetSpellInfo(204078)] = {id = 204078, level = 8,},
			[GetSpellInfo(214543)] = {id = 214543, level = 8,},
		},
		[EJ_GetEncounterInfo(1750)]={
			[GetSpellInfo(210279)] = {id = 210279, level = 8,},
			[GetSpellInfo(210315)] = {id = 210315, level = 8,},
			[GetSpellInfo(212681)] = {id = 212681, level = 8,},
			[GetSpellInfo(211612)] = {id = 211612, level = 8,},
			[GetSpellInfo(211989)] = {id = 211989, level = 8,}, -- buff
			[GetSpellInfo(211990)] = {id = 211990, level = 8,},
			[GetSpellInfo(216516)] = {id = 216516, level = 8,},
			[GetSpellInfo(211507)] = {id = 211507, level = 8,},
			[GetSpellInfo(211471)] = {id = 211471, level = 8,},
			[GetSpellInfo(213162)] = {id = 213162, level = 8,},
		},
		[EJ_GetEncounterInfo(1726)]={
			[GetSpellInfo(206005)] = {id = 206005, level = 8,},
			[GetSpellInfo(206109)] = {id = 206109, level = 8,},
			[GetSpellInfo(206651)] = {id = 206651, level = 8,},
			[GetSpellInfo(209158)] = {id = 209158, level = 8,},
			[GetSpellInfo(210451)] = {id = 210451, level = 8,},
			--[GetSpellInfo(209034)] = {id = 209034, level = 8,},
			[GetSpellInfo(208431)] = {id = 208431, level = 8,},
			[GetSpellInfo(207409)] = {id = 207409, level = 8,},
			[GetSpellInfo(208385)] = {id = 208385, level = 8,},
			[GetSpellInfo(211802)] = {id = 211802, level = 8,},
			[GetSpellInfo(224508)] = {id = 224508, level = 8,},
			[GetSpellInfo(205771)] = {id = 205771, level = 8,},
			[GetSpellInfo(211634)] = {id = 211634, level = 8,},
		},
	},

	[EJ_GetInstanceInfo(861)] = { -- 勇气试炼
		[EJ_GetEncounterInfo(1819)]={
			[GetSpellInfo(228932)] = {id = 228932, level = 8,}, --228918
			[GetSpellInfo(227491)] = {id = 227491, level = 8,},
			[GetSpellInfo(227490)] = {id = 227490, level = 8,},
			[GetSpellInfo(227500)] = {id = 227500, level = 8,},
			[GetSpellInfo(227498)] = {id = 227498, level = 8,},
			[GetSpellInfo(227499)] = {id = 227499, level = 8,},
			[GetSpellInfo(227781)] = {id = 227781, level = 8,},
			[GetSpellInfo(227475)] = {id = 227475, level = 8,},
			[GetSpellInfo(228029)] = {id = 228029, level = 8,},
			[GetSpellInfo(228007)] = {id = 228007, level = 8,},
		},
		[EJ_GetEncounterInfo(1830)]={
			[GetSpellInfo(228769)] = {id = 228769, level = 8,},
			[GetSpellInfo(228758)] = {id = 228758, level = 8,},
			[GetSpellInfo(228768)] = {id = 228768, level = 8,},
			[GetSpellInfo(228253)] = {id = 228253, level = 8,},
			[GetSpellInfo(228228)] = {id = 228228, level = 8,},
			[GetSpellInfo(228248)] = {id = 228248, level = 8,},
			[GetSpellInfo(219966)] = {id = 228248, level = 8,},
		},
		[EJ_GetEncounterInfo(1829)]={
			[GetSpellInfo(227982)] = {id = 227982, level = 8,},
			[GetSpellInfo(228054)] = {id = 228054, level = 8,},
			[GetSpellInfo(193367)] = {id = 193367, level = 8,},
			[GetSpellInfo(229119)] = {id = 229119, level = 8,},
			[GetSpellInfo(228127)] = {id = 228127, level = 8,},
			[GetSpellInfo(228055)] = {id = 228055, level = 8,},
			[GetSpellInfo(228519)] = {id = 228519, level = 8,},
			[GetSpellInfo(230197)] = {id = 230197, level = 8,},
			[GetSpellInfo(227998)] = {id = 227998, level = 8,},
			[GetSpellInfo(230267)] = {id = 230267, level = 8,},
			[GetSpellInfo(232488)] = {id = 232488, level = 8,},
			[GetSpellInfo(232450)] = {id = 232450, level = 8,},
		},
	},
	
	[EJ_GetInstanceInfo(786)] = { -- 暗夜要塞
		[EJ_GetEncounterInfo(1706)]={
			[GetSpellInfo(204284)] = {id = 204284, level = 8,},
			[GetSpellInfo(204483)] = {id = 204483, level = 8,},
			[GetSpellInfo(204744)] = {id = 204744, level = 8,},
		},
		[EJ_GetEncounterInfo(1725)]={
			[GetSpellInfo(206607)] = {id = 206607, level = 8,},
			[GetSpellInfo(206617)] = {id = 206617, level = 8,},
			[GetSpellInfo(219964)] = {id = 219964, level = 8,},
		},
		[EJ_GetEncounterInfo(1731)]={
			[GetSpellInfo(206641)] = {id = 206641, level = 8,},
			[GetSpellInfo(214573)] = {id = 214573, level = 8,},
			[GetSpellInfo(206838)] = {id = 206838, level = 8,},
			[GetSpellInfo(208499)] = {id = 208499, level = 8,},
			[GetSpellInfo(208910)] = {id = 208910, level = 8,},
		},
		[EJ_GetEncounterInfo(1751)]={
			[GetSpellInfo(215458)] = {id = 215458, level = 8,},
			[GetSpellInfo(212531)] = {id = 212531, level = 8,},
			[GetSpellInfo(212647)] = {id = 212647, level = 8,},
			[GetSpellInfo(213148)] = {id = 213148, level = 8,},
			[GetSpellInfo(213504)] = {id = 213504, level = 8,},
			[GetSpellInfo(212736)] = {id = 212736, level = 8,},
			[GetSpellInfo(213278)] = {id = 213278, level = 8,},
		},
		[EJ_GetEncounterInfo(1762)]={
			[GetSpellInfo(206480)] = {id = 206480, level = 8,},
			[GetSpellInfo(208230)] = {id = 208230, level = 8,},
			[GetSpellInfo(212794)] = {id = 212794, level = 8,},
			[GetSpellInfo(215988)] = {id = 215988, level = 8,},
			[GetSpellInfo(206466)] = {id = 206466, level = 8,},
			[GetSpellInfo(216024)] = {id = 216024, level = 8,},
			[GetSpellInfo(216027)] = {id = 216027, level = 8,},
			[GetSpellInfo(216040)] = {id = 216040, level = 8,},
			[GetSpellInfo(216685)] = {id = 216685, level = 8,},
		},
		[EJ_GetEncounterInfo(1713)]={
			[GetSpellInfo(206677)] = {id = 206677, level = 8,},
			[GetSpellInfo(205344)] = {id = 205344, level = 8,},
		},
		[EJ_GetEncounterInfo(1761)]={
			[GetSpellInfo(218342)] = {id = 218342, level = 8,},
			[GetSpellInfo(218503)] = {id = 218503, level = 8,},
			[GetSpellInfo(218780)] = {id = 218780, level = 8,},
			[GetSpellInfo(218304)] = {id = 218304, level = 8,},
			[GetSpellInfo(218809)] = {id = 218809, level = 8,},
			[GetSpellInfo(219235)] = {id = 219235, level = 8,},
			[GetSpellInfo(225105)] = {id = 225105, level = 8,},
		},
		[EJ_GetEncounterInfo(1732)]={
			[GetSpellInfo(206965)] = {id = 206965, level = 8,},
			[GetSpellInfo(206464)] = {id = 206464, level = 8,},
			[GetSpellInfo(214167)] = {id = 214167, level = 8,},
			[GetSpellInfo(206398)] = {id = 206398, level = 8,},
			[GetSpellInfo(205649)] = {id = 205649, level = 8,},
			[GetSpellInfo(206936)] = {id = 206936, level = 8,},
			[GetSpellInfo(207720)] = {id = 207720, level = 8,},
			[GetSpellInfo(206585)] = {id = 206585, level = 8,},
			[GetSpellInfo(206589)] = {id = 206589, level = 8,},
			[GetSpellInfo(207831)] = {id = 207831, level = 8,},
			[GetSpellInfo(205445)] = {id = 205445, level = 8,},
			[GetSpellInfo(205429)] = {id = 205429, level = 8,},
			[GetSpellInfo(216345)] = {id = 216345, level = 8,},
			[GetSpellInfo(216344)] = {id = 216344, level = 8,},
		},
		[EJ_GetEncounterInfo(1743)]={
			[GetSpellInfo(209166)] = {id = 209166, level = 8,},
			[GetSpellInfo(209165)] = {id = 209165, level = 8,},
			[GetSpellInfo(209433)] = {id = 209433, level = 8,},
			[GetSpellInfo(211261)] = {id = 211261, level = 8,},
			[GetSpellInfo(209244)] = {id = 209244, level = 8,},
			[GetSpellInfo(209615)] = {id = 209615, level = 8,},
			[GetSpellInfo(209973)] = {id = 209973, level = 8,},
		},
		[EJ_GetEncounterInfo(1737)] = {
			[GetSpellInfo(221891)] = {id = 221891, level = 8,},
			[GetSpellInfo(221728)] = {id = 221728, level = 8,},
			[GetSpellInfo(221606)] = {id = 221606, level = 8,},
			[GetSpellInfo(209454)] = {id = 209454, level = 8,},
			[GetSpellInfo(208802)] = {id = 208802, level = 8,},
		},
	},
	
	[EJ_GetInstanceInfo(875)] = { -- 萨格拉斯之墓
		[EJ_GetEncounterInfo(1862)] = {
			[GetSpellInfo(231363)] = {id = 231363, level = 8,},
			[GetSpellInfo(233279)] = {id = 233279, level = 8,},
			[GetSpellInfo(233062)] = {id = 233062, level = 8,},
			[GetSpellInfo(234346)] = {id = 234346, level = 8,},
			[GetSpellInfo(238588)] = {id = 238588, level = 8,},
		},
		[EJ_GetEncounterInfo(1867)] = {
			[GetSpellInfo(233426)] = {id = 233426, level = 8,},
			[GetSpellInfo(233431)] = {id = 233431, level = 8,},
			[GetSpellInfo(233441)] = {id = 233441, level = 8,},
			[GetSpellInfo(239401)] = {id = 239401, level = 8,},
			[GetSpellInfo(233983)] = {id = 233983, level = 8,},
			[GetSpellInfo(234015)] = {id = 234015, level = 8,},
			[GetSpellInfo(235230)] = {id = 235230, level = 8,},
		},
		[EJ_GetEncounterInfo(1856)] = {
			[GetSpellInfo(231998)] = {id = 231998, level = 8,},
			[GetSpellInfo(231854)] = {id = 231854, level = 8,},
			[GetSpellInfo(232061)] = {id = 232061, level = 8,},
			[GetSpellInfo(233429)] = {id = 233429, level = 8,},
			[GetSpellInfo(232174)] = {id = 232174, level = 8,},
			[GetSpellInfo(231729)] = {id = 231729, level = 8,},
			[GetSpellInfo(240319)] = {id = 240319, level = 8,},
			[GetSpellInfo(241600)] = {id = 241600, level = 8,},
		},
			[EJ_GetEncounterInfo(1903)] = { 
			[GetSpellInfo(230139)] = {id = 230139, level = 8,},
			[GetSpellInfo(230201)] = {id = 230201, level = 8,},
			[GetSpellInfo(232722)] = {id = 232722, level = 8,},
			[GetSpellInfo(230358)] = {id = 230358, level = 8,},
			[GetSpellInfo(230384)] = {id = 230384, level = 8,},
			[GetSpellInfo(232913)] = {id = 232913, level = 8,},
			[GetSpellInfo(239362)] = {id = 239362, level = 8,},
		},
		[EJ_GetEncounterInfo(1861)] = {
			[GetSpellInfo(236550)] = {id = 236550, level = 8,},
			[GetSpellInfo(236697)] = {id = 236697, level = 8,},
			[GetSpellInfo(236603)] = {id = 236603, level = 8,},
			[GetSpellInfo(236519)] = {id = 236519, level = 8,},
			[GetSpellInfo(236712)] = {id = 236712, level = 8,},
			[GetSpellInfo(239264)] = {id = 239264, level = 8,},
		},
		[EJ_GetEncounterInfo(1896)] = {
			[GetSpellInfo(239006)] = {id = 239006, level = 8,},
			[GetSpellInfo(236507)] = {id = 236507, level = 8,},
			[GetSpellInfo(235907)] = {id = 235907, level = 8,},
			[GetSpellInfo(238570)] = {id = 238570, level = 8,},
			[GetSpellInfo(235927)] = {id = 235927, level = 8,},
			[GetSpellInfo(236513)] = {id = 236513, level = 8,},
			[GetSpellInfo(236131)] = {id = 236131, level = 8,},
			[GetSpellInfo(236515)] = {id = 236515, level = 8,},
			[GetSpellInfo(236361)] = {id = 236361, level = 8,},
			[GetSpellInfo(236542)] = {id = 236542, level = 8,},
			[GetSpellInfo(236544)] = {id = 236544, level = 8,},
			[GetSpellInfo(236548)] = {id = 236548, level = 8,},
        },
		[EJ_GetEncounterInfo(1897)] = {
			[GetSpellInfo(235271)] = {id = 235271, level = 8,},
			[GetSpellInfo(241635)] = {id = 241635, level = 8,},
			[GetSpellInfo(235267)] = {id = 235267, level = 8,},
			[GetSpellInfo(234891)] = {id = 234891, level = 8,},
			[GetSpellInfo(239153)] = {id = 239153, level = 8,},
	    },
		[EJ_GetEncounterInfo(1873)] = {
			[GetSpellInfo(236604)] = {id = 236604, level = 8,},
			[GetSpellInfo(236494)] = {id = 236494, level = 8,},
			[GetSpellInfo(233856)] = {id = 233856, level = 8,},
			[GetSpellInfo(239739)] = {id = 239739, level = 8,},
			[GetSpellInfo(242017)] = {id = 242017, level = 8,},
			[GetSpellInfo(240728)] = {id = 240728, level = 8,},
			[GetSpellInfo(234418)] = {id = 234418, level = 8,},
		},
		[EJ_GetEncounterInfo(1898)] = {
		},
	},	
}

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
		arenaframes = true,
		
		-- show pvp timer
		pvpicon = false,
		
		-- show value
		runecooldown = true,
		dpsmana = true,
		stagger = true,
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
		hidblz = true,
		hidblz_receive = false,
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
		afkscreen = true,
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