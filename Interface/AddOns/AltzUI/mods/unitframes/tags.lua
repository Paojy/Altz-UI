local T, C, L, G = unpack(select(2, ...))

local oUF = AltzUF or oUF

oUF.Tags.Methods['Altz:color'] = function(u, r)
    local reaction = UnitReaction(u, "player")

    if UnitIsTapDenied(u) then
        return T.hex(oUF.colors.tapped)
    elseif (UnitIsPlayer(u)) then
        local _, class = UnitClass(u)
        return T.hex(oUF.colors.class[class])
    elseif reaction then
        return T.hex(oUF.colors.reaction[reaction])
    else
        return T.hex(1, 1, 1)
    end
end
oUF.Tags.Events['Altz:color'] = 'UNIT_FACTION' -- for tapping

oUF.Tags.Methods['Altz:shortname'] = function(u, r)
	local name = UnitName(r or u)
	local color = _TAGS['Altz:color'](u)
	if aCoreCDB["SkinOptions"]["style"] ~= 3 then
		return color..T.utf8sub(name, 8)
	else
		return T.utf8sub(name, 8)
	end
end
oUF.Tags.Events["Altz:shortname"] = "UNIT_NAME_UPDATE"

oUF.Tags.Methods['Altz:longname'] = function(u, r)
	local difficulty = ""
	if UnitCanAttack('player', u) then
		local l = UnitEffectiveLevel(u)
		difficulty = T.hex(GetCreatureDifficultyColor((l > 0) and l or 999))
	end
	
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
	
	
	local color = _TAGS['Altz:color'](u)
	local name = UnitName(r or u)
	local status = _TAGS['status'](u) or ""
	
	if aCoreCDB["SkinOptions"]["style"] ~= 3 then
		return difficulty..level..shortclassification.."|r "..color..name.." "..status
	else
		return difficulty..level..shortclassification.."|r "..name.." "..status
	end
end
oUF.Tags.Events["Altz:longname"] = "UNIT_NAME_UPDATE"

oUF.Tags.Methods["Altz:hpraidname"] = function(u, r)
	local name = UnitName(r or u)
	if not name then return end
	local color = _TAGS['Altz:color'](u)
	local result
	if aCoreCDB["UnitframeOptions"]["showmisshp"] then
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
	else
		result = T.utf8sub(name, aCoreCDB["UnitframeOptions"]["namelength"])
	end
	if result then
		if aCoreCDB["SkinOptions"]["style"] ~= 3 then
			return color..result
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
			local r, g, b = T.GetUnitColorforNameplate(u)
			result = T.hex(r, g, b)..class..name.."|r"
		else
			result = class..name
		end
		
		return result
	end
end
oUF.Tags.Events["Altz:platename"] = "UNIT_CLASSIFICATION_CHANGED UNIT_FACTION UNIT_NAME_UPDATE"
