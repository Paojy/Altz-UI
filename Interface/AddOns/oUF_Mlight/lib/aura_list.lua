local addon, ns = ...

local spellcache = setmetatable({}, {__index=function(t,v) local a = {GetSpellInfo(v)} if GetSpellInfo(v) then t[v] = a end return a end})
local function GetSpellInfo(a)
    return unpack(spellcache[a])
end

ns.auras = {
    -- Ascending aura timer
    -- Add spells to this list to have the aura time count up from 0
    -- NOTE: This does not show the aura, it needs to be in one of the other list too.
    ascending = {
        --[GetSpellInfo(92956)] = true, -- Wrack
    },

    -- Any Zone
    debuffs = {
		--[GetSpellInfo(2812)] = 16, -- TEST 谴责
        --[GetSpellInfo(6788)] = 16, -- Weakened Soul TEST
    },

    buffs = { -- these display on the second icon
		--[GetSpellInfo(139)] = 15, -- Renew TEST
	--牧师
		[GetSpellInfo(33206)] = 15, -- 痛苦压制
        [GetSpellInfo(47788)] = 15, -- 守护之魂
	--小德
        [GetSpellInfo(102342)] = 15, -- 铁木树皮
		[GetSpellInfo(22812)] = 15, -- 树皮术
		[GetSpellInfo(61336)] = 15, -- 生存本能
		[GetSpellInfo(105737)] = 15, -- 乌索克之力
		[GetSpellInfo(22842)] = 14, -- 狂暴回复
	--骑士
		[GetSpellInfo(1022)] = 15, -- 保护之手
		[GetSpellInfo(31850)] = 15, -- 炽热防御者
        [GetSpellInfo(498)] = 15, -- 圣佑术
		[GetSpellInfo(642)] = 15, -- 圣盾术
		[GetSpellInfo(86659)] = 15, -- 远古列王守卫
	--武僧
		[GetSpellInfo(116849)] = 15, -- 作茧缚命
		[GetSpellInfo(115203)] = 15, -- 壮胆酒
        --[GetSpellInfo(115308)] = 14, -- 飘渺酒		
	--DK
        [GetSpellInfo(50397)] = 15, -- 巫妖之躯
		[GetSpellInfo(48707)] = 15, -- 反魔法护罩
		[GetSpellInfo(48792)] = 15, -- 冰封之韧
		[GetSpellInfo(49222)] = 14, -- 白骨之盾
		[GetSpellInfo(49028)] = 14, -- 符文刃舞
		[GetSpellInfo(55233)] = 15, -- 符文刃舞
	--战士
        [GetSpellInfo(112048)] = 14, -- 盾牌屏障
		[GetSpellInfo(12975)] = 15, -- 破釜沉舟
		[GetSpellInfo(871)] = 15, -- 盾墙
	--魔古山三号进场BUFF
		[GetSpellInfo(120717)] = 14, -- 复苏之魂
    },

    -- Raid Debuffs
    instances = {
        --["MapID"] = {
        --	[Name or GetSpellInfo(spellID) or SpellID] = PRIORITY,
        --},
		
		-- GetCurrentMapAreaID() or http://www.wowpedia.org/MapID

        [875] = { --[[Gate of the Setting Sun 残阳关 ]]--

            -- Raigonn 莱公
            [GetSpellInfo(111644)] = 7, -- Screeching Swarm 111640 111643
        },

		[885] = { --[[Mogu'shan Palace 魔古山神殿 ]]--

            -- Trial of the King 国王的试炼
            [GetSpellInfo(119946)] = 7, -- Ravage
			-- Xin the Weaponmaster <King of the Clans> 武器大师席恩
			[GetSpellInfo(119684)] = 7, --Ground Slam
        },
		
		[871] = { --[[Scarlet Halls 血色大厅 ]]--

            -- Houndmaster Braun <PH Dressing>
            [GetSpellInfo(114056)] = 7, -- Bloody Mess
			-- Flameweaver Koegler
			[GetSpellInfo(113653)] = 7, -- Greater Dragon's Breath
			[GetSpellInfo(11366)] = 6,-- Pyroblast		
        },
		
		[874] = { --[[Scarlet Monastery 血色修道院 ]]--

            -- Thalnos the Soulrender
            [GetSpellInfo(115144)] = 7, -- Mind Rot
			[GetSpellInfo(115297)] = 6, -- Evict Soul
        },
		
		[763] = { --[[Scholomance 通灵学院 ]]--

            -- Instructor Chillheart
            [GetSpellInfo(111631)] = 7, -- Wrack Soul
			-- Lilian Voss
            [GetSpellInfo(111585)] = 7, -- Dark Blaze
			-- Darkmaster Gandling
			[GetSpellInfo(108686)] = 7, -- Immolate
        },
				
		[877] = { --[[Shado-Pan Monastery 影踪禅院 ]]--

            -- Sha of Violence
            [GetSpellInfo(106872)] = 7, -- Disorienting Smash
			-- Taran Zhu <Lord of the Shado-Pan>
            [GetSpellInfo(112932)] = 7, -- Ring of Malice
        },
		
		[887] = { --[[Siege of Niuzao Temple 围攻砮皂寺 ]]--

            -- Wing Leader Ner'onok 
            [GetSpellInfo(121447)] = 7, -- Quick-Dry Resin
        },
		
		[867] = { --[[Temple of the Jade Serpent 青龙寺 ]]--

            -- Wise Mari <Waterspeaker>
            [GetSpellInfo(106653)] = 7, -- Sha Residue
			-- Lorewalker Stonestep <The Keeper of Scrolls>
			[GetSpellInfo(106653)] = 7, -- Agony
			-- Liu Flameheart <Priestess of the Jade Serpent>
			[GetSpellInfo(106823)] = 7, -- Serpent Strike
			-- Sha of Doubt
			[GetSpellInfo(106113)] = 7, --Touch of Nothingness
        },
		
		[896] = { --[[Mogu'shan Vaults 魔古山宝库 ]]--
			-- The Stone Guard
			[GetSpellInfo(116281)] = 7, -- Cobalt Mine Blast, Magic root

			--Feng the Accursed
			[GetSpellInfo(116040)] = 7, -- Epicenter, roomwide aoe.
			[GetSpellInfo(116784)] = 7, -- Wildfire Spark, Debuff that explodes leaving fire on the ground after 5 sec.
			[GetSpellInfo(116374)] = 7, -- Lightning Charge, Stun debuff.
			[GetSpellInfo(116417)] = 7, -- Arcane Resonance, aoe-people-around-you-debuff.
			[GetSpellInfo(116942)] = 7, -- Flaming Spear, fire damage dot.

			-- Gara'jal the Spiritbinder
			[GetSpellInfo(122151)] = 7,	-- Voodoo Doll, shared damage with the tank.
			[GetSpellInfo(116161)] = 7,	-- Crossed Over, people in the spirit world.

			-- The Spirit Kings
			[GetSpellInfo(117708)] = 7, -- Meddening Shout, The mind control debuff.
			[GetSpellInfo(118303)] = 7, -- Fixate, the once targeted by the shadows.
			[GetSpellInfo(118048)] = 7, -- Pillaged, the healing/Armor/damage debuff.
			[GetSpellInfo(118135)] = 7, -- Pinned Down, Najentus spine 2.0
			[GetSpellInfo(118163)] = 7, -- 巧取豪夺

			--Elegon
			[GetSpellInfo(117878)] = 7, -- Overcharged, the stacking increased damage taken debuff.	
			[GetSpellInfo(117870)] = 7, -- Touch of the Titans, the debuff everybody gets increasing damage done and healing taken.
			[GetSpellInfo(117949)] = 7, -- Closed Circuit, Magic Healing debuff.
			[GetSpellInfo(132222)] = 7, -- 不稳定能量

			--Will of the Emperor
			[GetSpellInfo(116969)] = 7, -- Stomp, Stun from the bosses.
			[GetSpellInfo(116835)] = 7, -- Devestating Arc, Armor debuff from the boss.
			[GetSpellInfo(116778)] = 7, -- Focused Defense, Fixate from the Emperors Courage.
			[GetSpellInfo(117485)] = 7, -- Impending Thrust, Stacking slow from the Emperors Courage.
			[GetSpellInfo(116525)] = 7, -- Focused Assault, Fixate from the Emperors Rage
			[GetSpellInfo(116550)] = 7, -- Energizing Smash, Knockdown from the Emperors Strength
		},
		
		[897] = { --[[Heart of Fear 恐惧之心 ]]--
			-- Imperial Vizier Zor'lok
			[GetSpellInfo(122761)] = 7, -- Exhale, The person targeted for Exhale. 
			[GetSpellInfo(123812)] = 7, -- Pheromones of Zeal, the gas in the middle of the room.
			[GetSpellInfo(122706)] = 7, -- Noise Cancelling, The "safe zone" from the roomwide aoe.
			[GetSpellInfo(122740)] = 7, -- Convert, The mindcontrol Debuff.

			-- Blade Lord Ta'yak
			[GetSpellInfo(123180)] = 7, -- Wind Step, Bleeding Debuff from stealth.
			[GetSpellInfo(123474)] = 7, -- Overwhelming Assault, stacking tank swap debuff. 

			-- Garalon
			[GetSpellInfo(122774)] = 7, -- Crush, stun from the crush ability.
			[GetSpellInfo(123426)] = 7, -- Weak Points, Increased damage done to one leg.
			[GetSpellInfo(123428)] = 7, -- Weak Points, Increased damage to another leg.
			[GetSpellInfo(123423)] = 7, -- Weak Points, Increased damage to another leg.
			[GetSpellInfo(123235)] = 7, -- Weak Points, Increased damage to another leg.
			[GetSpellInfo(122835)] = 7, -- Pheromones, The buff indicating who is carrying the pheramone.
			[GetSpellInfo(123081)] = 7, -- Punchency, The stacking debuff causing the raid damage.

			--Wind Lord Mel'jarak
			[GetSpellInfo(122055)] = 7, -- Residue, The debuff after breaking a prsion preventing further breaking.
			[GetSpellInfo(121885)] = 7, -- Amber Prison, The stun that somebody has to click off.
			[GetSpellInfo(121881)] = 7, -- Amber Prison, not sure what the differance is but both were used.
			[GetSpellInfo(122125)] = 7, -- Corrosive Resin pool, the **** on the floor your not supposed to stand in.
			[GetSpellInfo(122064)] = 7, -- Corrosive Resin, the dot you clear by moving/jumping.

			-- Amber-Shaper Un'sok 
			[GetSpellInfo(122370)] = 7, -- Reshape Life, the transformation ala putricide.
			[GetSpellInfo(122784)] = 7, -- Reshape Life, Both were used.
			[GetSpellInfo(124802)] = 7, -- The transformed players increase damage taken cooldown.
			[GetSpellInfo(122395)] = 7, -- Struggle for Control, the self stun used to interupt the channel.
			[GetSpellInfo(122457)] = 7, -- Rough Landing, The stun from being tossed and being hit by the toss from the add in Phase 2.
			[GetSpellInfo(121949)] = 7, -- Parasitic Growth, the dot that scales with healing taken.
			[GetSpellInfo(124802)] = 9, -- 易伤
			
			-- 女王
			[GetSpellInfo(123788)] = 7, -- 恐怖嚎叫
		},
		
		[886] = { --[[Terrace of Endless Spring 永春台 ]]--
			--Protectors Of the Endless
			[GetSpellInfo(117519)] = 7, -- Touch of Sha, Dot that lasts untill Kaolan is defeated.
			[GetSpellInfo(117235)] = 7, -- Purified, haste buff gained by killing mist and being in range.
			[GetSpellInfo(117353)] = 7, -- Overwhelming Corruption, stacking raidwide softenrage debuff.
			[GetSpellInfo(118091)] = 7, -- Defiled Ground, Increased damage taken from Defiled ground debuff.
			[GetSpellInfo(117436)] = 7, -- Lightning Prison, Magic stun.

			--Tsulong
			[GetSpellInfo(122768)] = 7, -- Dread Shadows, Stacking raid damage debuff (ragnaros superheated style) 
			[GetSpellInfo(122789)] = 7, -- Sunbeam, standing in the sunbeam, used to clear dread shadows.
			[GetSpellInfo(122858)] = 7, -- Bathed in Light, 500% increased healing done debuff.
			[GetSpellInfo(122752)] = 7, -- Shadow Breath, increased shadow breath damage debuff.
			[GetSpellInfo(123011)] = 7, -- Terrorize, Magical dot dealing % health.
			[GetSpellInfo(123036)] = 7, -- Fright, 2 second fear.
			[GetSpellInfo(122777)] = 7, -- Nightmares, 3 second fear.

			--Lei Shi
			[GetSpellInfo(123121)] = 7, -- Spray, Stacking frost damage taken debuff.

			--Sha of Fear
			[GetSpellInfo(129147)] = 7, -- Ominous Cackle, Debuff that sends players to the outer platforms.
			[GetSpellInfo(119086)] = 7, -- Penetrating Bolt, Increased Shadow damage debuff.
			[GetSpellInfo(119775)] = 7, -- Reaching Attack, Increased Shadow damage debuff.
			[GetSpellInfo(119985)] = 7, -- Dread Spray, stacking magic debuff, fears at 2 stacks.
			[GetSpellInfo(119983)] = 7, -- Dread Spray, is also used.
			[GetSpellInfo(119414)] = 7, -- Breath of Fear, Fear+Massiv damage.
		},
		
		[824] = { --[[ Dragon Soul 巨龙之魂 ]]--
			-- Morchok
			[GetSpellInfo(103687)] = 7, -- Crush Armor
			-- Warlord Zon'ozz
			[GetSpellInfo(103434)] = 8, -- Disrupting Shadows
			-- some shit boss with blobs
			[GetSpellInfo(104849)] = 8, -- Void Bolt
			[109389] = 12, 				-- Deep Corruption stacks (108220)
			[103628] = 12,				-- Deep Corruption stacks
			-- Hagara the Stormbinder
			[GetSpellInfo(109325)] = 7, -- Frostflake, HC
			[GetSpellInfo(104451)] = 7, -- Ice Tomb
			--[GetSpellInfo(105313)] = 7, -- Ice Lance
			[GetSpellInfo(105289)] = 7, -- Shattered Ice
			-- Blackhorn
			-- Ultraxion
			[GetSpellInfo(109075)] = 8, -- Fading Light
			-- Spine of Deathwing
			[GetSpellInfo(106199)] = 1, -- Blood Corruption: Death
			[GetSpellInfo(106200)] = 7, -- Blood Corruption: Earth
			[GetSpellInfo(105563)] = 2, -- Grasping Tendrils
			[GetSpellInfo(109379)] = 3, -- Searing Plasma
			[GetSpellInfo(105490)] = 8, -- Fiery Grip
			-- Madness
			[GetSpellInfo(108649)] = 7,  -- Corrupting Parasite			
			--[GetSpellInfo(105841)] = 7,  -- Degenerative Bite
			--[GetSpellInfo(105445)] = 8,  -- Blistering Heat
			[GetSpellInfo(106444)] = 9,  -- Impale
		},
    },
}