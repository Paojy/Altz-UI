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

local function UpdateRaidMana(pp, unit, cur, min, max)
	local _, ptype = UnitPowerType(unit)
    if ptype == 'MANA' then		
		if max == 0 then
			pp.backdrop:SetBackdropColor(0, 0, 0.7)
		elseif cur/max > 0.2 then
			pp.backdrop:SetBackdropColor(.15, .15, .15)
		elseif UnitIsDead(unit) or UnitIsGhost(unit) or not UnitIsConnected(unit) then
			pp.backdrop:SetBackdropColor(.5, .5, .5)
		else
			pp.backdrop:SetBackdropColor(0, 0, 0.7)
		end
	end
	T.Updatepowerbar(pp, unit, cur, min, max)
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

	icon.bd = T.createBackdrop(icon, icon, 0, true)

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
	local enable = false
	for i = 6, 13 do
		if aCoreCDB["UnitframeOptions"]["ClickCast"][tostring(i)]["Click"]["action"] and aCoreCDB["UnitframeOptions"]["ClickCast"][tostring(i)]["Click"]["action"] ~= "NONE" then
			--print(i, "a", aCoreCDB["UnitframeOptions"]["ClickCast"][tostring(i)]["Click"]["action"])
			enable = true
		elseif aCoreCDB["UnitframeOptions"]["ClickCast"][tostring(i)]["Click"]["macro"] and aCoreCDB["UnitframeOptions"]["ClickCast"][tostring(i)]["Click"]["macro"] ~= "" then
			--print(i, "m", aCoreCDB["UnitframeOptions"]["ClickCast"][tostring(i)]["Click"]["macro"])
			enable = true
		end
	end
	if enable then
		--print("Enable")
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
	end
	
	local action, macrotext, key_tmp
	local C = aCoreCDB["UnitframeOptions"]["ClickCast"]
	for id, var in pairs(C) do
		for	key, _ in pairs(C[id]) do
			key_tmp = string.gsub(key, "Click", "")
			action = C[id][key]["action"]
			macro = C[id][key]["macro"]
			if action == "follow" then
				object:SetAttribute(key_tmp.."type"..id, "macro")
				object:SetAttribute(key_tmp.."macrotext"..id, "/follow mouseover")
			elseif	action == "tot" then		
				object:SetAttribute(key_tmp.."type"..id, "macro")
				object:SetAttribute(key_tmp.."macrotext"..id, "/target mouseovertarget")
			elseif	action == "focus" then		
				object:SetAttribute(key_tmp.."type"..id, "focus")
			elseif	action == "target" then
				object:SetAttribute(key_tmp.."type"..id, "target")
			elseif action == "macro" then
				object:SetAttribute(key_tmp.."type"..id, "macro")
				object:SetAttribute(key_tmp.."macrotext"..id, macro)
			else
				object:SetAttribute(key_tmp.."type"..id, "spell")
				object:SetAttribute(key_tmp.."spell"..id, action)
			end				
		end
		object:RegisterForClicks("AnyDown")
	end
end

local clickcast_pendingFrames = {}

local function CreateClickSets(self)
	if not aCoreCDB["UnitframeOptions"]["enableClickCast"] then return end

	if InCombatLockdown() then
		clickcast_pendingFrames[self] = true
	else
		RegisterClicks(self)
		clickcast_pendingFrames[self] = nil
	end
end
T.CreateClickSets = CreateClickSets

local function DelayClickSets()
	if not next(clickcast_pendingFrames) then return end

	for frame in next, clickcast_pendingFrames do
		CreateClickSets(frame)
	end
end

--=============================================--
--[[              Raid Frames                ]]--
--=============================================--

local func = function(self, unit)

    self:RegisterForClicks"AnyUp"
	self.mouseovers = {}
	
	-- highlight --
	self.hl = self:CreateTexture(nil, "HIGHLIGHT")
    self.hl:SetAllPoints()
    self.hl:SetTexture(G.media.barhightlight)
    self.hl:SetVertexColor( 1, 1, 1, .3)
    self.hl:SetBlendMode("ADD")
	
	-- target border --
	self.targetborder = Createpxborder(self, 2)
	self.targetborder:SetBackdropBorderColor(1, 1, .4)
	self:RegisterEvent("PLAYER_TARGET_CHANGED", ChangedTarget, true)

	-- threat border --
	self.threatborder = Createpxborder(self, 1)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UpdateThreat, true)
	
	-- backdrop --
	self.bg = CreateFrame("Frame", nil, self)
	self.bg:SetFrameLevel(0)
	self.bg:SetAllPoints(self)
	self.bg.tex = self.bg:CreateTexture(nil, "BACKGROUND")
    self.bg.tex:SetAllPoints()
	self.bg.tex:SetTexture(G.media.ufbar)
	self.bg.tex:SetVertexColor(0, 0, 0)
	
	-- health --
    local hp = T.createStatusbar(self, nil, nil, 1, 1, 1, 1)
	hp:SetFrameLevel(3)
	hp:SetAllPoints(self)
	hp:SetReverseFill(true)
    hp.frequentUpdates = true
	
	-- little black line to make the health bar more clear
	hp.ind = hp:CreateTexture(nil, "OVERLAY", nil, 1)
    hp.ind:SetTexture("Interface\\Buttons\\WHITE8x8")
	hp.ind:SetVertexColor(0, 0, 0)
	hp.ind:SetSize(1, 45)
	hp.ind:SetPoint("RIGHT", hp:GetStatusBarTexture(), "LEFT", 0, 0)
	
	-- border --
	self.backdrop = T.createBackdrop(hp, hp, 0)
	
	hp.ApplySettings = function()
		hp.ind:SetSize(1, aCoreCDB["UnitframeOptions"]["raidheight"])
		
		if aCoreCDB["SkinOptions"]["style"] == 1 then
			self.bg.tex:SetAlpha(0)
			hp:SetStatusBarTexture(G.media.blank)
			hp.bg:SetTexture(G.media.blank)
			hp.bg:SetGradient("VERTICAL", CreateColor(.5, .5, .5, .5), CreateColor(0, 0, 0, 0))
		elseif aCoreCDB["SkinOptions"]["style"] == 2 then
			self.bg.tex:SetAlpha(1)
			hp:SetStatusBarTexture(G.media.ufbar)
			hp.bg:SetTexture(G.media.ufbar)
			hp.bg:SetGradient("VERTICAL", CreateColor(.2,.2,.2,.15), CreateColor(.25,.25,.25,.6))
		else
			self.bg.tex:SetAlpha(1)
			hp:SetStatusBarTexture(G.media.ufbar)
			hp.bg:SetTexture(G.media.ufbar)
			hp.bg:SetGradient("VERTICAL", CreateColor(.2,.2,.2,0), CreateColor(.25,.25,.25,0))
		end
	end
	
    self.Health = hp
	self.Health.PostUpdate = T.Updatehealthbar
	self.Health.Override = T.Overridehealthbar
	self.Health.ApplySettings()
	
	-- raid manabars --
	local pp = T.createStatusbar(self, nil, nil, 1, 1, 1, 1)
	pp:SetFrameLevel(3)
	pp:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT")
	pp:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
	
	pp.bg:SetGradient("VERTICAL", CreateColor(.2,.2,.2,.15), CreateColor(.25,.25,.25,.6))
	pp.backdrop = T.createBackdrop(pp, pp, 0)

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
		if aCoreCDB["SkinOptions"]["style"] == 1 then
			pp:SetStatusBarTexture(G.media.blank)
		else
			pp:SetStatusBarTexture(G.media.ufbar)
		end
		
		pp:SetHeight(aCoreCDB["UnitframeOptions"]["raidheight"]*aCoreCDB["UnitframeOptions"]["raidppheight"])
	end	
	
	self.Power = pp
	self.Power.PostUpdate = UpdateRaidMana
	self.Power.ApplySettings()
	
	-- gcd frane --
	local gcd = CreateFrame("StatusBar", nil, self)
    gcd:SetAllPoints(self)
    gcd:SetStatusBarTexture(G.media.blank)
    gcd:SetStatusBarColor(1, 1, 1, .4)
    gcd:SetFrameLevel(5)
	
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
	
	self.HealthPrediction = hp_predict
	self.HealthPrediction.ApplySettings()
	
	
	local leader = hp:CreateTexture(nil, "OVERLAY", nil, 1)
    leader:SetSize(10, 10)
    leader:SetPoint("BOTTOMLEFT", hp, "BOTTOMLEFT", 0, -5)
    self.LeaderIndicator = leader

	local assistant = hp:CreateTexture(nil, "OVERLAY", nil, 1)
    assistant:SetSize(10, 10)
    assistant:SetPoint("BOTTOMLEFT", hp, "BOTTOMLEFT", 0, -5)
	self.AssistantIndicator = assistant
	
    local masterlooter = hp:CreateTexture(nil, 'OVERLAY', nil, 1)
    masterlooter:SetSize(10, 10)
    masterlooter:SetPoint('LEFT', leader, 'RIGHT', 0, 1)
    self.MasterLooterIndicator = masterlooter
	
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
	
	local lfd =  T.createtext(hp, "OVERLAY", 13, "OUTLINE", "CENTER")
	lfd:SetFont(G.symbols, aCoreCDB["UnitframeOptions"]["raidfontsize"]-3, "OUTLINE")
	lfd:SetPoint("BOTTOM", hp, 0, -1)
	self.tag_lfd = lfd
	self:Tag(lfd, '[Altz:LFD]')
	
	local raidname = T.createtext(hp, "ARTWORK", aCoreCDB["UnitframeOptions"]["raidfontsize"], "OUTLINE", "RIGHT")
	raidname:SetPoint("BOTTOMRIGHT", hp, "BOTTOMRIGHT", -1, 5)
	self.tag_raidname = raidname
	self:Tag(raidname, '[Altz:hpraidname]')
	
    local ricon = hp:CreateTexture(nil, "OVERLAY", nil, 1)
	ricon:SetSize(18 ,18)
    ricon:SetPoint("RIGHT", hp, "TOP", -8 , 0)
	ricon:SetTexture[[Interface\AddOns\AltzUI\media\raidicons.blp]]
    self.RaidTargetIndicator = ricon
	
	local status = T.createtext(hp, "OVERLAY", aCoreCDB["UnitframeOptions"]["raidfontsize"]-2, "OUTLINE", "LEFT")
    status:SetPoint"TOPLEFT"
	self.tag_status = status
	self:Tag(status, '[Altz:AfkDnd][Altz:DDG]')
	
	local resurrecticon = hp:CreateTexture(nil, "OVERLAY")
    resurrecticon:SetSize(16, 16)
    resurrecticon:SetPoint"CENTER"
    self.ResurrectIndicator = resurrecticon
	
    local readycheck = hp:CreateTexture(nil, 'OVERLAY', nil, 3)
    readycheck:SetSize(16, 16)
    readycheck:SetPoint"CENTER"
    self.ReadyCheckIndicator = readycheck

	local summonIndicator = self:CreateTexture(nil, 'OVERLAY')
    summonIndicator:SetSize(32, 32)
    summonIndicator:SetPoint('TOPRIGHT', self)
	summonIndicator:SetAtlas('Raid-Icon-SummonPending', true)
	summonIndicator:Show()
    self.SummonIndicator = summonIndicator
	
	-- Debuffs
	local Auras = CreateFrame("Frame", nil, self)
	Auras:SetFrameLevel(4)
	Auras.tfontsize = aCoreCDB["UnitframeOptions"]["raid_debuff_icon_fontsize"]
	Auras.cfontsize = aCoreCDB["UnitframeOptions"]["raid_debuff_icon_fontsize"]
	Auras.Icon_size = aCoreCDB["UnitframeOptions"]["raid_debuff_icon_size"]
	Auras.anchor_x = aCoreCDB["UnitframeOptions"]["raid_debuff_anchor_x"]
	Auras.anchor_y = aCoreCDB["UnitframeOptions"]["raid_debuff_anchor_y"]
	Auras.numDebuffs = aCoreCDB["UnitframeOptions"]["raid_debuff_num"]
	self.AltzAuras2 = Auras
	
	-- Tankbuff
    local Tankbuff = CreateFrame("Frame", nil, self)
	Tankbuff:SetFrameLevel(4)
	Tankbuff.tfontsize = aCoreCDB["UnitframeOptions"]["raid_buff_icon_fontsize"]
	Tankbuff.cfontsize = aCoreCDB["UnitframeOptions"]["raid_buff_icon_fontsize"]
	Tankbuff.Icon_size = aCoreCDB["UnitframeOptions"]["raid_buff_icon_size"]
	Tankbuff.anchor_x = aCoreCDB["UnitframeOptions"]["raid_buff_anchor_x"]
	Tankbuff.anchor_y = aCoreCDB["UnitframeOptions"]["raid_buff_anchor_y"]
	Tankbuff.numBuffs = aCoreCDB["UnitframeOptions"]["raid_buff_num"]
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
	self.Auras.ApplySettings()

	-- Range
    local range = {
        insideAlpha = 1,
        outsideAlpha = 0.3,
    }
	
	self.Range = range
	
	if aCoreCDB["UnitframeOptions"]["enableClickCast"] then
		T.CreateClickSets(self)
	end
	
	T.RaidOnMouseOver(self)
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
RaidPetFrame.movingname = L["宠物团队框架"]
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

T.UpdateGroupTag = function(t)
	local oUF = AltzUF or oUF
	for _, obj in next, oUF.objects do	
		if obj.style == 'Altz_Healerraid' then
			if t == "update" then
				obj:UpdateTags()
			elseif t == "fontsize" then
				obj.tag_lfd:SetFont(G.symbols, aCoreCDB["UnitframeOptions"]["raidfontsize"]-3, "OUTLINE")
				obj.tag_raidname:SetFont(G.norFont, aCoreCDB["UnitframeOptions"]["raidfontsize"], "OUTLINE")
				obj.tag_status:SetFont(G.norFont, aCoreCDB["UnitframeOptions"]["raidfontsize"]-2, "OUTLINE")
			end
		end
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
	self:RegisterForClicks"AnyUp"
	self.mouseovers = {}

	-- highlight --
	self.hl = self:CreateTexture(nil, "HIGHLIGHT")
	self.hl:SetAllPoints()
	self.hl:SetTexture(G.media.barhightlight)
	self.hl:SetVertexColor( 1, 1, 1, .3)
	self.hl:SetBlendMode("ADD")
	
	-- backdrop --
	self.bg = CreateFrame("Frame", nil, self)
	self.bg:SetFrameLevel(0)
	self.bg:SetAllPoints(self)
	self.bg.tex = self.bg:CreateTexture(nil, "BACKGROUND")
    self.bg.tex:SetAllPoints()
	self.bg.tex:SetTexture(G.media.ufbar)
	self.bg.tex:SetVertexColor(0, 0, 0)
	
    local hp = T.createStatusbar(self, nil, nil, 1, 1, 1, 1)
	hp:SetFrameLevel(4)
    hp:SetAllPoints(self)
	hp:SetPoint("TOPLEFT", self, "TOPLEFT")
	hp:SetPoint("TOPRIGHT", self, "TOPRIGHT")
	hp:SetReverseFill(true)
    hp.frequentUpdates = true
	
	-- little black line to make the health bar more clear
	hp.ind = hp:CreateTexture(nil, "OVERLAY", nil, 1)
    hp.ind:SetTexture("Interface\\Buttons\\WHITE8x8")
	hp.ind:SetVertexColor(0, 0, 0)
	hp.ind:SetSize(1, 18)
	hp.ind:SetPoint("RIGHT", hp:GetStatusBarTexture(), "LEFT", 0, 0)
	
	-- border --
	self.backdrop = T.createBackdrop(hp, hp, 0)
	
	hp.value = T.createnumber(hp, "OVERLAY", aCoreCDB["UnitframeOptions"]["valuefontsize"], "OUTLINE", "RIGHT")
	hp.value:SetPoint("BOTTOMRIGHT", self, -4, -2)	
	
    self.Health = hp
	self.Health.PostUpdate = T.Updatehealthbar
	self.Health.Override = T.Overridehealthbar
	
	self.Health.ApplySettings = function()
		if aCoreCDB["SkinOptions"]["style"] == 1 then
			self.bg.tex:SetAlpha(0)
			hp:SetStatusBarTexture(G.media.blank)
			hp.bg:SetTexture(G.media.blank)
			hp.bg:SetGradient("VERTICAL", CreateColor(.5, .5, .5, .5), CreateColor(0, 0, 0, 0))
		elseif aCoreCDB["SkinOptions"]["style"] == 2 then
			self.bg.tex:SetAlpha(1)
			hp:SetStatusBarTexture(G.media.ufbar)
			hp.bg:SetTexture(G.media.ufbar)
			hp.bg:SetGradient("VERTICAL", CreateColor(.2,.2,.2,.15), CreateColor(.25,.25,.25,.6))
		else
			self.bg.tex:SetAlpha(1)
			hp:SetStatusBarTexture(G.media.ufbar)
			hp.bg:SetTexture(G.media.ufbar)
			hp.bg:SetGradient("VERTICAL", CreateColor(.2,.2,.2,0), CreateColor(.25,.25,.25,0))
		end
		
		hp.ind:SetSize(1, aCoreCDB["UnitframeOptions"]["height"])
		self:SetSize(aCoreCDB["UnitframeOptions"]["widthparty"], aCoreCDB["UnitframeOptions"]["height"])
		
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
	
	self.Health.ApplySettings()
	
	tinsert(self.mouseovers, self.Health)
	
	-- portrait
	local portrait = CreateFrame('PlayerModel', nil, self)
	portrait:SetFrameLevel(1)
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
	local pp = T.createStatusbar(self, aCoreCDB["UnitframeOptions"]["height"]*aCoreCDB["UnitframeOptions"]["ppheight"], nil, 1, 1, 1, 1)
	pp:SetFrameLevel(4)
	pp:SetPoint"LEFT"
	pp:SetPoint"RIGHT"
	pp:SetPoint("TOP", self, "BOTTOM", 0, -1)
	pp.frequentUpdates = true

	pp.bg:SetGradient("VERTICAL", CreateColor(.2,.2,.2,.15), CreateColor(.25,.25,.25,.6))

	-- backdrop for power bar --
	pp.bd = T.createBackdrop(pp, pp, 1)

	pp.ApplySettings = function()			
		if aCoreCDB["SkinOptions"]["style"] == 1 then
			pp:SetStatusBarTexture(G.media.blank)
		else
			pp:SetStatusBarTexture(G.media.ufbar)
		end
		pp:SetHeight(aCoreCDB["UnitframeOptions"]["height"]*aCoreCDB["UnitframeOptions"]["ppheight"])
	end
	
	self.Power = pp
	self.Power.PostUpdate = T.Updatepowerbar
	tinsert(self.mouseovers, self.Power)

	-- target border --
	self.targetborder = Createpxborder(self, 2)
	self.targetborder:SetBackdropBorderColor(1, 1, .4)
	self.targetborder:SetPoint("TOPLEFT", hp, "TOPLEFT", -3, 3)
	self.targetborder:SetPoint("BOTTOMRIGHT", pp, "BOTTOMRIGHT", 3, -3)
	self:RegisterEvent("PLAYER_TARGET_CHANGED", ChangedTarget, true)

	-- threat border --
	self.threatborder = Createpxborder(self, 1)
	self.threatborder:SetPoint("TOPLEFT", hp, "TOPLEFT", -3, 3)
	self.threatborder:SetPoint("BOTTOMRIGHT", pp, "BOTTOMRIGHT", 3, -3)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UpdateThreat, true)
	
	-- little thing around unit frames --
	local leader = hp:CreateTexture(nil, "OVERLAY")
	leader:SetSize(12, 12)
	leader:SetPoint("BOTTOMLEFT", hp, "BOTTOMLEFT", 5, -5)
	self.LeaderIndicator = leader

	local assistant = hp:CreateTexture(nil, "OVERLAY")
	assistant:SetSize(12, 12)
	assistant:SetPoint("BOTTOMLEFT", hp, "BOTTOMLEFT", 5, -5)
	self.AssistantIndicator = assistant

	local masterlooter = hp:CreateTexture(nil, "OVERLAY")
	masterlooter:SetSize(12, 12)
	masterlooter:SetPoint("LEFT", leader, "RIGHT")
	self.MasterLooterIndicator = masterlooter

	local ricon = hp:CreateTexture(nil, "OVERLAY")
	ricon:SetPoint("CENTER", hp, "CENTER", 0, 0)
	ricon:SetSize(40, 40)
	ricon:SetTexture[[Interface\AddOns\AltzUI\media\raidicons.blp]]
	self.RaidTargetIndicator = ricon

    local summonIndicator = self:CreateTexture(nil, 'OVERLAY')
    summonIndicator:SetSize(32, 32)
    summonIndicator:SetPoint('TOPRIGHT', self)
    self.SummonIndicator = summonIndicator
	
	-- name --
	local name = T.createtext(self.Health, "OVERLAY", 13, "OUTLINE", "LEFT")
	name:SetPoint("TOPLEFT", self.Health, "TOPLEFT", 3, 9)
	self:Tag(name, "[Altz:longname]")

	T.CreateAuras(self, unit)

	if aCoreCDB["UnitframeOptions"]["enableClickCast"] then
		T.CreateClickSets(self)
	end
	
	T.RaidOnMouseOver(self)
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
			DelayClickSets()
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
	
	EventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
end)