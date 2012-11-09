-- LightCT by Alza
-- xCT by Dandruff
local T, C, L, G = unpack(select(2, ...))
local dragFrameList = G.dragFrameList

if not aCoreCDB.combattext then return end

local showreceived = aCoreCDB.showreceivedct
local showoutput = aCoreCDB.showoutputct
local fliter = aCoreCDB.ctfliter
local iconsize = aCoreCDB.cticonsize
local bigiconsize = aCoreCDB.ctbigiconsize
local showdots = aCoreCDB.ctshowdots
local showhots = aCoreCDB.ctshowhots
local fadetime = aCoreCDB.ctfadetime

local frames = {}
local healfilter = {}
local aoefilter = {}

local dmgcolor = {}
dmgcolor[1]  = {  1,  1,  0 }  -- physical
dmgcolor[2]  = {  1, .9, .5 }  -- holy
dmgcolor[4]  = {  1, .5,  0 }  -- fire
dmgcolor[8]  = { .3,  1, .3 }  -- nature
dmgcolor[16] = { .5,  1,  1 }  -- frost
dmgcolor[32] = { .5, .5,  1 }  -- shadow
dmgcolor[64] = {  1, .5,  1 }  -- arcane

local eventframe = CreateFrame"Frame"
eventframe:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

--[[  Class Specific Filter Assignment  ]]
if showoutput then
	if G.myClass == "WARLOCK" then
		aoefilter[27243] = true  -- Seed of Corruption (DoT) 腐蚀之种
		aoefilter[27285] = true  -- Seed of Corruption (Explosion) 腐蚀之种
		aoefilter[87385] = true  -- Seed of Corruption (Explosion Soulburned) 腐蚀之种
		aoefilter[42223] = true  -- Rain of Fire 火焰之雨
		aoefilter[5857]  = true  -- Hellfire Effect 地狱烈焰
		aoefilter[47897] = true  -- Shadowflame (shadow direct damage) 古尔丹之息
		aoefilter[47960] = true  -- Shadowflame (fire dot) 古尔丹之息
		aoefilter[50590] = true  -- Immolation Aura 献祭光环
		aoefilter[30213] = true  -- Legion Strike (Felguard) 军团打击
		aoefilter[89753] = true  -- Felstorm (Felguard) 魔刃风暴
		aoefilter[20153] = true  -- Immolation (Infrenal) 献祭
		--[[ healing spells ]]--
		healfilter[63106] = true  -- Siphon Life 生命虹吸
		healfilter[54181] = true  -- Fel Synergy 邪能共效
		healfilter[89653] = true  -- Drain Life 吸取生命
	elseif G.myClass == "DRUID" then
		aoefilter[42231] = true  -- Hurricane 飓风
		aoefilter[50288] = true  -- Starfall 星辰坠落
		aoefilter[78777] = true  -- Wild Mushroom 野性蘑菇：引爆
		aoefilter[61391] = true  -- Typhoon 台风
		aoefilter[62078] = true  -- Swipe (Cat Form) 横扫
		aoefilter[779]   = true  -- Swipe (Bear Form) 横扫
		--[[ healing spells ]]--
		aoefilter[44203] = true  -- Tranquility 宁静
		--aoefilter[81269] = true  -- Efflorescence 迅捷治愈
	elseif G.myClass == "PALADIN" then
		aoefilter[81297] = true  -- Consecration 奉献
		aoefilter[53385] = true  -- Divine Storm 神圣风暴
		aoefilter[42463] = true  -- Seal of Truth 真理圣印
		aoefilter[101423] = true -- Seal of Righteousness (Thanks Shestak) 正义圣印
		--[[ healing spells ]]--
		aoefilter[85222] = true  -- Light of Dawn 黎明圣光
		aoefilter[82327] = true  -- Holy Radiance   (Thanks Nidra) 圣光普照
	elseif G.myClass == "PRIEST" then
		aoefilter[49821] = true  -- Mind Seer 精神灼烧
		aoefilter[87532] = true  -- Shadowy Apparition 暗影幻灵
		aoefilter[15237] = true  -- Holy Nova (Damage Effect) 神圣新星
		--[[ healing spells ]]--
		aoefilter[596]  = true  -- Prayer of Healing 治疗祷言
		aoefilter[56161]= true  -- Glyph of Prayer of Healing 治疗祷言
		aoefilter[64844]= true  -- Divine Hymn 神圣赞美诗
		aoefilter[32546]= true  -- Binding Heal 联接治疗
		aoefilter[77489]= true  -- Echo of Light 圣光回响
		aoefilter[34861]= true  -- Circle of Healing 治疗之环
		aoefilter[23455]= true  -- Holy Nova (Healing Effect) 神圣新星
		aoefilter[88686]= true  -- Holy Word: Sanctuary 圣言术：佑
		--[[ healing spells ]]--
		healfilter[15290] = true  -- Vampiric Embrace 吸血鬼拥抱
	elseif G.myClass == "SHAMAN" then
		aoefilter[421]   = true  -- Chain Lightning 闪电链
		aoefilter[8349]  = true  -- Fire Nova 火焰新星
		aoefilter[77478] = true  -- Earhquake 地震术
		aoefilter[51490] = true  -- Thunderstorm 雷霆风暴
		aoefilter[8187]  = true  -- Magma Totem 熔岩图腾
		--aoefilter[8050]  = true	-- Flame Shock (Thanks Shestak) 烈焰震击
		aoefilter[25504] = true  -- Windfury (Thanks NitZo) 风怒攻击
		--[[ healing spells ]]--
		aoefilter[73921] = true  -- Healing Rain 治疗之雨
		aoefilter[1064]  = true  -- Chain Heal 治疗链
		aoefilter[52042] = true  -- Healing Stream Totem 治疗之泉图腾
	elseif G.myClass == "MAGE" then
		aoefilter[44461] = true  -- Living Bomb Explosion 活体炸弹
		aoefilter[44457] = true  -- Living Bomb Dot 活体炸弹
		aoefilter[2120]  = true  -- Flamestrike 烈焰风暴
		aoefilter[31661] = true  -- Dragon's Breath 龙息术
		aoefilter[42208] = true  -- Blizzard 暴风雪
		aoefilter[122]   = true  -- Frost Nova 冰霜新星
		aoefilter[1449]  = true  -- Arcane Explosion 魔爆术
		aoefilter[11113] = true  -- Blast Wave   (Thanks Shestak) 冲击波
		aoefilter[83619] = true  -- Fire Power   (Thanks Shestak) 烈焰宝珠
		aoefilter[120]   = true  -- Cone of Cold (Thanks Shestak) 冰锥术
	elseif G.myClass == "WARRIOR" then
		aoefilter[845]   = true  -- Cleave 顺劈斩
		aoefilter[46968] = true  -- Shockwave 震荡波
		aoefilter[6343]  = true  -- Thunder Clap 雷霆一击
		aoefilter[1680]  = true  -- Whirlwind 旋风斩
		aoefilter[50622] = true  -- Bladestorm 剑刃风暴
		aoefilter[52174] = true  -- Heroic Leap 英勇飞跃
		--[[ healing spells ]]--
		healfilter[55694] = true  -- Enraged Regeneration 狂怒回复
	elseif G.myClass == "HUNTER" then
		aoefilter[2643]  = true  -- Multi-Shot 多重射击
		--aoefilter[83077] = true  -- Serpent Sting (Instant Serpent Spread) (Thanks Naughtia) 毒蛇钉刺
		--aoefilter[1978]  = true  -- Serpent Sting  (Thanks Naughtia) 毒蛇钉刺
		aoefilter[13812] = true  -- Explosive Trap 爆炸陷阱
		--aoefilter[53301] = true  -- Explosive Shot (3 ticks merged as one) 爆炸射击
		--aoefilter[63468] = true  -- Piercing Shots 穿刺射击
	elseif G.myClass == "DEATHKNIGHT" then
		aoefilter[55095] = true  -- Frost Fever 冰霜疫病
		aoefilter[55078] = true  -- Blood Plague 血之疫病
		aoefilter[48721] = true  -- Blood Boil 血液沸腾
		aoefilter[49184] = true  -- Howling Blast 凛风冲击
		aoefilter[52212] = true  -- Death and Decay 死亡凋零
		-- Merging MainHand/OffHand Strikes (by Bozo)(Thanks Shestak)
		aoefilter[55050] = true  --  Heart Strike (Thanks Shestak) 心脏打击
	elseif G.myClass == "ROGUE" then
		aoefilter[51723] = true  -- Fan of Knives 刀扇
	elseif G.myClass == "MONK" then
		aoefilter[107270] = true  -- 神鹤引项踢 伤害
		aoefilter[117418] = true  -- 愤怒之拳
		aoefilter[115181] = true  -- 火焰之息
		aoefilter[125033] = true  -- 禅意珠 爆炸 伤害
		aoefilter[130651] = true  -- 真气爆裂 伤害
		aoefilter[116847] = true  -- 碧玉疾风 伤害
		aoefilter[117993] = true  -- 真气突 伤害
		--aoefilter[121253] = true  -- 醉酿投
		
		aoefilter[117640] = true  -- 神鹤引项踢 治疗
		aoefilter[115310] = true  -- 还魂术
		aoefilter[116670] = true  -- 引魂阵
		aoefilter[124101] = true  -- 禅意珠 爆炸 治疗
		aoefilter[130654] = true  -- 真气爆裂 治疗
		aoefilter[126890] = true  -- 碧玉疾风 治疗
		aoefilter[124040] = true  -- 真气突 治疗
	end
end

local GetSpellTextureFormatted = function(spellID, iconSize)
	local msg = ""
	if spellID == PET_ATTACK_TEXTURE then
		msg = " \124T"..PET_ATTACK_TEXTURE..":"..iconSize..":"..iconSize..":0:0:64:64:5:59:5:59\124t"
	else
		local icon = GetSpellTexture(spellID)
		if icon then
			msg = " \124T"..icon..":"..iconSize..":"..iconSize..":0:0:64:64:5:59:5:59\124t"
		else
			msg = " \124T"..ct.blank..":"..iconSize..":"..iconSize..":0:0:64:64:5:59:5:59\124t"
		end
	end
	return msg
end

local function CreateCTFrame(i, movingname, justify, ...)
	local f = CreateFrame("ScrollingMessageFrame", "Combat Text"..i, UIParent)
	
	f:SetFont("Interface\\AddOns\\AltzUI\\media\\number.ttf", 12, "OUTLINE")
	f:SetShadowColor(0, 0, 0, 0)
	f:SetFadeDuration(0.2)
	f:SetTimeVisible(fadetime)
	f:SetMaxLines(20)
	f:SetSpacing(3)
	f:SetWidth(84)
	f:SetHeight(150)
	
	f.movingname = movingname
	f:SetJustifyH(justify)
	f:SetPoint(...)
	
	T.CreateDragFrame(f, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
	
	f.dragFrame:SetScript("OnUpdate", function(self, elapsed)
		self.timer = (self.timer or 0) + elapsed
		if self.timer > 1 then	
			self.number = random(1 , 10000)
			frames[1]:AddMessage("-"..self.number, 1, 0, 0)
			frames[2]:AddMessage("+"..self.number, 0, 1, 0)
			frames[3]:AddMessage(GetSpellTextureFormatted(6603, iconsize)..self.number, 1, 1, 0)
			frames[4]:AddMessage(GetSpellTextureFormatted(139, iconsize)..self.number, 0.3, 1, 0)
			self.timer = 0
		end
	end)
	
	return f
end

local tbl = {
	["DAMAGE"] = 			{frame = 1, prefix =  "-", 		arg2 = true, 	r = 1, 		g = 0.1, 	b = 0.1},
	["DAMAGE_CRIT"] = 		{frame = 1, prefix = "c-", 		arg2 = true, 	r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_DAMAGE"] = 		{frame = 1, prefix =  "-", 		arg2 = true, 	r = 0.79, 	g = 0.3, 	b = 0.85},
	["SPELL_DAMAGE_CRIT"] = {frame = 1, prefix = "c-", 		arg2 = true, 	r = 0.79, 	g = 0.3, 	b = 0.85},
	["HEAL"] = 				{frame = 2, prefix =  "+", 		arg3 = true, 	r = 0.1, 	g = 1, 		b = 0.1},
	["HEAL_CRIT"] = 		{frame = 2, prefix = "c+", 		arg3 = true, 	r = 0.1, 	g = 1, 		b = 0.1},
	["PERIODIC_HEAL"] = 	{frame = 2, prefix =  "+", 		arg3 = true, 	r = 0.1, 	g = 1, 		b = 0.1},
	["MISS"] = 				{frame = 1, prefix = "Miss", 					r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_MISS"] = 		{frame = 1, prefix = "Miss", 					r = 0.79, 	g = 0.3, 	b = 0.85},
	["SPELL_REFLECT"] = 	{frame = 1, prefix = "Reflect", 				r = 1, 		g = 1, 		b = 1},
	["DODGE"] = 			{frame = 1, prefix = "Dodge", 					r = 1, 		g = 0.1, 	b = 0.1},
	["PARRY"] = 			{frame = 1, prefix = "Parry", 					r = 1, 		g = 0.1, 	b = 0.1},
	["BLOCK"] = 			{frame = 1, prefix = "Block", 	spec = true,	r = 1, 		g = 0.1, 	b = 0.1},
	["RESIST"] = 			{frame = 1, prefix = "Resist", 	spec = true, 	r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_RESIST"] = 		{frame = 1, prefix = "Resist", 	spec = true, 	r = 0.79, 	g = 0.3, 	b = 0.85},
	["ABSORB"] = 			{frame = 1, prefix = "Absorb", 	spec = true, 	r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_ABSORBED"] = 	{frame = 1, prefix = "Absorb", 	spec = true, 	r = 0.79, 	g = 0.3, 	b = 0.85},
}

if showreceived then
	frames[1] = CreateCTFrame(1, L["damageCT"], "LEFT", "RIGHT", UIParent, "CENTER", -185, 0)
	frames[2] = CreateCTFrame(2, L["healingCT"], "RIGHT", "LEFT", UIParent, "CENTER", -365, 0)
	eventframe:RegisterEvent"COMBAT_TEXT_UPDATE"
end

if showoutput then
	frames[3] = CreateCTFrame(3, L["outdamageCT"], "RIGHT", "LEFT", UIParent, "CENTER", 185, 80)
	frames[4] = CreateCTFrame(4, L["outhealingCT"], "LEFT", "RIGHT", UIParent, "CENTER", 365, 80)	
	eventframe:RegisterEvent"COMBAT_LOG_EVENT_UNFILTERED"
end

local template = "-%s (%s)"
function eventframe:COMBAT_TEXT_UPDATE(spelltype, arg2, arg3)
	local info = tbl[spelltype]
	if info then
		local msg = info.prefix
		if info.spec  then
			if arg3 then
				msg = template:format(arg2, arg3)
			end
		else
			if info.arg2 then msg = msg..arg2 end
			if info.arg3 then msg = msg..arg3 end
		end
		frames[info.frame]:AddMessage(msg, info.r, info.g, info.b)
	end
end

function eventframe:COMBAT_LOG_EVENT_UNFILTERED(...)
	local icon, spellId, amount, critical, spellSchool
    local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags, destFlags2 = select(1, ...)
	if sourceGUID == UnitGUID("player") or sourceFlags == gflags then
		if eventType == 'SPELL_HEAL' or (eventType == 'SPELL_PERIODIC_HEAL' and showhots) then
			spellId = select(12, ...)
			amount = select(15, ...)
			critical = select(18, ...)
			if fliter and (healfilter[spellId] or aoefilter[spellId]) then return end
			icon = GetSpellTextureFormatted(spellId, critical and bigiconsize or iconsize)
			frames[4]:AddMessage(amount..""..icon, 0, 1, 0)
		elseif destGUID ~= UnitGUID("player") then
			if eventType=="SWING_DAMAGE" then
				amount = select(12, ...)
				critical = select(18, ...)
				icon = GetSpellTextureFormatted(6603, critical and bigiconsize or iconsize)
			elseif eventType == "RANGE_DAMAGE" then
				spellId = select(12, ...)
				amount = select(15, ...)
				critical = select(21, ...)
				icon = GetSpellTextureFormatted(spellId, critical and bigiconsize or iconsize)
			elseif eventType == "SPELL_DAMAGE" or (showdots and eventType == "SPELL_PERIODIC_DAMAGE") then
				spellId = select(12, ...)
				spellSchool = select(14, ...)
				amount = select(15, ...)
				critical = select(21, ...)
				icon = GetSpellTextureFormatted(spellId, critical and bigiconsize or iconsize)
			elseif eventType == "SWING_MISSED" then
				amount = select(12, ...) -- misstype
				icon = GetSpellTextureFormatted(6603, iconsize)
			elseif eventType == "SPELL_MISSED" or eventType == "RANGE_MISSED" then
				spellId = select(12, ...)
				amount = select(15, ...) -- misstype
				icon = GetSpellTextureFormatted(spellId, iconsize)
			end
			
			if amount and icon then
				if fliter and spellId and aoefilter[spellId] then return end
				if critical then
					if dmgcolor[spellSchool] then
						frames[3]:AddMessage("+"..amount..""..icon, dmgcolor[spellSchool][1], dmgcolor[spellSchool][2], dmgcolor[spellSchool][3])
					else
						frames[3]:AddMessage("+"..amount..""..icon, dmgcolor[1][1], dmgcolor[1][2], dmgcolor[1][3])
					end
				else
					if dmgcolor[spellSchool] then
						frames[3]:AddMessage(amount..""..icon, dmgcolor[spellSchool][1], dmgcolor[spellSchool][2], dmgcolor[spellSchool][3])
					else
						frames[3]:AddMessage(amount..""..icon, dmgcolor[1][1], dmgcolor[1][2], dmgcolor[1][3])
					end
				end
			end
		end
	end
end

if not IsAddOnLoaded("Blizzard_CombatText") then LoadAddOn("Blizzard_CombatText") end
if IsAddOnLoaded("Blizzard_CombatText") then
	CombatText:SetScript("OnUpdate", nil)
	CombatText:SetScript("OnEvent", nil)
	CombatText:UnregisterAllEvents()
end

SetCVar("CombatLogPeriodicSpells", 0)
SetCVar("PetMeleeDamage", 0)
SetCVar("CombatDamage", 0)
SetCVar("CombatHealing", 0)