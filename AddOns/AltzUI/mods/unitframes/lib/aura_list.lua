local T, C, L, G = unpack(select(2, ...))
local oUF = AltzUF or oUF

local spellcache = setmetatable({}, {__index=function(t,v) local a = {GetSpellInfo(v)} if GetSpellInfo(v) then t[v] = a end return a end})
local function GetSpellInfo(a)
    return unpack(spellcache[a])
end

G.auras = {
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
		[GetSpellInfo(117309)] = 15, -- 净化之水
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
}