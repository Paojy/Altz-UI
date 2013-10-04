local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)

T.ShortValue = function(val)
	if aCoreCDB["UnitframeOptions"]["tenthousand"] then
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

T.CreateSD = function(parent, size, r, g, b, alpha, offset)
	local sd = CreateFrame("Frame", nil, parent)
	sd.size = size or 5
	sd.offset = offset or 0
	sd:SetBackdrop({
		edgeFile = G.media.glow,
		edgeSize = sd.size,
	})
	sd:SetPoint("TOPLEFT", parent, -sd.size - 1 - sd.offset, sd.size + 1 + sd.offset)
	sd:SetPoint("BOTTOMRIGHT", parent, sd.size + 1 + sd.offset, -sd.size - 1 - sd.offset)
	sd:SetBackdropBorderColor(r or 0, g or 0, b or 0)
	sd:SetAlpha(alpha or 1)
end

T.SkinButton = function(button, tex, blend)
	local texture = button:CreateTexture(nil, "OVERLAY")
	texture:SetAllPoints(button)
	texture:SetTexture(tex)
	texture:SetVertexColor(1, 1, 1)
	
	if blend then
		texture:SetBlendMode("ADD")
	end
	
	if button:GetScript("OnEnter") then
		button:HookScript("OnEnter", function() texture:SetVertexColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b) end)
	else
		button:SetScript("OnEnter", function() texture:SetVertexColor(G.Ccolor.r, G.Ccolor.g, G.Ccolor.b) end)
	end
	
	if button:GetScript("OnLeave") then
		button:HookScript("OnLeave", function() texture:SetVertexColor(1, 1, 1) end)
	else
		button:SetScript("OnLeave", function() texture:SetVertexColor(1, 1, 1) end)
	end
	
	return texture
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

T.createStatusbar = function(parent, layer, height, width, r, g, b, alpha)
    local bar = CreateFrame"StatusBar"
    bar:SetParent(parent)
    if height then
        bar:SetHeight(height)
    end
    if width then
        bar:SetWidth(width)
    end
	
	if aCoreCDB["OtherOptions"]["style"] == 1 then
		bar:SetStatusBarTexture(G.media.blank)
	else
		bar:SetStatusBarTexture(G.media.ufbar)
	end
	
    bar:SetStatusBarColor(r, g, b, alpha)
	
	bar.bg = bar:CreateTexture(nil, "BACKGROUND")
	if aCoreCDB["OtherOptions"]["style"] == 1 then
		bar.bg:SetTexture(G.media.blank)
	else
		bar.bg:SetTexture(G.media.ufbar)
	end
	bar.bg:SetAllPoints(true)
	
    bar:GetStatusBarTexture():SetHorizTile(false)
    bar:GetStatusBarTexture():SetVertTile(false)
	
    return bar
end

T.CheckRole = function()
	local role
	local tree = GetSpecialization()
	if (G.myClass == "MONK" and tree == 2) or (G.myClass == "PRIEST" and (tree == 1 or tree ==2)) or (G.myClass == "PALADIN" and tree == 1) or (G.myClass == "DRUID" and tree == 4) or (G.myClass == "SHAMAN" and tree == 3) then
		role = "healer"
	else
		role = "dpser"
	end
	return role
end