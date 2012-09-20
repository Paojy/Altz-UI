-- Author: Blooblahguy
local T, C, L, G = unpack(select(2, ...))

local frame = CreateFrame("frame", nil)
SlashCmdList['COUNTDOWN'] = function(newtime)
    if newtime ~= "" then
        cdtime = newtime+1
    else
        cdtime = 7
    end
   
    local ending = false
    local start = floor(GetTime())
    local throttle = cdtime
    frame:SetScript("OnUpdate", function()
        if ending == true then return end
        local countdown = (start - floor(GetTime()) + cdtime)
      
        if (countdown + 1) == throttle and countdown >= 0 then
            if countdown == 0 then
                SendChatMessage(L["Fire!"], UnitIsGroupAssistant("player") or UnitIsGroupLeader("player") and "RAID_WARNING" or "SAY")
                throttle = countdown
                ending = true
            else
                SendChatMessage(countdown, UnitIsGroupAssistant("player") or UnitIsGroupLeader("player") and "RAID_WARNING" or "SAY")
                throttle = countdown
            end
        end
    end)
end

SLASH_COUNTDOWN1 = "/cd"