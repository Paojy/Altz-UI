local T, C, L, G = unpack(select(2, ...))

G.BuffWhiteList = {
	--druid
	-- OLD
	[61336] = true, -- 求生本能
	[29166] = false, -- 激活
	[22812] = true, -- 樹皮術
	--[132158] = "naturesSwiftness", -- 自然迅捷
	--[16689] = "naturesGrasp", -- 自然之握
	[22842] = true, -- 狂暴恢復
	--[5229] = "enrage", -- 狂怒
	[1850] = true, -- 疾奔
	[50334] = true, -- 狂暴
	--[69369] = "predatorSwiftness", -- PredatorSwiftness 猛獸迅捷
	--[102280] = "displacerBeast", 
	--Mist of Pandaria
	--[124974] = true,
	--[112071] = "celestialAlignment",
	--[102342] = true,--树皮
	--[110575] = "sIcebound",
	--[110570] = "sAntiMagicShell", 
	--[110617] = "sDeterrance", 
	--[110696] = "sIceBlock", 
	--[110700] = "sDivineShield", 
	--[110717] = "sFearWard", 
	--[110806] = "sSpiritWalkersGrace", 
	--[122291] = "sUnendingResolve", 
	--[110715] = "sDispersion", 
	--[110788] = "sCloakOfShadows", 
	--[126456] = "sFortifyingBrew", 
	--[126453] = "sElusiveBrew", 
	--paladin
	-- OLD
	[31821] = true, -- 光環精通
	[1022] = true, -- 保護
	[1044] = true, -- 自由
	[642] = true, -- 無敵
	[6940] = true, -- 犧牲祝福
	--[54428] = "divinePlea", -- 神性祈求
	--[85696] = "zealotry", -- 狂熱精神 rimosso/removed
	[31884] = true,--翅膀
	-- Mist of pandaria
	--[114163] = "eternalFlame",
	--[20925] ="sacredShield",
	[114039] = true, --纯净之手
	[105809] = true,--狂热
	[114917] = true, --
	[113075] = true,
	[85499]= true,--加速
	--rogue
	-- OLD
	[51713] = true, -- 暗影之舞
	[2983] = true, -- 疾跑
	[31224] = true, -- 斗篷
	[13750] = true, -- 衝動
	[5277] = true, -- 閃避
	[74001] = true, -- 戰鬥就緒
	--[121471] = "shadowBlades",
	-- Mist of pandaria
	--[114018] = "shroudOfConcealment",
	--warrior
	-- OLD
	[55694] = true, -- 狂怒恢復
	[871] = true, --盾墻
	[18499] = true, -- 狂暴之怒
	-- [20230] = "retaliation", -- 反擊風暴 rimosso/removed
	[23920] = true, -- 盾反
	--[12328] = "sweepingStrikes", -- 橫掃攻擊
	--[46924] = "bladestorm", -- 劍刃風暴
	[85730] = true, -- 沉著殺機
	[1719] = true, -- 魯莽
	-- Mist of pandaria
	[114028] = true, --群体反射
	[114029] = "safeguard",
	[114030] = "vigilance",
	[107574] = true,--天神下凡
	[12292] = true, -- old death wish
	--[112048] = "shieldBarrier",
	--preist
	-- OLD
	[33206] = true, -- 痛苦壓制
	[37274] = true, -- 能量灌注
	[6346] = true, -- 反恐
	[47585] = true, -- 消散
	[89485] = true, -- 心靈專注
	--[87153] = "darkArchangel", rimosso/reomved
	[81700] = "archangel",
	[47788] = true,--翅膀
	-- Mist of pandaria
	--[112833] = "spectralGuise",
	[10060] = true,--能量灌注
	--[109964] = "spiritShell",
	--[81209] = "chakraChastise",
	--[81206] = "chakraSanctuary",
	--[81208] = "chakraSerenity",
	--shaman
	-- OLD
	--[52127] = "waterShield", -- 水盾
	[30823] = true, -- 薩滿之怒
	[974] = true, -- 大地之盾
	[16188] = true, -- 自然迅捷
	[79206] = true, --移动施法
	[16166] = true, --元素掌握
	[8178] = true,--根基
	-- Mist of pandaria
	[114050] = true,
	[114051] = true,
	[114052] = true,
	--mage
	-- OLD
	[45438] = true, -- 寒冰屏障
	[12042] = true, -- 奥强
	[12472] = true, --冰脈
	-- Mist of pandaria
	[12043] = true,--气定
	[108839] = true,
	[110909] = true,--时间操控
	--dk
	-- OLD
	[49039] = true, -- 巫妖之軀
	[48792] = true, -- 冰固
	[55233] = true, -- 血族之裔
	[49016] = true, -- 邪惡狂熱
	[51271] = true, --冰霜之
	[48707] = true,
	-- Mist of pandaria
	[115989] = true,
	[113072] = true,
	--hunter
	-- OLD
	[34471] = true, -- 獸心
	[19263] = true, -- 威懾
	[3045] = true,
	[54216] = true,--主人召唤
	-- Mist of pandaria
	[113073] = true, 
	--lock
	-- Mist of pandaria
	[108416] = true,
	[108503] = true,
	[119049] = true,
	[113858] = true,
	[113861] = true,
	[113860] = true,
	[104773] = true,
	--monk
	-- Mist of pandaria
	[122278] = true,
	[122783] = true,
	[120954] = true,
	[115176] = true,
	[115213] = true,
	[116849] = true,
	[113306] = true,
	--[115294] = "manaTea",
	[108359] = true,
}

G.DebuffWhiteList = {
	[78675] = true, -- 太陽光束
	[108194] = true,-- 窒息
	[47481] =true, -- 啃（食尸鬼）
	[91797] =true, -- 怪物重击（超级食尸鬼）
	[47476] =true, -- 绞杀
	[126458] =true, -- 共生：格斗武器
	[5211] =true, -- 强力重击
	[33786] =true, -- 旋风
	[81261] =true, -- 太阳光束
	[19386] =true, -- 翼龙钉刺
	[34490] =true, -- 沉默射击
	[5116] =true, -- 震荡射击
	[61394] =true, -- 冰冻陷阱雕文
	[4167] =true, -- 网络（蜘蛛）
	[44572] =true, -- 深度冻结
	[55021] =true, -- 沉默 - 强化法术反制
	[31661] =true, -- 龙之吐息
	[118] =true, -- 变形
	[82691] =true, -- 霜之环
	[105421] =true, -- 盲目之光
	[115752] =true, -- 雕文盲目之光（电）
	[105593] =true, -- 正义之拳
	[853] =true, -- 制裁之锤
	[20066] =true, -- 忏悔
	[605] =true, -- 主宰心灵
	[64044] =true, -- 心理恐怖片
	[8122] =true, -- 心灵尖啸
	[9484] =true, -- 束缚亡灵
	[87204] =true, -- 罪与罚
	[15487] =true, -- 沉默
	[2094] =true, -- 盲
	[64058] =true, -- 心灵恐慌
	[76577] =true, --烟雾弹
	[6770] =true, -- SAP
	[1330] =true, -- 绞喉 - 沉默
	[51722] =true, -- 拆除
	[118905] =true, -- 静电
	[5782] =true, -- 恐惧
	[5484] =true, -- 恐惧嚎叫
	[6358] =true, -- 诱惑（魅魔）
	[30283] =true, -- 暗影之怒
	[24259] =true, --法术封锁（地狱犬）
	[31117] =true, -- 痛苦无常
	[5246] =true, -- 破胆怒吼
	[46968] =true, --冲击波
	[18498] =true, -- 沉默 - GAG订单
	[676] =true, -- 解除
	[20549] =true, -- 战争践踏
	[25046] =true, -- 奥术洪流
}

G.DebuffBlackList = {
	[15407] = true, -- 精神鞭笞
}