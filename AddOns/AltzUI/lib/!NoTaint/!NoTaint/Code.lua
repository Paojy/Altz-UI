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
        if ( frame ) then
            if not issecurevariable(frame, "syncId") or not issecurevariable(frame, "fadeInTime") or not issecurevariable(frame, "flashTimer") then
                error(L.FLASH_FAILED)
                --UIFrameFlashStop(frame)
                --frameFlashManager:SetScript("OnUpdate", nil)
            end
        end
    end)
end


--[[-------------------------------------------------------------------
处理确认框导致不能洗天赋的情况 http://bbs.ngacn.cc/read.php?tid=5901398
只是解决一部分原因导致的该问题，所以无法保证一定有效

测试方式：
1. 打开 天赋界面，然后关闭
2. 运行 /run StaticPopup_Show('PARTY_INVITE',"a") 
3. 点击确定或取消
4. 再次打开 天赋界面
结果：不安装此插件时肯定不能洗天赋，但安装此插件后"可能"成功洗天赋

副作用: 
1. 如果在有提示框（如组队邀请）的时候打开天赋面板，则此提示框会隐藏
2. 主菜单的天赋按钮无法自动跳转到天赋页（如停留在雕文页）
----------------------------------------------------------------------]]

--[[

for k,v in pairs(frame) do
    if not issecurevariable(frame, k) then frame[k] = nil end
end

tab:HookScript("OnClick", function()
    testObj(PlayerTalentGroup)
end)

hooksecurefunc("UIFrameFade", function (frame, fadeInfo)
	if (not frame) then
		return;
	end
    if not issecurevariable(frame, "fadeInfo") then
        UIFrameFadeRemoveFrame(frame)
        if UICoreFrameFade then 
            UICoreFrameFade(frame, fadeInfo)
        else
            error(L.FADE_PREVENT)
        end
    end
end)

hooksecurefunc("UIFrameFlash", function(frame, ...)
    --table.wipe(FLASHFRAMES) --this line will cause taint, aslo tDeleteItem(FLASHFRAMES, frame);
    frame.syncId = nil
    UICoreFrameFlash(frame, ...)
end)

hooksecurefunc("UIFrameFlashStop", function(frame)
    UICoreFrameFlashStop(frame)
end)
]]