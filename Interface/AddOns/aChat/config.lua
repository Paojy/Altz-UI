local ADDON_NAME, ns = ...
local cfg = CreateFrame("Frame")
---------------------------------------------------------------------------------------
-------------------[[        Config        ]]------------------------------------------ 
---------------------------------------------------------------------------------------
-- channel name replacements
-- 聊天频道缩写
cfg.channelreplacement = true

--Right-Click player names in chat window to be able to copy their names/do Guild Invite/do a Who lookup. 
--玩家菜单增强（复制名字/公会邀请/查看详情）
cfg.playermenu = true

-- URL support
-- 网站复制
cfg.urlcopy = true

-- Hide Black Combat Log Bar
-- 隐藏战斗记录黑条
cfg.hidecombat = true

-- auto scroll the chat to the bottom
-- 自动翻页到最底
cfg.autoscroll = true
cfg.autoscrolldelay = 15

-- Press Tab to change between available channels
-- Tab 切换聊天频道
cfg.tabchannel = true

-- Minimize the Chat after a few seconds
-- 自动收缩聊天框
cfg.minchat = true              -- enable
cfg.maxHeight = 120				-- How high the chat frames are when maximized
cfg.minimizeTime = 10			-- Minimize after X seconds
cfg.minimizedLines = 1			-- Number of chat messages to show in minimized state
cfg.LockInCombat = true			-- Do not maximize in combat
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
