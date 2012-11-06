local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)
local dragFrameList = G.dragFrameList
local addon, ns = ...
if not aCoreCDB.enabletip then return end

local cursor = aCoreCDB.cursor
local hideTitles = aCoreCDB.hideTitles
local hideRealm = aCoreCDB.hideRealm
local colorborderClass = aCoreCDB.colorborderClass
local combathide = aCoreCDB.combathide

local you = "<You>"
local boss = "Boss"

local classification = {
    elite = "+",
    rare = " Rare",
    rareelite = " Rare+",
	}

local find = string.find
local format = string.format
local hex = function(color)
	if not color or not color.r then return end
    return format('|cff%02x%02x%02x', color.r * 255, color.g * 255, color.b * 255)
end

local function unitColor(unit)
    local color = { r=1, g=1, b=1 }
    if UnitIsPlayer(unit) then
        local _, class = UnitClass(unit)
        color = G.Ccolors[class]
        return color
    else
        local reaction = UnitReaction(unit, "player")
        if reaction then
            color = FACTION_BAR_COLORS[reaction]
            return color
        end
    end
    return color
end

function GameTooltip_UnitColor(unit)
    local color = unitColor(unit)
    return color.r, color.g, color.b
end

local anchor = CreateFrame("Button", "Altz_tooltip", UIParent)
anchor.movingname = L["tooltip"]
anchor:SetWidth(120)
anchor:SetHeight(70)
anchor:SetPoint("BOTTOMRIGHT",  UIParent, "BOTTOMRIGHT", -16, 18)
T.CreateDragFrame(anchor, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp

local function getTarget(unit)
    if UnitIsUnit(unit, "player") then
        return ("|cffff0000%s|r"):format(you)
    else
        return hex(unitColor(unit))..UnitName(unit).."|r"
    end
end

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
    local name, unit = self:GetUnit()

    if unit then
        if combathide and InCombatLockdown() then
            return self:Hide()
        end

        local color = unitColor(unit)
        local ricon = GetRaidTargetIndex(unit)

        if ricon then
            local text = GameTooltipTextLeft1:GetText()
            GameTooltipTextLeft1:SetText(("%s %s"):format(ICON_LIST[ricon].."18|t", text))
        end

        if UnitIsPlayer(unit) then
            self:AppendText((" |cff00cc00%s|r"):format(UnitIsAFK(unit) and CHAT_FLAG_AFK or 
            UnitIsDND(unit) and CHAT_FLAG_DND or 
            not UnitIsConnected(unit) and "<DC>" or ""))

            if hideTitles then
                local title = UnitPVPName(unit)
                if title then
                    local text = GameTooltipTextLeft1:GetText()
                    title = title:gsub(name, "")
                    text = text:gsub(title, "")
                    if text then GameTooltipTextLeft1:SetText(text) end
                end
            end

            if hideRealm then
                local _, realm = UnitName(unit)
                if realm then
                    local text = GameTooltipTextLeft1:GetText()
                    text = text:gsub("- "..realm, "")
                    if text then GameTooltipTextLeft1:SetText(text) end
                end
            end

            local unitGuild, tmp,tmp2 = GetGuildInfo(unit)
            local text = GameTooltipTextLeft2:GetText()
            if tmp then
               --tmp2=tmp2+1
               GameTooltipTextLeft2:SetText("<"..text..">  "..tmp.."  ("..tmp2..")")
            end
        end


        local alive = not UnitIsDeadOrGhost(unit)
        local level = UnitLevel(unit)

        if level then
            local unitClass = UnitIsPlayer(unit) and hex(color)..UnitClass(unit).."|r" or ""
            local creature = not UnitIsPlayer(unit) and UnitCreatureType(unit) or ""
            local diff = GetQuestDifficultyColor(level)

            if level == -1 then
                level = "|cffff0000"..boss
            end

            local classify = UnitClassification(unit)
            local textLevel = ("%s%s%s|r"):format(hex(diff), tostring(level), classification[classify] or "")

            for i=2, self:NumLines() do
                local tiptext = _G["GameTooltipTextLeft"..i]
                if tiptext:GetText():find(LEVEL) then
                    if alive then
                        tiptext:SetText(("%s %s%s %s"):format(textLevel, creature, UnitRace(unit) or "", unitClass):trim())
                    else
                        tiptext:SetText(("%s %s"):format(textLevel, "|cffCCCCCC"..DEAD.."|r"):trim())
                    end
                end

                if tiptext:GetText():find(PVP) then
                    tiptext:SetText(nil)
                end
            end
        end

        if not alive then
            GameTooltipStatusBar:Hide()
        end

        if UnitExists(unit.."target") then
            local tartext = ("%s: %s"):format(TARGET, getTarget(unit.."target"))
            self:AddLine(tartext)
        end
		
		GameTooltipStatusBar:SetStatusBarTexture("Interface\\Buttons\\WHITE8x8")
		GameTooltipStatusBar:GetStatusBarTexture():SetGradient("VERTICAL",  color.r, color.g, color.b, color.r/3, color.g/3, color.b/3)
    else
        for i=2, self:NumLines() do
            local tiptext = _G["GameTooltipTextLeft"..i]

            if tiptext:GetText():find(PVP) then
                tiptext:SetText(nil)
            end
        end

        GameTooltipStatusBar:SetStatusBarColor(0, .9, 0)
    end

    if GameTooltipStatusBar:IsShown() then
		GameTooltipStatusBar:ClearAllPoints()
        GameTooltipStatusBar:SetHeight(4)
		GameTooltipStatusBar:SetPoint("BOTTOMLEFT", GameTooltipStatusBar:GetParent(), "TOPLEFT", 0, 4)
		GameTooltipStatusBar:SetPoint("BOTTOMRIGHT", GameTooltipStatusBar:GetParent(), "TOPRIGHT", 0, 4)
		F.CreateBG(GameTooltipStatusBar)		
    end
end)

GameTooltipStatusBar:SetStatusBarTexture("Interface\\Buttons\\WHITE8x8")

GameTooltipStatusBar:SetScript("OnValueChanged", function(self, value)
    if not value then
        return
    end
    local min, max = self:GetMinMaxValues()
    if (value < min) or (value > max) then
        return
    end
    local _, unit = GameTooltip:GetUnit()
    if unit then
        min, max = UnitHealth(unit), UnitHealthMax(unit)
        if not self.text then
            self.text = T.createtext(self, "OVERLAY", 12, "OUTLINE", "CENTER")
			self.text:SetPoint"BOTTOM"
        end
        self.text:Show()
        local hp = T.ShortValue(min).." / "..T.ShortValue(max)
        self.text:SetText(hp)
    end
end)

hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
    local frame = GetMouseFocus()
    if cursor then
        tooltip:SetOwner(parent, "ANCHOR_CURSOR_RIGHT")
    else
        tooltip:SetOwner(parent, "ANCHOR_NONE")	
        tooltip:SetPoint("BOTTOMRIGHT",  anchor, "BOTTOMRIGHT")
    end
    tooltip.default = 1
end)

GameTooltip:HookScript("OnUpdate", function(self, ...)
   if self:GetAnchorType() == "ANCHOR_CURSOR" then
	  local x, y = GetCursorPosition()
	  local effScale = self:GetEffectiveScale()
	  local width = self:GetWidth() or 0
	  self:ClearAllPoints()
	  self:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x / effScale +5, y / effScale + 20)
   end
end)

local function style(frame)
    if not frame.border then
        F.CreateBD(frame, 0.5)
		frame.border = true
    end
	
	frame:SetBackdropColor(0, 0, 0, 0.4)
    frame:SetBackdropBorderColor(0, 0, 0)
	
    if colorborderClass then
        local _, unit = GameTooltip:GetUnit()
        if UnitIsPlayer(unit) then
            frame:SetBackdropBorderColor(GameTooltip_UnitColor(unit))
        end
    end

    if frame.NumLines then
        for index=1, frame:NumLines() do
            if index == 1 then
                _G[frame:GetName()..'TextLeft'..index]:SetFont(G.norFont, 14, "OUTLINE")
            else
                _G[frame:GetName()..'TextLeft'..index]:SetFont(G.norFont, 12, "OUTLINE")
            end
            _G[frame:GetName()..'TextRight'..index]:SetFont(G.norFont, 12, "OUTLINE")
        end
    end
end

local tooltips = {
    GameTooltip,
    ItemRefTooltip,
    ShoppingTooltip1,
    ShoppingTooltip2, 
    ShoppingTooltip3,
    WorldMapTooltip,
    DropDownList1MenuBackdrop, 
    DropDownList2MenuBackdrop,
}

for i, frame in ipairs(tooltips) do
    frame:SetScript("OnShow", function(frame) style(frame) end)
end

local itemrefScripts = {
    "OnTooltipSetItem",
    "OnTooltipSetAchievement",
    "OnTooltipSetQuest",
    "OnTooltipSetSpell",
}

for i, script in ipairs(itemrefScripts) do
    ItemRefTooltip:HookScript(script, function(self)
        style(self)
    end)
end

if IsAddOnLoaded("ManyItemTooltips") then
    MIT:AddHook("FreebTip", "OnShow", function(frame) style(frame) end)
end

local f = CreateFrame"Frame"
f:SetScript("OnEvent", function(self, event, ...) if ns[event] then return ns[event](ns, event, ...) end end)
function ns:RegisterEvent(...) for i=1,select("#", ...) do f:RegisterEvent((select(i, ...))) end end
function ns:UnregisterEvent(...) for i=1,select("#", ...) do f:UnregisterEvent((select(i, ...))) end end

ns:RegisterEvent"PLAYER_LOGIN"
function ns:PLAYER_LOGIN()
    for i, frame in ipairs(tooltips) do
        F.CreateBD(frame, 0.5)
		frame.border = true
    end

    ns:UnregisterEvent"PLAYER_LOGIN"
end
