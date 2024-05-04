local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)

----------------------------
-- 			通用		  --
----------------------------
T.dummy = function() end

T.multicheck = function(check, ...)
	for i=1, select("#", ...) do
		if check == select(i, ...) then return true end
	end
	return false
end

T.CheckRole = function()
	local tree = GetSpecialization()
	if tree then
		local role = select(5, GetSpecializationInfo(tree))
		if role == "HEALER" then
			return "healer"
		else
			return "dpser"
		end
	end
end

T.GetSpecID = function()
	local specIndex, specID = GetSpecialization(), "nospec"
	if specIndex and specIndex ~= 5 then
		specID = GetSpecializationInfo(specIndex)
	end
	return specID
end

-- 通过ID查找光环
local function SpellIDPredicate(auraSpellIDToFind, _, _, _, _, _, _, _, _, _, _, _, spellID)
	return auraSpellIDToFind == spellID
end

function T.FindAuraBySpellID(spellID, unit, filter)
	return AuraUtil.FindAura(SpellIDPredicate, unit, filter, spellID)
end

-- 获取NPCID
T.GetUnitNpcID = function(unit)
	local guid = UnitGUID(unit)
	if guid then
		return select(6, strsplit("-", guid))
	end
end

-- 获取装备ID
G.SLOTS = {}
for _,slot in pairs({"Head", "Shoulder", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "MainHand", "SecondaryHand"}) do 
	G.SLOTS[slot] = GetInventorySlotInfo(slot .. "Slot")
end
----------------------------
-- 			表格		  --
----------------------------
T.pairsByKeys = function(t)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a)
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
		i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
      end
    return iter
end

T.table_remove = function(t, v)
	local index = 1
	while t[index] do
		if ( t[index] == v ) then 
			table.remove(t, index)
			return 
		end
		index = index + 1
	end
end
----------------------------
-- 			材质		  --
----------------------------
local arrowDegree = {
	["up"] = 0,
	["down"] = 180,
	["left"] = 90,
	["right"] = -90,
}

T.SetupArrow = function(tex, direction)
	tex:SetTexture([[Interface\AddOns\AltzUI\media\arrow.tga]])
	tex:SetRotation(rad(arrowDegree[direction]))
end

----------------------------
-- 			文本		  --
----------------------------
-- 文本缩写
T.utf8sub = function(str, i)
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
				return string.sub(str, 1, pos - 1)
			else
				return str
			end
		end
	end
end

-- 内存
T.memFormat = function(num)
	if num > 1024 then
		return format("%.2f mb", (num / 1024))
	else
		return format("%.1f kb", floor(num))
	end
end

-- 数值缩写
T.ShortValue = function(val)
	if type(val) == "number" then
		if aCoreCDB["SkinOptions"]["formattype"] == "w" then
			if (val >= 1e7) then
				return ("%.1fkw"):format(val / 1e7)
			elseif (val >= 1e4) then
				return ("%.1fw"):format(val / 1e4)
			else
				return ("%d"):format(val)
			end
		elseif aCoreCDB["SkinOptions"]["formattype"] == "w_chinese" then
			if (val >= 1e7) then
				return ("%.1f千万"):format(val / 1e7)
			elseif (val >= 1e4) then
				return ("%.1f万"):format(val / 1e4)
			else
				return ("%d"):format(val)
			end
		elseif aCoreCDB["SkinOptions"]["formattype"] == "k" then
			if (val >= 1e6) then
				return ("%.1fm"):format(val / 1e6)
			elseif (val >= 1e3) then
				return ("%.1fk"):format(val / 1e3)
			else
				return ("%d"):format(val)
			end
		else
			return ("%d"):format(val)
		end
	else
		return val
	end
end

-- 时间格式
local day, hour, minute = 86400, 3600, 60
T.FormatTime = function(s)
	if s >= day then
		return format("%dd", floor(s/day + 0.5))
	elseif s >= hour then
		return format("%dh", floor(s/hour + 0.5))
	elseif s >= minute then
		return format("%dm", floor(s/minute + 0.5))
	else
		return format("%d", math.fmod(s, minute))
	end
end

-- 染色
T.hex_str = function(str, r, g, b)
	return ('|cff%02x%02x%02x%s|r'):format(r * 255, g * 255, b * 255, str)
end

-- 插件主题色
T.color_text = function(text)
	return string.format(G.addon_colorStr.."%s|r", text)
end

-- 根据数值渐变颜色
local ColorGradient = function(perc, ...)-- http://www.wowwiki.com/ColorGradient
	local r, g, b, r1, g1, b1, r2, g2, b2
	if (perc >= 1) then
		r, g, b = select(select('#', ...) - 2, ...)
		return r, g, b
	elseif (perc < 0) then
		r, g, b = ...
		return r, g, b
	else
		local num = select('#', ...) / 3

		local segment, relperc = math.modf(perc*(num-1))
		r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

		r, g, b = r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
		return r, g, b
	end
end

T.ColorGradient = function(perc, max_color)
	local r, g, b
	if max_color == "red" then
		r, g, b = ColorGradient(perc, 0, 1, 0, 1, 1, 0, 1, 0, 0)
	else
		r, g, b = ColorGradient(perc, 1, 0, 0, 1, 1, 0, 0, 1, 0)
	end
	return r, g, b
end

-- 创建文本
T.createtext = function(f, layer, fontsize, flag, justifyh)
	local text = f:CreateFontString(nil, layer)
	text:SetFont(G.norFont, fontsize, flag)
	text:SetJustifyH(justifyh or "CENTER")
	return text
end

-- 创建数字
T.createnumber = function(f, layer, fontsize, flag, justifyh)
	local text = f:CreateFontString(nil, layer)
	text:SetFont(G.numFont, fontsize, flag)
	text:SetJustifyH(justifyh)
	return text
end

-- 材质转文本
T.GetTexStr = function(tex, size)
	local s = size or 12
	return "|T"..tex..":"..s..":"..s..":0:0:64:64:4:60:4:60|t"
end

-- 法术图标
T.GetSpellIcon = function(spellID)
	local icon = select(3, GetSpellInfo(spellID))
	if icon then
		return "|T"..icon..":14:14:0:0:64:64:4:60:4:60|t"
	else
		print(spellID, "bug")
	end
end

-- 法术图标和链接
T.GetIconLink = function(spellID)
	local icon = select(3, GetSpellInfo(spellID))
	return "|T"..icon..":14:14:0:0:64:64:4:60:4:60|t"..GetSpellLink(spellID)
end

-- 非中文文本中间加空格
T.split_words = function(...)
	local words = {...}
	if string.find(G.Client, "zh") then
		return table.concat(words, "")
	else
		return table.concat(words, " ")
	end
end
---------------------------
--  	边框背景		  --
----------------------------
-- 像素边框
T.createPXBackdrop = function(anchor, alpha, border_size, parent)
	local parent_frame = parent or anchor
	local bd_frame = CreateFrame("Frame", nil, parent_frame, "BackdropTemplate")
	local size = border_size or 1
	
	local flvl = parent_frame:GetFrameLevel()
	if flvl - 1 >= 0 then bd_frame:SetFrameLevel(flvl-1) end

	bd_frame:SetPoint("TOPLEFT", anchor, "TOPLEFT", -size, size)
	bd_frame:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", size, -size)
	bd_frame:SetBackdrop({
		edgeFile = G.media.blank,
		edgeSize = size,
		bgFile = G.media.blank,
		insets = {left = size, right = size, top = size, bottom = size}
	})
	
	bd_frame:SetBackdropColor(.05, .05, .05, alpha or 0)
	bd_frame:SetBackdropBorderColor(0, 0, 0)

	return bd_frame
end

-- 毛绒边框
T.createBackdrop = function(anchor, alpha, border_size, parent)
	local parent_frame = parent or anchor
	local bd_frame = CreateFrame("Frame", nil, parent_frame, "BackdropTemplate")
	local size = border_size or 3
	
	local flvl = parent_frame:GetFrameLevel()
	if flvl - 1 >= 0 then bd_frame:SetFrameLevel(flvl-1) end

	bd_frame:SetPoint("TOPLEFT", anchor, "TOPLEFT", -size, size)
	bd_frame:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", size, -size)
	bd_frame:SetBackdrop({
		edgeFile = G.media.glow,
		edgeSize = size,
		bgFile = G.media.blank,
		insets = {left = size, right = size, top = size, bottom = size}
	})
	
	bd_frame:SetBackdropColor(.05, .05, .05, alpha or 0)
	bd_frame:SetBackdropBorderColor(0, 0, 0)

	return bd_frame
end

-- 像素边框材质
T.setPXBackdrop = function(bd_frame, alpha, border_size)
	local size = border_size or 1
	
	bd_frame:SetBackdrop({
		edgeFile = G.media.blank,
		edgeSize = size,
		bgFile = G.media.blank,
		insets = {left = size, right = size, top = size, bottom = size}
	})
	
	bd_frame:SetBackdropColor(.05, .05, .05, alpha or 0)
	bd_frame:SetBackdropBorderColor(0, 0, 0)
end

-- 毛绒边框材质
T.setBackdrop = function(bd_frame, alpha, border_size)
	local size = border_size or 3
	
	bd_frame:SetBackdrop({
		edgeFile = G.media.glow,
		edgeSize = size,
		bgFile = G.media.blank,
		insets = {left = size, right = size, top = size, bottom = size}
	})

	bd_frame:SetBackdropColor(.05, .05, .05, alpha or 0)
	bd_frame:SetBackdropBorderColor(0, 0, 0)
end

-- 材质背景
T.createTexBackdrop = function(parent, anchor, drawlayer)
	local bd = parent:CreateTexture(nil, drawlayer or "BORDER", nil, 3)
	bd:SetPoint("TOPLEFT", anchor or parent, "TOPLEFT", -1, 1)
	bd:SetPoint("BOTTOMRIGHT", anchor or parent, "BOTTOMRIGHT", 1, -1)
	bd:SetTexture(G.media.blank)
	bd:SetVertexColor(0, 0, 0)
	
	return bd
end

-- 条纹背景
T.setStripeBg = function(bd_frame, anchor)
	local tex = bd_frame:CreateTexture(nil, "BACKGROUND", nil, 1)
	tex:SetAllPoints(anchor or bd_frame)
	tex:SetTexture([[Interface\AddOns\AltzUI\media\stripeTex]], true, true)
	tex:SetHorizTile(true)
	tex:SetVertTile(true)
	tex:SetBlendMode("ADD")
end

T.setStripBD = function(frame)
	local bd = T.createBackdrop(frame, .6)
	T.setStripeBg(bd)
	return bd
end

----------------------------
-- 			模型		  --
----------------------------
T.CreateCreatureModel = function(parent, width, height, points, creatureID, position, scale)
	local model = CreateFrame("PlayerModel", nil, parent)
	model:SetSize(width, height)
	model:SetPosition(unpack(position))
	model:SetPoint(unpack(points))
	model:SetDisplayInfo(creatureID)
	if scale then
		model:SetCamDistanceScale(scale)
	end
	return model
end
----------------------------
--  	  计量条		  --
----------------------------

T.createStatusbar = function(parent, height, width, r, g, b, alpha)
	local bar = CreateFrame("StatusBar", nil, parent)
	bar:SetStatusBarTexture(G.media.blank)
	if height then
		bar:SetHeight(height)
	end
	if width then
		bar:SetWidth(width)
	end
	if r and g and b then
		bar:SetStatusBarColor(r, g, b)
	end
	if alpha then
		bar:SetAlpha(alpha)
	end

	bar:GetStatusBarTexture():SetHorizTile(false)
	bar:GetStatusBarTexture():SetVertTile(false)
	
	return bar
end

----------------------------
--  	选项皮肤		  --
----------------------------

-- 勾选选项
T.ReskinCheck = function(bu, fontsize)
	F.ReskinCheck(bu)
	
	bu:SetSize(25, 25)
	
	local ch = bu:GetCheckedTexture()
	ch:SetAtlas("checkmark-minimal")
	ch:SetDesaturated(true)
	ch:SetTexCoord(0, 1, 0, 1)
	ch:SetVertexColor(0, 1, .3)
	
	local ch2 = bu:GetDisabledCheckedTexture()
	ch2:SetAtlas("checkmark-minimal")
	ch2:SetDesaturated(true)
	ch2:SetTexCoord(0, 1, 0, 1)
	ch2:SetVertexColor(.5, .5, .5)
	
	if bu.Text then
		local fs = fontsize or 12
		bu.Text:SetFont(G.norFont, fs, "OUTLINE")
	end
end

-- 多选一选项
T.ReskinRadio =  function(bu, fontsize)
	F.ReskinRadio(bu)
	
	local ch = bu:GetCheckedTexture()
	ch:SetVertexColor(0, .9, .3, 1)
	
	if bu.text then
		local fs = fontsize or 12
		bu.text:SetFont(G.norFont, fs, "OUTLINE")
	end
end

-- 滚动条
T.ReskinScroll = function(ScrollBar)
	F.ReskinScroll(ScrollBar)
end

-- 关闭按钮
T.ReskinClose = function(bu)
	F.ReskinClose(bu)
end

-- 滑动条
T.ReskinSlider = function(slider, fontsize)
	F.ReskinSlider(slider)
	
	if slider.Low then
		slider.Low:ClearAllPoints()
		slider.Low:SetPoint("RIGHT", slider, "LEFT", 15, 0)
		slider.Low:SetFont(G.norFont, 10, "OUTLINE")
	end
	
	if slider.High then
		slider.High:ClearAllPoints()
		slider.High:SetPoint("LEFT", slider, "RIGHT", -15, 0)
		slider.High:SetFont(G.norFont, 10, "OUTLINE")
	end
	
	if slider.Text then
		local fs = fontsize or 12
		slider.Text:ClearAllPoints()
		slider.Text:SetPoint("BOTTOM", slider, "TOP", 0, 3)
		slider.Text:SetFont(G.norFont, fs, "OUTLINE")
	end
	
	slider.Thumb:SetSize(25, 16)
end

-- 按钮
T.ReskinButton = function(bu, fontsize, noHighlight, override)
	F.Reskin(bu, noHighlight, override)
	if bu.Text then
		local fs = fontsize or 12
		bu.Text:SetFont(G.norFont, fs, "OUTLINE")
	end
end

-- 下拉菜单
T.ReskinDropDown = function(dd, fontsize)
	F.ReskinDropDown(dd)
	local fs = fontsize or 12
	dd.Text:SetFont(G.norFont, fs, "OUTLINE")
end

-- 标签
T.ReskinTab = function(tab)
	F.ReskinTab(tab)
end