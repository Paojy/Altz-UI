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
	--武僧
		[GetSpellInfo(116849)] = { id = 116849, level = 15,}, -- 作茧缚命
		[GetSpellInfo(115203)] = { id = 115203, level = 15,}, -- 壮胆酒
	--DK
		[GetSpellInfo(48707)]  = { id = 48707,  level = 15,}, -- 反魔法护罩
		[GetSpellInfo(48792)]  = { id = 48792,  level = 15,}, -- 冰封之韧
		[GetSpellInfo(49028)]  = { id = 49028,  level = 15,}, -- 吸血鬼之血
		[GetSpellInfo(55233)]  = { id = 55233,  level = 15,}, -- 符文刃舞
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
		[GetSpellInfo(122470)]  = { id = 122470,  level = 15,}, -- 业报之触
		[GetSpellInfo(122783)]  = { id = 122783,  level = 15,}, -- 散魔功
	--萨满
		[GetSpellInfo(108271)]  = { id = 108271,  level = 15,}, -- 星界转移

	},
	["Debuffs"] = {
		[GetSpellInfo(243237)]  = { id = 243237,  level = 15,}, -- 爆裂
		[GetSpellInfo(240559)]  = { id = 240559,  level = 15,}, -- 重伤
		[GetSpellInfo(209858)]  = { id = 209858,  level = 15,}, -- 死疽
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
}

G.DebuffList = {
	[EJ_GetInstanceInfo(968)] = { -- Atal'Dazar
		[EJ_GetEncounterInfo(2082)] = { --> Prêtresse Alun'za
			[GetSpellInfo(255582)] = {id = 255582, level = 8,}, 
			[GetSpellInfo(255558)] = {id = 255558, level = 8,}, 
		},
		[EJ_GetEncounterInfo(2036)] = { --> Vol'kaal
			[GetSpellInfo(250371)] = {id = 250371, level = 8,}, 
		},
		[EJ_GetEncounterInfo(2083)] = { --> Rezan
			[GetSpellInfo(255371)] = {id = 255371, level = 8,}, 
			[GetSpellInfo(255421)] = {id = 255421, level = 8,}, 
			[GetSpellInfo(255434)] = {id = 255434, level = 8,}, 
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
			[GetSpellInfo(256474)] = {id = 256474, level = 8,},
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
	},
	PALADIN = {
	    [53563] = true,		-- 圣光道标
        [156910] = true,	-- 信仰道标
		[25771] = true,		-- 自律
		[223306] = true,	-- 赋予信仰
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
		hideplayercastbaricon = false,
		
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
		
		-- totems
		totems = true,
		totemsize = 25,
		growthDirection = 'HORIZONTAL',
		sortDirection = 'ASCENDING',
		
		--[[ share ]]--
		enableraid = true,
		showraidpet = false,
		raidfontsize = 10,
		namelength = 4,
		showsolo = false,
		toggleForVehicle = true,
		autoswitch = false,
		raidonly = "healer",

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
		hotind_style = "icon_ind",-- "icon_ind", "number_ind"
		hotind_size = 15,
		hotind_filtertype = "whitelist", -- "blacklist", "whitelist"
		hotind_auralist = HealerIndicatorAuraList,
				
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
		enableplate = true,
		blzplates = true,
		blzplates_nameonly = true,
		name_fontsize = 18,
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
		combathide = true,	
		backdropOpacity = 0.8,
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
		vignettealerthide = true,
		flashtaskbar = true,
		autopet = true,
		LFGRewards = true,
		autoacceptproposal = true,
		hidemap = false,
		hidechat = false,
		worldmapcoords = false,
		afklogin = false,
		afkscreen = true,
		hidepanels = false,
		shiftfocus = false,
		customobjectivetracker = false,
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