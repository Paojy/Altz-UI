local T, C, L, G = unpack(select(2, ...))
if G.Client == "zhCN" or G.Client == "zhTW" then return end

L["团队工具"] = "RaidTools"

L["当前经验"] = "Current: "
L["剩余经验"] = "Remaining: "
L["双倍"] = "Rested: "
L["声望"] = "Rep:"
L["剩余声望"] = "Remaining: "
L["占用前 %d 的插件"] = "Top %d AddOns"
L["自定义插件占用"] = "UI Memory usage"
L["所有插件占用"] = "Total incl. Blizzard"

L["Fire!"] = "Fire!"

L["赚得"] = "Earned:"
L["消费"] = "Spent:"
L["赤字"] = "Deficit:"
L["盈利"] = "Profit:"
L["本次登陆"] = "Session"
L["服务器"] = "Server"
L["角色"] = "Character"
L["重置金币信息"] = "Click to reset."

L["脱装备"] = "Undress All"
L["切天赋"] = "Change Active Spec"

L["锁定框体"] = "Lock all frames"
L["解锁框体"] = "Unlock all frames"
L["重置框体位置"] = "Reset Positions"

L["你不能在战斗中绑定按键"] = "You can't bind keys in combat."
L["按键绑定解除"] = "Keybinding reset to defaults"
L["所有键位设定保存"] = "All keybindings have been saved."
L["刚才的键位设定修改取消了"] = "All newly set keybindings have been discarded."
L["绑定到"] = "bound to"
L["绑定模式"] = "Hover your mouse over any action button to bind it. Press the escape key or right click to clear the current action button's keybinding."
L["没有绑定键位"] = "No bindings set."
L["绑定"] = "Binding"
L["键位"] = "Key"
L["保存键位"] = "Save bindings"
L["取消键位"] = "Discard bindings"

L["被闷了"] = "Sapped!"
L["被闷了2"] = "sapped by:"

L["修理花费"] = "Repair Cost:"

L["整理"] = "S"
L["背包"] = "B"

L["复制名字"] = "Copy Name"
L["玩家详情"] = "Who"
L["公会邀请"] = "Guild Invite"
L["添加好友"] = "Add Friend"

L["信息条"] = "Info Bar"
L["微型菜单"] = "MicroMenu"
L["控制台"] = "Config"
L["主动作条"] = "Main\nActionbar"
L["额外动作条"] = "Multi\nActionBar"
L["右侧额外动作条"] = "RightMulti\nActionBar"
L["宠物动作条"] = "Pet Actionbar"
L["姿态/形态条"] = "Stance Bar"
L["离开载具按钮"] = "Leave\nVehicle"
L["额外特殊按钮"] = "Extrabar\nButton"
L["增益框"] = "Buff"
L["减益框"] = "Debuff"
L["ROLL点框"] = "Loot Group"
L["鼠标提示"] = "Tooltip"
L["承受伤害"] = "Received\nHealing Text"
L["承受治疗"] = "Received\nDamage Text"
L["输出伤害"] = "Output\nHealing Text"
L["输出治疗"] = "Output\nDamage Text"
L["任务追踪"] = "Watch Frame"
L["小地图缩放按钮"] = "Minimap\nToggle Button"
L["聊天框缩放按钮"] = "ChatFrame\nToggle Button"
L["背包框"] = "Bag Frame"
L["银行框"] = "Bank Frame"
L["输出模式团队框架"] = "Dps/Tank\nRaid Frame"
L["输出模式宠物团队框架"] = "Dps/Tank\nPet\nRaid Frame"
L["治疗模式团队框架"] = "Healing\nRaid Frame"
L["治疗模式宠物团队框架"] = "Healing\nPet\nRaid Frame"
L["玩家头像"] = "Player Frame"
L["宠物头像"] = "Pet Frame"
L["目标头像"] = "Target Frame"
L["目标的目标头像"] = "ToT Frame"
L["焦点头像"] = "Focus Frame"
L["焦点的目标头像"] = "ToF Frame"
for i = 1, MAX_BOSS_FRAMES do
	L["首领头像"..i] = "Boss"..i
end
for i = 1, 5 do
	L["竞技场敌人头像"..i] = "Arena"..i
end
L["玩家施法条"] = "Player Cast Bar"
L["目标施法条"] = "Target Cast Bar"
L["焦点施法条"] = "Focus Cast Bar"
L["玩家平砍计时条"] = "Player Swing Timer"
L["冷却提示"] = "Cooldown Alert"
L["图腾条"] = "Totem Bar"
L["便捷物品按钮"] = "Convenient Item Buttons"
L["多人坐骑控制框"] = "Vehicle Seat Indicator"
L["耐久提示框"] = "Durability Frame"

L["无2"] = "|cffFF0000No|r"
L["无"] = "No"
L["合剂"] = "Flask"
L["食物"] = "Food"
L["过远"] = "OoR"
L["距离过远"] = "Out of range"
L["dbm_pull"] = "Pull"
L["dbm_lag"] = "Check Lag"
L["需要加载DBM"] = "DBM needs to be enabled for this option."
L["无合剂增益"] = "No one has flask buff."
L["无食物增益"] = "No one has food buff."
L["全合剂增益"] = "Everyone has flask buff."
L["全食物增益"] = "Everyone has food buff."
L["偷药水"] = "Didn't have potion buff when combat started: "
L["全偷药水"] = "Everyone had potion buff when combat started."
L["药水"] = "Didn't use a potion during combat: "
L["全药水"] = "Everyone used a potion during combat."

L["无法自动邀请进组:"] = "I can't invite you:"
L["我不能组人"] = "I'm not a raid leader or an assistant"
L["小队满了"] = "party is full"
L["团队满了"] = "raid is full"
L["客户端错误"] = "I can't invite you by keyword now, your account seems to be sticking to %s."

L["的徽章冷却就绪"] = "'s TrinketPVP is ready"
L["使用了徽章"] = " uses TrinketPVP"

L["界面移动工具"] = "Frame Mover"
L["锚点框体"] = "Anchor Frame"
L["重置位置"] = "Reset this frame to it's default position."
L["healer"] = "|cff76EE00Healer|r"
L["dpser"] = "|cffE066FFDps/Tank|r"
L["选中的框体"] = "CurrentFrame"
L["当前模式"] = "CurrentMode"
L["进入战斗锁定"] = "Entered combat, lock all frames."

L["钱不够"] = "You don't have enough gold to purchase this"
L["购买"] = "Bought %d %s."
L["货物不足"] = "The merchant don't have enough"
L["光标"] = "cursor"
L["当前"] = "current"


L["上一条"] = "Previous"
L["下一条"] = "Next"
L["我不想看到这些提示"] = "I don't want to see them"
L["隐藏提示的提示"] = "You can re-enable these tips in GUI → Other"

L["TIPS"] = {
	"Altz UI can hide the minimap and chat frame when you enter combat and show them when you leave. GUI → Other",
	"Click the clock on the minimap to open the calendar; right click changes between local/server time while a modified right click (holding alt, ctrl, or shift) changes 12/24 format.",
	"Want to enable class colors on your raid frames? GUI → UnitFrames → Style → Classic Theme",
	"Want to display the independent castbar? GUI → Unit Frames → Castbar → Independent player castbar",
	"Want to use the healer-style raid frame? GUI → Raid Frames → Switch → click Disable Auto Switch and Healer",
	"Want to switch the positions of the first and second action bar? GUI → Actionbars → MainActionbar → Place bar1 above bar2",
	"Want to use a custom color of the nameplate of a specific unit? GUI → Unit Nameplates → Custom Color",
	"Want to change the size of the mini-map? GUI → Other → Togglebutton Height",
	"/rl - reload UI",
	"/hb - Key Binding Mode",
	"Use SHIFT+Click to set your focus; it's available for unit frames",
	"Use ALT+Click to mill/prospect, disenchant, unlock instantly",
	"Press Tab to change between available channels when the edit box of the chat frame is activated",
	"The font files are located at Interface\\AddOns\\AuroraClassic\\media\\font.ttf(main font),Interface\\AddOns\\AltzUI\\media\\number.ttf(font for some time text)",
	"Hold Ctrl, Alt or Shift to scroll chat frame to top/bottom.",
	"Clicking the edge of some button will toggle it's autohidden function, eg MicroMenu/Raidtools/Config.",
}

L["出现了！"] = "spotted!"
