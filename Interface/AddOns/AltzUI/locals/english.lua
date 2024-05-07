local T, C, L, G = unpack(select(2, ...))
if G.Client == "zhCN" or G.Client == "zhTW" then return end

--====================================================--
--[[           -- 更新日志和插件提示 --             ]]--
--====================================================--
L["更新日志tip"] = "New feature:\nUpdate for 10.00"

L["TIPS"] = {
	"Click the date on the minimap to open the calendar",
	"Right click on the minimap to open the minimap tracking menu",
	"Want to display the independent castbar? GUI → Unit Frames → Castbar → Independent player castbar",
	"Want to use a custom color of the nameplate of a specific unit? CTRL+click on the mob's dropdown menu and select,or GUI → Unit Nameplates → Custom",
	"/rl - reload UI",
	"/hb - Key Binding Mode",
	"Use SHIFT+Click to set your focus; it's available for unit frames",
	"Use ALT+Click to mill/prospect, disenchant, unlock instantly",
	"Press Tab to change between available channels when the edit box of the chat frame is activated",
	"Hold Ctrl, Alt or Shift to scroll chat frame to top/bottom.",
}

L["指令"] = [[
/rl - Reload UI
/Setup-Run the setup wizard
SHIFT+Click - set focus to current mouseover target
Ctrl+Click - add raid mark to current mouseover target
ALT+Click - Mill/Prospect/Disenchant/Unlock instantly
Tab - Change between available channels
]]

--====================================================--
--[[                 -- 通用 --                     ]]--
--====================================================--
L["生效"] = " to take effect"
L["稍后重载"] = "Reload later"
L["脱离战斗"] = "Leave combat"
L["冷却"] = "Cooldown"
L["光环"] = "Auras"
L["增益"] = "Buffs"
L["减益"] = "Debuffs"
L["副本"] = "Instance"
L["全局"] = "Global"
L["可打断"] = "Interruptible"
L["不可打断"] = "Not interruptible"
L["焦点"] = "Focus"
L["目标的目标"] = "ToT"
L["焦点的目标"] = "ToF"

--====================================================--
--[[                 -- 控制台 --                   ]]--
--====================================================--
L["复制粘贴"] = "Ctrl+C/Ctrl+V copy/paste"
L["界面"] = "Interface"
L["控制台"] = "GUI"
L["设置"] = "Edit"
L["启用"] = "Enable"
L["重置"] = "Reset"
L["重置确认"] = "Do you want to reset all the %s settings?"
L["显示"] = "Show"
L["隐藏"] = "Hide"
L["总是"] = "Always"
L["一般"] = "General"

L["字体"] = "Font"
L["数字"] = "Number"
L["图标"] = "Icon"
L["时间"] = "Time"

L["尺寸"] = "Size"
L["高度"] = "Height"
L["宽度"] = "Width"
L["数量"] = "Number"
L["百分比"] = "Perc"
L["数值"] = "Value"
L["大小"] = "Size"
L["长度"] = "Length"
L["样式"] = "Style"
L["独立"] = "Independent"
L["位置"] = "Position"
L["透明度"] = "Alpha"
L["颜色"] = "Color"

L["左"] = "Left"
L["右"] = "Right"
L["上"] = "Up"
L["下"] = "Down"
L["中间"] = "Center"
L["左上"] = "Top Left"
L["右上"] = "Top Right"
L["左下"] = "Bottom Left"
L["右下"] = "Bottom Right"
L["上方"] = "Top"
L["下方"] = "Bottom"
L["排列方向"] = "Anchor"
L["垂直"] = "Vertical"
L["水平"] = "Horizontal"
L["排列顺序"] = "Order"
L["正序"] = "Ascending"
L["反序"] = "Descending"

L["法术编号"] = "SpellID"
L["物品编号"] = "ItemID"
L["输入法术ID"] = "Input a spellID"
L["不是一个有效的法术ID"] = "is not a correct spell ID"
L["物品名称ID链接"] = "Item name/ID/link"
L["不正确的物品ID"] = "Incorrect Item name/ID/link"
L["物品数量"] = "Quantity"
L["必须是一个数字"] = "should be a number."

L["白名单"] = "Always display"
L["黑名单"] = "Never display"
L["优先级"] = "Priority"

L["命令"] = "Commands"
L["制作"] = "Credits"
L["制作说明"] = "AltzUI ver %s \n \n \n \n Paopao zhCN \n \n \n \n Thanks to \n \n %s \n and everyone who help me with this Compilations."

--====================================================--
--[[                 -- 安装 --                     ]]--
--====================================================--
L["小泡泡"] = "Paopao"
L["欢迎使用"] = "Welcome to Altz UI Setup"
L["简介"] = "Altz UI is a minimalistic compilation with in-game configuration supported. Suggest taking a few minutes to quickly set up the addon."
L["上一步"] = "Previous"
L["下一步"] = "Next"
L["完成"] = "Finish"
L["跳过"] = "Skip Setup Wizard"
L["设置向导"] = "Setup Wizard"
L["界面风格tip"] = "How do you want to display the UnitFrames?"
L["界面布局"] = "Layout"
L["界面布局tip"] = "How do you want to layout the Interface?"
L["默认布局"] = "Default Layout"
L["极简布局"] = "Minimal Layout"
L["聚合布局"] = "Centralized layout"
L["姓名板tip"] = "How do you want to display the nameplates?"
L["更新日志"] = "Update Log"

--====================================================--
--[[        -- 导入、导出设置 --                    ]]--
--====================================================--
L["导入"] = "Import"
L["导出"] = "Export"
L["导入确认"] = "Do you want to import all the %s settings?\n"
L["版本不符合"] = "\nImport Version %s（Current Version %s）"
L["客户端不符合"] = "\nGame Client %s（Current Client %s）"
L["职业不符合"] = "\nClass %s（Current Class %s）"
L["不完整导入"] = "\nMay not import completely."
L["无法导入"] = "Cannot Import"

--====================================================--
--[[                 -- 界面移动 --                 ]]--
--====================================================--
L["锚点"] = "Anchor"
L["锚点框体"] = "Anchor Frame"
L["对齐到"] = "Align to"
L["屏幕"] = "Screen"
L["当前模式"] = "CurrentMode"
L["healer"] = "|cff76EE00Healer|r"
L["dpser"] = "|cffE066FFDps/Tank|r"

--====================================================--
--[[                   -- 界面 --                   ]]--
--====================================================--
L["当前经验"] = "Current: "
L["剩余经验"] = "Remaining: "
L["双倍"] = "Rested: "
L["声望"] = "Rep:"
L["剩余声望"] = "Remaining: "
L["占用前 %d 的插件"] = "Top %d AddOns"
L["自定义插件占用"] = "UI Memory usage"
L["所有插件占用"] = "Total incl. Blizzard"
L["脱装备"] = "Undress All"
L["一直显示插件按钮"] = "Always show addon buttons"
L["小地图按钮"]	= "Altz UI Button"

L["界面风格"] = "Color Theme"
L["透明样式"] = "Transparent Theme"
L["深色样式"] = "Dark Theme"
L["普通样式"] = "Classic Theme"
L["数字缩写样式"] = "abbreviated style"
L["信息条"] = "Info Bar"
L["暂离屏幕"] = "Hide interface when AFK"
L["显示插件使用小提示"] = "Show addon tips when afk"
L["显示插件使用小提示提示"] = "Show addon tips on bottom of the screen when afk"
L["隐藏提示的提示"] = "You can re-enable these tips in Interface → Layout"
L["在副本中收起任务追踪"] = "Collapse tracker in instances"
L["在副本中收起任务追踪提示"] = "Collapse ObjectiveTracker when entering an instances/battleground, expand it when you leave."

L["未加载插件"] = "%s addon not loaded"
L["插件皮肤"] = "Addon Skins"
L["职业颜色"] = "Class Colors"
L["鲜明"] = "Bright"
L["原生"] = "Original"
L["BW计时条皮肤"] = "BigWigs timer skin"
L["更改设置提示"] = "Load default settings for this addon"
L["边缘装饰"] = "Strip Decoration"
L["两侧装饰"] = "Decoration on both sides"
L["快速删除"] = "Quick Delete"

--====================================================--
--[[                 -- 社交 --                     ]]--
--====================================================--
L["滚动聊天框"] = "Scroll Chat Frame"
L["滚动聊天框提示"] = "Auto Scroll Chat Frame to bottom after 15 seconds."
L["频道缩写"] = "Replace Channel Name"
L["复制聊天"] = "Copy Chat"
L["显示聊天框背景"] = "Show background for chat frames."
L["自动邀请"] = "Key Word Invite"
L["自动邀请提示"] = "Auto Invite people whispered key words"
L["关键词"] = "Key Word"
L["关键词输入"] = "Input key words separated by a space"
L["无法自动邀请进组:"] = "I can't invite you:"
L["我不能组人"] = "I'm not a raid leader or an assistant"
L["小队满了"] = "party is full"
L["团队满了"] = "raid is full"
L["客户端错误"] = "I can't invite you by keyword now, your account seems to be sticking to %s."
L["聊天过滤"] = "Chat Filter"
L["聊天过滤提示"] = "Hide repeated chat messages and chat messages containing key word(s) below."
L["过滤阈值"] = "Chat Filter Keyword Number"
L["自动接受好友的组队邀请"] = "Automatically accept team invitations from friends"
L["自动接受公会成员的组队邀请"] = "Automatically accept team invitations from guild members"
L["自动接受社区成员的组队邀请"] = "Automatically accept team invitations from club members"
L["自动接受同一战网其他角色的组队邀请"] = "Automatically accept team invitations from other characters in the same battle net"
L["拒绝陌生人的组队邀请"] = "Refusing team invitations from strangers"
L["邀请过滤"] = "|cff7FFF00[Invitation filtering]|r Received a stranger team invitation from |cff00FFFF%s|r, rejected"

--====================================================--
--[[                 -- 物品 --                     ]]--
--====================================================--
L["自动修理"] = "Auto Repair"
L["自动修理提示"] = "Automatically repair items"
L["优先使用公会修理"] = "Auto Guild Repair"
L["优先使用公会修理提示"] = "Use Guild funds for auto repairs, use your own money when go over guild repair limit."
L["修理花费"] = "Repair Cost:"
L["自动售卖"] = "Auto Sell"
L["自动售卖提示"] = "Automatically sell greys"
L["已会配方着色"] = "Colorizes Known Items"
L["已会配方着色提示"] = "Colorizes the item that is already known in some default frames."
L["自动购买"] = "Auto Buy"
L["自动购买提示"] = "Automatically buy items in the list below."
L["购买"] = "Bought %d %s.%s"
L["每次最多购买"] = "Purchase up to %d at a time"
L["赚得"] = "Earned:"
L["消费"] = "Spent:"
L["赤字"] = "Deficit:"
L["盈利"] = "Profit:"
L["本次登陆"] = "Session"
L["服务器"] = "Server"
L["角色"] = "Character"
L["重置金币信息"] = "Click to reset."

--====================================================--
--[[               -- 单位框架 --                   ]]--
--====================================================--
L["单位框架"] = "Unit Frames"
L["显示冷却"] = "Show %s's cooldown."
L["生命值"] = "HP"
L["能量值"] = "PP"
L["总是显示数值提示"] = "disable to show %s only when it's not full."
L["肖像"] = "Portrait"
L["宽度提示"] = "The width for player, target and focus frame"
L["能量条"] = "Powerbar"
L["施法条"] = "Castbar"
L["平砍计时条"] = "Swing Timer"
L["过滤增益"] = "Target Aura Filter: Ignore Buff"
L["过滤增益提示"] = "Hide others' buff on friendly target."
L["过滤减益"] = "Target Aura Filter: Ignore Debuff"
L["过滤减益提示"] = "Hide others' debuffs on enemy target."
L["图腾条"] = "Totembar"
L["PvP标记"] = "PvP Icon"
L["PvP标记提示"] = "Recommand in a PvE Server"
L["法力条"] = "mana bar"
L["法力条提示"] = "show mana bar for Dps Specialization"
L["仇恨条"] = "threat bar"
L["醉拳条"] = "stagger bar"
L["徽章冷却就绪"] = "%s's TrinketPVP is ready"
L["使用了徽章"] = "%s uses TrinketPVP"

L["团队框架"] = "Raid Frame"
L["未进组时显示"] = "Show Solo"
L["团队规模"] = "Group Size"
L["治疗法力条"] = "Display the mana bars of healing duty players in the group"
L["治疗法力条高度"] = "Healing mana bar height"
L["GCD"] = "GCD Bar"
L["GCD提示"] = "Show GCD bar on raid frame."
L["缺失生命值"] = "Missing HP"
L["缺失生命值提示"] = "Display missing health when health is less than 90% \ nDisplay name when health is greater than 90%"
L["治疗和吸收预估"] = "Heal Prediction and Absorb effects"
L["治疗和吸收预估提示"] = "Show heal prediction bar and absorb bar on raid frame."
L["点击施法"] = "Click-Cast"
L["当前设置"] = "Current settings"
L["Button1"] = "Left"
L["Button2"] = "Right"
L["Button3"] = "Middle"
L["Button4"] = "4"
L["Button5"] = "5"
L["MouseUp"] = "MouseUp"
L["MouseDown"] = "MouseDown"
L["打开菜单"] = "Toggle Menu"
L["输入一个宏"] = "Enter a macro"
L["主坦克和主助手"] = "tank icon and main assist icon"
L["主坦克和主助手提示"] = "show tank icon and main assist icon on raid frames"
L["治疗指示器"] = "Healer Indicators"
L["数字指示器"] = "Number-style Indicators"
L["图标指示器"] = "Icon-style Indicators"
L["自动添加团队减益"] = "Automatically add newly discovered Raid&Dungeon debuffs to the list"
L["自动添加团队减益提示"] = "The newly-discovered Raid&Dungeon debuffs are automatically added to the list. You can delete the newly added debuffs from the debuff list, or disable them from being displayed through the debuff blacklist filter."
L["自动添加的图标层级"] = "Aura Priority"
L["添加团队减益"] = "|cff7FFF00Raid Debuff added successfully|r %s %s"
L["杂兵"] = "Trash"
L["删除并加入黑名单"] = "Delete and add to blacklist"
L["已删除并加入黑名单"] = "|cff7FFF00Deleted and added to blacklist:%s|r"
L["团队工具"] = "RaidTools"

--====================================================--
--[[                 -- 动作条 --                   ]]--
--====================================================--
L["显示冷却时间提示"] = "Displaying cooldown text on action buttons, inventory items, etc."
L["显示冷却时间提示WA"] = "Displaying cooldown text on Weakauras displays"
L["不可用颜色"] = "Beyond distance action bar turns red"
L["不可用颜色提示"] = "Change the color of standard action buttons when they are out of range."
L["键位"] = "Keybind"
L["次数"] = "Count"
L["条件渐隐"] = "Conditional Fading"
L["条件渐隐提示"] = "Enable Fading when you are not casting, not in combat,\ndon't have a target and got max health or max/min power, etc."
L["渐隐透明度"] = "Fading Alpha"
L["渐隐透明度提示"] = "Fade-out minimum alpha"
L["冷却提示"] = "Cooldown Alert"

--====================================================--
--[[                 -- 姓名板 --                   ]]--
--====================================================--
L["数字样式"] = "Numberic Style"
L["职业色-条形"] = "Class Color Bar"
L["深色-条形"] = "Dark Color Bar"
L["仇恨染色"] = "Enchat Threat Color to Nameplates."
L["过滤方式"] = "Filter Type"
L["我施放的光环"] = "Auras I casted"
L["其他人施放的光环"] = "Auras others casted"
L["全部隐藏"] = "Hide All"
L["玩家姓名板"] = "My Nameplate"
L["友方只显示名字"] = "Name-only on friendly units"
L["根据血量染色"] = "Color according to hp perc"
L["焦点染色"] = "Color focus target"
L["自定义能量"] = "The nameplate of the following NPCs displays an energy bar"
L["自定义颜色"] = "The nameplate of the following NPCs display custom colors"
L["输入npc名称"] = "Imput npc name"
L["添加自定义能量"] = "Add [%s] to Custom Nameplate Power List"
L["移除自定义能量"] = "Remove [%s] from Custom Nameplate Power List"
L["添加自定义颜色"] = "Add [%s] to Custom Nameplate Color List"
L["移除自定义颜色"] = "Remove |cff%02x%02x%02x[%s]|r from Custom Nameplate Color List"
L["替换自定义颜色"] = "Replace |cff%02x%02x%02x[%s]|r from Custom Nameplate Color List"

--====================================================--
--[[                 -- 鼠标提示 --                 ]]--
--====================================================--
L["鼠标提示"] = "Game Tooltip"
L["战斗中隐藏"] = "Hide in Combat"
L["评分层数"] = "Score（Highest Level）"

--====================================================--
--[[                 -- 战斗信息 --                 ]]--
--====================================================--
L["战斗数字"] = "Combat Text"
L["滚动战斗数字"] = "Scrolling combat text"
L["承受伤害"] = "Received\nDamage Text"
L["承受治疗"] = "Received\nHealing Text"
L["输出伤害"] = "Output\nDamage Text"
L["输出治疗"] = "Output\nHealing Text"
L["承受伤害/治疗"] = "Received Healing/Damage Text"
L["输出伤害/治疗"] = "Output Healing/Damage Text"
L["浮动战斗数字"] = "Blizzard combat text"

--====================================================--
--[[                   -- 其他 --                   ]]--
--====================================================--
L["讯息提示"] = "Message prompt"
L["隐藏错误提示"] = "Hide Errors"
L["隐藏错误提示提示"] = "Hide the red errors texts, like out of range, etc."
L["稀有警报"] = "Vignette alert"
L["稀有警报提示"] = "Display the vignette-ids introduced with 5.0.4 (chests, rare mobs etc) with name and icon on screen."
L["出现了！"] = "spotted!"
L["任务栏闪动"] = "Flash task bar"
L["任务栏闪动提示"] = "Flashes the taskbar when you are alt-tabbed and Dungeon, LFR or BG queue pops up."
L["随机奖励"] = "LFG RoleShortage Alert"
L["随机奖励提示"] = "Raid Warning alert when LFG RoleShortage Rewards are available; only available when solo."

L["辅助功能"] = "Auxiliary functions"
L["成就截图"] = "Achievement Shot"
L["成就截图提示"] = "Take a screenshot when you earn an achievement."
L["提升截图画质"] = "Upgrade Screenshot picture quality"
L["自动接受复活"] = "Accept Resurrects"
L["自动接受复活提示"] = "Accept Resurrects, only available when out of combat."
L["战场自动释放灵魂"] = "Releases Spirit in BG"
L["战场自动释放灵魂提示"] = "Releases your spirit in BG, Wintergrasp and Tol Barad."
L["自动召宝宝"] = "Automatically summon a pet"
L["自动召宝宝提示"] = "Automatically summon a pet when you login, resurrect or leave vehicle."
L["优先偏爱宝宝"] = "Prioritize summoning preferred pets"
L["优先偏爱宝宝提示"] = "Prioritize summoning small pets set as preferred, otherwise randomly summon one."
