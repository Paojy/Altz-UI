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
		
		--9.0
		[GetSpellInfo(240443)]  = { id = 240443,  level = 8,}, -- 新爆裂
		[GetSpellInfo(342494)]  = { id = 342494,  level = 8,}, -- 狂妄吹嘘
	},
	["Debuffs_Black"] = {
	
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
		},
		[EJ_GetEncounterInfo(2401)] = { --> 斩血
			[GetSpellInfo(321768)] = {id = 321768, level = 8,}, -- 上钩了
		},
		[EJ_GetEncounterInfo(2390)] = { --> 无堕者哈夫

		},
		[EJ_GetEncounterInfo(2389)] = { --> 库尔萨洛克
			[GetSpellInfo(319539)] = {id = 319539, level = 8,}, -- 无魂者	
		},
		[EJ_GetEncounterInfo(2417)] = { --> 无尽女皇莫德雷莎
			[GetSpellInfo(323825)] = {id = 323825, level = 8,}, -- 攫取裂隙
		},
		["Trash"] = {
			[GetSpellInfo(333299)] = {id = 333299, level = 8,}, -- 荒芜诅咒
			[GetSpellInfo(330532)] = {id = 330532, level = 8,}, -- 锯齿箭
		},
	},

	[EJ_GetInstanceInfo(1183)] = { -- 凋魂之殇
		[EJ_GetEncounterInfo(2419)] = { --> 酷团

		},
		[EJ_GetEncounterInfo(2403)] = { --> 伊库斯博士
			[GetSpellInfo(329110)] = {id = 329110, level = 8,}, -- 软泥注射
		},
		[EJ_GetEncounterInfo(2423)] = { --> 多米娜
			[GetSpellInfo(336258)] = {id = 336258, level = 8,}, -- 落单狩猎
			[GetSpellInfo(331818)] = {id = 331818, level = 8,}, -- 暗影伏击
			[GetSpellInfo(325552)] = {id = 325552, level = 8,}, -- 毒性裂击
		},
		[EJ_GetEncounterInfo(2404)] = { --> 斯特拉达玛侯爵

		},
		["Trash"] = {
			[GetSpellInfo(336301)] = {id = 336301, level = 8,}, -- 裹体之网
		},
	},

	[EJ_GetInstanceInfo(1184)] = { -- 塞兹仙林的迷雾
		[EJ_GetEncounterInfo(2400)] = { --> 英格拉

		},
		[EJ_GetEncounterInfo(2402)] = { --> 唤雾者

		},
		[EJ_GetEncounterInfo(2405)] = { --> 特雷德奥瓦
			[GetSpellInfo(331172)] = {id = 331172, level = 8,}, -- 心灵连接
			[GetSpellInfo(322563)] = {id = 322563, level = 8,}, -- 被标记的猎物
			[GetSpellInfo(341198)] = {id = 341198, level = 8,}, -- 易燃爆炸，这条可能有错误
		},
		["Trash"] = {
			[GetSpellInfo(325027)] = {id = 325027, level = 8,}, -- 荆棘爆发
			[GetSpellInfo(323043)] = {id = 323043, level = 8,}, -- 放血
			[GetSpellInfo(322557)] = {id = 322557, level = 8,}, -- 灵魂分裂
		},
	},

	[EJ_GetInstanceInfo(1188)] = { -- 彼界
		[EJ_GetEncounterInfo(2408)] = { --> 哈卡
			[GetSpellInfo(328987)] = {id = 328987, level = 8,}, -- 狂热
			[GetSpellInfo(322746)] = {id = 322746, level = 8,}, -- 堕落之血
		},
		[EJ_GetEncounterInfo(2409)] = { --> 法力风暴
			[GetSpellInfo(320786)] = {id = 320786, level = 8,}, -- 势不可挡
		},
		[EJ_GetEncounterInfo(2398)] = { --> 艾柯莎
			[GetSpellInfo(323692)] = {id = 323692, level = 8,}, -- 奥术易伤
			},
		[EJ_GetEncounterInfo(2410)] = { --> 穆厄扎拉
			[GetSpellInfo(334913)] = {id = 334913, level = 8,}, -- 死亡之主
			[GetSpellInfo(325725)] = {id = 325725, level = 8,}, -- 寰宇操控
		},
		["Trash"] = {
			[GetSpellInfo(334496)] = {id = 334496, level = 8,}, -- 催眠光粉
			[GetSpellInfo(339978)] = {id = 339978, level = 8,}, -- 安抚迷雾
			[GetSpellInfo(333250)] = {id = 333250, level = 8,}, -- 放血之击
		},
	},
	
	[EJ_GetInstanceInfo(1186)] = { -- 晋升高塔
		[EJ_GetEncounterInfo(2399)] = { --> 金塔拉
			[GetSpellInfo(327481)] = {id = 327481, level = 8,}, -- 黑暗长枪
		},
		[EJ_GetEncounterInfo(2416)] = { --> 雯图纳柯丝
			[GetSpellInfo(324154)] = {id = 324154, level = 8,}, -- 暗影迅步
		},
		[EJ_GetEncounterInfo(2414)] = { --> 奥莱芙莉安
			[GetSpellInfo(323195)] = {id = 323195, level = 8,}, -- 净化冲击波
			[GetSpellInfo(338729)] = {id = 338729, level = 8,}, -- 充能践踏
		},
		[EJ_GetEncounterInfo(2412)] = { --> 疑虑圣杰德沃斯
			[GetSpellInfo(322818)] = {id = 322818, level = 8,}, -- 失去信心
			[GetSpellInfo(322817)] = {id = 322817, level = 8,}, -- 疑云密布
			[GetSpellInfo(335805)] = {id = 335805, level = 8,}, -- 执政官的壁垒
		},
		["Trash"] = {
			[GetSpellInfo(317661)] = {id = 317661, level = 8,}, -- 险恶毒液
			[GetSpellInfo(328331)] = {id = 328331, level = 8,}, -- 严刑逼供
		},
	},
	
	[EJ_GetInstanceInfo(1185)] = { -- 赎罪大厅
		[EJ_GetEncounterInfo(2406)] = { --> 罪污巨像

		},
		[EJ_GetEncounterInfo(2387)] = { --> 艾谢郎
			[GetSpellInfo(319603)] = {id = 319603, level = 8,}, -- 羁石诅咒
		},
		[EJ_GetEncounterInfo(2411)] = { --> 高阶裁决官阿丽兹
			[GetSpellInfo(323650)] = {id = 323650, level = 8,}, -- 萦绕锁定
		},
		[EJ_GetEncounterInfo(2413)] = { --> 宫务大臣
			[GetSpellInfo(335338)] = {id = 335338, level = 8,}, -- 哀伤仪式
		},
		["Trash"] = {
			[GetSpellInfo(326891)] = {id = 326891, level = 8,}, -- 痛楚
			[GetSpellInfo(329321)] = {id = 329321, level = 8,}, -- 锯齿横扫
			[GetSpellInfo(319611)] = {id = 319611, level = 8,}, -- 变成石头
			[GetSpellInfo(325876)] = {id = 325876, level = 8,}, -- 湮灭诅咒
			[GetSpellInfo(326632)] = {id = 326632, level = 8,}, -- 石化血脉
			[GetSpellInfo(326874)] = {id = 326874, level = 8,}, -- 脚踝撕咬
		},
	},
	
	[EJ_GetInstanceInfo(1189)] = { -- 赤红深渊
		[EJ_GetEncounterInfo(2388)] = { --> 贪食的克里克西斯

		},
		[EJ_GetEncounterInfo(2415)] = { --> 执行者塔沃德
			[GetSpellInfo(322554)] = {id = 322554, level = 8,}, -- 严惩
		},
		[EJ_GetEncounterInfo(2421)] = { --> 大学监贝律莉娅
			[GetSpellInfo(325254)] = {id = 325254, level = 8,}, -- 钢铁尖刺
			[GetSpellInfo(328593)] = {id = 328593, level = 8,}, -- 苦痛刑罚
		},
		[EJ_GetEncounterInfo(2407)] = { --> 卡尔将军
			[GetSpellInfo(327814)] = {id = 327814, level = 8,}, -- 邪恶创口
		},
		["Trash"] = {
			[GetSpellInfo(326827)] = {id = 326827, level = 8,}, -- 恐惧之缚
			[GetSpellInfo(326836)] = {id = 326836, level = 8,}, -- 镇压诅咒
			[GetSpellInfo(321038)] = {id = 321038, level = 8,}, -- 烦扰之魂
			[GetSpellInfo(335306)] = {id = 335306, level = 8,}, -- 尖刺镣铐
		},
	},
	
	[EJ_GetInstanceInfo(1182)] = { -- 通灵战潮
		[EJ_GetEncounterInfo(2395)] = { --> 凋骨

		},
		[EJ_GetEncounterInfo(2391)] = { --> 收割者
			[GetSpellInfo(320170)] = {id = 320170, level = 8,}, -- 通灵箭
		},
		[EJ_GetEncounterInfo(2392)] = { --> 外科医生缝肉

		},
		[EJ_GetEncounterInfo(2396)] = { --> 缚霜者纳尔佐
			[GetSpellInfo(323198)] = {id = 323198, level = 8,}, -- 黑暗放逐
		},
		["Trash"] = {
			[GetSpellInfo(321821)] = {id = 321821, level = 8,}, -- 作呕喷吐
			[GetSpellInfo(323365)] = {id = 323365, level = 8,}, -- 黑暗纠缠
			[GetSpellInfo(338353)] = {id = 338353, level = 8,}, -- 瘀液喷撒
			[GetSpellInfo(333485)] = {id = 333485, level = 8,}, -- 疾病之云
			[GetSpellInfo(338357)] = {id = 338357, level = 8,}, -- 暴锤
			[GetSpellInfo(328181)] = {id = 328181, level = 8,}, -- 冷冽之寒
			[GetSpellInfo(323464)] = {id = 323464, level = 8,}, -- 黑暗脓液
			[GetSpellInfo(327401)] = {id = 327401, level = 8,}, -- 共受苦难
			[GetSpellInfo(327397)] = {id = 327397, level = 8,}, -- 严酷命运
			[GetSpellInfo(322681)] = {id = 322681, level = 8,}, -- 肉钩
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
			[GetSpellInfo(330713)] = {id = 330713, level = 8,}, -- 耳鸣之痛
			[GetSpellInfo(340324)] = {id = 340324, level = 8,}, -- 鲜血脓液
			[GetSpellInfo(342077)] = {id = 342077, level = 8,}, -- 回声定位
		},
		[EJ_GetEncounterInfo(2429)] = {  --> 猎手阿尔迪莫
			[GetSpellInfo(335304)] = {id = 335304, level = 8,}, -- 寻罪箭
			[GetSpellInfo(334971)] = {id = 334971, level = 8,}, -- 锯齿利爪
			[GetSpellInfo(335111)] = {id = 335111, level = 8,}, -- 猎手印记
			[GetSpellInfo(335112)] = {id = 335112, level = 8,}, -- 猎手印记
			[GetSpellInfo(335113)] = {id = 335113, level = 8,}, -- 猎手印记
			[GetSpellInfo(334945)] = {id = 334945, level = 8,}, -- 深红痛击
			[GetSpellInfo(334852)] = {id = 334852, level = 8,}, -- 石化嚎叫
			[GetSpellInfo(334893)] = {id = 334893, level = 8,}, -- 尖石裂片
			[GetSpellInfo(334708)] = {id = 334708, level = 8,}, -- 致命咆哮
			[GetSpellInfo(334960)] = {id = 334960, level = 8,}, -- 恶毒之伤
		},
		[EJ_GetEncounterInfo(2422)] = {  --> 太阳之王的救赎
			[GetSpellInfo(333002)] = {id = 333002, level = 8,}, -- 劣民印记
			[GetSpellInfo(326078)] = {id = 326078, level = 8,}, -- 灌注者的恩赐
			[GetSpellInfo(325251)] = {id = 325251, level = 8,}, -- 骄傲之罪
		},
		[EJ_GetEncounterInfo(2418)] = {  --> 圣物匠赛·墨克斯
			[GetSpellInfo(327902)] = {id = 327902, level = 8,}, -- 锁定
			[GetSpellInfo(326302)] = {id = 326302, level = 8,}, -- 静滞陷阱
			[GetSpellInfo(325236)] = {id = 325236, level = 8,}, -- 毁灭符文
			[GetSpellInfo(327414)] = {id = 327414, level = 8,}, -- 附身
		},
		[EJ_GetEncounterInfo(2428)] = {  --> 饥饿的毁灭者
			[GetSpellInfo(334228)] = {id = 334228, level = 8,}, -- 不稳定的喷发
			[GetSpellInfo(329298)] = {id = 329298, level = 8,}, -- 暴食瘴气
		},
		[EJ_GetEncounterInfo(2420)] = {  --> 伊涅瓦·暗脉女勋爵
			[GetSpellInfo(325936)] = {id = 325936, level = 8,}, -- 共享认知
			[GetSpellInfo(335396)] = {id = 335396, level = 8,}, -- 隐秘欲望
			[GetSpellInfo(324982)] = {id = 324982, level = 8,}, -- 共受苦难
			[GetSpellInfo(324983)] = {id = 324983, level = 8,}, -- 共受苦难
			[GetSpellInfo(332664)] = {id = 332664, level = 8,}, -- 浓缩心能
			[GetSpellInfo(325382)] = {id = 325382, level = 8,}, -- 扭曲欲望
			[GetSpellInfo(331573)] = {id = 331573, level = 8,}, -- 无边悔罪
			[GetSpellInfo(340477)] = {id = 340477, level = 8,}, -- 高度浓缩心能
			[GetSpellInfo(325713)] = {id = 325713, level = 8,}, -- 残留心能
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
		},
		[EJ_GetEncounterInfo(2394)] = {  --> 泥拳
			[GetSpellInfo(335470)] = {id = 335470, level = 8,}, -- 恩佐斯之眼，坦克
			[GetSpellInfo(339181)] = {id = 339181, level = 8,}, -- 腐蚀者之触，心控
			[GetSpellInfo(331209)] = {id = 331209, level = 8,}, -- 腐蚀沼泽，别踩
			[GetSpellInfo(335293)] = {id = 335293, level = 8,}, -- 轮回噩梦，被咬
			[GetSpellInfo(335295)] = {id = 335295, level = 8,}, -- 诅咒之血，11码圈
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
		},
		[EJ_GetEncounterInfo(2424)] = {  --> 德纳修斯大帝
			[GetSpellInfo(326851)] = {id = 326851, level = 6,}, -- 虚化重击，坦克		
			[GetSpellInfo(327798)] = {id = 327798, level = 4,}, -- 动荡暴露，易伤。死了活该，不用监控
			[GetSpellInfo(327992)] = {id = 327992, level = 7,}, -- 不稳定的生命
			[GetSpellInfo(328276)] = {id = 328276, level = 7,}, -- 不稳定的梦魇
			[GetSpellInfo(326699)] = {id = 326699, level = 6,}, -- 不稳定的虚空爆发，沉默
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