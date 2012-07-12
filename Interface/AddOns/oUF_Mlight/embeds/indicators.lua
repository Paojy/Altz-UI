local ADDON_NAME, ns = ...
local cfg = ns.cfg

local x = "M"
local indicatorsize = 6
local symbolsize = 11
local fontsizeEdge = 12

local getTime = function(expirationTime)
    local expire = (expirationTime-GetTime())
    local timeleft = ns.siValue(expire)
    if expire > 0.5 then
        return ("|cffffff00"..timeleft.."|r")
    end
end

-- Priest 牧师
local pomCount = {"i","h","g","f","Z","Y"}
oUF.Tags.Methods['freebgrid:pom'] = function(u) -- 愈合祷言
    local name, _,_, c, _,_,_, fromwho = UnitAura(u, GetSpellInfo(41635)) 
    if fromwho == "player" then
        if(c) then return "|cff66FFFF"..pomCount[c].."|r" end 
    else
        if(c) then return "|cffFFCF7F"..pomCount[c].."|r" end 
    end
end
oUF.Tags.Events['freebgrid:pom'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:rnw'] = function(u) -- 恢复 小方块
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(139))
    if(fromwho == "player") then
        local spellTimer = GetTime() - expirationTime
        if spellTimer > -2 then
            return "|cffFF0000"..x.."|r"
        elseif spellTimer > -4 then
            return "|cffFF9900"..x.."|r"
        else
            return "|cff33FF33"..x.."|r"
        end
    end
end
oUF.Tags.Events['freebgrid:rnw'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:rnwTime'] = function(u) -- 恢复 秒数
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(139))
    if(fromwho == "player") then return getTime(expirationTime) end 
end
oUF.Tags.Events['freebgrid:rnwTime'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:pws'] = function(u) if UnitAura(u, GetSpellInfo(17)) then return "|cff33FF33"..x.."|r" end end -- 盾
oUF.Tags.Events['freebgrid:pws'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:ws'] = function(u) if UnitDebuff(u, GetSpellInfo(6788)) then return "|cffFF9900"..x.."|r" end end -- 虚弱灵魂
oUF.Tags.Events['freebgrid:ws'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:fort'] = function(u) if not (UnitAura(u, GetSpellInfo(21562)) or UnitAura(u, GetSpellInfo(6307)) or UnitAura(u, GetSpellInfo(469))) then return "|cffE0FFFF"..x.."|r" end end -- 韧 小鬼 命令怒吼
oUF.Tags.Events['freebgrid:fort'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:pwb'] = function(u) if UnitAura(u, GetSpellInfo(81782)) then return "|cffEEEE00"..x.."|r" end end -- 真言术：障
oUF.Tags.Events['freebgrid:pwb'] = "UNIT_AURA"

-- Druid
local lbCount = { 4, 2, 3}
oUF.Tags.Methods['freebgrid:lb'] = function(u) -- 生命绽放 层数 笑脸
    local name, _,_, c,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(33763))
    if(fromwho == "player") then
        local spellTimer = GetTime()-expirationTime
        if spellTimer > -2 then
            return "|cffFF0000"..lbCount[c].."|r"
        elseif spellTimer > -4 then
            return "|cffFF9900"..lbCount[c].."|r"
        else
            return "|cffA7FD0A"..lbCount[c].."|r"
        end
    end
end
oUF.Tags.Events['freebgrid:lb'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:rejuv'] = function(u) -- 回春 小方块
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(774))
    if(fromwho == "player") then
        local spellTimer = GetTime()-expirationTime
        if spellTimer > -2 then
            return "|cffFF0000"..x.."|r"
        elseif spellTimer > -4 then
            return "|cffFF9900"..x.."|r"
        else
            return "|cff33FF33"..x.."|r"
        end
    end
end
oUF.Tags.Events['freebgrid:rejuv'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:regrow'] = function(u) if UnitAura(u, GetSpellInfo(8936)) then return "|cff00FF10"..x.."|r" end end -- 愈合
oUF.Tags.Events['freebgrid:regrow'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:wg'] = function(u) if UnitAura(u, GetSpellInfo(48438)) then return "|cffFFFF00"..x.."|r" end end -- 野性成长
oUF.Tags.Events['freebgrid:wg'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:motw'] = function(u) if not (UnitAura(u, GetSpellInfo(1126)) or UnitAura(u, GetSpellInfo(20217)) or UnitAura(u, GetSpellInfo(115921))) then return "|cffBF3EFF"..x.."|r" end end -- 野性印记 或者 王者祝福 或者 帝王传承
oUF.Tags.Events['freebgrid:motw'] = "UNIT_AURA"

-- Warrior 战士
oUF.Tags.Methods['freebgrid:stragi'] = function(u) if not(UnitAura(u, GetSpellInfo(6673)) or UnitAura(u, GetSpellInfo(57330))) then return "|cffFF0000"..x.."|r" end end -- 战斗怒吼 寒冬号角
oUF.Tags.Events['freebgrid:stragi'] = "UNIT_AURA"

-- Shaman 萨满
oUF.Tags.Methods['freebgrid:rip'] = function(u) 
    local name, _,_,_,_,_,_, fromwho = UnitAura(u, GetSpellInfo(61295)) -- 激流
    if(fromwho == 'player') then return "|cff00FEBF"..x.."|r" end
end
oUF.Tags.Events['freebgrid:rip'] = 'UNIT_AURA'

oUF.Tags.Methods['freebgrid:ripTime'] = function(u) --激流 时间
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(61295))
    if(fromwho == "player") then return getTime(expirationTime) end 
end
oUF.Tags.Events['freebgrid:ripTime'] = 'UNIT_AURA'

local earthCount = {'i','h','g','f','p','q','Z','Z','Y'}
oUF.Tags.Methods['freebgrid:earth'] = function(u) -- 大地之盾
    local c = select(4, UnitAura(u, GetSpellInfo(974))) if c then return '|cffFFCF7F'..earthCount[c]..'|r' end 
end
oUF.Tags.Events['freebgrid:earth'] = 'UNIT_AURA'

-- Paladin 骑士

oUF.Tags.Methods['freebgrid:might'] = function(u) if not UnitAura(u, GetSpellInfo(19740)) then return "|cffFFFF00"..x.."|r" end end --力量祝福
oUF.Tags.Events['freebgrid:might'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:beacon'] = function(u) if UnitAura(u, GetSpellInfo(53563)) then return "|cffFFB90F3|r" end end --道标
oUF.Tags.Events['freebgrid:beacon'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:forbearance'] = function(u) if UnitDebuff(u, GetSpellInfo(25771)) then return "|cffFF9900"..x.."|r" end end
oUF.Tags.Events['freebgrid:forbearance'] = "UNIT_AURA"

-- Warlock 术士
oUF.Tags.Methods['freebgrid:di'] = function(u) -- 黑暗意图
    local name, _,_,_,_,_,_, fromwho = UnitAura(u, GetSpellInfo(109773)) 
    if fromwho == "player" then
        return "|cff6600FF"..x.."|r"
    elseif name then
        return "|cffCC00FF"..x.."|r"
    end
end
oUF.Tags.Events['freebgrid:di'] = "UNIT_AURA"

oUF.Tags.Methods['freebgrid:ss'] = function(u) -- 灵魂石复活
    local name, _,_,_,_,_,_, fromwho = UnitAura(u, GetSpellInfo(20707))  
    if fromwho == "player" then
        return "|cff6600FFY|r"
    elseif name then
        return "|cffCC00FFY|r"
    end
end
oUF.Tags.Events['freebgrid:ss'] = "UNIT_AURA"

-- Mage 法师
oUF.Tags.Methods['freebgrid:int'] = function(u) if not(UnitAura(u, GetSpellInfo(1459))) then return "|cff00A1DE"..x.."|r" end end
oUF.Tags.Events['freebgrid:int'] = "UNIT_AURA"

-- Monk 武僧
oUF.Tags.Methods['mlight:zs'] = function(u) if UnitAura(u, GetSpellInfo(124081)) then return "|cff97FFFF"..x.."|r" end end -- 禅意珠
oUF.Tags.Events['mlight:zs'] = "UNIT_AURA"

oUF.Tags.Methods['mlight:remist'] = function(u) -- 复苏之雾 笑脸
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(115151))
    if(fromwho == "player") then
        local spellTimer = GetTime()-expirationTime
        if spellTimer > -2 then
            return "|cffFF00003|r"
        elseif spellTimer > -4 then
            return "|cffFF99001|r"
        else
            return "|cffA7FD0A2|r"
        end
    end
end
oUF.Tags.Events['mlight:remist'] = "UNIT_AURA"

classIndicators={
    ["DRUID"] = {
        ["TL"] = "[freebgrid:rejuv]",
        ["TR"] = "[freebgrid:motw]",
        ["BL"] = "[freebgrid:regrow][freebgrid:wg]",
        ["BR"] = "[freebgrid:lb]",
        ["Cen"] = "",
    },
    ["PRIEST"] = {
        ["TL"] = "[freebgrid:rnw]",
        ["TR"] = "[freebgrid:fort]",
        ["BL"] = "[freebgrid:pws][freebgrid:ws][freebgrid:pwb]",
        ["BR"] = "[freebgrid:pom]",
        ["Cen"] = "[freebgrid:rnwTime]",
    },
    ["PALADIN"] = {
        ["TL"] = "[freebgrid:forbearance]",
        ["TR"] = "[freebgrid:motw][freebgrid:might]",
        ["BL"] = "",
        ["BR"] = "[freebgrid:beacon]",
        ["Cen"] = "",
    },
    ["WARLOCK"] = {
        ["TL"] = "",
        ["TR"] = "[freebgrid:di]",
        ["BL"] = "",
        ["BR"] = "[freebgrid:ss]",
        ["Cen"] = "",
    },
    ["WARRIOR"] = {
        ["TL"] = "",
        ["TR"] = "[freebgrid:stragi][freebgrid:fort]",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["DEATHKNIGHT"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["SHAMAN"] = {
        ["TL"] = "[freebgrid:rip]",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "[freebgrid:earth]",
        ["Cen"] = "[freebgrid:ripTime]",
    },
    ["HUNTER"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["ROGUE"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["MAGE"] = {
        ["TL"] = "",
        ["TR"] = "[freebgrid:int]",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
	["MONK"] = {
        ["TL"] = "[mlight:zs]",
        ["TR"] = "[freebgrid:motw]",
        ["BL"] = "",
        ["BR"] = "[mlight:remist]",
        ["Cen"] = "",
    },
}

local _, class = UnitClass("player")
local indicator = "Interface\\Addons\\oUF_Mlight\\media\\squares.ttf"
local symbols = "Interface\\Addons\\oUF_Mlight\\media\\PIZZADUDEBULLETS.ttf"

local update = .25

local Enable = function(self)
    if(self.MlightIndicators) then
        self.AuraStatusTL = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusTL:ClearAllPoints()
        self.AuraStatusTL:SetPoint("TOPLEFT", self.Health, 0, 0)
        self.AuraStatusTL:SetFont(indicator, indicatorsize, "THINOUTLINE")
        self.AuraStatusTL.frequentUpdates = update
        self:Tag(self.AuraStatusTL, classIndicators[class]["TL"])

        self.AuraStatusTR = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusTR:ClearAllPoints()
        self.AuraStatusTR:SetPoint("TOPRIGHT", self.Health, 1, 0)
        self.AuraStatusTR:SetFont(indicator, indicatorsize, "THINOUTLINE")
        self.AuraStatusTR.frequentUpdates = update
        self:Tag(self.AuraStatusTR, classIndicators[class]["TR"])

        self.AuraStatusBL = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusBL:ClearAllPoints()
        self.AuraStatusBL:SetPoint("BOTTOMLEFT", self.Health, 0, 0)
        self.AuraStatusBL:SetFont(indicator, indicatorsize, "THINOUTLINE")
        self.AuraStatusBL.frequentUpdates = update
        self:Tag(self.AuraStatusBL, classIndicators[class]["BL"])	

        self.AuraStatusBR = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusBR:ClearAllPoints()
        self.AuraStatusBR:SetPoint("BOTTOMRIGHT", self.Health, 6, -2)
        self.AuraStatusBR:SetFont(symbols, symbolsize, "THINOUTLINE")
        self.AuraStatusBR.frequentUpdates = update
        self:Tag(self.AuraStatusBR, classIndicators[class]["BR"])

        self.AuraStatusCen = self.Health:CreateFontString(nil, "OVERLAY")
        self.AuraStatusCen:SetPoint("TOP")
        self.AuraStatusCen:SetJustifyH("CENTER")
        self.AuraStatusCen:SetFont(cfg.font, fontsizeEdge, "OUTLINE")
        self.AuraStatusCen:SetWidth(0)
        self.AuraStatusCen.frequentUpdates = update
        self:Tag(self.AuraStatusCen, classIndicators[class]["Cen"])
    end
end

oUF:AddElement('MlightIndicators', nil, Enable, nil)
