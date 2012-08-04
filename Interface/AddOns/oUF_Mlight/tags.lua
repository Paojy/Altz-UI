local ADDON_NAME, ns = ...
local cfg = ns.cfg

local siValue = function(val)
    if (val >= 1e6) then
        return ("%.1fm"):format(val / 1e6)
    elseif (val >= 1e3) then
        return ("%.1fk"):format(val / 1e3)
    else
        return ("%d"):format(val)
    end
end
ns.siValue = siValue

-- calculating the ammount of latters
local function utf8sub(string, i, dots)
	if string then
	local bytes = string:len()
	if bytes <= i then
		return string
	else
		local len, pos = 0, 1
		while pos <= bytes do
			len = len + 1
			local c = string:byte(pos)
			if c > 0 and c <= 127 then
				pos = pos + 1
			elseif c >= 192 and c <= 223 then
				pos = pos + 2
			elseif c >= 224 and c <= 239 then
				pos = pos + 3
			elseif c >= 240 and c <= 247 then
				pos = pos + 4
			end
			if len == i then break end
		end
		if len == i and pos <= bytes then
			return string:sub(1, pos - 1)..(dots and '..' or '')
		else
			return string
		end
	end
	end
end

local function hex(r, g, b)
    if not r then return "|cffFFFFFF" end

    if(type(r) == 'table') then
        if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
    end
    return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
end

oUF.Tags.Methods['Mlight:lvl'] = function(u) 
    local level = UnitLevel(u)
    local typ = UnitClassification(u)
    local color = GetQuestDifficultyColor(level)

    if level <= 0 then
        level = "??" 
        color.r, color.g, color.b = 1, 0, 0
    end

    if typ=="rareelite" then
        return hex(color)..level..'r+|r'
    elseif typ=="elite" then
        return hex(color)..level..'+|r'
    elseif typ=="rare" then
        return hex(color)..level..'r|r'
    else
        return hex(color)..level..'|r'
    end
end

oUF.Tags.Methods['Mlight:hp']  = function(u) 
    local min, max = UnitHealth(u), UnitHealthMax(u)
	if min~=max and min > 0 then 
    return siValue(min).." | "..math.floor(min/max*100+.5).."%"
	end
end
oUF.Tags.Events['Mlight:hp'] = 'UNIT_HEALTH'

oUF.Tags.Methods['Mlight:pp'] = function(u) 
	local min, max = UnitPower(u), UnitPowerMax(u)
	
    if min~=max and min > 0 then
        local _, str, r, g, b = UnitPowerType(u)
        local t = oUF.colors.power[str]

        if t then
            r, g, b = t[1], t[2], t[3]
        end

        return hex(r, g, b)..siValue(min).."|r"
    end
end
oUF.Tags.Events['Mlight:pp'] = 'UNIT_POWER'

oUF.Tags.Methods['Mlight:color'] = function(u, r)
    local reaction = UnitReaction(u, "player")

    if (UnitIsTapped(u) and not UnitIsTappedByPlayer(u)) then
        return hex(oUF.colors.tapped)
    elseif (UnitIsPlayer(u)) then
        local _, class = UnitClass(u)
        return hex(oUF.colors.class[class])
    elseif reaction then
        return hex(oUF.colors.reaction[reaction])
    else
        return hex(1, 1, 1)
    end
end
oUF.Tags.Events['Mlight:color'] = 'UNIT_REACTION UNIT_HEALTH'

oUF.Tags.Methods['Mlight:name'] = function(u, r)
    local name = UnitName(r or u)
    return name
end
oUF.Tags.Events['Mlight:name'] = 'UNIT_NAME_UPDATE'

oUF.Tags.Methods['Mlight:shortname'] = function(u, r)
	local name = UnitName(r or u)
	return utf8sub(name, 3, false)
end
oUF.Tags.Events['Mlight:shortname'] = 'UNIT_NAME_UPDATE'

oUF.Tags.Methods['Mlight:info'] = function(u)
    if UnitIsDead(u) then
        return oUF.Tags.Methods['Mlight:lvl'](u).."|cffCFCFCF DEAD|r"
    elseif UnitIsGhost(u) then
        return oUF.Tags.Methods['Mlight:lvl'](u).."|cffCFCFCF Gho|r"
    elseif not UnitIsConnected(u) then
        return oUF.Tags.Methods['Mlight:lvl'](u).."|cffCFCFCF D/C|r"
    else
        return oUF.Tags.Methods['Mlight:lvl'](u)
    end
end
oUF.Tags.Events['Mlight:info'] = 'UNIT_HEALTH'

oUF.Tags.Methods['Mlight:altpower'] = function(u)
    local cur = UnitPower(u, ALTERNATE_POWER_INDEX)
    local max = UnitPowerMax(u, ALTERNATE_POWER_INDEX)

    if max > 0 then
        local per = floor(cur/max*100)

        return format("%d", per > 0 and per or 0).."%"
    end
end
oUF.Tags.Events['Mlight:altpower'] = "UNIT_POWER UNIT_MAXPOWER"

--------------[[     raid     ]]-------------------
oUF.Tags.Methods['Mlight:raidinfo'] = function(u)
	local ripcolor = {r = 1, g = 0, b = 0}
	local ghocolor = {r = 0.5, g = 0.5, b = 0.5}
	
    if UnitIsDead(u) then
        return hex(ripcolor).."b|r"
    elseif UnitIsGhost(u) then
        return hex(ghocolor).."z|r"
    elseif not UnitIsConnected(u) then
        return hex(ghocolor).."U|r"
    end

end
oUF.Tags.Events['Mlight:raidinfo'] = 'UNIT_HEALTH UNIT_CONNECTION'