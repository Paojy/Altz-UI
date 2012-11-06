local addon, ns = ...

local texture = "Interface\\Buttons\\WHITE8x8"
local symbols = "Interface\\Addons\\oUF_Mlight\\media\\PIZZADUDEBULLETS.ttf"
local myclass = select(2, UnitClass("player"))
local highlighttexture = "Interface\\AddOns\\oUF_Mlight\\media\\highlight"

local createFont = ns.createFont
local createBackdrop = ns.createBackdrop
local Updatehealthbar = ns.Updatehealthbar
local Updatepowerbar = ns.Updatepowerbar
local OnMouseOver = ns.OnMouseOver
local createStatusbar = ns.createStatusbar
--=============================================--
--[[               Some update               ]]--
--=============================================--
local pxbackdrop = { edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=],  edgeSize = 1, }

local function Createpxborder(self, lvl)
	local pxbd = CreateFrame("Frame", nil, self)
	pxbd:SetPoint("TOPLEFT", self, "TOPLEFT", -2, 2)
	pxbd:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 2, -2)
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
	hpb:SetFrameLevel(3)
	hpb:SetStatusBarTexture(texture)
	hpb:SetStatusBarColor(...)
	hpb:SetPoint('TOP')
	hpb:SetPoint('BOTTOM')
	if oUF_MlightDB.transparentmode then
		hpb:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'LEFT')
	else
		hpb:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
	end
	hpb:SetWidth(200)
	return hpb
end

local function CreateHealPredition(self)
	local myBar = healpreditionbar(self, 110/255, 210/255, 0/255, 0.5)
	local otherBar = healpreditionbar(self, 0/255, 110/255, 0/255, 0.5)
	self.HealPrediction = {
		myBar = myBar,
		otherBar = otherBar,
		maxOverflow = 1,
	}
end

local function CreateGCDframe(self)
    local Gcd = CreateFrame("StatusBar", nil, self)
    Gcd:SetAllPoints(self)
    Gcd:SetStatusBarTexture(texture)
    Gcd:SetStatusBarColor(1, 1, 1, .4)
    Gcd:SetFrameLevel(5)
    self.GCD = Gcd
end

local function UpdateRaidMana(pp, unit, min, max)
	local _, ptype = UnitPowerType(unit)
	local self = pp:GetParent()
    if ptype == 'MANA' then
		pp:SetHeight(oUF_MlightDB.healerraidheight*-(oUF_MlightDB.raidhpheight-1))
		self.Health:SetPoint("BOTTOM", pp, "TOP", 0, 3)
		if min/max > 0.2 then
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
	Updatepowerbar(pp, unit, min, max)
end
--=============================================--
--[[              Click Cast                 ]]--
--=============================================--
local function RegisterClicks(object)
	local action, macrotext, key_tmp
	local C = oUF_MlightDB.ClickCast
	for id, var in pairs(C) do
		for	key, _ in pairs(C[id]) do
			key_tmp = string.gsub(key, "Click", "")
			action = C[id][key]["action"]
			if action == "follow" then
				object:SetAttribute(key_tmp.."type"..id, "macro")
				object:SetAttribute(key_tmp.."macrotext"..id, "/follow mouseover")
			elseif	action == "tot" then		
				object:SetAttribute(key_tmp.."type"..id, "macro")
				object:SetAttribute(key_tmp.."macrotext"..id, "/target mouseovertarget")
			elseif	action == "target" then		
				object:SetAttribute(key_tmp.."type"..id, "target")
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

	OnMouseOver(self)
    self:RegisterForClicks"AnyUp"
	self.mouseovers = {}
	
	-- highlight --
	self.hl = self:CreateTexture(nil, "HIGHLIGHT")
    self.hl:SetAllPoints()
    self.hl:SetTexture(highlighttexture)
    self.hl:SetVertexColor( 1, 1, 1, .3)
    self.hl:SetBlendMode("ADD")
	
	-- target border --
	self.targetborder = Createpxborder(self, 2)
	self.targetborder:SetBackdropBorderColor(1, 1, .4)
	self:RegisterEvent("PLAYER_TARGET_CHANGED", ChangedTarget)

	-- threat border --
	self.threatborder = Createpxborder(self, 1)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UpdateThreat)
	
    local hp = createStatusbar(self, texture, "ARTWORK", nil, nil, 1, 1, 1, 1)
	hp:SetFrameLevel(3)
    hp:SetAllPoints(self)
	hp:SetPoint("TOPLEFT", self, "TOPLEFT")
	hp:SetPoint("TOPRIGHT", self, "TOPRIGHT")
    hp.frequentUpdates = true
	
	-- little black line to make the health bar more clear
	hp.ind = hp:CreateTexture(nil, "OVERLAY", 1)
    hp.ind:SetTexture("Interface\\Buttons\\WHITE8x8")
	hp.ind:SetVertexColor(0, 0, 0)
	hp.ind:SetSize(1, self:GetHeight())
	if oUF_MlightDB.transparentmode then
		hp.ind:SetPoint("RIGHT", hp:GetStatusBarTexture(), "LEFT", 0, 0)
	else
		hp.ind:SetPoint("LEFT", hp:GetStatusBarTexture(), "RIGHT", 0, 0)
	end
	
	if oUF_MlightDB.transparentmode then
		hp:SetReverseFill(true)
	end
	
	-- border --
	self.backdrop = createBackdrop(hp, hp, 0)
	
	-- health backdrop --
	self.bg = self:CreateTexture(nil, "BACKGROUND")
    self.bg:SetAllPoints(hp)
    self.bg:SetTexture(texture)
	if oUF_MlightDB.transparentmode then
		self.bg:SetGradientAlpha("VERTICAL", oUF_MlightDB.endcolor.r, oUF_MlightDB.endcolor.g, oUF_MlightDB.endcolor.b, oUF_MlightDB.endcolor.a, oUF_MlightDB.startcolor.r, oUF_MlightDB.startcolor.g, oUF_MlightDB.startcolor.b, oUF_MlightDB.startcolor.a)
	else
		self.bg:SetGradientAlpha("VERTICAL", oUF_MlightDB.endcolor.r, oUF_MlightDB.endcolor.g, oUF_MlightDB.endcolor.b, 1, oUF_MlightDB.startcolor.r, oUF_MlightDB.startcolor.g, oUF_MlightDB.startcolor.b, 1)
	end
	
    self.Health = hp
	self.Health.PostUpdate = Updatehealthbar
	
	-- raid manabars --
	if oUF_MlightDB.raidmanabars == true then
		local pp = createStatusbar(self, texture, "ARTWORK", nil, nil, 1, 1, 1, 1)
		pp:SetFrameLevel(3)
		pp:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT")
		pp:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
		pp.backdrop = createBackdrop(pp, pp, 1)
		
		self.Power = pp
		self.Power.PostUpdate = UpdateRaidMana
	else
		self.Health:SetPoint("BOTTOM", self, "BOTTOM")
	end
	
	-- gcd frane --
	if oUF_MlightDB.showgcd then
		CreateGCDframe(self)
	end
	
	-- heal prediction --
	if oUF_MlightDB.healprediction then
		CreateHealPredition(self)
	end
	
	local leader = hp:CreateTexture(nil, "OVERLAY", 1)
    leader:SetSize(12, 12)
    leader:SetPoint("BOTTOMLEFT", hp, "BOTTOMLEFT", 5, -5)
    self.Leader = leader

	local assistant = hp:CreateTexture(nil, "OVERLAY", 1)
    assistant:SetSize(12, 12)
    assistant:SetPoint("BOTTOMLEFT", hp, "BOTTOMLEFT", 5, -5)
	self.Assistant = assistant
	
    local masterlooter = hp:CreateTexture(nil, 'OVERLAY', 1)
    masterlooter:SetSize(12, 12)
    masterlooter:SetPoint('LEFT', leader, 'RIGHT')
    self.MasterLooter = masterlooter

	local lfd = createFont(hp, "OVERLAY", symbols, oUF_MlightDB.raidfontsize-3, 1, 1, 1)
	lfd:SetPoint("BOTTOM", hp, 0, -1)
	self:Tag(lfd, '[Mlight:LFD]')
	
	local raidname = createFont(hp, "OVERLAY", oUF_MlightDB.fontfile, oUF_MlightDB.raidfontsize, 1, 1, 1)
	raidname:SetPoint("BOTTOMRIGHT", hp, "BOTTOMRIGHT", -1, 5)
	if oUF_MlightDB.nameclasscolormode then
		self:Tag(raidname, '[Mlight:color][Mlight:raidname]')
	else
		self:Tag(raidname, '[Mlight:raidname]')
	end
	self.Name = raidname
	
    local ricon = hp:CreateTexture(nil, "OVERLAY", 1)
	ricon:SetSize(10 ,10)
    ricon:SetPoint("BOTTOM", hp, "TOP", 0 , -5)
    self.RaidIcon = ricon
	
	local status = createFont(hp, "OVERLAY", oUF_MlightDB.fontfile, oUF_MlightDB.raidfontsize-2, 1, 1, 1)
    status:SetPoint"TOPLEFT"
	self:Tag(status, '[Mlight:AfkDnd][Mlight:DDG]')
	
	local resurrecticon = hp:CreateTexture(nil, "OVERLAY")
    resurrecticon:SetSize(16, 16)
    resurrecticon:SetPoint"CENTER"
    self.ResurrectIcon = resurrecticon
	
    local readycheck = self:CreateTexture(nil, 'OVERLAY', 1)
    readycheck:SetSize(16, 16)
    readycheck:SetPoint"CENTER"
    self.ReadyCheck = readycheck
   
	-- Raid debuff
    local auras = CreateFrame("Frame", nil, self)
	auras:SetFrameLevel(4)
    auras:SetSize(16, 16)
    auras:SetPoint("LEFT", hp, "LEFT", 15, 0)
	auras.tfontsize = 10
	auras.cfontsize = 10
	self.MlightAuras = auras
	
	-- Tankbuff
    local tankbuff = CreateFrame("Frame", nil, self)
	tankbuff:SetFrameLevel(4)
    tankbuff:SetSize(16, 16)
    tankbuff:SetPoint("LEFT", auras, "RIGHT", 5, 0)
	tankbuff.tfontsize = 10
	tankbuff.cfontsize = 10
	self.MlightTankbuff = tankbuff
	
	-- Indicators
	self.MlightIndicators = true
	
	-- Range
    local range = {
        insideAlpha = 1,
        outsideAlpha = 0.5,
    }
	
	if oUF_MlightDB.enablearrow then
		self.freebRange = range
	else
		self.Range = range
	end
	
	if oUF_MlightDB.enableClickCast then
		RegisterClicks(self)
	end
end

local dfunc = function(self, unit)

	OnMouseOver(self)
    self:RegisterForClicks"AnyUp"
	self.mouseovers = {}
	
	-- highlight --
	self.hl = self:CreateTexture(nil, "HIGHLIGHT")
    self.hl:SetAllPoints()
    self.hl:SetTexture(highlighttexture)
    self.hl:SetVertexColor( 1, 1, 1, .3)
    self.hl:SetBlendMode("ADD")
	
	-- backdrop --
	self.bg = self:CreateTexture(nil, "BACKGROUND")
    self.bg:SetAllPoints()
    self.bg:SetTexture(texture)
	if oUF_MlightDB.transparentmode then
		self.bg:SetGradientAlpha("VERTICAL", oUF_MlightDB.endcolor.r, oUF_MlightDB.endcolor.g, oUF_MlightDB.endcolor.b, oUF_MlightDB.endcolor.a, oUF_MlightDB.startcolor.r, oUF_MlightDB.startcolor.g, oUF_MlightDB.startcolor.b, oUF_MlightDB.startcolor.a)
	else
		self.bg:SetGradientAlpha("VERTICAL", oUF_MlightDB.endcolor.r, oUF_MlightDB.endcolor.g, oUF_MlightDB.endcolor.b, 1, oUF_MlightDB.startcolor.r, oUF_MlightDB.startcolor.g, oUF_MlightDB.startcolor.b, 1)
	end
	
	-- border --
	self.backdrop = createBackdrop(self, self, 0)
	
    local hp = createStatusbar(self, texture, "ARTWORK", nil, nil, 1, 1, 1, 1)
	hp:SetFrameLevel(3)
    hp:SetAllPoints(self)
    hp.frequentUpdates = true
	
	-- little black line to make the health bar more clear
	hp.ind = hp:CreateTexture(nil, "OVERLAY", 1)
    hp.ind:SetTexture("Interface\\Buttons\\WHITE8x8")
	hp.ind:SetVertexColor(0, 0, 0)
	hp.ind:SetSize(1, self:GetHeight())
	if oUF_MlightDB.transparentmode then
		hp.ind:SetPoint("RIGHT", hp:GetStatusBarTexture(), "LEFT", 0, 0)
	else
		hp.ind:SetPoint("LEFT", hp:GetStatusBarTexture(), "RIGHT", 0, 0)
	end
	
	if oUF_MlightDB.transparentmode then
		hp:SetReverseFill(true)
	end
	
    self.Health = hp
	self.Health.PostUpdate = Updatehealthbar
	
	local leader = hp:CreateTexture(nil, "OVERLAY", 1)
    leader:SetSize(8, 8)
    leader:SetPoint("BOTTOMLEFT", hp, "BOTTOMLEFT", 5, -5)
    self.Leader = leader

	local assistant = hp:CreateTexture(nil, "OVERLAY", 1)
    assistant:SetSize(8, 8)
    assistant:SetPoint("BOTTOMLEFT", hp, "BOTTOMLEFT", 5, -5)
	self.Assistant = assistant
	
    local masterlooter = hp:CreateTexture(nil, 'OVERLAY', 1)
    masterlooter:SetSize(8, 8)
    masterlooter:SetPoint('LEFT', leader, 'RIGHT')
    self.MasterLooter = masterlooter
	
	local lfd = createFont(hp, "OVERLAY", symbols, oUF_MlightDB.raidfontsize-3, 1, 1, 1)
	lfd:SetPoint("LEFT", hp, 1, -1)
	self:Tag(lfd, '[Mlight:LFD]')
		
	local raidname = createFont(hp, "OVERLAY", oUF_MlightDB.fontfile, oUF_MlightDB.raidfontsize, 1, 1, 1, 'RIGHT')
	raidname:SetPoint"CENTER"
	if oUF_MlightDB.nameclasscolormode then
		self:Tag(raidname, '[Mlight:color][Mlight:raidname]')
	else
		self:Tag(raidname, '[Mlight:raidname]')
	end
	self.Name = raidname
	
    local ricon = hp:CreateTexture(nil, "OVERLAY", 1)
	ricon:SetSize(10 ,10)
    ricon:SetPoint("BOTTOM", hp, "TOP", 0 , -5)
    self.RaidIcon = ricon
	
	local status = createFont(hp, "OVERLAY", oUF_MlightDB.fontfile, oUF_MlightDB.raidfontsize-2, 1, 1, 1)
    status:SetPoint"TOPLEFT"
	self:Tag(status, '[Mlight:AfkDnd][Mlight:DDG]')
	
	local readycheck = self:CreateTexture(nil, 'OVERLAY', 1)
    readycheck:SetSize(16, 16)
    readycheck:SetPoint"CENTER"
    self.ReadyCheck = readycheck
	
	-- Range
    local range = {
        insideAlpha = 1,
        outsideAlpha = 0.5,
    }
	
	if oUF_MlightDB.enablearrow then
		self.freebRange = range
	else
		self.Range = range
	end
	
	if oUF_MlightDB.enableClickCast then
		RegisterClicks(self)
	end
end

oUF:RegisterStyle("Mlight_Healerraid", func)
oUF:RegisterStyle("Mlight_DPSraid", dfunc)

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
	oUF:SetActiveStyle"Mlight_Healerraid"
	healerraid = oUF:SpawnHeader('HealerRaid_Mlight', nil, 'raid,party,solo',
		'oUF-initialConfigFunction', initconfig:format(oUF_MlightDB.healerraidwidth, oUF_MlightDB.healerraidheight, 1),
		'showPlayer', true,
		'showSolo', oUF_MlightDB.showsolo,
		'showParty', true,
		'showRaid', true,
		'xOffset', 5,
		'yOffset', -5,
		'point', oUF_MlightDB.anchor,
		'groupFilter', oUF_MlightDB.healergroupfilter,
		'groupingOrder', '1,2,3,4,5,6,7,8',
		'groupBy', 'GROUP',
		'maxColumns', 8,
		'unitsPerColumn', 5,
		'columnSpacing', 5,
		'columnAnchorPoint', oUF_MlightDB.partyanchor
	)
	healerraid:SetPoint('TOPLEFT', 'UIParent', 'CENTER', 150, -100)
	healerpet = oUF:SpawnHeader('HealerPetRaid_Mlight', 'SecureGroupPetHeaderTemplate', 'raid,party,solo',
		'oUF-initialConfigFunction', initconfig:format(oUF_MlightDB.healerraidwidth, oUF_MlightDB.healerraidheight, 1),
		'showPlayer', true,
		'showSolo', oUF_MlightDB.showsolo,
		'showParty', true,
		'showRaid', true,
		'xOffset', 5,
		'yOffset', -5,
		'point', oUF_MlightDB.anchor,
		'groupFilter', oUF_MlightDB.healergroupfilter,
		'groupingOrder', '1,2,3,4,5,6,7,8',
		'groupBy', 'GROUP',
		'maxColumns', 8,
		'unitsPerColumn', 5,
		'columnSpacing', 5,
		'columnAnchorPoint', oUF_MlightDB.partyanchor,
		--'useOwnerUnit', true,
		'unitsuffix', 'pet'
	)
	healerpet:SetPoint('TOPLEFT', healerraid, 'TOPRIGHT', 10, 0)
end

local function Spawndpsraid()
	oUF:SetActiveStyle"Mlight_DPSraid"
	dpsraid = oUF:SpawnHeader('DpsRaid_Mlight', nil, 'raid,party,solo',
		'oUF-initialConfigFunction', initconfig:format(oUF_MlightDB.dpsraidwidth, oUF_MlightDB.dpsraidheight, 1),
		'showPlayer', true,
		'showSolo', oUF_MlightDB.showsolo,
		'showParty', true,
		'showRaid', true,
		'xOffset', 5,
		'yOffset', -5,
		'point', "TOP",
		'groupFilter', oUF_MlightDB.dpsgroupfilter,
		'groupingOrder', oUF_MlightDB.dpsraidgroupbyclass and "WARRIOR, DEATHKNIGHT, PALADIN, WARLOCK, SHAMAN, MAGE, MONK, HUNTER, PRIEST, ROGUE, DRUID" or "1,2,3,4,5,6,7,8",
		'groupBy', oUF_MlightDB.dpsraidgroupbyclass and "CLASS" or "GROUP",
		'maxColumns', 8,
		'unitsPerColumn', tonumber(oUF_MlightDB.unitnumperline),
		'columnSpacing', 5,
		'columnAnchorPoint', "LEFT"
	)
	dpsraid:SetPoint("TOPLEFT", 'UIParent', "TOPLEFT", 14, -180)
	dpspet = oUF:SpawnHeader('DpsPetRaid_Mlight', 'SecureGroupPetHeaderTemplate', 'raid,party,solo',
		'oUF-initialConfigFunction', initconfig:format(oUF_MlightDB.dpsraidwidth, oUF_MlightDB.dpsraidheight, 1),
		'showPlayer', true,
		'showSolo', oUF_MlightDB.showsolo,
		'showParty', true,
		'showRaid', true,
		'xOffset', 5,
		'yOffset', -5,
		'point', "TOP",
		'groupFilter', oUF_MlightDB.dpsgroupfilter,
		'groupingOrder', oUF_MlightDB.dpsraidgroupbyclass and "WARRIOR, DEATHKNIGHT, PALADIN, WARLOCK, SHAMAN, MAGE, MONK, HUNTER, PRIEST, ROGUE, DRUID" or "1,2,3,4,5,6,7,8",
		'groupBy', oUF_MlightDB.dpsraidgroupbyclass and "CLASS" or "GROUP",
		'maxColumns', 8,
		'unitsPerColumn', tonumber(oUF_MlightDB.unitnumperline),
		'columnSpacing', 5,
		'columnAnchorPoint', "LEFT" 
	)
	dpspet:SetPoint('TOPLEFT', dpsraid, 'TOPRIGHT', 10, 0)
end

local function CheckRole()
	local role
	local tree = GetSpecialization()
	if ((myclass == "MONK" and tree == 2) or (myclass == "PRIEST" and (tree == 1 or tree ==2)) or (myclass == "PALADIN" and tree == 1)) or (myclass == "DRUID" and tree == 4) or (myclass == "SHAMAN" and tree == 3) then
		role = "Healer"
	end
	return role
end

local function hiderf(f)
	if oUF_MlightDB.showsolo and f:GetAttribute("showSolo") then f:SetAttribute("showSolo", false) end
	if f:GetAttribute("showParty") then f:SetAttribute("showParty", false) end
	if f:GetAttribute("showRaid") then f:SetAttribute("showRaid", false) end
end

local function showrf(f)
	if oUF_MlightDB.showsolo and not f:GetAttribute("showSolo") then f:SetAttribute("showSolo", true) end
	if not f:GetAttribute("showParty") then f:SetAttribute("showParty", true) end
	if not f:GetAttribute("showRaid") then f:SetAttribute("showRaid", true) end
end

function togglerf()
	local Role = CheckRole()
	if Role then
		hiderf(dpsraid)
		hiderf(dpspet)
		showrf(healerraid)
		if oUF_MlightDB.showraidpet then showrf(healerpet) else hiderf(healerpet) end
	else
		hiderf(healerraid)
		hiderf(healerpet)
		showrf(dpsraid)
		if oUF_MlightDB.showraidpet then showrf(dpspet) else hiderf(dpspet) end
	end
end

local EventFrame = CreateFrame("Frame")

EventFrame:RegisterEvent("ADDON_LOADED")
EventFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

EventFrame:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

function EventFrame:ADDON_LOADED(arg1)
	if arg1 ~= "oUF_Mlight" or not oUF_MlightDB.enableraid then return end
	Spawnhealraid()
	Spawndpsraid()
end

function EventFrame:PLAYER_TALENT_UPDATE()
	if oUF_MlightDB == nil or not oUF_MlightDB.enableraid then return end
	if oUF_MlightDB.autoswitch then
		if oUF_MlightDB.raidonlyhealer then
			hiderf(dpsraid)
			hiderf(dpspet)
			showrf(healerraid)
			if oUF_MlightDB.showraidpet then showrf(healerpet) else hiderf(healerpet) end
		elseif oUF_MlightDB.raidonlydps then
			hiderf(healerraid)
			hiderf(healerpet)
			showrf(dpsraid)
			if oUF_MlightDB.showraidpet then showrf(dpspet) else hiderf(dpspet) end
		else
			togglerf()
		end
		EventFrame:UnregisterEvent("PLAYER_TALENT_UPDATE")
	else
		togglerf()
	end
end

function EventFrame:PLAYER_ENTERING_WORLD()
	if oUF_MlightDB == nil or not oUF_MlightDB.enableraid then return end
	CompactRaidFrameManager:Hide()
	CompactRaidFrameManager:UnregisterAllEvents()
	CompactRaidFrameContainer:Hide()
	CompactRaidFrameContainer:UnregisterAllEvents()
	CompactRaidFrameManager.Show = CompactRaidFrameManager.Hide
	CompactRaidFrameContainer.Show = CompactRaidFrameContainer.Hide

	EventFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

local function SlashCmd(cmd)
    if (cmd:match"healer") then
		hiderf(dpsraid)
		hiderf(dpspet)
		showrf(healerraid)
		if oUF_MlightDB.showraidpet then showrf(healerpet) else hiderf(healerpet) end
    elseif (cmd:match"dps") then
		hiderf(healerraid)
		hiderf(healerpet)
		showrf(dpsraid)
		if oUF_MlightDB.showraidpet then showrf(dpspet) else hiderf(dpspet) end
    else
      print("|c0000FF00oUF_Mlight command list:|r")
      print("|c0000FF00\/rf healer")
      print("|c0000FF00\/rf dps")
    end
end

SlashCmdList["MlightRaid"] = SlashCmd;
SLASH_MlightRaid1 = "/rf"