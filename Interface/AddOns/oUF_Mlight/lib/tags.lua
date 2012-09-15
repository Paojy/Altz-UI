local addon, ns = ...

local FormatValue = function(val)
    if (val >= 1e6) then
        return ("%.1fm"):format(val / 1e6)
    elseif (val >= 1e3) then
        return ("%.1fk"):format(val / 1e3)
    else
        return ("%d"):format(val)
    end
end
ns.FormatValue = FormatValue

local day, hour, minute = 86400, 3600, 60
local FormatTime = function(s)
    if s >= day then
        return format("%dd", floor(s/day + 0.5))
    elseif s >= hour then
        return format("%dh", floor(s/hour + 0.5))
    elseif s >= minute then
        return format("%dm", floor(s/minute + 0.5))
    end

    return format("%d", math.fmod(s, minute))
end
ns.FormatTime = FormatTime

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
ns.hex = hex
--=============================================--
--[[                 Tags                    ]]--
--=============================================--
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
oUF.Tags.Events['Mlight:color'] = 'UNIT_FACTION' -- for tapping

oUF.Tags.Methods['Mlight:shortname'] = function(u, r)
	local name = UnitName(r or u)
	return utf8sub(name, 4, false)
end
oUF.Tags.Events["Mlight:shortname"] = "UNIT_NAME_UPDATE"

oUF.Tags.Methods["Mlight:raidname"] = function(u, r)
	local name = UnitName(r or u)
	return utf8sub(name, 4, false)
end
oUF.Tags.Events["Mlight:raidname"] = "UNIT_NAME_UPDATE"
--------------[[     raid     ]]-------------------

oUF.Tags.Methods['Mlight:LFD'] = function(u) -- use symbols istead of letters
	local role = UnitGroupRolesAssigned(u)
	if role == "HEALER" then
		return "|cff7CFC00H|r"
	elseif role == "TANK" then
		return "|cffF4A460T|r"
	elseif role == "DAMAGER" then
		return "|cffEEEE00D|r"
	end
end
oUF.Tags.Events['Mlight:LFD'] = "GROUP_ROSTER_UPDATE PLAYER_ROLES_ASSIGNED"

oUF.Tags.Methods['Mlight:AfkDnd'] = function(u)
	if UnitIsAFK(u) then
		return "|cff9FB6CD <afk>|r"
	elseif UnitIsDND(u) then
		return "|cffCD2626 <dnd>|r"
	end
end
oUF.Tags.Events['Mlight:AfkDnd'] = 'PLAYER_FLAGS_CHANGED'

oUF.Tags.Methods['Mlight:DDG'] = function(u)
	if UnitIsDead(u) then
		return "|cffCD0000  Dead|r"
	elseif UnitIsGhost(u) then
		return "|cffBFEFFF  Ghost|r"
	elseif not UnitIsConnected(u) then
		return "|cffCCCCCC  D/C|r"
	end
end
oUF.Tags.Events['Mlight:DDG'] = 'UNIT_HEALTH UNIT_CONNECTION'