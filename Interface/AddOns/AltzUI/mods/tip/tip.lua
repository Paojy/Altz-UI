local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)

local _, ns = ...

if not aCoreCDB["TooltipOptions"]["enabletip"] then return end

local cursor = aCoreCDB["TooltipOptions"]["cursor"]
local hideTitles = aCoreCDB["TooltipOptions"]["hideTitles"]
local hideRealm = aCoreCDB["TooltipOptions"]["hideRealm"]
local colorborderClass = aCoreCDB["TooltipOptions"]["colorborderClass"]
local combathide = aCoreCDB["TooltipOptions"]["combathide"]
local scale = aCoreCDB["TooltipOptions"]["size"]

local you = "<You>"
local boss = "Boss"

local classification = {
    elite = "+",
    rare = " Rare",
    rareelite = " Rare+",
	}

local format = string.format
local hex = function(r, g, b)
    return format('|cff%02x%02x%02x', r * 255, g * 255, b * 255)
end

local function unitColor(unit)
    local r, g, b = 1, 1, 1
    if UnitIsPlayer(unit) then
        local _, class = UnitClass(unit)
        r, g, b = G.Ccolors[class].r, G.Ccolors[class].g, G.Ccolors[class].b
    else
        local reaction = UnitReaction(unit, "player")
        if reaction then
            r, g, b = FACTION_BAR_COLORS[reaction].r, FACTION_BAR_COLORS[reaction].g, FACTION_BAR_COLORS[reaction].b
        end
    end
    return r, g, b
end

local anchor = CreateFrame("Button", "Altz_tooltip", UIParent)
anchor.movingname = L["鼠标提示"]
anchor.point = {
		healer = {a1 = "BOTTOMRIGHT", parent = "Minimap", a2 = "TOPRIGHT", x = 0, y = 40 },
		dpser = {a1 = "BOTTOMRIGHT", parent = "Minimap", a2 = "TOPRIGHT", x = 0, y = 40},
	}
T.CreateDragFrame(anchor)
anchor:SetWidth(120)
anchor:SetHeight(70)

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

        local r, g, b = unitColor(unit)
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

            local _, tmp,tmp2 = GetGuildInfo(unit)
            local text = GameTooltipTextLeft2:GetText()
            if tmp then
               --tmp2=tmp2+1
               GameTooltipTextLeft2:SetText("<"..text..">  "..tmp.."  ("..tmp2..")")
            end
        end


        local alive = not UnitIsDeadOrGhost(unit)
        local level = UnitLevel(unit)

        if level and unit then
			if not UnitIsWildBattlePet(unit) then
				local unitClass = UnitIsPlayer(unit) and hex(r, g, b)..UnitClass(unit).."|r" or ""
				local creature = not UnitIsPlayer(unit) and UnitCreatureType(unit) or ""
				local diff = GetQuestDifficultyColor(level)

				if level == -1 then
					level = "|cffff0000"..boss
				end

				local classify = UnitClassification(unit)
				local textLevel = ("%s%s%s|r"):format(hex(diff.r, diff.g, diff.b), tostring(level), classification[classify] or "")

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
        end

        if not alive then
            GameTooltipStatusBar:Hide()
        end

        if UnitExists(unit.."target") then
            local tartext = ("%s: %s"):format(TARGET, getTarget(unit.."target"))
            self:AddLine(tartext)
        end

		GameTooltipStatusBar:SetStatusBarTexture("Interface\\Buttons\\WHITE8x8")
		GameTooltipStatusBar:GetStatusBarTexture():SetGradient("VERTICAL",  r, g, b, r/3, g/3, b/3)
    else
        for i=2, self:NumLines() do
            local tiptext = _G["GameTooltipTextLeft"..i]

            if tiptext:GetText():find(PVP) then
                tiptext:SetText(nil)
			end

        GameTooltipStatusBar:SetStatusBarColor(0, .9, 0)
		end
	end

    if GameTooltipStatusBar:IsShown() then
		GameTooltipStatusBar:ClearAllPoints()
        GameTooltipStatusBar:SetHeight(8)
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
    if cursor then
        tooltip:SetOwner(parent, "ANCHOR_CURSOR_RIGHT")
    else
        tooltip:SetOwner(parent, "ANCHOR_NONE")
        tooltip:SetPoint("BOTTOMRIGHT",  anchor, "BOTTOMRIGHT")
    end
    tooltip.default = 1
end)

GameTooltip:HookScript("OnUpdate", function(self)
   if self:GetAnchorType() == "ANCHOR_CURSOR" then
	  local x, y = GetCursorPosition()
	  local effScale = self:GetEffectiveScale()
	  self:ClearAllPoints()
	  self:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x / effScale +5, y / effScale + 20)
   end
end)

local styledline = 0

local function style(frame)
    if not frame.border then
        F.CreateBD(frame, 0.5)
		frame.border = true
    end

	frame:SetScale(scale)
	frame:SetBackdropColor(0, 0, 0, 0.4)
    frame:SetBackdropBorderColor(0, 0, 0)

    if colorborderClass then
        local _, unit = GameTooltip:GetUnit()
        if UnitIsPlayer(unit) then
            frame:SetBackdropBorderColor(unitColor(unit))
        end
    end

    if frame.NumLines then
        for index = styledline+1, 30 do
            if index == 1 then
                _G[frame:GetName()..'TextLeft'..index]:SetFont(G.norFont, 14, "OUTLINE")
				_G[frame:GetName()..'TextRight'..index]:SetFont(G.norFont, 12, "OUTLINE")
				styledline = index
            elseif _G[frame:GetName()..'TextLeft'..index] then
                _G[frame:GetName()..'TextLeft'..index]:SetFont(G.norFont, 12, "OUTLINE")
				_G[frame:GetName()..'TextRight'..index]:SetFont(G.norFont, 12, "OUTLINE")
				styledline = index
				--print(index.."ok")
			else
				--print(index.."break")
				break
            end
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
	WorldMapTooltip.BackdropFrame,
    DropDownList1MenuBackdrop,
    DropDownList2MenuBackdrop,
}

for _, frame in pairs(tooltips) do
    frame:SetScript("OnShow", function(self) style(self) end)
end

local itemrefScripts = {
    "OnTooltipSetItem",
    "OnTooltipSetAchievement",
    "OnTooltipSetQuest",
    "OnTooltipSetSpell",
}

for _, script in ipairs(itemrefScripts) do
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
    for _, frame in ipairs(tooltips) do
        F.CreateBD(frame, 0.5)
		frame.border = true
    end

    ns:UnregisterEvent"PLAYER_LOGIN"
end