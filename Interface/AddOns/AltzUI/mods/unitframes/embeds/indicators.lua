local T, C, L, G = unpack(select(2, ...))
local oUF = AltzUF or oUF

local x = "8"
local bigmark = 11
local smallmark = 5
local timersize = 12

-- [[ Healers' indicators ]] -- 

-- Priest 牧师
local pomCount = {"①","②","③","④","⑤","⑥","⑦","⑧","⑨","⑩"}
oUF.Tags.Methods['Mlight:pom'] = function(u) -- 愈合祷言
    local name, _,_, c, _,_,_, fromwho = UnitBuff(u, GetSpellInfo(41635))
    if fromwho == "player" then
        if c and c ~= 0 then return "|cff66FFFF"..pomCount[c].."|r" end
    else
        if c and c ~= 0 then return "|cffFFCF7F"..pomCount[c].."|r" end 
    end
end
oUF.Tags.Events['Mlight:pom'] = "UNIT_AURA"

oUF.Tags.Methods['Mlight:atonement'] = function(u) -- 救赎
    local name, _,_,_,_,_, expirationTime, fromwho = UnitBuff(u, GetSpellInfo(194384))
    if(fromwho == "player") then
        local spellTimer = expirationTime - GetTime()
        return "|cffFFE4C4"..T.FormatTime(spellTimer).."|r"
    end
end
oUF.Tags.Events['Mlight:atonement'] = "UNIT_AURA"

oUF.Tags.Methods['Mlight:rnw'] = function(u) -- 恢复
    local name, _,_,_,_,_, expirationTime, fromwho = UnitBuff(u, GetSpellInfo(139))
    if(fromwho == "player") then
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
	local pws_time, perc, r, g, b, colorstr
	
	local pws, _,_,_,_,_, pws_expiration = UnitBuff(u, GetSpellInfo(17), nil, "PLAYER")
	if pws then
		pws_time = T.FormatTime(pws_expiration-GetTime())
		
		real_absorb = select(17, UnitBuff(u, GetSpellInfo(17), nil, "PLAYER"))
		max_absorb = tostring(string.match(gsub(gsub(GetSpellDescription(17), ",", ""),"%d+","",1),"%d+"))
		
		perc = real_absorb/max_absorb
		
		r, g, b = T.ColorGradient(perc, 1, 0, 0, 1, 1, 0, 0, 1, 0)
		colorstr = ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
		
		return colorstr..pws_time.."|r"
	end
end
oUF.Tags.Events['Mlight:pws'] = "UNIT_AURA UNIT_ABSORB_AMOUNT_CHANGED"

oUF.Tags.Methods['Mlight:yzdx'] = function(u) -- 意志洞悉
	local yzdx_time, perc, r, g, b, colorstr
	
	local yzdx, _,_,_,_,_, yzdx_expiration = UnitBuff(u, GetSpellInfo(152118), nil, "PLAYER")
	if yzdx then
		yzdx_time = T.FormatTime(yzdx_expiration-GetTime())
		
		real_absorb = select(17, UnitBuff(u, GetSpellInfo(152118), nil, "PLAYER"))
		max_absorb = tostring(string.match(gsub(gsub(GetSpellDescription(152118), ",", ""),"%d+","",1),"%d+"))*2.5
		
		perc = real_absorb/max_absorb
		r, g, b = T.ColorGradient(perc, 0, 0, 1, 0, 1, 1, 1, 1, 1)
		colorstr = ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)

		return colorstr..yzdx_time.."|r"
	end
end
oUF.Tags.Events['Mlight:yzdx'] = "UNIT_AURA UNIT_ABSORB_AMOUNT_CHANGED" 
 
-- Druid 德鲁伊
oUF.Tags.Methods['Mlight:lb'] = function(u) -- 生命绽放
    local name, _,_, c,_,_, expirationTime, fromwho = UnitBuff(u, GetSpellInfo(33763))
    if(fromwho == "player") then
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
    local name, _,_,_,_,_, expirationTime, fromwho = UnitBuff(u, GetSpellInfo(774))
    if(fromwho == "player") then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = T.FormatTime(spellTimer)
        if spellTimer > 0 then
            return "|cffFF00BB"..TimeLeft.."|r"
        end
    end
end
oUF.Tags.Events['Mlight:rejuv'] = "UNIT_AURA"

oUF.Tags.Methods['Mlight:regrow'] = function(u) -- 愈合
	local name, _,_,_,_,_, expirationTime, fromwho = UnitBuff(u, GetSpellInfo(8936))
    if(fromwho == "player") then
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
	local name, _,_,_,_,_, expirationTime, fromwho = UnitBuff(u, GetSpellInfo(48438))
    if(fromwho == "player") then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = T.FormatTime(spellTimer)
        return "|cff33FF33"..TimeLeft.."|r"
    end
end
oUF.Tags.Events['Mlight:wildgrowth'] = "UNIT_AURA"

-- Shaman 萨满
oUF.Tags.Methods['Mlight:ripTime'] = function(u) --激流
    local name, _,_,_,_,_, expirationTime, fromwho = UnitBuff(u, GetSpellInfo(61295))
    if(fromwho == "player") then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = T.FormatTime(spellTimer)
        if spellTimer > 0 then
            return "|cff00FFDD"..TimeLeft.."|r"
        end
    end
end
oUF.Tags.Events['Mlight:ripTime'] = 'UNIT_AURA'

-- Paladin 骑士
oUF.Tags.Methods['Mlight:beacon'] = function(u) if UnitBuff(u, GetSpellInfo(53563)) then return "|cffFFB90FO|r" end end --道标
oUF.Tags.Events['Mlight:beacon'] = "UNIT_AURA"

oUF.Tags.Methods['Mlight:forbearance'] = function(u) if UnitDebuff(u, GetSpellInfo(25771)) then return "|cffFF9900"..x.."|r" end end
oUF.Tags.Events['Mlight:forbearance'] = "UNIT_AURA" -- 自律

-- Monk 武僧
oUF.Tags.Methods['Mlight:zs'] = function(u) -- 禅意珠
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(124081))
    if(fromwho == "player") then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = T.FormatTime(spellTimer)
        if spellTimer > 0 then
            return "|cff00FBFF"..TimeLeft.."|r"
        end
    end
end
oUF.Tags.Events['Mlight:zs'] = 'UNIT_AURA'

oUF.Tags.Methods['Mlight:sooth'] = function(u)-- 抚慰之雾
	local name, _,_,_,_,_, _, fromwho = UnitAura(u, GetSpellInfo(115175))
	if (fromwho == "player") then
		return "|cff97FFFF"..x.."|r"
	end
end 
oUF.Tags.Events['Mlight:sooth'] = "UNIT_AURA"

oUF.Tags.Methods['Mlight:mist'] = function(u) -- 氤氲之雾
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(124682))
    if(fromwho == "player") then
        local spellTimer = (expirationTime-GetTime())
		local TimeLeft = T.FormatTime(spellTimer)
        if spellTimer > 0 then
            return "|cffEEB422"..TimeLeft.."|r"
        end
    end
end 
oUF.Tags.Events['Mlight:mist'] = 'UNIT_AURA'

oUF.Tags.Methods['Mlight:remist'] = function(u) -- 复苏之雾
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(115151))
    if(fromwho == "player") then
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
        ["TL"] = "[Mlight:lb]",
        ["BR"] = "",
        ["BL"] = "[Mlight:wildgrowth]",
        ["TR"] = "[Mlight:regrow]",
        ["Cen"] = "[Mlight:rejuv]",
    },
    ["PRIEST"] = {
        ["TL"] = "[Mlight:rnw][Mlight:pws]",
        ["BR"] = "",
        ["BL"] = "[Mlight:yzdx]",
        ["TR"] = "[Mlight:pom]",
        ["Cen"] = "[Mlight:atonement]",
    },
    ["PALADIN"] = {
        ["TL"] = "",
        ["BR"] = "",
        ["BL"] = "",
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
        ["TR"] = "",
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
        ["TR"] = "[Mlight:zs]",
        ["Cen"] = "[Mlight:sooth]",
    },
	["DEMONHUNTER"] = {
        ["TL"] = "",
        ["BR"] = "",
        ["BL"] = "",
        ["TR"] = "",
        ["Cen"] = "",
    },
}

local update = .25

local Enable = function(self)
    if(self.AltzIndicators) then
		-- 左中 数字
        self.AuraStatusBL = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusBL:ClearAllPoints()
        self.AuraStatusBL:SetPoint("LEFT", 1, 0)
		self.AuraStatusBL:SetJustifyH("LEFT")
        self.AuraStatusBL:SetFont(G.norFont, timersize, "OUTLINE")
        self.AuraStatusBL.frequentUpdates = update
        self:Tag(self.AuraStatusBL, classIndicators[G.myClass]["BL"])	
		
		-- 右下 符号
		self.AuraStatusBR = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusBR:ClearAllPoints()
        self.AuraStatusBR:SetPoint("BOTTOMRIGHT", 3, 0)
		self.AuraStatusBR:SetJustifyH("RIGHT")
        self.AuraStatusBR:SetFont(G.symbols, smallmark, "OUTLINE")
        self.AuraStatusBR.frequentUpdates = update
        self:Tag(self.AuraStatusBR, classIndicators[G.myClass]["BR"])
		
		-- 左上 数字
        self.AuraStatusTL = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusTL:ClearAllPoints()
        self.AuraStatusTL:SetPoint("TOPLEFT", 1, 0)
		self.AuraStatusTL:SetJustifyH("LEFT")
        self.AuraStatusTL:SetFont(G.norFont, timersize, "OUTLINE")
        self.AuraStatusTL.frequentUpdates = update
        self:Tag(self.AuraStatusTL, classIndicators[G.myClass]["TL"])
			
		-- 右上
        self.AuraStatusTR = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusTR:ClearAllPoints()
        
		if G.myClass == "DRUID" then
			self.AuraStatusTR:SetPoint("TOPRIGHT", 0, 0)
			self.AuraStatusTR:SetFont(G.norFont, timersize, "OUTLINE") -- 数字
		elseif G.myClass == "PRIEST" or G.myClass == "SHAMAN" or G.myClass == "MONK" then
			self.AuraStatusTR:SetPoint("TOPRIGHT", 0, 0)
			self.AuraStatusTR:SetFont(G.norFont, timersize+3, "OUTLINE") -- 大数字
		else
			self.AuraStatusTR:SetPoint("CENTER", self.Health, "TOPRIGHT", -4, -4) -- 符号
			self.AuraStatusTR:SetFont(G.symbols, bigmark, "OUTLINE")
		end
        self.AuraStatusTR.frequentUpdates = update
        self:Tag(self.AuraStatusTR, classIndicators[G.myClass]["TR"])
		
		-- 中上
        self.AuraStatusCen = self.Health:CreateFontString(nil, "OVERLAY")
       
        self.AuraStatusCen:SetJustifyH("CENTER")
		if G.myClass == "DRUID" or G.myClass == "PRIEST" then
			self.AuraStatusCen:SetFont(ChatFrame1:GetFont(), timersize, "OUTLINE") -- 文字
			self.AuraStatusCen:SetPoint("TOP", 0, 0)
		else
			self.AuraStatusCen:SetFont(G.symbols, smallmark+2, "OUTLINE") -- 符号
			self.AuraStatusCen:SetPoint("TOP", 0, 2)
		end
        self.AuraStatusCen:SetWidth(0)
        self.AuraStatusCen.frequentUpdates = update
        self:Tag(self.AuraStatusCen, classIndicators[G.myClass]["Cen"])
    end
end

oUF:AddElement('AltzIndicators', nil, Enable, nil)
