﻿local T, C, L, G = unpack(select(2, ...))
if G.Client == "zhCN" or G.Client == "zhTW" then return end

-- 安装
L["小泡泡"] = "Paopao"
L["欢迎使用"] = "Welcome to Altz UI Setup"
L["简介"] = "Altz UI is a minimalistic compilation with in-game configuration supported. I wanted to make a UI which gives people the feeling of hiding almost all UI elements, just like after pressing Alt+Z, and that is the origin of the name.  It was first released at November 11, 2011. The theme of AltzUI is simplicity. It only shows necessary elements when you want to see them. Also its memory usage and CPU footprint is very low, with only 2 ~ 3mb it is able to complete most of the functionality you need. Please help by spreading the word about this UI by recommending it to your guild members and friends. Thank you."

L["上一步"] = "Previous"
L["下一步"] = "Next"
L["跳过"] = "Skip Setup Wizard"
L["设置向导"] = "Setup Wizard"
L["完成"] = "Finish"
L["更新日志"] = "Update Log"
L["更新日志tip"] = "New feature:\nUpdate for 10.00"
L["寻求帮助"] = "Help"
L["粘贴"] = "Press Ctrl + c to copy the link"
L["Buffs"] = "Buffs"
L["Debuffs_Black"] = "Debuffs"
L["Debuffs"] = "Debuffs"
L["生效"] = " to take effect"
L["稍后重载"] = "Reload later"

-- 控制台通用
L["界面"] = "Interface"
L["启用"] = "Enable"
L["控制台"] = "GUI"
L["图标大小"] = "Icon Size"
L["图标数量"] = "Aura Number"
L["图标间距"] = "Icon Space"
L["缩放尺寸"] = "Scale"
L["字体大小"] = "Font Size"
L["尺寸"] = "Size"
L["高度"] = "Height"
L["宽度"] = "Width"
L["光环"] = "Auras"
L["图标"] = "Icon"
L["Buffs"] = "Buffs"
L["Debuffs"] = "Debuffs"
L["输入法术ID"] = "Input a spellID"
L["左"] = "Left"
L["右"] = "Right"
L["上"] = "Up"
L["下"] = "Down"
L["左上"] = "Top Left"
L["右上"] = "Top Right"
L["上方"] = "Top"
L["下方"] = "Bottom"
L["垂直"] = "Vertical"
L["水平"] = "Horizontal"
L["正向"] = "Ascending"
L["反向"] = "Descending"
L["显示冷却"] = "Show %s's cooldown."
L["导入/导出配置"] = "Import Settings"
L["排列方向"] = "Anchor"

-- 介绍
L["介绍"] = "Intro"
L["重置确认"] = "Do you want to reset all the %s settings?"
L["重置"] = "Reset"
L["导入确认"] = "Do you want to import all the %s settings?\n"
L["版本不符合"] = "\nImport Version %s（Current Version %s）"
L["客户端不符合"] = "\nGame Client %s（Current Client %s）"
L["职业不符合"] = "\nClass %s（Current Class %s）"
L["不完整导入"] = "\nMay not import completely."
L["导入"] = "Import"
L["导出"] = "Export"
L["无法导入"] = "Cannot Import"

-- 聊天
L["聊天按钮悬停渐隐"] = "Social Buttons Hover Fading"
L["聊天按钮悬停渐隐提示"] = "Enble button fading when your mouse is not hovering over them."
L["频道缩写"] = "Replace Channel Name"
L["滚动聊天框"] = "Scroll Chat Frame"
L["滚动聊天框提示"] = "Auto Scroll Chat Frame to bottom after a few seconds."
L["自动邀请"] = "Key Word Invite"
L["自动邀请提示"] = "Auto Invite people whispered key words"
L["关键词"] = "Key Word"
L["关键词输入"] = "Input key words separated by a space"
L["聊天过滤"] = "Chat Filter"
L["聊天过滤提示"] = "Hide repeated chat messages and chat messages containing key word(s) below."
L["过滤阈值"] = "Chat Filter Keyword Number"
L["显示聊天框背景"] = "Show background for chat frames."
L["复制聊天"] = "Copy Chat"
L["无法自动邀请进组:"] = "I can't invite you:"
L["我不能组人"] = "I'm not a raid leader or an assistant"
L["小队满了"] = "party is full"
L["团队满了"] = "raid is full"
L["客户端错误"] = "I can't invite you by keyword now, your account seems to be sticking to %s."

-- 背包和物品
L["启用背包模块"] = "Enable Inventory Mods"
L["背包图标大小"] = "Inventory icons size"
L["背包每行图标数量"] = "Inventory icon number per row"
L["自动修理"] = "Auto Repair"
L["自动修理提示"] = "Automatically repair items"
L["自动公会修理"] = "Auto Guild Repair"
L["自动公会修理提示"] = "Use Guild funds for auto repairs"
L["灵活公会修理"] = "Flexible Guild Repair"
L["灵活公会修理提示"] = "Use your own money when go over guild repair limit."
L["自动售卖"] = "Auto Sell"
L["自动售卖提示"] = "Automatically sell greys"
L["已会配方着色"] = "Colorizes Known Items"
L["已会配方着色提示"] = "Colorizes the item that is already known in some default frames."
L["自动购买"] = "Auto Buy"
L["自动购买提示"] = "Automatically buy items in the list below."
L["输入自动购买的物品ID"] = "Input Auto-buy-item ID"
L["输入物品ID"] = "Input item ID"
L["输入数量"] = "Quantity"
L["不正确的物品ID"] = "Incorrect Item ID"
L["不正确的数量"] = "Incorrect quantity"
L["显示物品等级"] = "Item Level"
L["显示物品等级提示"] = "Show item level on weapons and armor in your bags and character inventory slots"
L["便捷物品按钮"] = "Convenient Item Buttons"
L["便捷物品按钮提示"] = "These buttons only show when you are not in combat."
L["每行图标数量"] = "icon number per row"
L["精确匹配"] = "Exact Item"
L["精确匹配提示"] = "Enable to show the exact item, otherwise also show items with similar spell.(e.g. artifact power items)"
L["显示数量"] = "Show Count"
L["显示数量提示"] = "Show item count in inventory."
L["条件"] = "Conditions"
L["总是显示"] = "Always"
L["在职业大厅显示"] = "In Orderhall"
L["在团队副本中显示"] = "In Raid"
L["在地下城中显示"] = "In Dungeon"
L["在战场中显示"] = "In BG"
L["赚得"] = "Earned:"
L["消费"] = "Spent:"
L["赤字"] = "Deficit:"
L["盈利"] = "Profit:"
L["本次登陆"] = "Session"
L["服务器"] = "Server"
L["角色"] = "Character"
L["重置金币信息"] = "Click to reset."
L["修理花费"] = "Repair Cost:"
L["钱不够"] = "You don't have enough gold to purchase this"
L["购买"] = "Bought %d %s."
L["货物不足"] = "The merchant don't have enough"
L["光标"] = "cursor"
L["当前"] = "current"

-- 单位框体
L["单位框体"] = "Unit Frames"
L["样式"] =  "Style"
L["总是显示生命值"] = "Always show HP"
L["总是显示生命值提示"] = "disable to show HP only when it's not full."
L["总是显示能量值"] = "Always show PP"
L["总是显示能量值提示"] = "disable to show PP only when it's not full."
L["数值字号"] = "Value fontsize"
L["数值字号提示"] = "HP and PP value fontsize"
L["显示肖像"] = "Show Portrait"
L["宽度提示"] = "The width for player, target and focus frame"
L["宠物框体宽度"] = "Pet Frame Width"
L["首领框体和PVP框体的宽度"] = "Boss Frame/Arena Frame Width"
--L["能量条高度"] = "PP Height"
L["施法条"] = "Castbar"
L["独立施法条"] = "Independent Castbar"
L["玩家施法条"] = "Player Cast Bar"
L["目标施法条"] = "Target Cast Bar"
L["焦点施法条"] = "Focus Cast Bar"
L["法术名称位置"] = "Spell Name Position"
L["可打断施法条图标颜色"] = "Interruptible spell icon border color"
L["不可打断施法条图标颜色"] = "Not interruptible spell icon border color"
L["施法时间位置"] = "Cast Duration Position"
L["引导法术分段"] = "Show every tick in a channel spell"
L["隐藏玩家施法条图标"] = "Hide the icon on player castbar"
L["平砍计时条"] = "Swing Timer"
L["显示副手"] = "Show Off-Hand bar"
L["显示平砍计时"] = "Show Time Text"
L["玩家减益"] = "Player Debuffs"
L["玩家减益提示"] = "Show the debuffs cast on player above player frame"
L["过滤增益"] = "Target Aura Filter: Ignore Buff"
L["过滤增益提示"] = "Hide others' buff on friendly target."
L["过滤减益"] = "Target Aura Filter: Ignore Debuff"
L["过滤减益提示"] = "Hide others' debuffs on enemy target."
L["白名单"] = "WhiteList"
L["白名单提示"] = "Edit whitelist to force an aura to show when enable filter.\nIf a debuff cast by others on an enemy is in whitelist, its color will not fade."
L["已经在白名单中"] = "is already in Aura Filter WhiteList."
L["被添加到法术过滤白名单中"] = "has been add to Aura Filter WhiteList."
L["从法术过滤白名单中移出"] = "has been removed from Aura Filter WhiteList"
L["不是一个有效的法术ID"] = "is not a correct spell ID"
L["图腾条"] = "Totembar"
L["显示PvP标记"] = "Show PvP Icon"
L["显示PvP标记提示"] = "Recommand in a PvE Server"
L["启用首领框体"] = "Enable Bossframes"
L["启用PVP框体"] = "Enable Arenaframes"
L["在小队中显示自己"] = "Show player in party frames"
L["显示法力条"] = "show mana bar"
L["显示法力条提示"] = "show mana bar for Dps Specialization"
L["启用仇恨条"] = "show threat bar"
L["显示醉拳条"] = "show stagger bar"
L["的徽章冷却就绪"] = "'s TrinketPVP is ready"
L["使用了徽章"] = " uses TrinketPVP"

-- 团队框架
L["团队框架"] = "Raid Frames"
L["团队框架tip"] = "Does the Raid Frames change with specialization?"
L["通用设置"] = "Common"
L["显示宠物"] = "Show Pets"
L["名字长度"] = "Name Length"
L["未进组时显示"] = "Show Solo"
L["刷新载具"] = "Toggle for vehicle"
L["团队规模"] = "Group Size"
L["40-man"] = "40-man"
L["30-man"] = "30-man"
L["20-man"] = "20-man"
L["10-man"] = "10-man"
L["raidmanabars"] = "Show Mana bars"
L["GCD"] = "GCD Bar"
L["GCD提示"] = "Show GCD bar on raid frame."
L["显示缺失生命值"] = "Show HP"
L["显示缺失生命值提示"] = "Show missing HP when HP is below 90%"
L["治疗和吸收预估"] = "Heal Prediction and Absorb effects"
L["治疗和吸收预估提示"] = "Show heal prediction bar and absorb bar on raid frame."
L["职业顺序"] = "Sort raid members by their class."
L["整体高度"] = "Number Per Line"
L["整体高度提示"] = "How many units do you want to show per line?"
L["点击施法"] = "Click-Cast"
L["点击施法提示"] = "Input %starget|r to target mouseover unit.\nInput %stot|r to target mouseover unit's target.\nInput %sfocus|r to set mouseover unit as focus unit.\nInput %sfollow|r to follow mouseover unit.\nInput %sa spell|r to cast it to the mouseover unit.\nInput %smacro|r bind a macro to the action"
L["Button1"] = "Left" 
L["Button2"] = "Right" 
L["Button3"] = "Middle" 
L["Button4"] = "4" 
L["Button5"] = "5" 
L["MouseUp"] = "MouseUp" 
L["MouseDown"] = "MouseDown" 
L["不正确的法术名称"] = "Incorret Spell"
L["输入一个宏"] = "Enter a macro"
L["输入层级"] = "Priority"
L["必须是一个数字"] = "should be a number."
L["主坦克和主助手"] = "tank icon and main assist icon"
L["主坦克和主助手提示"] = "show tank icon and main assist icon on raid frames"
L["治疗指示器"] = "Healer Indicators"
L["数字指示器"] = "Number-style Indicators"
L["图标指示器"] = "Icon-style Indicators"
L["团队减益"] = "Debuff List"
L["减益过滤"] = "Debuff fliter"
L["团队增益"]= "Buff List"
L["自动添加团队减益"] = "Automatically add newly discovered Raid&Dungeon debuffs to the list"
L["自动添加团队减益提示"] = "The newly-discovered Raid&Dungeon debuffs are automatically added to the list. You can delete the newly added debuffs from the debuff list, or disable them from being displayed through the debuff blacklist filter."
L["自动添加的图标层级"] = "Icon Priority"
L["团队工具"] = "RaidTools"
L["添加团队减益"] = "|cff7FFF00Raid Debuff added successfully|r %s %s"
L["杂兵"] = "Trash"
L["设置"] = "Edit"
L["删除并加入黑名单"] = "Delete and add to blacklist"
L["已删除并加入黑名单"] = "|cff7FFF00Deleted and added to blacklist:%s|r"

-- 动作条
L["向上排列"] = "Grow Bar Upwards"
L["向上排列说明"] = "This growns the bars upwards when in a horizontal layout"
L["显示冷却时间"] = "Show Cooldown Text"
L["冷却时间数字大小"] = "Cooldown Text Size"
L["冷却时间数字大小提示"] = "This value only affects cooldown frames which size is bigger than 25*25pixel,\n others have their appropriate sized text.\nNote that the cooldown text won't show if it's too small."
L["显示冷却时间提示"] = "Displaying cooldown text on action buttons, inventory items, etc."
L["显示冷却时间提示WA"] = "Displaying cooldown text on Weakauras displays"
L["不可用颜色"] = "Unusable Color"
L["不可用颜色提示"] = "Change the color of standard action buttons when they are unusable.\nLike out of range, mana, etc."
L["键位字体大小"] = "Keybind Text Font Size"
L["宏名字字体大小"] = "Macro Name Text Font Size"
L["可用次数字体大小"] = "Count Text Font Size"

L["条件渐隐"] = "Conditional Fading"
L["条件渐隐提示"] = "Enable Fading when you are not casting, not in combat,\ndon't have a target and got max health or max/min power, etc."
L["悬停渐隐"] = "Hover Fading"
L["悬停渐隐提示"] = "Enble Actionbar Fading when your mouse is not hovering over them."
L["渐隐透明度"] = "Fading Alpha"
L["渐隐透明度提示"] = "Fade-out minimum alpha"

L["主动作条"] = "MainActionbar"
L["额外动作条"] = "MultiActionBar"
L["额外动作条布局"] = "MultiActionBar Layout"
L["额外动作条间距"] = "Space"
L["额外动作条间距提示"] = "The space between the left part and the right part are (bar12's width + 2*space1).\nOnly available when you enable the 3x2x2 layout."
L["6*4布局"] = "Layout 6*4"
L["右侧额外动作条"] = "RightMultiActionBar"
L["宠物动作条"] = "Pet Actionbar"
L["5*2布局"] = "Layout 5*2"
L["5*2布局提示"] = "Use Layout 5*2 for Pet Actionbar, disable to use layout 10*1."
L["姿态/形态条"] = "Stance Bar"
L["离开载具按钮"] = "Leave Vehicle Button"
L["额外特殊按钮"] = "Extrabar Button"
L["横向动作条"] = "Horizontal RightMultiActionBar"

L["冷却提示"] = "Cooldown Alert"
L["透明度"] = "Alpha"
L["忽略法术"] = "Ignore Spells"
L["忽略物品"] = "Ignore Items"

-- 姓名板
L["姓名板tip"] = "How do you want to display the nameplates?"
L["数字样式"] = "Numberic Style"
L["职业色-条形"] = "Class Color Bar"
L["深色-条形"] = "Dark Color Bar"
L["仇恨染色"] = "Enchat Threat Color to Nameplates."
L["自定义颜色"] = "Custom Color"
L["空"] = "Empty"
L["我的法术"] = "My Auras"
L["其他法术"] = "Other Auras"
L["黑名单"] = "Black List"
L["全部隐藏"] = "Hide All"
L["过滤方式"] = "Filter Type"
L["显示玩家姓名板"] = "Show My Nameplate"
L["显示玩家姓名板光环"] = "Show Aura Icons on My Nameplate"
L["显示玩家施法条"] = "Show Castbar on My Nameplate"
L["姓名板资源位置"] = "Resources Position"
L["姓名板资源尺寸"] = "Player Resource Width"
L["目标姓名板"] = "Target Nameplate"
L["玩家姓名板"] = "My Nameplate"
L["名字字体大小"] = "Name fontsize"
L["可打断施法条颜色"] = "Interruptible castbar color"
L["不可打断施法条颜色"] = "Not interruptible castbar color"
L["自定义能量"] = "Custom Power"
L["数值样式"] = "Value form"
L["百分比"] = "Perc"
L["数值和百分比"] = "Value+Perc"
L["条形样式"] = "Bar"
L["友方只显示名字"] = "Name-only on friendly units"
L["根据血量染色"] = "Color according to hp perc"
L["焦点染色"] = "Color focus target"
L["焦点颜色"] = "Focus color"
L["图标数字大小"] = "Icon number size"
L["空"] = "Empty"
L["自定义能量"] = "Custom Nameplate Power List"
L["自定义颜色"] = "Custom Nameplate Color List"
L["列表已满"] = "%s is full."
L["添加自定义颜色"] = "Add [%s] to Custom Nameplate Color List"
L["添加自定义能量"] = "Add [%s] to Custom Nameplate Power List"
L["移除自定义颜色"] = "Remove |cff%02x%02x%02x[%s]|r from Custom Nameplate Color List"
L["移除自定义能量"] = "Remove [%s] from Custom Nameplate Power List"
L["替换自定义颜色"] = "Replace |cff%02x%02x%02x[%s]|r from Custom Nameplate Color List"
L["已加入列表"] = "|cff7FFF00Added successfully|r Added |cff%02x%02x%02x[%s]|r to %s."
L["已从列表移除"] = "|cff00FFFFRemoved successfully|r Removed |cff%02x%02x%02x[%s]|r from %s."

-- 鼠标提示
L["跟随光标"] = "Show at Mouse"
L["隐藏服务器名称"] = "Hide Realm"
L["隐藏称号"] = "Hide Title"
L["显示法术编号"] = "Show SpellID"
L["显示物品编号"] = "Show ItemID"
L["显示天赋"] = "Show Talent"
L["战斗中隐藏"] = "Hide in Combat"
L["背景透明度"] = "Backdrop Opacity"
L["大秘境评分"] = "Challenge Mode Score"
L["副本"] = "Instance"
L["评分层数"] = "Score（Highest Level）"

-- 战斗信息
L["战斗信息"] = "Combat Text"
L["承受伤害/治疗"] = "Received Healing/Damage Text"
L["输出伤害/治疗"] = "Output Healing/Damage Text"
L["数字缩写样式"] = "abbreviated style"
L["暴击图标大小"] = "Crit Icon Size"
L["显示DOT"] = "Show Dot"
L["显示HOT"] = "Show Hot"
L["显示宠物"] = "Show Pet"
L["隐藏时间"] = "Fade time"
L["隐藏时间提示"] =  "Amount of time for which combat text remains visible before beginning to fade out"
L["隐藏浮动战斗信息接受"] = "Hide Blizzard combat text(OutPut Healing/Damage Text)"
L["隐藏浮动战斗信息输出"] = "Hide Blizzard combat text(Received Healing/Damage Text)"

-- 其他
L["界面风格"] = "Color Theme"
L["界面风格tip"] = "How do you want to display the UnitFrames?"
L["透明样式"] = "Transparent Theme"
L["深色样式"] = "Dark Theme"
L["普通样式"] = "Classic Theme"
L["小地图尺寸"] = "Minimap Size"
L["系统菜单尺寸"] = "Micromenu Scale"
L["信息条"] = "Info Bar"
L["信息条尺寸"] = "Info Bar Scale"
L["整理小地图图标"] = "Collect minimapbuttons"
L["整理栏位置"] = "Finishing box position"
L["成就截图"] = "Achievement Shot"
L["成就截图提示"] = "Take a screenshot when you earn an achievement."
L["自动接受复活"] = "Accept Resurrects"
L["自动接受复活提示"] = "Accept Resurrects, only available when out of combat."
L["战场自动释放灵魂"] = "Releases Spirit in BG"
L["战场自动释放灵魂提示"] = "Releases your spirit in BG, Wintergrasp and Tol Barad."
L["隐藏错误提示"] = "Hide Errors"
L["隐藏错误提示提示"] = "Hide the red errors texts, like out of range, etc."
L["自动接受邀请"] = "Accept Invites"
L["自动接受邀请提示"] = "Accept invites from your friends or guild members."
L["自动交接任务"] = "Auto Quests"
L["自动交接任务提示"] = "Automatically receive and turn in quests. Hold down Shift to temporarily suppress this function."
L["显示插件使用小提示"] = "Show addon tips when afk"
L["显示插件使用小提示提示"] = "Show addon tips on bottom of the screen when afk"
L["出现了！"] = "spotted!"
L["稀有警报"] = "Vignette alert"
L["稀有警报提示"] = "Display the vignette-ids introduced with 5.0.4 (chests, rare mobs etc) with name and icon on screen."
L["任务栏闪动"] = "Flash task bar"
L["任务栏闪动提示"] = "Flashes the taskbar when you are alt-tabbed and Dungeon, LFR or BG queue pops up."
L["自动召宝宝"] = "Automatically summon a pet"
L["自动召宝宝提示"] = "Automatically summon a pet when you login, resurrect or leave vehicle."
L["随机奖励"] = "LFG RoleShortage Alert"
L["随机奖励提示"] = "Raid Warning alert when LFG RoleShortage Rewards are available; only available when solo."
L["在战斗中隐藏小地图"] = "Hide minimap in combat"
L["在战斗中隐藏聊天框"] = "Hide chatframe in combat"
L["在副本中收起任务追踪"] = "Collapse tracker in instances"
L["在副本中收起任务追踪提示"] = "Collapse ObjectiveTracker when entering an instances/battleground, expand it when you leave."
L["提升截图画质"] = "Upgrade Screenshot picture quality"
L["截图保存为tga格式"] = "Screenshot saved as TGA format"
L["登陆屏幕"] = "Hide Interface on Login"
L["暂离屏幕"] = "Hide interface when AFK"
L["快速焦点"] = "Use SHIFT+Click to set focus."
L["自定义任务追踪"] = "Custom Objective Tracker"
L["自定义任务追踪提示"] = "Enable this if you are using a custom objective tracker addon.\n  (ex: Dugi Questing Essential, Kaliel's Tracker)"
L["快速标记"] = "Use Ctrl+Click to add raid mark."

-- 插件界面
L["当前经验"] = "Current: "
L["剩余经验"] = "Remaining: "
L["双倍"] = "Rested: "
L["声望"] = "Rep:"
L["剩余声望"] = "Remaining: "
L["占用前 %d 的插件"] = "Top %d AddOns"
L["自定义插件占用"] = "UI Memory usage"
L["所有插件占用"] = "Total incl. Blizzard"
L["团队工具"] = "RaidTools"
L["脱装备"] = "Undress All"
L["一直显示插件按钮"] = "Always show addon buttons"
L["小地图按钮"]	= "Altz UI Button"

-- 插件提示
L["上一条"] = "Previous"
L["下一条"] = "Next"
L["我不想看到这些提示"] = "I don't want to see them"
L["隐藏提示的提示"] = "You can re-enable these tips in GUI → Other"
L["TIPS"] = {
	"Altz UI can hide the minimap and chat frame when you enter combat and show them when you leave. GUI → Other",
	"Click the clock on the minimap to open the calendar; right click changes between local/server time while a modified right click (holding alt, ctrl, or shift) changes 12/24 format.",
	"Want to display the independent castbar? GUI → Unit Frames → Castbar → Independent player castbar",
	"Want to use the healer-style raid frame? GUI → Raid Frames → Switch → click Disable Auto Switch and Healer",
	"Want to use a custom color of the nameplate of a specific unit? GUI → Unit Nameplates → Custom Color",
	"/rl - reload UI",
	"/hb - Key Binding Mode",
	"Use SHIFT+Click to set your focus; it's available for unit frames",
	"Use ALT+Click to mill/prospect, disenchant, unlock instantly",
	"Press Tab to change between available channels when the edit box of the chat frame is activated",
	"The font files are located at Interface\\AddOns\\AuroraClassic\\media\\font.ttf(main font),Interface\\AddOns\\AltzUI\\media\\number.ttf(font for some time text)",
	"Hold Ctrl, Alt or Shift to scroll chat frame to top/bottom.",
}

-- 界面移动
L["界面移动工具"] = "Frame Mover"
L["锚点框体"] = "Anchor Frame"
L["重置位置"] = "Reset this frame to it's default position."
L["healer"] = "|cff76EE00Healer|r"
L["dpser"] = "|cffE066FFDps/Tank|r"
L["选中的框体"] = "CurrentFrame"
L["当前模式"] = "CurrentMode"
L["进入战斗锁定"] = "Entered combat, lock all frames."
L["锁定框体"] = "Lock all frames"
L["解锁框体"] = "Unlock all frames"
L["重置框体位置"] = "Reset Positions"
L["重置确认"] = "Do you want to reset all frame positions？"
L["信息条"] = "Info Bar"
L["承受伤害"] = "Received\nDamage Text"
L["承受治疗"] = "Received\nHealing Text"
L["输出伤害"] = "Output\nDamage Text"
L["输出治疗"] = "Output\nHealing Text"
L["团队框架"] = "Raid Frame"
L["宠物团队框架"] = "Pet\nRaid Frame"
L["玩家头像"] = "Player Frame"
L["宠物头像"] = "Pet Frame"
L["目标头像"] = "Target Frame"
L["目标的目标头像"] = "ToT Frame"
L["焦点头像"] = "Focus Frame"
L["焦点的目标头像"] = "ToF Frame"
L["首领头像"] = "Boss"
L["竞技场敌人头像"] = "Arena"
L["小队队友"] = "Party"
L["玩家施法条"] = "Player Cast Bar"
L["目标施法条"] = "Target Cast Bar"
L["焦点施法条"] = "Focus Cast Bar"
L["玩家平砍计时条"] = "Player Swing Timer"
L["冷却提示"] = "Cooldown Alert"
L["图腾条"] = "Totem Bar"
L["多人坐骑控制框"] = "Vehicle Seat Indicator"
L["耐久提示框"] = "Durability Frame"
L["主菜单和背包"] = "Micro Button And Bags Bar"

-- 插件皮肤
L["界面布局"] = "Layout"
L["界面布局tip"] = "How do you want to layout the Interface?"
L["默认布局"] = "Default Layout"
L["极简布局"] = "Minimal Layout"
L["聚合布局"] = "Centralized layout"
L["插件皮肤"] = "Addon Skins"
L["更改设置"] = "Reset Addon"
L["更改设置提示"] = "Load default settings for this addon"
L["边缘装饰"] = "Strip Decoration"
L["两侧装饰"] = "Decoration on both sides"
L["战斗字体"] = "Combat Text"

-- 命令
L["命令"] = "Commands"
L["指令"] = " %s/rl|r - Reload UI \n \n %sALT+Click|r - Mill/Prospect/Disenchant/Unlock instantly \n \n %sTab|r - Change between available channels. \n \n %s/Setup|r-Run the setup wizard"

-- 制作
L["制作"] = "Credits"
L["制作说明"] = "AltzUI ver %s \n \n \n \n Paopao zhCN \n \n \n \n %s Thanks to \n \n %s \n and everyone who help me with this Compilations.|r"
