local T, C, L, G = unpack(select(2, ...))
local oUF = AltzUF or oUF

local x = "8"

-- [[ Healers' indicators ]] -- 

-- Priest 牧师
oUF.Tags.Methods['Mlight:pom'] = function(u) -- 愈合祷言
    local name,_, c = T.FindAuraBySpellID(41635, u, "PLAYER|HELPFUL")
	if name and c then
        if c and c ~= 0 then return "|cff66FFFF["..c.."]|r" end
	end
end
oUF.Tags.Events['Mlight:pom'] = "UNIT_AURA"

oUF.Tags.Methods['Mlight:atonement'] = function(u) -- 救赎
    local name, _,_,_,_, expirationTime = T.FindAuraBySpellID(194384, u, "PLAYER|HELPFUL")
    if name then
        local spellTimer = expirationTime - GetTime()
        return "|cffFFE4C4"..T.FormatTime(spellTimer).."|r"
    end
end
oUF.Tags.Events['Mlight:atonement'] = "UNIT_AURA"

oUF.Tags.Methods['Mlight:rnw'] = function(u) -- 恢复
    local name,_,_,_,_, expirationTime = T.FindAuraBySpellID(139, u, "PLAYER|HELPFUL")
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
	local pws, _,_,_,_, pws_expiration = T.FindAuraBySpellID(17, u, "PLAYER|HELPFUL")
	if pws then
		local pws_time = T.FormatTime(pws_expiration-GetTime())
		
		return "|cffFFFF00"..pws_time.."|r"
	end
end
oUF.Tags.Events['Mlight:pws'] = "UNIT_AURA"

-- Druid 德鲁伊
oUF.Tags.Methods['Mlight:lb'] = function(u) -- 生命绽放
    local name, _, c,_,_, expirationTime = T.FindAuraBySpellID(33763, u, "PLAYER|HELPFUL")
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
    local name, _,_,_,_, expirationTime = T.FindAuraBySpellID(774, u, "PLAYER|HELPFUL")
	local name2, _,_,_,_, expirationTime2 = T.FindAuraBySpellID(155777, u, "PLAYER|HELPFUL")
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
	local name, _,_,_,_, expirationTime = T.FindAuraBySpellID(8936, u, "PLAYER|HELPFUL")
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
	local name, _,_,_,_, expirationTime = T.FindAuraBySpellID(48438, u, "PLAYER|HELPFUL")
    if name then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = T.FormatTime(spellTimer)
        return "|cff33FF33"..TimeLeft.."|r"
    end
end
oUF.Tags.Events['Mlight:wildgrowth'] = "UNIT_AURA"

oUF.Tags.Methods['Mlight:snla'] = function(u) --塞纳里奥结界
	local name = T.FindAuraBySpellID(102351, u, "PLAYER|HELPFUL")
	local name2 = T.FindAuraBySpellID(102352, u, "PLAYER|HELPFUL")
	if name then
		return "|cffFFF8DCY|r"
	elseif name2 then
		return "|cff33FF33b|r"
	end
end
oUF.Tags.Events['Mlight:snla'] = "UNIT_AURA"

-- Shaman 萨满
oUF.Tags.Methods['Mlight:ripTime'] = function(u) --激流
    local name, _,_,_,_, expirationTime = T.FindAuraBySpellID(61295, u, "PLAYER|HELPFUL")
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
    local name,_, c = T.FindAuraBySpellID(974, u, "PLAYER|HELPFUL")
	if name and c then
        if c and c ~= 0 then return "|cff66FFFF["..c.."]|r" end
	end
end
oUF.Tags.Events['Mlight:ddzd'] = "UNIT_AURA"

-- Paladin 骑士
oUF.Tags.Methods['Mlight:beacon'] = function(u) --道标
    local name, _,_,_,_, expirationTime = T.FindAuraBySpellID(53563, u, "PLAYER|HELPFUL")
	local name2, _,_,_,_, expirationTime2 = T.FindAuraBySpellID(156910, u, "PLAYER|HELPFUL")
	local name3, _,_,_,_, expirationTime3 = T.FindAuraBySpellID(200025, u, "PLAYER|HELPFUL")
	
    if name then
        return "|cffFFB90FO|r"
	elseif name2 then
		return "|cffE0FFFFO|r"
	elseif name3 then
		return "|cff7CFC00O|r"
    end
end
oUF.Tags.Events['Mlight:beacon'] = 'UNIT_AURA'

oUF.Tags.Methods['Mlight:forbearance'] = function(u) -- 自律
	if T.FindAuraBySpellID(25771, u, "HARMFUL") then
		return "|cffFF9900"..x.."|r" 
	end
end
oUF.Tags.Events['Mlight:forbearance'] = "UNIT_AURA"

oUF.Tags.Methods['Mlight:fyxy'] = function(u) -- 赋予信仰
    local name, _,_,_,_, expirationTime = T.FindAuraBySpellID(223306, u, "PLAYER|HELPFUL")
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
    local name, _,_,_,_, expirationTime = T.FindAuraBySpellID(287280, u, "PLAYER|HELPFUL")
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
    local name, _,_,_,_, expirationTime = T.FindAuraBySpellID(191840, u, "PLAYER|HELPFUL")
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
	local name = T.FindAuraBySpellID(115175, u, "PLAYER|HELPFUL")
	if name then
		return "|cff97FFFF"..x.."|r"
	end
end 
oUF.Tags.Events['Mlight:sooth'] = "UNIT_AURA"

oUF.Tags.Methods['Mlight:mist'] = function(u) -- 氤氲之雾
    local name, _,_,_,_, expirationTime = T.FindAuraBySpellID(124682, u, "PLAYER|HELPFUL")
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
    local name, _,_,_,_, expirationTime = T.FindAuraBySpellID(115151, u, "PLAYER|HELPFUL")
    if name then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = T.FormatTime(spellTimer)
        if spellTimer > 0 then
            return "|cff55FF00"..TimeLeft.."|r"
        end
    end
end 
oUF.Tags.Events['Mlight:remist'] = 'UNIT_AURA'

classIndicators={
    ["DRUID"] = {
        ["TL"] = "[Mlight:regrow]",
        ["BR"] = "[Mlight:snla]",
        ["BL"] = "[Mlight:wildgrowth]",
        ["TR"] = "[Mlight:rejuv]",
        ["Cen"] = "[Mlight:lb]",
    },
    ["PRIEST"] = {
        ["TL"] = "[Mlight:pws]",
        ["BR"] = "",
        ["BL"] = "[Mlight:rnw]",
        ["TR"] = "[Mlight:pom]",
        ["Cen"] = "[Mlight:atonement]",
    },
    ["PALADIN"] = {
        ["TL"] = "[Mlight:sgss]",
        ["BR"] = "",
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
        ["BR"] = "",
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
        ["BR"] = "",
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