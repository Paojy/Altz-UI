local T, C, L, G = unpack(select(2, ...))
local oUF = AltzUF or oUF

--=============================================--
--[[               Some update               ]]--
--=============================================--
local pxbackdrop = { edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=],  edgeSize = 2, }

local function Createpxborder(self, lvl)
	local pxbd = CreateFrame("Frame", nil, self)
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
	
	if aCoreCDB["UnitframeOptions"]["style"] ~= 3 then
		hpb:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'LEFT')
	else
		hpb:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
	end
	hpb:SetWidth(aCoreCDB["UnitframeOptions"]["healerraidwidth"])
	return hpb
end

local function CreateHealPredition(self)
	local myBar = healpreditionbar(self, .4, .8, 0, .5)
	local otherBar = healpreditionbar(self, 0, .4, 0, .5)
	local absorbBar = healpreditionbar(self, .2, 1, 1, .7)
	
	self.HealthPrediction = {
		myBar = myBar,
		otherBar = otherBar,
		absorbBar = absorbBar,
		maxOverflow = 1.2,
	}
end

local function CreateGCDframe(self)
    local Gcd = CreateFrame("StatusBar", nil, self)
    Gcd:SetAllPoints(self)
    Gcd:SetStatusBarTexture(G.media.blank)
    Gcd:SetStatusBarColor(1, 1, 1, .4)
    Gcd:SetFrameLevel(5)
    self.GCD = Gcd
end

local function UpdateRaidMana(pp, unit, cur, min, max)
	local _, ptype = UnitPowerType(unit)
	local self = pp:GetParent()
    if ptype == 'MANA' then
		pp:SetHeight(aCoreCDB["UnitframeOptions"]["healerraidheight"]*-(aCoreCDB["UnitframeOptions"]["raidhpheight"]-1))
		self.Health:SetPoint("BOTTOM", pp, "TOP", 0, 3)
		if cur/max > 0.2 then
			pp.backdrop:SetBackdropColor(.15, .15, .15)
		elseif UnitIsDead(unit) or UnitIsGhost(unit) or not UnitIsConnected(unit) then
			pp.backdrop:SetBackdropColor(.5, .5, .5)
		else
			pp.backdrop:SetBackdropColor(0, 0, 0.7)
		end
		pp.backdrop:SetBackdropBorderColor(0, 0, 0)
	else
		pp:SetHeight(0.0000001)
		self.Health:SetPoint("BOTTOM", self, "BOTTOM")
		pp.backdrop:SetBackdropBorderColor(0, 0, 0, 0)
	end
	T.Updatepowerbar(pp, unit, cur, min, max)
end
--=============================================--
--[[              Click Cast                 ]]--
--=============================================--
local OnMouseOver = function(self)
    self:HookScript("OnEnter", function(self) UnitFrame_OnEnter(self) end)
    self:HookScript("OnLeave", function(self) UnitFrame_OnLeave(self) end)
end

local function EnableWheelCastOnFrame(object)
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
		object:SetAttribute("_onenter", [[
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

		object:SetAttribute("_onleave", [[
			self:ClearBindings()
		]])
	end
end

local function RegisterClicks(object)
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
	self:RegisterEvent("PLAYER_TARGET_CHANGED", ChangedTarget)

	-- threat border --
	self.threatborder = Createpxborder(self, 1)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UpdateThreat)
	
	-- backdrop --
	self.bg = CreateFrame("Frame", nil, self)
	self.bg:SetFrameLevel(0)
	self.bg:SetAllPoints(self)
	self.bg.tex = self.bg:CreateTexture(nil, "BACKGROUND")
    self.bg.tex:SetAllPoints()
	if aCoreCDB["UnitframeOptions"]["style"] == 1 then
		self.bg.tex:SetTexture(G.media.blank)
		self.bg.tex:SetVertexColor(0, 0, 0, 0)	
	else
		self.bg.tex:SetTexture(G.media.ufbar)
		self.bg.tex:SetVertexColor(0, 0, 0)
	end
	
    local hp = T.createStatusbar(self, "ARTWORK", nil, nil, 1, 1, 1, 1)
	hp:SetFrameLevel(3)
    hp:SetAllPoints(self)
	hp:SetPoint("TOPLEFT", self, "TOPLEFT")
	hp:SetPoint("TOPRIGHT", self, "TOPRIGHT")
    hp.frequentUpdates = true
	
	if aCoreCDB["UnitframeOptions"]["style"] == 1 then
		hp.bg:SetGradientAlpha("VERTICAL", .5, .5, .5, .5, 0, 0, 0,0)
	else
		hp.bg:SetGradientAlpha("VERTICAL", .2,.2,.2,.15,.25,.25,.25,.6)
	end
	
	-- little black line to make the health bar more clear
	hp.ind = hp:CreateTexture(nil, "OVERLAY", 1)
    hp.ind:SetTexture("Interface\\Buttons\\WHITE8x8")
	hp.ind:SetVertexColor(0, 0, 0)
	hp.ind:SetSize(1, hp:GetHeight())
	if aCoreCDB["UnitframeOptions"]["style"] ~= 3 then
		hp.ind:SetPoint("RIGHT", hp:GetStatusBarTexture(), "LEFT", 0, 0)
	else
		hp.ind:SetPoint("LEFT", hp:GetStatusBarTexture(), "RIGHT", 0, 0)
	end
	
	if aCoreCDB["UnitframeOptions"]["style"] ~= 3 then
		hp:SetReverseFill(true)
	end
	
	-- border --
	self.backdrop = T.createBackdrop(hp, hp, 0)
	
    self.Health = hp
	self.Health.PostUpdate = T.Updatehealthbar
	self.Health.Override = T.Overridehealthbar
	
	-- raid manabars --
	if aCoreCDB["UnitframeOptions"]["raidmanabars"] then
		local pp = T.createStatusbar(self, "ARTWORK", nil, nil, 1, 1, 1, 1)
		pp:SetFrameLevel(3)
		pp:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT")
		pp:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
		
		pp.bg:SetGradientAlpha("VERTICAL", .2,.2,.2,.15,.25,.25,.25,.6)
		
		pp.backdrop = T.createBackdrop(pp, pp, 1)
		
		self.Power = pp
		self.Power.PostUpdate = UpdateRaidMana
	else
		self.Health:SetPoint("BOTTOM", self, "BOTTOM")
	end
	
	-- gcd frane --
	if aCoreCDB["UnitframeOptions"]["showgcd"] then
		CreateGCDframe(self)
	end
	
	-- heal prediction --
	if aCoreCDB["UnitframeOptions"]["healprediction"] then
		CreateHealPredition(self)
	end
	
	local leader = hp:CreateTexture(nil, "OVERLAY", 1)
    leader:SetSize(10, 10)
    leader:SetPoint("BOTTOMLEFT", hp, "BOTTOMLEFT", 0, -5)
    self.LeaderIndicator = leader

	local assistant = hp:CreateTexture(nil, "OVERLAY", 1)
    assistant:SetSize(10, 10)
    assistant:SetPoint("BOTTOMLEFT", hp, "BOTTOMLEFT", 0, -5)
	self.AssistantIndicator = assistant
	
    local masterlooter = hp:CreateTexture(nil, 'OVERLAY', 1)
    masterlooter:SetSize(10, 10)
    masterlooter:SetPoint('LEFT', leader, 'RIGHT', 0, 1)
    self.MasterLooterIndicator = masterlooter
	
	if aCoreCDB["UnitframeOptions"]["healtank_assisticon"] then
		local raidrole = hp:CreateTexture(nil, 'OVERLAY', 1)
		raidrole:SetSize(10, 10)
		raidrole:SetPoint('LEFT', masterlooter, 'RIGHT')
		self.RaidRoleIndicator = raidrole
	end
	
	local lfd =  T.createtext(hp, "OVERLAY", 13, "OUTLINE", "CENTER")
	lfd:SetFont(G.symbols, aCoreCDB["UnitframeOptions"]["raidfontsize"]-3, "OUTLINE")
	lfd:SetPoint("BOTTOM", hp, 0, -1)
	self:Tag(lfd, '[Altz:LFD]')
	
	local raidname = T.createtext(hp, "ARTWORK", aCoreCDB["UnitframeOptions"]["raidfontsize"], "OUTLINE", "RIGHT")
	raidname:SetPoint("BOTTOMRIGHT", hp, "BOTTOMRIGHT", -1, 5)
	if aCoreCDB["UnitframeOptions"]["showmisshp"] then
		if aCoreCDB["UnitframeOptions"]["style"] == 1 or aCoreCDB["UnitframeOptions"]["style"] == 2 then
			self:Tag(raidname, '[Altz:color][Altz:hpraidname]')
		else
			self:Tag(raidname, '[Altz:hpraidname]')
		end
	else
		if aCoreCDB["UnitframeOptions"]["style"] == 1 or aCoreCDB["UnitframeOptions"]["style"] == 2 then
			self:Tag(raidname, '[Altz:color][Altz:raidname]')
		else
			self:Tag(raidname, '[Altz:raidname]')
		end
	end
	self.Name = raidname
	
    local ricon = hp:CreateTexture(nil, "OVERLAY", 1)
	ricon:SetSize(18 ,18)
    ricon:SetPoint("RIGHT", hp, "TOP", -8 , 0)
	ricon:SetTexture[[Interface\AddOns\AltzUI\media\raidicons.blp]]
    self.RaidTargetIndicator = ricon
	
	local status = T.createtext(hp, "OVERLAY", aCoreCDB["UnitframeOptions"]["raidfontsize"]-2, "OUTLINE", "LEFT")
    status:SetPoint"TOPLEFT"
	self:Tag(status, '[Altz:AfkDnd][Altz:DDG]')
	
	local resurrecticon = hp:CreateTexture(nil, "OVERLAY")
    resurrecticon:SetSize(16, 16)
    resurrecticon:SetPoint"CENTER"
    self.ResurrectIndicator = resurrecticon
	
    local readycheck = hp:CreateTexture(nil, 'OVERLAY', 3)
    readycheck:SetSize(16, 16)
    readycheck:SetPoint"CENTER"
    self.ReadyCheckIndicator = readycheck
	
	local Auras = CreateFrame("Frame", nil, self)
	Auras:SetFrameLevel(4)
    Auras:SetSize(20, 20)
    Auras:SetPoint("LEFT", hp, "LEFT", 15, 0)
	Auras.tfontsize = 10
	Auras.cfontsize = 10
	
	Auras.sizeA = 20
	Auras.point1A = "CENTER"
	Auras.point2A = "CENTER"
	Auras.xA = 0
	Auras.yA = 0
	
	Auras.sizeB = 15
	Auras.point1B = "BOTTOMLEFT"
	Auras.point2B = "BOTTOMLEFT"
	Auras.xB = 2
	Auras.yB = 3
	self.AltzAuras2 = Auras
	
	-- Tankbuff
    local tankbuff = CreateFrame("Frame", nil, self)
	tankbuff:SetFrameLevel(4)
    tankbuff:SetSize(15, 15)
    tankbuff:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -2, 3)
	tankbuff.tfontsize = 10
	tankbuff.cfontsize = 10
	self.AltzTankbuff = tankbuff
	
	-- Indicators
	if aCoreCDB["UnitframeOptions"]["hotind_style"] == "number_ind" then
		self.AltzIndicators = true
	else
		T.CreateAuras(self, unit)
	end
	
	-- Range
    local range = {
        insideAlpha = 1,
        outsideAlpha = 0.3,
    }
	
	self.Range = range
	
	if aCoreCDB["UnitframeOptions"]["enableClickCast"] then
		EnableWheelCastOnFrame(self)
		RegisterClicks(self)
	end
	
	self:SetAttribute("toggleForVehicle", aCoreCDB["UnitframeOptions"]["toggleForVehicle"])
	
	OnMouseOver(self)
end

local dfunc = function(self, unit)

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
	self:RegisterEvent("PLAYER_TARGET_CHANGED", ChangedTarget)

	-- threat border --
	self.threatborder = Createpxborder(self, 1)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UpdateThreat)
	
	-- backdrop --
	self.bg = CreateFrame("Frame", nil, self)
	self.bg:SetFrameLevel(0)
	self.bg:SetAllPoints(self)
	self.bg.tex = self.bg:CreateTexture(nil, "BACKGROUND")
    self.bg.tex:SetAllPoints()
	if aCoreCDB["UnitframeOptions"]["style"] == 1 then
		self.bg.tex:SetTexture(G.media.blank)
		self.bg.tex:SetVertexColor(0, 0, 0, 0)	
	else
		self.bg.tex:SetTexture(G.media.ufbar)
		self.bg.tex:SetVertexColor(0, 0, 0)
	end
	
	-- border --
	self.backdrop = T.createBackdrop(self, self, 0)
	
    local hp = T.createStatusbar(self, "ARTWORK", nil, nil, 1, 1, 1, 1)
	hp:SetFrameLevel(3)
    hp:SetAllPoints(self)
    hp.frequentUpdates = true
	
	if aCoreCDB["UnitframeOptions"]["style"] == 1 then
		hp.bg:SetGradientAlpha("VERTICAL", .5, .5, .5, .5, 0, 0, 0,0)
	else
		hp.bg:SetGradientAlpha("VERTICAL", .2,.2,.2,.15,.25,.25,.25,.6)
	end
	
	-- little black line to make the health bar more clear
	hp.ind = hp:CreateTexture(nil, "OVERLAY", 1)
    hp.ind:SetTexture("Interface\\Buttons\\WHITE8x8")
	hp.ind:SetVertexColor(0, 0, 0)
	hp.ind:SetSize(1, self:GetHeight())
	if aCoreCDB["UnitframeOptions"]["style"] ~= 3 then
		hp.ind:SetPoint("RIGHT", hp:GetStatusBarTexture(), "LEFT", 0, 0)
	else
		hp.ind:SetPoint("LEFT", hp:GetStatusBarTexture(), "RIGHT", 0, 0)
	end
	
	if aCoreCDB["UnitframeOptions"]["style"] ~= 3 then
		hp:SetReverseFill(true)
	end
	
    self.Health = hp
	self.Health.PostUpdate = T.Updatehealthbar
	
	local leader = hp:CreateTexture(nil, "OVERLAY", 1)
    leader:SetSize(10, 10)
    leader:SetPoint("BOTTOMLEFT", hp, "BOTTOMLEFT", 0, -3)
    self.LeaderIndicator = leader

	local assistant = hp:CreateTexture(nil, "OVERLAY", 1)
    assistant:SetSize(10, 10)
    assistant:SetPoint("BOTTOMLEFT", hp, "BOTTOMLEFT", 0, -3)
	self.AssistantIndicator = assistant
	
    local masterlooter = hp:CreateTexture(nil, 'OVERLAY', 1)
    masterlooter:SetSize(10, 10)
    masterlooter:SetPoint('LEFT', leader, 'RIGHT', 0, 1)
    self.MasterLooterIndicator = masterlooter
	
	if aCoreCDB["UnitframeOptions"]["dpstank_assisticon"] then
		local raidrole = hp:CreateTexture(nil, 'OVERLAY', 1)
		raidrole:SetSize(10, 10)
		raidrole:SetPoint('LEFT', masterlooter, 'RIGHT')
		self.RaidRoleIndicator = raidrole
	end
	
	local lfd =  T.createtext(hp, "OVERLAY", 13, "OUTLINE", "LEFT")
	lfd:SetFont(G.symbols, aCoreCDB["UnitframeOptions"]["raidfontsize"]-3, "OUTLINE")
	lfd:SetPoint("LEFT", hp, 1, -1)
	self:Tag(lfd, '[Altz:LFD]')
		
	local raidname = T.createtext(hp, "ARTWORK", aCoreCDB["UnitframeOptions"]["raidfontsize"], "OUTLINE", "RIGHT")
	raidname:SetPoint"CENTER"
	if aCoreCDB["UnitframeOptions"]["style"] == 1 or aCoreCDB["UnitframeOptions"]["style"] == 2 then
		self:Tag(raidname, '[Altz:color][Altz:raidname]')
	else
		self:Tag(raidname, '[Altz:raidname]')
	end
	self.Name = raidname
	
    local ricon = hp:CreateTexture(nil, "OVERLAY", 1)
	ricon:SetSize(13 ,13)
    ricon:SetPoint("TOP", hp, "TOP", 0 , 5)
	ricon:SetTexture[[Interface\AddOns\AltzUI\media\raidicons.blp]]
    self.RaidTargetIndicator = ricon
	
	local status = T.createtext(hp, "OVERLAY", aCoreCDB["UnitframeOptions"]["raidfontsize"]-2, "OUTLINE", "LEFT")
    status:SetPoint"TOPLEFT"
	self:Tag(status, '[Altz:AfkDnd][Altz:DDG]')
	
	local readycheck = hp:CreateTexture(nil, 'OVERLAY', 3)
    readycheck:SetSize(16, 16)
    readycheck:SetPoint"CENTER"
    self.ReadyCheckIndicator = readycheck
	
	-- Range
    local range = {
        insideAlpha = 1,
        outsideAlpha = 0.3,
    }
	
	self.Range = range
	
	if aCoreCDB["UnitframeOptions"]["enableClickCast"] then
		EnableWheelCastOnFrame(self)
		RegisterClicks(self)
	end
	
	self:SetAttribute("toggleForVehicle", aCoreCDB["UnitframeOptions"]["toggleForVehicle"])
	
	OnMouseOver(self)
end

oUF:RegisterStyle("Altz_Healerraid", func)
oUF:RegisterStyle("Altz_DPSraid", dfunc)

local healerraid
local dpsraid

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

local function Spawnhealraid()
	oUF:SetActiveStyle"Altz_Healerraid"
	healerraid = oUF:SpawnHeader('Altz_HealerRaid', nil, 'raid,party,solo',
		'oUF-initialConfigFunction', initconfig:format(aCoreCDB["UnitframeOptions"]["healerraidwidth"], aCoreCDB["UnitframeOptions"]["healerraidheight"], 1),
		'showPlayer', true,
		'showSolo', aCoreCDB["UnitframeOptions"]["showsolo"],
		'showParty', true,
		'showRaid', true,
		'xOffset', 5,
		'yOffset', -5,
		'point', aCoreCDB["UnitframeOptions"]["anchor"],
		'groupFilter', aCoreCDB["UnitframeOptions"]["healergroupfilter"],
		'groupingOrder', '1,2,3,4,5,6,7,8',
		'groupBy', 'GROUP',
		'maxColumns', 8,
		'unitsPerColumn', 5,
		'columnSpacing', 5,
		'columnAnchorPoint', aCoreCDB["UnitframeOptions"]["partyanchor"]
	)
	healerraid.movingname = L["治疗模式团队框架"]
	healerraid.point = {
		healer = {a1 = "CENTER", parent = "UIParent", a2 = "BOTTOM", x = 0, y = 225},
		dpser = {a1 = "BOTTOMLEFT", parent = "UIParent", a2 = "BOTTOMLEFT", x = 10, y = 250},
	}
	T.CreateDragFrame(healerraid)
	healerraid.df:ClearAllPoints()
	local size
	if aCoreCDB["UnitframeOptions"]["healergroupfilter"] == "1,2,3,4,5,6,7,8" then
		size = 40
	elseif aCoreCDB["UnitframeOptions"]["healergroupfilter"] == "1,2,3,4,5,6" then
		size = 30
	elseif aCoreCDB["UnitframeOptions"]["healergroupfilter"] == "1,2,3,4" then
		size = 20
	else
		size = 10
	end
	if aCoreCDB["UnitframeOptions"]["anchor"] == "LEFT" then
		if aCoreCDB["UnitframeOptions"]["partyanchor"] == "LEFT" then
			healerraid.df:SetSize(5*(size/5)*(aCoreCDB["UnitframeOptions"]["healerraidwidth"]+5)-5, aCoreCDB["UnitframeOptions"]["healerraidheight"])
		else
			healerraid.df:SetSize(5*(aCoreCDB["UnitframeOptions"]["healerraidwidth"]+5)-5, (size/5)*(aCoreCDB["UnitframeOptions"]["healerraidheight"]+5)-5)
		end
	else -- "TOP"
		if aCoreCDB["UnitframeOptions"]["partyanchor"] == "LEFT" then
			healerraid.df:SetSize((size/5)*(aCoreCDB["UnitframeOptions"]["healerraidwidth"]+5)-5, 5*(aCoreCDB["UnitframeOptions"]["healerraidheight"]+5)-5)
		else
			healerraid.df:SetSize(aCoreCDB["UnitframeOptions"]["healerraidwidth"], 5*(size/5)*(aCoreCDB["UnitframeOptions"]["healerraidheight"]+5)-5)
		end
	end
	healerpet = oUF:SpawnHeader('Altz_HealerPetRaid', 'SecureGroupPetHeaderTemplate', 'raid,party,solo',
		'oUF-initialConfigFunction', initconfig:format(aCoreCDB["UnitframeOptions"]["healerraidwidth"], aCoreCDB["UnitframeOptions"]["healerraidheight"], 1),
		'showPlayer', true,
		'showSolo', aCoreCDB["UnitframeOptions"]["showsolo"],
		'showParty', true,
		'showRaid', true,
		'xOffset', 5,
		'yOffset', -5,
		'point', aCoreCDB["UnitframeOptions"]["anchor"],
		'groupFilter', aCoreCDB["UnitframeOptions"]["healergroupfilter"],
		'groupingOrder', '1,2,3,4,5,6,7,8',
		'groupBy', 'GROUP',
		'maxColumns', 8,
		'unitsPerColumn', 5,
		'columnSpacing', 5,
		'columnAnchorPoint', aCoreCDB["UnitframeOptions"]["partyanchor"],
		--'useOwnerUnit', true,
		'unitsuffix', 'pet'
	)
	healerpet.movingname = L["治疗模式宠物团队框架"]
	healerpet.point = {
		healer = {a1 = "TOPLEFT", parent = healerraid:GetName(), a2 = "TOPRIGHT", x = 10, y = 0},
		dpser = {a1 = "TOPLEFT", parent = healerraid:GetName(), a2 = "TOPRIGHT", x = 10, y = 0},
	}
	T.CreateDragFrame(healerpet)
	healerpet.df:ClearAllPoints()
	healerpet.df:SetSize(aCoreCDB["UnitframeOptions"]["healerraidwidth"], 5*(aCoreCDB["UnitframeOptions"]["healerraidheight"]+5)-5)
end

local function Spawndpsraid()
	oUF:SetActiveStyle"Altz_DPSraid"
	dpsraid = oUF:SpawnHeader('Altz_DpsRaid', nil, 'raid,party,solo',
		'oUF-initialConfigFunction', initconfig:format(aCoreCDB["UnitframeOptions"]["dpsraidwidth"], aCoreCDB["UnitframeOptions"]["dpsraidheight"], 1),
		'showPlayer', true,
		'showSolo', aCoreCDB["UnitframeOptions"]["showsolo"],
		'showParty', true,
		'showRaid', true,
		'xOffset', 5,
		'yOffset', -5,
		'point', "TOP",
		'groupFilter', aCoreCDB["UnitframeOptions"]["dpsgroupfilter"],
		'groupingOrder', aCoreCDB["UnitframeOptions"]["dpsraidgroupbyclass"] and "WARRIOR, DEATHKNIGHT, PALADIN, WARLOCK, SHAMAN, MAGE, MONK, HUNTER, PRIEST, ROGUE, DRUID" or "1,2,3,4,5,6,7,8",
		'groupBy', aCoreCDB["UnitframeOptions"]["dpsraidgroupbyclass"] and "CLASS" or "GROUP",
		'maxColumns', 8,
		'unitsPerColumn', aCoreCDB["UnitframeOptions"]["unitnumperline"],
		'columnSpacing', 5,
		'columnAnchorPoint', "LEFT"
	)
	dpsraid.movingname = L["输出模式团队框架"]
	dpsraid.point = {
		healer = {a1 = "TOPLEFT", parent = "UIParent", a2 = "TOPLEFT", x = 15, y = -146},
		dpser = {a1 = "TOPLEFT", parent = "UIParent", a2 = "TOPLEFT", x = 15, y = -146},
	}	
	T.CreateDragFrame(dpsraid)
	dpsraid.df:ClearAllPoints()
	local size, more
	local size
	if aCoreCDB["UnitframeOptions"]["dpsgroupfilter"] == "1,2,3,4,5,6,7,8" then
		size = 40
	elseif aCoreCDB["UnitframeOptions"]["dpsgroupfilter"] == "1,2,3,4,5,6" then
		size = 30
	elseif aCoreCDB["UnitframeOptions"]["dpsgroupfilter"] == "1,2,3,4" then
		size = 20
	else
		size = 10
	end
	if size%aCoreCDB["UnitframeOptions"]["unitnumperline"] == 0 then
		more = 0
	else
		more = 1
	end
	dpsraid.df:SetSize((math.floor(size/aCoreCDB["UnitframeOptions"]["unitnumperline"])+1)*aCoreCDB["UnitframeOptions"]["dpsraidwidth"], aCoreCDB["UnitframeOptions"]["unitnumperline"]*(aCoreCDB["UnitframeOptions"]["dpsraidheight"]+5)-5)
	dpspet = oUF:SpawnHeader('Altz_DpsPetRaid', 'SecureGroupPetHeaderTemplate', 'raid,party,solo',
		'oUF-initialConfigFunction', initconfig:format(aCoreCDB["UnitframeOptions"]["dpsraidwidth"], aCoreCDB["UnitframeOptions"]["dpsraidheight"], 1),
		'showPlayer', true,
		'showSolo', aCoreCDB["UnitframeOptions"]["showsolo"],
		'showParty', true,
		'showRaid', true,
		'xOffset', 5,
		'yOffset', -5,
		'point', "TOP",
		'groupFilter', aCoreCDB["UnitframeOptions"]["dpsgroupfilter"],
		'groupingOrder', aCoreCDB["UnitframeOptions"]["dpsraidgroupbyclass"] and "WARRIOR, DEATHKNIGHT, PALADIN, WARLOCK, SHAMAN, MAGE, MONK, HUNTER, PRIEST, ROGUE, DRUID" or "1,2,3,4,5,6,7,8",
		'groupBy', aCoreCDB["UnitframeOptions"]["dpsraidgroupbyclass"] and "CLASS" or "GROUP",
		'maxColumns', 8,
		'unitsPerColumn', aCoreCDB["UnitframeOptions"]["unitnumperline"],
		'columnSpacing', 5,
		'columnAnchorPoint', "LEFT" 
	)
	dpspet.movingname = L["输出模式宠物团队框架"]
	dpspet.point = {
		healer = {a1 = "TOPLEFT", parent = dpsraid:GetName(), a2 = "TOPRIGHT", x = 10, y = 0},
		dpser = {a1 = "TOPLEFT", parent = dpsraid:GetName(), a2 = "TOPRIGHT", x = 10, y = 0},
	}	
	T.CreateDragFrame(dpspet)
	dpspet.df:ClearAllPoints()
	dpspet.df:SetSize(aCoreCDB["UnitframeOptions"]["dpsraidwidth"], aCoreCDB["UnitframeOptions"]["unitnumperline"]*(aCoreCDB["UnitframeOptions"]["dpsraidheight"]+5)-5)
end

local function hiderf(f)
	if aCoreCDB["UnitframeOptions"]["showsolo"] and f:GetAttribute("showSolo") then f:SetAttribute("showSolo", false) end
	if f:GetAttribute("showParty") then f:SetAttribute("showParty", false) end
	if f:GetAttribute("showRaid") then f:SetAttribute("showRaid", false) end
end

local function showrf(f)
	if aCoreCDB["UnitframeOptions"]["showsolo"] and not f:GetAttribute("showSolo") then f:SetAttribute("showSolo", true) end
	if not f:GetAttribute("showParty") then f:SetAttribute("showParty", true) end
	if not f:GetAttribute("showRaid") then f:SetAttribute("showRaid", true) end
end

function togglerf()
	local Role = T.CheckRole()
	if Role == "healer" then
		hiderf(dpsraid)
		hiderf(dpspet)
		showrf(healerraid)
		if aCoreCDB["UnitframeOptions"]["showraidpet"] then showrf(healerpet) else hiderf(healerpet) end
	else
		hiderf(healerraid)
		hiderf(healerpet)
		showrf(dpsraid)
		if aCoreCDB["UnitframeOptions"]["showraidpet"] then showrf(dpspet) else hiderf(dpspet) end
	end
end

local EventFrame = CreateFrame("Frame")

EventFrame:RegisterEvent("ADDON_LOADED")
EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
EventFrame:RegisterEvent("PLAYER_LOGIN")

EventFrame:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

function EventFrame:ADDON_LOADED(arg1)
	if arg1 ~= "AltzUI" or not aCoreCDB["UnitframeOptions"]["enableraid"] then return end
	Spawnhealraid()
	Spawndpsraid()
end

function EventFrame:PLAYER_LOGIN()
	if aCoreCDB["UnitframeOptions"] == nil or not aCoreCDB["UnitframeOptions"]["enableraid"] then return end
	if aCoreCDB["UnitframeOptions"]["autoswitch"] then -- 禁用自动切换
		if aCoreCDB["UnitframeOptions"]["raidonly"] == "healer" then
			hiderf(dpsraid)
			hiderf(dpspet)
			showrf(healerraid)
			if aCoreCDB["UnitframeOptions"]["showraidpet"] then showrf(healerpet) else hiderf(healerpet) end
		elseif aCoreCDB["UnitframeOptions"]["raidonly"] == "dps" then
			hiderf(healerraid)
			hiderf(healerpet)
			showrf(dpsraid)
			if aCoreCDB["UnitframeOptions"]["showraidpet"] then showrf(dpspet) else hiderf(dpspet) end
		end
	else
		togglerf()
		EventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	end
end

function EventFrame:PLAYER_SPECIALIZATION_CHANGED(arg1)
	if arg1 == "player" then
		togglerf()
	end
end

function EventFrame:PLAYER_ENTERING_WORLD()
	if aCoreCDB["UnitframeOptions"] == nil or not aCoreCDB["UnitframeOptions"]["enableraid"] then return end
	CompactRaidFrameManager:Hide()
	CompactRaidFrameContainer:Hide()
	PartyMemberBackground:Hide()
	CompactRaidFrameManager.Show = CompactRaidFrameManager.Hide
	CompactRaidFrameContainer.Show = CompactRaidFrameContainer.Hide
	PartyMemberBackground.Show = PartyMemberBackground.Hide

	EventFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

-- 加入团队工具中
T.IsDpsRaidShown = function()
	if dpsraid:GetAttribute("showRaid") then
		return true
	end
end

T.SwitchRaidFrame = function()
	if dpsraid:GetAttribute("showRaid") then
		hiderf(dpsraid)
		hiderf(dpspet)
		showrf(healerraid)
		if aCoreCDB["UnitframeOptions"]["showraidpet"] then showrf(healerpet) else hiderf(healerpet) end
    else
		hiderf(healerraid)
		hiderf(healerpet)
		showrf(dpsraid)
		if aCoreCDB["UnitframeOptions"]["showraidpet"] then showrf(dpspet) else hiderf(dpspet) end
    end
end

