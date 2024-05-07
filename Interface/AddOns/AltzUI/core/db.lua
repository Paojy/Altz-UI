local T, C, L, G = unpack(select(2, ...))

-- 点击施法
local default_ClassClick = {
	PRIEST = { 
		[256] = { -- 戒律
			["1"] = {
				["Click"] = {action = "target"},
				["shift-"] = {action = "spell", spell = 10060}, -- 能量灌注				
				["ctrl-"] = {action = "spell", spell = 33206}, -- 痛苦压制			
				["alt-"] = {action = "spell", spell = 47540}, -- 苦修
			},                      
			["2"] = {               
				["Click"] = {action = "spell", spell = 17}, -- 真言术：盾
				["ctrl-"] = {action = "spell", spell = 139}, -- 恢复
			},          
			["6"] = {               
				["Click"] = {action = "spell", spell = 2061}, -- 快速治疗
			},
			["9"] = {               
				["Click"] = {action = "spell", spell = 1706}, -- 漂浮术
			},
			["10"] = {
				["Click"] = {action = "spell", spell = 194509}, -- 真言术：耀
			},
			["12"] = {
				["Click"] = {action = "spell", spell = 527}, -- 纯净术（驱散）				
			},
			["13"] = {
				["Click"] = {action = "spell", spell = 73325}, -- 信仰飞跃			
			},
		},
		[257] = { -- 神圣
			["1"] = {
				["Click"] = {action = "target"},
				["shift-"] = {action = "spell", spell = 10060}, -- 能量灌注				
				["ctrl-"] = {action = "spell", spell = 47788}, -- 守护之魂
				["alt-"] = {action = "spell", spell = 33076}, -- 愈合祷言
			},
			["2"] = {               
				["Click"] = {action = "spell", spell = 17}, -- 真言术：盾
				["ctrl-"] = {action = "spell", spell = 139}, -- 恢复
			},
			["6"] = {               
				["Click"] = {action = "spell", spell = 2061}, -- 快速治疗
			},
			["9"] = {               
				["Click"] = {action = "spell", spell = 1706}, -- 漂浮术
			},
			["10"] = {
				["Click"] = {action = "spell", spell = 596}, -- 治疗祷言
			},
			["12"] = {
				["Click"] = {action = "spell", spell = 527}, -- 纯净术（驱散）				
			},
			["13"] = {
				["Click"] = {action = "spell", spell = 73325}, -- 信仰飞跃			
			},
		},
		[258] = { -- 暗影
			["1"] = {
				["Click"] = {action = "target"},
			},
			
		},
		["nospec"] = {
			["1"] = {
				["Click"] = {action = "target"},
			},
		},
	},
	DRUID = { 
		[102] = { -- 平衡
			["1"] = {
				["Click"] = {action = "target"},
			},
			["2"] = {
				["Click"] = {action = "spell", spell = 774}, -- 回春
				["ctrl-"] = {action = "spell", spell = 20484}, -- 复生
				["alt-"] = {action = "spell", spell = 29166}, -- 激活
			},
			["6"] = {
				["Click"] = {action = "spell", spell = 18562}, -- 迅捷治愈
			},
			["9"] = {
				["Click"] = {action = "spell", spell = 48438}, -- 野性成长
			},
			["10"] = {
				["Click"] = {action = "spell", spell = 8936}, -- 愈合
			},
			["12"] = {
				["Click"] = {action = "spell", spell = 2782}, -- 清除腐蚀（驱散）
			},
		},
		[103] = { -- 野性
			["1"] = {
				["Click"] = {action = "target"},
			},
			["2"] = {
				["Click"] = {action = "spell", spell = 774}, -- 回春
				["ctrl-"] = {action = "spell", spell = 20484}, -- 复生
				["alt-"] = {action = "spell", spell = 29166}, -- 激活
			},
			["6"] = {
				["Click"] = {action = "spell", spell = 18562}, -- 迅捷治愈
			},
			["9"] = {
				["Click"] = {action = "spell", spell = 48438}, -- 野性成长
			},
			["10"] = {
				["Click"] = {action = "spell", spell = 8936}, -- 愈合
			},
			["12"] = {
				["Click"] = {action = "spell", spell = 2782}, -- 清除腐蚀（驱散）
			},
		},
		[104] = { -- 守护
			["1"] = {
				["Click"] = {action = "target"},
			},
			["2"] = {
				["Click"] = {action = "spell", spell = 774}, -- 回春
				["ctrl-"] = {action = "spell", spell = 20484}, -- 复生
				["alt-"] = {action = "spell", spell = 29166}, -- 激活
			},
			["6"] = {
				["Click"] = {action = "spell", spell = 18562}, -- 迅捷治愈
			},
			["9"] = {
				["Click"] = {action = "spell", spell = 48438}, -- 野性成长
			},
			["10"] = {
				["Click"] = {action = "spell", spell = 8936}, -- 愈合
			},
			["12"] = {
				["Click"] = {action = "spell", spell = 2782}, -- 清除腐蚀（驱散）
			},
		},
		[105] = { -- 恢复
			["1"] = {
				["Click"] = {action = "target"},
				["ctrl-"] = {action = "spell", spell = 102342}, -- 铁木树皮
			},
			["2"] = {
				["Click"] = {action = "spell", spell = 774}, -- 回春
				["ctrl-"] = {action = "spell", spell = 20484}, -- 复生
				["alt-"] = {action = "spell", spell = 102351}, -- 塞纳里奥结界
			},
			["6"] = {
				["Click"] = {action = "spell", spell = 18562}, -- 迅捷治愈
			},
			["8"] = {
				["Click"] = {action = "spell", spell = 33763}, -- 生命绽放
			},
			["9"] = {
				["Click"] = {action = "spell", spell = 48438}, -- 野性成长
			},
			["10"] = {
				["Click"] = {action = "spell", spell = 8936}, -- 愈合
			},
			["12"] = {
				["Click"] = {action = "spell", spell = 88423}, -- 自然之愈（驱散）
			},
		},
		["nospec"] = {
			["1"] = {
				["Click"] = {action = "target"},
			},
		},
	},
	SHAMAN = {
		[262] = { -- 元素
			["1"] = {
				["Click"] = {action = "target"},
				["ctrl-"] = {action = "spell", spell = 974}, -- 大地之盾
			},
			["2"] = {
				["ctrl-"] = {action = "spell", spell = 546}, -- 水上行走
			},
			["6"] = {
				["Click"] = {action = "spell", spell = 8004}, -- 治疗之涌
			},
			["10"] = {
				["Click"] = {action = "spell", spell = 1064}, -- 治疗链
			},
			["12"] = {
				["Click"] = {action = "spell", spell = 51886}, -- 净化灵魂（驱散）
			},
		},
		[263] = { -- 增强
			["1"] = {
				["Click"] = {action = "target"},
				["ctrl-"] = {action = "spell", spell = 974}, -- 大地之盾
			},
			["2"] = {
				["ctrl-"] = {action = "spell", spell = 546}, -- 水上行走
			},
			["6"] = {
				["Click"] = {action = "spell", spell = 8004}, -- 治疗之涌
			},
			["10"] = {
				["Click"] = {action = "spell", spell = 1064}, -- 治疗链
			},
			["12"] = {
				["Click"] = {action = "spell", spell = 51886}, -- 净化灵魂（驱散）
			},
		},
		[264] = { -- 恢复
			["1"] = {
				["Click"] = {action = "target"},
				["ctrl-"] = {action = "spell", spell = 974}, -- 大地之盾
			},
			["2"] = {
				["Click"] = {action = "spell", spell = 61295}, -- 激流
				["ctrl-"] = {action = "spell", spell = 546}, -- 水上行走
			},
			["6"] = {
				["Click"] = {action = "spell", spell = 8004}, -- 治疗之涌
			},
			["10"] = {
				["Click"] = {action = "spell", spell = 1064}, -- 治疗链
			},
			["12"] = {
				["Click"] = {action = "spell", spell = 77130}, -- 净化灵魂（驱散）
			},
		},
		["nospec"] = {
			["1"] = {
				["Click"] = {action = "target"},
			},
		},
	},
	PALADIN = { 
		[65] = { -- 神圣
			["1"] = {
				["Click"] = {action = "target"},
				["ctrl-"] = {action = "spell", spell = 6940}, -- 牺牲祝福			
			},
			["2"] = {
				["Click"] = {action = "spell", spell = 20473}, -- 神圣震击
				["ctrl-"] = {action = "spell", spell = 633}, -- 圣疗术
				["alt-"] = {action = "spell", spell = 1022}, -- 保护祝福	
			},
			["6"] = {
				["Click"] = {action = "spell", spell = 19750}, -- 圣光闪现
			},
			["7"] = {
				["Click"] = {action = "spell", spell = 115450}, -- 自由祝福	
			},
			["8"] = {
				["Click"] = {action = "spell", spell = 85673}, -- 荣耀圣令	
			},
			["9"] = {
				["Click"] = {action = "spell", spell = 82326}, -- 圣光术	
			},
			["11"] = {
				["Click"] = {action = "spell", spell = 156910}, -- 信仰道标
			},
			["12"] = {
				["Click"] = {action = "spell", spell = 4987}, -- 清洁术（驱散）
			},
			["13"] = {
				["Click"] = {action = "spell", spell = 53563}, -- 圣光道标
			},
		},
		[66] = { -- 保护
			["1"] = {
				["Click"] = {action = "target"},
				["ctrl-"] = {action = "spell", spell = 6940}, -- 牺牲祝福			
			},
			["2"] = {
				["ctrl-"] = {action = "spell", spell = 633}, -- 圣疗术
				["alt-"] = {action = "spell", spell = 1022}, -- 保护祝福	
			},
			["6"] = {
				["Click"] = {action = "spell", spell = 19750}, -- 圣光闪现
			},
			["7"] = {
				["Click"] = {action = "spell", spell = 115450}, -- 自由祝福	
			},
			["8"] = {
				["Click"] = {action = "spell", spell = 85673}, -- 荣耀圣令	
			},
			["12"] = {
				["Click"] = {action = "spell", spell = 213644}, -- 清毒术（驱散）
			},
		},
		[70] = { -- 惩戒
			["1"] = {
				["Click"] = {action = "target"},
				["ctrl-"] = {action = "spell", spell = 6940}, -- 牺牲祝福			
			},
			["2"] = {
				["ctrl-"] = {action = "spell", spell = 633}, -- 圣疗术
				["alt-"] = {action = "spell", spell = 1022}, -- 保护祝福	
			},
			["6"] = {
				["Click"] = {action = "spell", spell = 19750}, -- 圣光闪现
			},
			["7"] = {
				["Click"] = {action = "spell", spell = 115450}, -- 自由祝福	
			},
			["8"] = {
				["Click"] = {action = "spell", spell = 85673}, -- 荣耀圣令	
			},
			["12"] = {
				["Click"] = {action = "spell", spell = 213644}, -- 清毒术（驱散）
			},
		},
		["nospec"] = {
			["1"] = {
				["Click"] = {action = "target"},
			},
		},
	},
	WARRIOR = { 
		[71] = { -- 武器
			["1"] = {
				["Click"] = {action = "target"},
			},
		},
		[72] = { -- 狂暴
			["1"] = {
				["Click"] = {action = "target"},
			},
		},
		[73] = { -- 防护
			["1"] = {
				["Click"] = {action = "target"},
			},
			["2"] = {
				["Click"] = {action = "spell", spell = 3411}, -- 援护
			},
		},
		["nospec"] = {
			["1"] = {
				["Click"] = {action = "target"},
			},
		},
	},
	MAGE = { 
		[62] = { -- 奥术
			["1"] = {
				["Click"] = {action = "target"},
			},		
		},
		[63] = { -- 火焰
			["1"] = {
				["Click"] = {action = "target"},
			},
		},
		[64] = { -- 冰霜
			["1"] = {
				["Click"] = {action = "target"},
			},
		},
		["nospec"] = {
			["1"] = {
				["Click"] = {action = "target"},
			},
		},
	},
	WARLOCK = { 
		[265] = { -- 痛苦
			["1"] = {
				["Click"] = {action = "target"},
			},
			["2"] = {		
				["Click"] = {action = "spell", spell = 20707}, -- 灵魂石
			},
		},
		[266] = { -- 恶魔
			["1"] = {
				["Click"] = {action = "target"},
			},
			["2"] = {		
				["Click"] = {action = "spell", spell = 20707}, -- 灵魂石
			},
		},
		[267] = { -- 毁灭
			["1"] = {
				["Click"] = {action = "target"},
			},
			["2"] = {		
				["Click"] = {action = "spell", spell = 20707}, -- 灵魂石
			},
		},
		["nospec"] = {
			["1"] = {
				["Click"] = {action = "target"},
			},
		},
	},
	HUNTER = { 
		[253] = { -- 野兽
			["1"] = {
				["Click"] = {action = "target"},
			},
			["2"] = {
				["Click"] = {action = "spell", spell = 34477}, -- 误导
			},
		},
		[254] = { -- 射击
			["1"] = {
				["Click"] = {action = "target"},
			},
			["2"] = {
				["Click"] = {action = "spell", spell = 34477}, -- 误导
			},
		},
		[255] = { -- 生存
			["1"] = {
				["Click"] = {action = "target"},
			},
			["2"] = {
				["Click"] = {action = "spell", spell = 34477}, -- 误导
			},
		},
		["nospec"] = {
			["1"] = {
				["Click"] = {action = "target"},
			},
		},
	},
	ROGUE = { 
		[259] = { -- 刺杀
			["1"] = {
				["Click"] = {action = "target"},
			},
			["2"] = {
				["Click"] = {action = "spell", spell = 57934}, -- 嫁祸诀窍
			},
		},
		[260] = { -- 狂徒
			["1"] = {
				["Click"] = {action = "target"},
			},
			["2"] = {
				["Click"] = {action = "spell", spell = 57934}, -- 嫁祸诀窍
			},
		},
		[261] = { -- 敏锐
			["1"] = {
				["Click"] = {action = "target"},
			},
			["2"] = {
				["Click"] = {action = "spell", spell = 57934}, -- 嫁祸诀窍
			},
		},
		["nospec"] = {
			["1"] = {
				["Click"] = {action = "target"},
			},
		},
	},
	DEATHKNIGHT = {
		[250] = { -- 鲜血
			["1"] = {
				["Click"] = {action = "target"},
			},
			["2"] = {
				["Click"] = {action = "spell", spell = 61999}, -- 复活盟友
			},
		},
		[251] = { -- 冰霜
			["1"] = {
				["Click"] = {action = "target"},
			},
			["2"] = {
				["Click"] = {action = "spell", spell = 61999}, -- 复活盟友
			},
		},
		[252] = { -- 邪恶
			["1"] = {
				["Click"] = {action = "target"},
			},
			["2"] = {
				["Click"] = {action = "spell", spell = 61999}, -- 复活盟友
			},
		},
		["nospec"] = {
			["1"] = {
				["Click"] = {action = "target"},
			},
		},
	},
	MONK = {
		[268] = { -- 酿酒
			["1"] = {
				["Click"] = {action = "target"},
			},
			["6"] = {
				["Click"] = {action = "spell", spell = 116670}, -- 活血术
			},
			["9"] = {
				["Click"] = {action = "spell", spell = 115175}, -- 抚慰之雾
			},
			["12"] = {
				["Click"] = {action = "spell", spell = 218164}, -- 清创生血（驱散）
			},
		},
		[270] = { -- 织雾
			["1"] = {
				["Click"] = {action = "target"},
				["ctrl-"] = {action = "spell", spell = 116849}, -- 作茧缚命				
			},
			["2"] = {
				["Click"] = {action = "spell", spell = 119611}, -- 复苏之雾
				["ctrl-"] = {action = "spell", spell = 124081}, -- 禅意波
			},
			["6"] = {
				["Click"] = {action = "spell", spell = 116670}, -- 活血术
			},
			["9"] = {
				["Click"] = {action = "spell", spell = 115175}, -- 抚慰之雾			
			},
			["12"] = {
				["Click"] = {action = "spell", spell = 115450}, -- 清创生血（驱散）
			},
			["13"] = {
				["Click"] = {action = "spell", spell = 124682}, -- 氤氲之雾
			},			
		},
		[269] = { -- 踏风
			["1"] = {
				["Click"] = {action = "target"},
			},
			["6"] = {
				["Click"] = {action = "spell", spell = 116670}, -- 活血术
			},
			["9"] = {
				["Click"] = {action = "spell", spell = 115175}, -- 抚慰之雾
			},
			["12"] = {
				["Click"] = {action = "spell", spell = 218164}, -- 清创生血（驱散）
			},
		},
		["nospec"] = {
			["1"] = {
				["Click"] = {action = "target"},
			},
		},		
	},
	DEMONHUNTER = {
		[577] = { -- 浩劫
			["1"] = {
				["Click"] = {action = "target"},
			},
		},
		[581] = { -- 复仇
			["1"] = {
				["Click"] = {action = "target"},
			},
		},
		["nospec"] = {
			["1"] = {
				["Click"] = {action = "target"},
			},
		},
	},
	EVOKER = {
		[1467] = { -- 湮灭
			["1"] = {
				["Click"] = {action = "target"},
			},
			["2"] = {
				["Click"] = {action = "spell", spell = 361469}, -- 活化烈焰
			},
			["6"] = {
				["Click"] = {action = "spell", spell = 355913}, -- 翡翠之花
			},
			["12"] = {
				["Click"] = {action = "spell", spell = 365585}, -- 净除
			},
			["13"] = {
				["Click"] = {action = "spell", spell = 370665}, -- 营救
			},
		},
		[1468] = { -- 恩护
			["1"] = {
				["Click"] = {action = "target"},
			},
			["2"] = {
				["Click"] = {action = "spell", spell = 361469}, -- 活化烈焰
			},
			["6"] = {
				["Click"] = {action = "spell", spell = 355913}, -- 翡翠之花
			},
			["12"] = {
				["Click"] = {action = "spell", spell = 360823}, -- 自然平衡
			},
			["13"] = {
				["Click"] = {action = "spell", spell = 370665}, -- 营救
			},
		},
		[1473] = { -- 增辉
			["1"] = {
				["Click"] = {action = "target"},
			},
			["2"] = {
				["Click"] = {action = "spell", spell = 361469}, -- 活化烈焰
			},
			["6"] = {
				["Click"] = {action = "spell", spell = 355913}, -- 翡翠之花
			},
			["12"] = {
				["Click"] = {action = "spell", spell = 365585}, -- 净除
			},
			["13"] = {
				["Click"] = {action = "spell", spell = 370665}, -- 营救
			},
		},
		["nospec"] = {
			["1"] = {
				["Click"] = {action = "target"},
			},
		},
	},
}

local classClickdb = default_ClassClick[G.myClass]
local modifiers = { "Click", "shift-", "ctrl-", "alt-"}

local ClickCastDB = {}

for specID, info in pairs(classClickdb) do
	ClickCastDB[specID] = {}
	for i = 1, 13  do
		ClickCastDB[specID][tostring(i)] = {}
		if i < 6 then
			for _, modifier in ipairs(modifiers) do
				ClickCastDB[specID][tostring(i)][modifier] = {}
				ClickCastDB[specID][tostring(i)][modifier]["action"] = "NONE"
				ClickCastDB[specID][tostring(i)][modifier]["spell"] = ""
				ClickCastDB[specID][tostring(i)][modifier]["item"] = ""
				ClickCastDB[specID][tostring(i)][modifier]["macro"] = ""
			end
		else -- 滚轮用的
			ClickCastDB[specID][tostring(i)]["Click"] = {}
			ClickCastDB[specID][tostring(i)]["Click"]["action"] = "NONE"
			ClickCastDB[specID][tostring(i)]["Click"]["spell"] = ""
			ClickCastDB[specID][tostring(i)]["Click"]["item"] = ""
			ClickCastDB[specID][tostring(i)]["Click"]["macro"] = ""
		end
	end
	for k, _ in pairs(info) do
		for j, _ in pairs(info[k]) do
			local action = info[k][j]["action"]
			ClickCastDB[specID][k][j]["action"] = action
			
			local spellID = info[k][j]["spell"]
			if spellID then
				if GetSpellInfo(spellID) then
					ClickCastDB[specID][k][j]["spell"] = spellID
				else -- 法术错误
					print("spell ID "..spellID.." is gone, delete it.")
				end
			end
		end
	end
end

local click_cast_spells = {
	PRIEST = {
		class = {
			139, -- 恢复
			2061, -- 快速治疗
			17, -- 真言术：盾
			10060, -- 能量灌注
			73325, -- 信仰飞跃
			1706, -- 漂浮术
			373481, -- 真言术：命
			108968, -- 虚空转移
			21562, -- 真言术：韧（BUFF）			
			2006, -- 复活术（复活）
		},
		[256] = { -- 戒律		
			47540, -- 苦修
			194509, -- 真言术：耀
			33206, -- 痛苦压制
			421453, -- 终极苦修
			527, -- 纯净术（驱散）
			212036, -- 群体复活（复活）
		},
		[257] = { -- 神圣
			33076, -- 愈合祷言
			2050, -- 圣言术：静
			47788, -- 守护之魂		
			204883, -- 治疗之环
			2060, -- 治疗术
			596, -- 治疗祷言
			527, -- 纯净术（驱散）
			212036, -- 群体复活（复活）
		},
		[258] = { -- 暗影
			213634, -- 驱散疾病（驱散）
		},
	},
	DRUID = {
		class = {
			774, -- 回春
			20484, -- 复生
			8936, -- 愈合
			18562, -- 迅捷治愈
			102401, -- 野性冲锋
			1126, -- 野性印记
			48438, -- 野性成长
			29166, -- 激活
			1126, -- 野性印记（BUFF）
			50769, -- 起死回生（复活）
		},
		[102] = { -- 平衡
			2782, -- 清除腐蚀（驱散）
		},
		[103] = { -- 野性
			391888, -- 召唤虫群
			2782, -- 清除腐蚀（驱散）
		},
		[104] = { -- 守护
			2782, -- 清除腐蚀（驱散）
		},
		[105] = { -- 恢复
			102342, -- 铁木树皮		
			33763, -- 生命绽放		
			102351, -- 塞纳里奥结界
			50464, -- 滋养
			102693, -- 林莽卫士
			203651, -- 过度生长
			392160, -- 鼓舞
			391888, -- 召唤虫群
			88423, -- 自然之愈（驱散）
			212040, -- 新生（复活）
		},
	},
	SHAMAN = {
		class = {
			8004, -- 治疗之涌
			1064, -- 治疗链
			546, -- 水上行走
			974, -- 大地之盾
			2008, -- 先祖之魂（复活）
		},
		[262] = { -- 元素
			51886, -- 净化灵魂（驱散）
		},
		[263] = { -- 增强
			51886, -- 净化灵魂（驱散）
		},		
		[264] = { -- 恢复
			61295, -- 激流
			428332, -- 始源之潮
			77472, -- 治疗波
			73685, -- 生命释放
			77130, -- 净化灵魂（驱散）
			212048, -- 先祖视界（复活）
		},
	},
	PALADIN = {
		class = {
			1022, -- 保护祝福
			19750, -- 圣光闪现
			633, -- 圣疗术
			6940, -- 牺牲祝福
			1044, -- 自由祝福
			85673, -- 荣耀圣令
			391054, -- 代祷（复活）
		},
		[65] = { -- 神圣
			82326, -- 圣光术	
			20473, -- 神圣震击
			388007, -- 仲夏祝福(388013 阳春祝福 388010 暮秋祝福 388011 凛冬祝福)
			114165, -- 神圣棱镜
			183998, -- 殉道者之光
			148039, -- 信仰屏障
			53563, -- 圣光道标(200025 美德道标)
			156910, -- 信仰道标
			4987, -- 清洁术（驱散）
			212056, -- 宽恕（复活）
		},
		[66] = { -- 防护
			204018, -- 破咒祝福
			213644, -- 清毒术（驱散）
		},
		[67] = { -- 惩戒
			213644, -- 清毒术（驱散）
		},
	},
	WARRIOR = {
		class = {
			3411, -- 援护
			6673, -- 战斗怒吼（BUFF）
		},
	},
	MAGE = { 
		class = {
			130, -- 换落术
			1459, -- 奥术智慧（BUFF）
		},
	},
	WARLOCK = { 
		class = {
			20707, -- 灵魂石
			5697, -- 无尽呼吸
		},	
	},
	HUNTER = { 
		class = {
			34477, -- 误导
		},
	},
	ROGUE = { 
		class = {
			7934, -- 嫁祸诀窍
		},
	},
	DEATHKNIGHT = {
		class = {
			61999, -- 复活盟友
		},
	},
	MONK = {	
		class = {
			116670, -- 活血术	
			115175, -- 抚慰之雾
			115098, -- 真气波
			115178, -- 轮回转世（复活）
		},
		[268] = { -- 酿酒
            218164, -- 清创生血（驱散）
        },
		[270] = { -- 织雾
			124682, -- 氤氲之雾
            115151, -- 复苏之雾
            124081, -- 禅意波
			116849, -- 作茧缚命
			115450, -- 清创生血（驱散）
			212051, -- 死而复生（复活）
		},
		[269] = { -- 踏风
			218164, -- 清创生血（驱散）
		},
	},
	DEMONHUNTER = {
		class = {
			
		},
	},
	EVOKER = {
		class = {
			361469, -- 活化烈焰
			360995, -- 青翠之拥
			374251, -- 灼烧之焰
			369459, -- 魔力之源
			370665, -- 营救
			378441, -- 时间停止
			355913, -- 翡翠之花
			361227, -- 生还（复活）
		},
		[1467] = { -- 湮灭
			365585, -- 净除（驱散）
		},		
		[1468] = { -- 恩护
			364343, -- 回响
			357107, -- 时间膨胀
			367226, -- 精神之花
			366155, -- 逆转
			360823, -- 自然平衡（驱散）
			361178, -- 群体生还（复活）
		},
		[1473] = { -- 增辉
			409311, -- 先知先觉
			360827, -- 炽火龙鳞
			408233, -- 赋能军营之石
			412710, -- 超脱时间
			406732, -- 空间悖论
			365585, -- 净除（驱散）
		},
	},
}

G.ClickCastSpells = click_cast_spells[G.myClass]

--FindBaseSpellByID(388013) --388007
--FindSpellOverrideByID(388007) --388013
-- debug
--for tag, info in pairs(G.ClickCastSpells) do
--	for i, spellID in pairs(info) do
--		local baseID = FindBaseSpellByID(spellID)
--		if baseID ~= spellID then
--			print(string.format("%s has a base spellID %s", spellID, baseID))
--		end
--	end
--end

-- 团队框架光环
local cooldown_auras = {
	--牧师
    [33206]   = 15, -- 痛苦压制
    [47788]   = 15, -- 守护之魂
    [47585]   = 15, -- 消散    
	--小德        
    [102342]  = 15, -- 铁木树皮
    [22812]   = 15, -- 树皮术
    [61336]   = 15, -- 生存本能
    [22842]   = 15, -- 狂暴回复
	--骑士        
    [1022]    = 15, -- 保护之手
    [31850]   = 15, -- 炽热防御者
    [498]     = 15, -- 圣佑术
    [642]     = 15, -- 圣盾术
    [86659]   = 15, -- 远古列王守卫
    [132403]  = 13, -- 个人添加：正义盾击
    [204018]  = 15, -- 个人添加：破咒祝福
    [6940]    = 15, -- 个人添加：牺牲祝福
	--DK          
    [48707]   = 15, -- 反魔法护罩
    [48792]   = 15, -- 冰封之韧
    [49028]   = 15, -- 吸血鬼之血
    [55233]   = 15, -- 符文刃舞
    [194844]  = 15, -- 个人添加：白骨风暴
	--战士        
    [12975]   = 15, -- 破釜沉舟
    [871]     = 15, -- 盾墙
    [184364]  = 15, -- 狂怒回复
    [118038]  = 15, -- 剑在人在
	--DH            
    [196555]  = 15, -- 虚空行走 浩劫
    [187827]  = 15, -- 恶魔变形
    [212084]  = 15, -- 邪能毁灭
    [204021]  = 15, -- 烈火烙印
    [203720]  = 15, -- 恶魔尖刺
	--猎人
    [186265]  = 15, -- 灵龟守护
	--盗贼
    [31224]   = 15, -- 暗影斗篷
    [1966]    = 15, -- 佯攻
	--术士       
    [104773]  = 15, -- 不灭决心
	--法师       
    [45438]   = 15, -- 寒冰屏障
	--武僧       
    [116849]  = 15, -- 作茧缚命
    [115203]  = 15, -- 壮胆酒
    [122470]  = 15, -- 业报之触
    [122783]  = 15, -- 散魔功
	--萨满       
    [108271]  = 15, -- 星界转移
	--通用       
    [324867]  = 6, -- 血肉铸造
}

local global_debuffs = {
	[240559]  = 6,  -- 重伤
	[209858]  = 6,  -- 死疽
	
	--9.0       
	[240443]  = 8, -- 爆裂词缀
	[240447]  = 8, -- 践踏，地震词缀
	[342494]  = 8, -- 狂妄吹嘘，昏迷
	[342466]  = 8, -- 狂妄吹嘘，点名
	[225080]  = 8, -- 萨满重生，可诈尸
	[160029]  = 6, -- 正在复活
	[292910]  = 8, -- 镣铐，爬塔
	[1604]    = 6, -- 眩晕
}

if G.myClass == "PALADIN"  then
	global_debuffs[25771] = 6  -- 自律
end

local ignored_debuffs = {
	[57723]   = 6, -- 筋疲力尽
	[80354]   = 6, -- 时空错位
	[264689]  = 6, -- 疲倦
	[340880]  = 6, -- 傲慢
	[206151]  = 6, -- 挑战者的负担
	[15007]   = 6, -- 复活虚弱
	[113942]  = 6, -- 无法再用恶魔传送门
	[209261]  = 6, -- 未被污染的邪能，DH假死
	[87024]   = 6, -- 灸灼，法师假死
	[41425]   = 6, -- 低温，法师不能再用冰箱
	[326809]  = 6, -- 餍足，DK假死
	[45181]   = 6, -- 装死，盗贼假死
	[320227]  = 6, -- 枯竭外壳，法夜诈尸
	[340556]  = 6, -- 精确本能，导灵器
	[348254]  = 6, -- 典狱长之眼
	[338606]  = 6, -- 典狱长之链
	[26013]   = 6, -- 逃亡者
	[124275]  = 6, -- 轻度醉拳
	[124274]  = 6, -- 中度醉拳
	[340870]  = 6, -- 恐怖光环，圣物匠全屏aoe
	[325184]  = 6, -- 自由心能，女勋爵全屏debuff
	[334909]  = 6, -- 压制气场，议会全屏debuff
	[346939]  = 6, -- 扭曲痛苦，议会全屏debuff
	[332443]  = 6, -- 泥拳，震动的地基，全屏aoe
	[343063]  = 6, -- 干将，大地之刺减速
}

-- 姓名板光环
local plate_auras = {
	--BUFF
	[209859] = true, -- 激励
	-- DEBUFF
	[118] = true, -- 变形术
	[51514] = true, -- 妖术
	[217832] = true, -- 禁锢
	[605] = true, -- 精神控制
	[710] = true, -- 放逐
	[2094] = true, -- 致盲
	[6770] = true, -- 闷棍
	[9484] = true, -- 束缚亡灵
	[20066] = true, -- 忏悔
	
	[339] = true, -- 根须纠缠
	[102359] = true, -- 群体缠绕
	[3355] = true, -- 冰冻陷阱
	[64695] = true, -- 陷地图腾
	
	[5211] = true, -- 蛮力猛击
	[853] = true, -- 制裁之锤	
	[221562] = true, -- 窒息
	
	[118905] = true, -- 电能图腾	
	[132168] = true, -- 震荡波
	[179057] = true, -- 混沌新星
	[30283] = true, -- 暗影之怒
 	[207171] = true, -- 凛冬将至	
	[117405] = true, -- 束缚射击
	[119381] = true, -- 扫堂腿
	[127797] = true, -- 乌索尔旋风
	[205369] = true, --  精神炸弹 
	[81261] = true, -- 日光术
}

local plate_ignored_auras = {
	[15407] = true, -- 精神鞭笞
}

-- 团队框架治疗边角提示（图标）
local default_HealerIndicatorAuraList = {
	PRIEST = { 
        [17] = true,		-- 真言术盾
        [139] = true,		-- 恢复
        [41635] = true,		-- 愈合祷言
        [194384] = true,	-- 救赎
	},
	DRUID = { 
	    [774] = true,		-- 回春
        [155777] = true,	-- 萌芽
        [8936] = true,		-- 愈合
        [33763] = true,		-- 生命绽放
        [48438] = true,		-- 野性成长
		[102351] = true,	-- 塞纳里奥结界
        [102352] = true,	-- 塞纳里奥结界
        [200389] = true,	-- 栽培
	},
	SHAMAN = { 
		[61295] = true,		-- 激流
		[974] = true,		-- 大地之盾
	},
	PALADIN = {
	    [53563] = true,		-- 圣光道标
        [156910] = true,	-- 信仰道标
		[25771] = true,		-- 自律
		[223306] = true,	-- 赋予信仰
		[287280] = true,	-- 圣光闪烁
	},
	WARRIOR = { 
		[12975] = true,		-- 援护
		[114030] = true,	-- 警戒
	},
	MAGE = { 
	
	},
	WARLOCK = { 
	
	},
	HUNTER = { 
		[34477] = true,		-- 误导
	},
	ROGUE = { 
		[57934] = true,		-- 嫁祸
	},
	DEATHKNIGHT = {
	
	},
	MONK = {
	    [119611] = true,	-- 复苏之雾
        [124682] = true,	-- 氤氲之雾
        [124081] = true,	-- 禅意波
		[191840] = true,	-- 精华之泉
		[115175] = true,	-- 抚慰之雾
	},
	DEMONHUNTER = {
	
	},
	EVOKER = {
	
	},
}

local HealerIndicatorAuraList = default_HealerIndicatorAuraList[G.myClass]

-----------------------------------
----          默认配置         ----
-----------------------------------
local Account_default_Settings = {
	gold = {},
}

local Character_default_Settings = {	
	SkinOptions = {
		-- 界面风格
		style = 1,
		formattype = "k", -- w, w_chinese, none
		showtopbar = true,
		showbottombar = true,
		showtopconerbar = true,
		showbottomconerbar = true,	
		-- 界面布局
		infobar = true,
		infobarscale = 1,		
		collapseWF = true,
		afkscreen = true,
		showAFKtips = true,
		-- 非控制台内选项
		gui_x = 300,
		gui_y = 300,
		gui_scale = 100,
		collectminimapbuttons = true,
		MBCFalwaysshow = false,
		MBCFpos = "BOTTOM",
		minimapbutton = true,
	},
	ChatOptions = {
		channelreplacement = true,
		autoscroll = true,
		showbg = false,		
		nogoldseller = true,
		goldkeywordnum = 2,
		goldkeywordlist = "",		
		autoinvite = false,
        autoinvitekeywords = "111 123",
		acceptInvite_friend = true,
		acceptInvite_guild = true,
		acceptInvite_club = true,
		acceptInvite_account = true,		
		refuseInvite_stranger = false,
	},
	ItemOptions = {
		alreadyknown = true,
		autorepair = true,
		autorepair_guild = true,
		autorepair_guild_auto = true,		
		autosell = true,
		autobuy = false,
		autobuylist = {},
	},	
	UnitframeOptions = {
		--[[ 单位框架 ]]--
		-- 样式
		enablefade = true,
		fadingalpha = 0.2,
		portrait = true,
		alwayshp = false,
		alwayspp = false,
		valuefontsize = 16,
		-- 尺寸
		height	= 18,
		width = 230,
		ppheight = 0.25, -- slider
		widthpet = 70,
		widthboss = 170,
		-- 施法条
		castbars = true,	
		cbIconsize = 33,
		independentcb = true,
		cbheight = 16,
		cbwidth = 230,
		target_cbheight = 5,
		target_cbwidth = 230,
		focus_cbheight = 5,
		focus_cbwidth = 230,	
		namepos = "LEFT",
		timepos = "RIGHT",
		Interruptible_color = {r =.6 , g = .4, b = .8},
		notInterruptible_color = {r =.9 , g = 0, b = 1},
		hideplayercastbaricon = false,
		-- 平砍计时条
		swing = false,
		swheight = 12,
		swwidth = 230,
		swtimer = true,
		swtimersize = 12,
		-- 光环
		aura_size = 20,
		playerdebuffenable = true,
		AuraFilterignoreBuff = false,
		AuraFilterignoreDebuff = false,
		AuraFilterwhitelist = {},
		-- 图腾
		totems = true,
		totemsize = 25,
		growthDirection = 'HORIZONTAL',
		sortDirection = 'ASCENDING',
		-- 小队
		widthparty = 200,
		showpartypet = false,
		-- 其他
		showthreatbar = true,
		pvpicon = false,		
		bossframes = true,
		arenaframes = true,
		runecooldown = true,
		valuefs = 12,		
		dpsmana = true,
		stagger = true,
		--[[ 团队框架 ]]--
		-- 启用
		enableraid = true,
		party_num = 4,
		hor_party = false,
		party_connected = true,
		showsolo = false,
		raidframe_inparty = false,
		showraidpet = false,
		raidtool = true,
		raidtool_show = true, -- 非控制台内选项
		-- 启用
		raidheight = 45,
		raidwidth = 120,
		raidmanabars = true,
		raidppheight = 0.1, -- slider
		namelength = 4,		
		raidfontsize = 10,
		showgcd = true,
		raidrole_icon = false,		
		name_style = "missing_hp", -- "name", "none"
		healprediction = true,
		-- 治疗指示器
		hotind_size = 15,
		hotind_style = "icon_ind",-- "icon_ind", "number_ind"
		hotind_filtertype = "whitelist", -- "blacklist", "whitelist"
		hotind_auralist = HealerIndicatorAuraList,
		-- 点击施法
		enableClickCast = false,
		ClickCast = ClickCastDB,
		-- 光环图标	
		raid_debuff_anchor_x = -50,
		raid_debuff_anchor_y = 0,
		raid_debuff_num = 2,
		raid_debuff_icon_size = 22,
		raid_buff_anchor_x = 5,
		raid_buff_anchor_y = 0,
		raid_buff_num = 1,
		raid_buff_icon_size = 22,
		debuff_auto_add = true,
		debuff_auto_add_level = 6,
		-- 团队减益
		raid_debuffs = {},
		-- 全局减益
		debuff_list = global_debuffs,
		debuff_list_black = ignored_debuffs,
		-- 全局增益
		buff_list = cooldown_auras,
	},
	ActionbarOptions = {
		-- 样式
		cooldown_number = true,
		cooldown_number_wa = true,
		cooldownsize = 20,
		rangecolor = true,
		keybindsize = 12,
		macronamesize = 8,
		countsize = 12,
		enablefade = true,
		fadingalpha_type = "uf", -- "uf", "custom"
		fadingalpha = 0.2,
		-- 冷却提示
		cdflash_enable = true,
		cdflash_size = 60,
		cdflash_ignorespells = {},
		cdflash_ignoreitems = {
			[6948] = true,
		},
	},
	PlateOptions = {
		-- 通用
		enableplate = true,
		theme = "class", -- "dark" "class" "number"	
		namefontsize = 8,
		plateauranum = 5,
		plateaurasize = 15,	
		Interruptible_color = {r =.6 , g = .4, b = .8},	
		notInterruptible_color = {r =.9 , g = 0, b = 1},
		focuscolored = true,
		focus_color = {r = .5, g = .4, b = .9},
		threatcolor = true,
		bar_onlyname = false, -- 友方只显示名字
				
		-- 样式
		bar_width = 90,-- 条形
		bar_height = 8,
		valuefontsize = 8,
		bar_hp_perc = "perc", -- 数值样式  "perc" "value_perc"
		bar_alwayshp = false,		

		number_size = 23,-- 数字型
		number_alwayshp = false,
		number_colorheperc = false,	
		-- 玩家姓名板
		playerplate = false,
		platecastbar = false,
		classresource_show = false,	
		-- 光环过滤列表
		myfiltertype = "blacklist", -- "blacklist", "whitelist", "none"
		myplateauralist = plate_ignored_auras,
		otherfiltertype = "none", -- "whitelist", "none"
		otherplateauralist = plate_auras,
		-- 自定义
		customcoloredplates = {},
		custompowerplates = {},
	},
	CombattextOptions = {
		showreceivedct = true,
		showoutputct = true,
		ctshowdots = false,
		ctshowhots = false,
		ctshowpet = true,
		combattext_font = "none",
	},
	OtherOptions = {
		show_spellID = true,
		show_itemID = true,
		combat_hide = true,
		autopet = true,
		autopet_favorite = true,
		LFGRewards = true,
		vignettealert = true,
		battlegroundres = true,
		acceptres = true,
		flashtaskbar = true,
		hideerrors = true,
		autoscreenshot = true,
	},
	
	FramePoints = {},
}

function T.LoadVariables()
	for a, b in pairs(Character_default_Settings) do
		if type(b) ~= "table" then
			if aCoreCDB[a] == nil then
				aCoreCDB[a] = b
			end
		else
			if aCoreCDB[a] == nil then
				aCoreCDB[a] = {}
			end
			for k, v in pairs(b) do
				if aCoreCDB[a][k] == nil then
					aCoreCDB[a][k] = v
				end
			end
		end
	end
end

function T.LoadAccountVariables()
	for a, b in pairs(Account_default_Settings) do
		if type(b) ~= "table" then
			if aCoreDB[a] == nil then
				aCoreDB[a] = b
			end
		else
			if aCoreDB[a] == nil then
				aCoreDB[a] = {}
			end
			for k, v in pairs(b) do
				if aCoreDB[a][k] == nil then
					aCoreDB[a][k] = v
				end
			end
		end
	end
end

-----------------------------------
----         导出、导入        ----
-----------------------------------

T.ExportSettings = function()
	local BlzLayoutStr = T.ExportLayout()
	local str = "AltzUI Export".."~"..G.Version.."~"..G.Client.."~"..G.myClass.."~"..G.PlayerName.."~"..BlzLayoutStr
	for OptionCategroy, OptionTable in pairs(Character_default_Settings) do
		if type(OptionTable) == "table" then
			for setting, value in pairs(OptionTable) do
				if type(value) ~= "table" then -- 3
					if aCoreCDB[OptionCategroy][setting] ~= value then
						local valuetext
						if aCoreCDB[OptionCategroy][setting] == false then
							valuetext = "false"
						elseif aCoreCDB[OptionCategroy][setting] == true then
							valuetext = "true"
						else
							valuetext = aCoreCDB[OptionCategroy][setting]
						end
						str = str.."^"..OptionCategroy.."~"..setting.."~"..valuetext
					end
				else
					if OptionCategroy == "ItemOptions" then
						if setting == "autobuylist" then -- 完全复制 4
							for id, count in pairs(aCoreCDB["ItemOptions"]["autobuylist"]) do -- 默认是空的
								str = str.."^"..OptionCategroy.."~"..setting.."~"..id.."~"..count
							end
						end
					elseif OptionCategroy == "PlateOptions" then
						if setting == "customcoloredplates" then -- 完全复制 6
							for name, t in pairs(aCoreCDB["PlateOptions"]["customcoloredplates"]) do
								str = str.."^"..OptionCategroy.."~"..setting.."~"..name.."~"..t.r.."~"..t.g.."~"..t.b
							end
						elseif setting == "custompowerplates" then -- 完全复制 4
							for name, _ in pairs(aCoreCDB["PlateOptions"]["custompowerplates"]) do
								str = str.."^"..OptionCategroy.."~"..setting.."~"..name.."~true"
							end
						else -- 完全复制 4
							for id, _ in pairs(aCoreCDB["PlateOptions"][setting]) do
								str = str.."^"..OptionCategroy.."~"..setting.."~"..id.."~true"
							end
						end
					elseif setting == "ClickCast" then -- 9
						for specID, info in pairs(value) do
							for k, _ in pairs(info) do
								for j, v in pairs(info[k]) do -- j  Click ctrl- shift- alt-
									local action = aCoreCDB["UnitframeOptions"]["ClickCast"][specID][k][j].action
									local spell = aCoreCDB["UnitframeOptions"]["ClickCast"][specID][k][j].spell
									local item = aCoreCDB["UnitframeOptions"]["ClickCast"][specID][k][j].item
									local macro = aCoreCDB["UnitframeOptions"]["ClickCast"][specID][k][j].macro
									if action ~= v.action or spell ~= v.spell or item ~= v.item or macro ~= v.macro then
										str = str.."^"..OptionCategroy.."~"..setting.."~"..specID.."~"..k.."~"..j.."~"..action.."~"..spell.."~"..item.."~"..macro
									end
								end
							end
						end
					elseif setting == "raid_debuffs" then -- 完全复制 6
						for instanceID, encouter_table in pairs(value) do
							for boss, auratable in pairs(encouter_table) do
								for spellID, level in pairs(auratable) do
									str = str.."^"..OptionCategroy.."~"..setting.."~"..instanceID.."~"..boss.."~"..spellID.."~"..level
								end
							end
						end
					elseif setting == "debuff_list_black" then -- 完全复制 4
						for spellID, bool in pairs(value) do
							str = str.."^"..OptionCategroy.."~"..setting.."~"..spellID.."~true"
						end
					elseif setting == "debuff_list" or setting == "buff_list" then -- 完全复制 4
						for spellID, level in pairs(value) do
							str = str.."^"..OptionCategroy.."~"..setting.."~"..spellID.."~"..level
						end
					elseif setting == "AuraFilterwhitelist" then -- 完全复制 4
						for id, _ in pairs(aCoreCDB["UnitframeOptions"]["AuraFilterwhitelist"]) do -- 默认是空的
							str = str.."^"..OptionCategroy.."~"..setting.."~"..id.."~true"
						end
					elseif setting == "cdflash_ignorespells" then -- 完全复制 4
						for spellID, _ in pairs(aCoreCDB["ActionbarOptions"]["cdflash_ignorespells"]) do
							str = str.."^"..OptionCategroy.."~"..setting.."~"..spellID.."~true"
						end
					elseif setting == "cdflash_ignoreitems" then -- 完全复制 4
						for itemID, _ in pairs(aCoreCDB["ActionbarOptions"]["cdflash_ignoreitems"]) do
							str = str.."^"..OptionCategroy.."~"..setting.."~"..itemID.."~true"
						end	
					end
				end
			end
		end
	end
	for frame, info in pairs (aCoreCDB["FramePoints"]) do
		for mode, xy in pairs(info) do
			for key, _ in pairs(xy) do
				local f = _G[frame]
				if f and f["point"] then
					if xy[key] ~= f["point"][mode][key] then
						str = str.."^FramePoints~"..frame.."~"..mode.."~"..key.."~"..xy[key]
						--print(frame.."~"..mode.."~"..key.."~"..xy[key])
					end
				end
			end
		end
	end
	
	return str
end

T.ImportSettings = function(str)
	local optionlines = {string.split("^", str)}
	local uiname, version, client, class, sender, BlzLayoutStr = string.split("~", optionlines[1])
	local sameversion, sameclient, sameclass, importLayoutInfo
	
	if uiname ~= "AltzUI Export" then
		StaticPopup_Show(G.uiname.."Cannot Import")
	else
		local import_str = ""
		if version ~= G.Version then
			import_str = import_str..format(L["版本不符合"], version, G.Version)
		else
			sameversion = true
		end
		
		if client ~= G.Client then
			import_str = import_str..format(L["客户端不符合"], client, G.Client)
		else
			sameclient = true
		end
		
		if class ~= G.myClass then
			import_str = import_str..format(L["职业不符合"], G.ClassInfo[class], G.ClassInfo[G.myClass])
		else
			sameclass = true
		end
		
		importLayoutInfo = C_EditMode.ConvertStringToLayoutInfo(BlzLayoutStr)	
		if not importLayoutInfo then
			import_str = import_str..L["暴雪布局字串有误"]
		end
	
		if not (sameversion and sameclient and sameclass and importLayoutInfo) then
			import_str = import_str..L["不完整导入"]
		end
		
		StaticPopupDialogs[G.uiname.."Import Confirm"].text = format(L["导入确认"]..import_str, "Altz UI")
		StaticPopupDialogs[G.uiname.."Import Confirm"].OnAccept = function()
			aCoreCDB = {}
			T.LoadVariables()
			
			aCoreCDB.meet = true -- 不显示引导
			
			-- 完全复制的设置
			if sameclass then
				aCoreCDB.PlateOptions.myplateauralist = {}
				aCoreCDB.ActionbarOptions.cdflash_ignorespells = {}
			end			
			
			aCoreCDB.UnitframeOptions.debuff_list = {}
			aCoreCDB.UnitframeOptions.debuff_list_black = {}
			aCoreCDB.UnitframeOptions.buff_list = {}
			
			aCoreCDB.ActionbarOptions.cdflash_ignoreitems = {}
			aCoreCDB.PlateOptions.otherplateauralist = {}
			
			for index, v in pairs(optionlines) do
				if index ~= 1 then
					local OptionCategroy, setting, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 = string.split("~", v)	
					local count = select(2, string.gsub(v, "~", "~")) + 1
	
					if count == 3 then -- 可以直接赋值
						if aCoreCDB[OptionCategroy][setting] ~= nil then
							if arg1 == "true" then
								aCoreCDB[OptionCategroy][setting] = true	
							elseif arg1 == "false" then
								aCoreCDB[OptionCategroy][setting] = false
							elseif tonumber(arg1) and setting ~= "autoinvitekeywords" and setting ~= "goldkeywordlist" then
								aCoreCDB[OptionCategroy][setting] = tonumber(arg1)
							else
								aCoreCDB[OptionCategroy][setting] = arg1
							end
						end
					else -- 是个表格
						if OptionCategroy == "ItemOptions" then
							if setting == "autobuylist" then -- 完全复制 4 OptionCategroy.."~"..setting.."~"..id.."~"..count
								aCoreCDB[OptionCategroy][setting][tonumber(arg1)] = tonumber(arg2)
							end
						elseif OptionCategroy == "PlateOptions" then
							if setting == "customcoloredplates" then -- 完全复制 6 OptionCategroy.."~"..setting.."~"..name.."~"..t.r.."~"..t.g.."~"..t.b
								if sameclient then
									aCoreCDB[OptionCategroy][setting][arg1] = {	
										r = tonumber(arg2),
										g = tonumber(arg3),
										b = tonumber(arg4),
									}
								end
							elseif setting == "custompowerplates" then -- 非空则复制 4
								if sameclient then
									aCoreCDB[OptionCategroy][setting][arg1] = true
								end
							elseif setting == "otherplateauralist" then -- 完全复制 4 OptionCategroy.."~"..setting.."~"..id.."~true"
								aCoreCDB[OptionCategroy][setting][tonumber(arg1)] = true
							elseif setting == "myplateauralist" then
								if sameclass then
									aCoreCDB[OptionCategroy][setting][tonumber(arg1)] = true
								end
							end
						elseif OptionCategroy == "FramePoints" then -- 5 FramePoints~"..frame.."~"..mode.."~"..key.."~"..xy[key]
							if aCoreCDB[OptionCategroy][setting] == nil then
								aCoreCDB[OptionCategroy][setting] = {}
							end
							if aCoreCDB[OptionCategroy][setting][arg1] == nil then
								aCoreCDB[OptionCategroy][setting][arg1] = {}
							end
							if arg2 == "x" or arg2 == "y" then
								aCoreCDB[OptionCategroy][setting][arg1][arg2] = tonumber(arg3)
							else
								aCoreCDB[OptionCategroy][setting][arg1][arg2] = arg3
							end
						
						elseif OptionCategroy == "UnitframeOptions" and setting == "ClickCast" then -- 9 OptionCategroy.."~"..setting.."~"..specID.."~"..k.."~"..j.."~"..action.."~"..spell.."~"..item.."~"..macro
							if sameclass then
								aCoreCDB[OptionCategroy][setting][tonumber(arg1)][arg2][arg3]["action"] = arg4
								aCoreCDB[OptionCategroy][setting][tonumber(arg1)][arg2][arg3]["spell"] = tonumber(arg5)
								aCoreCDB[OptionCategroy][setting][tonumber(arg1)][arg2][arg3]["item"] = arg6
								aCoreCDB[OptionCategroy][setting][tonumber(arg1)][arg2][arg3]["macro"] = arg7						
							end
						elseif setting == "raid_debuffs" then -- 完全复制 6 OptionCategroy.."~"..setting.."~"..instanceID.."~"..boss.."~"..spellID.."~"..level
							if not aCoreCDB[OptionCategroy][setting][tonumber(arg1)] then
								aCoreCDB[OptionCategroy][setting][tonumber(arg1)] = {}
							end
							if not aCoreCDB[OptionCategroy][setting][tonumber(arg1)][tonumber(arg2)] then
								aCoreCDB[OptionCategroy][setting][tonumber(arg1)][tonumber(arg2)] = {}
							end
							aCoreCDB[OptionCategroy][setting][tonumber(arg1)][tonumber(arg2)][tonumber(arg3)] = tonumber(arg4)		
						elseif setting == "debuff_list_black" then -- 完全复制 4 OptionCategroy.."~"..setting.."~"..spellID.."~"..true							
							aCoreCDB[OptionCategroy][setting][tonumber(arg1)] = true
						elseif setting == "debuff_list" or setting == "buff_list" then -- 完全复制 4 OptionCategroy.."~"..setting.."~"..spellID.."~"..level
							aCoreCDB[OptionCategroy][setting][tonumber(arg1)] = tonumber(arg2)
						elseif setting == "AuraFilterwhitelist" then -- 完全复制 4 OptionCategroy.."~"..setting.."~"..id.."~true"
							aCoreCDB[OptionCategroy][setting][tonumber(arg1)] = true
						elseif setting == "cdflash_ignorespells" and sameclass then -- 完全复制 4 OptionCategroy.."~"..setting.."~"..spellID.."~true"	
							aCoreCDB[OptionCategroy][setting][tonumber(arg1)] = true
						elseif setting == "cdflash_ignoreitems" then -- 完全复制 4 OptionCategroy.."~"..setting.."~"..spellID.."~true"	
							aCoreCDB[OptionCategroy][setting][tonumber(arg1)] = true
						end
					end
				end
			end
			
			if importLayoutInfo then
				T.ImportLayout(importLayoutInfo, string.format("%s[%s]", sender, version), true)
			end
			
			ReloadUI()
		end
		StaticPopup_Show(G.uiname.."Import Confirm")
	end
end