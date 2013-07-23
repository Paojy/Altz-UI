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

G.Raids = {
	[EJ_GetInstanceInfo(362)] = { -- 雷电王座
		EJ_GetEncounterInfo(827),
		EJ_GetEncounterInfo(819),
		EJ_GetEncounterInfo(816),
		EJ_GetEncounterInfo(825),
		EJ_GetEncounterInfo(821),
		EJ_GetEncounterInfo(828),
		EJ_GetEncounterInfo(818),
		EJ_GetEncounterInfo(820),
		EJ_GetEncounterInfo(824),
		EJ_GetEncounterInfo(817),
		EJ_GetEncounterInfo(829),
		EJ_GetEncounterInfo(832),
		EJ_GetEncounterInfo(831),
		L["Trash"],
	},
	[EJ_GetInstanceInfo(320)] = { -- 永春台
		EJ_GetEncounterInfo(683),
		EJ_GetEncounterInfo(742),
		EJ_GetEncounterInfo(729),
		EJ_GetEncounterInfo(709),
		L["Trash"],
	},
	[EJ_GetInstanceInfo(330)] = { -- 恐惧之心
		EJ_GetEncounterInfo(745),
		EJ_GetEncounterInfo(744),
		EJ_GetEncounterInfo(713),
		EJ_GetEncounterInfo(741),
		EJ_GetEncounterInfo(737),
		EJ_GetEncounterInfo(743),
		L["Trash"],
	},
	[EJ_GetInstanceInfo(317)] = { -- 魔古山宝库
		EJ_GetEncounterInfo(679),
		EJ_GetEncounterInfo(689),
		EJ_GetEncounterInfo(682),
		EJ_GetEncounterInfo(687),
		EJ_GetEncounterInfo(726),
		EJ_GetEncounterInfo(677),
		L["Trash"],
	},
}

local DebuffList = {
	[EJ_GetInstanceInfo(317)] = { -- 魔古山宝库
		[L["Trash"]] = {
		},
		[EJ_GetEncounterInfo(679)] = { -- The Stone Guard
			[GetSpellInfo(116281)] = {id = 116281, level = 7,}, -- Cobalt Mine Blast, Magic root		
		},
		[EJ_GetEncounterInfo(689)] = { --Feng the Accursed
			[GetSpellInfo(116040)] = {id = 116040, level = 7,}, -- Epicenter, roomwide aoe.
			[GetSpellInfo(116784)] = {id = 116784, level = 7,}, -- Wildfire Spark, Debuff that explodes leaving fire on the ground after 5 sec.
			[GetSpellInfo(116374)] = {id = 116374, level = 7,}, -- Lightning Charge, Stun debuff.
			[GetSpellInfo(116417)] = {id = 116417, level = 7,}, -- Arcane Resonance, aoe-people-around-you-debuff.
			[GetSpellInfo(116942)] = {id = 116942, level = 7,}, -- Flaming Spear, fire damage dot.		
		},
		[EJ_GetEncounterInfo(682)] = { -- Gara'jal the Spiritbinder
			[GetSpellInfo(122151)] = {id = 122151, level = 7,},	-- Voodoo Doll, shared damage with the tank.
			[GetSpellInfo(116161)] = {id = 116161, level = 7,},	-- Crossed Over, people in the spirit world.
		},
		[EJ_GetEncounterInfo(687)] = { -- The Spirit Kings
			[GetSpellInfo(117708)] = {id = 117708, level = 7,}, -- Meddening Shout, The mind control debuff.
			[GetSpellInfo(118303)] = {id = 118303, level = 7,}, -- Fixate, the once targeted by the shadows.
			[GetSpellInfo(118048)] = {id = 118048, level = 7,}, -- Pillaged, the healing/Armor/damage debuff.
			[GetSpellInfo(118135)] = {id = 118135, level = 7,}, -- Pinned Down, Najentus spine 2.0
			[GetSpellInfo(118163)] = {id = 118163, level = 7,}, -- 巧取豪夺
		},
		[EJ_GetEncounterInfo(726)] = { --Elegon
			[GetSpellInfo(117878)] = {id = 117878, level = 7,}, -- Overcharged, the stacking increased damage taken debuff.	
			[GetSpellInfo(117870)] = {id = 117870, level = 7,}, -- Touch of the Titans, the debuff everybody gets increasing damage done and healing taken.
			[GetSpellInfo(117949)] = {id = 117949, level = 7,}, -- Closed Circuit, Magic Healing debuff.
			[GetSpellInfo(132222)] = {id = 132222, level = 7,}, -- 不稳定能量
		},
		[EJ_GetEncounterInfo(677)] = { --Will of the Emperor
			[GetSpellInfo(116969)] = {id = 116969, level = 7,}, -- Stomp, Stun from the bosses.
			[GetSpellInfo(116835)] = {id = 116835, level = 7,}, -- Devestating Arc, Armor debuff from the boss.
			[GetSpellInfo(116778)] = {id = 116778, level = 7,}, -- Focused Defense, Fixate from the Emperors Courage.
			[GetSpellInfo(117485)] = {id = 117485, level = 7,}, -- Impending Thrust, Stacking slow from the Emperors Courage.
			[GetSpellInfo(116525)] = {id = 116525, level = 7,}, -- Focused Assault, Fixate from the Emperors Rage
			[GetSpellInfo(116550)] = {id = 116550, level = 7,}, -- Energizing Smash, Knockdown from the Emperors Strength
		},
	},

	[EJ_GetInstanceInfo(330)] = { -- 恐惧之心
		[L["Trash"]] = {
		},
		[EJ_GetEncounterInfo(745)] = { -- Imperial Vizier Zor'lok
			[GetSpellInfo(122761)] = {id = 122761, level = 7,}, -- Exhale, The person targeted for Exhale. 
			[GetSpellInfo(123812)] = {id = 123812, level = 7,}, -- Pheromones of Zeal, the gas in the middle of the room.
			[GetSpellInfo(122706)] = {id = 122706, level = 7,}, -- Noise Cancelling, The "safe zone" from the roomwide aoe.
			[GetSpellInfo(122740)] = {id = 122740, level = 7,}, -- Convert, The mindcontrol Debuff.
		},
		[EJ_GetEncounterInfo(744)] = { -- Blade Lord Ta'yak
			[GetSpellInfo(123180)] = {id = 123180, level = 7,}, -- Wind Step, Bleeding Debuff from stealth.
			[GetSpellInfo(123474)] = {id = 123474, level = 7,}, -- Overwhelming Assault, stacking tank swap debuff. 
		},
		[EJ_GetEncounterInfo(713)] = { -- Garalon
			[GetSpellInfo(122774)] = {id = 122774, level = 7,}, -- Crush, stun from the crush ability.
			[GetSpellInfo(123426)] = {id = 123426, level = 7,}, -- Weak Points, Increased damage done to one leg.
			[GetSpellInfo(123428)] = {id = 123428, level = 7,}, -- Weak Points, Increased damage to another leg.
			[GetSpellInfo(123423)] = {id = 123423, level = 7,}, -- Weak Points, Increased damage to another leg.
			[GetSpellInfo(123235)] = {id = 123235, level = 7,}, -- Weak Points, Increased damage to another leg.
			[GetSpellInfo(122835)] = {id = 122835, level = 7,}, -- Pheromones, The buff indicating who is carrying the pheramone.
			[GetSpellInfo(123081)] = {id = 123081, level = 7,}, -- Punchency, The stacking debuff causing the raid damage.
		},
		[EJ_GetEncounterInfo(741)] = { 	--Wind Lord Mel'jarak
			[GetSpellInfo(122055)] = {id = 122055, level = 7,}, -- Residue, The debuff after breaking a prsion preventing further breaking.
			[GetSpellInfo(121885)] = {id = 121885, level = 7,}, -- Amber Prison, The stun that somebody has to click off.
			[GetSpellInfo(121881)] = {id = 121881, level = 7,}, -- Amber Prison, not sure what the differance is but both were used.
			[GetSpellInfo(122125)] = {id = 122125, level = 7,}, -- Corrosive Resin pool, the **** on the floor your not supposed to stand in.
			[GetSpellInfo(122064)] = {id = 122064, level = 7,}, -- Corrosive Resin, the dot you clear by moving/jumping.
		},
		[EJ_GetEncounterInfo(737)] = { -- Amber-Shaper Un'sok 
			[GetSpellInfo(122370)] = {id = 122370, level = 7,}, -- Reshape Life, the transformation ala putricide.
			[GetSpellInfo(122784)] = {id = 122784, level = 7,}, -- Reshape Life, Both were used.
			[GetSpellInfo(124802)] = {id = 124802, level = 7,}, -- The transformed players increase damage taken cooldown.
			[GetSpellInfo(122395)] = {id = 122395, level = 7,}, -- Struggle for Control, the self stun used to interupt the channel.
			[GetSpellInfo(122457)] = {id = 122457, level = 7,}, -- Rough Landing, The stun from being tossed and being hit by the toss from the add in Phase 2.
			[GetSpellInfo(121949)] = {id = 121949, level = 7,}, -- Parasitic Growth, the dot that scales with healing taken.
		},
		[EJ_GetEncounterInfo(743)] = { --Grand Empress Shek'zeer
			[GetSpellInfo(123788)] = {id = 123788, level = 8,}, -- 恐怖嚎叫
			[GetSpellInfo(126122)] = {id = 126122, level = 7,}, -- 腐蚀力场
			[GetSpellInfo(125390)] = {id = 125390, level = 7,}, -- 凝视
			[GetSpellInfo(124097)] = {id = 124097, level = 7,}, -- 树脂
			[GetSpellInfo(124777)] = {id = 124777, level = 7,}, -- 毒液炸弹
			[GetSpellInfo(124849)] = {id = 124849, level = 7,}, -- 吞噬恐惧
			[GetSpellInfo(124863)] = {id = 124863, level = 7,}, -- 死亡幻想 
			[GetSpellInfo(124862)] = {id = 124862, level = 7,}, -- 同上
			[GetSpellInfo(123845)] = {id = 123845, level = 8,}, -- 恐惧之心
			[GetSpellInfo(123846)] = {id = 123846, level = 8,}, -- 同上
		},
	},

	[EJ_GetInstanceInfo(320)] = { -- 永春台
		[L["Trash"]] = {
		},
		[EJ_GetEncounterInfo(683)] = { --Protectors Of the Endless		
			[GetSpellInfo(117519)] = {id = 117519, level = 7,}, -- Touch of Sha, Dot that lasts untill Kaolan is defeated.
			[GetSpellInfo(117235)] = {id = 117235, level = 7,}, -- Purified, haste buff gained by killing mist and being in range.
			[GetSpellInfo(118091)] = {id = 118091, level = 7,}, -- Defiled Ground, Increased damage taken from Defiled ground debuff.
			[GetSpellInfo(117436)] = {id = 117436, level = 9,}, -- Lightning Prison, Magic stun. 闪电牢笼
			[GetSpellInfo(118191)] = {id = 118191, level = 8,}, -- 堕落精华
		},
		[EJ_GetEncounterInfo(742)] = { --Tsulong
			[GetSpellInfo(122768)] = {id = 122768, level = 7,}, -- Dread Shadows, Stacking raid damage debuff (ragnaros superheated style) 
			[GetSpellInfo(122789)] = {id = 122789, level = 7,}, -- Sunbeam, standing in the sunbeam, used to clear dread shadows.
			[GetSpellInfo(122858)] = {id = 122858, level = 7,}, -- Bathed in Light, 500% increased healing done debuff.
			[GetSpellInfo(122752)] = {id = 122752, level = 7,}, -- Shadow Breath, increased shadow breath damage debuff.
			[GetSpellInfo(123011)] = {id = 123011, level = 7,}, -- Terrorize, Magical dot dealing % health.
			[GetSpellInfo(123036)] = {id = 123036, level = 7,}, -- Fright, 2 second fear.
			[GetSpellInfo(122777)] = {id = 122777, level = 7,}, -- Nightmares, 3 second fear.
		},
		[EJ_GetEncounterInfo(729)] = { --Lei Shi
			[GetSpellInfo(123121)] = {id = 123121, level = 7,}, -- Spray, Stacking frost damage taken debuff.
		},
		[EJ_GetEncounterInfo(709)] = { --Sha of Fear
			[GetSpellInfo(129147)] = {id = 129147, level = 7,}, -- Ominous Cackle, Debuff that sends players to the outer platforms.
			[GetSpellInfo(119086)] = {id = 119086, level = 7,}, -- Penetrating Bolt, Increased Shadow damage debuff.
			[GetSpellInfo(119775)] = {id = 119775, level = 7,}, -- Reaching Attack, Increased Shadow damage debuff.
			[GetSpellInfo(119985)] = {id = 119985, level = 7,}, -- Dread Spray, stacking magic debuff, fears at 2 stacks.
			[GetSpellInfo(119983)] = {id = 119983, level = 7,}, -- Dread Spray, is also used.
			[GetSpellInfo(119414)] = {id = 119414, level = 7,}, -- Breath of Fear, Fear+Massiv damage.
			},
	},

	[EJ_GetInstanceInfo(362)] = { -- 雷电王座
		[L["Trash"]] = {
			[GetSpellInfo(139900)] = {id = 139900, level = 7,}, --Stormcloud
			[GetSpellInfo(139550)] = {id = 139550, level = 7,}, --Torment
			[GetSpellInfo(139888)] = {id = 139888, level = 7,}, --Ancient Venom
			[GetSpellInfo(136751)] = {id = 136751, level = 7,}, --Sonic Screech
			[GetSpellInfo(136753)] = {id = 136753, level = 7,}, --Slashing Talons
			[GetSpellInfo(140686)] = {id = 140686, level = 7,}, --Corrosive Breath
			[GetSpellInfo(140682)] = {id = 140682, level = 7,}, --Chokin Mists
			[GetSpellInfo(140616)] = {id = 140616, level = 7,}, --Shale Shards
			[GetSpellInfo(139356)] = {id = 139356, level = 7,},--Extermination Beam
		},
		[EJ_GetEncounterInfo(827)] = { -- Jin'rokh the Breaker
			[GetSpellInfo(138006)] = {id = 138006, level = 7,}, --Electrified Waters
			[GetSpellInfo(138732)] = {id = 138732, level = 7,}, --Ionization
			[GetSpellInfo(138349)] = {id = 138349, level = 7,}, --Static Wound
			[GetSpellInfo(137371)] = {id = 137371, level = 7,}, --Thundering Throw
			[GetSpellInfo(137399)] = {id = 137399, level = 7,}, --Focused Lightning
			[GetSpellInfo(138733)] = {id = 138733, level = 7,}, --Ionization
		},
		[EJ_GetEncounterInfo(819)] = { --Horridon
			[GetSpellInfo(136767)] = {id = 136767, level = 7,}, --Triple Puncture
			[GetSpellInfo(136708)] = {id = 136708, level = 7,}, --Stone Gaze
			[GetSpellInfo(136719)] = {id = 136719, level = 7,}, --Blazing Sunlight
			[GetSpellInfo(136654)] = {id = 136654, level = 7,}, --Rending Charge
			[GetSpellInfo(136587)] = {id = 136587, level = 7,}, --Venom Bolt Volley
			[GetSpellInfo(136512)] = {id = 136512, level = 7,}, --Hex of Confusion
			[GetSpellInfo(140946)] = {id = 140946, level = 7,}, --Dire Fixation
			[GetSpellInfo(136769)] = {id = 136769, level = 7,}, --Charge
			[GetSpellInfo(136723)] = {id = 136723, level = 7,}, --Sand Trap
			[GetSpellInfo(136710)] = {id = 136710, level = 7,}, --Deadly Plague (disease)
			[GetSpellInfo(136670)] = {id = 136670, level = 7,}, --Mortal Strike
			[GetSpellInfo(136573)] = {id = 136573, level = 7,}, --Frozen Bolt (DebuffId used by frozen orb)		
		},
		[EJ_GetEncounterInfo(816)] = { --Council of Elders
			[GetSpellInfo(137641)] = {id = 137641, level = 7,}, --Soul Fragment
			[GetSpellInfo(137359)] = {id = 137359, level = 7,}, --Shadowed Loa Spirit Fixate
			[GetSpellInfo(137972)] = {id = 137972, level = 7,}, --Twisted Fate
			[GetSpellInfo(137650)] = {id = 137650, level = 7,}, --Shadowed Soul
			[GetSpellInfo(137085)] = {id = 137085, level = 7,}, --Chilled to the Bone
			[GetSpellInfo(136922)] = {id = 136922, level = 7,}, --Frostbite
			[GetSpellInfo(136917)] = {id = 136917, level = 7,}, --Biting Cold
			[GetSpellInfo(136903)] = {id = 136903, level = 7,}, --Frigid Assault
			[GetSpellInfo(136857)] = {id = 136857, level = 7,}, --Entrapped
			[GetSpellInfo(137891)] = {id = 137891, level = 7,}, --Twisted Fate
			[GetSpellInfo(137084)] = {id = 137084, level = 7,}, --Body Heat
			[GetSpellInfo(136878)] = {id = 136878, level = 7,}, --Ensnared
			[GetSpellInfo(136860)] = {id = 136860, level = 7,}, --Quicksand
		},
		[EJ_GetEncounterInfo(825)] = { --Tortos	
			[GetSpellInfo(136753)] = {id = 136753, level = 7,}, --Slashing Talons
			[GetSpellInfo(137633)] = {id = 137633, level = 7,}, --Crystal Shell 晶化甲壳
			[GetSpellInfo(140701)] = {id = 140701, level = 8,}, --Kick Shell
			[GetSpellInfo(134920)] = {id = 134920, level = 7,}, --Quake Stomp
			[GetSpellInfo(136751)] = {id = 136751, level = 7,}, --Sonic Screech
		},
		[EJ_GetEncounterInfo(821)] = { --Megaera
			[GetSpellInfo(137731)] = {id = 137731, level = 7,}, --Ignite Flesh
			[GetSpellInfo(139822)] = {id = 139822, level = 7,}, --Cinders
			[GetSpellInfo(139866)] = {id = 139866, level = 7,}, --Torrent of Ice
			[GetSpellInfo(139841)] = {id = 139841, level = 7,}, --Arctic Freeze
			[GetSpellInfo(134378)] = {id = 134378, level = 7,}, --Acid Rain
			[GetSpellInfo(139839)] = {id = 139839, level = 7,}, --Rot Armor
			[GetSpellInfo(140179)] = {id = 140179, level = 7,}, --Suppression
			[GetSpellInfo(139994)] = {id = 139994, level = 7,}, --Diffusion
			[GetSpellInfo(134396)] = {id = 134396, level = 7,}, --Consuming Flames (Dispell)
			[GetSpellInfo(136892)] = {id = 136892, level = 7,}, --Frozen Solid
			[GetSpellInfo(139909)] = {id = 139909, level = 7,}, --Icy Ground
			[GetSpellInfo(137746)] = {id = 137746, level = 7,}, --Consuming Magic
			[GetSpellInfo(139843)] = {id = 139843, level = 7,}, --Artic Freeze
			[GetSpellInfo(139840)] = {id = 139840, level = 7,}, --Rot Armor
		},
		[EJ_GetEncounterInfo(828)] = { --Ji-Kun
			[GetSpellInfo(138309)] = {id = 138309, level = 7,}, --Slimed
			[GetSpellInfo(140092)] = {id = 140092, level = 7,}, --Infected Talons
			[GetSpellInfo(134256)] = {id = 134256, level = 7,}, --Slimed
			[GetSpellInfo(138319)] = {id = 138319, level = 7,}, --Feed Pool
			[GetSpellInfo(134366)] = {id = 134366, level = 7,}, --Talon Rake
			[GetSpellInfo(140014)] = {id = 140014, level = 7,}, --Daedelian Wings
			[GetSpellInfo(140571)] = {id = 140571, level = 7,}, --Feed Pool
			[GetSpellInfo(134372)] = {id = 134372, level = 7,}, --Screech
		},
		[EJ_GetEncounterInfo(818)] = { --Durumu the Forgotten
			[GetSpellInfo(133767)] = {id = 133767, level = 7,}, --Serious Wound
			[GetSpellInfo(133768)] = {id = 133768, level = 7,}, --Arterial Cut
			[GetSpellInfo(134755)] = {id = 134755, level = 7,}, --Eye Sore
			[GetSpellInfo(136413)] = {id = 136413, level = 7,}, --Force of Will
			[GetSpellInfo(133795)] = {id = 133795, level = 7,}, --Life Drain
			[GetSpellInfo(133597)] = {id = 133597, level = 7,}, --Dark Parasite
			[GetSpellInfo(133598)] = {id = 133598, level = 7,}, --Dark Plague
			[GetSpellInfo(134007)] = {id = 134007, level = 7,}, --Devour
			[GetSpellInfo(136932)] = {id = 136932, level = 7,}, --Force of Will
			[GetSpellInfo(134122)] = {id = 134122, level = 7,}, --Blue Beam
			[GetSpellInfo(134123)] = {id = 134123, level = 7,}, --Red Beam
			[GetSpellInfo(134124)] = {id = 134124, level = 7,}, --Yellow Beam
			[GetSpellInfo(133732)] = {id = 133732, level = 7,}, --Infrared Light (the stacking red debuff)
			[GetSpellInfo(133677)] = {id = 133677, level = 7,}, --Blue Rays (the stacking blue debuff)  
			[GetSpellInfo(133738)] = {id = 133738, level = 7,}, --Bright Light (the stacking yellow debuff)
			[GetSpellInfo(133737)] = {id = 133737, level = 7,}, --Bright Light (The one that says you are actually in a beam)
			[GetSpellInfo(133675)] = {id = 133675, level = 7,}, --Blue Rays (The one that says you are actually in a beam)
			[GetSpellInfo(134626)] = {id = 134626, level = 7,}, --Lingering Gaze
		},
		[EJ_GetEncounterInfo(820)] = { --Primordius
			[GetSpellInfo(136050)] = {id = 136050, level = 7,}, --Malformed Blood
			[GetSpellInfo(140546)] = {id = 140546, level = 7,}, --Fully Mutated
			[GetSpellInfo(137000)] = {id = 137000, level = 7,}, --Black Blood
			[GetSpellInfo(136180)] = {id = 136180, level = 7,}, --Keen Eyesight (Helpful)
			[GetSpellInfo(136181)] = {id = 136181, level = 7,}, --Impared Eyesight (Harmful)
			[GetSpellInfo(136182)] = {id = 136182, level = 7,}, --Improved Synapses (Helpful)
			[GetSpellInfo(136183)] = {id = 136183, level = 7,}, --Dulled Synapses (Harmful)
			[GetSpellInfo(136184)] = {id = 136184, level = 7,}, --Thick Bones (Helpful)
			[GetSpellInfo(136185)] = {id = 136185, level = 7,}, --Fragile Bones (Harmful)
			[GetSpellInfo(136186)] = {id = 136186, level = 7,}, --Clear Mind (Helpful)
			[GetSpellInfo(136187)] = {id = 136187, level = 7,}, --Clouded Mind (Harmful)
			[GetSpellInfo(136228)] = {id = 136228, level = 7,}, --Volatile Pathogen
		},
		[EJ_GetEncounterInfo(824)] = { --Dark Animus
			[GetSpellInfo(138569)] = {id = 138569, level = 7,}, --Explosive Slam
			[GetSpellInfo(138609)] = {id = 138609, level = 7,}, --Matter Swap
			[GetSpellInfo(138659)] = {id = 138659, level = 7,}, --Touch of the Animus
			[GetSpellInfo(136954)] = {id = 136954, level = 7,}, --Anima Ring
			[GetSpellInfo(138691)] = {id = 138691, level = 7,}, --Anima Font
			[GetSpellInfo(136962)] = {id = 136962, level = 7,}, --Anima Ring
			[GetSpellInfo(138480)] = {id = 138480, level = 7,}, --Crimson Wake Fixate
		},
		[EJ_GetEncounterInfo(817)] = { --Iron Qon
			[GetSpellInfo(134691)] = {id = 134691, level = 7,}, --Impale
			[GetSpellInfo(134647)] = {id = 134647, level = 7,}, --Scorched
			[GetSpellInfo(136193)] = {id = 136193, level = 7,}, --Arcing Lightning
			[GetSpellInfo(135145)] = {id = 135145, level = 7,}, --Freeze
			[GetSpellInfo(135147)] = {id = 135147, level = 7,}, --Dead Zone
			[GetSpellInfo(136520)] = {id = 136520, level = 7,}, --Frozen Blood
			[GetSpellInfo(137669)] = {id = 137669, level = 7,}, --Storm Cloud
			[GetSpellInfo(137668)] = {id = 137668, level = 7,}, --Burning Cinders
			[GetSpellInfo(137654)] = {id = 137654, level = 7,}, --Rushing Winds 
			[GetSpellInfo(136577)] = {id = 136577, level = 7,}, --Wind Storm
			[GetSpellInfo(136192)] = {id = 136192, level = 7,}, --Lightning Storm
			[GetSpellInfo(136615)] = {id = 136615, level = 7,}, --Electrified
		},
		[EJ_GetEncounterInfo(829)] = { --Twin Consorts
			[GetSpellInfo(137440)] = {id = 137440, level = 7,}, --Icy Shadows
			[GetSpellInfo(137408)] = {id = 137408, level = 7,}, --Fan of Flames
			[GetSpellInfo(137360)] = {id = 137360, level = 7,}, --Corrupted Healing
			[GetSpellInfo(137341)] = {id = 137341, level = 7,}, --Beast of Nightmares
			[GetSpellInfo(137417)] = {id = 137417, level = 7,},--Flames of Passion
			[GetSpellInfo(138306)] = {id = 138306, level = 7,}, --Serpent's Vitality
			[GetSpellInfo(137375)] = {id = 137375, level = 7,},--Beast of Nightmares
			[GetSpellInfo(136722)] = {id = 136722, level = 7,},--Slumber Spores
		},
		[EJ_GetEncounterInfo(832)] = { --Lei Shen
			[GetSpellInfo(135000)] = {id = 135000, level = 7,}, --Decapitate
			[GetSpellInfo(134916)] = {id = 134916, level = 7,}, --Decapitate
			[GetSpellInfo(135150)] = {id = 135150, level = 7,}, --Crashing Thunder
			[GetSpellInfo(139011)] = {id = 139011, level = 7,}, --Helm of Command
			[GetSpellInfo(136478)] = {id = 136478, level = 7,}, --Fusion Slash
			[GetSpellInfo(136853)] = {id = 136853, level = 7,}, --Lightning Bolt
			[GetSpellInfo(135695)] = {id = 135695, level = 7,}, --Static Shock
			[GetSpellInfo(136295)] = {id = 136295, level = 7,}, --Overcharged
			[GetSpellInfo(136543)] = {id = 136543, level = 7,}, --Ball Lightning
			[GetSpellInfo(134821)] = {id = 134821, level = 7,}, --Discharged Energy
			[GetSpellInfo(136326)] = {id = 136326, level = 7,}, --Overcharge
			[GetSpellInfo(137176)] = {id = 137176, level = 7,}, --Overloaded Circuits
			[GetSpellInfo(135153)] = {id = 135153, level = 7,}, --Crashing Thunder
			[GetSpellInfo(136914)] = {id = 136914, level = 7,}, --Electrical Shock
			[GetSpellInfo(135001)] = {id = 135001, level = 7,}, --Maim
		},
		[EJ_GetEncounterInfo(831)] = { --Ra-den
		},
	},
}

local Account_default_Settings = {
	meet = false,
	gold = {},
	goldkeywordlist = "",
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
		healerraidwidth = 66,
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
		goldkeywordnum = 2,
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
		micromenuscale = 1,
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
	RaidDebuff = DebuffList
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