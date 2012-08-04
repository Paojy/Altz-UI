local ADDON_NAME, ns = ...
local cfg = ns.cfg

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
    },

    -- Raid Debuffs
    instances = {
        --["MapID"] = {
        --	[Name or GetSpellInfo(spellID) or SpellID] = PRIORITY,
        --},
		
		--GetCurrentMapAreaID()

        [1] = { --[[Gate of the Setting Sun 残阳关 ]]--

            -- Raigonn 莱公
            [GetSpellInfo(111644)] = 7, -- Screeching Swarm 111640 111643
        },

		[1] = { --[[Mogu'shan Palace 魔古山神殿 ]]--

            -- Trial of the King 国王的试炼
            [GetSpellInfo(119946)] = 7, -- Ravage
			-- Xin the Weaponmaster <King of the Clans> 武器大师席恩
			[GetSpellInfo(119684)] = 7, --Ground Slam
        },
		
		[1] = { --[[Scarlet Halls 血色大厅 ]]--

            -- Houndmaster Braun <PH Dressing>
            [GetSpellInfo(114056)] = 7, -- Bloody Mess
			-- Flameweaver Koegler
			[GetSpellInfo(113653)] = 7, -- Greater Dragon's Breath
			[GetSpellInfo(11366)] = 6,-- Pyroblast		
        },
		
		[1] = { --[[Scarlet Monastery 血色修道院 ]]--

            -- Thalnos the Soulrender
            [GetSpellInfo(115144)] = 7, -- Mind Rot
			[GetSpellInfo(115297)] = 6, -- Evict Soul
        },
		
		[1] = { --[[Scholomance 通灵学院 ]]--

            -- Instructor Chillheart
            [GetSpellInfo(111631)] = 7, -- Wrack Soul
			-- Lilian Voss
            [GetSpellInfo(111585)] = 7, -- Dark Blaze
			-- Darkmaster Gandling
			[GetSpellInfo(108686)] = 7, -- Immolate
        },
				
		[1] = { --[[Shado-Pan Monastery 影踪禅院 ]]--

            -- Sha of Violence
            [GetSpellInfo(106872)] = 7, -- Disorienting Smash
			-- Taran Zhu <Lord of the Shado-Pan>
            [GetSpellInfo(112932)] = 7, -- Ring of Malice
        },
		
		[1] = { --[[Siege of Niuzao Temple 围攻砮皂寺 ]]--

            -- Wing Leader Ner'onok 
            [GetSpellInfo(121447)] = 7, -- Quick-Dry Resin
        },
		
		[1] = { --[[Temple of the Jade Serpent 青龙寺 ]]--

            -- Wise Mari <Waterspeaker>
            [GetSpellInfo(106653)] = 7, -- Sha Residue
			-- Lorewalker Stonestep <The Keeper of Scrolls>
			[GetSpellInfo(106653)] = 7, -- Agony
			-- Liu Flameheart <Priestess of the Jade Serpent>
			[GetSpellInfo(106823)] = 7, -- Serpent Strike
			-- Sha of Doubt
			[GetSpellInfo(106113)] = 7, --Touch of Nothingness
        },
		
		[1] = { --[[Heart of Fear 恐惧之心 ]]--
		    -- Imperial Vizier Zor'lok
			-- Blade Lord Ta'yak
			-- Garalon
			-- Wind Lord Mel'jarak
			-- Amber-Shaper Un'sok
			-- Grand Empress Shek'zeer
        },
		
		[1] = { --[[Mogu'shan Vaults 魔古山宝库 ]]--
		    -- The Stone Guard
			-- Feng the Accursed
			-- Gara'jal the Spiritbinder
			-- The Spirit Kings
			-- Elegon
			-- Will of the Emperor 
        },
		
		[1] = { --[[Terrace of Endless Spring 永春台 ]]--
		    -- Protectors of the Endless
			-- Sha of Anger
			[GetSpellInfo(119487)] = 7, --Seethe
			-- Salyis's Warband
			[GetSpellInfo(34716)] = 7, -- Stomp
			-- Tsulong
			-- Lei Shi
			-- Sha of Fear
        },

    },
}