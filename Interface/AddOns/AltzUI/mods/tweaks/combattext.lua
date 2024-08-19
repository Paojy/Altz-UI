local T, C, L, G = unpack(select(2, ...))

local iconsize, crit_iconsize = 13, 25
local dmgcolor = {}
dmgcolor[1]  = {  1,  1,  0 }  -- physical
dmgcolor[2]  = {  1, .9, .5 }  -- holy
dmgcolor[4]  = {  1, .5,  0 }  -- fire
dmgcolor[8]  = { .3,  1, .3 }  -- nature
dmgcolor[16] = { .5,  1,  1 }  -- frost
dmgcolor[32] = { .5, .5,  1 }  -- shadow
dmgcolor[64] = {  1, .5,  1 }  -- arcane

local tbl = {
	["DAMAGE"] = 			{frame = "damagetaken",  	prefix =  "-", 		dmg_value = true, 	r = 1, 		g = 0.1, 	b = 0.1},
	["DAMAGE_CRIT"] = 		{frame = "damagetaken",  	prefix = "c-", 		dmg_value = true, 	r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_DAMAGE"] = 		{frame = "damagetaken",  	prefix =  "-", 		dmg_value = true, 	r = 0.79, 	g = 0.3, 	b = 0.85},
	["SPELL_DAMAGE_CRIT"] = {frame = "damagetaken",  	prefix = "c-", 		dmg_value = true, 	r = 0.79, 	g = 0.3, 	b = 0.85},
	["HEAL"] = 				{frame = "healingtaken", 	prefix =  "+", 		heal_value = true, 	r = 0.1, 	g = 1, 		b = 0.1},
	["HEAL_CRIT"] = 		{frame = "healingtaken", 	prefix = "c+", 		heal_value = true, 	r = 0.1, 	g = 1, 		b = 0.1},
	["PERIODIC_HEAL"] = 	{frame = "healingtaken", 	prefix =  "+", 		heal_value = true, 	r = 0.1, 	g = 1, 		b = 0.1},
	["MISS"] = 				{frame = "damagetaken",		prefix = "Miss", 						r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_MISS"] = 		{frame = "damagetaken",		prefix = "Miss", 						r = 0.79, 	g = 0.3, 	b = 0.85},
	["SPELL_REFLECT"] = 	{frame = "damagetaken",		prefix = "Reflect", 					r = 1, 		g = 1, 		b = 1},
	["DODGE"] = 			{frame = "damagetaken",		prefix = "Dodge", 						r = 1, 		g = 0.1, 	b = 0.1},
	["PARRY"] = 			{frame = "damagetaken",		prefix = "Parry", 						r = 1, 		g = 0.1, 	b = 0.1},
	["BLOCK"] = 			{frame = "damagetaken",		prefix = "Block", 	special = true,		r = 1, 		g = 0.1, 	b = 0.1},
	["RESIST"] = 			{frame = "damagetaken",		prefix = "Resist", 	special = true, 	r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_RESIST"] = 		{frame = "damagetaken",		prefix = "Resist", 	special = true, 	r = 0.79, 	g = 0.3, 	b = 0.85},
	["ABSORB"] = 			{frame = "damagetaken",		prefix = "Absorb", 	special = true, 	r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_ABSORBED"] = 	{frame = "damagetaken",		prefix = "Absorb", 	special = true, 	r = 0.79, 	g = 0.3, 	b = 0.85},
}

local eventFrame = CreateFrame("Frame")

local function GetSpellTextureFormatted(spellID, size)
	local msg = ""
	if spellID == PET_ATTACK_TEXTURE then
		msg = " \124T"..PET_ATTACK_TEXTURE..":"..size..":"..size..":0:0:64:64:5:59:5:59\124t"
	else
		local _, _, icon = T.GetSpellInfo(spellID)
		if icon then
			msg = " \124T"..icon..":"..size..":"..size..":0:0:64:64:5:59:5:59\124t"
		else
			msg = " \124T134400:"..size..":"..size..":0:0:64:64:5:59:5:59\124t"
		end
	end
	return msg
end

local function CreateCTFrame(tag, movingname, justify, a1, parent, a2, x, y)
	local frame = CreateFrame("ScrollingMessageFrame", "CombatText"..tag, UIParent)
	frame:SetSize(84,150)
	
	frame.movingname = movingname
	frame.point = {
		healer = {a1 = a1, parent = parent:GetName(), a2 = a2, x = x, y = y},
		dpser = {a1 = a1, parent = parent:GetName(), a2 = a2, x = x, y = y},
	}
	
	T.CreateDragFrame(frame)
	
	frame.df:SetScript("OnUpdate", function(self, elapsed)
		self.timer = (self.timer or 0) + elapsed
		if self.timer > 1 then		
			local number = random(1 , 10000)
			if tag == "damagetaken" then
				frame:AddMessage("-"..number, 1, 0, 0)
			elseif tag == "healingtaken" then
				frame:AddMessage("+"..number, 0, 1, 0)
			elseif tag == "outputdamage" then
				frame:AddMessage(GetSpellTextureFormatted(6603, iconsize)..number, 1, 1, 0)
			elseif tag == "outputhealing" then
				frame:AddMessage(GetSpellTextureFormatted(139, iconsize)..number, 0.3, 1, 0)
			end
			self.timer = 0
		end
	end)
	
	frame:SetFont(G.numFont, iconsize, "OUTLINE")
	frame:SetJustifyH(justify)
	frame:SetShadowColor(0, 0, 0, 0)
	frame:SetFadeDuration(0.2)
	frame:SetTimeVisible(3)
	frame:SetMaxLines(20)
	frame:SetSpacing(3)
	
	return frame
end

local damagetaken = CreateCTFrame("damagetaken", L["承受伤害"], "LEFT", "RIGHT", UIParent, "CENTER", -485, 0)
local healingtaken = CreateCTFrame("healingtaken", L["承受治疗"], "RIGHT", "LEFT", UIParent, "CENTER", -665, 0)

local outputdamage = CreateCTFrame("outputdamage", L["输出伤害"], "RIGHT", "LEFT", UIParent, "CENTER", 485, 80)
local outputhealing = CreateCTFrame("outputhealing", L["输出治疗"], "LEFT", "RIGHT", UIParent, "CENTER", 665, 80)	

eventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "COMBAT_TEXT_UPDATE" then
		local spelltype = ...
		local info = tbl[spelltype]
		if info then
			local arg2, arg3 = GetCurrentCombatTextEventInfo()
			local msg
			
			if info.special and arg3 then
				msg = info.prefix..string.format(" %s (%s)", arg2, arg3)
			elseif info.dmg_value and arg2 then
				msg = info.prefix..T.ShortValue(arg2)
			elseif info.heal_value and arg3 then
				msg = info.prefix..T.ShortValue(arg3)
			else
				msg = info.prefix
			end
			
			if info.frame == "damagetaken" then
				damagetaken:AddMessage(msg, info.r, info.g, info.b)
			elseif info.frame == "healingtaken" then
				healingtaken:AddMessage(msg, info.r, info.g, info.b)
			end
		end
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local icon, spellId, amount, critical, spellSchool
		local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags, destFlags2, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19, arg20, arg21 = CombatLogGetCurrentEventInfo()
		if sourceGUID == UnitGUID("player") or (aCoreCDB["CombattextOptions"]["ctshowpet"] and sourceGUID == UnitGUID("pet")) then
			if eventType == 'SPELL_HEAL' or (aCoreCDB["CombattextOptions"]["ctshowhots"] and eventType == 'SPELL_PERIODIC_HEAL') then
				spellId = arg12
				amount = arg15
				critical = arg18
				icon = GetSpellTextureFormatted(spellId, critical and crit_iconsize or iconsize)
				outputhealing:AddMessage(T.ShortValue(amount)..""..icon, 0, 1, 0)
			elseif destGUID ~= UnitGUID("player") then
				if eventType=="SWING_DAMAGE" then
					amount = arg12
					critical = arg18
					icon = GetSpellTextureFormatted(6603, critical and crit_iconsize or iconsize)
				elseif eventType == "RANGE_DAMAGE" then
					spellId = arg12
					amount = arg15
					critical = arg21
					icon = GetSpellTextureFormatted(spellId, critical and crit_iconsize or iconsize)
				elseif eventType == "SPELL_DAMAGE" or (aCoreCDB["CombattextOptions"]["ctshowdots"] and eventType == "SPELL_PERIODIC_DAMAGE") then
					spellId = arg12
					spellSchool = arg14
					amount = arg15
					critical = arg21
					icon = GetSpellTextureFormatted(spellId, critical and crit_iconsize or iconsize)
				elseif eventType == "SWING_MISSED" then
					amount = arg12 -- misstype
					icon = GetSpellTextureFormatted(6603, iconsize)
				elseif eventType == "SPELL_MISSED" or eventType == "RANGE_MISSED" then
					spellId = arg12
					amount = arg15 -- misstype
					icon = GetSpellTextureFormatted(spellId, iconsize)
				end
				
				if amount and icon then
					if critical then
						if dmgcolor[spellSchool] then
							outputdamage:AddMessage("+"..T.ShortValue(amount)..""..icon, dmgcolor[spellSchool][1], dmgcolor[spellSchool][2], dmgcolor[spellSchool][3])
						else
							outputdamage:AddMessage("+"..T.ShortValue(amount)..""..icon, dmgcolor[1][1], dmgcolor[1][2], dmgcolor[1][3])
						end
					else
						if dmgcolor[spellSchool] then
							outputdamage:AddMessage(T.ShortValue(amount)..""..icon, dmgcolor[spellSchool][1], dmgcolor[spellSchool][2], dmgcolor[spellSchool][3])
						else
							outputdamage:AddMessage(T.ShortValue(amount)..""..icon, dmgcolor[1][1], dmgcolor[1][2], dmgcolor[1][3])
						end
					end
				end
			end
		end
	end
end)

local function ToggleCTVisibility()
	if aCoreCDB["CombattextOptions"]["showreceivedct"] then
		T.RestoreDragFrame(damagetaken)
		T.RestoreDragFrame(healingtaken)
		eventFrame:RegisterEvent("COMBAT_TEXT_UPDATE")
	else
		T.ReleaseDragFrame(damagetaken)
		T.ReleaseDragFrame(healingtaken)
		eventFrame:RegisterEvent("COMBAT_TEXT_UPDATE")
	end
	if aCoreCDB["CombattextOptions"]["showoutputct"] then
		T.RestoreDragFrame(outputdamage)
		T.RestoreDragFrame(outputhealing)
		eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	else
		T.ReleaseDragFrame(outputdamage)
		T.ReleaseDragFrame(outputhealing)
		eventFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end
T.ToggleCTVisibility = ToggleCTVisibility

T.RegisterInitCallback(function()
	ToggleCTVisibility()
	-- 战斗文字字体
	local font = aCoreCDB["CombattextOptions"]["combattext_font"]
	if font ~= "none" then
		local index = string.match(font, "%d")
		DAMAGE_TEXT_FONT = G["combatFont"..index]
	end
end)