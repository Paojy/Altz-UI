-- Author: Blooblahguy

local ADDON_NAME, ns = ...
local cfg = ns.cfg
local L = ns.L

if not cfg.countdown then return end

local frame = CreateFrame("frame", nil)
SlashCmdList['COUNTDOWN'] = function(newtime)
    if newtime ~= "" then
        cdtime = newtime+1
    else
        cdtime = cfg.cdtime+1
    end
   
    local ending = false
    local start = floor(GetTime())
    local throttle = cdtime
    frame:SetScript("OnUpdate", function()
        if ending == true then return end
        local countdown = (start - floor(GetTime()) + cdtime)
      
        if (countdown + 1) == throttle and countdown >= 0 then
            if countdown == 0 then
                SendChatMessage(L["Fire!"], cfg.cdchannel)
                throttle = countdown
                ending = true
            else
                SendChatMessage(countdown, cfg.cdchannel)
                throttle = countdown
            end
        end
    end)
end

SLASH_COUNTDOWN1 = "/cd"