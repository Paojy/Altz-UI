﻿local T, C, L, G = unpack(select(2, ...))
if G.Client ~= "zhTW" then return end

-- 安装
L["小泡泡"] = "小泡泡"
L["欢迎使用"] = "歡迎安裝 Altz UI"
L["简介"] = " AltzUI是一個全職業通用的整合插件包，於2011年11月11日首次發布。它支持絕大部分分辨率，美化風格清爽簡潔，佔用也非常低，僅用2~3mb就能完成你所需要的大部分功能。如果你喜歡AltzUI，請將它推薦給其他公會成員或你的朋友，你的支持將是插件更新最大的動力。"

L["上一步"] = "上一步"
L["下一步"] = "下一步"
L["跳过"] = "跳過設置嚮導"
L["设置向导"] = "打開設置嚮導"
L["完成"] = "完成"
L["更新日志"] = "更新日誌"
L["更新日志tip"] = "新功能：\n更新10.00"
L["寻求帮助"] = "尋求幫助"
L["复制粘贴"] = "Ctrl+C/Ctrl+V 複製/粘貼"
L["生效"] = " 生效"
L["稍后重载"] = "稍後重載"
L["脱离战斗"] = "脫離戰鬥"

-- 控制台通用
L["界面"] = "界面"
L["启用"] = "啟用"
L["控制台"] = "控制台"
L["图标大小"] = "圖標大小"
L["图标数量"] = "圖標數量"
L["图标间距"] = "圖標間距"
L["缩放尺寸"] = "縮放尺寸"
L["字体大小"] = "字體大小"
L["尺寸"] = "尺寸"
L["高度"] = "高度"
L["宽度"] = "寬度"
L["光环"] = "光環"
L["图标"] = "圖標"
L["Buffs"] = "Buffs"
L["Debuffs"] = "Debuffs"
L["输入法术ID"] = "輸入法術ID"
L["不是一个有效的法术ID"] = "不是一個有效的法術ID"
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
L["垂直"] = "垂直"
L["水平"] = "水平"
L["正向"] = "正向"
L["反向"] = "反向"
L["显示冷却"] = "显示%s的冷卻時間"
L["排列方向"] = "排列方向"
L["白名单"] = "總是顯示以下"
L["黑名单"] = "從不顯示以下"

L["重置确认"] = "你想要重置所有的%s設置嗎？"
L["重置"] = "重置"
L["导入确认"] = "你想要導入所有的%s設置嗎？\n"
L["版本不符合"] = "\n版本%s（當前版本%s）"
L["客户端不符合"] = "\n客戶端%s（當前客戶端%s）"
L["职业不符合"] = "\n職業%s（當前職業%s）"
L["不完整导入"] = "\n導入可能不完整。"
L["导入"] = "導入"
L["导出"] = "導出"
L["无法导入"] = "錯誤的字符，無法導入。"

-- 聊天
L["聊天按钮悬停渐隐"] = "社交按鈕懸停漸隱"
L["聊天按钮悬停渐隐提示"] = "當鼠標沒有在聊天框左側的按鈕上時漸隱這些按鈕。"
L["频道缩写"] = "頻道縮寫"
L["滚动聊天框"] = "滾動聊天框"
L["滚动聊天框提示"] = "十多秒後自動滾動至聊天框底部。"
L["自动邀请"] = "自動邀請"
L["自动邀请提示"] = "當被密語特定關鍵詞後自動邀請玩家。"
L["关键词"] = "關鍵詞"
L["关键词输入"] = "輸入關鍵詞，用空格隔開。"
L["聊天过滤"] = "聊天過濾"
L["聊天过滤提示"] = "屏蔽重復或包涵數個關鍵詞的信息。"
L["过滤阈值"] = "過濾閾值"
L["显示聊天框背景"] = "顯示聊天框背景"
L["复制聊天"] = "複製聊天訊息"
L["无法自动邀请进组:"] = "我現在不能組你:"
L["我不能组人"]  = "我沒有組人權限"
L["小队满了"] = "小隊滿了"
L["团队满了"] = "團隊滿了"
L["客户端错误"] = "我現在不能自動邀請你進組，因為你的戰網賬號似乎粘在%s上了"

-- 背包和物品
L["启用背包模块"] = "啟用背包模塊"
L["背包图标大小"] = "背包圖標大小"
L["背包每行图标数量"] = "背包每行圖標數量"
L["自动修理"] = "自動修理"
L["自动修理提示"] = "與修理匠對話時自動修理裝備"
L["自动公会修理"] = "自動公會修理"
L["自动公会修理提示"] = "優先使用公會資金自動修理"
L["灵活公会修理"] = "靈活公會修理"
L["灵活公会修理提示"] = "當可用的公會修理資金不足修理全部裝備時用自己的錢修理。"
L["自动售卖"] = "自動售賣"
L["自动售卖提示"] = "與商人對話時自動售賣灰色品質物品"
L["已会配方着色"] = "已會配方著色"
L["已会配方着色提示"] = "已會配方的圖標顯示為綠色"
L["自动购买"] = "自動購買"
L["自动购买提示"] = "和商人對話時自動購買下列物品。"
L["物品名称ID链接"] = "物品名稱/ID/連結"
L["数量"] = "輸入數量"
L["不正确的物品ID"] = "不正確的物品名稱/ID/連結"
L["不正确的数量"] = "不正確的數量"
L["显示物品等级"] = "顯示物品等級"
L["显示物品等级提示"] = "在背包、銀行和角色欄中顯示裝備的等級"
L["便捷物品按钮"] = "便捷物品按鈕"
L["便捷物品按钮提示"] = "只在戰鬥外生效。"
L["每行图标数量"] = "每行圖標數量"
L["精确匹配"] = "精確匹配"
L["精确匹配提示"] = "啟用則只顯示該物品，禁用則顯示法術類似的物品（比如不同的神器能量）。"
L["显示数量"] = "顯示數量"
L["显示数量提示"] = "顯示背包中的該物品數量"
L["条件"] = "條件"
L["总是显示"] = "總是顯示"
L["在职业大厅显示"] = "在職業大廳顯示"
L["在团队副本中显示"] = "在團隊副本中顯示"
L["在地下城中显示"] = "在地下城中顯示"
L["在战场中显示"] = "在戰場中顯示"
L["赚得"] = "賺得:"
L["消费"] = "消費:"
L["赤字"] = "赤字:"
L["盈利"] = "盈利:"
L["本次登陆"] = "本次登陸"
L["服务器"] = "伺服器"
L["角色"] = "角色"
L["重置金币信息"] = "重置金蔽統計。"
L["修理花费"] = "修理花費:"
L["钱不够"] = "沒有足夠的錢來買"
L["购买"] = "購買了 %d %s."
L["货物不足"] = "商人沒有足夠的"
L["光标"] = "光標"
L["当前"] = "當前"

-- 单位框体
L["单位框体"] = "單位框體"
L["样式"] = "樣式"
L["总是显示生命值"] = "總是顯示生命值"
L["总是显示生命值提示"] = "禁用則只在生命值不滿時顯示生命值"
L["总是显示能量值"] = "總是顯示能量值"
L["总是显示能量值提示"] = "禁用則只在能量值不滿時顯示能量值"
L["数值字号"] = "數值字號"
L["数值字号提示"] = "生命值和法力值的數值字號"
L["显示肖像"] = "顯示肖像"
L["宽度提示"] = "玩家，目標和焦點框體的寬度。"
L["宠物框体宽度"] = "寵物框體寬度"
L["首领框体和PVP框体的宽度"] = "首領框體和PVP框體的寬度"
L["能量条高度"] = "能量條高度"
L["施法条"] = "施法條"
L["独立施法条"] = "獨立施法條"
L["玩家施法条"] = "玩家施法條"
L["目标施法条"] = "目標施法條"
L["焦点施法条"] = "焦点施法條"
L["法术名称位置"] = "法術名稱位置"
L["可打断施法条图标颜色"] = "可打斷施法條圖標顏色"
L["不可打断施法条图标颜色"] = "不可打斷施法條圖標顏色"
L["施法时间位置"] = "施法時間位置"
L["引导法术分段"] = "引導法術分段"
L["隐藏玩家施法条图标"] = "隱藏玩家施法條圖標"
L["平砍计时条"] = "平砍計時條"
L["显示副手"] = "顯示副手"
L["显示平砍计时"] = "顯示時間"
L["玩家减益"] = "玩家減益"
L["玩家减益提示"] = "在玩家框體上顯示施放在減益玩家"
L["过滤增益"] = "目標光環過濾 : 忽視增益"
L["过滤增益提示"] = "隱藏其他玩家施放在友方目標身上的增益。"
L["过滤减益"] = "目標光環過濾 : 忽視減益"
L["过滤减益提示"] = "隱藏其他玩家施放在敵方目標身上的減益。"
L["图腾条"] = "圖騰條"
L["显示PvP标记"] = "顯示PvP標记"
L["显示PvP标记提示"] = "建議在PvE伺服器使用。"
L["启用首领框体"] = "啟用首領框體"
L["启用PVP框体"] = "PVP框體"
L["在小队中显示自己"] = "在小隊中顯示自己"
L["显示法力条"] = "顯示法力條"
L["显示法力条提示"] = "為輸出專精顯示法力條"
L["启用仇恨条"] = "啟用仇恨條"
L["显示醉拳条"] = "顯示醉拳條"
L["的徽章冷却就绪"] = "的徽章冷却就绪"
L["使用了徽章"] = "使用了徽章"

-- 团队框架
L["团队框架"] = "團隊框架"
L["团队框架tip"] = "團隊框架是否隨專精改變？"
L["通用设置"] = "通用設置"
L["显示宠物"] = "顯示寵物"
L["名字长度"] = "名字長度"
L["未进组时显示"] = "未進组時顯示"
L["团队规模"] = "顯示小隊數量"
L["40-man"] = "40人"
L["30-man"] = "30人"
L["20-man"] = "20人"
L["10-man"] = "10人"
L["治疗法力条"] = "顯示治療法力條"
L["治疗法力条高度"] = "治療法力條高度"
L["GCD"] = "GCD"
L["GCD提示"] = "在團隊框體上指示GCD。"
L["显示缺失生命值"] = "顯示缺失生命值"
L["显示缺失生命值提示"] = "在生命值低於90%時顯示血量數值"
L["治疗和吸收预估"] = "治療和吸收預估"
L["治疗和吸收预估提示"] = "在團隊框體指示預計治療和吸收量"
L["职业顺序"] = "根據職業順序排列"
L["整体高度"] = "整體高度"
L["整体高度提示"] = "每一列的框體數量"
L["点击施法"] = "點擊施法"
L["Button1"] = "左鍵"
L["Button2"] = "右鍵"
L["Button3"] = "中鍵"
L["Button4"] = "按鍵4"
L["Button5"] = "按鍵5"
L["MouseUp"] = "滾輪上"
L["MouseDown"] = "滾輪下"
L["打开菜单"] = "打開選單"
L["不正确的法术名称"] = "不正確的法術名稱"
L["输入一个宏"] = "輸入一個巨集"
L["优先级"] = "優先順序"
L["必须是一个数字"] = "必須是一個數字。"
L["主坦克和主助手"] = "主坦克和主助手"
L["主坦克和主助手提示"] = "在團隊框架中顯示主坦克和主助手的圖標"
L["治疗指示器"] = "治療指示器"
L["数字指示器"] = "數字指示器"
L["图标指示器"] = "圖標指示器"
L["副本减益"] = "副本减益"
L["全局减益"] = "全局減益"
L["全局增益"]= "全局增益"
L["自动添加团队减益"] = "自動將新發現的副本減益加入列表"
L["自动添加团队减益提示"] = "自動將新發現的副本減益加入列表，你可以在團隊減益列表中將新添加的減益刪除，或通過減益過濾黑名單禁止其顯示。"
L["自动添加的图标层级"] = "自動添加的圖標層級"
L["团队工具"] = "團隊工具"
L["添加团队减益"] = "|cff7FFF00團隊減益添加成功|r %s %s"
L["杂兵"] = "雜兵"
L["设置"] = "設置"
L["删除并加入黑名单"] = "刪除並加入黑名單"
L["已删除并加入黑名单"] = "|cff7FFF00已刪除並加入黑名單:%s|r"

-- 动作条
L["向上排列"] = "向上排列"
L["向上排列说明"] = "當動作條有多行時向上排列"
L["显示冷却时间"] = "顯示冷却時間"
L["冷却时间数字大小"] = "冷却時間字體大小"
L["冷却时间数字大小提示"] = "只能調整大于25*25象素冷卻框體的字號，更小的冷卻框體會自動調整到適合的字號。注意如果框體太小則不會顯示冷卻數字。"
L["显示冷却时间提示"] = "在動作條和物品上顯示冷却時間。"
L["显示冷却时间提示WA"] = "在WA特效上顯示冷卻時間。"
L["不可用颜色"] = "不可用顏色"
L["不可用颜色提示"] = "當動作條按鈕不可用時改變它的顏色。比如超出距離，能量不足等。"
L["键位字体大小"] = "鍵位字體大小"
L["宏名字字体大小"] = "巨集名字字體大小"
L["可用次数字体大小"] = "可用次數字體大小"

L["条件渐隐"] = "條件漸隱"
L["条件渐隐提示"] = "當你不施法，不在戰鬥，没有目標且達到\n最大生命值和最大/最小能量值時啟用漸隱。"
L["悬停渐隐"] = "懸停漸隱"
L["悬停渐隐提示"] = "當你的鼠標没有懸停在動作條上時啟用動作條漸隱。"
L["渐隐透明度"] = "漸隱透明度"
L["渐隐透明度提示"] = "未激活時的透明度"

L["主动作条"] = "主動作條"
L["额外动作条"] = "額外動作條"
L["额外动作条布局"] = "額外動作條布局"
L["额外动作条间距"] = "間距"
L["额外动作条间距提示"] = "額外動作條左右兩部分中間的距離是主動作條的寬度加兩倍僵局。\n這個選項只在啟用3*2*2布局時生效。"
L["6*4布局"] = "6*4布局"
L["右侧额外动作条"] = "右側額外動作條"
L["宠物动作条"] = "寵物動作條"
L["5*2布局"] = "5*2布局"
L["5*2布局提示"] = "寵物動作條使用5*2布局，\n禁用則使用10*1布局。"
L["姿态/形态条"] = "姿態/形態條"
L["离开载具按钮"] = "離開載具按鈕"
L["额外特殊按钮"] = "額外特殊按鈕"
L["横向动作条"] = "橫向排列右側動作條"

L["冷却提示"] = "冷卻提示"
L["透明度"] = "透明度"

-- 姓名板
L["姓名板tip"] = "你希望以何種方式顯示姓名板？"
L["数字样式"] = "數字樣式"
L["职业色-条形"] = "職業色-條型"
L["深色-条形"] = "深色-條型"
L["仇恨染色"] = "根據仇恨情況變色"
L["我施放的光环"] = "我施放的光環"
L["其他人施放的光环"] = "其他人施放的光環"
L["全部隐藏"] = "全部隱藏"
L["过滤方式"] = "過濾方式"
L["显示玩家姓名板"] = "顯示玩家姓名板"
L["显示玩家姓名板光环"] = "顯示玩家姓名板光環"
L["显示玩家施法条"] = "顯示玩家姓名板施法條"
L["姓名板资源位置"] ="副資源位置"
L["姓名板资源尺寸"] = "姓名板資源尺寸"
L["目标姓名板"] = "目標姓名板"
L["玩家姓名板"] = "玩家姓名板"
L["名字字体大小"] = "名字字體大小"
L["可打断施法条颜色"] = "可打斷施法條顏色"
L["不可打断施法条颜色"] = "不可打斷施法條顏色"
L["数值样式"] = "數值樣式"
L["百分比"] = "百分比"
L["数值和百分比"] = "數值和百分比"
L["条形样式"] = "條型樣式"
L["友方只显示名字"] = "友方只顯示名字"
L["根据血量染色"] = "根據血量染色"
L["焦点染色"] = "染色焦點目標"
L["焦点颜色"] = "焦點顏色"
L["图标数字大小"] = "圖標數字大小"
L["自定义能量"] = "以下NPC的姓名板顯示能量條"
L["自定义颜色"] = "以下NPC的姓名板顯示自定義顏色"
L["输入npc名称"] = "輸入npc名稱"
L["添加自定义能量"] = "添加 [%s] 到姓名板自定義能量列表"
L["移除自定义能量"] = "從姓名板自定義能量列表中移除 [%s]"
L["添加自定义颜色"] = "添加 [%s] 到姓名板自定義顏色列表"
L["移除自定义颜色"] = "從姓名板自定義顏色列表中移除 |cff%02x%02x%02x[%s]|r"
L["替换自定义颜色"] = "從姓名板自定義顏色列表中替換 |cff%02x%02x%02x[%s]|r 的顏色"

-- 鼠标提示
L["跟随光标"] = "跟隨光標"
L["隐藏服务器名称"] = "隱藏伺服器名稱"
L["隐藏称号"] = "隱藏稱號"
L["显示法术编号"] = "顯示法術编號"
L["显示物品编号"] = "顯示物品编號"
L["显示天赋"] = "顯示天賦"
L["战斗中隐藏"] = "戰鬥中隱藏"
L["背景透明度"] = "背景透明度"
L["大秘境评分"] = "大祕境評分"
L["副本"] = "副本"
L["评分层数"] = "評分（最高層數）"

-- 战斗信息
L["战斗信息"] = "戰鬥信息"
L["承受伤害/治疗"] = "顯示受到的治療和傷害"
L["输出伤害/治疗"] = "顯示輸出的治療和傷害"
L["数字缩写样式"] = "數字縮寫樣式"
L["暴击图标大小"] = "暴擊圖標大小"
L["显示DOT"] = "顯示DOT"
L["显示HOT"] = "顯示HOT"
L["显示宠物"] = "顯示寵物"
L["隐藏时间"] = "隱藏時間"
L["隐藏时间提示"] = "戰鬥信息出現後經過一小段時間會漸漸隱藏"
L["隐藏浮动战斗信息接受"] = "隱藏暴雪浮動戰鬥信息(輸出的傷害和治療)"
L["隐藏浮动战斗信息输出"] = "隱藏暴雪浮動戰鬥信息(受到的傷害和治療)"

-- 其他
L["界面风格"] = "界面風格"
L["界面风格tip"] = "你希望以何種方式顯示頭像和團隊框架？"
L["透明样式"] = "透明主題"
L["深色样式"] = "深色主題"
L["普通样式"] = "經典主題"
L["小地图尺寸"] = "小地圖尺寸"
L["系统菜单尺寸"] = "系統菜單尺寸"
L["信息条尺寸"] = "信息條尺寸"
L["整理小地图图标"] = "整理小地圖圖標"
L["整理栏位置"] = "整理欄位置"
L["成就截图"] = "成就截圖"
L["成就截图提示"] = "你獲得成就的時候自動截圖。"
L["自动接受复活"] = "自動接受復活"
L["自动接受复活提示"] = "自動接受復活，只在戰鬥外生效。"
L["战场自动释放灵魂"] = "戰場自動釋放靈魂"
L["战场自动释放灵魂提示"] = "在戰場，冬握湖和托爾巴拉德自動釋放靈魂。"
L["隐藏错误提示"] = "隱藏錯誤提示"
L["隐藏错误提示提示"] = "隱藏紅色的錯誤文本，如超出範圍，等等。"
L["自动接受邀请"] = "自動接受邀請"
L["自动接受邀请提示"] = "自動接受來自你的好友或公會成員邀請。"
L["自动交接任务"] = "自動交接任務"
L["自动交接任务提示"] = "自動接受，交付任務。需要時按住轉變可暫時阻止該功能。"
L["显示插件使用小提示"] = "顯示插件使用小提示"
L["显示插件使用小提示提示"] = "當AFK時在屏幕下方顯示插件使用的小提示"
L["出现了！"] = "出現了！"
L["稀有警报"] = "稀有警報"
L["稀有警报提示"] = "在搜索到稀有時提示你"
L["任务栏闪动"] = "任務欄閃動"
L["任务栏闪动提示"] = "在當遊戲處於後臺運行時，閃動任務欄上的按鈕提示妳正在倒數開怪，正在就位確認或是戰場/隨機副本已經找到隊伍。"
L["自动召宝宝"] = "自動召喚小寵物"
L["自动召宝宝提示"] = "當妳登陸，復活和離開載具時隨機召喚壹只小寵物"
L["随机奖励"] = "5人本獎勵提示"
L["随机奖励提示"] = "出現5人本獎勵時以團隊警報的方式提醒妳，僅僅在無隊伍時生效。"
L["在战斗中隐藏小地图"] = "在戰鬥中隱藏小地圖"
L["在战斗中隐藏聊天框"] = "在戰鬥中隱藏聊天框"
L["在副本中收起任务追踪"] = "在副本中收起任務追蹤"
L["在副本中收起任务追踪提示"] = "進入副本/戰場時自動收起任務追蹤，出去時自動展開。"
L["提升截图画质"] = "提升截圖畫質"
L["截图保存为tga格式"] = "截圖保存為tga格式"
L["暂离屏幕"] = "暫離時隱藏界面"
L["自定义任务追踪"] = "自定義任務追蹤"
L["自定义任务追踪提示"] = "如果妳需要使用任務追蹤插件，請啟用此選項。"

-- 插件界面
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

-- 插件提示
L["上一条"] = "上壹條"
L["下一条"] = "下壹條"
L["我不想看到这些提示"] = "我不想看到這些提示"
L["隐藏提示的提示"] = "你可以在 插件設置→其他設置 中恢復顯示這些提示"
L["TIPS"] = {
	"你可以設置在戰鬥中自動隱藏聊天框和小地圖，並在脫離戰鬥後顯示它們。這樣能讓戰鬥界面更清爽。",
	"左鍵點擊小地圖上的時鐘可以打開日歷，右鍵點擊可以切換本地時間/服務器時間，按住控制鍵再右鍵點擊可以切換12/24小時顯示模式。",
	"如何顯示獨立的施法條？插件設置→單位框體→施法條→獨立的玩家施法條",
	"如何只顯示治療模式的團隊框架？插件設置→團隊框架→切換→禁用自動切換並選擇治療模式",
	"如何改變特定怪物姓名版的顏色？插件設置→單位姓名版→自定義顏色",
	"命令：/rl - 重載界面 ",
	"命令：/hb - 按鍵綁定模式",
	"SHIFT+左鍵 - 設置焦點。點擊單位框體也可以哦！",
	"ALT+單擊物品 - 快速分解、研磨、選礦、開鎖",
	"激活輸入框時點擊Tab可以切換聊天頻道",
	"字體文件在哪裏？Interface\\AddOns\\AuroraClassic\\media\\font.ttf(主要字體)，Interface\\AddOns\\AltzUI\\media\\number.ttf(壹些時間文本用的字體)",
	"按住Ctrl，Shift或Alt可以快速滾動聊天框。",
 }
 
-- 界面移动
L["界面移动工具"] = "介面移動工具"
L["锚点框体"] = "錨點框體"
L["重置位置"] = "將這個框體重置到默認位置。"
L["healer"] = "|cff76EE00治療|r"
L["dpser"] = "|cffE066FF輸出/坦克|r"
L["选中的框体"] = "選中的框體"
L["当前模式"] = "當前模式"
L["进入战斗锁定"] = "進入戰鬥，鎖定所有框體。"
L["框体位置"] = "框體位置"
L["锁定框体"] = "鎖定框體"
L["解锁框体"] = "解鎖框體"
L["信息条"] = "信息條"
L["承受伤害"] = "承受傷害"
L["承受治疗"] = "承受治療"
L["输出伤害"] = "輸出傷害"
L["输出治疗"] = "輸出治療"
L["团队框架"] = "團隊框架"
L["宠物团队框架"] = "寵物\n團隊框架"
L["玩家头像"] = "玩家頭像"
L["宠物头像"] = "寵物頭像"
L["目标头像"] = "目標頭像"
L["目标的目标头像"] = "目標的目標\n頭像"
L["焦点头像"] = "焦點頭像"
L["焦点的目标头像"] = "焦點的目標\n頭像"
L["首领头像"] = "首領"
L["竞技场敌人头像"] = "競技場敵人"
L["小队队友"] = "小隊隊友"
L["玩家施法条"] = "玩家施法條"
L["目标施法条"] = "目標施法條"
L["焦点施法条"] = "焦点施法條"
L["玩家平砍计时条"] = "玩家平砍計時條"
L["冷却提示"] = "冷卻提示"
L["多人坐骑控制框"] = "多人坐騎控制框"
L["耐久提示框"] = "耐久提示框"
L["主菜单和背包"] = "主菜單和背包"

-- 插件皮肤
L["界面布局"] = "界面布局"
L["界面布局tip"] = "你希望以何種方式來佈局插件？"
L["默认布局"] = "默認佈局"
L["极简布局"] = "極簡佈局"
L["聚合布局"] = "聚合佈局"
L["插件皮肤"] = "皮膚"
L["更改设置"] = "重新設置該插件"
L["更改设置提示"] = "這將改變該插件的設置並重載界面"
L["边缘装饰"] = "長條裝飾"
L["两侧装饰"] = "邊角裝飾"
L["战斗字体"] = "戰鬥字體"

-- 命令
L["命令"] = "命令"
L["指令"] = [[
/rl - 重載界面
/Setup - 打開設置嚮導
SHIFT+左鍵-設定滑鼠懸停組織為焦點
CTRL+左鍵-為滑鼠懸停組織添加團隊標記
ALT+單擊物品 - 快速分解、研磨、選礦、開鎖
Tab - 切換聊天頻道
]]

-- 制作
L["制作"] = "制作"
L["制作说明"] = "AltzUI ver %s \n \n \n \n 泡泡 zhCN \n \n \n \n %s Thanks to \n \n %s \n 和每一個幫我完成一個插件包的朋友。|r"