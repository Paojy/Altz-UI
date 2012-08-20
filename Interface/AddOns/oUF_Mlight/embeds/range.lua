local _, ns = ...
local cfg = ns.cfg

-- oUF range element with code sniplets from TomTom
-- by Freebaser

local _FRAMES = {}
local OnRangeFrame
local update = .20

local UnitInRange, UnitIsConnected = UnitInRange, UnitIsConnected
local SetMapToCurrentZone, WorldMapFrame = SetMapToCurrentZone, WorldMapFrame
local GetPlayerMapPosition, GetPlayerFacing = GetPlayerMapPosition, GetPlayerFacing

local select, next = select, next
local pi = math.pi
local twopi = pi * 2
local atan2 = math.atan2
local modf = math.modf
local abs = math.abs
local floor = floor

local function ColorGradient(perc, ...)
    local num = select("#", ...)
    local hexes = type(select(1, ...)) == "string"

    if perc == 1 then
        return select(num-2, ...), select(num-1, ...), select(num, ...)
    end

    num = num / 3

    local segment, relperc = modf(perc*(num-1))
    local r1, g1, b1, r2, g2, b2
    r1, g1, b1 = select((segment*3)+1, ...), select((segment*3)+2, ...), select((segment*3)+3, ...)
    r2, g2, b2 = select((segment*3)+4, ...), select((segment*3)+5, ...), select((segment*3)+6, ...)

    if not r2 or not g2 or not b2 then
        return r1, g1, b1
    else
        return r1 + (r2-r1)*relperc,
        g1 + (g2-g1)*relperc,
        b1 + (b2-b1)*relperc
    end
end

local function ColorTexture(texture, angle)
    local perc = abs((pi - abs(angle)) / pi)

    local gr,gg,gb = 0, 1, 0
    local mr,mg,mb = 1, 1, 0
    local br,bg,bb = 1, 0, 0
    local r,g,b = ColorGradient(perc, br, bg, bb, mr, mg, mb, gr, gg, gb)

    texture:SetVertexColor(r,g,b)
end

local function RotateTexture(frame, angle)
    if not frame:IsShown() then
        frame:Show()
    end
    angle = angle - GetPlayerFacing()

    local cell = floor(angle / twopi * 108 + 0.5) % 108
    if cell == frame.cell then return end
    frame.cell = cell

    local column = cell % 9
    local row = floor(cell / 9)

    ColorTexture(frame.arrow, angle)
    local xstart = (column * 56) / 512
    local ystart = (row * 42) / 512
    local xend = ((column + 1) * 56) / 512
    local yend = ((row + 1) * 42) / 512
    frame.arrow:SetTexCoord(xstart,xend,ystart,yend)
end

local px, py, tx, ty
local function GetBearing(unit)
    if unit == 'player' then return end

    px, py = GetPlayerMapPosition("player")
    if((px or 0)+(py or 0) <= 0) then
        if WorldMapFrame:IsVisible() then return end
        SetMapToCurrentZone()
        px, py = GetPlayerMapPosition("player")
        if((px or 0)+(py or 0) <= 0) then return end
    end

    tx, ty = GetPlayerMapPosition(unit)
    if((tx or 0)+(ty or 0) <= 0) then return end

    return pi - atan2(px-tx,ty-py)
end

function ns:arrow(object, unit)
    if not object.OoR or not UnitIsConnected(unit) then return end 
    local bearing = GetBearing(unit)
    if bearing then
        RotateTexture(object.freebarrow, bearing)
    end
end

local timer = 0
local OnRangeUpdate = function(self, elapsed)
    timer = timer + elapsed

    if(timer >= update) then
        for _, object in next, _FRAMES do
            if(object:IsShown()) then
                local range = object.freebRange
                if(UnitIsConnected(object.unit)) then
                    local inRange, checkRange = UnitInRange(object.unit)
                    if(checkRange and not inRange) then
                        object:SetAlpha(range.outsideAlpha)
                        object.OoR = true
                    else
                        object.OoR = false
                        if(object:GetAlpha() ~= range.insideAlpha) then
                            object:SetAlpha(range.insideAlpha)
                        end
                    end
                end
            elseif(object.freebarrow:IsShown()) then
                object.freebarrow:Hide()
            end
        end

        timer = 0
    end
end

local Enable = function(self)
    local range = self.freebRange
    if(range and range.insideAlpha and range.outsideAlpha) then
        table.insert(_FRAMES, self)

        if(not OnRangeFrame) then
            OnRangeFrame = CreateFrame"Frame"
            OnRangeFrame:SetScript("OnUpdate", OnRangeUpdate)
        end
        OnRangeFrame:Show()

        local frame = CreateFrame("Frame", nil, UIParent)
        frame:SetAllPoints(self)
        frame:SetFrameStrata("HIGH")
        frame:SetScale(cfg.arrowscale)

        frame.arrow = frame:CreateTexture(nil, "OVERLAY")
        frame.arrow:SetTexture"Interface\\Addons\\oUF_Mlight\\media\\Arrow"
        frame.arrow:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
        frame.arrow:SetSize(24, 24)

        self.freebarrow = frame
        self.freebarrow:Hide()
		
		self:HookScript("OnEnter", function(self)
			ns:arrow(self, self.unit) 
		end)
		
		self:HookScript("OnLeave", function(self)
		    if(self.freebarrow and self.freebarrow:IsShown()) then
				self.freebarrow:Hide()
			end 
		end)
		
        return true
    end
end

local Disable = function(self)
    local range = self.freebRange
    if(range) then
        for k, frame in next, _FRAMES do
            if(frame == self) then
                table.remove(_FRAMES, k)
                break
            end
        end

        if(#_FRAMES == 0) then
            OnRangeFrame:Hide()
        end
    end
end

oUF:AddElement('freebRange', nil, Enable, Disable)
