local T, C, L, G = unpack(select(2, ...))

--[[--------------------------------------------
Deal with StaticPopup_Show()
/run StaticPopup_Show('PARTY_INVITE',"test") 
----------------------------------------------]]
do
    local function hook()
        PlayerTalentFrame_Toggle = function() 
            if ( not PlayerTalentFrame:IsShown() ) then 
                ShowUIPanel(PlayerTalentFrame); 
                TalentMicroButtonAlert:Hide(); 
            else 
                PlayerTalentFrame_Close(); 
            end 
        end

        for i=1, 10 do
            local tab = _G["PlayerTalentFrameTab"..i];
            if not tab then break end
            tab:SetScript("PreClick", function()
                --print("PreClicked")
                for index = 1, STATICPOPUP_NUMDIALOGS, 1 do
                    local frame = _G["StaticPopup"..index];
                    if(not issecurevariable(frame, "which")) then
                        local info = StaticPopupDialogs[frame.which];
                        if frame:IsShown() and info and not issecurevariable(info, "OnCancel") then
                            info.OnCancel()
                        end
                        frame:Hide()
                        frame.which = nil
                    end
                end
            end)
        end
    end

    if(IsAddOnLoaded("Blizzard_TalentUI")) then
        hook()
    else
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, addon)
            if(addon=="Blizzard_TalentUI")then
                self:UnregisterEvent("ADDON_LOADED")
                hook()
            end             
        end)
    end
end

--[[--------------------------------------------
Deal with UIFrameFlash & UIFrameFade
/run UIFrameFlash(PlayerFrame, 1,1, -1,true,0,0,"test")
----------------------------------------------]]
do
    local L
    if GetLocale()=="zhTW" or GetLocale()=="zhCN" then
        L = {
            FADE_PREVENT = "!NoTaint阻止了对UIFrameFade的调用.",
            FLASH_FAILED = "你的插件调用了UIFrameFlash，导致你可能无法切换天赋，请修改对应代码。",
        }
    else
        L = {
            FADE_PREVENT = "Call of UIFrameFade is prevented by !NoTaint.",
            FLASH_FAILED = "AddOn calls UIFrameFlash, you may not be able to switch talent.",
        }
    end

    hooksecurefunc("UIFrameFlash", function (frame, fadeInTime, fadeOutTime, flashDuration, showWhenDone, flashInHoldTime, flashOutHoldTime, syncId)
        if ( frame and not string.match(frame:GetName(), "GM")) then
            if not issecurevariable(frame, "syncId") or not issecurevariable(frame, "fadeInTime") or not issecurevariable(frame, "flashTimer") then
                error(L.FLASH_FAILED)
                --UIFrameFlashStop(frame)
                --frameFlashManager:SetScript("OnUpdate", nil)
            end
        end
    end)
end
