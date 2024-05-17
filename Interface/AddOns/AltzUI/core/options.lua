local T, C, L, G = unpack(select(2, ...))

local combattext_font_alert
local overrideArchive
G.Options = {
	SkinOptions = {
		{ -- 1 标题:界面风格
			option_type = "title",
			text = L["界面风格"],
			line = true,
		},
		{ -- 2 样式
			key = "style",
			option_type = "ddmenu",
			text = L["样式"],
			option_table = {
				{1, L["透明样式"]},
				{2, L["深色样式"]},
				{3, L["普通样式"]},
			},
			apply = function()
				G.BGFrame.Apply()
				T.ApplyUFSettings({"Castbar", "Swing", "Health", "Power", "HealthPrediction"})
			end,
		},
		{ -- 3 数字缩写样式
			key = "formattype",
			option_type = "ddmenu",
			text = L["数字缩写样式"],
			option_table = {
				{"k", "k m"},
				{"w", "w kw"},
				{"w_chinese", "万 千万"},
			},
			apply = function()
				G.BGFrame.Apply()
				T.ApplyUFSettings({"Castbar", "Swing", "Health", "Power", "HealthPrediction"})
			end,
		},
		{ -- 4 上方边缘装饰
			key = "showtopbar",
			option_type = "check",
			width = .5,
			text = L["上方"].." "..L["边缘装饰"],
			apply = function()
				G.BGFrame.Apply()
			end,
		},
		{ -- 5 上方两侧装饰
			key = "showtopconerbar",
			option_type = "check",		
			width = .5,
			text = L["上方"].." "..L["两侧装饰"],
			apply = function()
				G.BGFrame.Apply()
			end,
		},
		{ -- 6 下方边缘装饰
			key = "showbottombar",
			option_type = "check",
			width = .5,
			text = L["下方"].." "..L["边缘装饰"],
			apply = function()
				G.BGFrame.Apply()
			end,
		},
		{ -- 7 下方两侧装饰
			key = "showbottomconerbar",
			option_type = "check",
			width = .5,
			text = L["下方"].." "..L["两侧装饰"],
			pos = "RIGHT",
			apply = function()
				G.BGFrame.Apply()
			end,
		},
		{ -- 8 标题:插件皮肤
			option_type = "title",
			text = L["插件皮肤"],
			line = true,
		},
		{ -- 9 标题:界面布局
			option_type = "title",
			text = L["界面布局"],
			line = true,
		},
		{ -- 10 信息条
			key = "infobar",
			option_type = "check",
			text = L["信息条"],
			apply = function()
				G.InfoFrame.Apply()
			end,
		},
		{ -- 11 信息条尺寸
			key = "infobarscale",
			option_type = "slider",
			text = T.split_words(L["信息条"],L["尺寸"]),
			min = .5,
			max = 2,
			step = .05,
			apply = function()
				G.InfoFrame.Apply()
			end,
			relatedFrames = {
				["AltzUI_InfoFrame"] = true,
			},
			rely = "infobar",
		},
		{ -- 12 分割线
			option_type = "title",
			line = true,
		},
		{ -- 13 在副本中收起任务追踪
			key = "collapseWF",
			option_type = "check",
			text = L["在副本中收起任务追踪"],
			tip = L["在副本中收起任务追踪提示"],
		},
		{ -- 14 暂离屏幕
			key = "afkscreen",
			option_type = "check",
			text = L["暂离屏幕"],
		},
		{ -- 15 显示插件使用小提示
			key = "showAFKtips",
			option_type = "check",
			text = L["显示插件使用小提示"],
			tip = L["显示插件使用小提示提示"],
			rely = "afkscreen",
		},
		{ -- 16 分割线
			option_type = "title",
			line = true,
		},
	},
	ChatOptions = {
		{ -- 1 标题:社交
			option_type = "title",
			text = SOCIAL_LABEL,
			line = true,
		},
		{ -- 2 频道缩写
			key = "channelreplacement",
			option_type = "check",
			width = .4,
			text = L["频道缩写"],
			apply = function()
				T.UpdateChannelReplacement()
			end,
		},
		{ -- 3 显示聊天戳
			key = "showTimestamps",
			option_type = "cvar_check",
			width = .6,
			text = SHOW_TIMESTAMP,
			arg1 = T.color_text("H:%M "),
			arg2 = "none",
		},
		{ -- 4 滚动聊天框
			key = "autoscroll",
			option_type = "check",
			width = .4,
			text = L["滚动聊天框"],
			tip = L["滚动聊天框提示"],
		},
		{ -- 5 显示聊天框背景
			key = "showbg",
			option_type = "check",
			width = .6,
			text = L["显示聊天框背景"],
			apply = function()
				T.UpdateChatFrameBg()
			end,
		},
		{ -- 6 分割线
			option_type = "title",
			line = true,
		},
		{ -- 7 聊天过滤
			key = "nogoldseller",
			option_type = "check",
			text = L["聊天过滤"],
			tip = L["聊天过滤提示"],
		},
		{ -- 8 过滤阈值
			key = "goldkeywordnum",
			option_type = "slider",
			text = L["过滤阈值"],
			min = 1,
			max = 5,
			step = 1,
			apply = function()
				G.InfoFrame.Apply()
			end,
			rely = "nogoldseller",
		},
		{ -- 9 关键词
			key = "goldkeywordlist",
			option_type = "multi_editbox",
			text = L["关键词"],
			tip = L["关键词输入"],
			width = 3,
			apply = function()
				T.Update_Chat_Filter()
			end,
			rely = "nogoldseller",
		},
		{ -- 10 分割线
			option_type = "title",
			line = true,
		},
		{ -- 11 聊天过滤
			key = "autoinvite",
			option_type = "check",
			text = L["自动邀请"],
			tip = L["自动邀请提示"],
		},
		{ -- 12 关键词
			key = "autoinvitekeywords",
			option_type = "editbox",
			text = L["关键词"],
			tip = L["关键词输入"],
			apply = function()
				T.Update_Invite_Keyword()
			end,
			rely = "autoinvite",
		},
		{ -- 13 自动接受好友的组队邀请
			key = "acceptInvite_friend",
			option_type = "check",
			text = L["自动接受好友的组队邀请"],
		},
		{ -- 14 自动接受公会成员的组队邀请
			key = "acceptInvite_guild",
			option_type = "check",
			text = L["自动接受公会成员的组队邀请"],
		},
		{ -- 15 自动接受社区成员的组队邀请
			key = "acceptInvite_club",
			option_type = "check",
			text = L["自动接受社区成员的组队邀请"],
		},
		{ -- 16 自动接受同一战网其他角色的组队邀请
			key = "acceptInvite_account",
			option_type = "check",
			text = L["自动接受同一战网其他角色的组队邀请"],
		},
		{ -- 17 拒绝陌生人的组队邀请
			key = "refuseInvite_stranger",
			option_type = "check",
			text = L["拒绝陌生人的组队邀请"],
		},
	},
	ItemOptions = {
		{ -- 1 标题:物品
			option_type = "title",
			text = ITEMS,
			line = true,
		},
		{ -- 2 显示物品等级
			key = "itemLevel",
			option_type = "check",
			text = T.split_words(L["显示"],STAT_AVERAGE_ITEM_LEVEL),
			apply = function()
				T.ToggleItemLevel()
			end,
		},		
		{ -- 3 已会配方着色
			key = "alreadyknown",
			option_type = "check",
			text = L["已会配方着色"],
			tip = L["已会配方着色提示"],
		},
		{ -- 4 分割线
			option_type = "title",
			line = true,
		},
		{ -- 5 自动修理
			key = "autorepair",
			option_type = "check",
			text = L["自动修理"],
			tip = L["自动修理提示"],
		},
		{ -- 6 优先使用公会修理
			key = "autorepair_guild",
			option_type = "check",
			text = L["优先使用公会修理"],
			tip = L["优先使用公会修理提示"],
			rely = "autorepair",
		},
		{ -- 7 分割线
			option_type = "title",
			line = true,
		},
		{ -- 8 自动售卖
			key = "autosell",
			option_type = "check",
			text = L["自动售卖"],
			tip = L["自动售卖提示"],
		},
		{ -- 9 自动购买
			key = "autobuy",
			option_type = "check",
			text = L["自动购买"],
			tip = L["自动购买提示"],
		},
		{ -- 10 分割线
			option_type = "title",
			line = true,
		},
	},
	UnitframeOptions = {
		{ -- 标题:样式
			option_type = "title",
			text = L["样式"],
			line = true,
		},
		{ -- 条件渐隐
			key = "enablefade",
			option_type = "check",
			text = L["条件渐隐"],
			tip = L["条件渐隐提示"],
			apply = function()
				T.EnableUFSettings({"Fader"})
				T.ApplyUFSettings({"Fader"})
			end,
			relatedFrames = {
				["oUF_AltzPlayer"] = true,
				["oUF_AltzPet"] = true,
				["oUF_AltzFocus"] = true,
				["oUF_AltzFocusTarget"] = true,
			},
		},
		{ -- 渐隐透明度
			key = "fadingalpha",
			option_type = "slider",
			text = L["渐隐透明度"],
			tip = L["渐隐透明度提示"],
			min = 0,
			max = .8,
			step = .05,
			apply = function()
				T.ApplyUFSettings({"Fader"})
				T.ApplyActionbarFadeAlpha()
			end,
			relatedFrames = {
				["oUF_AltzPlayer"] = true,
				["oUF_AltzPet"] = true,
				["oUF_AltzFocus"] = true,
				["oUF_AltzFocusTarget"] = true,
			},
			rely = "enablefade",
		},
		{ -- 分割线
			option_type = "title",
			line = true,
		},
		{ -- 肖像
			key = "portrait",
			option_type = "check",
			text = T.split_words(L["显示"],L["肖像"]),
			apply = function()
				T.EnableUFSettings({"Portrait"})
			end,
			relatedFrames = {
				["oUF_AltzPlayer"] = true,
				["oUF_AltzTarget"] = true,
				["oUF_AltzFocus"] = true,
			},
		},
		{ -- 分割线
			option_type = "title",
			line = true,
		},
		{ -- 总是显示生命值
			key = "alwayshp",
			option_type = "check",
			text = T.split_words(L["总是"],L["显示"],L["生命值"]),
			tip = string.format(L["总是显示数值提示"], L["生命值"]),
			apply = function()
				T.ApplyUFSettings({"Health"})
			end,
		},
		{ -- 总是显示能量值
			key = "alwayspp",
			option_type = "check",
			text = T.split_words(L["总是"],L["显示"],L["能量值"]),
			tip = string.format(L["总是显示数值提示"], L["能量值"]),
			apply = function()
				T.ApplyUFSettings({"Power"})
			end,
		},
		{ -- 数值字体尺寸
			key = "valuefontsize",
			option_type = "slider",
			text = T.split_words(L["数值"],L["字体"],L["尺寸"]),
			min = 10,
			max = 25,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Health", "Power", "Castbar"})
			end,
		},
		{ -- 10 分割线
			option_type = "title",
			line = true,
		},
		{ -- BOSS单位框架
			key = "bossframes",
			option_type = "check",
			text = T.split_words(L["启用"],BOSS,L["单位框架"]),
			apply = function()
				StaticPopup_Show(G.uiname.."Reload Alert")
			end,
		},
		{ -- ARENA单位框架
			key = "arenaframes",
			option_type = "check",
			text = T.split_words(L["启用"],ARENA,L["单位框架"]),
			apply = function()
				StaticPopup_Show(G.uiname.."Reload Alert")
			end,
		},
		{ -- 图腾
			key = "totems",
			option_type = "check",
			text = T.split_words(L["图腾条"]),
			apply = function()
				T.ApplyTotemsBarSettings()
			end,
		},
		{ -- 图腾图标尺寸
			key = "totemsize",
			option_type = "slider",
			text = T.split_words(L["图腾条"],L["图标"], L["尺寸"]),
			min = 15,
			max = 40,
			step = 1,
			apply = function()
				T.ApplyTotemsBarSettings()
			end,
			relatedFrames = {
				["AltzUI_TotemBar"] = true,
			},
		},		
		{ -- 排列方向
			key = "growthDirection",
			option_type = "ddmenu",
			text = L["排列方向"],
			option_table = {
				{"HORIZONTAL", L["水平"]},
				{"VERTICAL", L["垂直"]},
			},
			apply = function()
				T.ApplyTotemsBarSettings()
			end,
			relatedFrames = {
				["AltzUI_TotemBar"] = true,
			},
		},
		{ -- 排列顺序
			key = "sortDirection",
			option_type = "ddmenu",
			text = L["排列顺序"],
			option_table = {
				{"ASCENDING", L["正序"]},
				{"DESCENDING", L["反序"]},
			},
			apply = function()
				T.ApplyTotemsBarSettings()
			end,
			relatedFrames = {
				["AltzUI_TotemBar"] = true,
			},
		},
		{ -- 高度
			key = "height",
			option_type = "slider",
			text = L["高度"],
			min = 5,
			max = 50,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Health", "Power", "Auras", "Castbar", "ClassPower", "Runes", "Stagger", "Dpsmana", "PVPSpecIcon", "Trinket"})
			end,
			relatedFrames = {
				["oUF_AltzPlayer"] = true,
				["oUF_AltzPet"] = true,
				["oUF_AltzTarget"] = true,
				["oUF_AltzTargetTarget"] = true,
				["oUF_AltzFocus"] = true,
				["oUF_AltzFocusTarget"] = true,
				["oUF_AltzBoss1"] = true,
				["oUF_AltzBoss2"] = true,
				["oUF_AltzBoss3"] = true,
				["oUF_AltzBoss4"] = true,
				["oUF_AltzBoss5"] = true,
				["oUF_AltzArena1"] = true,
				["oUF_AltzArena2"] = true,
				["oUF_AltzArena3"] = true,
				["oUF_AltzArena4"] = true,
				["oUF_AltzArena5"] = true,				
			},
		},
		{ -- 宽度
			key = "width",
			option_type = "slider",
			text = L["宽度"],
			tip = L["宽度提示"],
			min = 50,
			max = 500,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Health", "Auras", "ClassPower", "Runes", "Stagger", "Dpsmana"})
			end,
			relatedFrames = {
				["oUF_AltzPlayer"] = true,
				["oUF_AltzTarget"] = true,
				["oUF_AltzFocus"] = true,
			},
		},
		{ -- 能量条高度
			key = "ppheight",
			option_type = "slider",
			text = T.split_words(L["能量条"], L["高度"],L["比例"]),
			min = 0.05,
			max = 1,
			step = 0.05,
			apply = function()
				T.ApplyUFSettings({"Health", "Power", "Auras", "Castbar", "ClassPower", "Runes", "Stagger", "Dpsmana"})
			end,
		},
		{ -- 20 分割线
			option_type = "title",
			line = true,
		},
		{ -- 宠物框架宽度
			key = "widthpet",
			option_type = "slider",
			text = T.split_words(PET,L["宽度"]),
			min = 50,
			max = 500,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Health", "Auras"}, "Altz - Pet")
			end,
			relatedFrames = {
				["oUF_AltzPet"] = true,
				["oUF_AltzTargetTarget"] = true,
				["oUF_AltzFocusTarget"] = true,
			},
		},
		{ -- 小队宽度
			key = "widthparty",
			option_type = "slider",
			text = T.split_words(PARTY,L["宽度"]),
			min = 50,
			max = 500,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Health", "Auras"}, "Altz - Party")
			end,
			relatedFrames = {
				["oUF_AltzParty1"] = true,
				["oUF_AltzParty2"] = true,
				["oUF_AltzParty3"] = true,
				["oUF_AltzParty4"] = true,
			},
		},
		{ -- 小队宠物
			key = "showpartypet",
			option_type = "check",
			text = T.split_words(L["显示"], PARTY, PET),
			apply = function()
				StaticPopup_Show(G.uiname.."Reload Alert")
			end,
			relatedFrames = {
				["oUF_AltzParty1"] = true,
				["oUF_AltzParty2"] = true,
				["oUF_AltzParty3"] = true,
				["oUF_AltzParty4"] = true,
			},
		},
		{ -- Boss 框架宽度
			key = "widthboss",
			option_type = "slider",
			text = T.split_words(BOSS,L["宽度"]),
			min = 50,
			max = 500,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Health", "Auras"}, "Altz - Boss")
			end,
			relatedFrames = {
				["oUF_AltzBoss1"] = true,
				["oUF_AltzBoss2"] = true,
				["oUF_AltzBoss3"] = true,
				["oUF_AltzBoss4"] = true,
				["oUF_AltzBoss5"] = true,
			},
		},
		{ -- Arena 框架宽度
			key = "widtharena",
			option_type = "slider",
			text = T.split_words(ARENA,L["宽度"]),
			min = 50,
			max = 500,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Health", "Auras"}, "Altz - Arena")
			end,
			relatedFrames = {
				["oUF_AltzArena1"] = true,
				["oUF_AltzArena2"] = true,
				["oUF_AltzArena3"] = true,
				["oUF_AltzArena4"] = true,
				["oUF_AltzArena5"] = true,
			},
		},
		{ -- 标题:施法条
			option_type = "title",
			text = L["施法条"],
			line = true,
		},
		{ -- 启用施法条
			key = "castbars",
			option_type = "check",
			text = L["启用"],
			apply = function()
				T.EnableUFSettings({"Castbar"})
			end,			
		},		
		{ -- 施法条样式
			key = "cbstyle",
			option_type = "ddmenu",
			text = T.split_words(L["施法条"], L["样式"]),
			option_table = {
				{"independent", L["独立施法条"]},
				{"attachment", L["依附施法条"]},
			},
			apply = function()
				T.ApplyUFSettings({"Castbar"})
			end,
			rely = "castbars",
		},
		{ -- 可打断施法条颜色
			key = "Interruptible_color",
			option_type = "color",
			text = T.split_words(L["可打断"],L["施法条"],L["颜色"]),
			rely = "castbars",
		},
		{ -- 30 不可打断施法条颜色
			key = "notInterruptible_color",
			option_type = "color",
			text = T.split_words(L["不可打断"],L["施法条"],L["颜色"]),
			rely = "castbars",
		},
		{ -- 玩家施法条宽度
			key = "cbwidth",
			option_type = "slider",
			text = T.split_words(PLAYER,L["施法条"],L["宽度"]),
			min = 50,
			max = 500,
			step = 5,
			apply = function()
				T.ApplyUFSettings({"Castbar"}, "Altz - Player")
			end,
			relatedFrames = {
				["AltzUI_playerCastbar"] = true,
			},
		},		
		{ -- 玩家施法条高度
			key = "cbheight",
			option_type = "slider",
			text = T.split_words(PLAYER,L["施法条"],L["高度"]),
			min = 5,
			max = 30,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Castbar"}, "Altz - Player")
			end,
			relatedFrames = {
				["AltzUI_playerCastbar"] = true,
			},
		},
		{ -- 目标施法条宽度
			key = "target_cbwidth",
			option_type = "slider",
			text = T.split_words(TARGET,L["施法条"],L["宽度"]),
			min = 50,
			max = 500,
			step = 5,
			apply = function()
				T.ApplyUFSettings({"Castbar"}, "Altz - Target")
			end,
			relatedFrames = {
				["AltzUI_targetCastbar"] = true,
			},
		},
		{ -- 目标施法条高度
			key = "target_cbheight",
			option_type = "slider",
			text = T.split_words(TARGET,L["施法条"],L["高度"]),
			min = 5,
			max = 30,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Castbar"}, "Altz - Target")
			end,
			relatedFrames = {
				["AltzUI_targetCastbar"] = true,
			},
		},
		{ -- 焦点施法条宽度
			key = "focus_cbwidth",
			option_type = "slider",
			text = T.split_words(L["焦点"],L["施法条"],L["宽度"]),
			min = 50,
			max = 500,
			step = 5,
			apply = function()
				T.ApplyUFSettings({"Castbar"}, "Altz - Focus")
			end,
			relatedFrames = {
				["AltzUI_focusCastbar"] = true,
			},
		},
		{ -- 焦点施法条高度
			key = "focus_cbheight",
			option_type = "slider",
			text = T.split_words(L["焦点"],L["施法条"],L["高度"]),
			min = 5,
			max = 30,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Castbar"}, "Altz - Focus")
			end,
			relatedFrames = {
				["AltzUI_focusCastbar"] = true,
			},
		},
		{ -- 法术名称位置
			key = "namepos",
			option_type = "ddmenu",
			text = T.split_words(SPELLS, NAME, L["位置"]),
			option_table = {
				{"LEFT", 		L["左"]},
				{"TOPLEFT", 	L["左上"]},
				{"RIGHT", 		L["右"]},
				{"TOPRIGHT",	L["右上"]},
			},
			apply = function()
				T.ApplyUFSettings({"Castbar"})
			end,
			relatedFrames = {
				["AltzUI_playerCastbar"] = true,
				["AltzUI_targetCastbar"] = true,
				["AltzUI_focusCastbar"] = true,
			},
		},
		{ -- 施法时间位置
			key = "timepos",
			option_type = "ddmenu",
			text = T.split_words(L["时间"], L["位置"]),
			option_table = {
				{"LEFT", 		L["左"]},
				{"TOPLEFT", 	L["左上"]},
				{"RIGHT", 		L["右"]},
				{"TOPRIGHT",	L["右上"]},
			},
			apply = function()
				T.ApplyUFSettings({"Castbar"})
			end,
			relatedFrames = {
				["AltzUI_playerCastbar"] = true,
				["AltzUI_targetCastbar"] = true,
				["AltzUI_focusCastbar"] = true,
			},
		},
		{ -- 施法条图标尺寸
			key = "cbIconsize",
			option_type = "slider",
			text = T.split_words(L["图标"], L["尺寸"]),
			min = 10,
			max = 50,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Castbar"})
			end,
			relatedFrames = {
				["AltzUI_playerCastbar"] = true,
				["AltzUI_targetCastbar"] = true,
				["AltzUI_focusCastbar"] = true,
			},
		},
		{ -- 40 隐藏玩家施法条图标
			key = "hideplayercastbaricon",
			option_type = "check",
			text = T.split_words(L["隐藏"],PLAYER,L["施法条"],L["图标"]),
			apply = function()
				T.ApplyUFSettings({"Castbar"}, "Altz - Player")
			end,
			relatedFrames = {
				["AltzUI_playerCastbar"] = true,
			},
		},
		{ -- 标题:平砍计时条
			option_type = "title",
			text = L["平砍计时条"],
			line = true,
		},
		{ -- 平砍计时条
			key = "swing",
			option_type = "check",
			text = L["启用"],
			apply = function()
				T.EnableUFSettings({"Swing"}, "Altz - Player")
			end,
		},
		{ -- 平砍计时条宽度
			key = "swwidth",
			option_type = "slider",
			text = L["宽度"],
			min = 50,
			max = 500,
			step = 5,
			apply = function()
				T.ApplyUFSettings({"Swing"}, "Altz - Player")
			end,
			relatedFrames = {
				["AltzUI_SwingTimer"] = true,
			},
		},
		{ -- 平砍计时条高度
			key = "swheight",
			option_type = "slider",
			text = L["高度"],
			min = 5,
			max = 30,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Swing"}, "Altz - Player")
			end,
			relatedFrames = {
				["AltzUI_SwingTimer"] = true,
			},
		},
		{ -- 平砍计时条字体大小
			key = "swtimersize",
			option_type = "slider",
			text = T.split_words(L["字体"],L["大小"]),
			min = 8,
			max = 20,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Swing"}, "Altz - Player")
			end,
			relatedFrames = {
				["AltzUI_SwingTimer"] = true,
			},
		},
		{ -- 标题:光环
			option_type = "title",
			text = AURAS,
			line = true,
		},
		{ -- 光环图标尺寸
			key = "aura_size",
			option_type = "slider",
			text = T.split_words(L["图标"], L["尺寸"]),
			min = 15,
			max = 30,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Auras"})
			end,
			relatedFrames = {
				["AltzUI_SwingTimer"] = true,
			},
		},		
		{ -- 分割线
			option_type = "title",
			line = true,
		},
		{ -- 过滤增益
			key = "AuraFilterignoreBuff",
			option_type = "check",
			text = L["过滤增益"],
			tip = L["过滤增益提示"],
			apply = function()
				T.ApplyUFSettings({"Auras"})
			end,
		},
		{ -- 50 过滤减益
			key = "AuraFilterignoreDebuff",
			option_type = "check",
			text = L["过滤减益"],
			tip = L["过滤减益提示"],
			apply = function()
				T.ApplyUFSettings({"Auras"})
			end,
		},
		{ -- 分割线
			option_type = "title",
			line = true,
		},
		{ -- 玩家减益
			key = "playerdebuffenable",
			option_type = "check",
			text = T.split_words(PLAYER, L["减益"]),
			tip = L["玩家减益提示"],
			apply = function()
				T.EnableUFSettings({"Auras"}, "Altz - Player")
			end,
			relatedFrames = {
				["oUF_AltzPlayer"] = true,
			},
		},
		{ -- PvP标记
			key = "pvpicon",
			option_type = "check",
			text = T.split_words(L["显示"],L["PvP标记"]),
			tip = L["PvP标记提示"],
			apply = function()
				T.EnableUFSettings({"PvPIndicator"}, "Altz - Player")
			end,
			relatedFrames = {
				["oUF_AltzPlayer"] = true,
			},
		},
		{ -- 符文冷却
			key = "runecooldown",
			option_type = "check",
			text = format(L["显示冷却"], RUNES),
			apply = function()
				T.ApplyUFSettings({"Runes"}, "Altz - Player")
			end,
			class = {
				["DEATHKNIGHT"] = true,
			},
			relatedFrames = {
				["oUF_AltzPlayer"] = true,
			},
		},
		{ -- 符文字体大小
			key = "valuefs",
			option_type = "slider",
			text = T.split_words(RUNES, L["字体"], L["大小"]),
			min = 8,
			max = 16,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Runes"}, "Altz - Player")
			end,
			class = {
				["DEATHKNIGHT"] = true,
			},
			relatedFrames = {
				["oUF_AltzPlayer"] = true,
			},
			rely = "runecooldown",
		},
		{ -- DPS MANA
			key = "dpsmana",
			option_type = "check",
			text = T.split_words(L["额外法力条"]),
			tip = L["法力条提示"],
			apply = function()
				T.EnableUFSettings({"Dpsmana"}, "Altz - Player")
				T.ApplyUFSettings({"ClassPower"}, "Altz - Player")
			end,
			class = {
				["SHAMAN"] = true,
				["PRIEST"] = true,
				["DRUID"] = true,
			},
			relatedFrames = {
				["oUF_AltzPlayer"] = true,
			},
		},
		{ -- 醉拳条
			key = "stagger",
			option_type = "check",
			text = T.split_words(L["显示"],L["醉拳条"]),
			apply = function()
				T.EnableUFSettings({"Stagger"}, "Altz - Player")
			end,
			class = {
				["MONK"] = true,
			},
			relatedFrames = {
				["oUF_AltzPlayer"] = true,
			},
		},
		{ -- 标题:样式
			option_type = "title",
			text = L["样式"],
			line = true,
		},
		{ -- 启用团队框架
			key = "enableraid",
			option_type = "check",
			text = L["启用"],
			apply = function()
				StaticPopup_Show(G.uiname.."Reload Alert")
			end,
		},
		{ -- 60 团队样式的小队框体
			key = "raidframe_inparty",
			option_type = "check",
			text = USE_RAID_STYLE_PARTY_FRAMES,
			apply = function()
				StaticPopup_Show(G.uiname.."Reload Alert")
			end,
			rely = "enableraid",
		},
		{ -- 未进组时显示
			key = "showsolo",
			option_type = "check",
			text = L["未进组时显示"],
			apply = function()
				T.UpdateGroupfilter()
			end,
			relatedFrames = {
				["Altz_Raid_Holder"] = true,
			},
			rely = "enableraid",
		},		
		{ -- 分割线
			option_type = "title",
			line = true,
		},
		{ -- 名字样式
			key = "name_style",
			option_type = "ddmenu",
			text = T.split_words(NAME,L["样式"]),
			option_table = {
				{"missing_hp", NAME.."/"..L["缺失生命值"]},
				{"name", NAME},
				{"none", L["隐藏"]},
			},
			apply = function()
				T.UpdateUFTags('Altz_Healerraid')
			end,
			rely = "enableraid",
		},
		{ -- 名字长度
			key = "namewidth",
			option_type = "slider",
			text = T.split_words(NAME,L["长度"],L["比例"]),
			min = .3,
			max = 1,
			step = 0.05,
			apply = function()
				T.ApplyUFSettings({"Tag_Name"}, 'Altz_Healerraid')
			end,
			rely = "enableraid",
		},
		{ -- 名字字体大小
			key = "raidfontsize",
			option_type = "slider",
			text = T.split_words(L["字体"],L["大小"]),
			min = 8,
			max = 20,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Tag_LFD", 'Tag_Name', 'Tag_Status'}, 'Altz_Healerraid')
			end,
			rely = "enableraid",
		},
		{ -- 分割线
			option_type = "title",
			line = true,
		},
		{ -- GCD
			key = "showgcd",
			option_type = "check",
			text = L["GCD"],
			tip = L["GCD提示"],
			apply = function()
				T.EnableUFSettings({"GCD"}, "Altz_Healerraid")
			end,
			rely = "enableraid",
		},
		{ -- 治疗和吸收预估
			key = "healprediction",
			option_type = "check",
			text = L["治疗和吸收预估"],
			tip = L["治疗和吸收预估提示"],
			apply = function()
				T.EnableUFSettings({"HealthPrediction"}, "Altz_Healerraid")
			end,
			rely = "enableraid",
		},
		{ -- 主坦克和主助手
			key = "raidrole_icon",
			option_type = "check",
			text = L["主坦克和主助手"],
			tip = L["主坦克和主助手提示"],
			apply = function()
				T.EnableUFSettings({"RaidRoleIndicator"}, "Altz_Healerraid")
			end,
			rely = "enableraid",
		},
		{ -- 70 分割线
			option_type = "title",
			line = true,
		},
		{ -- 团队工具
			key = "raidtool",
			option_type = "check",
			text = L["团队工具"],
			apply = function()
				T.UpdateRaidTools()
			end,
		},
		{ -- 水平排列小队
			key = "hor_party",
			option_type = "check",
			text = COMPACT_UNIT_FRAME_PROFILE_HORIZONTALGROUPS,
			apply = function()
				T.UpdateGroupAnchor()
				T.UpdateGroupSize()
			end,
			relatedFrames = {
				["Altz_Raid_Holder"] = true,
				["Altz_RaidPet_Holder"] = true,
			},
		},
		{ -- 小队相连
			key = "party_connected",
			option_type = "check",
			text = COMPACT_UNIT_FRAME_PROFILE_KEEPGROUPSTOGETHER,
			apply = function()
				T.UpdateGroupfilter()
			end,
			relatedFrames = {
				["Altz_Raid_Holder"] = true,
			},
		},
		{ -- 显示宠物
			key = "showraidpet",
			option_type = "check",
			text = T.split_words(L["显示"],PET),
			apply = function()
				T.UpdateGroupfilter()
			end,
			relatedFrames = {
				["Altz_Raid_Holder"] = true,
			},
		},
		{ -- 团队规模
			key = "party_num",
			option_type = "slider",
			text = L["团队规模"],
			min = 4,
			max = 8,
			step = 2,
			apply = function()
				T.UpdateGroupSize()
				T.UpdateGroupfilter()
			end,
			relatedFrames = {
				["Altz_Raid_Holder"] = true,
			},
		},
		{ -- 宽度
			key = "raidwidth",
			option_type = "slider",
			text = L["宽度"],
			min = 10,
			max = 150,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Health", "Auras"}, "Altz_Healerraid")
				T.UpdateGroupSize()
			end,
			relatedFrames = {
				["Altz_Raid_Holder"] = true,
				["Altz_RaidPet_Holder"] = true,
			},
		},
		{ -- 高度
			key = "raidheight",
			option_type = "slider",
			text = L["高度"],
			min = 10,
			max = 150,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Health", "Auras"}, "Altz_Healerraid")
				T.UpdateGroupSize()
			end,
			relatedFrames = {
				["Altz_Raid_Holder"] = true,
				["Altz_RaidPet_Holder"] = true,
			},
		},
		{ -- 治疗法力条
			key = "raidmanabars",
			option_type = "check",
			text = L["治疗法力条"],
			apply = function()
				T.UpdateHealManabar()
			end,
			relatedFrames = {
				["Altz_Raid_Holder"] = true,		
			},
		},
		{ -- 治疗法力条高度
			key = "raidppheight",
			option_type = "slider",
			text = L["治疗法力条高度"],
			min = .05,
			max = .5,
			step = .05,
			apply = function()
				T.ApplyUFSettings({"Power"}, "Altz_Healerraid")
			end,
			relatedFrames = {
				["Altz_Raid_Holder"] = true,		
			},
			rely = "raidmanabars",
		},
		{ -- 80 标题:治疗指示器
			option_type = "title",
			text = L["治疗指示器"],
			line = true,
		},
		{ -- 治疗指示器样式
			key = "hotind_style",
			option_type = "ddmenu",
			text = L["样式"],
			option_table = {
				{"number_ind", L["数字指示器"]},
				{"icon_ind", L["图标指示器"]},
			},
			apply = function()
				T.EnableUFSettings({"AltzIndicators"}, "Altz_Healerraid")
				T.ApplyUFSettings({"Auras"}, "Altz_Healerraid")				
			end,
		},
		{ -- 治疗指示器尺寸
			key = "hotind_size",
			option_type = "slider",
			text = L["尺寸"],
			min = 10,
			max = 25,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"AltzIndicators", "Auras"}, "Altz_Healerraid")
			end,
		},
		{ -- 分割线
			option_type = "title",
			line = true,
		},
		{ -- 过滤方式
			key = "hotind_filtertype",
			option_type = "ddmenu",
			text = "",
			option_table = {
				{"whitelist", L["白名单"]..AURAS},
				{"blacklist", L["黑名单"]..AURAS},
			},
			apply = function()
				T.ApplyUFSettings({"Auras"}, "Altz_Healerraid")
			end,
		},
		{ -- 标题:点击施法
			option_type = "title",
			text = L["点击施法"],
			line = true,
		},
		{ -- 点击施法
			key = "enableClickCast",
			option_type = "check",
			text = L["启用"],
			apply = function()
				if T.ValueFromPath(aCoreCDB, {"UnitframeOptions","enableClickCast"}) then
					T.RegisterClicksforAll()
				else
					T.UnregisterClicksforAll()
				end
			end,
		},
		{ -- 标题:减益
			option_type = "title",
			text = L["减益"],
			line = true,
			color = {1, .5, .3},
		},
		{ -- 减益水平偏移
			key = "raid_debuff_anchor_x",
			option_type = "slider",
			text = L["水平偏移"],
			min = -50,
			max = 50,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Debuffs"}, "Altz_Healerraid")
			end,
		},
		{ -- 减益垂直偏移
			key = "raid_debuff_anchor_y",
			option_type = "slider",
			text = L["垂直偏移"],
			min = -50,
			max = 50,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Debuffs"}, "Altz_Healerraid")
			end,
		},
		{ -- 90 图标尺寸
			key = "raid_debuff_icon_size",
			option_type = "slider",
			text = T.split_words(L["图标"], L["尺寸"]),
			min = 10,
			max = 40,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Debuffs"}, "Altz_Healerraid")
			end,
		},
		{ -- 图标数量
			key = "raid_debuff_num",
			option_type = "slider",
			text = T.split_words(L["图标"], L["数量"]),
			min = 1,
			max = 5,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Debuffs"}, "Altz_Healerraid")
			end,
		},
		{ -- 标题:增益
			option_type = "title",
			text = L["增益"],
			line = true,
			color = {.3, 1, .5},
		},
		{ -- 增益水平偏移
			key = "raid_buff_anchor_x",
			option_type = "slider",
			text = L["水平偏移"],
			min = -50,
			max = 50,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Buffs"}, "Altz_Healerraid")
			end,
		},
		{ -- 增益垂直偏移
			key = "raid_buff_anchor_y",
			option_type = "slider",
			text = L["垂直偏移"],
			min = -50,
			max = 50,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Buffs"}, "Altz_Healerraid")
			end,
		},
		{ -- 图标尺寸
			key = "raid_buff_icon_size",
			option_type = "slider",
			text = T.split_words(L["图标"], L["尺寸"]),
			min = 10,
			max = 40,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Buffs"}, "Altz_Healerraid")
			end,
		},
		{ -- 图标数量
			key = "raid_buff_num",
			option_type = "slider",
			text = T.split_words(L["图标"], L["数量"]),
			min = 1,
			max = 5,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Buffs"}, "Altz_Healerraid")
			end,
		},
		{ -- 分割线
			option_type = "title",
			line = true,
		},
		{ -- 自动添加团队减益
			key = "debuff_auto_add",
			option_type = "check",
			text = L["自动添加团队减益"],
			tip = L["自动添加团队减益提示"],	
		},
		{ -- 自动添加的图标层级
			key = "debuff_auto_add_level",
			option_type = "slider",
			text = L["优先级"],
			min = 1,
			max = 20,
			step = 1,
		},
		{ -- 100 标题:副本减益
			option_type = "title",
			text = T.split_words(L["副本"],L["减益"]),
			line = true,
		},
		{ -- 标题:全局减益
			option_type = "title",
			text = T.split_words(L["全局"], L["减益"]),
			line = true,
		},
		{ -- 标题:全局增益
			option_type = "title",
			text = T.split_words(L["全局"], L["增益"]),
			line = true,
		},
	},
	ActionbarOptions = {
		{ -- 1 标题:样式
			option_type = "title",
			text = L["样式"],
			line = true,
		},
		{ -- 2 显示冷却时间
			key = "countdownForCooldowns",
			option_type = "cvar_check",			
			text = T.split_words(L["显示"],L["冷却"],L["时间"]),
			tip = L["显示冷却时间提示"],
			arg1 = "1",
			arg2 = "0",
		},
		{ -- 3 冷却数字大小
			key = "cooldownsize",
			option_type = "slider",
			text = T.split_words(L["冷却"],L["数字"],L["大小"]),
			min = 18,
			max = 35,
			step = 1,
			apply = function()
				T.CooldownNumber_Edit()
			end,
			rely = "countdownForCooldowns",
		},
		{ -- 7 分割线
			option_type = "title",
			line = true,
		},
		{ -- 8 键位字体大小
			key = "keybindsize",
			option_type = "slider",
			text = T.split_words(L["键位"],L["字体"],L["尺寸"]),
			min = 8,
			max = 20,
			step = 1,
			apply = function()
				T.UpdateActionbarsFontSize()
			end,
		},
		{ -- 6 宏字体大小
			key = "macronamesize",
			option_type = "slider",
			text = T.split_words(MACRO,NAME,L["字体"],L["尺寸"]),
			min = 8,
			max = 20,
			step = 1,
			apply = function()
				T.UpdateActionbarsFontSize()
			end,
		},
		{ -- 7 次数字体大小
			key = "countsize",
			option_type = "slider",
			text = T.split_words(L["次数"],L["字体"],L["尺寸"]),
			min = 8,
			max = 20,
			step = 1,
			apply = function()
				T.UpdateActionbarsFontSize()
			end,
		},
		{ -- 8 分割线
			option_type = "title",
			line = true,
		},
		{ -- 9 不可用颜色
			key = "rangecolor",
			option_type = "check",			
			text = L["不可用颜色"],
			tip = L["不可用颜色提示"],
		},
		{ -- 10 条件渐隐
			key = "enablefade",
			option_type = "check",			
			text = L["条件渐隐"],
			tip = L["条件渐隐提示"],
			apply = function()
				T.ApplyActionbarFadeEnable()
			end,		
		},
		{ -- 11 渐隐同步
			key = "fadingalpha_type",
			option_type = "ddmenu",
			text = "",			
			option_table = {
				{"uf", T.split_words(USE, L["单位框架"], L["渐隐透明度"])},
				{"custom", T.split_words(CUSTOM, L["渐隐透明度"])},
			},
			apply = function()
				T.ApplyActionbarFadeAlpha()
			end,
			skip = true,
			rely = "enablefade",
		},
		{ -- 12 渐隐透明度
			key = "fadingalpha",
			option_type = "slider",
			text = L["渐隐透明度"],
			tip = L["渐隐透明度提示"],
			min = 0,
			max = .8,
			step = .05,
			apply = function()
				T.ApplyActionbarFadeAlpha()
			end,
			rely = "enablefade",
		},
		{ -- 13 标题:冷却提示
			option_type = "title",
			text = L["冷却提示"],
			line = true,
		},
		{ -- 14 启用冷却提示
			key = "cdflash_enable",
			option_type = "check",			
			text = L["启用"],
		},
		{ -- 15 冷却提示图标尺寸
			key = "cdflash_size",
			option_type = "slider",
			text = T.split_words(L["图标"], L["尺寸"]),
			min = 15,
			max = 100,
			step = 1,
			apply = function()
				T.UpdateCooldownFlashSize()
			end,
			relatedFrames = {
				["AltzUI_CooldownFlash"] = true,
			},
			rely = "cdflash_enable",
		},
	},
	PlateOptions = {
		{ -- 1 标题:一般设置
			option_type = "title",
			text = T.split_words(L["一般"], L["设置"]),
			line = true,
		},
		{ -- 2 启用姓名板
			key = "enableplate",
			option_type = "check",			
			text = L["启用"],
			apply = function()
				StaticPopup_Show(G.uiname.."Reload Alert")
			end,
		},
		{ -- 3 名字字体大小
			key = "namefontsize",
			option_type = "slider",
			text = T.split_words(NAME,L["字体"],L["大小"]),
			min = 5,
			max = 25,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Tag_Name", "Health", "Power"}, "Altz_Nameplates")
			end,
			rely = "enableplate",
		},
		{ -- 4 图标数量
			key = "plateauranum",
			option_type = "slider",
			text = T.split_words(L["光环"],L["图标"],L["数量"]),
			min = 3,
			max = 10,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Auras"}, "Altz_Nameplates")
			end,
			rely = "enableplate",
		},
		{ -- 5 图标尺寸
			key = "plateaurasize",
			option_type = "slider",
			text = T.split_words(L["光环"],L["图标"],L["尺寸"]),
			min = 10,
			max = 30,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Auras"}, "Altz_Nameplates")
			end,
			rely = "enableplate",
		},
		{ -- 6 分割线
			option_type = "title",
			line = true,
		},
		{ -- 7 可打断施法条颜色
			key = "Interruptible_color",
			option_type = "color",
			text = T.split_words(L["可打断"],L["施法条"],L["颜色"]),
			rely = "enableplate",
		},
		{ -- 8 不可打断施法条颜色
			key = "notInterruptible_color",
			option_type = "color",
			text = T.split_words(L["不可打断"],L["施法条"],L["颜色"]),
			rely = "enableplate",
		},
		{ -- 9 分割线
			option_type = "title",
			line = true,
		},
		{ -- 10 仇恨染色
			key = "threatcolor",
			option_type = "check",			
			text = L["仇恨染色"],
			apply = function()
				T.ApplyUFSettings({"Health"}, "Altz_Nameplates")
			end,
			rely = "enableplate",
		},
		{ -- 11 焦点染色
			key = "focuscolored",
			option_type = "check",			
			text = L["焦点染色"],
			apply = function()
				T.ApplyUFSettings({"Health"}, "Altz_Nameplates")
			end,
			rely = "enableplate",
		},
		{ -- 12 焦点颜色
			key = "focus_color",
			option_type = "color",
			text = T.split_words(L["焦点"],L["颜色"]),
			apply = function()
				T.ApplyUFSettings({"Health"}, "Altz_Nameplates")
			end,
			rely = "focuscolored",
		},
		{ -- 13 分割线
			option_type = "title",
			line = true,
		},
		{ -- 14 显示所有姓名板
			key = "nameplateShowAll",
			option_type = "cvar_check",
			text = UNIT_NAMEPLATES_AUTOMODE,
			arg1 = "1",
			arg2 = "0",
			secure = true,
			rely = "enableplate",
		},
		{ -- 15 友方只显示名字
			key = "bar_onlyname",
			option_type = "check",			
			text = L["友方只显示名字"],
			apply = function()
				T.UpdateUFTags('Altz_Nameplates')
				T.PostUpdateAllPlates()
			end,
			rely = "enableplate",
		},
		{ -- 16 标题:样式
			option_type = "title",
			text = L["样式"],
			line = true,
		},
		{ -- 17 样式
			key = "theme",
			option_type = "ddmenu",
			text = L["样式"],			
			option_table = {
				{"class", L["职业色-条形"]},
				{"dark", L["深色-条形"]},
				{"number", L["数字样式"]},
			},
			apply = function()
				T.ApplyUFSettings({"Health", "Power", "Castbar", "Auras", "ClassPower", "Runes", "Tag_Name"}, "Altz_Nameplates")
				T.PostUpdateAllPlates()				
			end,
		},
		{ -- 18 条形样式的选项 宽度
			key = "bar_width",
			option_type = "slider",
			text = L["宽度"],
			min = 70,
			max = 150,
			step = 5,
			apply = function()
				T.ApplyUFSettings({"Health", "Castbar", "Auras"}, "Altz_Nameplates")
			end,
		},
		{ -- 19 高度
			key = "bar_height",
			option_type = "slider",
			text = L["高度"],
			min = 5,
			max = 25,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Health", "Power", "Castbar"}, "Altz_Nameplates")
			end,
		},
		{ -- 20 数值字体大小
			key = "valuefontsize",
			option_type = "slider",
			text = T.split_words(L["数值"],L["字体"],L["大小"]),
			min = 5,
			max = 25,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Tag_Name", "Health", "Power"}, "Altz_Nameplates")
			end,
		},
		{ -- 21 数值样式
			key = "bar_hp_perc",
			option_type = "ddmenu",
			text = T.split_words(L["数值"],L["样式"]),			
			option_table = {
				{"perc", L["百分比"]},
				{"value_perc", L["数值"].."+"..L["百分比"]},
			},
			apply = function()
				T.ApplyUFSettings({"Health"}, "Altz_Nameplates")
			end,
		},
		{ -- 22 总是显示生命值
			key = "bar_alwayshp",
			option_type = "check",			
			text = T.split_words(L["总是"],L["显示"],L["生命值"]),
			tip = string.format(L["总是显示数值提示"], L["生命值"]),
			apply = function()
				T.ApplyUFSettings({"Health"}, "Altz_Nameplates")
			end,
		},
		{ -- 23 数字样式的选项 字体大小
			key = "number_size",
			option_type = "slider",
			text = T.split_words(L["字体"],L["大小"]),
			min = 15,
			max = 35,
			step = 1,
			apply = function()
				T.ApplyUFSettings({"Health", "Power", "ClassPower"}, "Altz_Nameplates")
			end,
		},
		{ -- 24 总是显示生命值
			key = "number_alwayshp",
			option_type = "check",			
			text = T.split_words(L["总是"],L["显示"],L["生命值"]),
			tip = string.format(L["总是显示数值提示"], L["生命值"]),
			apply = function()
				T.ApplyUFSettings({"Health"}, "Altz_Nameplates")
			end,
		},
		{ -- 25 总是显示生命值
			key = "number_colorheperc",
			option_type = "check",			
			text = L["根据血量变色"],
			apply = function()
				T.ApplyUFSettings({"Health"}, "Altz_Nameplates")
			end,
		},
		{ -- 26 标题:玩家姓名板
			option_type = "title",
			text = L["玩家姓名板"],
			line = true,
		},
		{ -- 27 启用
			key = "playerplate",
			option_type = "check",			
			text = T.split_words(L["显示"],L["玩家姓名板"]),
			apply = function()
				if aCoreCDB["PlateOptions"]["playerplate"] then
					SetCVar("nameplateShowSelf", 1)
				else
					SetCVar("nameplateShowSelf", 0)
				end
				T.PostUpdateAllPlates()
			end,
		},
		{ -- 28 施法条
			key = "platecastbar",
			option_type = "check",			
			text = T.split_words(L["显示"],PLAYER,L["施法条"]),
			apply = function()
				T.PostUpdateAllPlates()
			end,
			rely = "playerplate",
		},
		{ -- 29 个人资源
			key = "classresource_show",
			option_type = "check",			
			text = DISPLAY_PERSONAL_RESOURCE,
			apply = function()
				T.PostUpdateAllPlates()
			end,
			rely = "playerplate",
		},
		{ -- 30 标题:光环
			option_type = "title",
			text = L["光环"],
			line = true,
		},
		{ -- 31 过滤方式
			key = "myfiltertype",
			option_type = "ddmenu",
			text = "",			
			option_table = {
				{"none", L["全部隐藏"]},
				{"whitelist", L["白名单"]..AURAS},
				{"blacklist", L["黑名单"]..AURAS},
			},
			apply = function()
				T.ApplyUFSettings({"Auras"}, "Altz_Nameplates")
			end,
		},
		{ -- 32 过滤方式
			key = "otherfiltertype",
			option_type = "ddmenu",
			text = "",			
			option_table = {
				{"none", L["全部隐藏"]},
				{"whitelist", L["白名单"]..AURAS},
			},
			apply = function()
				T.ApplyUFSettings({"Auras"}, "Altz_Nameplates")
			end,
		},
		{ -- 33 标题:自定义
			option_type = "title",
			text = CUSTOM,
			line = true,
		},
	},
	CombattextOptions = {
		{ -- 1 标题:滚动战斗数字
			option_type = "title",
			text = L["滚动战斗数字"],
			line = true,
		},
		{ -- 2 承受伤害/治疗
			key = "showreceivedct",
			option_type = "check",
			text = L["承受伤害/治疗"],	
			apply = function()
				T.ToggleCTVisibility()
			end,
		},
		{ -- 3 输出伤害/治疗
			key = "showoutputct",
			option_type = "check",
			text = L["输出伤害/治疗"],	
			apply = function()
				T.ToggleCTVisibility()
			end,
		},
		{ -- 4 DOT
			key = "ctshowdots",
			option_type = "check",
			text = T.split_words(L["显示"], "DOT"),	
			relatedFrames = {
				["CombatTextoutputdamage"] = true,
			},
		},
		{ -- 5 HOT
			key = "ctshowhots",
			option_type = "check",
			text = T.split_words(L["显示"], "HOT"),	
			relatedFrames = {
				["CombatTextoutputhealing"] = true,
			},
		},
		{ -- 6 宠物
			key = "ctshowpet",
			option_type = "check",
			text = T.split_words(L["显示"], PET),	
			relatedFrames = {	
				["CombatTextoutputdamage"] = true,
				["CombatTextoutputhealing"] = true,
			},
		},
		{ -- 7 标题:浮动战斗数字
			option_type = "title",
			text = L["浮动战斗数字"],
			line = true,
		},
		{ -- 8 承受伤害
			key = "floatingCombatTextCombatDamage",
			option_type = "cvar_check",
			text = T.split_words(L["显示"], L["承受伤害"], L["战斗数字"]),
			arg1 = "1",
			arg2 = "0",
		},
		{ -- 9 承受治疗
			key = "floatingCombatTextCombatHealing",
			option_type = "cvar_check",
			text = T.split_words(L["显示"], L["承受治疗"], L["战斗数字"]),
			arg1 = "1",
			arg2 = "0",
		},
		{ -- 10 输出伤害/治疗
			key = "enableFloatingCombatText",
			option_type = "cvar_check",
			text = T.split_words(L["显示"], L["输出伤害/治疗"], L["战斗数字"]),
			arg1 = "1",
			arg2 = "0",
		},
		{ -- 11 战斗字体
			key = "combattext_font",
			option_type = "ddmenu",
			text = L["字体"],			
			option_table = {
				{"none", DEFAULT, "GameFontHighlight"},
				{"combat1", "1234", "Altz_CombatFont_1"},
				{"combat2", "1234", "Altz_CombatFont_2"},
				{"combat3", "1234", "Altz_CombatFont_3"},
			},
			apply = function()
				if not combattext_font_alert then
					StaticPopup_Show("CLIENT_RESTART_ALERT")
					combattext_font_alert = true
				end
			end,
		},
	},
	OtherOptions = {
		{ -- 1 标题:鼠标提示
			option_type = "title",
			text = L["鼠标提示"],
			line = true,
		},
		{ -- 2 法术编号
			key = "show_spellID",
			option_type = "check",
			width = .4,
			text = T.split_words(L["鼠标提示"],L["显示"],L["法术编号"]),	
		},
		{ -- 3 物品编号
			key = "show_itemID",
			option_type = "check",
			width = .6,
			text = T.split_words(L["鼠标提示"],L["显示"],L["物品编号"]),	
		},
		{ -- 4 战斗中隐藏
			key = "combat_hide",
			option_type = "check",
			width = .4,
			text = T.split_words(L["战斗中隐藏"],L["鼠标提示"]),	
		},
		{ -- 5 标题:讯息提示
			option_type = "title",
			text = L["讯息提示"],
			line = true,
		},
		{ -- 6 任务栏闪动
			key = "flashtaskbar",
			option_type = "check",
			width = .4,
			text = L["任务栏闪动"],	
			tip = L["任务栏闪动提示"],
		},
		{ -- 7 隐藏错误提示
			key = "hideerrors",
			option_type = "check",
			width = .6,
			text = L["隐藏错误提示"],	
			tip = L["隐藏错误提示提示"],
			apply = function()
				T.EnableErrorMsg()
			end,
		},
		{ -- 8 随机奖励
			key = "LFGRewards",
			option_type = "check",
			width = .4,
			text = L["随机奖励"],	
			tip = L["随机奖励提示"],
		},
		{ -- 9 稀有警报
			key = "vignettealert",
			option_type = "check",
			width = .6,
			text = L["稀有警报"],	
			tip = L["稀有警报提示"],
		},
		{ -- 10 标题:辅助功能
			option_type = "title",
			text = L["辅助功能"],
			line = true,
		},
		{ -- 11 成就截图
			key = "autoscreenshot",
			option_type = "check",
			width = .4,
			text = L["成就截图"],	
			tip = L["成就截图提示"],
		},
		{ -- 12 提升截图画质
			key = "screenshotQuality",
			option_type = "cvar_check",
			width = .6,
			text = L["提升截图画质"],
			arg1 = "10",
			arg2 = "1",
		},
		{ -- 13 战场自动释放灵魂
			key = "battlegroundres",
			option_type = "check",
			width = .4,
			text = L["战场自动释放灵魂"],	
			tip = L["战场自动释放灵魂提示"],
		},
		{ -- 14 自动接受复活
			key = "acceptres",
			option_type = "check",
			width = .6,
			text = L["自动接受复活"],	
			tip = L["自动接受复活提示"],
		},
		{ -- 15 自动召宝宝
			key = "autopet",
			option_type = "check",
			width = .4,
			text = L["自动召宝宝"],	
			tip = L["自动召宝宝提示"],
		},
		{ -- 16 优先偏爱宝宝
			key = "autopet_favorite",
			option_type = "check",
			width = .6,
			text = L["自动召宝宝"],	
			tip = L["优先偏爱宝宝提示"],
			rely = "autopet",
		},
		{ -- 17 反和谐
			key = "overrideArchive",
			option_type = "cvar_check",
			width = .4,
			arg1 = "0",
			arg2 = "1",
			text = "反和谐",
			apply = function()
				if not overrideArchive then
					StaticPopup_Show("CLIENT_RESTART_ALERT")
					overrideArchive = true
				end
			end,
			client = {
				["zhCN"] = true,
			},
		},
	},
	SetupOptions = {
		{
			key = "useUiScale",
			option_type = "cvar_check",
			text = USE_UISCALE,
			arg1 = "1",
			arg2 = "0",
			secure = true,
		},
	},
}

function T.GetOptionInfo(path)
	local OptionCategroy = path[1]
	local key = path[2]
	for _, info in pairs(G.Options[OptionCategroy]) do
		if info.key == key then
			return info
		end
	end
end

