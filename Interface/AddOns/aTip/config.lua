
local ADDON_NAME, ns = ...
local cfg = CreateFrame("Frame")
---------------------------------------------------------------------------------------
-------------------[[        Config        ]]------------------------------------------ 
---------------------------------------------------------------------------------------
cfg.point = { "TOPRIGHT", "RIGHT", -68, 160}
cfg.cursor = false                   -- 鼠标跟随 make tooltip placed with cursor

cfg.hideTitles = false              -- 隐藏头衔 hide titles
cfg.hideRealm = false               -- 隐藏区域 hide realm 
cfg.showspellID = true              -- 显示法术id show spell id

cfg.colorborderClass = false        -- 职业着色边框 class colored border
cfg.combathide = true               -- 战斗中隐藏 hide in combat

---------------------------------------------------------------------------------------
-------------------[[        My         Config        ]]------------------------------- 
---------------------------------------------------------------------------------------
  if GetUnitName("player") == "伤心蓝" or GetUnitName("player") == "Scarlett" then
   end
---------------------------------------------------------------------------------------
-------------------[[        Config        End        ]]-------------------------------  
---------------------------------------------------------------------------------------
-- HANDOVER
ns.cfg = cfg