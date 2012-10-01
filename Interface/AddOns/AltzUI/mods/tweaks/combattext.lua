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
		aoefilter[27243] = true  -- Seed of Corruption (DoT)
		aoefilter[27285] = true  -- Seed of Corruption (Explosion)
		aoefilter[87385] = true  -- Seed of Corruption (Explosion Soulburned)
		aoefilter[172]   = true  -- Corruption
		aoefilter[87389] = true  -- Corruption (Soulburn: Seed of Corruption)
		aoefilter[30108] = true  -- Unstable Affliction
		aoefilter[348]   = true  -- Immolate
		aoefilter[980]   = true  -- Bane of Agony
		aoefilter[85455] = true  -- Bane of Havoc
		aoefilter[85421] = true  -- Burning Embers
		aoefilter[42223] = true  -- Rain of Fire
		aoefilter[5857]  = true  -- Hellfire Effect
		aoefilter[47897] = true  -- Shadowflame (shadow direct damage)
		aoefilter[47960] = true  -- Shadowflame (fire dot)
		aoefilter[50590] = true  -- Immolation Aura
		aoefilter[30213] = true  -- Legion Strike (Felguard)
		aoefilter[89753] = true  -- Felstorm (Felguard)
		aoefilter[20153] = true  -- Immolation (Infrenal)
		--[[ healing spells ]]--
		healfilter[28176] = true  -- Fel Armor
		healfilter[96379] = true  -- Fel Armor (Thanks Shestak)
		healfilter[63106] = true  -- Siphon Life
		healfilter[54181] = true  -- Fel Synergy
		healfilter[89653] = true  -- Drain Life
		healfilter[79268] = true  -- Soul Harvest
		healfilter[30294] = true  -- Soul Leech
	elseif G.myClass == "DRUID" then
		aoefilter[8921]  = true  -- Moonfire
		aoefilter[93402] = true  -- Sunfire
		aoefilter[5570]  = true  -- Insect Swarm
		aoefilter[42231] = true  -- Hurricane
		aoefilter[50288] = true  -- Starfall
		aoefilter[78777] = true  -- Wild Mushroom
		aoefilter[61391] = true  -- Typhoon
		aoefilter[1822]  = true  -- Rake
		aoefilter[62078] = true  -- Swipe (Cat Form)
		aoefilter[779]   = true  -- Swipe (Bear Form)
		aoefilter[33745] = true  -- Lacerate
		aoefilter[1079]  = true  -- Rip
		--[[ healing spells ]]--
		aoefilter[774]   = true  -- Rejuvenation (Normal)
		aoefilter[64801] = true  -- Rejuvenation (First tick)
		aoefilter[48438] = true  -- Wild Growth
		aoefilter[8936]  = true  -- Regrowth
		aoefilter[33763] = true  -- Lifebloom
		aoefilter[44203] = true  -- Tranquility
		aoefilter[81269] = true  -- Efflorescence
	elseif G.myClass == "PALADIN" then
		aoefilter[81297] = true  -- Consecration
		aoefilter[2812]  = true  -- Holy Wrath
		aoefilter[53385] = true  -- Divine Storm
		aoefilter[31803] = true  -- Censure
		aoefilter[20424] = true  -- Seals of Command
		aoefilter[42463] = true  -- Seal of Truth
		aoefilter[101423] = true	-- Seal of Righteousness (Thanks Shestak)
		aoefilter[88263] = true  -- Hammer of the Righteous
		aoefilter[31935] = true  -- Avenger's Shield
		aoefilter[94289] = true  -- Protector of the Innocent
		--[[ healing spells ]]--
		aoefilter[53652] = true  -- Beacon of Light
		aoefilter[85222] = true  -- Light of Dawn
		aoefilter[86452] = true  -- Holy radiance (HoT) (Thanks Nidra)
		aoefilter[82327] = true  -- Holy Radiance   (Thanks Nidra)
		aoefilter[20167] = true  -- Seal of Insight (Heal Effect)
	elseif G.myClass == "PRIEST" then
		aoefilter[47666] = true  -- Penance (Damage Effect)
		aoefilter[15237] = true  -- Holy Nova (Damage Effect)
		aoefilter[589]   = true  -- Shadow Word: Pain
		aoefilter[34914] = true  -- Vampiric Touch
		aoefilter[2944]  = true  -- Devouring Plague
		aoefilter[63675] = true  -- Improved Devouring Plague
		aoefilter[15407] = true  -- Mind Flay
		aoefilter[49821] = true  -- Mind Seer
		aoefilter[87532] = true  -- Shadowy Apparition
		aoefilter[14914] = true  -- Holy Fire
		--[[ healing spells ]]--
		aoefilter[47750]= true  -- Penance (Heal Effect)
		aoefilter[139]  = true  -- Renew
		aoefilter[596]  = true  -- Prayer of Healing
		aoefilter[56161]= true  -- Glyph of Prayer of Healing
		aoefilter[64844]= true  -- Divine Hymn
		aoefilter[32546]= true  -- Binding Heal
		aoefilter[77489]= true  -- Echo of Light
		aoefilter[34861]= true  -- Circle of Healing
		aoefilter[23455]= true  -- Holy Nova (Healing Effect)
		aoefilter[33110]= true  -- Prayer of Mending
		aoefilter[63544]= true  -- Divine Touch
		aoefilter[88686]= true  -- Holy Word: Sanctuary
		--[[ healing spells ]]--
		healfilter[127626]  = true  -- Devouring Plague (Healing)
		healfilter[15290] = true  -- Vampiric Embrace
	elseif G.myClass == "SHAMAN" then
		aoefilter[421]   = true  -- Chain Lightning
		aoefilter[8349]  = true  -- Fire Nova
		aoefilter[77478] = true  -- Earhquake
		aoefilter[51490] = true  -- Thunderstorm
		aoefilter[8187]  = true  -- Magma Totem
		aoefilter[8050]  = true	-- Flame Shock (Thanks Shestak)
		aoefilter[25504] = true  -- Windfury (Thanks NitZo)
		--[[ healing spells ]]--
		aoefilter[73921] = true  -- Healing Rain
		aoefilter[1064]  = true  -- Chain Heal
		aoefilter[52042] = true  -- Healing Stream Totem
		aoefilter[51945] = true  -- Earthliving (Thanks gnangnan)
		aoefilter[61295] = true  -- Riptide (Instant & HoT) (Thanks gnangnan)
	elseif G.myClass == "MAGE" then
		aoefilter[44461] = true  -- Living Bomb Explosion
		aoefilter[44457] = true  -- Living Bomb Dot
		aoefilter[2120]  = true  -- Flamestrike
		aoefilter[12654] = true  -- Ignite
		aoefilter[11366] = true  -- Pyroblast
		aoefilter[31661] = true  -- Dragon's Breath
		aoefilter[42208] = true  -- Blizzard
		aoefilter[122]   = true  -- Frost Nova
		aoefilter[1449]  = true  -- Arcane Explosion
		aoefilter[92315] = true  -- Pyroblast(Thanks Shestak)
		aoefilter[83853] = true  -- Combustion   (Thanks Shestak)
		aoefilter[11113] = true  -- Blast Wave   (Thanks Shestak)
		aoefilter[88148] = true  -- Flamestrike void (Thanks Shestak)
		aoefilter[83619] = true  -- Fire Power   (Thanks Shestak)
		aoefilter[120]   = true  -- Cone of Cold (Thanks Shestak)
		aoefilter[1449]  = true  -- Arcane Explosion (Thanks Shestak)
		aoefilter[92315] = true  -- Pyroblast(Thanks Shestak)
	elseif G.myClass == "WARRIOR" then
		aoefilter[845]   = true  -- Cleave
		aoefilter[46968] = true  -- Shockwave
		aoefilter[6343]  = true  -- Thunder Clap
		aoefilter[1680]  = true  -- Whirlwind
		aoefilter[94009] = true  -- Rend
		aoefilter[12721] = true  -- Deep Wounds
		aoefilter[50622] = true  -- Bladestorm
		aoefilter[52174] = true  -- Heroic Leap
		--[[ healing spells ]]--
		healfilter[23880] = true  -- Bloodthirst
		healfilter[55694] = true  -- Enraged Regeneration
	elseif G.myClass == "HUNTER" then
		aoefilter[2643]  = true  -- Multi-Shot
		aoefilter[83077] = true  -- Serpent Sting (Instant Serpent Spread) (Thanks Naughtia)
		aoefilter[88453] = true  -- Serpent Sting (DOT 1/2 Serpent Spread) (Thanks Naughtia)
		aoefilter[88466] = true  -- Serpent Sting (DOT 2/2 Serpent Spread) (Thanks Naughtia)
		aoefilter[1978]  = true  -- Serpent Sting  (Thanks Naughtia)
		aoefilter[13812] = true  -- Explosive Trap
		aoefilter[53301] = true  -- Explosive Shot (3 ticks merged as one)
		aoefilter[63468] = true  -- Piercing Shots
	elseif G.myClass == "DEATHKNIGHT" then
		aoefilter[55095] = true  -- Frost Fever
		aoefilter[55078] = true  -- Blood Plague
		aoefilter[55536] = true  -- Unholy Blight
		aoefilter[48721] = true  -- Blood Boil
		aoefilter[49184] = true  -- Howling Blast
		aoefilter[52212] = true  -- Death and Decay
		aoefilter[98957] = true  -- Burning Blood Tier 13 2pc Bonus
		aoefilter[59754] = true  -- Rune Tap (aoe heal if glyphed)
		-- Merging MainHand/OffHand Strikes (by Bozo)(Thanks Shestak)
		aoefilter[55050] = true  --  Heart Strike (Thanks Shestak)
		aoefilter[49020] = true  --Obliterate MH
		aoefilter[66198] = 49020 --Obliterate OH
		aoefilter[49998] = true  --  Death Strike MH
		aoefilter[66188] = 49998 --  Death Strike OH
		aoefilter[45462] = true  -- Plague Strike MH
		aoefilter[66216] = 45462 -- Plague Strike OH
		aoefilter[49143] = true  --  Frost Strike MH
		aoefilter[66196] = 49143 --  Frost Strike OH
		aoefilter[56815] = true  --   Rune Strike MH
		aoefilter[66217] = 56815 --   Rune Strike OH
		aoefilter[45902] = true  --  Blood Strike MH
		aoefilter[66215] = 45902 --  Blood Strike OH
	elseif G.myClass == "ROGUE" then
		aoefilter[51723] = true  -- Fan of Knives
		aoefilter[2818]  = true  -- Deadly Poison
		aoefilter[8680]  = true  -- Instant Poison
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