﻿local T, C, L, G = unpack(select(2, ...))
local oUF = AltzUF or oUF

local UpdateRate = .25

local ClassSpells = {
	PRIEST = {
		[139] = { -- 恢复
			font = "text",
			update_type = "dur",
			color = {.81, .98, .48},
			point = {"TOPLEFT", 0, 0},
		},
		[41635] = { -- 愈合祷言
			font = "text",
			update_type = "stack",
			color = {.94, .8, .33},
			point = {"TOPRIGHT", 0, 0},
			str = {"⑴","⑵","⑶","⑷","⑸","⑹","⑺","⑻","⑼","⑽","⑾","⑿","⒀","⒁","⒂","⒃","⒄","⒅","⒆","⒇"},
		},
		[194384] = { -- 救赎
			font = "text",
			update_type = "dur",
			color = {.96, .91, .6},
			point = {"LEFT", 0, 0},
		},
		[17] = { -- 盾
			font = "symbol",
			adjust = -1,
			color = {.93, .87, .87},
			point = {"TOP", 0, 0},
			str = "T",
		},
		[443526] = { -- 慰藉预兆
			font = "symbol",
			adjust = -1,
			color = {1, 1, 0},
			point = {"TOP", -15, 0},
			str = "T",
		},
	},
	DRUID = {
		[188550] = { -- 生命绽放
			font = "text",
			update_type = "dur",
			color = {.15, .71, .38},
			point = {"TOP", 0, 0},
		},
		[33763] = { -- 生命绽放
			font = "text",
			update_type = "dur",
			color = {.15, .71, .38},
			point = {"TOP", 0, 0},
		},
		[774] = { -- 回春
			font = "text",
			update_type = "dur",
			color = {.98, .43, .98},
			point = {"TOPRIGHT", 0, 0},
		},
		[155777] = { -- 回春(萌芽)
			font = "text",
			update_type = "dur",
			color = {.69, .56, 1},
			point = {"TOPRIGHT", -20, 0},
		},
		[8936] = { -- 愈合
			font = "text",
			update_type = "dur",
			color = {.71, .87, .6},
			point = {"TOPLEFT", 0, 0},
		},
		[48438] = { -- 野性成长
			font = "text",
			update_type = "dur",
			color = {.64, .96, .5},
			point = {"LEFT", 0, 0},
		},
		[102351] = { -- 塞纳里奥结界(盾)
			font = "symbol",
			adjust = -1,
			color = {.85, .87, .77},
			point = {"RIGHT", 0, 0},
			str = "Y",
		},
		[102352] = { -- 塞纳里奥结界(HOT)
			font = "text",
			update_type = "dur",
			adjust = -1,
			color = {.8, .87, .6},
			point = {"RIGHT", 0, 0},
			str = {"⑴","⑵","⑶","⑷","⑸","⑹","⑺","⑻","⑼","⑽","⑾","⑿","⒀","⒁","⒂","⒃","⒄","⒅","⒆","⒇"},
		},
	},
	PALADIN = {
		[156322] = { -- 永恒之火
			font = "text",
			update_type = "dur",
			color = {1, .77, .15},
			point = {"TOPLEFT", 0, 0},
		},
		[388013] = { -- 阳春祝福
			font = "text",
			update_type = "dur",
			color = {.73, 1, .64},
			point = {"TOP", 0, 0},
		},
		[388007] = { -- 仲夏祝福
			font = "text",
			update_type = "dur",
			color = {1, .29, .55},
			point = {"TOP", 0, 0},
		},
		--[388010] = { -- 暮秋祝福
		--	font = "text",
		--	update_type = "dur",
		--	color = {1, .84, .25},
		--	point = {"TOP", 0, 0},
		--},
		--[388011] = { -- 凛冬祝福
		--	font = "text",
		--	update_type = "dur",
		--	color = {.21, .56, 1},
		--	point = {"TOP", 0, 0},
		--},
		[53563] = { -- 道标
			font = "symbol",
			adjust = -1,
			color = {.98, .82, .54},
			point = {"TOPRIGHT", 0, 0},
			str = "O",
		},
		[156910] = { -- 信仰道标
			font = "symbol",
			adjust = -1,
			color = {.38, .71, .82},
			point = {"TOPRIGHT", 0, 0},
			str = "O",
		},
		[200025] = { -- 美德道标
			font = "symbol",
			adjust = -1,
			color = {.96, .87, .29},
			point = {"TOPRIGHT", 0, 0},
			str = "O",
		},
		[25771] = { -- 自律
			source = "all",
			font = "symbol",
			adjust = -1,
			color = {1, .51, .32},
			point = {"LEFT", 0, 0},
			str = "F",
		},		
		[431381] = { -- 晨光
			font = "text",
			update_type = "dur",
			color = {1, 1, 0},
			point = {"BOTTOMLEFT", 0, 5},
		},
		[432496] = { -- 神圣壁垒
			font = "text",
			update_type = "dur",
			color = {.98, 1, .75},
			point = {"RIGHT", 0, 0},
			str = {"⑴","⑵","⑶","⑷","⑸","⑹","⑺","⑻","⑼","⑽","⑾","⑿","⒀","⒁","⒂","⒃","⒄","⒅","⒆","⒇"},
		},
		[432502] = { -- 圣洁武器
			font = "text",
			update_type = "dur",
			color = {.96, .5, .17},
			point = {"RIGHT", -15, 0},
			str = {"⑴","⑵","⑶","⑷","⑸","⑹","⑺","⑻","⑼","⑽","⑾","⑿","⒀","⒁","⒂","⒃","⒄","⒅","⒆","⒇"},
		},
	},
	SHAMAN = {
		[61295] = { -- 激流
			font = "text",
			update_type = "dur",
			color = {.73, .93, .97},
			point = {"TOPRIGHT", 0, 0},
		},
		[974] = { -- 大地之盾
			font = "text",
			update_type = "stack",
			color = {.95, .93, .79},
			point = {"TOPLEFT", 0, 0},
			str = {"⑴","⑵","⑶","⑷","⑸","⑹","⑺","⑻","⑼","⑽","⑾","⑿","⒀","⒁","⒂","⒃","⒄","⒅","⒆","⒇"},
		},
		[383648] = { -- 大地之盾
			font = "text",
			update_type = "stack",
			color = {.95, .93, .79},
			point = {"TOPLEFT", 0, 0},
			str = {"⑴","⑵","⑶","⑷","⑸","⑹","⑺","⑻","⑼","⑽","⑾","⑿","⒀","⒁","⒂","⒃","⒄","⒅","⒆","⒇"},
			backup_str = "o",
		},
	},
	MONK = {
		[115175] = { -- 抚慰之雾		
			font = "symbol",
			adjust = -1,
			color = {.34, .86, .59},
			point = {"TOP", 0, 0},
			str = "U",
		},
		[124682] = { -- 氤氲之雾		
			font = "text",
			update_type = "dur",
			color = {.84, .8, .46},
			point = {"LEFT", 0, 0},
		},
		[119611] = { -- 复苏之雾		
			font = "text",
			update_type = "dur",
			color = {.28, .75, .6},
			point = {"TOPLEFT", 0, 0},
		},
	},
	EVOKER = {
		[366155] = { -- 逆转
			font = "text",
			update_type = "dur",
			color = {.95, .91, .51},
			point = {"TOPLEFT", 0, 0},
		},
		[367364] = { -- 逆转（复制）
			font = "text",
			update_type = "dur",
			color = {.95, .91, .51},
			point = {"BOTTOMLEFT", 0, 5},
		},
		[355941] = { -- 梦境吐息
			font = "text",
			update_type = "dur",
			color = {.61, 1, .83},
			point = {"TOP", 0, 0},
		},
		--[376788] = { -- 梦境吐息（复制）
		--	font = "text",
		--	update_type = "dur",
		--	color = {.61, 1, .83},
		--	point = {"BOTTOM", 0, 5},
		--},
		[409895] = { -- 精神之花
			font = "text",
			update_type = "dur",
			color = {.22, 1, .78},
			point = {"LEFT", 0, 0},
		},
		[364343] = { -- 回响
			font = "symbol",
			adjust = -1,
			color = {.8, .87, .6},
			point = {"RIGHT", 0, 0},
			str = "Y",
		},
		[370889] = { -- 双生护卫
			font = "symbol",
			adjust = -1,
			color = {.34, .79, .98},
			point = {"TOPRIGHT", 0, 0},
			str = "z",
		},
		[373267] = { -- 缚誓生命
			font = "symbol",
			adjust = -1,
			color = {.74, .29, .29},
			point = {"TOPRIGHT", -20, 0},
			str = "z",
		},
		--[395296] = { -- 黑檀之力
		--	font = "text",
		--	update_type = "dur",
		--	color = {.65, .25, .13},
		--	point = {"BOTTOMLEFT", 0, 0},
		--},
		--[395152] = { -- 黑檀之力
		--	font = "text",
		--	update_type = "dur",
		--	color = {.65, .25, .13},
		--	point = {"BOTTOMLEFT", 0, 0},
		--},
		[410089] = { -- 先知先觉
			font = "text",
			update_type = "dur",
			color = {.85, .7, .3},
			point = {"TOP", 0, 0},
		},
		[361022] = { -- 威力感知
			font = "text",
			update_type = "dur",
			color = {.49, .62, 1},
			point = {"TOPLEFT", 0, 0},
		},
		[360827] = { -- 炽火龙鳞
			font = "text",
			update_type = "stack",
			color = {.95, .93, .79},
			point = {"RIGHT", 0, 0},
			str = {"⑴","⑵","⑶","⑷","⑸","⑹","⑺","⑻","⑼","⑽","⑾","⑿","⒀","⒁","⒂","⒃","⒄","⒅","⒆","⒇"},
		},
	},
	WARRIOR = {
	
	},
	MAGE = {
	
	},
	WARLOCK = {
	
	},
	HUNTER = {
	
	},
	ROGUE = {
	
	},
	DEATHKNIGHT = {
	
	},
	DEMONHUNTER = {
	
	},
}

local IndInfo = ClassSpells[G.myClass]

local function CreateButton(element, spellID)
	local button = CreateFrame('Button', nil, element)
	local info = IndInfo[spellID]
	
	button:SetSize(10, 10)
	button:SetPoint(unpack(info.point))
	button.spellID = spellID
	
	if info.font == "text" then
		button.text = T.createtext(button, "OVERLAY", element.size + (info.adjust or 0), "OUTLINE")
	elseif info.font == "symbol" then
		button.text = T.createsymbol(button, "OVERLAY", element.size + (info.adjust or 0), "OUTLINE")
	end
	
	button.text:SetPoint("CENTER")
	button.text:SetTextColor(info.color[1], info.color[2], info.color[3])
	
	if info.update_type == "dur" then
		button.t = 0
	end
	
	return button
end

local function updateAura(element, unit, data)
	if (not data or not data.name) then return end
	
	local spellID = data.spellId
	local info = IndInfo[spellID]

	local button = element.inds[spellID]
	
	if not button then
		button = CreateButton(element, spellID)
		element.inds[spellID] = button
	end
	
	button.auraID = data.auraInstanceID
	
	if info.update_type == "dur" then
		button:SetScript("OnUpdate", function(self, e)
			self.t = self.t - e
			if self.t < 0 then
				local remain = ceil(data.expirationTime - GetTime())
				if remain > 0 then
					if info.str then
						self.text:SetText(info.str[remain] or remain)
					else
						self.text:SetText(remain)
					end
				else
					self.text:SetText("")
					self:SetScript("OnUpdate", nil)
				end	
				self.t = UpdateRate					
			end
		end)
	elseif info.update_type == "stack" then
		if data.applications >= 1 then
			if info.str then
				button.text:SetText(info.str[data.applications] or data.applications)
			else
				button.text:SetText(data.applications)
			end
		else
			button.text:SetText(info.backup_str or "")
		end
	elseif info.str then
		button.text:SetText(info.str)
	end

	button:Show()
end

local function FilterAura(element, unit, data)
	if (data.isPlayerAura and IndInfo[data.spellId]) 
	or (IndInfo[data.spellId] and IndInfo[data.spellId]["source"] == "all")
	or (not data.isPlayerAura and IndInfo[data.spellId] and IndInfo[data.spellId]["source"] == "others") then
		return true
	end
end

local function processData(element, unit, data)
	if(not data) then return end

	data.isPlayerAura = data.sourceUnit and (UnitIsUnit('player', data.sourceUnit) or UnitIsOwnerOrControllerOfUnit('player', data.sourceUnit))

	return data
end

local function UpdateAuras(self, event, unit, updateInfo)
	if (not unit or not UnitIsUnit(self.unit, unit)) then return end
	
	local isFullUpdate = not updateInfo or updateInfo.isFullUpdate

	local ind = self.AltzIndicators
	if(ind) then		
		local buffsChanged, debuffsChanged
		
		if(isFullUpdate) then
			ind.allBuffs = table.wipe(ind.allBuffs or {})
			ind.activeBuffs = table.wipe(ind.activeBuffs or {})
			buffsChanged = true

			local slots = {C_UnitAuras.GetAuraSlots(unit, 'HELPFUL')}
			for i = 2, #slots do -- #1 return is continuationToken, we don't care about it
				local data = processData(ind, unit, C_UnitAuras.GetAuraDataBySlot(unit, slots[i]))
				ind.allBuffs[data.auraInstanceID] = data

				if FilterAura(ind, unit, data) then
					ind.activeBuffs[data.auraInstanceID] = true
				end
			end

			ind.allDebuffs = table.wipe(ind.allDebuffs or {})
			ind.activeDebuffs = table.wipe(ind.activeDebuffs or {})
			debuffsChanged = true

			local debuffslots = {C_UnitAuras.GetAuraSlots(unit, 'HARMFUL')}
			for i = 2, #debuffslots do
				local data = processData(ind, unit, C_UnitAuras.GetAuraDataBySlot(unit, debuffslots[i]))
				ind.allDebuffs[data.auraInstanceID] = data

				if FilterAura(ind, unit, data) then
					ind.activeDebuffs[data.auraInstanceID] = true
				end
			end
		else
			if updateInfo.addedAuras then
				for _, data in next, updateInfo.addedAuras do
					if(data.isHelpful and not C_UnitAuras.IsAuraFilteredOutByInstanceID(unit, data.auraInstanceID, 'HELPFUL')) then
						data = processData(ind, unit, data)
						ind.allBuffs[data.auraInstanceID] = data

						if FilterAura(ind, unit, data) then
							ind.activeBuffs[data.auraInstanceID] = true
							buffsChanged = true
						end
					elseif(data.isHarmful and not C_UnitAuras.IsAuraFilteredOutByInstanceID(unit, data.auraInstanceID, 'HARMFUL')) then
						data = processData(ind, unit, data)
						ind.allDebuffs[data.auraInstanceID] = data

						if FilterAura(ind, unit, data) then
							ind.activeDebuffs[data.auraInstanceID] = true
							debuffsChanged = true
						end
					end
				end
			end

			if(updateInfo.updatedAuraInstanceIDs) then
				for _, auraInstanceID in next, updateInfo.updatedAuraInstanceIDs do
					if(ind.allBuffs[auraInstanceID]) then
						ind.allBuffs[auraInstanceID] = processData(ind, unit, C_UnitAuras.GetAuraDataByAuraInstanceID(unit, auraInstanceID))

						-- only update if it's actually active
						if(ind.activeBuffs[auraInstanceID]) then
							ind.activeBuffs[auraInstanceID] = true
							buffsChanged = true
						end
					elseif(ind.allDebuffs[auraInstanceID]) then
						ind.allDebuffs[auraInstanceID] = processData(ind, unit, C_UnitAuras.GetAuraDataByAuraInstanceID(unit, auraInstanceID))

						if(ind.activeDebuffs[auraInstanceID]) then
							ind.activeDebuffs[auraInstanceID] = true
							debuffsChanged = true
						end
					end
				end
			end

			if(updateInfo.removedAuraInstanceIDs) then
				for _, auraInstanceID in next, updateInfo.removedAuraInstanceIDs do
					if(ind.allBuffs[auraInstanceID]) then
						ind.allBuffs[auraInstanceID] = nil

						if(ind.activeBuffs[auraInstanceID]) then
							ind.activeBuffs[auraInstanceID] = nil
							buffsChanged = true
						end
					elseif(ind.allDebuffs[auraInstanceID]) then
						ind.allDebuffs[auraInstanceID] = nil

						if(ind.activeDebuffs[auraInstanceID]) then
							ind.activeDebuffs[auraInstanceID] = nil
							debuffsChanged = true
						end
					end
				end
			end
		end

		if buffsChanged then
			for auraInstanceID in next, ind.activeBuffs do
				updateAura(ind, unit, ind.allBuffs[auraInstanceID])
			end
		end
		
		if debuffsChanged then	
			for auraInstanceID in next, ind.activeDebuffs do
				updateAura(ind, unit, ind.allDebuffs[auraInstanceID])
			end	
		end
		
		for spellID, bu in pairs(ind.inds) do
			if not (ind.allDebuffs[bu.auraID] or ind.allBuffs[bu.auraID]) then
				bu:Hide()
				if bu:GetScript("OnUpdate") then
					bu:SetScript("OnUpdate", nil)
				end
			end
		end
	end
end

local function Update(self, event, unit, updateInfo)
	if(self.unit ~= unit) then return end

	UpdateAuras(self, event, unit, updateInfo)
	
	if(event == 'ForceUpdate' or not event) then
		local ind = self.AltzIndicators
		for spellID, bu in pairs(ind.inds) do
			local info = IndInfo[bu.spellID]
			if info.font == "text" then
				bu.text:SetFont(G.norFont, ind.size + (info.adjust or 0), "OUTLINE")				
			elseif info.font == "symbol" then
				bu.text:SetFont(G.symbols, ind.size + (info.adjust or 0), "OUTLINE")		
			end
		end
	end
end

local function ForceUpdate(element)
	return Update(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local Enable = function(self)
	local ind = self.AltzIndicators
    if ind then
		self:RegisterEvent('UNIT_AURA', UpdateAuras)
		
		ind.__owner = self
		ind.ForceUpdate = ForceUpdate
		
		ind.size = ind.size or 10
		ind.inds = {}

		ind:Show()
		
		return true
    end
end

local Disable = function(self)
	local ind = self.AltzIndicators
    if ind then
		self:UnregisterEvent('UNIT_AURA', UpdateAuras)
		
		if(self.AltzIndicators) then self.AltzIndicators:Hide() end
	end
end

oUF:AddElement('AltzIndicators', Update, Enable, Disable)