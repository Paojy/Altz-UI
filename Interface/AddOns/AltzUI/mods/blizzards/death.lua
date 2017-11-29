local T, C, L, G = unpack(select(2, ...))

local eventframe = CreateFrame("Frame")

eventframe:SetScript("OnEvent", function(self, event)
	if UnitIsDead("player") then
		StaticPopup_Show("DEATH")
	end
end)

eventframe:RegisterEvent("PLAYER_ENTERING_WORLD")

hooksecurefunc("StaticPopup_Show", function(which, text_arg1, text_arg2, data)
	if which == "DEATH" and not UnitIsDead("player") then
      StaticPopup_Hide("DEATH")
   end
end)
--[[
setfenv(WorldMapFrame_OnShow, setmetatable({UpdateMicroButtons = function() end}, {__index = _G}))
setfenv(FriendsFrame_OnShow, setmetatable({UpdateMicroButtons = function() end}, {__index = _G}))
setfenv(SpellBookFrame_OnShow, setmetatable({UpdateMicroButtons = function() end}, {__index = _G}))
setfenv(SpellBookFrame_OnHide, setmetatable({UpdateMicroButtons = function() end}, {__index = _G}))

local ParentalControls = CreateFrame("Frame")
ParentalControls:RegisterEvent("ADDON_LOADED")
ParentalControls:SetScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_AchievementUI" then
		setfenv(AchievementFrame_OnShow, setmetatable({UpdateMicroButtons = function() end}, {__index = _G}))
		setfenv(AchievementFrame_OnHide, setmetatable({UpdateMicroButtons = function() end}, {__index = _G}))
	elseif addon == "Blizzard_TalentUI" then
		setfenv(PlayerTalentFrame_OnShow, setmetatable({UpdateMicroButtons = function() end}, {__index = _G}))
		setfenv(PlayerTalentFrame_OnHide, setmetatable({UpdateMicroButtons = function() end}, {__index = _G}))
	end
end)
]]--
hooksecurefunc("StaticPopup_Show", function(which)
  if(which == "ADDON_ACTION_FORBIDDEN") then
    StaticPopup_Hide(which);
  end
end)
