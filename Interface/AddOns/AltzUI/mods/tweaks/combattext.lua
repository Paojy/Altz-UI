-- LightCT by Alza
-- xCT by Dandruff
local T, C, L, G = unpack(select(2, ...))
local frames = {}
local dmgcolor = {}
dmgcolor[1]  = {  1,  1,  0 }  -- physical
dmgcolor[2]  = {  1, .9, .5 }  -- holy
dmgcolor[4]  = {  1, .5,  0 }  -- fire
dmgcolor[8]  = { .3,  1, .3 }  -- nature
dmgcolor[16] = { .5,  1,  1 }  -- frost
dmgcolor[32] = { .5, .5,  1 }  -- shadow
dmgcolor[64] = {  1, .5,  1 }  -- arcane

local tbl = {
	["DAMAGE"] = 			{frame = "damagetaken", prefix =  "-", 		arg2 = true, 	r = 1, 		g = 0.1, 	b = 0.1},
	["DAMAGE_CRIT"] = 		{frame = "damagetaken", prefix = "c-", 		arg2 = true, 	r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_DAMAGE"] = 		{frame = "damagetaken", prefix =  "-", 		arg2 = true, 	r = 0.79, 	g = 0.3, 	b = 0.85},
	["SPELL_DAMAGE_CRIT"] = {frame = "damagetaken", prefix = "c-", 		arg2 = true, 	r = 0.79, 	g = 0.3, 	b = 0.85},
	["HEAL"] = 				{frame = "healingtaken", prefix =  "+", 	arg3 = true, 	r = 0.1, 	g = 1, 		b = 0.1},
	["HEAL_CRIT"] = 		{frame = "healingtaken", prefix = "c+", 	arg3 = true, 	r = 0.1, 	g = 1, 		b = 0.1},
	["PERIODIC_HEAL"] = 	{frame = "healingtaken", prefix =  "+", 	arg3 = true, 	r = 0.1, 	g = 1, 		b = 0.1},
	["MISS"] = 				{frame = "damagetaken", prefix = "Miss", 					r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_MISS"] = 		{frame = "damagetaken", prefix = "Miss", 					r = 0.79, 	g = 0.3, 	b = 0.85},
	["SPELL_REFLECT"] = 	{frame = "damagetaken", prefix = "Reflect", 				r = 1, 		g = 1, 		b = 1},
	["DODGE"] = 			{frame = "damagetaken", prefix = "Dodge", 					r = 1, 		g = 0.1, 	b = 0.1},
	["PARRY"] = 			{frame = "damagetaken", prefix = "Parry", 					r = 1, 		g = 0.1, 	b = 0.1},
	["BLOCK"] = 			{frame = "damagetaken", prefix = "Block", 	spec = true,	r = 1, 		g = 0.1, 	b = 0.1},
	["RESIST"] = 			{frame = "damagetaken", prefix = "Resist", 	spec = true, 	r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_RESIST"] = 		{frame = "damagetaken", prefix = "Resist", 	spec = true, 	r = 0.79, 	g = 0.3, 	b = 0.85},
	["ABSORB"] = 			{frame = "damagetaken", prefix = "Absorb", 	spec = true, 	r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_ABSORBED"] = 	{frame = "damagetaken", prefix = "Absorb", 	spec = true, 	r = 0.79, 	g = 0.3, 	b = 0.85},
}

local GetSpellTextureFormatted = function(spellID, iconSize)
	local msg = ""
	if spellID == PET_ATTACK_TEXTURE then
		msg = " \124T"..PET_ATTACK_TEXTURE..":"..iconSize..":"..iconSize..":0:0:64:64:5:59:5:59\124t"
	else
		local icon = GetSpellTexture(spellID)
		if icon then
			msg = " \124T"..icon..":"..iconSize..":"..iconSize..":0:0:64:64:5:59:5:59\124t"
		else
			msg = " \124T134400:"..iconSize..":"..iconSize..":0:0:64:64:5:59:5:59\124t"
		end
	end
	return msg
end

local function CreateCTFrame(i, movingname, justify, a1, parent, a2, x, y)
	local f = CreateFrame("ScrollingMessageFrame", "Combat Text"..i, UIParent)
	
	f:SetFont("Interface\\AddOns\\AltzUI\\media\\number.ttf", aCoreCDB["CombattextOptions"]["cticonsize"], "OUTLINE")
	f:SetShadowColor(0, 0, 0, 0)
	f:SetFadeDuration(0.2)
	f:SetTimeVisible(aCoreCDB["CombattextOptions"]["ctfadetime"])
	f:SetMaxLines(20)
	f:SetSpacing(3)
	f:SetWidth(84)
	f:SetHeight(150)
	
	f.movingname = movingname
	f.point = {
		healer = {a1 = a1, parent = parent:GetName(), a2 = a2, x = x, y = y},
		dpser = {a1 = a1, parent = parent:GetName(), a2 = a2, x = x, y = y},
	}
	T.CreateDragFrame(f)
	
	f:SetJustifyH(justify)
	
	f.df:SetScript("OnUpdate", function(self, elapsed)
		self.timer = (self.timer or 0) + elapsed
		if self.timer > 1 then	
			self.number = random(1 , 10000)
			if aCoreCDB["CombattextOptions"]["showreceivedct"] then
				frames["damagetaken"]:AddMessage("-"..self.number, 1, 0, 0)
				frames["healingtaken"]:AddMessage("+"..self.number, 0, 1, 0)
			end
			if aCoreCDB["CombattextOptions"]["showoutputct"] then
				frames["outputdamage"]:AddMessage(GetSpellTextureFormatted(6603, aCoreCDB["CombattextOptions"]["cticonsize"])..self.number, 1, 1, 0)
				frames["outputhealing"]:AddMessage(GetSpellTextureFormatted(139, aCoreCDB["CombattextOptions"]["cticonsize"])..self.number, 0.3, 1, 0)
			end
			self.timer = 0
		end
	end)
	
	return f
end

local eventframe = CreateFrame("Frame")
eventframe:SetScript("OnEvent", function(self, event, ...)
	if not aCoreCDB["CombattextOptions"]["combattext"] then return end
	self[event](self, ...)
end)

function eventframe:COMBAT_TEXT_UPDATE(spelltype)
	local info = tbl[spelltype]
	if info then
		local msg = info.prefix
		local arg2, arg3 = GetCurrentCombatTextEventInfo()
		if info.spec  then
			if arg3 then
				msg = string.format("-%s (%s)", arg2, arg3)
			end
		else
			if info.arg2 and arg2 then msg = msg..T.ShortValue(arg2) end
			if info.arg3 and arg3 then msg = msg..T.ShortValue(arg3) end
		end
		frames[info.frame]:AddMessage(msg, info.r, info.g, info.b)
	end
end

function eventframe:COMBAT_LOG_EVENT_UNFILTERED()
	local icon, spellId, amount, critical, spellSchool
    local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags, destFlags2, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19, arg20, arg21 = CombatLogGetCurrentEventInfo()
	if sourceGUID == UnitGUID("player") or (aCoreCDB["CombattextOptions"]["ctshowpet"] and sourceGUID == UnitGUID("pet")) or sourceFlags == gflags then
		if eventType == 'SPELL_HEAL' or (aCoreCDB["CombattextOptions"]["ctshowhots"] and eventType == 'SPELL_PERIODIC_HEAL') then
			spellId = arg12
			amount = arg15
			critical = arg18
			icon = GetSpellTextureFormatted(spellId, critical and aCoreCDB["CombattextOptions"]["ctbigiconsize"] or aCoreCDB["CombattextOptions"]["cticonsize"])
			frames["outputhealing"]:AddMessage(T.ShortValue(amount)..""..icon, 0, 1, 0)
		elseif destGUID ~= UnitGUID("player") then
			if eventType=="SWING_DAMAGE" then
				amount = arg12
				critical = arg18
				icon = GetSpellTextureFormatted(6603, critical and aCoreCDB["CombattextOptions"]["ctbigiconsize"] or aCoreCDB["CombattextOptions"]["cticonsize"])
			elseif eventType == "RANGE_DAMAGE" then
				spellId = arg12
				amount = arg15
				critical = arg21
				icon = GetSpellTextureFormatted(spellId, critical and aCoreCDB["CombattextOptions"]["ctbigiconsize"] or aCoreCDB["CombattextOptions"]["cticonsize"])
			elseif eventType == "SPELL_DAMAGE" or (aCoreCDB["CombattextOptions"]["ctshowdots"] and eventType == "SPELL_PERIODIC_DAMAGE") then
				spellId = arg12
				spellSchool = arg14
				amount = arg15
				critical = arg21
				icon = GetSpellTextureFormatted(spellId, critical and aCoreCDB["CombattextOptions"]["ctbigiconsize"] or aCoreCDB["CombattextOptions"]["cticonsize"])
			elseif eventType == "SWING_MISSED" then
				amount = arg12 -- misstype
				icon = GetSpellTextureFormatted(6603, aCoreCDB["CombattextOptions"]["cticonsize"])
			elseif eventType == "SPELL_MISSED" or eventType == "RANGE_MISSED" then
				spellId = arg12
				amount = arg15 -- misstype
				icon = GetSpellTextureFormatted(spellId, aCoreCDB["CombattextOptions"]["cticonsize"])
			end
			
			if amount and icon then
				if critical then
					if dmgcolor[spellSchool] then
						frames["outputdamage"]:AddMessage("+"..T.ShortValue(amount)..""..icon, dmgcolor[spellSchool][1], dmgcolor[spellSchool][2], dmgcolor[spellSchool][3])
					else
						frames["outputdamage"]:AddMessage("+"..T.ShortValue(amount)..""..icon, dmgcolor[1][1], dmgcolor[1][2], dmgcolor[1][3])
					end
				else
					if dmgcolor[spellSchool] then
						frames["outputdamage"]:AddMessage(T.ShortValue(amount)..""..icon, dmgcolor[spellSchool][1], dmgcolor[spellSchool][2], dmgcolor[spellSchool][3])
					else
						frames["outputdamage"]:AddMessage(T.ShortValue(amount)..""..icon, dmgcolor[1][1], dmgcolor[1][2], dmgcolor[1][3])
					end
				end
			end
		end
	end
end

local function Init()
	SetCVar("floatingCombatTextCombatDamage", 1)
	SetCVar("floatingCombatTextCombatHealing", 1)
	
	if aCoreCDB["CombattextOptions"]["hidblz_receive"] then
		SetCVar("floatingCombatTextCombatDamage", 0)
		SetCVar("floatingCombatTextCombatHealing", 0)
	end
	
	if aCoreCDB["CombattextOptions"]["hidblz"] then
		SetCVar("enableFloatingCombatText", 0)
	else
		SetCVar("enableFloatingCombatText", 1)
	end
	
	if aCoreCDB["CombattextOptions"]["showreceivedct"] then
		frames["damagetaken"] = CreateCTFrame("damagetaken", L["承受伤害"], "LEFT", "RIGHT", UIParent, "CENTER", -485, 0)
		frames["healingtaken"] = CreateCTFrame("healingtaken", L["承受治疗"], "RIGHT", "LEFT", UIParent, "CENTER", -665, 0)
		eventframe:RegisterEvent("COMBAT_TEXT_UPDATE")
	end
	
	if aCoreCDB["CombattextOptions"]["showoutputct"] then
		frames["outputdamage"] = CreateCTFrame("outputdamage", L["输出伤害"], "RIGHT", "LEFT", UIParent, "CENTER", 485, 80)
		frames["outputhealing"] = CreateCTFrame("outputhealing", L["输出治疗"], "LEFT", "RIGHT", UIParent, "CENTER", 665, 80)	
		eventframe:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
	
	-- 战斗文字字体
	local font = aCoreCDB["SkinOptions"]["combattext"]
	if font ~= "none" then
		DAMAGE_TEXT_FONT = G.combatFont[font]
	end
end

T.RegisterInitCallback(Init)