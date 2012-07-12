local ADDON_NAME, ns = ...
local cfg = ns.cfg

if not cfg.collectgarbage then return end

---------
local eventcount = 0 
local a = CreateFrame("Frame") 
a:RegisterAllEvents() 
a:SetScript("OnEvent", function(self, event) 
   eventcount = eventcount + 1 
   if InCombatLockdown() then return end 
   if eventcount > 6000 or event == "PLAYER_ENTERING_WORLD" then 
      collectgarbage("collect") 
      eventcount = 0
   end 
end) 
---------






