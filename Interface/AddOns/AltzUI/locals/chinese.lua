﻿local T, C, L, G = unpack(select(2, ...))
if G.Client ~= "zhCN" then return end

-- 安装
L["小泡泡"] = "小泡泡"
L["欢迎使用"] = "欢迎安装 Altz UI"
L["简介"] = "  AltzUI是一个全职业通用的整合插件包，于2011年11月11日首次发布。它支持绝大部分分辨率，美化风格清爽简洁，占用也非常低，仅用2~3mb就能完成你所需要的大部分功能。如果你喜欢AltzUI，请将它推荐给其他公会成员或你的朋友，你的支持将是插件更新最大的动力。"

L["上一步"] = "上一步"
L["下一步"] = "下一步"
L["跳过"] = "跳过设置向导"
L["打开设置向导"] = "/Setup 打开设置向导"
L["完成"] = "完成"
L["更新日志"] = "更新日志"
L["更新日志tip"] = "新功能：\n更新10.00"
L["寻求帮助"] = "寻求帮助"
L["粘贴"] = "按住 Ctrl + c 来复制链接"
L["Buffs"] = "增益"
L["Debuffs_Black"] = "减益黑名单"
L["Debuffs"] = "减益"

-- 控制台通用
L["界面"] = "界面"
L["启用"] = "启用"
L["控制台"] = "控制台"
L["图标大小"] = "图标大小"
L["图标数量"] = "图标数量"
L["图标间距"] = "图标间距"
L["缩放尺寸"] = "缩放尺寸"
L["字体大小"] = "字体大小"
L["尺寸"] = "尺寸"
L["高度"] = "高度"
L["宽度"] = "宽度"
L["光环"] = "光环"
L["图标"] = "图标"
L["Buffs"] = "Buffs"
L["Debuffs"] = "Debuffs"
L["每一行的图标数量"] = "每一行的图标数量"
L["输入法术ID"] = "输入法术ID"
L["左"] = "左"
L["右"] = "右"
L["上"] = "上"
L["下"] = "下"
L["中间"] = "中间"
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
L["显示冷却"] = "显示%s的冷却时间"
L["导入/导出配置"] = "导入/导出配置"
L["排列方向"] = "排列方向"

-- 介绍
L["介绍"] = "介绍"
L["重置确认"] = "你想要重置所有的%s设置吗？"
L["重置"] = "重置"
L["导入确认"] = "你想要导入所有的%s设置吗？\n"
L["版本不符合"] = "\n版本%s（当前版本%s）"
L["客户端不符合"] = "\n客户端%s（当前客户端%s）"
L["职业不符合"] = "\n职业%s（当前职业%s）"
L["不完整导入"] = "\n导入可能不完整。"
L["导入"] = "导入"
L["导出"] = "导出"
L["无法导入"] = "错误的字符，无法导入。"

-- 聊天
L["聊天按钮悬停渐隐"] = "社交按钮悬停渐隐"
L["聊天按钮悬停渐隐提示"] = "当鼠标没有在聊天框左侧的按钮上时渐隐这些按钮。"
L["频道缩写"] = "频道缩写"
L["滚动聊天框"] = "滚动聊天框"
L["滚动聊天框提示"] = "十多秒后自动滚动至聊天框底部。"
L["自动邀请"] = "自动邀请"
L["自动邀请提示"] = "当被密语特定关键词后自动邀请玩家。"
L["关键词"] = "关键词"
L["关键词输入"] = "输入关键词，用空格隔开。"
L["聊天过滤"] = "聊天过滤"
L["聊天过滤提示"] = "屏蔽重复或包涵数个关键词的信息。"
L["过滤阈值"] = "过滤阈值"
L["显示聊天框背景"] = "显示聊天框背景"
L["复制聊天"] = "复制聊天内容"
L["无法自动邀请进组:"] = "我现在不能组你:"
L["我不能组人"] = "我没有组人权限"
L["小队满了"] = "小队满了"
L["团队满了"] = "团队满了"
L["客户端错误"] = "我现在不能自动邀请你进组，因为你的战网账号似乎粘在%s上了"

-- 背包和物品
L["启用背包模块"] = "启用背包模块"
L["背包图标大小"] = "背包图标大小"
L["背包每行图标数量"] = "背包每行图标数量"
L["自动修理"] = "自动修理"
L["自动修理提示"] = "与修理匠对话时自动修理装备"
L["自动公会修理"] = "自动公会修理"
L["自动公会修理提示"] = "优先使用公会资金自动修理"
L["灵活公会修理"] = "灵活公会修理"
L["灵活公会修理提示"] = "当可用的公会修理资金不足修理全部装备时用自己的钱修理。"
L["自动售卖"] = "自动售卖"
L["自动售卖提示"] = "与商人对话时自动售卖灰色品质物品"
L["已会配方着色"] = "已会配方着色"
L["已会配方着色提示"] = "已会配方的图标显示为绿色"
L["自动购买"] = "自动购买"
L["自动购买提示"] = "和商人对话时自动购买下列物品。"
L["输入自动购买的物品ID"] = "输入自动购买的物品ID"
L["输入物品ID"] = "输入物品ID"
L["输入数量"] = "输入数量"
L["不正确的物品ID"] = "不正确的物品ID"
L["不正确的数量"] = "不正确的数量"
L["显示物品等级"] = "显示物品等级"
L["显示物品等级提示"] = "在背包、银行和角色栏中显示装备的等级"
L["便捷物品按钮"] = "便捷物品按钮"
L["便捷物品按钮提示"] = "只在战斗外生效。"
L["每行图标数量"] = "每行图标数量"
L["精确匹配"] = "精确匹配"
L["精确匹配提示"] = "启用则只显示该物品，禁用则显示法术类似的物品（比如不同的神器能量）。"
L["显示数量"] = "显示数量"
L["显示数量提示"] = "显示背包中的该物品数量"
L["条件"] = "条件"
L["总是显示"] = "总是显示"
L["在职业大厅显示"] = "在职业大厅显示"
L["在团队副本中显示"] = "在团队副本中显示"
L["在地下城中显示"] = "在地下城中显示"
L["在战场中显示"] = "在战场中显示"
L["赚得"] = "赚得:"
L["消费"] = "消费:"
L["赤字"] = "赤字:"
L["盈利"] = "盈利:"
L["本次登陆"] = "本次登陆"
L["服务器"] = "服务器"
L["角色"] = "角色"
L["重置金币信息"] = "重置金币统计。"
L["修理花费"] = "修理花费:"
L["钱不够"] = "没有足够的钱来买"
L["购买"] = "购买了 %d %s."
L["货物不足"] = "商人没有足够的"
L["光标"] = "光标"
L["当前"] = "当前"

-- 单位框体
L["单位框体"] = "单位框体"
L["样式"] =  "样式"
L["总是显示生命值"] = "总是显示生命值"
L["总是显示生命值提示"] = "禁用则只在生命值不满时显示生命值"
L["总是显示能量值"] = "总是显示能量值"
L["总是显示能量值提示"] = "禁用则只在能量值不满时显示能量值"
L["数值字号"] = "数值字号"
L["数值字号提示"] = "生命值和法力值数值的字号"
L["显示肖像"] = "显示肖像"
L["肖像透明度"] = "肖像透明度"
L["宽度提示"] = "玩家，目标和焦点框体的宽度。"
L["宠物框体宽度"] = "宠物框体宽度"
L["首领框体和PVP框体的宽度"] = "首领框体和PVP框体的宽度"
L["生命条高度比"] = "生命条高度比"
L["生命条高度比提示"] = "生命条高度和框体高度的比例"
L["施法条"] = "施法条"
L["独立施法条"] = "独立施法条"
L["玩家施法条"] = "玩家施法条"
L["目标施法条"] = "目标施法条"
L["焦点施法条"] = "焦点施法条"
L["法术名称位置"] = "法术名称位置"
L["可打断施法条图标颜色"] = "可打断施法条图标颜色"
L["不可打断施法条图标颜色"] = "不可打断施法条图标颜色"
L["施法时间位置"] = "施法时间位置"
L["引导法术分段"] = "引导法术分段"
L["隐藏玩家施法条图标"] = "隐藏玩家施法条图标"
L["平砍计时条"] = "平砍计时条"
L["显示副手"] = "显示副手"
L["显示平砍计时"] = "显示时间"
L["减益边框"] = "减益边框"
L["减益边框提示"] = "根据减益类型染色减益边框."
L["每行的光环数量提示"] = "此数值会影响图标大小"
L["玩家减益"] = "玩家减益"
L["玩家减益提示"] = "在玩家框体上显示施放在减益玩家"
L["过滤增益"] = "光环过滤 : 忽视增益"
L["过滤增益提示"] = "隐藏其他玩家是放在友方单位身上的增益。"
L["过滤减益"] = "光环过滤 : 忽视减益"
L["过滤减益提示"] = "隐藏其他玩家是放在敌方单位身上的减益。"
L["过滤小队增益"] = "过滤小队增益"
L["过滤小队增益提示"] = "按照团队框架治疗图标指示器规则显示小队BUFF"
L["白名单"] = "白名单"
L["白名单提示"] = "编辑白名单来使一个光环在启用过滤时强制显示。\n在白名单中，一个其他玩家施放在敌方单位身上的减益颜色不会变灰。"
L["已经在白名单中"] = "已经在白名单中。"
L["被添加到法术过滤白名单中"] = "被添加到法术过滤白名单中。"
L["从法术过滤白名单中移出"] = "从法术过滤白名单中移出。"
L["不是一个有效的法术ID"] = "不是一个有效的法术ID。"
L["图腾条"] = "图腾条"
L["显示PvP标记"] = "显示PvP标记"
L["显示PvP标记提示"] = "建议在PvE服务器使用。"
L["启用首领框体"] = "启用首领框体"
L["启用PVP框体"] = "PVP框体"
L["在小队中显示自己"] = "在小队中显示自己"
L["显示法力条"] = "显示法力条"
L["显示法力条提示"] = "为增强和元素萨满显示法力条"
L["启用仇恨条"] = "启用仇恨条"
L["显示醉拳条"] = "显示醉拳条"
L["的徽章冷却就绪"] = "的徽章冷卻就緒"
L["使用了徽章"] = "使用了徽章"

-- 团队框架
L["团队框架"] = "团队框架"
L["团队框架tip"] = "团队框架是否随专精改变？"
L["通用设置"] = "通用设置"
L["显示宠物"] = "显示宠物"
L["名字长度"] = "名字长度"
L["未进组时显示"] = "未进组时显示"
L["刷新载具"] = "刷新载具"
L["团队规模"] = "团队规模"
L["40-man"] = "40人"
L["30-man"] = "30人"
L["20-man"] = "20人"
L["10-man"] = "10人"
L["raidmanabars"] = "显示法力条"
L["GCD"] = "GCD"
L["GCD提示"] = "在团队框体上指示GCD。"
L["显示缺失生命值"] = "显示缺失生命值"
L["显示缺失生命值提示"] = "在生命值低于90%时显示血量。"
L["治疗和吸收预估"] = "治疗和吸收预估"
L["治疗和吸收预估提示"] = "在团队框体指示预计治疗和吸收量。"
L["职业顺序"] = "根据职业顺序排列"
L["整体高度"] = "整体高度"
L["整体高度提示"] = "每一列的框体数量"
L["点击施法"] = "点击施法"
L["点击施法提示"] = "输入 %starget|r 来选定鼠标悬停单位为目标。\n输入 %sfocus|r 将鼠标悬停单位设置为焦点。\n输入 %stot|r 来选定该单位的目标为目标。\n输入 %sfollow|r 跟随该单位。\n输入 %s法术名称|r 在该单位上施法。\n输入 %smacro|r 来绑定一个宏。"
L["Button1"] = "左键" 
L["Button2"] = "右键" 
L["Button3"] = "中键" 
L["Button4"] = "按键4" 
L["Button5"] = "按键5" 
L["MouseUp"] = "滚轮上" 
L["MouseDown"] = "滚轮下" 
L["不正确的法术名称"] = "不正确的法术名称"
L["输入一个宏"] = "输入一个宏"
L["输入层级"] = "层级"
L["必须是一个数字"] = "必须是一个数字。"
L["主坦克和主助手"] = "主坦克和主助手"
L["主坦克和主助手提示"] = "在团队框架中显示主坦克和主助手的图标"
L["治疗指示器"] = "治疗指示器"
L["数字指示器"] = "数字指示器"
L["图标指示器"] = "图标指示器"
L["团队减益"] = "团队减益"
L["减益过滤"] = "减益过滤"
L["团队增益"]= "团队增益"
L["自动添加团队减益"] = "自动将新发现的副本减益加入列表"
L["自动添加团队减益提示"] = "自动将新发现的副本减益加入列表，你可以在团队减益列表中将新添加的减益删除，或通过减益过滤黑名单禁止其显示。"
L["自动添加的图标层级"] = "自动添加的图标层级"
L["团队工具"] = "团队工具"
L["添加团队减益"] = "|cff7FFF00团队减益添加成功|r %s %s"
L["杂兵"] = "杂兵"
L["设置"] = "设置"
L["删除并加入黑名单"] = "删除并加入黑名单"
L["已删除并加入黑名单"] = "|cff7FFF00已删除并加入黑名单:%s|r"

-- 动作条
L["向上排列"] = "向上排列"
L["向上排列说明"] = "当动作条有多行时向上排列"
L["显示冷却时间"] = "显示冷却时间"
L["冷却时间数字大小"] = "冷却时间数字大小"
L["冷却时间数字大小提示"] = "只能调整大于25*25象素冷却框体的字号，更小的冷却框体会自动调整到适合的字号。注意如果框体太小则不会显示冷却数字。"
L["显示冷却时间提示"] = "在动作条和物品上显示冷却时间。"
L["显示冷却时间提示WA"] = "在WA特效上显示冷却时间。"
L["不可用颜色"] = "不可用颜色"
L["不可用颜色提示"] = "当动作条按钮不可用时改变它的颜色。比如超出距离，能量不足等。"
L["键位字体大小"] = "键位字体大小"
L["宏名字字体大小"] = "宏名字字体大小"
L["可用次数字体大小"] = "可用次数字体大小"

L["条件渐隐"] = "条件渐隐"
L["条件渐隐提示"] = "当你不施法，不在战斗，没有目标且达到\n最大生命值和最大/最小能量值时启用渐隐。"
L["悬停渐隐"] = "悬停渐隐"
L["悬停渐隐提示"] = "当你的鼠标没有悬停在动作条上时启用动作条渐隐。"
L["渐隐透明度"] = "渐隐透明度"
L["渐隐透明度提示"] = "未激活时的透明度"

L["主动作条"] = "主动作条"
L["额外动作条"] = "额外动作条"
L["额外动作条布局"] = "额外动作条布局"
L["额外动作条间距"] = "间距"
L["额外动作条间距提示"] = "额外动作条左右两部分中间的距离是主动作条的宽度加两倍僵局。\n这个选项只在启用3*2*2布局时生效。"
L["6*4布局"] = "6*4布局"
L["右侧额外动作条"] = "右侧额外动作条"
L["宠物动作条"] = "宠物动作条"
L["5*2布局"] = "5*2布局"
L["5*2布局提示"] = "宠物动作条使用5*2布局，\n禁用则使用10*1布局。"
L["姿态/形态条"] = "姿态/形态条"
L["离开载具按钮"] = "离开载具按钮"
L["额外特殊按钮"] = "额外特殊按钮"
L["横向动作条"] = "横向排列右侧动作条"

L["冷却提示"] = "冷却提示"
L["透明度"] = "透明度"
L["忽略法术"] = "忽略法术"
L["忽略物品"] = "忽略物品"

-- 姓名板
L["姓名板tip"] = "你希望以何种方式显示姓名板？"
L["数字样式"] = "数字样式"
L["职业色-条形"] = "职业色-条形"
L["深色-条形"] = "深色-条形"
L["仇恨染色"] = "根据仇恨情况染色"
L["自定义颜色"] = "自定义颜色"
L["空"] = "空"
L["我的法术"] = "我的法术"
L["其他法术"] = "其他法术"
L["黑名单"] = "黑名单"
L["全部隐藏"] = "全部隐藏"
L["过滤方式"] = "过滤方式"
L["显示玩家姓名板"] = "显示玩家姓名板"
L["显示玩家姓名板光环"] = "显示玩家姓名板光环"
L["显示玩家施法条"] = "显示玩家姓名板施法条"
L["姓名板资源位置"] = "副资源位置"
L["姓名板资源尺寸"] = "姓名板资源尺寸"
L["目标姓名板"] = "目标姓名板"
L["玩家姓名板"] = "玩家姓名板"
L["名字字体大小"] = "名字字体大小"
L["可打断施法条颜色"] = "可打断施法条颜色"
L["不可打断施法条颜色"] = "不可打断施法条颜色"
L["自定义能量"] = "自定义能量"
L["数值样式"] = "数值样式"
L["百分比"] = "百分比"
L["数值和百分比"] = "数值和百分比"
L["条形样式"] = "条形样式"
L["友方只显示名字"] = "友方只显示名字"
L["根据血量染色"] = "根据血量染色"
L["焦点染色"] = "染色焦点目标"
L["焦点颜色"] = "焦点颜色"
L["图标数字大小"] = "图标数字大小"
L["空"] = "空"
L["自定义能量"] = "自定义能量"
L["自定义颜色"] = "自定义颜色"
L["列表已满"] = "%s列表已满"
L["添加自定义颜色"] = "添加 [%s] 到姓名板自定义颜色列表"
L["添加自定义能量"] = "添加 [%s] 到姓名板自定义能量列表"
L["移除自定义颜色"] = "从姓名板自定义颜色列表中移除 |cff%02x%02x%02x[%s]|r"
L["移除自定义能量"] = "从姓名板自定义能量列表中移除 [%s]"
L["替换自定义颜色"] = "从姓名板自定义颜色列表中替换 |cff%02x%02x%02x[%s]|r 的颜色"
L["已加入列表"] = "|cff7FFF00添加成功|r |cff%02x%02x%02x[%s]|r已加入%s。"
L["已从列表移除"] = "|cff00FFFF移除成功|r |cff%02x%02x%02x[%s]|r已从%s移除。"

-- 鼠标提示
L["跟随光标"] = "跟随光标"
L["隐藏服务器名称"] = "隐藏服务器名称"
L["隐藏称号"] = "隐藏称号"
L["显示法术编号"] = "显示法术编号"
L["显示物品编号"] = "显示物品编号"
L["显示天赋"] = "显示天赋"
L["战斗中隐藏"] = "战斗中隐藏"
L["背景透明度"] = "背景透明度"
L["大秘境评分"] = "大秘境评分"
L["副本"] = "副本"
L["评分层数"] = "评分（最高层数）"

-- 战斗信息
L["战斗信息"] = "战斗信息"
L["承受伤害/治疗"] = "显示受到的治疗和伤害"
L["输出伤害/治疗"] = "显示输出的治疗和伤害"
L["数字缩写样式"] = "数字缩写样式"
L["暴击图标大小"] = "暴击图标大小"
L["显示DOT"] = "显示DOT"
L["显示HOT"] = "显示HOT"
L["显示宠物"] = "显示宠物"
L["隐藏时间"] = "隐藏时间"
L["隐藏时间提示"] =  "战斗信息出现后经过一小段时间会渐渐隐藏"
L["隐藏浮动战斗信息接受"] = "隐藏暴雪浮动战斗信息(输出的伤害和治疗)"
L["隐藏浮动战斗信息输出"] = "隐藏暴雪浮动战斗信息(受到的伤害和治疗)"

-- 其他
L["界面风格"] = "界面风格"
L["界面风格tip"] = "你希望以何种方式显示头像和团队框架？"
L["透明样式"] = "透明主题"
L["深色样式"] = "深色主题"
L["普通样式"] = "经典主题"
L["小地图尺寸"] = "小地图尺寸"
L["系统菜单尺寸"] = "系统菜单尺寸"
L["信息条尺寸"] = "信息条尺寸"
L["整理小地图图标"] = "整理小地图图标"
L["整理栏位置"] = "整理栏位置"
L["成就截图"] = "成就截图"
L["成就截图提示"] = "你获得成就的时候自动截图。"
L["自动接受复活"] = "自动接受复活"
L["自动接受复活提示"] = "自动接受复活，只在战斗外生效。"
L["战场自动释放灵魂"] = "战场自动释放灵魂"
L["战场自动释放灵魂提示"] = "在战场，冬拥湖和托尔巴拉德自动释放灵魂。"
L["隐藏错误提示"] = "隐藏错误提示"
L["隐藏错误提示提示"] = "隐藏红色的错误文本，如超出范围，等等。"
L["自动接受邀请"] = "自动接受邀请"
L["自动接受邀请提示"] = "自动接受来自你的好友或公会成员邀请。"
L["自动交接任务"] = "自动交接任务"
L["自动交接任务提示"] = "自动接受，交付任务。需要时按住shift可暂时阻止该功能。"
L["显示插件使用小提示"] = "显示插件使用小提示"
L["显示插件使用小提示提示"] = "当AFK时在屏幕下方显示插件使用的小提示"
L["出现了！"] = "出现了！"
L["稀有警报"] = "稀有警报"
L["稀有警报提示"] = "在搜索到稀有时提示你"
L["任务栏闪动"] = "任务栏闪动"
L["任务栏闪动提示"] = "在当游戏处于后台运行时，闪动任务栏上的按钮提示你正在倒数开怪，正在就位确认或是战场/随机副本已经找到队伍。"
L["自动召宝宝"] = "自动召唤小宠物"
L["自动召宝宝提示"] = "当你登陆，复活和离开载具时随机召唤一只小宠物"
L["随机奖励"] = "5人本奖励提示"
L["随机奖励提示"] = "出现5人本奖励时以团队警报的方式提醒你，仅仅在无队伍时生效。"
L["在战斗中隐藏小地图"] = "在战斗中隐藏小地图"
L["在战斗中隐藏聊天框"] = "在战斗中隐藏聊天框"
L["在副本中收起任务追踪"] = "在副本中收起任务追踪"
L["在副本中收起任务追踪提示"] = "进入副本/战场时自动收起任务追踪，出去时自动展开。"
L["提升截图画质"] = "提升截图画质"
L["截图保存为tga格式"] = "截图保存为tga格式"
L["登陆屏幕"] = "登陆时隐藏界面"
L["暂离屏幕"] = "暂离时隐藏界面"
L["快速焦点"] = "使用SHIFT+左键快速设置焦点"
L["自定义任务追踪"] = "自定义任务追踪"
L["自定义任务追踪提示"] = "如果你需要使用任务追踪插件，请启用此选项。"
L["快速标记"] = "使用CTRL+左键快速设置标记"

-- 插件界面
L["当前经验"] = "当前经验： "
L["剩余经验"] = "剩余经验： "
L["双倍"] = "双倍： "
L["声望"] = "声望："
L["剩余声望"] = "剩余声望： "
L["占用前 %d 的插件"] = "占用前 %d 的插件"
L["自定义插件占用"] = "自定义插件占用"
L["所有插件占用"] = "所有插件占用"
L["团队工具"] = "团队工具"
L["脱装备"] = "脱装备"

-- 插件提示
L["上一条"] = "上一条"
L["下一条"] = "下一条"
L["我不想看到这些提示"] = "我不想看到这些提示"
L["隐藏提示的提示"] = "你可以在 插件设置→其他设置 中恢复显示这些提示"
L["TIPS"] = {
	"你可以设置在战斗中自动隐藏聊天框和小地图，并在脱离战斗后显示它们。这样能让战斗界面更清爽。",
	"左键点击小地图上的时钟可以打开日历，右键点击可以切换本地时间/服务器时间，按住控制键再右键点击可以切换12/24小时显示模式。",
	"如何显示独立的施法条？插件设置→单位框体→施法条→独立的玩家施法条",
	"如何只显示治疗模式的团队框架？插件设置→团队框架→切换→禁用自动切换并选择治疗模式",
	"如何改变特定怪物姓名版的颜色？插件设置→单位姓名版→自定义颜色",
	"命令：/rl - 重载界面 ",
	"命令：/hb - 按键绑定模式",
	"SHIFT+左键 - 设置焦点。点击单位框体也可以哦！",
	"ALT+单击物品 - 快速分解、研磨、选矿、开锁",
	"激活输入框时点击Tab可以切换聊天频道",
	"字体文件在哪里？Interface\\AddOns\\AuroraClassic\\media\\font.ttf(主要字体)，Interface\\AddOns\\AltzUI\\media\\number.ttf(一些时间文本用的字体)",
	"按住Ctrl，Shift或Alt可以快速滚动聊天框。",
 }
 
-- 界面移动
L["界面移动工具"] = "界面移动工具"
L["锚点框体"] = "锚点框体"
L["重置位置"] = "将这个框体重置到默认位置。"
L["healer"] = "|cff76EE00治疗|r"
L["dpser"] = "|cffE066FF输出/坦克|r"
L["选中的框体"] = "选中的框体"
L["当前模式"] = "当前模式"
L["进入战斗锁定"] = "进入战斗，锁定所有框体。"
L["锁定框体"] = "锁定框体"
L["解锁框体"] = "解锁框体"
L["重置框体位置"] = "重置框体位置"
L["重置确认"] = "你想要重置所有框体的位置吗？"
L["信息条"] = "信息条"
L["承受伤害"] = "承受伤害"
L["承受治疗"] = "承受治疗"
L["输出伤害"] = "输出伤害"
L["输出治疗"] = "输出治疗"
L["团队框架"] = "团队框架"
L["宠物团队框架"] = "宠物\n团队框架"
L["玩家头像"] = "玩家头像"
L["宠物头像"] = "宠物头像"
L["目标头像"] = "目标头像"
L["目标的目标头像"] = "目标的目标\n头像"
L["焦点头像"] = "焦点头像"
L["焦点的目标头像"] = "焦点的目标\n头像"
L["首领头像"] = "首领"
L["竞技场敌人头像"] = "竞技场敌人"
L["小队队友"] = "小队队友"
L["玩家施法条"] = "玩家施法条"
L["目标施法条"] = "目标施法条"
L["焦点施法条"] = "焦点施法条"
L["玩家平砍计时条"] = "玩家平砍计时条"
L["冷却提示"] = "冷却提示"
L["图腾条"] = "图腾条"
L["多人坐骑控制框"] = "多人坐骑控制框"
L["耐久提示框"] = "耐久提示框"
L["主菜单和背包"] = "主菜单和背包"

-- 插件皮肤
L["界面布局"] = "界面布局"
L["界面布局tip"] = "你希望以何种方式来布局插件？"
L["默认布局"] = "默认布局"
L["极简布局"] = "极简布局"
L["聚合布局"] = "聚合布局"
L["插件皮肤"] = "皮肤"
L["更改设置"] = "重新设置该插件"
L["更改设置提示"] = "这将改变该插件的设置并重载界面"
L["边缘装饰"] = "长条装饰"
L["两侧装饰"] = "边角装饰"
L["战斗字体"] = "战斗字体"

-- 命令
L["命令"] = "命令"
L["指令"] = " %s/rl|r - 重载界面 \n \n %sALT+单击物品|r - 快速分解、研磨、选矿、开锁 \n \n %sTab|r - 切换聊天频道 \n \n %s/Setup|r - 打开设置向导"

-- 制作
L["制作"] = "制作"
L["制作说明"] = "AltzUI ver %s \n \n \n \n 泡泡 zhCN \n \n \n \n %s Thanks to \n \n %s \n 和每一个帮我我完成一个插件包的朋友。|r"