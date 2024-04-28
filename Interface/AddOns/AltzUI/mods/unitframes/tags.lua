﻿local T, C, L, G = unpack(select(2, ...))

local oUF = AltzUF or oUF

oUF.Tags.Methods['Altz:shortname'] = function(u, r)
	local name = UnitName(r or u)
	if aCoreCDB["SkinOptions"]["style"] ~= 3 then
		return T.hex_str(T.utf8sub(name, 8), T.GetUnitColor(u))
	else
		return T.utf8sub(name, 8)
	end
end
oUF.Tags.Events["Altz:shortname"] = "UNIT_NAME_UPDATE"

oUF.Tags.Methods['Altz:longname'] = function(u, r)	
	local level = UnitLevel(u)
	if UnitIsWildBattlePet(u) or UnitIsBattlePetCompanion(u) then
		level = UnitBattlePetLevel(u)
	end
	if level <= 0 then
		level = '??'
	end

	local shortclassification = ""
	local c = UnitClassification(u)
	if(c == 'rare') then
		shortclassification = 'R'
	elseif(c == 'rareelite') then
		shortclassification = 'R+'
	elseif(c == 'elite') then
		shortclassification = '+'
	elseif(c == 'worldboss') then
		shortclassification = 'B'
	elseif(c == 'minus') then
		shortclassification = '-'
	end
	
	local level_str
	if UnitCanAttack('player', u) then
		local l = UnitEffectiveLevel(u)
		local dif_color = GetCreatureDifficultyColor((l > 0) and l or 999)
		level_str = T.hex_str(level..shortclassification, dif_color.r, dif_color.g, dif_color.b)
	else
		level_str = level..shortclassification
	end
	
	local name_str
	local name = UnitName(r or u)
	if aCoreCDB["SkinOptions"]["style"] ~= 3 then
		name_str = T.hex_str(name, T.GetUnitColor(u))
	else
		name_str = name
	end
	
	local status = _TAGS['status'](u) or ""
	
	return level_str.." "..name_str.." "..status
end
oUF.Tags.Events["Altz:longname"] = "UNIT_NAME_UPDATE"

oUF.Tags.Methods["Altz:hpraidname"] = function(u, r)
	local name = UnitName(r or u)
	if not name then return end
	local result
	if aCoreCDB["UnitframeOptions"]["name_style"] == "missing_hp" then
		local perc
		if UnitHealthMax(u) and UnitHealthMax(u) ~= 0 then
			perc = UnitHealth(u)/UnitHealthMax(u)
		else
			perc = 1
		end
		if perc > .9 or UnitIsDead(u) then
			result = T.utf8sub(name, aCoreCDB["UnitframeOptions"]["namelength"])
		else
			result = T.ShortValue(UnitHealthMax(u) - UnitHealth(u))
		end
	elseif aCoreCDB["UnitframeOptions"]["name_style"] == "name" then
		result = T.utf8sub(name, aCoreCDB["UnitframeOptions"]["namelength"])
	elseif aCoreCDB["UnitframeOptions"]["name_style"] == "none" then
		result = ""
	end
	
	if result then
		if aCoreCDB["SkinOptions"]["style"] ~= 3 then
			return T.hex_str(result, T.GetUnitColor(u))
		else		
			return result
		end
	end
end
oUF.Tags.Events["Altz:hpraidname"] = "UNIT_HEALTH UNIT_NAME_UPDATE"

--------------[[     raid     ]]-------------------

oUF.Tags.Methods['Altz:LFD'] = function(u) -- use symbols istead of letters
	local role = UnitGroupRolesAssigned(u)
	if role == "HEALER" then
		return "|cff7CFC00H|r"
	elseif role == "TANK" then
		return "|cffF4A460T|r"
	elseif role == "DAMAGER" then
		return "|cffEEEE00D|r"
	end
end
oUF.Tags.Events['Altz:LFD'] = "GROUP_ROSTER_UPDATE PLAYER_ROLES_ASSIGNED"

oUF.Tags.Methods['Altz:AfkDnd'] = function(u)
	if UnitIsAFK(u) then
		return "|cff9FB6CD <afk>|r"
	elseif UnitIsDND(u) then
		return "|cffCD2626 <dnd>|r"
	end
end
oUF.Tags.Events['Altz:AfkDnd'] = 'PLAYER_FLAGS_CHANGED'

oUF.Tags.Methods['Altz:DDG'] = function(u)
	if UnitIsDead(u) then
		return "|cffCD0000  Dead|r"
	elseif UnitIsGhost(u) then
		return "|cffBFEFFF  Ghost|r"
	elseif not UnitIsConnected(u) then
		return "|cffCCCCCC  D/C|r"
	end
end
oUF.Tags.Events['Altz:DDG'] = 'UNIT_HEALTH UNIT_CONNECTION'

oUF.Tags.Methods["Altz:platename"] = function(u, real)
	if not UnitIsUnit(u, "player") then
				
		local class = ""
		local c = UnitClassification(u)
		if c == 'rare' then
			class = 'R '
		elseif c == 'rareelite' then
			class = 'R+ '
		end
		
        local name = UnitName(real or u)
		
		local result
		
		if aCoreCDB["PlateOptions"]["theme"] ~= "class" then
			result = T.hex_str(class..name, T.GetUnitColorforNameplate(u))
		else
			result = class..name
		end
		
		return result
	end
end
oUF.Tags.Events["Altz:platename"] = "UNIT_CLASSIFICATION_CHANGED UNIT_FACTION UNIT_NAME_UPDATE"
