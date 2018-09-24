﻿local T, C, L, G = unpack(select(2, ...))
if G.Client ~= "zhTW" then return end

L["团队工具"] = "團隊工具"

L["当前经验"] = "當前經驗： "
L["剩余经验"] = "剩餘經驗： "
L["双倍"] = "雙倍： "
L["声望"] = "聲望："
L["剩余声望"] = "剩餘聲望： "
L["占用前 %d 的插件"] = "佔用前 %d 的插件"
L["自定义插件占用"] = "自定義插件佔用"
L["所有插件占用"] = "所有插件佔用"

L["Fire!"] = "Fire!"

L["赚得"] = "賺得:"
L["消费"] = "消費:"
L["赤字"] = "赤字:"
L["盈利"] = "盈利:"
L["本次登陆"] = "本次登陸"
L["服务器"] = "伺服器"
L["角色"] = "角色"
L["重置金币信息"] = "重置金蔽統計。"

L["脱装备"] = "脱裝備"
L["切天赋"] = "切換專精"

L["锁定框体"] = "鎖定框體"
L["解锁框体"] = "解鎖框體"
L["重置框体位置"] = "重置框體位置"

L["你不能在战斗中绑定按键"] = "你不能在戰鬥中綁定按鍵。"
L["按键绑定解除"] = "按鍵綁定解除："
L["所有键位设定保存"] = "所有鍵位設定保存。"
L["刚才的键位设定修改取消了"] = "剛才的鍵位設定修改取消了。"
L["绑定到"] = "綁定到"
L["绑定模式"] = "把鼠標放在動作條上來為它設定鍵位。按ESC鍵取消改按鈕上的鍵位。"
L["没有绑定键位"] = "沒有綁定鍵位"
L["绑定"] = "綁定"
L["键位"] = "鍵位"
L["保存键位"] = "保存"
L["取消键位"] = "取消"

L["被闷了"] = "有賊啊！被悶了！"
L["被闷了2"] = "被這傢伙悶了:"

L["修理花费"] = "修理花費:"

L["整理"] = "理"
L["背包"] = "包"

L["复制名字"] = "複製名字"
L["玩家详情"] = "詳情"
L["公会邀请"] = "公會邀請"
L["添加好友"] = "添加好友"
L["复制聊天"] = "複製聊天訊息"

L["信息条"] = "信息條"
L["微型菜单"] = "微型菜單"
L["控制台"] = "插件設置"
L["主动作条"] = "主動作條"
L["额外动作条"] = "額外\n動作條"
L["右侧额外动作条"] = "右側額外\n動作條"
L["宠物动作条"] = "寵物動作條"
L["姿态/形态条"] = "姿態/形態條"
L["离开载具按钮"] = "離開載具\n按鈕"
L["额外特殊按钮"] = "額外特殊\n按鈕"
L["增益框"] = "增益"
L["减益框"] = "減益"
L["ROLL点框"] = "ROLL點框"
L["鼠标提示"] = "鼠標提示"
L["承受伤害"] = "承受傷害"
L["承受治疗"] = "承受治療"
L["输出伤害"] = "輸出傷害"
L["输出治疗"] = "輸出治療"
L["任务追踪"] = "任務追踪"
L["小地图缩放按钮"] = "小地圖\n縮放按鈕"
L["聊天框缩放按钮"] = "聊天框\n縮放按鈕"
L["背包框"] = "背包"
L["银行框"] = "銀行"
L["输出模式团队框架"] = "輸出模式\n團隊框架"
L["输出模式宠物团队框架"] = "輸出模式\n寵物\n團隊框架"
L["治疗模式团队框架"] = "治療模式\n團隊框架"
L["治疗模式宠物团队框架"] = "治療模式\n寵物\n團隊框架"
L["玩家头像"] = "玩家頭像"
L["宠物头像"] = "寵物頭像"
L["目标头像"] = "目標頭像"
L["目标的目标头像"] = "目標的目標\n頭像"
L["焦点头像"] = "焦點頭像"
L["焦点的目标头像"] = "焦點的目標\n頭像"
for i = 1, MAX_BOSS_FRAMES do
	L["首领头像"..i] = "首領"..i
end
for i = 1, 5 do
	L["竞技场敌人头像"..i] = "競技場敵人"..i
end
L["玩家施法条"] = "玩家施法條"
L["目标施法条"] = "目標施法條"
L["焦点施法条"] = "焦点施法條"
L["玩家平砍计时条"] = "玩家平砍計時條"
L["冷却提示"] = "冷卻提示"
L["图腾条"] = "圖騰條"
L["便捷物品按钮"] = "便捷物品按鈕"
L["多人坐骑控制框"] = "多人坐騎控制框"
L["耐久提示框"] = "耐久提示框"

L["无2"] = "|cffFF0000無|r"
L["无"] = "無"
L["合剂"] = "精煉"
L["食物"] = "食物"
L["过远"] = "過遠"
L["距离过远"] = "距離開過遠"
L["dbm_pull"] = "倒數"
L["dbm_lag"] = "檢查延遲"
L["需要加载DBM"] = "這個功能需要加載DBM"
L["无合剂增益"] = "無人有精煉buff。"
L["无食物增益"] = "無人有食物buff。"
L["全合剂增益"] = "所有人都精煉buff。"
L["全食物增益"] = "所有人都食物buff。"
L["偷药水"] = "在上次戰鬥開始前沒有偷喝藥水: "
L["全偷药水"] = "所有人在上次戰鬥開始前都偷喝了藥水。"
L["药水"] = "在上次戰鬥中沒有喝第二瓶藥水: "
L["全药水"] = "所有人在上次戰鬥中都喝了第二瓶藥水。"

L["无法自动邀请进组:"] = "我現在不能組你:"
L["我不能组人"]  = "我沒有組人權限"
L["小队满了"] = "小隊滿了"
L["团队满了"] = "團隊滿了"
L["客户端错误"] = "我現在不能自動邀請你進組，因為你的戰網賬號似乎粘在%s上了"

L["的徽章冷却就绪"] = "的徽章冷却就绪"
L["使用了徽章"] = "使用了徽章"

L["界面移动工具"] = "介面移動工具"
L["锚点框体"] = "錨點框體"
L["重置位置"] = "將這個框體重置到默認位置。"
L["healer"] = "|cff76EE00治療|r"
L["dpser"] = "|cffE066FF輸出/坦克|r"
L["选中的框体"] = "選中的框體"
L["当前模式"] = "當前模式"
L["进入战斗锁定"] = "進入戰鬥，鎖定所有框體。"

L["钱不够"] = "沒有足夠的錢來買"
L["购买"] = "購買了 %d %s."
L["货物不足"] = "商人沒有足夠的"
L["光标"] = "光標"
L["当前"] = "當前"

L["上一条"] = "上壹條"
L["下一条"] = "下壹條"
L["我不想看到这些提示"] = "我不想看到這些提示"
L["隐藏提示的提示"] = "你可以在 插件設置→其他設置 中恢復顯示這些提示"

L["TIPS"] = {
	"你可以設置在戰鬥中自動隱藏聊天框和小地圖，並在脫離戰鬥後顯示它們。這樣能讓戰鬥界面更清爽。",
	"左鍵點擊小地圖上的時鐘可以打開日歷，右鍵點擊可以切換本地時間/服務器時間，按住控制鍵再右鍵點擊可以切換12/24小時顯示模式。",
	"如何把團隊框架顯示為職業顏色？插件設置→單位框體→樣式→經典主題",
	"如何顯示獨立的施法條？插件設置→單位框體→施法條→獨立的玩家施法條",
	"如何只顯示治療模式的團隊框架？插件設置→團隊框架→切換→禁用自動切換並選擇治療模式",
	"如何把動作條1和2交換位置？插件設置→動作條→主動做條→將動作條1放在動作條2上面",
	"如何改變特定怪物姓名版的顏色？插件設置→單位姓名版→自定義顏色",
	"如何改變小地圖的大小？插件設置→其他→縮放按鈕高度",
	"命令：/rl - 重載界面 ",
	"命令：/hb - 按鍵綁定模式",
	"SHIFT+左鍵 - 設置焦點。點擊單位框體也可以哦！",
	"ALT+單擊物品 - 快速分解、研磨、選礦、開鎖",
	"激活輸入框時點擊Tab可以切換聊天頻道",
	"字體文件在哪裏？Interface\\AddOns\\AuroraClassic\\media\\font.ttf(主要字體)，Interface\\AddOns\\AltzUI\\media\\number.ttf(壹些時間文本用的字體)",
	"按住Ctrl，Shift或Alt可以快速滾動聊天框。",
	"點擊一些按鈕的邊緣可以打開/關閉自動隱藏該按鈕的功能，如微型菜單/團隊工具/插件設置。",
 }

L["出现了！"] = "出現了！"