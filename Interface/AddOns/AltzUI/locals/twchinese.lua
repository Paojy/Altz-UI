﻿local T, C, L, G = unpack(select(2, ...))
if G.Client ~= "zhTW" then return end

--====================================================--
--[[           -- 更新日志和插件提示 --             ]]--
--====================================================--
--L["更新日志tip"] = [[新功能：
--更新10.00]]

L["TIPS"] = {
	"左鍵點擊小地圖上的時鐘可以打開日歷",
	"右鍵點擊小地圖上打開小地圖追跡選單",
	"如何改變特定怪物姓名版的顏色？CTRL+點擊怪物的下拉式功能表中選擇，或插件設置→單位姓名版→自定義顏色",
	"命令：/rl - 重載界面 ",
	"命令：/hb - 按鍵綁定模式",
	"SHIFT+左鍵 - 設置焦點。點擊單位框體也可以哦！",
	"ALT+單擊物品 - 快速分解、研磨、選礦、開鎖",
	"激活輸入框時點擊Tab可以切換聊天頻道",
	"按住Ctrl，Shift或Alt可以快速滾動聊天框。",
 }
 
 L["指令"] = [[
/rl - 重載界面
/setup - 打開設置嚮導
SHIFT+左鍵-設定滑鼠懸停組織為焦點
CTRL+左鍵-為滑鼠懸停組織添加團隊標記
ALT+單擊物品 - 快速分解、研磨、選礦、開鎖
Tab - 切換聊天頻道
]]

--====================================================--
--[[                 -- 通用 --                     ]]--
--====================================================--
L["生效"] = " 生效"
L["稍后重载"] = "稍後重載"
L["脱离战斗"] = "脫離戰鬥"
L["冷却"] = "冷卻"
L["光环"] = "光環"
L["增益"] = "增益"
L["减益"] = "减益"
L["副本"] = "副本"
L["全局"] = "全局"
L["可打断"] = "可打斷"
L["不可打断"] = "不可打斷"
L["焦点"] = "焦點"
L["目标的目标"] = "目標的目標"
L["焦点的目标头像"] = "焦點的目標"
L["非"] = "非"

--====================================================--
--[[                 -- 控制台 --                   ]]--
--====================================================--
L["复制粘贴"] = "Ctrl+C/Ctrl+V 複製/粘貼"
L["界面"] = "界面"
L["控制台"] = "控制台"
L["设置"] = "設置"
L["启用"] = "啟用"
L["重置"] = "重置"
L["重置确认"] = "你想要重置所有的%s設置嗎？"
L["显示"] = "顯示"
L["隐藏"] = "隱藏"
L["总是"] = "總是"
L["一般"] = "一般"

L["字体"] = "字體"
L["数字"] = "數字"
L["图标"] = "圖標"
L["时间"] = "時間"

L["尺寸"] = "尺寸"
L["比例"] = "比例"
L["高度"] = "高度"
L["宽度"] = "寬度"
L["数量"] = "數量"
L["数值"] = "數值"
L["百分比"] = "百分比"
L["大小"] = "大小"
L["长度"] = "長度"
L["样式"] = "樣式"
L["位置"] = "位置"
L["透明度"] = "透明度"
L["颜色"] = "顏色"

L["左"] = "左"
L["右"] = "右"
L["上"] = "上"
L["下"] = "下"
L["中间"] = "中間"
L["左上"] = "左上"
L["右上"] = "右上"
L["左下"] = "左下"
L["右下"] = "右下"
L["上方"] = "上方"
L["下方"] = "下方"
L["排列方向"] = "排列方向"
L["垂直"] = "垂直"
L["水平"] = "水平"
L["排列顺序"] = "排列順序"
L["正序"] = "正序"
L["反序"] = "反序"
L["水平偏移"] = "水平偏移"
L["垂直偏移"] = "垂直偏移"

L["法术编号"] = "法術ID"
L["物品编号"] = "物品ID"
L["输入法术ID"] = "輸入法術ID"
L["不是一个有效的法术ID"] = "不是一個有效的法術ID"
L["物品名称ID链接"] = "物品名稱/ID/連結"
L["不正确的物品ID"] = "不正確的物品名稱/ID/連結"
L["物品数量"] = "輸入數量"
L["必须是一个数字"] = "必須是一個數字。"

L["白名单"] = "總是顯示以下"
L["黑名单"] = "從不顯示以下"
L["优先级"] = "優先順序"

L["命令"] = "命令"
L["制作"] = "制作"
L["制作说明"] = [[AltzUI ver %s
泡泡 zhCN

Thanks to
%s
和每一個幫我完成一個插件包的朋友。]]

--====================================================--
--[[                 -- 安装 --                     ]]--
--====================================================--
L["小泡泡"] = "小泡泡"
L["欢迎使用"] = "歡迎安裝 Altz UI"
L["简介"] = "AltzUI是一個全職業通用的綜合外掛程式包，美化風格清爽簡潔。 建議花幾分鐘對挿件進行快速設定。"
L["上一步"] = "上一步"
L["下一步"] = "下一步"
L["完成"] = "完成"
L["跳过"] = "跳過設置嚮導"
L["设置向导"] = "設置嚮導"
L["设置向导提示"] = "聊天框輸入/setup或右键小地图插件图标打開設置嚮導"
L["界面风格tip"] = "你希望以何種方式顯示頭像和團隊框架？"
L["界面布局"] = "界面布局"
L["界面布局tip"] = "你希望以何種方式來佈局插件？"
L["对称布局"] = "對稱佈局"
L["聚合布局"] = "聚合佈局"
L["姓名板tip"] = "你希望以何種方式顯示姓名板？"
L["更新日志"] = "更新日誌"

--====================================================--
--[[        -- 导入、导出设置 --                    ]]--
--====================================================--
L["导入"] = "導入"
L["导出"] = "導出"
L["导入确认"] = "你想要導入所有的%s設置嗎？"
L["版本不符合"] = "版本%s（當前版本%s）"
L["客户端不符合"] = "客戶端%s（當前客戶端%s）"
L["职业不符合"] = "職業%s（當前職業%s）"
L["暴雪布局字串有误"] = "暴雪佈局字串有誤"
L["不完整导入"] = "導入可能不完整。"
L["无法导入"] = "錯誤的字符，無法導入。"

--====================================================--
--[[                 -- 界面移动 --                 ]]--
--====================================================--
L["锚点"] = "錨點"
L["锚点框体"] = "錨點框體"
L["对齐到"] = "對齊到"
L["屏幕"] = "荧幕"
L["当前模式"] = "當前模式"
L["healer"] = "|cff76EE00治療|r"
L["dpser"] = "|cffE066FF輸出/坦克|r"

--====================================================--
--[[                   -- 界面 --                   ]]--
--====================================================--
L["当前经验"] = "當前經驗： "
L["剩余经验"] = "剩餘經驗： "
L["双倍"] = "雙倍： "
L["声望"] = "聲望："
L["剩余声望"] = "剩餘聲望： "
L["占用前 %d 的插件"] = "佔用前 %d 的插件"
L["自定义插件占用"] = "自定義插件佔用"
L["所有插件占用"] = "所有插件佔用"
L["脱装备"] = "脱裝備"
L["一直显示插件按钮"] = "一直顯示挿件按鈕綜合條"
L["小地图按钮"]	= "AltzUI 按鈕"

L["界面风格"] = "界面風格"
L["透明样式"] = "透明主題"
L["深色样式"] = "深色主題"
L["普通样式"] = "經典主題"
L["数字缩写样式"] = "數字縮寫樣式"
L["信息条"] = "信息條"
L["暂离屏幕"] = "暫離時隱藏界面"
L["显示插件使用小提示"] = "顯示插件使用小提示"
L["显示插件使用小提示提示"] = "當AFK時在屏幕下方顯示插件使用的小提示"
L["隐藏提示的提示"] = "你可以在 界面→界面布局 中恢復顯示這些提示"
L["在副本中收起任务追踪"] = "在副本中收起任務追蹤"
L["在副本中收起任务追踪提示"] = "進入副本/戰場時自動收起任務追蹤，出去時自動展開。"

L["未加载插件"] = "未加載%s挿件"
L["插件皮肤"] = "皮膚"
L["职业颜色"] = "職業顏色"
L["鲜明"] = "鮮明"
L["原生"] = "原生"
L["BW计时条皮肤"] = "BigWigs計時條皮膚"
L["更改设置提示"] = "這將改變該插件的設置"
L["边缘装饰"] = "長條裝飾"
L["两侧装饰"] = "邊角裝飾"
L["快速删除"] = "快速删除"
L["复制宏"] = "複製"

L["赛季"] = "賽季"
L["当前词缀"] = "當前詞綴"
L["传送可用"] = "傳送可用"
L["传送不可用"] = "傳送不可用"

L["玩家位置"] = "玩家位置"
L["鼠标位置"] = "滑鼠位置"
--====================================================--
--[[                 -- 社交 --                     ]]--
--====================================================--
L["滚动聊天框"] = "滾動聊天框"
L["滚动聊天框提示"] = "15秒後自動滾動至聊天框底部。"
L["频道缩写"] = "頻道縮寫"
L["复制聊天"] = "複製聊天訊息"
L["显示聊天框背景"] = "顯示聊天框背景"
L["自动邀请"] = "自動邀請"
L["自动邀请提示"] = "當被密語特定關鍵詞後自動邀請玩家。"
L["关键词"] = "關鍵詞"
L["关键词输入"] = "輸入關鍵詞，用空格隔開。"
L["无法自动邀请进组:"] = "我現在不能組你:"
L["我不能组人"]  = "我沒有組人權限"
L["小队满了"] = "小隊滿了"
L["团队满了"] = "團隊滿了"
L["客户端错误"] = "我現在不能自動邀請你進組，因為你的戰網賬號似乎粘在%s上了"
L["聊天过滤"] = "聊天過濾"
L["聊天过滤提示"] = "屏蔽重復或包涵數個關鍵詞的信息。"
L["过滤阈值"] = "過濾閾值"
L["自动接受好友的组队邀请"] = "自動接受好友的組隊邀請"
L["自动接受公会成员的组队邀请"] = "自動接受公會成員的組隊邀請"
L["自动接受社区成员的组队邀请"] = "自動接受社區成員的組隊邀請"
L["自动接受同一战网其他角色的组队邀请"] = "自動接受同一戰網其他角色的組隊邀請"
L["拒绝陌生人的组队邀请"] = "拒絕陌生人的組隊邀請"
L["邀请过滤"] = "|cff7FFF00[邀請過濾]|r 收到來自|cff00FFFF%s|r的陌生人組隊邀請，已拒絕"

--====================================================--
--[[                 -- 物品 --                     ]]--
--====================================================--
L["自动修理"] = "自動修理"
L["自动修理提示"] = "與修理匠對話時自動修理裝備"
L["优先使用公会修理"] = "優先使用公會修理"
L["优先使用公会修理提示"] = "優先使用公會資金自動修理，資金不足時用自己的錢修理。"
L["修理花费"] = "修理花費:"
L["自动售卖"] = "自動售賣"
L["自动售卖提示"] = "與商人對話時自動售賣灰色品質物品"
L["已会配方着色"] = "已會配方圖標染色"
L["已会配方着色提示"] = "已會配方的圖標顯示為綠色"
L["自动购买"] = "自動購買"
L["自动购买提示"] = "和商人對話時自動購買下列物品。"
L["购买"] = "購買了 %d %s。%s"
L["每次最多购买"] = "每次最多購買%d"
L["赚得"] = "賺得:"
L["消费"] = "消費:"
L["赤字"] = "赤字:"
L["盈利"] = "盈利:"
L["本次登陆"] = "本次登陸"
L["服务器"] = "伺服器"
L["角色"] = "角色"
L["重置金币信息"] = "重置金蔽統計。"
L["收藏"] = "收藏"
L["加入收藏"] = "把物品拖動到這裡加入收藏或從收藏中移除"
L["新物品"] = "新物品"
L["装备列表"] = "裝備清單"
L["自动ROLL"] = "自動ROLL"
L["自动ROLL%s"] = "你對%s自動選擇%s"
L["手动"] = "手動"
L["ROLL结果截图"] = "ROLL結果截圖"
L["截图后关闭ROLL点框"] = "截圖後關閉ROLL點框"
L["自动截图%s"] = "%s的ROLL結果已截圖"

--====================================================--
--[[               -- 单位框架 --                   ]]--
--====================================================--
L["背包按钮"] = "背包按鈕"
L["单位框架"] = "單位框體"
L["显示冷却"] = "显示%s的冷卻時間"
L["生命值"] = "生命值"
L["能量值"] = "能量值"
L["总是显示数值提示"] = "禁用則只在%s不滿時顯示"
L["肖像"] = "肖像"
L["单位框架治疗和吸收预估提示"] = "在玩家、目標和焦點框體訓示預計治療和吸收量"
L["宽度提示"] = "玩家，目標和焦點框體的寬度。"
L["能量条"] = "能量條"
L["施法条"] = "施法條"
L["独立施法条"] = "獨立的施法條"
L["依附施法条"] = "依附於框架的施法條"
L["平砍计时条"] = "平砍計時條"
L["过滤增益"] = "目標光環過濾 : 忽視增益"
L["过滤增益提示"] = "隱藏其他玩家施放在友方目標身上的增益。"
L["过滤减益"] = "目標光環過濾 : 忽視減益"
L["过滤减益提示"] = "隱藏其他玩家施放在敵方目標身上的減益。"
L["图腾条"] = "圖騰條"
L["PvP标记"] = "PvP標记"
L["PvP标记提示"] = "建議在PvE伺服器使用。"
L["额外法力条"] = "額外法力條"
L["法力条提示"] = "主要資源類型非法力（如能量、怒氣）時顯示額外的法力條"
L["醉拳条"] = "醉拳條"
L["徽章冷却就绪"] = "%s的徽章冷却就绪"
L["使用了徽章"] = "%s使用了徽章"

L["团队框架"] = "團隊框架"
L["未进组时显示"] = "未進组時顯示"
L["团队规模"] = "顯示小隊數量"
L["治疗法力条"] = "顯示隊伍中治療職責玩家的法力條"
L["治疗法力条高度"] = "治療法力條高度"
L["GCD"] = "GCD"
L["GCD提示"] = "在團隊框體上指示GCD。"
L["缺失生命值"] = "缺失生命值"
L["治疗和吸收预估"] = "治療和吸收預估"
L["治疗和吸收预估提示"] = "在團隊框體指示預計治療和吸收量"
L["点击施法"] = "點擊施法"
L["当前设置"] = "當前設定"
L["Button1"] = "左鍵"
L["Button2"] = "右鍵"
L["Button3"] = "中鍵"
L["Button4"] = "按鍵4"
L["Button5"] = "按鍵5"
L["MouseUp"] = "滾輪上"
L["MouseDown"] = "滾輪下"
L["打开菜单"] = "打開選單"
L["输入一个宏"] = "輸入一個巨集"
L["主坦克和主助手"] = "主坦克和主助手"
L["主坦克和主助手提示"] = "在團隊框架中顯示主坦克和主助手的圖標"
L["治疗指示器"] = "治療指示器"
L["数字指示器"] = "數字指示器"
L["图标指示器"] = "圖標指示器"
L["自动添加团队减益"] = "自動將新發現的副本減益加入列表"
L["自动添加团队减益提示"] = "自動將新發現的副本減益加入列表，你可以在團隊減益列表中將新添加的減益刪除，或通過減益過濾黑名單禁止其顯示。"
L["添加团队减益"] = "|cff7FFF00團隊減益添加成功|r %s %s"
L["杂兵"] = "雜兵"
L["删除并加入黑名单"] = "刪除並加入黑名單"
L["已删除并加入黑名单"] = "|cff7FFF00已刪除並加入黑名單:%s|r"
L["团队工具"] = "團隊工具"
L["自动记录%s"] = "在%s自動記錄"
L["正在记录战斗日志"] = "正在記錄戰鬥日誌……"
L["开始记录"] = "開始記錄"
L["停止记录"] = "停止記錄"

--====================================================--
--[[                 -- 动作条 --                   ]]--
--====================================================--
L["显示冷却时间提示"] = "在動作條和物品圖標上顯示冷却時間。"
L["不可用颜色"] = "超出距離動作條變紅"
L["不可用颜色提示"] = "當動作超出距離時，動作條圖標圖標變紅。"
L["键位"] = "鍵位"
L["次数"] = "次數"
L["条件渐隐"] = "條件漸隱"
L["条件渐隐提示"] = "當你不施法，不在戰鬥，没有目標且達到\n最大生命值和最大/最小能量值時啟用漸隱。"
L["渐隐透明度"] = "漸隱透明度"
L["渐隐透明度提示"] = "未激活時的透明度"
L["冷却提示"] = "冷卻提示"

--====================================================--
--[[                 -- 姓名板 --                   ]]--
--====================================================--
L["数字样式"] = "數字樣式"
L["职业色-条形"] = "職業色-條型"
L["深色-条形"] = "深色-條型"
L["仇恨染色"] = "根據仇恨情況變色"
L["过滤方式"] = "過濾方式"
L["我施放的光环"] = "我施放的光環"
L["其他人施放的光环"] = "其他人施放的光環"
L["全部隐藏"] = "全部隱藏"
L["玩家姓名板"] = "玩家姓名板"
L["友方只显示名字"] = "友方只顯示名字"
L["根据血量变色"] = "根據血量變色"
L["焦点染色"] = "染色焦點目標"
L["自定义能量"] = "以下NPC的姓名板顯示能量條"
L["自定义颜色"] = "以下NPC的姓名板顯示自定義顏色"
L["输入npc名称"] = "輸入npc名稱"
L["添加自定义能量"] = "添加 [%s] 到姓名板自定義能量列表"
L["移除自定义能量"] = "從姓名板自定義能量列表中移除 [%s]"
L["添加自定义颜色"] = "添加 [%s] 到姓名板自定義顏色列表"
L["移除自定义颜色"] = "從姓名板自定義顏色列表中移除 |cff%02x%02x%02x[%s]|r"
L["替换自定义颜色"] = "從姓名板自定義顏色列表中替換 |cff%02x%02x%02x[%s]|r 的顏色"

--====================================================--
--[[                 -- 鼠标提示 --                 ]]--
--====================================================--
L["鼠标提示"] = "滑鼠提示"
L["战斗中隐藏"] = "戰鬥中隱藏"
L["评分层数"] = "評分（最高層數）"
L["跟随光标"] = "位置總是跟隨光標"

--====================================================--
--[[                 -- 战斗信息 --                 ]]--
--====================================================--
L["战斗数字"] = "戰鬥數字"
L["滚动战斗数字"] = "滾動戰鬥數字"
L["承受伤害"] = "承受傷害"
L["承受治疗"] = "承受治療"
L["输出伤害"] = "輸出傷害"
L["输出治疗"] = "輸出治療"
L["承受伤害/治疗"] = "顯示受到的治療和傷害"
L["输出伤害/治疗"] = "顯示輸出的治療和傷害"
L["浮动战斗数字"] = "浮動戰鬥數字"

--====================================================--
--[[                   -- 其他 --                   ]]--
--====================================================--
L["讯息提示"] = "讯息提示"
L["隐藏错误提示"] = "隱藏錯誤提示"
L["隐藏错误提示提示"] = "隱藏紅色的錯誤文本，如超出範圍，等等。"
L["稀有警报"] = "稀有怪物提示"
L["稀有警报提示"] = "在搜索到稀有時提示你"
L["出现了！"] = "出現了！"
L["任务栏闪动"] = "任務欄閃動"
L["任务栏闪动提示"] = "在當遊戲處於後臺運行時，閃動任務欄上的按鈕提示妳正在倒數開怪，正在就位確認或是戰場/隨機副本已經找到隊伍。"
L["随机奖励"] = "5人本獎勵提示"
L["随机奖励提示"] = "出現5人本獎勵時以團隊警報的方式提醒妳，僅僅在無隊伍時生效。"

L["辅助功能"] = "辅助功能"
L["成就截图"] = "成就截圖"
L["成就截图提示"] = "你獲得成就的時候自動截圖。"
L["提升截图画质"] = "提升截圖畫質"
L["自动接受复活"] = "自動接受復活"
L["自动接受复活提示"] = "自動接受復活，只在戰鬥外生效。"
L["战场自动释放灵魂"] = "戰場自動釋放靈魂"
L["战场自动释放灵魂提示"] = "在戰場，冬握湖和托爾巴拉德自動釋放靈魂。"
L["自动召宝宝"] = "自動召喚小寵物"
L["自动召宝宝提示"] = "當妳登陸，復活和離開載具時隨機召喚壹只小寵物"
L["优先偏爱宝宝"] = "優先召喚偏愛的小寵物"
L["优先偏爱宝宝提示"] = "優先召喚設定為偏愛的小寵物，否則隨機召喚一隻。"
