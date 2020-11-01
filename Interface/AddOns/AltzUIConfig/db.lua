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
		[GetSpellInfo(296230)]  = { id = 296230,  level = 6,}, -- 活力导管精华

	},
	["Debuffs"] = {
		[GetSpellInfo(243237)]  = { id = 243237,  level = 6,},  -- 爆裂
		[GetSpellInfo(240559)]  = { id = 240559,  level = 6,},  -- 重伤
		[GetSpellInfo(209858)]  = { id = 209858,  level = 4,},  -- 死疽
		[GetSpellInfo(124273)]  = { id = 124273,  level = 4,},  -- 个人添加：重度醉拳
--		[GetSpellInfo(288694)]  = { id = 288694,  level = 10,}, -- 个人添加：暗影碎击
--		[GetSpellInfo(288388)]  = { id = 288388,  level = 15,}, -- 个人添加：夺魂
--		[GetSpellInfo(290085)]  = { id = 290085,  level = 10,}, -- 个人添加：驱逐灵魂
		[GetSpellInfo(314406)]  = { id = 314406,  level = 6,},  -- 个人添加：致残疫病
		[GetSpellInfo(314531)]  = { id = 314531,  level = 6,},  -- 个人添加：撕扯血肉
		[GetSpellInfo(314478)]  = { id = 314478,  level = 6,},  -- 个人添加：倾泻恐惧
		[GetSpellInfo(314308)]  = { id = 314308,  level = 4,},  -- 个人添加：灵魂毁灭
	},
}

--instanceID, name, description, bgImage, buttonImage, loreImage, dungeonAreaMapID, link = EJ_GetInstanceByIndex(index, isRaid)
--name, description, encounterID, rootSectionID, link = EJ_GetEncounterInfoByIndex(index[, instanceID])

G.Raids = {
	[EJ_GetInstanceInfo(1001)] = { -- 自由镇
		EJ_GetEncounterInfo(2102),
		EJ_GetEncounterInfo(2093),
		EJ_GetEncounterInfo(2094),
		EJ_GetEncounterInfo(2095),
		"Trash",
	},
	
	[EJ_GetInstanceInfo(1036)] = { -- 风暴神殿
		EJ_GetEncounterInfo(2153),
		EJ_GetEncounterInfo(2154),
		EJ_GetEncounterInfo(2155),
		EJ_GetEncounterInfo(2156),
		"Trash",
	},
	
	[EJ_GetInstanceInfo(1021)] = { -- 维克雷斯庄园
		EJ_GetEncounterInfo(2125),
		EJ_GetEncounterInfo(2126),
		EJ_GetEncounterInfo(2127),
		EJ_GetEncounterInfo(2128),
		EJ_GetEncounterInfo(2129),
		"Trash",
	},
	
	[EJ_GetInstanceInfo(968)] = { -- 阿塔达萨
		EJ_GetEncounterInfo(2082),
		EJ_GetEncounterInfo(2036),
		EJ_GetEncounterInfo(2083),
		EJ_GetEncounterInfo(2030),
		"Trash",
	},
	
	[EJ_GetInstanceInfo(1022)] = { -- 地渊孢林
		EJ_GetEncounterInfo(2157),
		EJ_GetEncounterInfo(2131),
		EJ_GetEncounterInfo(2130),
		EJ_GetEncounterInfo(2158),
		"Trash",
	},
	
	[EJ_GetInstanceInfo(1002)] = { -- 托尔达戈
		EJ_GetEncounterInfo(2097),
		EJ_GetEncounterInfo(2098),
		EJ_GetEncounterInfo(2099),
		EJ_GetEncounterInfo(2096),
		"Trash",
	},
	
	[EJ_GetInstanceInfo(1012)] = { -- 暴富矿区
		EJ_GetEncounterInfo(2109),
		EJ_GetEncounterInfo(2114),
		EJ_GetEncounterInfo(2115),
		EJ_GetEncounterInfo(2116),
		"Trash",
	},
	
	[EJ_GetInstanceInfo(1023)] = { -- 围攻伯拉勒斯
		EJ_GetEncounterInfo(2132),
		EJ_GetEncounterInfo(2133),
		EJ_GetEncounterInfo(2173),
		EJ_GetEncounterInfo(2134),
		EJ_GetEncounterInfo(2140),
		"Trash",
	},
	
	[EJ_GetInstanceInfo(1030)] = { -- 塞塔里斯神庙
		EJ_GetEncounterInfo(2142),
		EJ_GetEncounterInfo(2143),
		EJ_GetEncounterInfo(2144),
		EJ_GetEncounterInfo(2145),
		"Trash",
	},
	
	[EJ_GetInstanceInfo(1041)] = { -- 诸王之眠
		EJ_GetEncounterInfo(2165),
		EJ_GetEncounterInfo(2171),
		EJ_GetEncounterInfo(2170),
		EJ_GetEncounterInfo(2172),
		"Trash",
	},

	[EJ_GetInstanceInfo(1178)] = { -- 麦卡贡行动
		EJ_GetEncounterInfo(2357),
		EJ_GetEncounterInfo(2358),
		EJ_GetEncounterInfo(2360),
		EJ_GetEncounterInfo(2355),
		EJ_GetEncounterInfo(2336),
		EJ_GetEncounterInfo(2339),
		EJ_GetEncounterInfo(2348),
		EJ_GetEncounterInfo(2331),
		"Trash",
	},
	
	[EJ_GetInstanceInfo(1028)] = { -- Azeroth boss BFA
		EJ_GetEncounterInfo(2139),
		EJ_GetEncounterInfo(2141),
		EJ_GetEncounterInfo(2197),
		EJ_GetEncounterInfo(2212),
		EJ_GetEncounterInfo(2199),
		EJ_GetEncounterInfo(2198),
		EJ_GetEncounterInfo(2210),
	},
	
	[EJ_GetInstanceInfo(1031)] = { -- 奥迪尔
		EJ_GetEncounterInfo(2168),
		EJ_GetEncounterInfo(2167),
		EJ_GetEncounterInfo(2146),
		EJ_GetEncounterInfo(2169),
		EJ_GetEncounterInfo(2166),
		EJ_GetEncounterInfo(2195),
		EJ_GetEncounterInfo(2194),
		EJ_GetEncounterInfo(2147),
		"Trash",
	},

	[EJ_GetInstanceInfo(1176)] = { -- 达萨罗
		EJ_GetEncounterInfo(2333),
		EJ_GetEncounterInfo(2325),
		EJ_GetEncounterInfo(2341),
		EJ_GetEncounterInfo(2342),
		EJ_GetEncounterInfo(2330),
		EJ_GetEncounterInfo(2335),
		EJ_GetEncounterInfo(2334),
		EJ_GetEncounterInfo(2337),
		EJ_GetEncounterInfo(2343),
		"Trash",
	},

	[EJ_GetInstanceInfo(1177)] = { -- 熔炉
		EJ_GetEncounterInfo(2328),
		EJ_GetEncounterInfo(2332),
	},

	[EJ_GetInstanceInfo(1179)] = { -- 永恒王宫
		EJ_GetEncounterInfo(2352),
		EJ_GetEncounterInfo(2347),
		EJ_GetEncounterInfo(2353),
		EJ_GetEncounterInfo(2354),
		EJ_GetEncounterInfo(2351),
		EJ_GetEncounterInfo(2359),
		EJ_GetEncounterInfo(2349),
		EJ_GetEncounterInfo(2361),
		"Trash",
	},

	[EJ_GetInstanceInfo(1180)] = { -- 尼奥罗萨
		EJ_GetEncounterInfo(2368),
		EJ_GetEncounterInfo(2365),
		EJ_GetEncounterInfo(2369),
		EJ_GetEncounterInfo(2377),
		EJ_GetEncounterInfo(2372),
		EJ_GetEncounterInfo(2367),
		EJ_GetEncounterInfo(2373),
		EJ_GetEncounterInfo(2374),
		EJ_GetEncounterInfo(2370),
		EJ_GetEncounterInfo(2364),
		EJ_GetEncounterInfo(2366),
		EJ_GetEncounterInfo(2375),
		"Trash",
	},

}

G.DebuffList = {
	[EJ_GetInstanceInfo(968)] = { -- Atal'Dazar
		[EJ_GetEncounterInfo(2082)] = { --> Prêtresse Alun'za
			[GetSpellInfo(255582)] = {id = 255582, level = 8,}, 
			[GetSpellInfo(255558)] = {id = 255558, level = 8,}, 
			[GetSpellInfo(277072)] = {id = 277072, level = 4,}, 	-- 腐化的黄金
		},
		[EJ_GetEncounterInfo(2036)] = { --> Vol'kaal
			[GetSpellInfo(250371)] = {id = 250371, level = 8,}, 
			[GetSpellInfo(250372)] = {id = 250372, level = 8,}, --个人添加：挥之不去的恶心感
		},
		[EJ_GetEncounterInfo(2083)] = { --> Rezan
			[GetSpellInfo(255371)] = {id = 255371, level = 8,}, 
			[GetSpellInfo(255421)] = {id = 255421, level = 8,}, 
			[GetSpellInfo(255434)] = {id = 255434, level = 8,}, 
			[GetSpellInfo(257407)] = {id = 257407, level = 8,}, --个人添加：追踪
			},
		[EJ_GetEncounterInfo(2030)] = { --> Yazma
			[GetSpellInfo(250096)] = {id = 250096, level = 8,},
			[GetSpellInfo(256577)] = {id = 256577, level = 8,},
			[GetSpellInfo(259190)] = {id = 259190, level = 8,},
		},
		["Trash"] = {
			[GetSpellInfo(252781)] = {id = 252781, level = 8,},
			[GetSpellInfo(253562)] = {id = 253562, level = 8,},			
			[GetSpellInfo(255041)] = {id = 255041, level = 8,},
			[GetSpellInfo(252687)] = {id = 252687, level = 8,},
			[GetSpellInfo(254959)] = {id = 254959, level = 8,},		
			[GetSpellInfo(255814)] = {id = 255814, level = 8,},
		},
	},
	
	[EJ_GetInstanceInfo(1022)] = { -- Les Tréfonds Putrides
		[EJ_GetEncounterInfo(2157)] = { --> Leaxa l'aînée
			[GetSpellInfo(260685)] = {id = 260685, level = 8,},
		},
		[EJ_GetEncounterInfo(2131)] = { --> Gueule-de-pierre l'Infesté

		},
		[EJ_GetEncounterInfo(2130)] = { --> Zancha le Mande-spores
			[GetSpellInfo(259714)] = {id = 259714, level = 8,},
		},
		[EJ_GetEncounterInfo(2158)] = { --> Monstruosité déchaînée
			[GetSpellInfo(269301)] = {id = 269301, level = 8,},
		},
		["Trash"] = {
			[GetSpellInfo(265468)] = {id = 265468, level = 8,},
			[GetSpellInfo(278961)] = {id = 278961, level = 8,},
			[GetSpellInfo(272180)] = {id = 272180, level = 8,},
			[GetSpellInfo(272609)] = {id = 272609, level = 8,},
			[GetSpellInfo(265533)] = {id = 265533, level = 8,},
			[GetSpellInfo(265019)] = {id = 265019, level = 8,},
			[GetSpellInfo(265377)] = {id = 265377, level = 8,},
			[GetSpellInfo(265625)] = {id = 265625, level = 8,},
			[GetSpellInfo(266107)] = {id = 266107, level = 8,},
			[GetSpellInfo(260455)] = {id = 260455, level = 8,},
		},
	},
	
	[EJ_GetInstanceInfo(1030)] = { -- Temple de Sephrasliss
		[EJ_GetEncounterInfo(2142)] = { --> Viperis et Aspis
			[GetSpellInfo(263371)] = {id = 263371, level = 8,},
		},
		[EJ_GetEncounterInfo(2143)] = { --> Merekpha
			[GetSpellInfo(263914)] = {id = 263914, level = 8,},
			[GetSpellInfo(263958)] = {id = 263958, level = 8,},
		},
		[EJ_GetEncounterInfo(2144)] = { --> Galvazzt
			[GetSpellInfo(266923)] = {id = 266923, level = 8,},
		},
		[EJ_GetEncounterInfo(2145)] = { --> Avatar de Sephraliss

		},
		["Trash"] = {
			[GetSpellInfo(269686)] = {id = 269686, level = 8,},
			[GetSpellInfo(268013)] = {id = 268013, level = 8,},
			[GetSpellInfo(268008)] = {id = 268008, level = 8,},
			[GetSpellInfo(273563)] = {id = 273563, level = 8,},
			[GetSpellInfo(272657)] = {id = 272657, level = 8,},
			[GetSpellInfo(267027)] = {id = 267027, level = 8,},
			[GetSpellInfo(272699)] = {id = 272699, level = 8,},
			[GetSpellInfo(272655)] = {id = 272655, level = 8,},
			[GetSpellInfo(268007)] = {id = 268007, level = 8,},
			[GetSpellInfo(268024)] = {id = 268024, level = 8,},		--个人添加：脉冲
		},
	},
	
	[EJ_GetInstanceInfo(1012)] = { -- Le Filon
		[EJ_GetEncounterInfo(2109)] = { --> Disperseur de foule automatique
			[GetSpellInfo(257337)] = {id = 257337, level = 8,},
			[GetSpellInfo(270882)] = {id = 270882, level = 8,},
		},
		[EJ_GetEncounterInfo(2114)] = { --> Azerokk

		},
		[EJ_GetEncounterInfo(2115)] = { --> Rixxa Fluxifuge
			--[GetSpellInfo(259856)] = {id = 259856, level = 8,},
			[GetSpellInfo(259853)] = {id = 259853, level = 8,},
		},
		[EJ_GetEncounterInfo(2116)] = { --> Nabab Razzbam
			[GetSpellInfo(260829)] = {id = 260829, level = 8,},
			[GetSpellInfo(260838)] = {id = 260838, level = 8,},
		},
		["Trash"] = {
			[GetSpellInfo(263074)] = {id = 263074, level = 8,},
			[GetSpellInfo(280605)] = {id = 280605, level = 8,},
			[GetSpellInfo(268797)] = {id = 268797, level = 8,},
			[GetSpellInfo(269302)] = {id = 269302, level = 8,},
			[GetSpellInfo(280604)] = {id = 280604, level = 8,},
			[GetSpellInfo(257371)] = {id = 257371, level = 8,},
			[GetSpellInfo(257544)] = {id = 257544, level = 8,},
			[GetSpellInfo(268846)] = {id = 268846, level = 8,},
			[GetSpellInfo(262794)] = {id = 262794, level = 8,},
			[GetSpellInfo(262513)] = {id = 262513, level = 8,},
			[GetSpellInfo(263637)] = {id = 263637, level = 8,},
			[GetSpellInfo(262270)] = {id = 262270, level = 8,},
		},
	},
	
	[EJ_GetInstanceInfo(1021)] = { -- Manoir Malvoie
		[EJ_GetEncounterInfo(2125)] = { --> Triade Malecarde
			[GetSpellInfo(260703)] = {id = 260703, level = 8,},
			[GetSpellInfo(260907)] = {id = 260907, level = 8,},
			[GetSpellInfo(260741)] = {id = 260741, level = 8,},
		},
		[EJ_GetEncounterInfo(2126)] = { --> Goliath des âmes
			[GetSpellInfo(260551)] = {id = 260551, level = 8,},
		},
		[EJ_GetEncounterInfo(2127)] = { --> Raal le Bâfreur
			
		},
		[EJ_GetEncounterInfo(2128)] = { --> Seigneur et Dame Malvoie
			[GetSpellInfo(261440)] = {id = 261440, level = 8,},
			[GetSpellInfo(261438)] = {id = 261438, level = 8,},
		},
		[EJ_GetEncounterInfo(2129)] = { --> Gorak Tul
			
		},
		["Trash"] = {
			[GetSpellInfo(263905)] = {id = 263905, level = 8,},
			[GetSpellInfo(265880)] = {id = 265880, level = 8,},
			[GetSpellInfo(265882)] = {id = 265882, level = 8,},
			[GetSpellInfo(264105)] = {id = 264105, level = 8,},
			[GetSpellInfo(264050)] = {id = 264050, level = 8,},
			[GetSpellInfo(263891)] = {id = 263891, level = 8,},
			[GetSpellInfo(264378)] = {id = 264378, level = 8,},
			[GetSpellInfo(266035)] = {id = 266035, level = 8,},
			[GetSpellInfo(266036)] = {id = 266036, level = 8,},
			[GetSpellInfo(264556)] = {id = 264556, level = 8,},
			[GetSpellInfo(265760)] = {id = 265760, level = 8,},
			[GetSpellInfo(263943)] = {id = 263943, level = 8,},
			[GetSpellInfo(265881)] = {id = 265881, level = 8,},
			[GetSpellInfo(268202)] = {id = 268202, level = 8,},
			[GetSpellInfo(264153)] = {id = 264153, level = 8,},
			[GetSpellInfo(271175)] = {id = 271175, level = 8,},
			[GetSpellInfo(273658)] = {id = 273658, level = 8,},
		},
	},
	
	[EJ_GetInstanceInfo(1001)] = { -- Port-Liberté
		[EJ_GetEncounterInfo(2102)] = { --> Cap'taine céleste Kragg
			
		},
		[EJ_GetEncounterInfo(2093)] = { --> Conseil des capitaines
			[GetSpellInfo(258875)] = {id = 258875, level = 8,},
		},
		[EJ_GetEncounterInfo(2094)] = { --> Arène du Butin
			[GetSpellInfo(256363)] = {id = 256363, level = 8,},
		},
		[EJ_GetEncounterInfo(2095)] = { --> Harlan Sweete
			
		},
		["Trash"] = {
			[GetSpellInfo(258323)] = {id = 258323, level = 8,},
			[GetSpellInfo(257775)] = {id = 257775, level = 8,},
			[GetSpellInfo(257908)] = {id = 257908, level = 8,},
			[GetSpellInfo(257436)] = {id = 257436, level = 8,},
			[GetSpellInfo(274389)] = {id = 274389, level = 8,},
			[GetSpellInfo(274555)] = {id = 274555, level = 8,},
			[GetSpellInfo(257478)] = {id = 257478, level = 8,},
		},
	},
	
	[EJ_GetInstanceInfo(1041)] = { -- Repos des rois
		[EJ_GetEncounterInfo(2165)] = { --> Le serpent doré
			[GetSpellInfo(265773)] = {id = 265773, level = 8,},
		},
		[EJ_GetEncounterInfo(2171)] = { --> Mchimba l'Embaumeur
			[GetSpellInfo(267618)] = {id = 267618, level = 8,},
			[GetSpellInfo(267626)] = {id = 267626, level = 8,},
		},
		[EJ_GetEncounterInfo(2170)] = { --> Le conseil des tribus
			[GetSpellInfo(267273)] = {id = 267273, level = 8,},
			[GetSpellInfo(266238)] = {id = 266238, level = 8,},
			[GetSpellInfo(266231)] = {id = 266231, level = 8,},
			[GetSpellInfo(266191)] = {id = 266191, level = 8,},
		},
		[EJ_GetEncounterInfo(2172)] = { --> Dazar le premier roi
			[GetSpellInfo(268796)] = {id = 268796, level = 8,},
			[GetSpellInfo(268419)] = {id = 268419, level = 8,},
		},
		["Trash"] = {
			[GetSpellInfo(270492)] = {id = 270492, level = 8,},
			[GetSpellInfo(267763)] = {id = 267763, level = 8,},
			[GetSpellInfo(276031)] = {id = 276031, level = 8,},
			[GetSpellInfo(270920)] = {id = 270920, level = 8,},
			[GetSpellInfo(270865)] = {id = 270865, level = 8,},
			[GetSpellInfo(271564)] = {id = 271564, level = 8,},
			[GetSpellInfo(270507)] = {id = 270507, level = 8,},
			[GetSpellInfo(270003)] = {id = 270003, level = 8,},
			[GetSpellInfo(270084)] = {id = 270084, level = 8,},
			[GetSpellInfo(270487)] = {id = 270487, level = 8,},
			[GetSpellInfo(272388)] = {id = 272388, level = 8,},
			[GetSpellInfo(271640)] = {id = 271640, level = 8,},
			[GetSpellInfo(270499)] = {id = 270499, level = 8,},
			[GetSpellInfo(269369)] = {id = 269369, level = 8,},
			[GetSpellInfo(270289)] = {id = 270289, level = 8,},		-- 净化光线
		},
	},
	
	[EJ_GetInstanceInfo(1036)] = { -- Sanctuaire des tempetes
		[EJ_GetEncounterInfo(2153)] = { --> Aqu'sire
			[GetSpellInfo(264560)] = {id = 264560, level = 8,},
			[GetSpellInfo(264166)] = {id = 264166, level = 8,},
			[GetSpellInfo(264526)] = {id = 264526, level = 8,},
		},
		[EJ_GetEncounterInfo(2154)] = { --> Conseil des eaugures
			[GetSpellInfo(267818)] = {id = 267818, level = 8,},
			[GetSpellInfo(267899)] = {id = 267899, level = 8,},
		},
		[EJ_GetEncounterInfo(2155)] = { --> Seigneur Chantorage
			[GetSpellInfo(268896)] = {id = 268896, level = 8,},
			[GetSpellInfo(269104)] = {id = 269104, level = 8,},
			[GetSpellInfo(269131)] = {id = 269131, level = 8,},
		},
		[EJ_GetEncounterInfo(2156)] = { --> Vol'zith l'Insidieuse
			[GetSpellInfo(267034)] = {id = 267034, level = 8,},
		},
		["Trash"] = {
			[GetSpellInfo(268233)] = {id = 268233, level = 8,},
			[GetSpellInfo(268322)] = {id = 268322, level = 8,},
			[GetSpellInfo(276268)] = {id = 276268, level = 8,},
			[GetSpellInfo(274633)] = {id = 274633, level = 8,},
			[GetSpellInfo(268214)] = {id = 268214, level = 8,},
			[GetSpellInfo(268309)] = {id = 268309, level = 8,},
			[GetSpellInfo(268317)] = {id = 268317, level = 8,},
			[GetSpellInfo(268391)] = {id = 268391, level = 8,},
			[GetSpellInfo(274720)] = {id = 274720, level = 8,},
			[GetSpellInfo(268315)] = {id = 268315, level = 8,},
			[GetSpellInfo(276297)] = {id = 276297, level = 8,},
			[GetSpellInfo(268050)] = {id = 268050, level = 8,},
		},
	},
	
	[EJ_GetInstanceInfo(1023)] = { -- Siege de Boralus
		[EJ_GetEncounterInfo(2132)] = { --> Sergent Bainbridge
			[GetSpellInfo(261428)] = {id = 261428, level = 8,},
		},
		[EJ_GetEncounterInfo(2133)] = { --> Sergent Bainbridge
			[GetSpellInfo(261428)] = {id = 261428, level = 8,},
		},
		[EJ_GetEncounterInfo(2173)] = { --> Capitaine de l'effroi Boisclos
			[GetSpellInfo(273470)] = {id = 273470, level = 8,},
		},
		[EJ_GetEncounterInfo(2134)] = { --> Hadal Sombrabysse
			
		},
		[EJ_GetEncounterInfo(2140)] = { --> Viq'Goth
			[GetSpellInfo(274991)] = {id = 274991, level = 8,},
		},
		["Trash"] = {
			[GetSpellInfo(257168)] = {id = 257168, level = 8,},
			[GetSpellInfo(272588)] = {id = 272588, level = 8,},
			[GetSpellInfo(272571)] = {id = 272571, level = 8,},
			[GetSpellInfo(275835)] = {id = 275835, level = 8,},
			[GetSpellInfo(273930)] = {id = 273930, level = 8,},
			[GetSpellInfo(257292)] = {id = 257292, level = 8,},
			[GetSpellInfo(256897)] = {id = 256897, level = 8,},
			[GetSpellInfo(272874)] = {id = 272874, level = 8,},
			[GetSpellInfo(272834)] = {id = 272834, level = 8,},
			[GetSpellInfo(257169)] = {id = 257169, level = 8,},
			[GetSpellInfo(272713)] = {id = 272713, level = 8,},
			[GetSpellInfo(257036)] = {id = 257036, level = 8,},			--个人添加：狂野冲锋
			[GetSpellInfo(275836)] = {id = 275836, level = 6,},			--个人添加：钉刺之毒
		},
	},

	[EJ_GetInstanceInfo(1178)] = { -- 麦卡贡行动
		[EJ_GetEncounterInfo(2357)] = { --> 戈巴马克国王
			[GetSpellInfo(297257)] = {id = 297257, level = 8,},		--电荷充能
		},
		[EJ_GetEncounterInfo(2358)] = { --> 冈克
			[GetSpellInfo(298259)] = {id = 298259, level = 8,},		--束缚粘液
		},
		[EJ_GetEncounterInfo(2360)] = { --> 崔克茜和耐诺
			[GetSpellInfo(298669)] = {id = 298669, level = 8,},		--跳电
			[GetSpellInfo(298718)] = {id = 298718, level = 8,},		--超能跳电
		},
		[EJ_GetEncounterInfo(2355)] = { --> HK-8
			[GetSpellInfo(302274)] = {id = 302274, level = 8,},		--爆裂冲击
			[GetSpellInfo(303885)] = {id = 303885, level = 8,},		--爆裂喷发
		},
		[EJ_GetEncounterInfo(2336)] = { --> 坦克大战
			[GetSpellInfo(318587)] = {id = 318587, level = 8,},		--烈焰喷射
		},
		[EJ_GetEncounterInfo(2339)] = { --> 狂犬
			[GetSpellInfo(294929)] = {id = 294929, level = 8,},		--烈焰撕咬
		},
		[EJ_GetEncounterInfo(2348)] = { --> 机械师的花园
			[GetSpellInfo(285443)] = {id = 285443, level = 8,},		--隐秘烈焰
		},
		[EJ_GetEncounterInfo(2331)] = { --> 麦卡贡国王
			[GetSpellInfo(292267)] = {id = 292267, level = 8,},		--超荷电磁炮
			[GetSpellInfo(291928)] = {id = 291928, level = 8,},		--超荷电磁炮
		},		
		["Trash"] = {
			[GetSpellInfo(300659)] = {id = 300659, level = 8,},		--疾病
			[GetSpellInfo(299438)] = {id = 299438, level = 8,},		--无情铁锤，破甲
			[GetSpellInfo(298602)] = {id = 298602, level = 7,},		--烟雾弹
			[GetSpellInfo(301712)] = {id = 301712, level = 7,},		--突袭
			[GetSpellInfo(299475)] = {id = 299475, level = 7,},		--音速咆哮
			[GetSpellInfo(293670)] = {id = 293670, level = 7,},		--链刃
		},
	},
	
	[EJ_GetInstanceInfo(1002)] = { -- Tol Dagor
		[EJ_GetEncounterInfo(2097)] = { --> La reine des sables
			[GetSpellInfo(257119)] = {id = 257119, level = 8,},
		},
		[EJ_GetEncounterInfo(2098)] = { --> Jes Hurley
			[GetSpellInfo(257791)] = {id = 257791, level = 8,},
			[GetSpellInfo(257777)] = {id = 257777, level = 8,},
			[GetSpellInfo(260067)] = {id = 260067, level = 8,},
		},
		[EJ_GetEncounterInfo(2099)] = { --> Chevalier-capitaine Valyri
			[GetSpellInfo(257028)] = {id = 257028, level = 8,},
		},
		[EJ_GetEncounterInfo(2096)] = { --> Surveillant Korgus
			[GetSpellInfo(256198)] = {id = 256198, level = 8,},
			[GetSpellInfo(256101)] = {id = 256101, level = 8,},
			[GetSpellInfo(256044)] = {id = 256044, level = 8,},
--			[GetSpellInfo(256474)] = {id = 256474, level = 8,},
			[GetSpellInfo(256201)] = {id = 256201, level = 8,}, -- 个人添加：爆炎弹
		},
		["Trash"] = {
			[GetSpellInfo(258128)] = {id = 258128, level = 8,},
			[GetSpellInfo(265889)] = {id = 265889, level = 8,},
			[GetSpellInfo(258864)] = {id = 258864, level = 8,},
			[GetSpellInfo(258917)] = {id = 258917, level = 8,},
			[GetSpellInfo(258079)] = {id = 258079, level = 8,},
			[GetSpellInfo(258058)] = {id = 258058, level = 8,},
			[GetSpellInfo(260016)] = {id = 260016, level = 8,},
			[GetSpellInfo(258313)] = {id = 258313, level = 8,},
			[GetSpellInfo(259711)] = {id = 259711, level = 8,},
		},
	},
	
	[EJ_GetInstanceInfo(1028)] = { -- Azeroth boss BFA
		[EJ_GetEncounterInfo(2139)] = { --> T'zane
			
		},
		[EJ_GetEncounterInfo(2141)] = { --> Ji'arak

		},
		[EJ_GetEncounterInfo(2197)] = { --> Assemblage de grelons
			
		},
		[EJ_GetEncounterInfo(2212)] = { --> Le Rugissement du Lion
			
		},
		[EJ_GetEncounterInfo(2199)] = { --> Azurethos, le typhon aile
			
		},
		[EJ_GetEncounterInfo(2198)] = { --> Porteguerre Yenajz
			
		},
		[EJ_GetEncounterInfo(2210)] = { --> Krolauk gorgedune
			
		},
	},
	
	[EJ_GetInstanceInfo(1031)] = { -- 奥迪尔
		[EJ_GetEncounterInfo(2168)] = {  --> 
			[GetSpellInfo(271224)] = {id = 271224, level = 8,}, -- 赤红迸发
			[GetSpellInfo(270290)] = {id = 270290, level = 8,}, -- 鲜血风暴
			[GetSpellInfo(275189)] = {id = 275189, level = 8,}, -- 硬化血脉
			[GetSpellInfo(275205)] = {id = 275205, level = 8,}, -- 变大的心脏
		},
		[EJ_GetEncounterInfo(2167)] = {  --> 
			[GetSpellInfo(279660)] = {id = 279660, level = 8,}, -- 风土病毒
			[GetSpellInfo(279663)] = {id = 279663, level = 8,}, -- 传播感染
			[GetSpellInfo(268198)] = {id = 268198, level = 8,}, -- 粘附腐化
			[GetSpellInfo(274205)] = {id = 274205, level = 8,}, -- 能量衰竭
			[GetSpellInfo(268095)] = {id = 268095, level = 8,}, -- 净化荡涤
			[GetSpellInfo(267787)] = {id = 267787, level = 8,}, -- 消毒打击
		},
		[EJ_GetEncounterInfo(2146)] = {  --> 
			[GetSpellInfo(262313)] = {id = 262313, level = 8,}, -- 恶臭沼气
			[GetSpellInfo(262314)] = {id = 262314, level = 8,}, -- 腐烂恶臭
		},
		[EJ_GetEncounterInfo(2169)] = {  --> 
			[GetSpellInfo(265237)] = {id = 265237, level = 8,}, -- 粉碎
			[GetSpellInfo(265264)] = {id = 265264, level = 8,}, -- 虚空鞭笞
			[GetSpellInfo(265360)] = {id = 265360, level = 8,}, -- 翻腾欺诈
			[GetSpellInfo(264210)] = {id = 264210, level = 8,}, -- 锯齿咬颚
			[GetSpellInfo(265662)] = {id = 265662, level = 8,}, -- 腐化者的契约
			[GetSpellInfo(265646)] = {id = 265646, level = 8,}, -- 腐化者的意志
			[GetSpellInfo(270589)] = {id = 270589, level = 8,}, -- 虚空之嚎
			[GetSpellInfo(270620)] = {id = 270620, level = 8,}, -- 灵能冲击波
		},
		[EJ_GetEncounterInfo(2166)] = {  --> 
			[GetSpellInfo(265129)] = {id = 265129, level = 8,}, -- 终极菌体
			[GetSpellInfo(265127)] = {id = 265127, level = 8,}, -- 持续感染
			[GetSpellInfo(274990)] = {id = 274990, level = 8,}, -- 破裂损伤
			[GetSpellInfo(265178)] = {id = 265178, level = 8,}, -- 进化痛苦
			[GetSpellInfo(265212)] = {id = 265212, level = 8,}, -- 育种
			[GetSpellInfo(265206)] = {id = 265206, level = 8,}, -- 免疫力压制
			[GetSpellInfo(266948)] = {id = 266948, level = 8,}, -- 瘟疫炸弹
		},
		[EJ_GetEncounterInfo(2195)] = {  --> 
			[GetSpellInfo(272018)] = {id = 272018, level = 8,}, -- 黑暗吸收
			[GetSpellInfo(273365)] = {id = 273365, level = 8,}, -- 黑暗启示
			[GetSpellInfo(276020)] = {id = 276020, level = 8,}, -- 锁定
			[GetSpellInfo(273434)] = {id = 273434, level = 8,}, -- 绝望深渊
			[GetSpellInfo(274195)] = {id = 274195, level = 8,}, -- 堕落之血
			[GetSpellInfo(274358)] = {id = 274358, level = 8,}, -- 破裂之血
			[GetSpellInfo(274271)] = {id = 274271, level = 8,}, -- 死亡之愿
		},
		[EJ_GetEncounterInfo(2194)] = {  --> 
			[GetSpellInfo(272146)] = {id = 272146, level = 8,}, -- 毁灭
			[GetSpellInfo(273282)] = {id = 273282, level = 8,}, -- 精华撕裂
			[GetSpellInfo(272407)] = {id = 272407, level = 8,}, -- 湮灭之球
			[GetSpellInfo(272536)] = {id = 272536, level = 8,}, -- 毁灭迫近
			[GetSpellInfo(274230)] = {id = 274230, level = 8,}, -- 湮灭帷幕
			[GetSpellInfo(274019)] = {id = 274019, level = 8,}, -- 精神鞭笞
		},
		[EJ_GetEncounterInfo(2147)] = {  --> 
			[GetSpellInfo(267813)] = {id = 267813, level = 8,}, -- 血之宿主
			[GetSpellInfo(272506)] = {id = 272506, level = 8,}, -- 爆炸腐蚀
			[GetSpellInfo(270287)] = {id = 270287, level = 8,}, -- 疫病之地
			[GetSpellInfo(267427)] = {id = 267427, level = 8,}, -- 折磨
			[GetSpellInfo(267409)] = {id = 267409, level = 8,}, -- 黑暗交易
			[GetSpellInfo(263372)] = {id = 263372, level = 8,}, -- 能量矩阵
			[GetSpellInfo(263436)] = {id = 263436, level = 8,}, -- 不完美的生理机制
			[GetSpellInfo(267659)] = {id = 267659, level = 8,}, -- 不洁传染
			[GetSpellInfo(268174)] = {id = 268174, level = 8,}, -- 腐化触须
			[GetSpellInfo(270447)] = {id = 270447, level = 8,}, -- 腐化滋长
			[GetSpellInfo(263227)] = {id = 263227, level = 8,}, -- 腐败之血
			[GetSpellInfo(263235)] = {id = 263235, level = 8,}, -- 鲜血盛宴
			[GetSpellInfo(275008)] = {id = 275008, level = 8,}, -- 喋喋回声
			[GetSpellInfo(277007)] = {id = 277007, level = 8,}, -- 爆裂囊肿
			[GetSpellInfo(267700)] = {id = 267700, level = 8,}, -- 戈霍恩的凝视
		},
		["Trash"] = {
		
		},
	},

	[EJ_GetInstanceInfo(1176)] = { -- 达萨罗
		[EJ_GetEncounterInfo(2333)] = {  --> 圣光勇士
			[GetSpellInfo(283573)] = {id = 283573, level = 7,}, -- 圣洁之刃
			[GetSpellInfo(283617)] = {id = 283617, level = 7,}, -- 圣光之潮
			[GetSpellInfo(283651)] = {id = 283651, level = 7,}, -- 盲目之光
			[GetSpellInfo(284595)] = {id = 284595, level = 7,}, -- 苦修
			[GetSpellInfo(283582)] = {id = 283582, level = 7,}, -- 奉献
		},
		[EJ_GetEncounterInfo(2325)] = {  --> 丛林之王格洛恩
			[GetSpellInfo(285671)] = {id = 285671, level = 7,}, -- 碾碎
			[GetSpellInfo(285998)] = {id = 285998, level = 7,}, -- 凶狠咆哮
			[GetSpellInfo(285875)] = {id = 285875, level = 7,}, -- 撕裂噬咬
			[GetSpellInfo(285659)] = {id = 285659, level = 8,}, -- 猿猴折磨者核心-部落
			[GetSpellInfo(286373)] = {id = 286373, level = 8,}, -- 死亡战栗-联盟
			[GetSpellInfo(283069)] = {id = 283069, level = 7,}, -- 原子烈焰-部落
			[GetSpellInfo(286434)] = {id = 286434, level = 7,}, -- 死疽之核-联盟
			[GetSpellInfo(289406)] = {id = 289406, level = 7,}, -- 蛮兽压掷
			[GetSpellInfo(289292)] = {id = 289292, level = 7,}, -- 蛮兽压掷-eke版
			[GetSpellInfo(289307)] = {id = 289307, level = 7,}, -- 蛮兽压掷目标-eke版
		},
		[EJ_GetEncounterInfo(2341)] = {  --> 玉火大师
			[GetSpellInfo(286988)] = {id = 286988, level = 8,}, -- 炽热余烬
			[GetSpellInfo(284374)] = {id = 284374, level = 7,}, -- 熔岩陷阱
			[GetSpellInfo(282037)] = {id = 282037, level = 7,}, -- 升腾之焰
			[GetSpellInfo(286379)] = {id = 286379, level = 7,}, -- 炎爆术
			[GetSpellInfo(285632)] = {id = 285632, level = 7,}, -- 追踪
			[GetSpellInfo(288151)] = {id = 288151, level = 7,}, -- 考验后遗症
--			[GetSpellInfo(284089)] = {id = 284089, level = 7,}, -- 成功防御
			[GetSpellInfo(286503)] = {id = 286503, level = 7,}, -- 射线
			[GetSpellInfo(287747)] = {id = 287747, level = 7,}, -- 超力之球
		},
		[EJ_GetEncounterInfo(2342)] = {  --> 丰灵
			[GetSpellInfo(287424)] = {id = 287424, level = 7,}, -- 窃贼的报应
			[GetSpellInfo(284527)] = {id = 284527, level = 5,}, -- 坚毅守护者的钻石
			[GetSpellInfo(284546)] = {id = 284546, level = 5,}, -- 枯竭的钻石
--			[GetSpellInfo(284567)] = {id = 284567, level = 5,}, -- 顺风蓝宝石
--			[GetSpellInfo(284558)] = {id = 284558, level = 5,}, -- 暗影之王紫水晶
			[GetSpellInfo(284556)] = {id = 284556, level = 7,}, -- 暗影触痕
--			[GetSpellInfo(284611)] = {id = 284611, level = 5,}, -- 聚焦敌意红宝石
--			[GetSpellInfo(284645)] = {id = 284645, level = 5,}, -- 璀璨日光黄晶
			[GetSpellInfo(284798)] = {id = 284798, level = 7,}, -- 极度炽热
--			[GetSpellInfo(284814)] = {id = 284814, level = 5,}, -- 地之根系绿宝石
--			[GetSpellInfo(284881)] = {id = 284881, level = 5,}, -- 怒意释放猫眼石
			[GetSpellInfo(283610)] = {id = 283610, level = 7,}, -- 碾压
			[GetSpellInfo(283609)] = {id = 283609, level = 7,}, -- 碾压
			[GetSpellInfo(283507)] = {id = 283507, level = 7,}, -- 爆裂充能
			[GetSpellInfo(287648)] = {id = 287648, level = 7,}, -- 爆裂充能
			[GetSpellInfo(283063)] = {id = 283063, level = 7,}, -- 惩罚烈焰
			[GetSpellInfo(287513)] = {id = 287513, level = 7,}, -- 惩罚烈焰
			[GetSpellInfo(285479)] = {id = 285479, level = 7,}, -- 烈焰喷射
			[GetSpellInfo(283947)] = {id = 283947, level = 7,}, -- 烈焰喷射
			[GetSpellInfo(285014)] = {id = 285014, level = 8,}, -- 金币雨
			[GetSpellInfo(284470)] = {id = 284470, level = 8,}, -- 昏睡妖术
			[GetSpellInfo(287072)] = {id = 287072, level = 8,}, -- 液态黄金
			[GetSpellInfo(289383)] = {id = 289383, level = 8,}, -- 混沌位移
			[GetSpellInfo(287074)] = {id = 287074, level = 7,}, -- 熔化的黄金
		},
		[EJ_GetEncounterInfo(2330)] = {  --> 神选者教团
			[GetSpellInfo(282135)] = {id = 282135, level = 5,}, -- 恶意妖术
			[GetSpellInfo(282209)] = {id = 282209, level = 7,}, -- 掠食印记
			[GetSpellInfo(282592)] = {id = 282592, level = 6,}, -- 血流不止
			[GetSpellInfo(286838)] = {id = 286838, level = 6,}, -- 静电之球
			[GetSpellInfo(282444)] = {id = 282444, level = 6,}, -- 裂爪猛击
			[GetSpellInfo(285879)] = {id = 285879, level = 7,}, -- 记忆清除
			[GetSpellInfo(284663)] = {id = 284663, level = 8,}, -- 邦桑迪的愤怒
		},
		[EJ_GetEncounterInfo(2335)] = {  --> 拉斯塔哈大王
			[GetSpellInfo(284831)] = {id = 284831, level = 7,}, -- 炽焰引爆
			[GetSpellInfo(285010)] = {id = 285010, level = 7,}, -- 蟾蜍粘液毒素
			[GetSpellInfo(285044)] = {id = 285044, level = 7,}, -- 蟾蜍毒素-个人打普通添加
			[GetSpellInfo(284676)] = {id = 284676, level = 7,}, -- 净化之印
			[GetSpellInfo(290450)] = {id = 290450, level = 7,}, -- 净化之印-EKE版
			[GetSpellInfo(290448)] = {id = 290448, level = 7,}, -- 净化之印-EKE版
			[GetSpellInfo(285178)] = {id = 285178, level = 7,}, -- 蛇焰吐息
			[GetSpellInfo(289858)] = {id = 289858, level = 7,}, -- 碾压
			[GetSpellInfo(284740)] = {id = 284740, level = 8,}, -- 重斧掷击
			[GetSpellInfo(284781)] = {id = 284781, level = 8,}, -- 重斧掷击
			[GetSpellInfo(285349)] = {id = 285349, level = 7,}, -- 赤焰瘟疫
			[GetSpellInfo(284995)] = {id = 284995, level = 7,}, -- 僵尸尘
			[GetSpellInfo(285195)] = {id = 285195, level = 5,}, -- 寂灭凋零
			[GetSpellInfo(288449)] = {id = 288449, level = 8,}, -- 死亡之门
			[GetSpellInfo(286742)] = {id = 286742, level = 7,}, -- 死疽碎击
			[GetSpellInfo(286779)] = {id = 286779, level = 7,}, -- 死亡聚焦
			[GetSpellInfo(288415)] = {id = 288415, level = 7,}, -- 死亡之抚
			[GetSpellInfo(285213)] = {id = 285213, level = 7,}, -- 死亡之抚
			[GetSpellInfo(284688)] = {id = 284688, level = 7,}, -- 流星飞跃
		},
		[EJ_GetEncounterInfo(2334)] = {  --> 大工匠梅卡托克
			[GetSpellInfo(286646)] = {id = 286646, level = 8,}, -- 千兆伏特充能
			[GetSpellInfo(288806)] = {id = 288806, level = 7,}, -- 千兆伏特轰炸
			[GetSpellInfo(284168)] = {id = 284168, level = 7,}, -- 缩小
			[GetSpellInfo(282182)] = {id = 282182, level = 7,}, -- 毁灭加农炮
			[GetSpellInfo(287891)] = {id = 287891, level = 7,}, -- 绵羊弹片
			[GetSpellInfo(286516)] = {id = 286516, level = 7,}, -- 反干涉震击
			[GetSpellInfo(286480)] = {id = 286480, level = 7,}, -- 反干涉震击
			[GetSpellInfo(284214)] = {id = 284214, level = 7,}, -- 践踏
			[GetSpellInfo(287167)] = {id = 287167, level = 7,}, -- 基因解组
			[GetSpellInfo(286105)] = {id = 286105, level = 7,}, -- 干涉
		},
		[EJ_GetEncounterInfo(2337)] = {  --> 风暴之墙阻击战
			[GetSpellInfo(284405)] = {id = 284405, level = 7,}, -- 诱惑之歌
			[GetSpellInfo(284369)] = {id = 284369, level = 7,}, -- 海洋暴风
			[GetSpellInfo(284121)] = {id = 284121, level = 7,}, -- 雷霆轰鸣
			[GetSpellInfo(285350)] = {id = 285350, level = 8,}, -- 风暴哀嚎
			[GetSpellInfo(285000)] = {id = 285000, level = 7,}, -- 海藻缠裹
			[GetSpellInfo(285426)] = {id = 285426, level = 8,}, -- 风暴哀嚎-补充
		},
		[EJ_GetEncounterInfo(2343)] = {  --> 吉安娜·普罗德摩尔
			[GetSpellInfo(287490)] = {id = 287490, level = 7,}, -- 冻结
			[GetSpellInfo(287993)] = {id = 287993, level = 2,}, -- 寒冰之触
			[GetSpellInfo(285253)] = {id = 285253, level = 7,}, -- 寒冰碎片
			[GetSpellInfo(288038)] = {id = 288038, level = 7,}, -- 被标记的目标
			[GetSpellInfo(287626)] = {id = 287626, level = 7,}, -- 冰霜掌控
			[GetSpellInfo(287199)] = {id = 287199, level = 7,}, -- 寒冰之环
			[GetSpellInfo(288212)] = {id = 288212, level = 7,}, -- 舷侧攻击
			[GetSpellInfo(288434)] = {id = 288434, level = 7,}, -- 寒冰之手
			[GetSpellInfo(288374)] = {id = 288374, level = 7,}, -- 破城者炮击
			[GetSpellInfo(288219)] = {id = 288219, level = 7,}, -- 折射寒冰
			[GetSpellInfo(289220)] = {id = 289220, level = 7,}, -- 冰霜之心
		},
		["Trash"] = {
		
		},
	},

	[EJ_GetInstanceInfo(1177)] = { -- 风暴熔炉
		[EJ_GetEncounterInfo(2328)] = {  --> 无眠秘党
			[GetSpellInfo(282384)] = {id = 282384, level = 8,}, -- 精神割裂
			[GetSpellInfo(282561)] = {id = 282561, level = 7,}, -- 黑暗信使
			[GetSpellInfo(282566)] = {id = 282566, level = 8,}, -- 力量应许
--			[GetSpellInfo(282743)] = {id = 282743, level = 2,}, -- 风暴湮灭
			[GetSpellInfo(282738)] = {id = 282738, level = 2,}, -- 虚空之拥
			[GetSpellInfo(282589)] = {id = 282589, level = 5,}, -- 脑髓侵袭
			[GetSpellInfo(287876)] = {id = 287876, level = 5,}, -- 黑暗吞噬
			[GetSpellInfo(282432)] = {id = 282432, level = 8,}, -- 粉碎之凝
			[GetSpellInfo(282621)] = {id = 282621, level = 7,}, -- 终焉见证
			[GetSpellInfo(282517)] = {id = 282517, level = 7,}, -- 恐惧回响
			[GetSpellInfo(282386)] = {id = 282386, level = 7,}, -- 无光冲击 - 法术坦
			[GetSpellInfo(282540)] = {id = 282540, level = 7,}, -- 死亡化身
		},
		[EJ_GetEncounterInfo(2332)] = {  --> 乌纳特，虚空先驱
			[GetSpellInfo(284851)] = {id = 284851, level = 7,}, -- 末日之触
			[GetSpellInfo(285652)] = {id = 285652, level = 8,}, -- 贪食折磨
			[GetSpellInfo(285345)] = {id = 285345, level = 8,}, -- 恩佐斯的癫狂之眼
			[GetSpellInfo(285562)] = {id = 285562, level = 7,}, -- 不可知的恐惧
			[GetSpellInfo(285477)] = {id = 285477, level = 7,}, -- 渊黯
			[GetSpellInfo(285367)] = {id = 285367, level = 7,}, -- 恩佐斯的穿刺凝视
			[GetSpellInfo(285685)] = {id = 285685, level = 7,}, -- 恩佐斯之赐：疯狂
			[GetSpellInfo(284804)] = {id = 284804, level = 7,}, -- 深渊护持
			[GetSpellInfo(284722)] = {id = 284722, level = 7,}, -- 暗影之壳
			[GetSpellInfo(284733)] = {id = 284733, level = 2,}, -- 虚空之拥
--			[GetSpellInfo(284733)] = {id = 284733, level = 2,}, -- 史诗难度：动荡共鸣
		},
		["Trash"] = {
		
		},
	},

	[EJ_GetInstanceInfo(1179)] = { -- 永恒王宫
		[EJ_GetEncounterInfo(2352)] = {  --> 深渊指挥官西瓦拉
--			[GetSpellInfo(294711)] = {id = 294711, level = 5,}, -- 冰霜烙印，全场伴随，没有监控必要，个人注释掉
--			[GetSpellInfo(294715)] = {id = 294715, level = 5,}, -- 剧毒烙印，全场伴随，没有监控必要，个人注释掉
--			[GetSpellInfo(300882)] = {id = 300882, level = 5,}, -- 倒置之疾1，没有监控必要，个人注释掉
--			[GetSpellInfo(300883)] = {id = 300883, level = 5,}, -- 倒置之疾2，没有监控必要，个人注释掉
			[GetSpellInfo(300701)] = {id = 300701, level = 7,}, -- 白霜，坦克结束放水
			[GetSpellInfo(300705)] = {id = 300705, level = 7,}, -- 脓毒污染，坦克结束放水
			[GetSpellInfo(300961)] = {id = 300961, level = 7,}, -- 冰霜之地，别踩
			[GetSpellInfo(300962)] = {id = 300962, level = 7,}, -- 败血之地，别踩
			[GetSpellInfo(295348)] = {id = 295348, level = 8,}, -- 溢流寒霜，分摊
			[GetSpellInfo(295421)] = {id = 295421, level = 8,}, -- 溢流毒液，分摊
			[GetSpellInfo(295704)] = {id = 295704, level = 8,}, -- 冰霜标枪，帮挡
			[GetSpellInfo(295705)] = {id = 295705, level = 8,}, -- 剧毒标枪，帮挡
			[GetSpellInfo(294847)] = {id = 294847, level = 7,}, -- 不稳定混合物，爆炸
			[GetSpellInfo(295807)] = {id = 295807, level = 7,}, -- 冻结之血，冻僵昏迷
			[GetSpellInfo(295850)] = {id = 295850, level = 7,}, -- 癫狂，中毒迷惑
		},
		[EJ_GetEncounterInfo(2347)] = {  --> 黑水巨鳗
			[GetSpellInfo(298428)] = {id = 298428, level = 7,}, -- 暴食，换坦技
			[GetSpellInfo(292127)] = {id = 292127, level = 5,}, -- 墨黑深渊，无法获得治疗
			[GetSpellInfo(292138)] = {id = 292138, level = 5,}, -- 辐光生物质，坦克dot+可被治疗
--			[GetSpellInfo(292133)] = {id = 292133, level = 5,}, -- 生物体荧光，可被治疗，无需监视
			[GetSpellInfo(292167)] = {id = 292167, level = 6,}, -- 剧毒脊刺，dot
			[GetSpellInfo(298595)] = {id = 298595, level = 5,}, -- 发光的钉刺，碰到水母
--			[GetSpellInfo(292307)] = {id = 292307, level = 7,}, -- 深渊凝视1，碰到水母触发，无需监控
--			[GetSpellInfo(301494)] = {id = 301494, level = 7,}, -- 深渊凝视2，碰到水母触发，无需监控
			[GetSpellInfo(305085)] = {id = 305085, level = 7,}, -- 冲流1
			[GetSpellInfo(301180)] = {id = 301180, level = 7,}, -- 冲流2
			[GetSpellInfo(301494)] = {id = 301494, level = 8,}, -- 穿透x刺，未知，注意观察
		},
		[EJ_GetEncounterInfo(2353)] = {  --> 艾萨拉之辉
			[GetSpellInfo(296566)] = {id = 296566, level = 7,}, -- 海潮之拳，换坦技
			[GetSpellInfo(296737)] = {id = 296737, level = 8,}, -- 奥术炸弹，出人群
			[GetSpellInfo(296746)] = {id = 296746, level = 7,}, -- 奥术炸弹被炸昏6秒
--			[GetSpellInfo(295920)] = {id = 295920, level = 5,}, -- 远古风暴1，可能全屏效果，暂注释掉
--			[GetSpellInfo(295916)] = {id = 295916, level = 5,}, -- 远古风暴2，可能全屏效果，暂注释掉
			[GetSpellInfo(299152)] = {id = 299152, level = 7,}, -- 浸水，泡水了
			[GetSpellInfo(296462)] = {id = 296462, level = 7,}, -- 飓风陷阱1
			[GetSpellInfo(295919)] = {id = 295919, level = 5,}, -- 风暴之眼，可能全屏效果
		},
		[EJ_GetEncounterInfo(2354)] = {  --> 艾什凡女勋爵
			[GetSpellInfo(296725)] = {id = 296725, level = 7,}, -- 壶蔓猛击，换坦技
			[GetSpellInfo(296693)] = {id = 296693, level = 8,}, -- 浸水，撞球dot
			[GetSpellInfo(296752)] = {id = 296752, level = 7,}, -- 锋利的珊瑚，别碰
			[GetSpellInfo(302992)] = {id = 302992, level = 8,}, -- 咸水气泡1
			[GetSpellInfo(297333)] = {id = 297333, level = 8,}, -- 咸水气泡2
			[GetSpellInfo(297397)] = {id = 297397, level = 8,}, -- 咸水气泡3
			[GetSpellInfo(296938)] = {id = 296938, level = 7,}, -- 艾泽里特弧光黄1
			[GetSpellInfo(296941)] = {id = 296941, level = 7,}, -- 艾泽里特弧光黄2
			[GetSpellInfo(296942)] = {id = 296942, level = 7,}, -- 艾泽里特弧光红1
			[GetSpellInfo(296939)] = {id = 296939, level = 7,}, -- 艾泽里特弧光红2
			[GetSpellInfo(296940)] = {id = 296940, level = 7,}, -- 艾泽里特弧光蓝1
			[GetSpellInfo(296943)] = {id = 296943, level = 7,}, -- 艾泽里特弧光蓝2
		},
		[EJ_GetEncounterInfo(2351)] = {  --> 奥戈佐亚
			[GetSpellInfo(298156)] = {id = 298156, level = 7,}, -- 麻痹钉刺，换坦技
			[GetSpellInfo(298459)] = {id = 298459, level = 5,}, -- 羊水喷发，没踩水灭团技
			[GetSpellInfo(298306)] = {id = 298306, level = 8,}, -- 孵化培养液，dot
			[GetSpellInfo(305603)] = {id = 305603, level = 6,}, -- 电击
			[GetSpellInfo(295779)] = {id = 295779, level = 7,}, -- 水舞长枪
			[GetSpellInfo(300244)] = {id = 300244, level = 7,}, -- 狂怒急流，跑开
			[GetSpellInfo(298522)] = {id = 298522, level = 6,}, -- 导雷脉冲，没打断被昏
		},
		[EJ_GetEncounterInfo(2359)] = {  --> 女王法庭
			[GetSpellInfo(301830)] = {id = 301830, level = 7,}, -- 帕什玛之触，换坦技，8层换
			[GetSpellInfo(301832)] = {id = 301832, level = 7,}, -- 疯狂热诚，心控
			[GetSpellInfo(296851)] = {id = 296851, level = 8,}, -- 狂热裁决，出人群
			[GetSpellInfo(297836)] = {id = 297836, level = 5,}, -- 强能火花，爆炸易伤
			[GetSpellInfo(299575)] = {id = 299575, level = 7,}, -- 希里瓦兹之触，换坦技
			[GetSpellInfo(299914)] = {id = 299914, level = 7,}, -- 狂热冲锋，分摊
			[GetSpellInfo(300545)] = {id = 300545, level = 7,}, -- 力量决裂，别踩
--			[GetSpellInfo(304409)] = {id = 304409, level = 5,}, -- 重复行动，全屏效果考虑注释掉
--			[GetSpellInfo(304410)] = {id = 304410, level = 7,}, -- 重复行动，沉默
--			[GetSpellInfo(297656)] = {id = 297656, level = 7,}, -- 出列，分散，全屏效果考虑注释掉
			[GetSpellInfo(304128)] = {id = 304128, level = 7,}, -- 缓刑，移动
--			[GetSpellInfo(303188)] = {id = 303188, level = 7,}, -- 保持阵型，站好，，全屏效果考虑注释掉
--			[GetSpellInfo(297585)] = {id = 297585, level = 5,}, -- 服从或受苦，，全屏效果考虑注释掉
			[GetSpellInfo(297586)] = {id = 297586, level = 7,}, -- 承受折磨，免疫治疗5秒
		},
		[EJ_GetEncounterInfo(2349)] = {  --> 扎库尔,尼奥罗萨先驱
			[GetSpellInfo(298192)] = {id = 298192, level = 7,}, -- 黑暗虚空，踩到水
--			[GetSpellInfo(292971)] = {id = 292971, level = 6,}, -- 狂乱
--			[GetSpellInfo(295480)] = {id = 295480, level = 7,}, -- 心智锁链1
--			[GetSpellInfo(295495)] = {id = 295495, level = 7,}, -- 心智锁链2
			[GetSpellInfo(300133)] = {id = 300133, level = 7,}, -- 折断，线断昏迷
			[GetSpellInfo(292963)] = {id = 292963, level = 8,}, -- 惊惧
			[GetSpellInfo(294515)] = {id = 294515, level = 7,}, -- 黑暗撕裂
--			[GetSpellInfo(295173)] = {id = 295173, level = 5,}, -- 恐惧领域，P2，考虑注释掉
			[GetSpellInfo(293509)] = {id = 293509, level = 8,}, -- 梦魇之影，放水
			[GetSpellInfo(303819)] = {id = 303819, level = 7,}, -- 梦魇池，踩了水
			[GetSpellInfo(295249)] = {id = 295249, level = 5,}, -- 谵妄领域，P3，考虑注释掉
			[GetSpellInfo(304797)] = {id = 304797, level = 7,}, -- 狂乱坠焰
			[GetSpellInfo(295327)] = {id = 295327, level = 8,}, -- 碎裂心智，昏6秒
			[GetSpellInfo(296078)] = {id = 296078, level = 7,}, -- 黑暗脉冲
			[GetSpellInfo(299705)] = {id = 299705, level = 7,}, -- 黑暗通道
			[GetSpellInfo(296018)] = {id = 296018, level = 7,}, -- 狂躁惊恐
			[GetSpellInfo(296015)] = {id = 296015, level = 7,}, -- 腐蚀狂乱
		},
		[EJ_GetEncounterInfo(2361)] = {  --> 艾萨拉女王
--			[GetSpellInfo(298569)] = {id = 298569, level = 7,}, -- 干涸灵魂
			[GetSpellInfo(297907)] = {id = 297907, level = 7,}, -- 诅咒之心
			[GetSpellInfo(298014)] = {id = 298014, level = 7,}, -- 冰爆，换坦技
			[GetSpellInfo(298018)] = {id = 298018, level = 7,}, -- 冻结
			[GetSpellInfo(298756)] = {id = 298756, level = 7,}, -- 锯齿之锋，换坦技
			[GetSpellInfo(301078)] = {id = 301078, level = 7,}, -- 充能长矛
			[GetSpellInfo(298781)] = {id = 298781, level = 7,}, -- 奥术宝珠，吃球
			[GetSpellInfo(299094)] = {id = 299094, level = 7,}, -- 召唤1
			[GetSpellInfo(302141)] = {id = 302141, level = 7,}, -- 召唤2
			[GetSpellInfo(300001)] = {id = 300001, level = 7,}, -- 虔诚
			[GetSpellInfo(303825)] = {id = 303825, level = 7,}, -- 压抑深渊，溺水
			[GetSpellInfo(299276)] = {id = 299276, level = 7,}, -- 制裁
--			[GetSpellInfo(299251)] = {id = 299251, level = 6,}, -- 服从，别吃球，以下法令全屏效果，考虑注释掉
--			[GetSpellInfo(299249)] = {id = 299249, level = 6,}, -- 受苦，吃球
--			[GetSpellInfo(299255)] = {id = 299255, level = 6,}, -- 出列，单独站
--			[GetSpellInfo(299254)] = {id = 299254, level = 6,}, -- 集合，一起站
--			[GetSpellInfo(299252)] = {id = 299252, level = 6,}, -- 前进
--			[GetSpellInfo(299253)] = {id = 299253, level = 6,}, -- 停留
			[GetSpellInfo(302999)] = {id = 302999, level = 7,}, -- 奥术易伤，换坦技
			[GetSpellInfo(303657)] = {id = 303657, level = 7,}, -- 奥术震爆
		},
		["Trash"] = {
		
		},
	},

	[EJ_GetInstanceInfo(1180)] = { -- 尼奥罗萨
		[EJ_GetEncounterInfo(2368)] = {  --> 黑龙帝王拉希奥
			[GetSpellInfo(306015)] = {id = 306015, level = 7,}, -- 灼烧护甲，换坦技，2层换
			[GetSpellInfo(306163)] = {id = 306163, level = 8,}, -- 万物尽焚，点名技，出去放火
			[GetSpellInfo(313959)] = {id = 313959, level = 6,}, -- 灼热气泡，别踩
			[GetSpellInfo(314347)] = {id = 314347, level = 6,}, -- 毒扼，昏迷
			[GetSpellInfo(309733)] = {id = 309733, level = 7,}, -- 疯狂燃烧，工具人
			[GetSpellInfo(307053)] = {id = 307053, level = 6,}, -- 岩浆池，别踩
--			[GetSpellInfo(311362)] = {id = 311362, level = 6,}, -- 升温，环境效果，注释掉
--			[GetSpellInfo(313250)] = {id = 313250, level = 6,}, -- 蠕行疯狂，史诗，自己解决不用监视
			
		},
		[EJ_GetEncounterInfo(2365)] = {  --> 玛乌特
			[GetSpellInfo(307399)] = {id = 307399, level = 7,}, -- 暗影之伤，换坦技
			[GetSpellInfo(307806)] = {id = 307806, level = 7,}, -- 吞噬魔法，点名放圈
			[GetSpellInfo(307586)] = {id = 307586, level = 6,}, -- 噬魔深渊，踩圈
--			[GetSpellInfo(306301)] = {id = 306301, level = 6,}, -- 禁忌法力，玩家buff，无需关注
--			[GetSpellInfo(310611)] = {id = 310611, level = 6,}, -- 禁忌法力，玩家buff，无需关注
			[GetSpellInfo(314993)] = {id = 314993, level = 8,}, -- 吸取精华，出去驱散
			[GetSpellInfo(315025)] = {id = 315025, level = 8,}, -- 远古诅咒，史诗
		},
		[EJ_GetEncounterInfo(2369)] = {  --> 先知斯基特拉
--			[GetSpellInfo(307785)] = {id = 307785, level = 6,}, -- 扭曲心智，预计全屏，拟删除
--			[GetSpellInfo(307784)] = {id = 307784, level = 6,}, -- 困惑心智，预计全屏，拟删除
			[GetSpellInfo(308059)] = {id = 308059, level = 6,}, -- 暗影震击，换坦技
			[GetSpellInfo(309652)] = {id = 309652, level = 6,}, -- 虚幻之蚀，预计全屏，拟删除
			[GetSpellInfo(307950)] = {id = 307950, level = 8,}, -- 心智剥离，点名出去
			[GetSpellInfo(313215)] = {id = 313215, level = 6,}, -- 颤涌镜像，别靠近，可能能删除
		},
		[EJ_GetEncounterInfo(2377)] = {  --> 黑暗审判官夏奈什
			[GetSpellInfo(311551)] = {id = 311551, level = 7,}, -- 深渊打击，换坦技
			[GetSpellInfo(312406)] = {id = 312406, level = 7,}, -- 虚空觉醒，踢球
			[GetSpellInfo(314298)] = {id = 314298, level = 6,}, -- 末日迫近，3层死
			[GetSpellInfo(306311)] = {id = 306311, level = 6,}, -- 灵魂鞭笞，远离
			[GetSpellInfo(305575)] = {id = 305575, level = 6,}, -- 仪式领域，别靠近
			[GetSpellInfo(316211)] = {id = 316211, level = 6,}, -- 恐惧浪潮，史诗，可能能删除
		},
		[EJ_GetEncounterInfo(2372)] = {  --> 主脑
			[GetSpellInfo(313461)] = {id = 313461, level = 7,}, -- 腐蚀，别碰
			[GetSpellInfo(315311)] = {id = 315311, level = 7,}, -- 毁灭，换嘲
			[GetSpellInfo(313672)] = {id = 313672, level = 7,}, -- 酸液池，别踩
			[GetSpellInfo(314593)] = {id = 314593, level = 7,}, -- 麻痹毒液，毒
			[GetSpellInfo(313460)] = {id = 313460, level = 7,}, -- 虚化，躲
			[GetSpellInfo(310402)] = {id = 310402, level = 6,}, -- 吞食狂热，可能为全屏效果
		},
		[EJ_GetEncounterInfo(2367)] = {  --> 无厌者夏德哈
			[GetSpellInfo(307471)] = {id = 307471, level = 7,}, -- 碾压，坦克
			[GetSpellInfo(307472)] = {id = 307472, level = 7,}, -- 融解，坦克
			[GetSpellInfo(307358)] = {id = 307358, level = 8,}, -- 衰弱唾液，传染
			[GetSpellInfo(306928)] = {id = 306928, level = 6,}, -- 幽影吐息，恐惧
			[GetSpellInfo(308177)] = {id = 308177, level = 6,}, -- 熵能聚合，吃球
--			[GetSpellInfo(306930)] = {id = 306930, level = 6,}, -- 熵能暗息，减少治疗
			[GetSpellInfo(314736)] = {id = 314736, level = 6,}, -- 毒泡流溢，3秒死
			[GetSpellInfo(306929)] = {id = 306929, level = 6,}, -- 翻滚毒息，dot
			[GetSpellInfo(318078)] = {id = 318078, level = 8,}, -- 锁定，需查证
			[GetSpellInfo(309704)] = {id = 309704, level = 6,}, -- 腐蚀涂层，需查证
			[GetSpellInfo(312099)] = {id = 312099, level = 5,}, -- 史诗，美味狗粮，去喂
			[GetSpellInfo(312332)] = {id = 312332, level = 4,}, -- 史诗，粘液残留，喂过了
		},
		[EJ_GetEncounterInfo(2373)] = {  --> 德雷阿佳丝
			[GetSpellInfo(310246)] = {id = 310246, level = 6,}, -- 虚空之握，抓人
			[GetSpellInfo(310277)] = {id = 310277, level = 7,}, -- 动荡之种，坦克
			[GetSpellInfo(310309)] = {id = 310309, level = 6,}, -- 动荡易伤，爆炸易伤
			[GetSpellInfo(310358)] = {id = 310358, level = 6,}, -- 狂乱低语，减速
			[GetSpellInfo(310361)] = {id = 310361, level = 6,}, -- 不羁狂乱，炸昏
			[GetSpellInfo(310406)] = {id = 310406, level = 6,}, -- 虚空闪耀，可能能删除
--			[GetSpellInfo(308377)] = {id = 308377, level = 6,}, -- 虚化脓液，踩水打王，dps自己监控
--			[GetSpellInfo(317001)] = {id = 317001, level = 5,}, -- 暗影排异，不能踩水，无需关注
			[GetSpellInfo(310552)] = {id = 310552, level = 6,}, -- 精神鞭笞
			[GetSpellInfo(310563)] = {id = 310563, level = 6,}, -- 背叛低语，4层心控
			[GetSpellInfo(310567)] = {id = 310567, level = 6,}, -- 背叛者，心控
			[GetSpellInfo(310499)] = {id = 310499, level = 6,}, -- 烟雾弹
		},
		[EJ_GetEncounterInfo(2374)] = {  --> 伊格诺斯，重生之蚀
			[GetSpellInfo(309961)] = {id = 309961, level = 7,}, -- 恩佐斯之眼，坦克
			[GetSpellInfo(311367)] = {id = 311367, level = 7,}, -- 腐蚀者之触，心控
			[GetSpellInfo(310322)] = {id = 310322, level = 6,}, -- 腐蚀沼泽，别踩
			[GetSpellInfo(312486)] = {id = 312486, level = 8,}, -- 轮回噩梦，被咬
			[GetSpellInfo(311159)] = {id = 311159, level = 6,}, -- 诅咒之血，11码圈
			[GetSpellInfo(315094)] = {id = 315094, level = 7,}, -- 锁定
			[GetSpellInfo(313759)] = {id = 313759, level = 6,}, -- 史诗，诅咒之血，变小驱散
		},
		[EJ_GetEncounterInfo(2370)] = {  --> 维克修娜
			[GetSpellInfo(307359)] = {id = 307359, level = 8,}, -- 绝望，坦克，加满血
			[GetSpellInfo(307020)] = {id = 307020, level = 6,}, -- 暮光之息
--			[GetSpellInfo(307019)] = {id = 307019, level = 6,}, -- 虚空腐蚀，全屏不消，自己用wa监控
			[GetSpellInfo(306981)] = {id = 306981, level = 6,}, -- 虚空之赐
			[GetSpellInfo(310224)] = {id = 310224, level = 8,}, -- 毁灭，接力驱散
			[GetSpellInfo(307314)] = {id = 307314, level = 7,}, -- 渗透暗影，点名出去
			[GetSpellInfo(307343)] = {id = 307343, level = 6,}, -- 暗影残渣，别踩
			[GetSpellInfo(307250)] = {id = 307250, level = 6,}, -- 暮光屠戮
			[GetSpellInfo(315769)] = {id = 315769, level = 6,}, -- 屠戮
			[GetSpellInfo(307284)] = {id = 307284, level = 6,}, -- 恐怖降临，落单
			[GetSpellInfo(307645)] = {id = 307645, level = 6,}, -- 黑暗之心，被恐
			[GetSpellInfo(310323)] = {id = 310323, level = 6,}, -- 荒芜
			[GetSpellInfo(315932)] = {id = 315932, level = 6,}, -- 史诗，蛮力重击
		},
		[EJ_GetEncounterInfo(2364)] = {  --> 虚无者莱登
			[GetSpellInfo(306819)] = {id = 306819, level = 6,}, -- 虚化重击，坦克		
			[GetSpellInfo(306279)] = {id = 306279, level = 4,}, -- 动荡暴露，易伤。死了活该，不用监控
			[GetSpellInfo(306273)] = {id = 306273, level = 7,}, -- 不稳定的生命
			[GetSpellInfo(313077)] = {id = 313077, level = 7,}, -- 不稳定的梦魇
			[GetSpellInfo(306637)] = {id = 306637, level = 6,}, -- 不稳定的虚空爆发，沉默
			[GetSpellInfo(309777)] = {id = 309777, level = 5,}, -- 虚空污秽，接圈
			[GetSpellInfo(313227)] = {id = 313227, level = 7,}, -- 腐坏伤口，坦克
			[GetSpellInfo(310019)] = {id = 310019, level = 8,}, -- 充能锁链，拉断
			[GetSpellInfo(310022)] = {id = 310022, level = 8,}, -- 充能锁链，拉断
			[GetSpellInfo(306184)] = {id = 306184, level = 5,}, -- 施放的虚空，治疗破盾
			[GetSpellInfo(315252)] = {id = 315252, level = 6,}, -- 史诗，恐怖炼狱，被火追
			[GetSpellInfo(316065)] = {id = 316065, level = 8,}, -- 史诗，腐化存续，满血暴毙
		},
		[EJ_GetEncounterInfo(2366)] = {  --> 恩佐斯的外壳
			[GetSpellInfo(307832)] = {id = 307832, level = 6,}, -- 恩佐斯的仆从，心控
			[GetSpellInfo(313334)] = {id = 313334, level = 6,}, -- 恩佐斯之赐，超神
			[GetSpellInfo(306973)] = {id = 306973, level = 6,}, -- 疯狂炸弹，群恐
			[GetSpellInfo(313364)] = {id = 313364, level = 5,}, -- 精神腐烂
			[GetSpellInfo(315954)] = {id = 315954, level = 7,}, -- 漆黑伤疤，坦克
			[GetSpellInfo(307044)] = {id = 307044, level = 5,}, -- 梦魇抗原，被咬
			[GetSpellInfo(307011)] = {id = 307012, level = 7,}, -- 疯狂繁衍
			[GetSpellInfo(306985)] = {id = 306985, level = 6,}, -- 狂乱炸弹
			[GetSpellInfo(317627)] = {id = 317627, level = 6,}, -- 无尽虚空			
			[GetSpellInfo(307061)] = {id = 307061, level = 4,}, -- 菌丝生长，减速
			[GetSpellInfo(316848)] = {id = 316848, level = 8,}, -- 外膜
		},
		[EJ_GetEncounterInfo(2375)] = {  --> 腐蚀者恩佐斯
			[GetSpellInfo(314889)] = {id = 314889, level = 6,}, -- 探视心智
--			[GetSpellInfo(315624)] = {id = 315624, level = 6,}, -- 心智受限，无需监控
			[GetSpellInfo(309991)] = {id = 309991, level = 6,}, -- 痛楚
			[GetSpellInfo(313609)] = {id = 313609, level = 6,}, -- 恩佐斯之赐
			[GetSpellInfo(308996)] = {id = 308996, level = 6,}, -- 恩佐斯的仆从
			[GetSpellInfo(316711)] = {id = 316711, level = 6,}, -- 意志摧毁
			[GetSpellInfo(313400)] = {id = 313400, level = 8,}, -- 堕落心灵
			[GetSpellInfo(316542)] = {id = 316542, level = 7,}, -- 妄念
			[GetSpellInfo(316541)] = {id = 316541, level = 7,}, -- 妄念
			[GetSpellInfo(310042)] = {id = 310042, level = 6,}, -- 混乱爆发
			[GetSpellInfo(313793)] = {id = 313793, level = 6,}, -- 狂乱之火
			[GetSpellInfo(313610)] = {id = 313610, level = 6,}, -- 精神腐烂
			[GetSpellInfo(309698)] = {id = 309698, level = 6,}, -- 虚空鞭笞
			[GetSpellInfo(311392)] = {id = 311392, level = 6,}, -- 心灵之握
			[GetSpellInfo(310073)] = {id = 310073, level = 6,}, -- 心灵之握
			[GetSpellInfo(313184)] = {id = 313184, level = 6,}, -- 突触震击
			[GetSpellInfo(310331)] = {id = 310331, level = 6,}, -- 虚空凝视
			[GetSpellInfo(312155)] = {id = 312155, level = 6,}, -- 碎裂自我
			[GetSpellInfo(315675)] = {id = 315675, level = 6,}, -- 碎裂自我
			[GetSpellInfo(315672)] = {id = 315672, level = 6,}, -- 碎裂自我
			[GetSpellInfo(310134)] = {id = 310134, level = 6,}, -- 疯狂聚现
			[GetSpellInfo(312866)] = {id = 312866, level = 6,}, -- 灾变烈焰
			[GetSpellInfo(315772)] = {id = 315772, level = 6,}, -- 心灵之握
			[GetSpellInfo(318459)] = {id = 318459, level = 8,}, -- 生灵俱灭
			[GetSpellInfo(318196)] = {id = 318196, level = 8,}, -- 事件视界
		},
		["Trash"] = {
			[GetSpellInfo(316513)] = {id = 316513, level = 8,}, -- 穿心毒液
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
		style = 1, -- 1: tansparent , 2:dark bg reverse, 3:dark bg normal -- 加入
		enablefade = true,
		fadingalpha = 0.2,
		valuefontsize = 16,
		
		-- health/power
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
		Interruptible_color = {r = 0, g = 0, b = 0},
		notInterruptible_color = {r = 1, g = 0, b = 0},	
		
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
		healerraidheight = 50,
		healerraidwidth = 100,
		raidmanabars = true,
		raidhpheight = 0.85, -- slider
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
		healerraid_debuff_num = 3,
		healerraid_debuff_anchor_x = -20,
		healerraid_debuff_anchor_y = 10,
		healerraid_debuff_icon_size = 25,
		healerraid_debuff_icon_fontsize = 8,
		healerraid_buff_num = 3,
		healerraid_buff_anchor_x = -20,
		healerraid_buff_anchor_y = -10,
		healerraid_buff_icon_size = 20,
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
		threatcolor = true,
		plateaura = false,
		plateauranum = 5,
		plateaurasize = 15,	
		Interruptible_color = {r = 1, g = 1, b = 0},
		notInterruptible_color = {r = 1, g = 0, b = 0},	
		
		bar_width = 100,-- 条形
		bar_height = 8,
		bar_hp_perc = "perc", -- 数值样式  "perc" "value_perc"
		bar_alwayshp = false, -- 满血显示生命值
		
		number_size = 23,-- 数字型
		number_alwayshp = false, -- 满血显示生命值	
		number_cpwidth = 15, -- 职业能量长度
		
		-- 玩家姓名板
		playerplate = true,
		classresource_show = true,
		classresource_pos = "player", --"player", "target"		
		
		-- 光环列表 OK
		myplateauralist = G.BlackList,		
		otherplateauralist = G.WhiteList,
		myfiltertype = "blacklist", -- "blacklist", "whitelist", "none"
		otherfiltertype = "none", -- "whitelist", "none"
		
		-- 染色列表 1
		customcoloredplates = Customcoloredplates,
		
		-- 能量列表 1
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
		collectgarbage = false,	
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
	},
	SkinOptions = {
		setClassColor = true,
		setDBM = true,
		setSkada = true,
		setBW = true,
		showtopbar = true,
		showbottombar = true,
		decorativestyle = "light1",
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