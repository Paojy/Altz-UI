local T, C, L, G = unpack(select(2, ...))
local oUF = AltzUF or oUF

--=============================================--
--[[               Some update               ]]--
--=============================================--
local pxbackdrop = { edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=],  edgeSize = 2, }

local function Createpxborder(self, lvl)
	local pxbd = CreateFrame("Frame", nil, self, "BackdropTemplate")
	pxbd:SetPoint("TOPLEFT", self, "TOPLEFT", -3, 3)
	pxbd:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 3, -3)
	pxbd:SetBackdrop(pxbackdrop)
	pxbd:SetFrameLevel(lvl)
	pxbd:Hide()
	return pxbd
end

local function ChangedTarget(self, event, unit)
	if UnitIsUnit('target', self.unit) then
		self.targetborder:Show()
	else
		self.targetborder:Hide()
	end
end

local function UpdateThreat(self, event, unit)	
	if (self.unit ~= unit) then return end
	
	unit = unit or self.unit
	local threat = UnitThreatSituation(unit)
	
	if threat and threat > 1 then
		local r, g, b = GetThreatStatusColor(threat)
		self.threatborder:SetBackdropBorderColor(r, g, b)
		self.threatborder:Show()
	else
		self.threatborder:Hide()
	end
end

local function healpreditionbar(self, ...)
	local hpb = CreateFrame('StatusBar', nil, self.Health)
	hpb:SetFrameLevel(4)
	hpb:SetStatusBarTexture("Interface\\RaidFrame\\Shield-Fill")
	hpb:GetStatusBarTexture():SetBlendMode("ADD")
	hpb:SetStatusBarColor(...)
	hpb:SetPoint('TOP')
	hpb:SetPoint('BOTTOM')
	
	hpb:SetWidth(aCoreCDB["UnitframeOptions"]["raidwidth"])
	return hpb
end

local HealerInd_AuraFilter = function(icons, unit, data)
	if data.sourceUnit == "player" then -- show my buffs
		if aCoreCDB["UnitframeOptions"]["hotind_filtertype"] == "blacklist" and not aCoreCDB["UnitframeOptions"]["hotind_auralist"][data.spellId] then
			return true
		elseif aCoreCDB["UnitframeOptions"]["hotind_filtertype"] == "whitelist"	and aCoreCDB["UnitframeOptions"]["hotind_auralist"][data.spellId] then
			return true
		end
	end
end

local PostCreateIndicatorIcon = function(auras, icon)
	icon.Icon:SetTexCoord(.07, .93, .07, .93)

	icon.Count:ClearAllPoints()
	icon.Count:SetPoint("BOTTOM", 0, -3)
	icon.Count:SetFontObject(nil)
	icon.Count:SetFont(G.numFont, aCoreCDB["UnitframeOptions"]["hotind_size"]*.8, "OUTLINE")
	icon.Count:SetTextColor(.9, .9, .1)

	icon.Overlay:SetTexture(G.media.blank)
	icon.Overlay:SetDrawLayer("BACKGROUND")
	icon.Overlay:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
	icon.Overlay:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)

	icon.backdrop = T.createPXBackdrop(icon)

	icon.Cooldown.noshowcd = true
	icon.Cooldown:SetReverse(true)
end
--=============================================--
--[[              Click Cast                 ]]--
--=============================================--
T.RaidOnMouseOver = function(self)
    self:HookScript("OnEnter", function(self) UnitFrame_OnEnter(self) end)
    self:HookScript("OnLeave", function(self) UnitFrame_OnLeave(self) end)
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
	
	local C = aCoreCDB["UnitframeOptions"]["ClickCast"]
	for id, var in pairs(C) do
		for	key, info in pairs(var) do
			local key_tmp = string.gsub(key, "Click", "")
			local action = info.action
			local spell = info.spell
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

local UnregisterClicks = function(object)
	object:SetAttribute("clickcast_onenter", nil)
	object:SetAttribute("clickcast_onleave", nil)
	
	local action, macrotext, key_tmp
	local C = aCoreCDB["UnitframeOptions"]["ClickCast"]
	for id, var in pairs(C) do
		for	key, _ in pairs(var) do
			key_tmp = string.gsub(key, "Click", "")
			object:SetAttribute(key_tmp.."type"..id, nil)
		end
	end
end

-- 收集应用点击施法的单位框体
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
	local action = aCoreCDB["UnitframeOptions"]["ClickCast"][id][key]["action"]
	local spell = aCoreCDB["UnitframeOptions"]["ClickCast"][id][key]["spell"]
	local item = aCoreCDB["UnitframeOptions"]["ClickCast"][id][key]["item"]
	local macro = aCoreCDB["UnitframeOptions"]["ClickCast"][id][key]["macro"]
	
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
--[[              Raid Frames                ]]--
--=============================================--

local func = function(self, unit)  	
	T.CreateClickSets(self)
	T.RaidOnMouseOver(self)
	
	self:RegisterForClicks"AnyUp"
	self.mouseovers = {}
	
	-- highlight --
	self.hl = self:CreateTexture(nil, "HIGHLIGHT")
    self.hl:SetAllPoints()
    self.hl:SetTexture(G.media.barhightlight)
    self.hl:SetVertexColor( 1, 1, 1, .3)
    self.hl:SetBlendMode("ADD")
	
	-- background --
	self.bg = self:CreateTexture(nil, 'BACKGROUND')
    self.bg:SetAllPoints(self)
	
	-- target border --
	self.targetborder = Createpxborder(self, 2)
	self.targetborder:SetBackdropBorderColor(1, 1, .4)
	self:RegisterEvent("PLAYER_TARGET_CHANGED", ChangedTarget, true)

	-- threat border --
	self.threatborder = Createpxborder(self, 1)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UpdateThreat, true)
	
	-- health bar --
    local hp = T.createStatusbar(self, nil, nil, 1, 1, 1, 1)
	hp:SetAllPoints(self)
	hp:SetReverseFill(true)
	
	hp.backdrop = T.createBackdrop(hp)
	
	hp.cover = hp:CreateTexture(nil, 'OVERLAY')
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
	
	-- raid manabars --
	local pp = T.createStatusbar(self)
	pp:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT")
	pp:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
	
	pp.backdrop = T.createBackdrop(hp)
	
	pp.bg = pp:CreateTexture(nil, 'BACKGROUND')
	pp.bg:SetAllPoints(pp)
	pp.multiplier = .2
	
	pp.EnableSettings = function(object)
		if not object or object == self then	
			if aCoreCDB["UnitframeOptions"]["raidmanabars"] then			
				self:EnableElement("Power")
				self.Power:ForceUpdate()
			else
				self:DisableElement("Power")
			end
		end
	end
	oUF:RegisterInitCallback(pp.EnableSettings)
	
	pp.ApplySettings = function()		
		pp:SetHeight(aCoreCDB["UnitframeOptions"]["raidheight"]*aCoreCDB["UnitframeOptions"]["raidppheight"])
		
		T.ApplyPowerThemeSettings(pp)
	end
	
	pp.PostUpdateColor = T.PostUpdate_PowerColor
	pp.PostUpdate = T.PostUpdate_Power
	
	self.Power = pp
	self.Power.ApplySettings()
	
	-- gcd frane --
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
	
	-- heal prediction --
	local hp_predict = {
		myBar = healpreditionbar(self, .4, .8, 0, .5),
		otherBar = healpreditionbar(self, 0, .4, 0, .5),
		absorbBar = healpreditionbar(self, .2, 1, 1, .7),
		maxOverflow = 1.2,
	}
	
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
			hp_predict.otherBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'LEFT')
			hp_predict.absorbBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'LEFT')
		else
			hp_predict.myBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
			hp_predict.otherBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
			hp_predict.absorbBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
		end
	end
	
	self.HealthPrediction = hp_predict
	hp_predict.ApplySettings()
	
	-- 团队领袖
	local leader = hp:CreateTexture(nil, "OVERLAY", nil, 1)
    leader:SetSize(10, 10)
    leader:SetPoint("BOTTOMLEFT", hp, "BOTTOMLEFT", 0, -5)
    self.LeaderIndicator = leader
	
	-- 团队助手
	local assistant = hp:CreateTexture(nil, "OVERLAY", nil, 1)
    assistant:SetSize(10, 10)
    assistant:SetPoint("BOTTOMLEFT", hp, "BOTTOMLEFT", 0, -5)
	self.AssistantIndicator = assistant
	
	-- 团队拾取
    local masterlooter = hp:CreateTexture(nil, 'OVERLAY', nil, 1)
    masterlooter:SetSize(10, 10)
    masterlooter:SetPoint('LEFT', leader, 'RIGHT', 0, 1)
    self.MasterLooterIndicator = masterlooter
	
	-- 主坦克、主助理标记
	local raidrole = hp:CreateTexture(nil, 'OVERLAY', nil, 1)
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
	local ricon = hp:CreateTexture(nil, "OVERLAY", nil, 1)
	ricon:SetSize(18 ,18)
    ricon:SetPoint("RIGHT", hp, "TOP", -8 , 0)
	ricon:SetTexture[[Interface\AddOns\AltzUI\media\raidicons.blp]]
	
    self.RaidTargetIndicator = ricon
	
	-- 复活标记
	local resurrecticon = hp:CreateTexture(nil, "OVERLAY")
    resurrecticon:SetSize(16, 16)
    resurrecticon:SetPoint"CENTER"
    self.ResurrectIndicator = resurrecticon
	
	-- 就位确认
    local readycheck = hp:CreateTexture(nil, 'OVERLAY', nil, 3)
    readycheck:SetSize(16, 16)
    readycheck:SetPoint"CENTER"
    self.ReadyCheckIndicator = readycheck
	
	-- 召唤标记
	local summonIndicator = self:CreateTexture(nil, 'OVERLAY')
    summonIndicator:SetSize(32, 32)
    summonIndicator:SetPoint('TOPRIGHT', self)
	summonIndicator:SetAtlas('Raid-Icon-SummonPending', true)
	summonIndicator:Show()
    self.SummonIndicator = summonIndicator
	
	-- 团队职责
	local lfd =  T.createtext(hp, "OVERLAY", 13, "OUTLINE", "CENTER")
	lfd:SetFont(G.symbols, 7, "OUTLINE")
	lfd:SetPoint("BOTTOM", hp, 0, -1)
	
	lfd.ApplySettings = function()
		lfd:SetFont(G.symbols, aCoreCDB["UnitframeOptions"]["raidfontsize"]-3, "OUTLINE")
	end
	
	self:Tag(lfd, '[Altz:LFD]')
	self.Tag_LFD = lfd
	lfd.ApplySettings()
	
	-- 名字
	local raidname = T.createtext(hp, "ARTWORK", 10, "OUTLINE", "RIGHT")
	raidname:SetPoint("BOTTOMRIGHT", hp, "BOTTOMRIGHT", -1, 5)
	
	raidname.ApplySettings = function()
		raidname:SetFont(G.norFont, aCoreCDB["UnitframeOptions"]["raidfontsize"], "OUTLINE")
	end
	
	self:Tag(raidname, '[Altz:hpraidname]')
	self.Tag_Name = raidname
	raidname.ApplySettings()
	
	-- 勿扰 暂离 离线 死亡 灵魂
	local status = T.createtext(hp, "OVERLAY", 8, "OUTLINE", "LEFT")
    status:SetPoint"TOPLEFT"
	
	status.ApplySettings = function()
		status:SetFont(G.norFont, aCoreCDB["UnitframeOptions"]["raidfontsize"]-2, "OUTLINE")
	end
	
	self:Tag(status, '[Altz:AfkDnd][Altz:DDG]')
	self.Tag_Status = status
	status.ApplySettings()
	
	-- 团队减益
	local Auras = CreateFrame("Frame", nil, self)
	Auras:SetFrameLevel(self:GetFrameLevel()+1)
	self.AltzAuras2 = Auras
	
	-- 团队增益
    local Tankbuff = CreateFrame("Frame", nil, self)
	Tankbuff:SetFrameLevel(self:GetFrameLevel()+1)
	self.AltzTankbuff = Tankbuff
	
	-- 治疗边角指示器（数字）
	local ind_number = CreateFrame("Frame", nil, self)
	ind_number:SetAllPoints()
	
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
	
	self.AltzIndicators = ind_number	
	
	-- 治疗边角指示器（图标）
	local ind_icon = CreateFrame("Frame", nil, self)
	ind_icon.spacing = 1
	ind_icon:SetPoint("TOPRIGHT", self, "TOPRIGHT", -1, -1)
	ind_icon.initialAnchor = "TOPRIGHT"
	ind_icon["growth-x"] = "LEFT"
	ind_icon["growth-y"] = "DOWN"
	ind_icon.numDebuffs = 1
	ind_icon.numBuffs = 8
	ind_icon.FilterAura = HealerInd_AuraFilter
	ind_icon.PostCreateButton = PostCreateIndicatorIcon
	
	ind_icon.EnableSettings = function(object)
		if not object or object == self then	
			if aCoreCDB["UnitframeOptions"]["hotind_style"] == "icon_ind" then
				self:EnableElement("Auras")
				self.Auras:ForceUpdate()
			else
				self:DisableElement("Auras")
			end
		end
	end
	oUF:RegisterInitCallback(ind_icon.EnableSettings)
	
	ind_icon.ApplySettings =  function()
		ind_icon:SetHeight(aCoreCDB["UnitframeOptions"]["raidheight"])
		ind_icon:SetWidth(aCoreCDB["UnitframeOptions"]["raidwidth"]-2)
		ind_icon.size = aCoreCDB["UnitframeOptions"]["hotind_size"]
	end
	
	self.Auras = ind_icon
	ind_icon.ApplySettings()

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

local groupingOrder = {
	["GROUP"] = "1,2,3,4,5,6,7,8",
	["CLASS"] = "WARRIOR, DEATHKNIGHT, PALADIN, WARLOCK, SHAMAN, MAGE, MONK, HUNTER, PRIEST, ROGUE, DRUID",
	["ROLE"] = "TANK, HEALER, DAMAGER"
}

local RaidFrame = CreateFrame("Frame", "Altz_Raid_Holder", UIParent)
RaidFrame.movingname = L["团队框架"]
RaidFrame.point = {
	healer = {a1 = "CENTER", parent = "UIParent", a2 = "BOTTOM", x = 0, y = 225},
	dpser = {a1 = "BOTTOMLEFT", parent = "UIParent", a2 = "BOTTOMLEFT", x = 10, y = 250},
}
T.CreateDragFrame(RaidFrame)

local RaidPetFrame = CreateFrame("Frame", "Altz_RaidPet_Holder", UIParent)
RaidPetFrame.movingname = PET.." "..L["团队框架"]
RaidPetFrame.point = {
	healer = {a1 = "TOPLEFT", parent = "Altz_Raid_Holder", a2 = "TOPRIGHT", x = 10, y = 0},
	dpser = {a1 = "TOPLEFT", parent = "Altz_Raid_Holder", a2 = "TOPRIGHT", x = 10, y = 0},
}
T.CreateDragFrame(RaidPetFrame)

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
	local oUF = AltzUF or oUF
	for _, obj in next, oUF.objects do	
		if obj.style == 'Altz_Healerraid' then
			obj:SetSize(aCoreCDB["UnitframeOptions"]["raidwidth"], aCoreCDB["UnitframeOptions"]["raidheight"])
		end
	end
	
	if aCoreCDB["UnitframeOptions"]["hor_party"] then -- 水平小队
		RaidFrame:SetSize(5*(aCoreCDB["UnitframeOptions"]["raidwidth"]+5)-5, aCoreCDB["UnitframeOptions"]["party_num"]*(aCoreCDB["UnitframeOptions"]["raidheight"]+5)-5)
		RaidPetFrame:SetSize(5*(aCoreCDB["UnitframeOptions"]["raidwidth"]+5)-5, aCoreCDB["UnitframeOptions"]["raidheight"])
	else
		RaidFrame:SetSize(aCoreCDB["UnitframeOptions"]["party_num"]*(aCoreCDB["UnitframeOptions"]["raidwidth"]+5)-5, 5*(aCoreCDB["UnitframeOptions"]["raidheight"]+5)-5)
		RaidPetFrame:SetSize(aCoreCDB["UnitframeOptions"]["raidwidth"], 5*(aCoreCDB["UnitframeOptions"]["raidheight"]+5)-5)
	end
end
	
T.UpdateGroupfilter = function()
	if not RaidFrame[1] then return end
	
	for i = 1, 8 do
		if not aCoreCDB["UnitframeOptions"]["party_connected"] then -- 小队分离
			RaidFrame[i]:SetAttribute("groupFilter", (i <= aCoreCDB["UnitframeOptions"]["party_num"]) and tostring(i) or '')
		else
			RaidFrame[i]:SetAttribute("groupFilter", (i == 1) and GetGroupfilter() or '')
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

RaidHealerManaBarUpdater = CreateFrame("Frame")
RaidHealerManaBarUpdater:RegisterEvent('GROUP_ROSTER_UPDATE')
RaidHealerManaBarUpdater:RegisterEvent('PLAYER_ENTERING_WORLD')
RaidHealerManaBarUpdater:SetScript("OnEvent", function()
	local oUF = AltzUF or oUF
	for _, obj in next, oUF.objects do	
		if obj.style == 'Altz_Healerraid' and obj.Power then
			local role = UnitGroupRolesAssigned(obj.unit)
			if role == 'HEALER' then
				obj.Power:SetAlpha(1)
			else
				obj.Power:SetAlpha(0)
			end
		end
	end
end)

--=============================================--
--[[             Party Frames                ]]--
--=============================================--

local pfunc = function(self, unit)	
	T.CreateClickSets(self)
	T.RaidOnMouseOver(self)

	self:RegisterForClicks"AnyUp"
	self.mouseovers = {}

	-- highlight --
	self.hl = self:CreateTexture(nil, "HIGHLIGHT")
	self.hl:SetAllPoints()
	self.hl:SetTexture(G.media.barhightlight)
	self.hl:SetVertexColor( 1, 1, 1, .3)
	self.hl:SetBlendMode("ADD")
	
	-- background --
	self.bg = self:CreateTexture(nil, 'BACKGROUND')
    self.bg:SetAllPoints(self)
	
	-- target border --
	self.targetborder = Createpxborder(self, 2)
	self.targetborder:SetBackdropBorderColor(1, 1, .4)
	self:RegisterEvent("PLAYER_TARGET_CHANGED", ChangedTarget, true)

	-- threat border --
	self.threatborder = Createpxborder(self, 1)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UpdateThreat, true)
	
	-- health bar --
    local hp = T.createStatusbar(self)
    hp:SetAllPoints(self)
	hp:SetReverseFill(true)
	
	hp.backdrop = T.createBackdrop(hp)
	
	hp.cover = hp:CreateTexture(nil, 'OVERLAY')
    hp.cover:SetAllPoints(hp)
	hp.cover:SetTexture(G.media.blank)
	
	hp.value = T.createnumber(hp, "OVERLAY", aCoreCDB["UnitframeOptions"]["valuefontsize"], "OUTLINE", "RIGHT")
	hp.value:SetPoint("BOTTOMRIGHT", self, -4, -2)
	
	hp.ind = hp:CreateTexture(nil, "OVERLAY", nil, 1)
    hp.ind:SetTexture("Interface\\Buttons\\WHITE8x8")
	hp.ind:SetVertexColor(0, 0, 0)
	hp.ind:SetSize(1, 18)
	hp.ind:SetPoint("RIGHT", hp:GetStatusBarTexture(), "LEFT", 0, 0)
  
	hp.ApplySettings = function()
		T.ApplyHealthThemeSettings(self, hp)
		
		hp.ind:SetSize(1, aCoreCDB["UnitframeOptions"]["height"])
		
		-- height, width --
		self:SetSize(aCoreCDB["UnitframeOptions"]["widthparty"], aCoreCDB["UnitframeOptions"]["height"])
		
		-- value --
		if hp.value then
			hp.value:SetFont(G.numFont, aCoreCDB["UnitframeOptions"]["valuefontsize"], "OUTLINE")
			hp.value:ClearAllPoints()
			if aCoreCDB["UnitframeOptions"]["height"] >= aCoreCDB["UnitframeOptions"]["valuefontsize"] then
				hp.value:SetPoint("BOTTOMRIGHT", self, -4, -2)
			else
				hp.value:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", -4, -2-(aCoreCDB["UnitframeOptions"]["height"]*aCoreCDB["UnitframeOptions"]["ppheight"]))
			end
		end
	end

	hp.PostUpdateColor = T.PostUpdate_HealthColor
	hp.PostUpdate = T.PostUpdate_Health
	tinsert(self.mouseovers, hp)
	
	self.Health = hp
	self.Health.ApplySettings()
	
	-- portrait
	local portrait = CreateFrame('PlayerModel', nil, self)
	portrait:SetPoint("TOPLEFT", 0, 0)
	portrait:SetPoint("BOTTOMRIGHT", -1, 0)
	
	portrait:RegisterEvent("PLAYER_FLAGS_CHANGED")
	portrait:SetScript("OnEvent",function(self, event) 
		if event == "PLAYER_FLAGS_CHANGED" and aCoreCDB["SkinOptions"]["afkscreen"] then
			if UnitIsAFK("player") then
				self:Hide()
			else
				self:Show()
			end
		end
	end)
	
	portrait.EnableSettings = function(object)
		if not object or object == self then	
			if aCoreCDB["UnitframeOptions"]["portrait"] then
				self:EnableElement("Portrait")
				self.Portrait:ForceUpdate()
			else
				self:DisableElement("Portrait")
			end
		end
	end
	oUF:RegisterInitCallback(portrait.EnableSettings)
	
	self.Portrait = portrait
		
	-- power bar --
	local pp = T.createStatusbar(self)
	pp:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -1)
	pp:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -1)

	pp.backdrop = T.createBackdrop(pp)
	
	pp.bg = pp:CreateTexture(nil, 'BACKGROUND')
	pp.bg:SetAllPoints(pp)
	pp.multiplier = .2
	
	pp.ApplySettings = function()			
		pp:SetHeight(aCoreCDB["UnitframeOptions"]["height"]*aCoreCDB["UnitframeOptions"]["ppheight"])
		
		T.ApplyPowerThemeSettings(pp)
	end
	
	pp.PostUpdateColor = T.PostUpdate_PowerColor
	pp.PostUpdate = T.PostUpdate_Power
	tinsert(self.mouseovers, pp)
	
	self.Power = pp
	self.Power.ApplySettings()
	
	-- 团队标记
	local ricon = hp:CreateTexture(nil, "OVERLAY")
	ricon:SetPoint("CENTER", hp, "CENTER", 0, 0)
	ricon:SetSize(40, 40)
	ricon:SetTexture[[Interface\AddOns\AltzUI\media\raidicons.blp]]
	self.RaidTargetIndicator = ricon
	
	-- 拉人
    local summonIndicator = self:CreateTexture(nil, 'OVERLAY')
    summonIndicator:SetSize(32, 32)
    summonIndicator:SetPoint('TOPRIGHT', self)
    self.SummonIndicator = summonIndicator
	
	-- 名字
	local name = T.createtext(hp, "OVERLAY", 13, "OUTLINE", "LEFT")
	name:SetPoint("TOPLEFT", hp, "TOPLEFT", 3, 9)
	self:Tag(name, "[Altz:longname]")
	
	-- 光环
	T.CreateAuras(self, unit)
end

oUF:RegisterStyle("Altz_party", pfunc)

local PartyFrame = CreateFrame("Frame", "Altz_Party_Holder", UIParent)
PartyFrame.movingname = PARTY
PartyFrame.point = {
	healer = {a1 = "TOPLEFT", parent = "UIParent", a2 = "TOPLEFT" , x = 240, y = -340},
	dpser = {a1 = "TOPLEFT", parent = "UIParent", a2 = "TOPLEFT" , x = 240, y = -340},
}
T.CreateDragFrame(PartyFrame)

local PartyPetFrame = CreateFrame("Frame", "Altz_PartyPet_Holder", UIParent)
PartyPetFrame.movingname = PARTY..PET
PartyPetFrame.point = {
	healer = {a1 = "TOPLEFT", parent = "Altz_Party_Holder", a2 = "BOTTOMLEFT" , x = 0, y = -40},
	dpser = {a1 = "TOPLEFT", parent = "Altz_Party_Holder", a2 = "BOTTOMLEFT" , x = 0, y = -40},
}
T.CreateDragFrame(PartyPetFrame)

local function Spawnparty()
	oUF:SetActiveStyle"Altz_party"
	
	PartyFrame[1] = oUF:SpawnHeader('Altz_Party', nil, not aCoreCDB["UnitframeOptions"]["raidframe_inparty"] and 'party',
		'oUF-initialConfigFunction', initconfig:format(aCoreCDB["UnitframeOptions"]["widthparty"], aCoreCDB["UnitframeOptions"]["height"]),
		'showPlayer', true,
		'showSolo', false,
		'showParty', true,
		'showRaid', false,
		'xOffset', 0,
		'yOffset', -50,
		'point', "TOP",
		'groupFilter', "1,2,3,4,5,6,7,8",
		'groupingOrder', "1,2,3,4,5,6,7,8",
		'groupBy', "GROUP",
		'maxColumns', 5,
		'unitsPerColumn', 5,
		'columnSpacing', 5,
		'columnAnchorPoint', "LEFT"
	)

	PartyFrame[1]:SetPoint("TOPLEFT", PartyFrame, "TOPLEFT")
	
	PartyPetFrame[1] = oUF:SpawnHeader('Altz_PartyPet', 'SecureGroupPetHeaderTemplate', not aCoreCDB["UnitframeOptions"]["raidframe_inparty"] and 'party',
		'oUF-initialConfigFunction', initconfig:format(aCoreCDB["UnitframeOptions"]["widthparty"], aCoreCDB["UnitframeOptions"]["height"]),
		'showPlayer', true,
		'showSolo', false,
		'showParty', true,
		'showRaid', false,
		'xOffset', 0,
		'yOffset', -50,
		'point', "TOP",
		'groupFilter', "1,2,3,4,5,6,7,8",
		'groupingOrder', "1,2,3,4,5,6,7,8",
		'groupBy', "GROUP",
		'maxColumns', 5,
		'unitsPerColumn', 5,
		'columnSpacing', 5,
		'columnAnchorPoint', "LEFT"
	)
    
	PartyPetFrame[1]:SetPoint("TOPLEFT", PartyPetFrame, "TOPLEFT")
end

T.UpdatePartySize = function()
	PartyFrame:SetSize(aCoreCDB["UnitframeOptions"]["widthparty"], aCoreCDB["UnitframeOptions"]["height"]*5+160)
	PartyPetFrame:SetSize(aCoreCDB["UnitframeOptions"]["widthparty"], aCoreCDB["UnitframeOptions"]["height"]*5+160)
end

T.UpdatePartyfilter = function()
	PartyFrame[1]:SetAttribute("showPlayer", aCoreCDB["UnitframeOptions"]["showplayerinparty"])
	PartyPetFrame[1]:SetAttribute("showPlayer", aCoreCDB["UnitframeOptions"]["showplayerinparty"])
	
	if aCoreCDB["UnitframeOptions"]["raidframe_inparty"] then	
		T.ReleaseDragFrame(PartyFrame)
		T.ReleaseDragFrame(PartyPetFrame)
	else
		T.RestoreDragFrame(PartyFrame)
		
		if aCoreCDB["UnitframeOptions"]["showpartypet"] then
			PartyPetFrame[1]:SetAttribute("groupFilter", "1,2,3,4,5,6,7,8")
			T.RestoreDragFrame(PartyPetFrame)
		else
			PartyPetFrame[1]:SetAttribute("groupFilter", "")
			T.ReleaseDragFrame(PartyPetFrame)
		end		
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
	
	Spawnparty()
	T.UpdatePartySize()
	T.UpdatePartyfilter()
	
	if aCoreCDB["UnitframeOptions"]["enableClickCast"] then
		RegisterClicksforAll()
	end
	
	EventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
end)