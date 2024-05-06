﻿local T, C, L, G = unpack(select(2, ...))
local oUF = AltzUF or oUF

local current_encounter

local gold_str = "|cFFFFD700|Haddon:altz:raiddebuff_config:%s:%s:%s|h[%s]|h|r"
local red_str = "|cFFDC143C|Haddon:altz:raiddebuff_delete:%s:%s:%s|h[%s]|h|r"

--=============================================--
--[[              治疗法力条				 ]]--
--=============================================--

local UpdateHealManabar = function()
	local oUF = AltzUF or oUF
	for _, obj in next, oUF.objects do	
		if obj.style == 'Altz_Healerraid' and obj.Power then
			local role = UnitGroupRolesAssigned(obj.unit)
			if aCoreCDB["UnitframeOptions"]["raidmanabars"] and role == 'HEALER' then
				obj.Power:SetAlpha(1)
			else
				obj.Power:SetAlpha(0)
			end
		end
	end
end
T.UpdateHealManabar = UpdateHealManabar

--=============================================--
--[[ 		     	仇恨		    		 ]]--
--=============================================--

local function Override_ThreatUpdate(self, event, unit)	
	if (self.unit ~= unit) then return end
	
	local element = self.ThreatIndicator
	local status = UnitThreatSituation(unit)
	
	if status and status > 1 then
		element:SetBackdropBorderColor(GetThreatStatusColor(status))
		element:Show()
	else
		element:Hide()
	end
end
T.Override_ThreatUpdate = Override_ThreatUpdate

--=============================================--
--[[ 	    	治疗预估和吸收 				 ]]--
--=============================================--

local function CreateHealPreditionBar(self, ...)
	local hpb = CreateFrame('StatusBar', nil, self.Health)
	hpb:SetFrameLevel(self:GetFrameLevel()+1)
	hpb:SetStatusBarTexture(G.media.blank)
	hpb:SetStatusBarColor(...)
	hpb:SetPoint('TOP')
	hpb:SetPoint('BOTTOM')
	
	hpb:SetWidth(aCoreCDB["UnitframeOptions"]["raidwidth"])
	return hpb
end

--=============================================--
--[[ 				驱散 					 ]]--
--=============================================--
local dispelClass = {
	PRIEST = {Disease = true},
    SHAMAN = {Curse = true},
    PALADIN = {Poison = true, Disease = true},
    DRUID = {Curse = true, Poison = true},
    MONK = {Disease = true, Poison = true},	
}

local dispellist = dispelClass[G.myClass] or {}
local dispelPriority = { Magic = 4, Curse = 3, Poison = 2, Disease = 1,}

local UpdateDispelType = function()
	if T.multicheck(G.myClass, "SHAMAN", "PALADIN", "DRUID", "PRIEST", "MONK") then
		local tree = GetSpecialization()
		
		if G.myClass == "SHAMAN" then
			dispellist.Magic = (tree == 3)
		elseif G.myClass == "PALADIN" then
			dispellist.Magic = (tree == 1)
		elseif G.myClass == "DRUID" then
			dispellist.Magic = (tree == 4)
		elseif G.myClass == "PRIEST" then
			dispellist.Magic = (tree == 1 or tree == 2)
		elseif G.myClass == "MONK" then
			dispellist.Magic = (tree == 2)
		end
	end
end

--=============================================--
--[[              点击施法                 ]]--
--=============================================--
T.RaidOnMouseOver = function(self)
    self:HookScript("OnEnter", function(self) UnitFrame_OnEnter(self) end)
    self:HookScript("OnLeave", function(self) UnitFrame_OnLeave(self) end)
end

local function UpdateClickActions(object)
	local specID = T.GetSpecID()
	local C = aCoreCDB["UnitframeOptions"]["ClickCast"][specID]
	for id, var in pairs(C) do
		for	key, info in pairs(var) do
			local key_tmp = string.gsub(key, "Click", "")
			local action = info.action
			local spell = GetSpellInfo(info.spell)
			local item = info.item
			local macro = info.macro
			
			if action == "follow" then
				object:SetAttribute(key_tmp.."type"..id, "macro")
				object:SetAttribute(key_tmp.."macrotext"..id, "/follow mouseover")
			elseif	action == "target" then
				object:SetAttribute(key_tmp.."type"..id, "target")				
			elseif	action == "focus" then		
				object:SetAttribute(key_tmp.."type"..id, "focus")
			elseif action == "menu" then
				object:SetAttribute(key_tmp.."type"..id, "togglemenu")
			elseif action == "macro" then
				object:SetAttribute(key_tmp.."type"..id, "macro")
				object:SetAttribute(key_tmp.."macrotext"..id, macro)
			elseif action == "spell" then
				object:SetAttribute(key_tmp.."type"..id, "spell")
				object:SetAttribute(key_tmp.."spell"..id, spell)
			elseif action == "item" then
				object:SetAttribute(key_tmp.."type"..id, "item")
				object:SetAttribute(key_tmp.."type"..id, string.format("item:%s", item))
			end
		end
	end
end

local RegisterClicks = function(object)
	-- EnableWheelCastOnFrame
	object:RegisterForClicks("AnyDown")
	object:SetAttribute("clickcast_onenter", [[
		self:ClearBindings()
		self:SetBindingClick(1, "MOUSEWHEELUP", self, "Button6")
		self:SetBindingClick(1, "SHIFT-MOUSEWHEELUP", self, "Button7")
		self:SetBindingClick(1, "CTRL-MOUSEWHEELUP", self, "Button8")
		self:SetBindingClick(1, "ALT-MOUSEWHEELUP", self, "Button9")
		self:SetBindingClick(1, "MOUSEWHEELDOWN", self, "Button10")
		self:SetBindingClick(1, "SHIFT-MOUSEWHEELDOWN", self, "Button11")
		self:SetBindingClick(1, "CTRL-MOUSEWHEELDOWN", self, "Button12")
		self:SetBindingClick(1, "ALT-MOUSEWHEELDOWN", self, "Button13")
	]])

	object:SetAttribute("clickcast_onleave", [[
		self:ClearBindings()
	]])
	
	UpdateClickActions(object)
end

local UnregisterClicks = function(object)
	object:SetAttribute("clickcast_onenter", nil)
	object:SetAttribute("clickcast_onleave", nil)
	
	local action, macrotext, key_tmp
	local specID = T.GetSpecID()
	local C = aCoreCDB["UnitframeOptions"]["ClickCast"][specID]
	for id, var in pairs(C) do
		for	key, _ in pairs(var) do
			key_tmp = string.gsub(key, "Click", "")
			object:SetAttribute(key_tmp.."type"..id, nil)
		end
	end
end

-- 收集应用点击施法的单位框架
G.ClickCast_Frames = {}

local function CreateClickSets(self)
	table.insert(G.ClickCast_Frames, self)
end
T.CreateClickSets = CreateClickSets

-- 启用点击施法
local Register_PendingFrames = {}

local function RegisterClicksforAll()
	for i, object in pairs(G.ClickCast_Frames) do
		if InCombatLockdown() then
			Register_PendingFrames[object] = true -- 等待脱战后生效
		else
			RegisterClicks(object)
		end
	end
	if InCombatLockdown() then
		StaticPopup_Show(G.uiname.."InCombat Alert")
	end
end
T.RegisterClicksforAll = RegisterClicksforAll

local function DelayRegisterClickSets()
	if not next(Register_PendingFrames) then return end

	for object, _ in next, Register_PendingFrames do
		RegisterClicks(object)
		Register_PendingFrames[object] = nil
	end
end

-- 禁用点击施法
local Unregister_PendingFrames = {}

local function UnregisterClicksforAll()
	for i, object in pairs(G.ClickCast_Frames) do
		if InCombatLockdown() then
			Unregister_PendingFrames[object] = true -- 等待脱战后生效
		else
			UnregisterClicks(object)
		end
	end
	if InCombatLockdown() then
		StaticPopup_Show(G.uiname.."InCombat Alert")
	end
end
T.UnregisterClicksforAll = UnregisterClicksforAll

local function DelayUnregisterClickSets()
	if not next(Unregister_PendingFrames) then return end

	for object, _ in next, Unregister_PendingFrames do
		UnregisterClicks(object)
		Unregister_PendingFrames[object] = nil
	end
end

-- 刷新点击施法
local modifier = {
	"Click",
	"shift-",
	"ctrl-",
	"alt-",
}
G.modifier = modifier

local Update_PendingFrames = {}

local function UpdateClicksforAll(id, key)
	local specID = T.GetSpecID()
	local action = aCoreCDB["UnitframeOptions"]["ClickCast"][specID][id][key]["action"]
	local spell = aCoreCDB["UnitframeOptions"]["ClickCast"][specID][id][key]["spell"]
	local item = aCoreCDB["UnitframeOptions"]["ClickCast"][specID][id][key]["item"]
	local macro = aCoreCDB["UnitframeOptions"]["ClickCast"][specID][id][key]["macro"]
	
	for i, object in pairs(G.ClickCast_Frames) do
		if InCombatLockdown() then
			Update_PendingFrames[object] = true -- 等待脱战后生效
		else
			local key_tmp = string.gsub(key, "Click", "")
			if action == "follow" then
				object:SetAttribute(key_tmp.."type"..id, "macro")
				object:SetAttribute(key_tmp.."macrotext"..id, "/follow mouseover")
			elseif	action == "target" then
				object:SetAttribute(key_tmp.."type"..id, "target")				
			elseif	action == "focus" then		
				object:SetAttribute(key_tmp.."type"..id, "focus")
			elseif action == "menu" then
				object:SetAttribute(key_tmp.."type"..id, "togglemenu")
			elseif action == "macro" then
				object:SetAttribute(key_tmp.."type"..id, "macro")
				object:SetAttribute(key_tmp.."macrotext"..id, macro)
			elseif action == "spell" then
				object:SetAttribute(key_tmp.."type"..id, "spell")
				object:SetAttribute(key_tmp.."spell"..id, spell)
			elseif action == "item" then
				object:SetAttribute(key_tmp.."type"..id, "macro")
				object:SetAttribute(key_tmp.."macrotext"..id, "/use [@mouseover]"..item)
			end	
		end
	end
	if InCombatLockdown() then
		StaticPopup_Show(G.uiname.."InCombat Alert")
	end	
end
T.UpdateClicksforAll = UpdateClicksforAll


--=============================================--
--[[              Raid Auras                 ]]--
--=============================================--
-- Debuffs
local RaidDebuff_AuraFilter = function(debuffs, unit, data)
	local spellID = data.spellId
	local dtype = data.dispelName
	
	if aCoreCDB["UnitframeOptions"]["debuff_list_black"][spellID] then -- 黑名单不显示
		return false
	elseif aCoreCDB["UnitframeOptions"]["debuff_list"][spellID] then -- 白名单显示
		return true
	elseif dispellist[dtype] then -- 可驱散
        return true
	elseif IsInInstance() then -- 副本
		local map = C_Map.GetBestMapForUnit("player")
		local InstanceID = map and EJ_GetInstanceForMap(map)
		if map and InstanceID and aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID] then -- 排除非手册副本、如场景战役
			if current_encounter == 1 then
				if not aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID][1] then
					aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID][1] = {}
				end
				
				if aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID][1][spellID] then -- 找到了
					return true
				elseif not data.isFromPlayerOrPlayerPet and aCoreCDB["UnitframeOptions"]["debuff_auto_add"] and not castByPlayer then -- 没有找到，可以添加
					aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID][1][spellID] = aCoreCDB["UnitframeOptions"]["debuff_auto_add_level"]
					print(format(L["添加团队减益"], L["杂兵"], T.GetIconLink(spellID)), format(gold_str, InstanceID, 1, spellID, L["设置"]), format(red_str, InstanceID, 1, spellID, L["删除并加入黑名单"]))
					return true
				end
			elseif current_encounter then -- BOSS战斗中
				local dataIndex = 1
				EJ_SelectInstance(InstanceID)
				local encounterName, _, encounterID, _, _, _, dungeonEncounterID = EJ_GetEncounterInfoByIndex(dataIndex, InstanceID)
				while encounterName ~= nil do
					if dungeonEncounterID == current_encounter then
						if not aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID][encounterID] then
							aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID][encounterID] = {}
						end
						
						if aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID][encounterID][spellID] then -- 找到了
							return true
						elseif not data.isFromPlayerOrPlayerPet and aCoreCDB["UnitframeOptions"]["debuff_auto_add"] and not castByPlayer then -- 没有找到，可以添加
							aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID][encounterID][spellID] = aCoreCDB["UnitframeOptions"]["debuff_auto_add_level"]
							print(format(L["添加团队减益"], encounterName, T.GetIconLink(spellID)), format(gold_str, InstanceID, encounterID, spellID, L["设置"]), format(red_str, InstanceID, encounterID, spellID, L["删除并加入黑名单"]))
							return true
						end
						break
					end
					dataIndex = dataIndex + 1
					encounterName, _, encounterID, _, _, _, dungeonEncounterID = EJ_GetEncounterInfoByIndex(dataIndex, InstanceID)
				end
			end
		end
    end
end

local GetDebuffPriority = function(data)
	local spellID = data.spellId
	local dtype = data.dispelNameW
	
	if aCoreCDB["UnitframeOptions"]["debuff_list"][spellID] then
		return aCoreCDB["UnitframeOptions"]["debuff_list"][spellID]
	elseif dispellist[dtype] then -- 可驱散
        return dispelPriority[dtype]
	elseif IsInInstance() then -- 副本
		local map = C_Map.GetBestMapForUnit("player")
		local InstanceID = map and EJ_GetInstanceForMap(map)
		for boss, info in pairs (aCoreCDB["UnitframeOptions"]["raid_debuffs"][InstanceID]) do
			if info[spellID] then
				return info[spellID]
			end
		end
	else
		return 0
	end
end

local SortDebuffs = function(a, b)
	a.priority = GetDebuffPriority(a)
	b.priority = GetDebuffPriority(b)
	
	return a.priority > b.priority or a.auraInstanceID < b.auraInstanceID
end

local PostUpdateDebuffs = function(auras, unit)
	local show_dispel
	for i = 1, #auras do
		local bu = auras[i]
		if bu and bu.Overlay:IsShown() then
			local data = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, bu.auraInstanceID)
			if data and dispellist[data.dispelName] then
				local color = auras.__owner.colors.debuff[data.dispelName]
				auras.__owner.dispelborder:SetBackdropBorderColor(unpack(color))
				auras.__owner.dispelborder:Show()
				show_dispel = true
				return
			end
		end
	end
			
	if not show_dispel then
		auras.__owner.dispelborder:Hide()
	end	
end

local CreateRaidDebuffs = function(self, unit)
	local debuffs = CreateFrame("Frame", nil, self)
	debuffs:SetFrameLevel(self:GetFrameLevel()+2)
	debuffs.initialAnchor = "BOTTOMLEFT"
	debuffs["growth-x"] = "RIGHT"
	debuffs["growth-y"] = "UP"
	debuffs.spacing = 3
	debuffs.showDebuffType = true

	debuffs.PostCreateButton = T.PostCreateIcon
	debuffs.FilterAura = RaidDebuff_AuraFilter
	debuffs.SortDebuffs = SortDebuffs
	debuffs.PostUpdate = PostUpdateDebuffs
	
	debuffs.ApplySettings =  function()			
		debuffs:SetPoint("LEFT", self, "CENTER", aCoreCDB["UnitframeOptions"]["raid_debuff_anchor_x"], aCoreCDB["UnitframeOptions"]["raid_debuff_anchor_y"])
		debuffs:SetWidth(aCoreCDB["UnitframeOptions"]["raid_debuff_icon_size"]*5+12)
		debuffs:SetHeight(aCoreCDB["UnitframeOptions"]["raid_debuff_icon_size"])
		debuffs.size = aCoreCDB["UnitframeOptions"]["raid_debuff_icon_size"]
		debuffs.num = aCoreCDB["UnitframeOptions"]["raid_debuff_num"]	
	end

	self.Debuffs = debuffs
	self.Debuffs.ApplySettings()
end

-- Buffs

local RaidBuff_AuraFilter = function(debuffs, unit, data)
	local spellID = data.spellId
	if aCoreCDB["UnitframeOptions"]["buff_list"][spellID] then
		return true
    end
end

local GetBuffPriority = function(data)
	local spellID = data.spellId
	
	if aCoreCDB["UnitframeOptions"]["buff_list"][spellID] then
		return aCoreCDB["UnitframeOptions"]["buff_list"][spellID]
	else
		return 0
    end
end

local SortBuffs = function(a, b)
	a.priority = GetBuffPriority(a)
	b.priority = GetBuffPriority(b)
	
	return a.priority > b.priority or a.auraInstanceID < b.auraInstanceID
end

local CreateRaidBuffs = function(self, unit)
	local buffs = CreateFrame("Frame", nil, self)
	buffs:SetFrameLevel(self:GetFrameLevel()+2)	
	buffs.initialAnchor = "BOTTOMLEFT"
	buffs["growth-x"] = "RIGHT"
	buffs["growth-y"] = "UP"
	buffs.spacing = 3

	buffs.PostCreateButton = T.PostCreateIcon
	buffs.FilterAura = RaidBuff_AuraFilter
	buffs.SortBuffs = SortBuffs
	
	buffs.ApplySettings =  function()			
		buffs:SetPoint("LEFT", self, "CENTER", aCoreCDB["UnitframeOptions"]["raid_buff_anchor_x"], aCoreCDB["UnitframeOptions"]["raid_buff_anchor_y"])
		buffs:SetWidth(aCoreCDB["UnitframeOptions"]["raid_buff_icon_size"]*5+12)
		buffs:SetHeight(aCoreCDB["UnitframeOptions"]["raid_buff_icon_size"])
		buffs.size = aCoreCDB["UnitframeOptions"]["raid_buff_icon_size"]
		buffs.num = aCoreCDB["UnitframeOptions"]["raid_buff_num"]	
	end

	self.Buffs = buffs
	self.Buffs.ApplySettings()
end

-- 治疗指示器
local PostCreateIndicatorIcon = function(auras, icon)
	icon.Icon:SetTexCoord(.07, .93, .07, .93)

	icon.Count:ClearAllPoints()
	icon.Count:SetPoint("BOTTOM", 0, -3)
	icon.Count:SetFontObject(nil)
	icon.Count:SetFont(G.numFont, aCoreCDB["UnitframeOptions"]["hotind_size"]*.8, "OUTLINE")
	icon.Count:SetTextColor(.9, .9, .1)

	icon.Overlay:SetTexture(G.media.blank)
	icon.Overlay:SetDrawLayer("BORDER")
	icon.Overlay:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
	icon.Overlay:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)
	
	T.createTexBackdrop(icon, nil, "BACKGROUND")
	
	icon.Cooldown.noshowcd = true
	icon.Cooldown:SetReverse(true)
end

local HealerInd_AuraFilter = function(icons, unit, data)
	if data.sourceUnit and UnitIsUnit(data.sourceUnit, "player") then -- show my buffs
		if aCoreCDB["UnitframeOptions"]["hotind_filtertype"] == "blacklist" and not aCoreCDB["UnitframeOptions"]["hotind_auralist"][data.spellId] then
			return true
		elseif aCoreCDB["UnitframeOptions"]["hotind_filtertype"] == "whitelist"	and aCoreCDB["UnitframeOptions"]["hotind_auralist"][data.spellId] then
			return true
		end
	end
end

local CreateHealIndicator = function(self, unit)
	local icons = CreateFrame("Frame", nil, self)
	icons:SetFrameLevel(self:GetFrameLevel()+2)
	icons:SetPoint("TOPRIGHT", self, "TOPRIGHT", -1, -1)	
	icons.initialAnchor = "TOPRIGHT"
	icons["growth-x"] = "LEFT"
	icons["growth-y"] = "DOWN"	
	icons.spacing = 1

	icons.numDebuffs = 1
	icons.numBuffs = 8
	
	icons.FilterAura = HealerInd_AuraFilter
	icons.PostCreateButton = PostCreateIndicatorIcon
	
	icons.EnableSettings = function(object)
		if not object or object == self then	
			if aCoreCDB["UnitframeOptions"]["hotind_style"] == "icon_ind" then
				self:EnableElement("Auras")
				self.Auras:ForceUpdate()
			else
				self:DisableElement("Auras")
			end
		end
	end
	oUF:RegisterInitCallback(icons.EnableSettings)
	
	icons.ApplySettings =  function()
		icons:SetHeight(aCoreCDB["UnitframeOptions"]["raidheight"])
		icons:SetWidth(aCoreCDB["UnitframeOptions"]["raidwidth"]-2)
		icons.size = aCoreCDB["UnitframeOptions"]["hotind_size"]
	end
	
	self.Auras = icons
	self.Auras.ApplySettings()
end
--=============================================--
--[[              Raid Frames                ]]--
--=============================================--

local func = function(self, unit)  	
	T.CreateClickSets(self)
	T.RaidOnMouseOver(self)
	
	self:RegisterForClicks"AnyUp"
	self.mouseovers = {}
	
	-- 文字/标记框体层
	self.cover = CreateFrame("Frame", nil, self)
	self.cover:SetAllPoints(self)
	self.cover:SetFrameLevel(self:GetFrameLevel()+7)
	
	-- 高亮
	self.hl = self:CreateTexture(nil, "HIGHLIGHT")
    self.hl:SetAllPoints()
    self.hl:SetTexture([[Interface\AddOns\AltzUI\media\highlight.tga]])
    self.hl:SetVertexColor( 1, 1, 1, .3)
    self.hl:SetBlendMode("ADD")
	
	-- 背景
	self.bg = self:CreateTexture(nil, 'BACKGROUND')
    self.bg:SetAllPoints(self)
	
	-- 目标边框
	local targetborder = T.createPXBackdrop(self, nil, 2)
	targetborder:SetBackdropBorderColor(1, 1, .4)
	targetborder:SetFrameLevel(self:GetFrameLevel()+6)
	targetborder:Hide()
	targetborder.ShowPlayer =  true
	
	self.TargetIndicator = targetborder
	
	-- 驱散边框
	self.dispelborder = T.createPXBackdrop(self, nil, 2)
	self.dispelborder:SetFrameLevel(self:GetFrameLevel()+5)
	self.dispelborder:Hide()

	-- 仇恨边框
	local threatborder = T.createPXBackdrop(self, nil, 2)
	threatborder:SetFrameLevel(self:GetFrameLevel()+4)
	threatborder:Hide()
	
	threatborder.Override = Override_ThreatUpdate
	self.ThreatIndicator = threatborder
	
	-- 生命条
    local hp = T.createStatusbar(self, nil, nil, 1, 1, 1, 1)
	hp:SetAllPoints(self)
	hp:SetFrameLevel(self:GetFrameLevel())
	hp:SetReverseFill(true)
	
	hp.backdrop = T.createBackdrop(hp)
	
	hp.cover = hp:CreateTexture(nil, "BACKGROUND")
    hp.cover:SetAllPoints(hp)
	hp.cover:SetTexture(G.media.blank)
	
	hp.ind = hp:CreateTexture(nil, "OVERLAY", nil, 1)
    hp.ind:SetTexture("Interface\\Buttons\\WHITE8x8")
	hp.ind:SetVertexColor(0, 0, 0)
	hp.ind:SetSize(1, 45)
	hp.ind:SetPoint("RIGHT", hp:GetStatusBarTexture(), "LEFT", 0, 0)
	
	hp.ApplySettings = function()
		T.ApplyHealthThemeSettings(self, hp)
		
		hp.ind:SetSize(1, aCoreCDB["UnitframeOptions"]["raidheight"])
	end
	
	hp.colorDisconnected = true	
	hp.PostUpdateColor = T.PostUpdate_HealthColor
	hp.PostUpdate = T.PostUpdate_Health
	
	self.Health = hp
	self.Health.ApplySettings()
	
	-- 治疗蓝条
	local pp = T.createStatusbar(self)
	pp:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT")
	pp:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
	pp:SetFrameLevel(self:GetFrameLevel()+3)
	
	pp.backdrop = T.createBackdrop(hp)
	
	pp.bg = pp:CreateTexture(nil, 'BACKGROUND')
	pp.bg:SetAllPoints(pp)
	pp.bg.multiplier = .2
	
	pp.ApplySettings = function()		
		pp:SetHeight(aCoreCDB["UnitframeOptions"]["raidheight"]*aCoreCDB["UnitframeOptions"]["raidppheight"])
		
		T.ApplyPowerThemeSettings(pp)
	end
	
	pp.PostUpdateColor = T.PostUpdate_PowerColor
	pp.PostUpdate = T.PostUpdate_Power
	
	self.Power = pp
	self.Power.ApplySettings()
	
	-- GCD
	local gcd = CreateFrame("StatusBar", nil, self)
    gcd:SetAllPoints(self)
    gcd:SetStatusBarTexture(G.media.blank)
    gcd:SetStatusBarColor(1, 1, 1, .4)
    gcd:SetFrameLevel(self:GetFrameLevel()+2)
	
	gcd.EnableSettings = function(object)
		if not object or object == self then	
			if aCoreCDB["UnitframeOptions"]["showgcd"] then
				self:EnableElement("GCD")
			else
				self:DisableElement("GCD")
			end
		end
	end
	oUF:RegisterInitCallback(gcd.EnableSettings)
	
    self.GCD = gcd
	
	-- 治疗预估和吸收
	local hp_predict = {
		myBar = CreateHealPreditionBar(self, .4, .8, 0),
		otherBar = CreateHealPreditionBar(self, 0, .4, 0),
		absorbBar = CreateHealPreditionBar(self, .2, 1, 1, .7),
		healAbsorbBar = CreateHealPreditionBar(self, 1, 0, 1, .7),		
		maxOverflow = 1.05,
	}
	
	hp_predict.otherBar:SetPoint('LEFT', hp_predict.myBar:GetStatusBarTexture(), 'RIGHT')
	hp_predict.absorbBar:SetPoint('LEFT', hp_predict.otherBar:GetStatusBarTexture(), 'RIGHT')
 
	hp_predict.EnableSettings = function(object)
		if not object or object == self then	
			if aCoreCDB["UnitframeOptions"]["healprediction"] then
				self:EnableElement("HealthPrediction")				
			else
				self:DisableElement("HealthPrediction")
			end
		end
	end
	oUF:RegisterInitCallback(hp_predict.EnableSettings)
	
	hp_predict.ApplySettings = function()
		if aCoreCDB["SkinOptions"]["style"] ~= 3 then
			hp_predict.myBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'LEFT')
			hp_predict.healAbsorbBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'LEFT')
		else
			hp_predict.myBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
			hp_predict.healAbsorbBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
		end
	end
	
	self.HealthPrediction = hp_predict
	self.HealthPrediction.ApplySettings()
	
	-- 团队减益
	CreateRaidDebuffs(self, unit)
	
	-- 团队增益
	CreateRaidBuffs(self, unit)
	
	-- 治疗边角指示器（图标）
	CreateHealIndicator(self, unit)
	
	-- 治疗边角指示器（数字）
	local ind_number = CreateFrame("Frame", nil, self)
	ind_number:SetAllPoints()
	
	ind_number.EnableSettings = function(object)
		if not object or object == self then	
			if aCoreCDB["UnitframeOptions"]["hotind_style"] == "number_ind" then
				self:EnableElement("AltzIndicators")
				self:UpdateTags()
			else
				self:DisableElement("AltzIndicators")
			end
		end
	end
	oUF:RegisterInitCallback(ind_number.EnableSettings)
	
	ind_number.ApplySettings = function()
		ind_number.AuraStatusBL:SetFont(G.norFont, aCoreCDB["UnitframeOptions"]["hotind_size"], "OUTLINE")
		ind_number.AuraStatusBR:SetFont(G.symbols, aCoreCDB["UnitframeOptions"]["hotind_size"], "OUTLINE")
		ind_number.AuraStatusTL:SetFont(G.norFont, aCoreCDB["UnitframeOptions"]["hotind_size"], "OUTLINE")
		if G.myClass == "DRUID" or G.myClass == "MONK" or G.myClass == "PRIEST" or G.myClass == "SHAMAN" then
			ind_number.AuraStatusTR:SetFont(G.norFont, aCoreCDB["UnitframeOptions"]["hotind_size"], "OUTLINE") -- 数字
		else
			ind_number.AuraStatusTR:SetFont(G.symbols, aCoreCDB["UnitframeOptions"]["hotind_size"], "OUTLINE") -- 符号
		end
		if G.myClass == "DRUID" or G.myClass == "PRIEST" then
			ind_number.AuraStatusCen:SetFont(G.norFont, aCoreCDB["UnitframeOptions"]["hotind_size"], "OUTLINE") -- 文字
		else
			ind_number.AuraStatusCen:SetFont(G.symbols, aCoreCDB["UnitframeOptions"]["hotind_size"]/2, "OUTLINE") -- 符号
		end
	end
	
	self.AltzIndicators = ind_number	
		
	-- 团队领袖
	local leader = self.cover:CreateTexture(nil, "OVERLAY", nil, 1)
    leader:SetSize(10, 10)
    leader:SetPoint("BOTTOMLEFT", self.cover, "BOTTOMLEFT", 0, -5)
    self.LeaderIndicator = leader
	
	-- 团队助手
	local assistant = self.cover:CreateTexture(nil, "OVERLAY", nil, 1)
    assistant:SetSize(10, 10)
    assistant:SetPoint("BOTTOMLEFT", self.cover, "BOTTOMLEFT", 0, -5)
	self.AssistantIndicator = assistant
	
	-- 团队拾取
    local masterlooter = self.cover:CreateTexture(nil, 'OVERLAY', nil, 1)
    masterlooter:SetSize(10, 10)
    masterlooter:SetPoint('LEFT', leader, 'RIGHT', 0, 1)
    self.MasterLooterIndicator = masterlooter
	
	-- 主坦克、主助理标记
	local raidrole = self.cover:CreateTexture(nil, 'OVERLAY', nil, 1)
	raidrole:SetSize(10, 10)
	raidrole:SetPoint('LEFT', masterlooter, 'RIGHT')
	
	raidrole.EnableSettings = function(object)
		if not object or object == self then	
			if aCoreCDB["UnitframeOptions"]["raidrole_icon"] then
				self:EnableElement("RaidRoleIndicator")
				self.RaidRoleIndicator:ForceUpdate()
			else
				self:DisableElement("RaidRoleIndicator")
			end
		end
	end
	oUF:RegisterInitCallback(raidrole.EnableSettings)
	
	self.RaidRoleIndicator = raidrole
	
	-- 团队标记
	local ricon = self.cover:CreateTexture(nil, "OVERLAY", nil, 1)
	ricon:SetSize(18 ,18)
    ricon:SetPoint("RIGHT", self.cover, "TOP", -8 , 0)
	ricon:SetTexture[[Interface\AddOns\AltzUI\media\raidicons.blp]]
	
    self.RaidTargetIndicator = ricon
	
	-- 复活标记
	local resurrecticon = self.cover:CreateTexture(nil, "OVERLAY")
    resurrecticon:SetSize(16, 16)
    resurrecticon:SetPoint("CENTER")
    self.ResurrectIndicator = resurrecticon
	
	-- 就位确认
    local readycheck = self.cover:CreateTexture(nil, 'OVERLAY', nil, 3)
    readycheck:SetSize(16, 16)
    readycheck:SetPoint("CENTER")
    self.ReadyCheckIndicator = readycheck
	
	-- 召唤标记
	local summonIndicator = self.cover:CreateTexture(nil, 'OVERLAY')
	summonIndicator:SetSize(32, 32)
	summonIndicator:SetPoint('CENTER')
	summonIndicator:SetAtlas('Raid-Icon-SummonPending', true)
	summonIndicator:Hide()
	
	self.SummonIndicator = summonIndicator
	
	-- 团队职责
	local lfd =  T.createtext(self.cover, "OVERLAY", 13, "OUTLINE", "CENTER")
	lfd:SetFont(G.symbols, 7, "OUTLINE")
	lfd:SetPoint("BOTTOM", self.cover, 0, -1)
	
	lfd.ApplySettings = function()
		lfd:SetFont(G.symbols, aCoreCDB["UnitframeOptions"]["raidfontsize"]-3, "OUTLINE")
	end
	
	self:Tag(lfd, '[Altz:LFD]')
	self.Tag_LFD = lfd
	lfd.ApplySettings()
	
	-- 名字
	local raidname = T.createtext(hp, "OVERLAY", 10, "OUTLINE", "RIGHT")
	raidname:SetPoint("BOTTOMRIGHT", hp, "BOTTOMRIGHT", -1, 5)
	
	raidname.ApplySettings = function()
		raidname:SetFont(G.norFont, aCoreCDB["UnitframeOptions"]["raidfontsize"], "OUTLINE")
	end
	
	self:Tag(raidname, '[Altz:hpraidname]')
	self.Tag_Name = raidname
	raidname.ApplySettings()
	
	-- 勿扰 暂离 离线 死亡 灵魂
	local status = T.createtext(hp, "OVERLAY", 8, "OUTLINE", "LEFT")
    status:SetPoint("TOPLEFT")
	
	status.ApplySettings = function()
		status:SetFont(G.norFont, aCoreCDB["UnitframeOptions"]["raidfontsize"]-2, "OUTLINE")
	end
	
	self:Tag(status, '[Altz:AfkDnd][Altz:DDG]')
	self.Tag_Status = status
	status.ApplySettings()
	
	-- 距离指示
    local range = {
        insideAlpha = 1,
        outsideAlpha = 0.3,
    }
	self.Range = range
end

oUF:RegisterStyle("Altz_Healerraid", func)

local initconfig = [[
	self:SetWidth(%d)
    self:SetHeight(%d)

	local header = self:GetParent()
	local clique = header:GetFrameRef("clickcast_header")
	
	if(clique) then
		clique:SetAttribute("clickcast_button", self)
		clique:RunAttribute("clickcast_register")
	end
]]

local GetGroupfilter = function()
	if aCoreCDB["UnitframeOptions"]["party_num"] == 2 then
		return "1,2"
	elseif aCoreCDB["UnitframeOptions"]["party_num"] == 4 then
		return "1,2,3,4"
	elseif aCoreCDB["UnitframeOptions"]["party_num"] == 6 then
		return "1,2,3,4,5,6"
	else
		return "1,2,3,4,5,6,7,8"
	end
end

local RaidFrame = CreateFrame("Frame", "Altz_Raid_Holder", UIParent)
RaidFrame.movingname = L["团队框架"]
RaidFrame.point = {
	healer = {a1 = "CENTER", parent = "UIParent", a2 = "BOTTOM", x = 0, y = 225},
	dpser = {a1 = "BOTTOMLEFT", parent = "UIParent", a2 = "BOTTOMLEFT", x = 10, y = 250},
}
T.CreateDragFrame(RaidFrame)
G.RaidFrame = RaidFrame

local RaidPetFrame = CreateFrame("Frame", "Altz_RaidPet_Holder", UIParent)
RaidPetFrame.movingname = PET.." "..L["团队框架"]
RaidPetFrame.point = {
	healer = {a1 = "TOPLEFT", parent = "Altz_Raid_Holder", a2 = "TOPRIGHT", x = 10, y = 0},
	dpser = {a1 = "TOPLEFT", parent = "Altz_Raid_Holder", a2 = "TOPRIGHT", x = 10, y = 0},
}
T.CreateDragFrame(RaidPetFrame)
G.RaidPetFrame = RaidPetFrame

local function Spawnraid()
	oUF:SetActiveStyle"Altz_Healerraid"
	
	for i = 1, 8 do
		RaidFrame[i] = oUF:SpawnHeader(i== 1 and 'Altz_HealerRaid' or 'Altz_HealerRaid'..i, nil, aCoreCDB["UnitframeOptions"]["raidframe_inparty"] and 'raid,party,solo' or 'raid,solo',
			'oUF-initialConfigFunction', initconfig:format(aCoreCDB["UnitframeOptions"]["raidwidth"], aCoreCDB["UnitframeOptions"]["raidheight"]),
			'showPlayer', true,
			'showSolo', true,
			'showParty', true,
			'showRaid', true,
			'xOffset', 5,
			'yOffset', -5,
			'point', "LEFT",
			'groupFilter', '1,2,3,4,5,6,7,8',
			'groupingOrder', '1,2,3,4,5,6,7,8',
			'groupBy', 'GROUP',
			'maxColumns', 1,
			'unitsPerColumn', 5,
			'columnSpacing', 5,
			'columnAnchorPoint', "TOP"
		)
	end

	RaidPetFrame[1] = oUF:SpawnHeader('Altz_HealerPetRaid', 'SecureGroupPetHeaderTemplate', aCoreCDB["UnitframeOptions"]["raidframe_inparty"] and 'raid,PartyFrame,solo' or 'raid,solo',
		'oUF-initialConfigFunction', initconfig:format(aCoreCDB["UnitframeOptions"]["raidwidth"], aCoreCDB["UnitframeOptions"]["raidheight"]),
		'showPlayer', true,
		'showSolo', true,
		'showParty', true,
		'showRaid', true,
		'xOffset', 5,
		'yOffset', -5,
		'point', "LEFT",
		'groupFilter', GetGroupfilter(),
		'groupingOrder', '1,2,3,4,5,6,7,8',
		'groupBy', 'GROUP',
		'maxColumns', 8,
		'unitsPerColumn', 5,
		'columnSpacing', 5,
		'columnAnchorPoint', "TOP",
		--'useOwnerUnit', true,
		'unitsuffix', 'pet'
	)
end

T.UpdateGroupAnchor = function()
	local oUF = AltzUF or oUF
	for _, obj in next, oUF.objects do	
		if obj.style == 'Altz_Healerraid' then
			obj:ClearAllPoints()
		end
	end
	
	for i = 1, 8 do
		RaidFrame[i]:ClearAllPoints()
		if i == 1 then
			RaidFrame[i]:SetPoint("TOPLEFT", RaidFrame, "TOPLEFT", 0, 0)
		elseif aCoreCDB["UnitframeOptions"]["hor_party"] then -- 水平小队
			RaidFrame[i]:SetPoint("TOPLEFT", RaidFrame[i-1], "BOTTOMLEFT", 0, -5)
		else -- 垂直小队
			RaidFrame[i]:SetPoint("TOPLEFT", RaidFrame[i-1], "TOPRIGHT", 5, 0)
		end
		RaidFrame[i]:SetAttribute('point', aCoreCDB["UnitframeOptions"]["hor_party"] and "LEFT" or "TOP")
		RaidFrame[i]:SetAttribute('columnAnchorPoint', aCoreCDB["UnitframeOptions"]["hor_party"] and "TOP" or "LEFT")
	end
	
	RaidPetFrame[1]:ClearAllPoints()
	RaidPetFrame[1]:SetPoint("TOPLEFT", RaidPetFrame, "TOPLEFT")
	RaidPetFrame[1]:SetAttribute('point', aCoreCDB["UnitframeOptions"]["hor_party"] and "LEFT" or "TOP")
	RaidPetFrame[1]:SetAttribute('columnAnchorPoint', aCoreCDB["UnitframeOptions"]["hor_party"] and "TOP" or "LEFT")
end

T.UpdateGroupSize = function()
	local group_member_size = min(GetNumGroupMembers(), aCoreCDB["UnitframeOptions"]["party_num"]*5)
	local w, h = aCoreCDB["UnitframeOptions"]["raidwidth"], aCoreCDB["UnitframeOptions"]["raidheight"]
	if aCoreCDB["UnitframeOptions"]["hor_party"] then
		if group_member_size > 30 then -- 7~8个队伍
			h = h*.5
		elseif group_member_size > 20 then -- 5~6个队伍
			h = h*.75
		end
	else
		if group_member_size > 30 then -- 7~8个队伍
			w = w*.5
		elseif group_member_size > 20 then -- 5~6个队伍
			w = w*.75
		end
	end
	
	local oUF = AltzUF or oUF	
	for _, obj in next, oUF.objects do	
		if obj.style == 'Altz_Healerraid' then
			obj:SetSize(w, h)
		end
	end
	
	if aCoreCDB["UnitframeOptions"]["hor_party"] then
		if group_member_size > 30 then -- 7~8个队伍
			RaidFrame:SetSize(5*(w+5)-5, 8*(h+5)-5)
		elseif group_member_size > 20 then -- 5~6个队伍
			RaidFrame:SetSize(5*(w+5)-5, 6*(h+5)-5)			
		else
			RaidFrame:SetSize(5*(w+5)-5, 4*(h+5)-5)
		end
		RaidPetFrame:SetSize(5*(w+5)-5, h)
	else
		if group_member_size > 30 then -- 7~8个队伍
			RaidFrame:SetSize(8*(w+5)-5, 5*(h+5)-5)
		elseif group_member_size > 20 then -- 5~6个队伍
			RaidFrame:SetSize(6*(w+5)-5, 5*(h+5)-5)			
		else
			RaidFrame:SetSize(4*(w+5)-5, 5*(h+5)-5)
		end
		RaidPetFrame:SetSize(w, 5*(h+5)-5)
	end
end
	
T.UpdateGroupfilter = function()
	if not RaidFrame[1] then return end
		
	if not aCoreCDB["UnitframeOptions"]["party_connected"] then -- 小队分离
		for i = 1, 8 do
			RaidFrame[i]:SetAttribute("groupFilter", (i <= aCoreCDB["UnitframeOptions"]["party_num"]) and tostring(i) or '')
		end
	else
		for i = 1, 8 do
			if i == 1 then
				RaidFrame[i]:SetAttribute("groupFilter", GetGroupfilter())
			else
				RaidFrame[i]:SetAttribute("groupFilter", '')
			end
		end
	end
	
	RaidFrame[1]:SetAttribute("showSolo", aCoreCDB["UnitframeOptions"]["showsolo"])
	
	if aCoreCDB["UnitframeOptions"]["showraidpet"] then
		RaidPetFrame[1]:SetAttribute("groupFilter", GetGroupfilter())
		T.RestoreDragFrame(RaidPetFrame)
	else
		RaidPetFrame[1]:SetAttribute("groupFilter", '')
		T.ReleaseDragFrame(RaidPetFrame)
	end
end

--=============================================--
--[[                Events                   ]]--
--=============================================--
local EventFrame = CreateFrame("Frame")

EventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_REGEN_ENABLED" then
		if aCoreCDB["UnitframeOptions"]["enableClickCast"] then
			DelayRegisterClickSets()
			DelayUnregisterClickSets()
		end
	elseif event == "PLAYER_SPECIALIZATION_CHANGED" then
		UpdateDispelType()
		
		for i, object in pairs(G.ClickCast_Frames) do
			UpdateClickActions(object)
		end
		local options = G.ClickcastOptions
		if options:IsShown() then -- force GUI update
			options:Hide()
			options:Show()
		end
	elseif event == "ENCOUNTER_START" then
		local encounterID = ...
		current_encounter = encounterID
	elseif event == "ENCOUNTER_END" then
		current_encounter = 1
	elseif event == "PLAYER_LOGIN" then		
		if aCoreCDB["UnitframeOptions"]["enableClickCast"] then
			RegisterClicksforAll()
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		current_encounter = 1
		UpdateHealManabar()
		UpdateDispelType()
	elseif event == "GROUP_ROSTER_UPDATE" then
		UpdateHealManabar()
		T.UpdateGroupSize()
	end
end)

T.RegisterInitCallback(function()
	if not aCoreCDB["UnitframeOptions"]["enableraid"] then return end	
	
	-- Hide Default RaidFrame
	if CompactRaidFrameManager_SetSetting then
		CompactRaidFrameManager_SetSetting("IsShown", "0")
		CompactRaidFrameManager:UnregisterAllEvents()
		CompactRaidFrameManager:HookScript("OnShow", function()
			CompactRaidFrameManager_SetSetting("IsShown", "0")
		end)
	end

	Spawnraid()
	T.UpdateGroupAnchor()
	T.UpdateGroupSize()
	T.UpdateGroupfilter()
	
	EventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
	EventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	EventFrame:RegisterEvent("ENCOUNTER_START")
	EventFrame:RegisterEvent("ENCOUNTER_END")	
	EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	EventFrame:RegisterEvent("PLAYER_LOGIN")
	EventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")	
end)