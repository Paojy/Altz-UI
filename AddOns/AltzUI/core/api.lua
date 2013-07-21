local T, C, L, G = unpack(select(2, ...))

T.ShortValue = function(v)
	if v >= 1e6 then
		return ("%.1fm"):format(v / 1e6):gsub("%.?0+([km])$", "%1")
	elseif v >= 1e3 or v <= -1e3 then
		return ("%.1fk"):format(v / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return v
	end
end

T.FormatUFValue = function(val)
	if oUF_MlightDB.tenthousand then
		if (val >= 1e7) then
			return ("%.1fkw"):format(val / 1e7)
		elseif (val >= 1e4) then
			return ("%.1fw"):format(val / 1e4)
		else
			return ("%d"):format(val)
		end
	else
		if (val >= 1e6) then
			return ("%.1fm"):format(val / 1e6)
		elseif (val >= 1e3) then
			return ("%.1fk"):format(val / 1e3)
		else
			return ("%d"):format(val)
		end
	end
end

local day, hour, minute = 86400, 3600, 60
T.FormatTime = function(s)
    if s >= day then
        return format("%dd", floor(s/day + 0.5))
    elseif s >= hour then
        return format("%dh", floor(s/hour + 0.5))
    elseif s >= minute then
        return format("%dm", floor(s/minute + 0.5))
    end

    return format("%d", math.fmod(s, minute))
end

T.createtext = function(f, layer, fontsize, flag, justifyh)
	local text = f:CreateFontString(nil, layer)
	text:SetFont(G.norFont, fontsize, flag)
	text:SetJustifyH(justifyh)
	return text
end

T.createnumber = function(f, layer, fontsize, flag, justifyh)
	local text = f:CreateFontString(nil, layer)
	text:SetFont(G.numFont, fontsize, flag)
	text:SetJustifyH(justifyh)
	return text
end

T.dummy = function() end

-- calculating the ammount of latters
T.utf8sub = function(str, i, wrap)
	if str then
	local bytes = string.len(str)
	if bytes <= i then
		return str
	else
		local len, pos = 0, 1
		while pos <= bytes do
			len = len + 1
			local c = string.byte(str, pos)
			if c > 0 and c <= 127 then
				pos = pos + 1
			elseif c >= 192 and c <= 223 then
				pos = pos + 2
			elseif c >= 224 and c <= 239 then
				pos = pos + 3
				len = len + 1
			elseif c >= 240 and c <= 247 then
				pos = pos + 4
				len = len + 1
			end
			if len == i then break end
		end
		if len == i and pos <= bytes then
			if wrap then
				return string.sub(str, 1, pos - 1).."\n"..T.utf8sub(string.sub(str, pos, bytes), i, true)
			else
				return string.sub(str, 1, pos - 1)
			end
		else
			return str
		end
	end
	end
end

T.hex = function(r, g, b)
    if not r then return "|cffFFFFFF" end

    if(type(r) == 'table') then
        if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
    end
    return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
end

local frameBD = {
    edgeFile = G.media.glow, edgeSize = 3,
    bgFile = G.media.blank,
    insets = {left = 3, right = 3, top = 3, bottom = 3}
}

T.createBackdrop = function(parent, anchor, a)
    local frame = CreateFrame("Frame", nil, parent)

	local flvl = parent:GetFrameLevel()
	if flvl - 1 >= 0 then frame:SetFrameLevel(flvl-1) end

	frame:ClearAllPoints()
    frame:SetPoint("TOPLEFT", anchor, "TOPLEFT", -3, 3)
    frame:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", 3, -3)

    frame:SetBackdrop(frameBD)
	if a then
		frame:SetBackdropColor(.15, .15, .15, a)
		frame:SetBackdropBorderColor(0, 0, 0)
	end

    return frame
end

T.createStatusbar = function(parent, tex, layer, height, width, r, g, b, alpha)
    local bar = CreateFrame"StatusBar"
    bar:SetParent(parent)
    if height then
        bar:SetHeight(height)
    end
    if width then
        bar:SetWidth(width)
    end
    bar:SetStatusBarTexture(tex, layer)
    bar:SetStatusBarColor(r, g, b, alpha)
	
    bar:GetStatusBarTexture():SetHorizTile(false)
    bar:GetStatusBarTexture():SetVertTile(false)
	
    return bar
end

T.CheckRole = function()
	local role
	local tree = GetSpecialization()
	if ((G.myClass == "MONK" and tree == 2) or (G.myClass == "PRIEST" and (tree == 1 or tree ==2)) or (G.myClass == "PALADIN" and tree == 1)) or (G.myClass == "DRUID" and tree == 4) or (myclass == "SHAMAN" and tree == 3) then
		role = "healer"
	else
		role = "dpser"
	end
	return role
end