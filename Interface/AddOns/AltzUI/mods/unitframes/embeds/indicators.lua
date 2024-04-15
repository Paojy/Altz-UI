local T, C, L, G = unpack(select(2, ...))
local oUF = AltzUF or oUF

local x = "8"

-- [[ Healers' indicators ]] -- 

-- Priest 牧师
oUF.Tags.Methods['Mlight:pom'] = function(u) -- 愈合祷言
    local name,_, c = AuraUtil.FindAuraByName(GetSpellInfo(41635), u, "PLAYER|HELPFUL")
	if name and c then
        if c and c ~= 0 then return "|cff66FFFF["..c.."]|r" end
	end
end
oUF.Tags.Events['Mlight:pom'] = "UNIT_AURA"

oUF.Tags.Methods['Mlight:atonement'] = function(u) -- 救赎
    local name, _,_,_,_, expirationTime = AuraUtil.FindAuraByName(GetSpellInfo(194384), u, "PLAYER|HELPFUL")
    if name then
        local spellTimer = expirationTime - GetTime()
        return "|cffFFE4C4"..T.FormatTime(spellTimer).."|r"
    end
end
oUF.Tags.Events['Mlight:atonement'] = "UNIT_AURA"

oUF.Tags.Methods['Mlight:rnw'] = function(u) -- 恢复
    local name,_,_,_,_, expirationTime = AuraUtil.FindAuraByName(GetSpellInfo(139), u, "PLAYER|HELPFUL")
    if name then
        local spellTimer = expirationTime - GetTime()
        if spellTimer > 4 then
            return "|cff33FF33"..T.FormatTime(spellTimer).."|r"
        elseif spellTimer > 2 then
            return "|cffFF9900"..T.FormatTime(spellTimer).."|r"
        else
            return "|cffFF0000"..T.FormatTime(spellTimer).."|r"
        end
    end
end
oUF.Tags.Events['Mlight:rnw'] = "UNIT_AURA"

oUF.Tags.Methods['Mlight:pws'] = function(u) -- 盾
	local spell, pws_time, perc, r, g, b, colorstr
	
	local pws, _,_,_,_, pws_expiration = AuraUtil.FindAuraByName(GetSpellInfo(17), u, "PLAYER|HELPFUL")
	if pws then
		pws_time = T.FormatTime(pws_expiration-GetTime())
		spell = Spell:CreateFromSpellID(17) 
		
		real_absorb = select(16, AuraUtil.FindAuraByName(GetSpellInfo(17), u, "PLAYER|HELPFUL"))
		max_absorb = tostring(string.match(gsub(gsub(GetSpellDescription(spell:GetSpellID()), ",", ""),"%d+","",1),"%d+"))
		
		perc = real_absorb/max_absorb
		
		r, g, b = T.ColorGradient(perc, 1, 0, 0, 1, 1, 0, 0, 1, 0)
		colorstr = ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
		
		return colorstr..pws_time.."|r"
	end
end
oUF.Tags.Events['Mlight:pws'] = "UNIT_AURA UNIT_ABSORB_AMOUNT_CHANGED"

-- Druid 德鲁伊
oUF.Tags.Methods['Mlight:lb'] = function(u) -- 生命绽放
    local name, _, c,_,_, expirationTime = AuraUtil.FindAuraByName(GetSpellInfo(33763), u, "PLAYER|HELPFUL")
    if name then
		local spellTimer = (expirationTime-GetTime())
		local TimeLeft = T.FormatTime(spellTimer)
        if c > 2 then
            return "|cffA7FD0A"..TimeLeft.."|r"
        elseif c > 1 then
            return "|cffFF9900"..TimeLeft.."|r"
        else
            return "|cffFF0000"..TimeLeft.."|r"
        end
    end
end
oUF.Tags.Events['Mlight:lb'] = "UNIT_AURA"

oUF.Tags.Methods['Mlight:rejuv'] = function(u) -- 回春
    local name, _,_,_,_, expirationTime = AuraUtil.FindAuraByName(GetSpellInfo(774), u, "PLAYER|HELPFUL")
	local name2, _,_,_,_, expirationTime2 = AuraUtil.FindAuraByName(GetSpellInfo(155777), u, "PLAYER|HELPFUL")
	local text, text2 = "", ""
    if name then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = T.FormatTime(spellTimer)
        if spellTimer > 0 then
            text = "|cffFF00BB"..TimeLeft.."|r"
        end
    end
	if name2 then
        local spellTimer2 = (expirationTime2-GetTime())
		local TimeLeft2 = T.FormatTime(spellTimer2)
        if spellTimer2 > 0 then
            text2 = "|cffFF6EB4 "..TimeLeft2.."|r"
        end
    end
	if text or text2 then
		return text..text2
	end
end
oUF.Tags.Events['Mlight:rejuv'] = "UNIT_AURA"

oUF.Tags.Methods['Mlight:regrow'] = function(u) -- 愈合
	local name, _,_,_,_, expirationTime = AuraUtil.FindAuraByName(GetSpellInfo(8936), u, "PLAYER|HELPFUL")
    if name then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = T.FormatTime(spellTimer)
        if spellTimer > 3 then
			return "|cffFFA500"..TimeLeft.."|r"
		elseif spellTimer > 0 then
            return "|cff33FF33"..TimeLeft.."|r"
        end
    end
end
oUF.Tags.Events['Mlight:regrow'] = "UNIT_AURA"

oUF.Tags.Methods['Mlight:wildgrowth'] = function(u) -- 野性成长
	local name, _,_,_,_, expirationTime = AuraUtil.FindAuraByName(GetSpellInfo(48438), u, "PLAYER|HELPFUL")
    if name then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = T.FormatTime(spellTimer)
        return "|cff33FF33"..TimeLeft.."|r"
    end
end
oUF.Tags.Events['Mlight:wildgrowth'] = "UNIT_AURA"

oUF.Tags.Methods['Mlight:snla'] = function(u) --塞纳里奥结界
	local name = AuraUtil.FindAuraByName(GetSpellInfo(102351), u, "PLAYER|HELPFUL")
	if name then
		local w = select(10, AuraUtil.FindAuraByName(GetSpellInfo(102351), u, "PLAYER|HELPFUL"))
		if w == 102351 then
			return "|cffFFF8DCY|r"
		else
			return "|cff33FF33b|r"
		end
	end
end
oUF.Tags.Events['Mlight:snla'] = "UNIT_AURA"

-- Shaman 萨满
oUF.Tags.Methods['Mlight:rip40'] = function(u) --激流40%
	if IsEquippedItem(137085) then
		local health, max_health, perc = UnitHealth(u), UnitHealthMax(u)
		if health and max_health and max_health ~= 0 then
			perc = health/max_health
			local startTime, duration = GetSpellCooldown(61295)
			startTime = startTime or 0
			duration = duration or 0
			cd = cd or 0
			if duration <= 1.5 or (startTime+duration-GetTime()) <= 0 then
				if not UnitIsDead(u) and perc < .35 then
					return "|cff76EE00O|r"
				elseif not UnitIsDead(u) and perc < .4 then
					return "|cffFFFF00O|r"
				end
			end
		end
	end
end
oUF.Tags.Events['Mlight:Mlight:rip40'] = 'UNIT_AURA ACTIONBAR_UPDATE_STATE'


oUF.Tags.Methods['Mlight:ripTime'] = function(u) --激流
    local name, _,_,_,_, expirationTime = AuraUtil.FindAuraByName(GetSpellInfo(61295), u, "PLAYER|HELPFUL")
    if name then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = T.FormatTime(spellTimer)
        if spellTimer > 0 then
            return "|cff00FFDD"..TimeLeft.."|r"
        end
    end
end
oUF.Tags.Events['Mlight:ripTime'] = 'UNIT_AURA'

oUF.Tags.Methods['Mlight:ddzd'] = function(u) -- 大地之盾
    local name,_, c = AuraUtil.FindAuraByName(GetSpellInfo(974), u, "PLAYER|HELPFUL")
	if name and c then
        if c and c ~= 0 then return "|cff66FFFF["..c.."]|r" end
	end
end
oUF.Tags.Events['Mlight:ddzd'] = "UNIT_AURA"

-- Paladin 骑士
oUF.Tags.Methods['Mlight:beacon'] = function(u) --道标
    local name, _,_,_,_, expirationTime = AuraUtil.FindAuraByName(GetSpellInfo(53563), u, "PLAYER|HELPFUL")
	local name2, _,_,_,_, expirationTime2 = AuraUtil.FindAuraByName(GetSpellInfo(156910), u, "PLAYER|HELPFUL")
	local name3, _,_,_,_, expirationTime3 = AuraUtil.FindAuraByName(GetSpellInfo(200025), u, "PLAYER|HELPFUL")
	
    if name then
        return "|cffFFB90FO|r"
	elseif name2 then
		return "|cffE0FFFFO|r"
	elseif name3 then
		return "|cff7CFC00O|r"
    end
end
oUF.Tags.Events['Mlight:beacon'] = 'UNIT_AURA'

oUF.Tags.Methods['Mlight:forbearance'] = function(u) if AuraUtil.FindAuraByName(GetSpellInfo(25771), u, "HARMFUL") then return "|cffFF9900"..x.."|r" end end
oUF.Tags.Events['Mlight:forbearance'] = "UNIT_AURA" -- 自律

oUF.Tags.Methods['Mlight:fyxy'] = function(u) -- 赋予信仰
    local name, _,_,_,_, expirationTime = AuraUtil.FindAuraByName(GetSpellInfo(223306), u, "PLAYER|HELPFUL")
    if name then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = T.FormatTime(spellTimer)
        if spellTimer > 0 then
            return "|cff97FFFF"..TimeLeft.."|r"
        end
    end
end
oUF.Tags.Events['Mlight:fyxy'] = 'UNIT_AURA'

oUF.Tags.Methods['Mlight:sgss'] = function(u) -- 圣光闪烁
    local name, _,_,_,_, expirationTime = AuraUtil.FindAuraByName(GetSpellInfo(287280), u, "PLAYER|HELPFUL")
    if name then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = T.FormatTime(spellTimer)
        if spellTimer > 0 then
            return "|cff97FFFF"..TimeLeft.."|r"
        end
    end
end
oUF.Tags.Events['Mlight:sgss'] = 'UNIT_AURA'

-- Monk 武僧
oUF.Tags.Methods['Mlight:jhzq'] = function(u) -- 精华之泉
    local name, _,_,_,_, expirationTime = AuraUtil.FindAuraByName(GetSpellInfo(191840), u, "PLAYER|HELPFUL")
    if name then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = T.FormatTime(spellTimer)
        if spellTimer > 0 then
            return "|cff97FFFF"..TimeLeft.."|r"
        end
    end
end
oUF.Tags.Events['Mlight:jhzq'] = 'UNIT_AURA'

oUF.Tags.Methods['Mlight:sooth'] = function(u)-- 抚慰之雾
	local name = AuraUtil.FindAuraByName(GetSpellInfo(115175), u, "PLAYER|HELPFUL")
	if name then
		return "|cff97FFFF"..x.."|r"
	end
end 
oUF.Tags.Events['Mlight:sooth'] = "UNIT_AURA"

oUF.Tags.Methods['Mlight:mist'] = function(u) -- 氤氲之雾
    local name, _,_,_,_, expirationTime = AuraUtil.FindAuraByName(GetSpellInfo(124682), u, "PLAYER|HELPFUL")
    if name then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = T.FormatTime(spellTimer)
        if spellTimer > 0 then
            return "|cffEEB422"..TimeLeft.."|r"
        end
    end
end 
oUF.Tags.Events['Mlight:mist'] = 'UNIT_AURA'

oUF.Tags.Methods['Mlight:remist'] = function(u) -- 复苏之雾
    local name, _,_,_,_, expirationTime = AuraUtil.FindAuraByName(GetSpellInfo(115151), u, "PLAYER|HELPFUL")
    if name then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = T.FormatTime(spellTimer)
        if spellTimer > 0 then
            return "|cff55FF00"..TimeLeft.."|r"
        end
    end
end 
oUF.Tags.Events['Mlight:remist'] = 'UNIT_AURA'

oUF.Tags.Methods['Mlight:ayj'] = function(u) --暗夜井释放
    local name, _,_,_,_, expirationTime = AuraUtil.FindAuraByName(GetSpellInfo(225724), u, "PLAYER|HELPFUL")
    if name then
        return "|cffAB82FF-|r"
    end
end
oUF.Tags.Events['Mlight:ayj'] = 'UNIT_AURA'

oUF.Tags.Methods['Mlight:lt'] = function(u) --基尔加丹的蓝图
    local name, _,_,_,_, expirationTime = AuraUtil.FindAuraByName(GetSpellInfo(242622), u, "PLAYER|HELPFUL") -- hot
	local name2, _,_,_,_, expirationTime2 = AuraUtil.FindAuraByName(GetSpellInfo(242623), u, "PLAYER|HELPFUL") -- 吸收盾
    if name then
        return "|cffFF3030b|r"
	elseif name2 then
		return "|cffFF3030z|r"
    end
end
oUF.Tags.Events['Mlight:lt'] = 'UNIT_AURA'

oUF.Tags.Methods['Mlight:da'] = function(u) --信仰档案
    local name, _,_,_,_, expirationTime = AuraUtil.FindAuraByName(GetSpellInfo(242619), u, "PLAYER|HELPFUL") -- hot
	local name2, _,_,_,_, expirationTime2 = AuraUtil.FindAuraByName(GetSpellInfo(242621), u, "PLAYER|HELPFUL") -- 吸收盾
    if name then
        return "|cffFFD700b|r"
	elseif name2 then
		local w = select(10, AuraUtil.FindAuraByName(GetSpellInfo(242621), u, "PLAYER|HELPFUL"))
		if w == 242621 then
			return "|cffFFD700z|r"
		end
    end
end
oUF.Tags.Events['Mlight:da'] = 'UNIT_AURA'

oUF.Tags.Methods['Mlight:xnhd'] = function(u) --邪能护盾
    local name, _,_,_,_, expirationTime = AuraUtil.FindAuraByName(GetSpellInfo(344916), u, "PLAYER|HELPFUL")
    if name then
        return "|cffC0FF3Ez|r"
    end
end
oUF.Tags.Events['Mlight:xnhd'] = 'UNIT_AURA'

classIndicators={
    ["DRUID"] = {
        ["TL"] = "[Mlight:regrow]",
        ["BR"] = "[Mlight:xnhd][Mlight:ayj][Mlight:da][Mlight:lt][Mlight:snla]",
        ["BL"] = "[Mlight:wildgrowth]",
        ["TR"] = "[Mlight:rejuv]",
        ["Cen"] = "[Mlight:lb]",
    },
    ["PRIEST"] = {
        ["TL"] = "[Mlight:pws]",
        ["BR"] = "[Mlight:xnhd][Mlight:ayj][Mlight:da][Mlight:lt]",
        ["BL"] = "[Mlight:rnw]",
        ["TR"] = "[Mlight:pom]",
        ["Cen"] = "[Mlight:atonement]",
    },
    ["PALADIN"] = {
        ["TL"] = "[Mlight:sgss]",
        ["BR"] = "[Mlight:xnhd][Mlight:ayj][Mlight:da][Mlight:lt]",
        ["BL"] = "[Mlight:fyxy]",
        ["TR"] = "[Mlight:beacon]",
        ["Cen"] = "[Mlight:forbearance]",
    },
    ["WARLOCK"] = {
        ["TL"] = "",
        ["BR"] = "",
        ["BL"] = "",
        ["TR"] = "",
        ["Cen"] = "",
    },
    ["WARRIOR"] = {
        ["TL"] = "",
        ["BR"] = "",
        ["BL"] = "",
        ["TR"] = "",
        ["Cen"] = "",
    },
    ["DEATHKNIGHT"] = {
        ["TL"] = "",
        ["BR"] = "",
        ["BL"] = "",
        ["TR"] = "",
        ["Cen"] = "",
    },
    ["SHAMAN"] = {
        ["TL"] = "[Mlight:ripTime]",
        ["BR"] = "[Mlight:xnhd][Mlight:ayj][Mlight:da][Mlight:lt][Mlight:rip40]",
        ["BL"] = "",
        ["TR"] = "[Mlight:ddzd]",
        ["Cen"] = "",
    },
    ["HUNTER"] = {
        ["TL"] = "",
        ["BR"] = "",
        ["BL"] = "",
        ["TR"] = "",
        ["Cen"] = "",
    },
    ["ROGUE"] = {
        ["TL"] = "",
        ["BR"] = "",
        ["BL"] = "",
        ["TR"] = "",
        ["Cen"] = "",
    },
    ["MAGE"] = {
        ["TL"] = "",
        ["BR"] = "",
        ["BL"] = "",
        ["TR"] = "",
        ["Cen"] = "",
    },
	["MONK"] = {
        ["TL"] = "[Mlight:remist]",
        ["BR"] = "[Mlight:xnhd][Mlight:ayj][Mlight:da][Mlight:lt]",
        ["BL"] = "[Mlight:mist]",
        ["TR"] = "[Mlight:jhzq]",
        ["Cen"] = "[Mlight:sooth]",
    },
	["DEMONHUNTER"] = {
        ["TL"] = "",
        ["BR"] = "",
        ["BL"] = "",
        ["TR"] = "",
        ["Cen"] = "",
    },
	["EVOKER"] = {
        ["TL"] = "",
        ["BR"] = "",
        ["BL"] = "",
        ["TR"] = "",
        ["Cen"] = "",
    },
}

local update = .25

local Enable = function(self)
	local ind = self.AltzIndicators
    if ind then
		ind.__owner = self
		
		-- 左中 数字
		if not ind.AuraStatusBL then
			ind.AuraStatusBL = ind:CreateFontString(nil, "OVERLAY")
			ind.AuraStatusBL:SetPoint("LEFT", 1, 0)
			ind.AuraStatusBL:SetJustifyH("LEFT")
			ind.AuraStatusBL:SetFont(G.norFont, aCoreCDB["UnitframeOptions"]["hotind_size"], "OUTLINE")
			ind.AuraStatusBL.frequentUpdates = update	
		end
		self:Tag(ind.AuraStatusBL, classIndicators[G.myClass]["BL"])
		ind.AuraStatusBL:Show()
		
		-- 右中 符号
		if not ind.AuraStatusBR then
			ind.AuraStatusBR = ind:CreateFontString(nil, "OVERLAY")
			ind.AuraStatusBR:SetPoint("RIGHT", -1, 0)
			ind.AuraStatusBR:SetJustifyH("RIGHT")
			ind.AuraStatusBR:SetFont(G.symbols, aCoreCDB["UnitframeOptions"]["hotind_size"], "OUTLINE")
			ind.AuraStatusBR.frequentUpdates = update
		end
		self:Tag(ind.AuraStatusBR, classIndicators[G.myClass]["BR"])
		ind.AuraStatusBR:Show()
		
		-- 左上 数字
		if not ind.AuraStatusTL then
			ind.AuraStatusTL = ind:CreateFontString(nil, "OVERLAY")
			ind.AuraStatusTL:SetPoint("TOPLEFT", 1, 0)
			ind.AuraStatusTL:SetJustifyH("LEFT")
			ind.AuraStatusTL:SetFont(G.norFont, aCoreCDB["UnitframeOptions"]["hotind_size"], "OUTLINE")
			ind.AuraStatusTL.frequentUpdates = update
		end
		self:Tag(ind.AuraStatusTL, classIndicators[G.myClass]["TL"])
		ind.AuraStatusTL:Show()
		
		-- 右上
		if not ind.AuraStatusTR then
			ind.AuraStatusTR = ind:CreateFontString(nil, "OVERLAY")
			if G.myClass == "DRUID" or G.myClass == "MONK" or G.myClass == "PRIEST" or G.myClass == "SHAMAN" then
				ind.AuraStatusTR:SetPoint("TOPRIGHT", 0, 0)
				ind.AuraStatusTR:SetFont(G.norFont, aCoreCDB["UnitframeOptions"]["hotind_size"], "OUTLINE") -- 数字
			else
				ind.AuraStatusTR:SetPoint("CENTER", ind, "TOPRIGHT", -4, -4)
				ind.AuraStatusTR:SetFont(G.symbols, aCoreCDB["UnitframeOptions"]["hotind_size"], "OUTLINE") -- 符号
			end
			ind.AuraStatusTR.frequentUpdates = update			
		end
		self:Tag(ind.AuraStatusTR, classIndicators[G.myClass]["TR"])
		ind.AuraStatusTR:Show()
		
		-- 中上
		if not ind.AuraStatusCen then
			ind.AuraStatusCen = ind:CreateFontString(nil, "OVERLAY")
			ind.AuraStatusCen:SetJustifyH("CENTER")
			if G.myClass == "DRUID" or G.myClass == "PRIEST" then
				ind.AuraStatusCen:SetFont(G.norFont, aCoreCDB["UnitframeOptions"]["hotind_size"], "OUTLINE") -- 文字
				ind.AuraStatusCen:SetPoint("TOP", 0, 0)
			else
				ind.AuraStatusCen:SetFont(G.symbols, aCoreCDB["UnitframeOptions"]["hotind_size"]/2, "OUTLINE") -- 符号
				ind.AuraStatusCen:SetPoint("TOP", 0, 2)
			end
			ind.AuraStatusCen:SetWidth(0)
			ind.AuraStatusCen.frequentUpdates = update
		end
		self:Tag(ind.AuraStatusCen, classIndicators[G.myClass]["Cen"])
		ind.AuraStatusCen:Show()
		
		return true
    end
end

local Disable = function(self)
	local ind = self.AltzIndicators
    if ind then
		ind.AuraStatusBL:Hide()
		self:Untag(ind.AuraStatusBL)
		
		ind.AuraStatusBR:Hide()
		self:Untag(ind.AuraStatusBR)
		
		ind.AuraStatusTL:Hide()
		self:Untag(ind.AuraStatusTL)
		
		ind.AuraStatusTR:Hide()
		self:Untag(ind.AuraStatusTR)
		
		ind.AuraStatusCen:Hide()
		self:Untag(ind.AuraStatusCen)
	end
end

oUF:AddElement('AltzIndicators', nil, Enable, Disable)