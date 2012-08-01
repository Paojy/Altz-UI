local ADDON_NAME, ns = ...
local cfg = CreateFrame("Frame")
---------------------------------------------------------------------------------------
-------------------[[        Config        ]]------------------------------------------ 
---------------------------------------------------------------------------------------
-- name of worldchannelname
-- 世界频道名称
cfg.worldchannelname = "大脚世界频道"

-- Automatically takes a screenshot when you earn an achievement.
-- 成就自动截图
cfg.autoscreenshot = true

-- Automatically accept a resurrect request if not in combat and thank the caster.
-- 当不在战斗中时自动接收复活
cfg.acceptres = true

-- Automatically release when you die in a battle ground.
-- 在战场中自动释放灵魂
cfg.battlegroundres = true

-- Disable error messages: Not enough energy, Not enough mana, ...
-- 取消系统红字错误提示
cfg.hideerrors = true

-- Automatically accept party invites from people in your guild or on your friends list.
-- 自动接受来自公会或好友的组队邀请。
cfg.acceptfriendlyinvites = true

-- Automatically repair all of your gear when visiting an applicable merchant,From guild funds.
cfg.autorepair = false --自动修理
cfg.autorepairguild = true --自动公会修理

-- Automatically sell all of your grey quality items when visiting a merchant.
-- 自动卖垃圾
cfg.selljunk = true

-- gives a sound warning, when you get the exhaustion/fatigue 'debuff' - you will also hear it when you disabled sounds.
-- 疲劳警报
cfg.fatiguewarner = true

-- Outputs a message when you successfully interrupt.
-- 打断通报 （团队或小队）
cfg.interruptedmsg = true

cfg.combattext = true
cfg.raidcd = true

--Automaticly accepts/completes quests
--自动交接任务
cfg.autoquests = false

--Colorizes the item that is already known in some default frames.
--已会配方染色
cfg.knowncolorenable = true
cfg.knowncolor = { r = 0.1, g = 1.0, b = 0.1, }

-- add a button to 'Open All' items from your mailbox with a single click.
-- 一键取邮件
cfg.automail = true

-- garbage collector(out of combat)
-- 回收内存（战斗外）
cfg.collectgarbage = true

-- count down and announce it(/cd or /cd x)
-- 倒计时（/cd or /cd x）
cfg.countdown = true
cfg.cdtime = 6 --(/cd)
cfg.cdchannel = "RAID_WARNING"

-- unlock default frames(allows you to move them)
-- 解锁框体
cfg.unlockframes = true

-- Shift+Click to set focus
-- Shift+左键 设置焦点
cfg.fastfocus = true

-- says "Sapped!" to alert those around you when a rogue saps you.
-- 被闷棍后喊"Sapped!"
cfg.saysapped = true

-- Watch Frame replacement
-- 自定义任务追踪栏
cfg.customwf = true         -- enable
cfg.x = -70				    -- Horizontal offset
cfg.y = -140				-- Vertical offset
cfg.anchor = "TOPRIGHT"  	-- Position on screen. CENTER, RIGHT, LEFT, BOTTOM, BOTTOMRIGHT, BOTTOMLEFT, TOP, TOPRIGHT, TOPLEFT
cfg.heightsc = 370	        -- How much shorter than screen height to make the Watch Frame
cfg.wffont = 13             -- fontsize
-- Collapse the Watch Frame 收起任务追踪栏
cfg.collapsepvp = true
cfg.collapsearena = false
cfg.collapseparty = true
cfg.collapseraid = true
-- Hide the Watch Frame completely 隐藏任务追踪栏
cfg.hidepvp = false
cfg.hidearena = true
cfg.hideparty = false
cfg.hideraid = false

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