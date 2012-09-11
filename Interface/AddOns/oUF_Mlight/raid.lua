local ADDON_NAME, ns = ...
local cfg = ns.cfg

if not cfg.enableraid then return end

local texture = cfg.texture
local font, fontflag = cfg.font, cfg.fontflag
local fontsize = cfg.raidfontsize
local symbols = "Interface\\Addons\\oUF_Mlight\\media\\PIZZADUDEBULLETS.ttf"
local myclass = select(2, UnitClass("player"))

local createFont = ns.createFont
local createBackdrop = ns.createBackdrop
local Updatehealthbar = ns.Updatehealthbar
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

local function healpreditionbar(self, color)
	local hpb = CreateFrame('StatusBar', nil, self.Health)
	hpb:SetFrameLevel(2)
	hpb:SetStatusBarTexture(texture)
	hpb:SetStatusBarColor(unpack(color))
	hpb:SetPoint('TOP')
	hpb:SetPoint('BOTTOM')
	if cfg.tranparentmode then
		hpb:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'LEFT')
	else
		hpb:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
	end
	hpb:SetWidth(200)
	return hpb
end

local function CreateHealPredition(self)
	local myBar = healpreditionbar(self, cfg.healprediction.mycolor)
	local otherBar = healpreditionbar(self, cfg.healprediction.othercolor)
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
    Gcd:SetFrameLevel(4)
    self.GCD = Gcd
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
    self.hl:SetTexture(cfg.highlighttexture)
    self.hl:SetVertexColor( 1, 1, 1, .3)
    self.hl:SetBlendMode("ADD")
	
	-- backdrop --
	self.bg = self:CreateTexture(nil, "BACKGROUND")
    self.bg:SetAllPoints()
    self.bg:SetTexture(cfg.texture)
	if cfg.tranparentmode then
		self.bg:SetGradientAlpha("VERTICAL", .5, .5, .5, .5, 0, 0, 0, .2)
	else
		self.bg:SetGradientAlpha("VERTICAL", .3, .3, .3, 1, .1, .1, .1, 1)
	end
	
	-- border --
	self.backdrop = createBackdrop(self, self, 0)
	
	-- target border --
	self.targetborder = Createpxborder(self, 1)
	self.targetborder:SetBackdropBorderColor(1, 1, .4)
	self:RegisterEvent("PLAYER_TARGET_CHANGED", ChangedTarget)

	-- threat border --
	self.threatborder = Createpxborder(self, 0)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UpdateThreat)
	
    local hp = createStatusbar(self, cfg.texture, "ARTWORK", nil, nil, 1, 1, 1, 1)
	hp:SetFrameLevel(2)
    hp:SetAllPoints(self)
    hp.frequentUpdates = true
	
	if cfg.tranparentmode then
		hp:SetReverseFill(true)
	end
	
    self.Health = hp
	self.Health.PostUpdate = Updatehealthbar
	
	-- gcd frane --
	if cfg.showgcd then
		CreateGCDframe(self)
	end
	
	-- heal prediction --
	if cfg.healprediction.enable then
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

	local lfd = createFont(hp, "OVERLAY", symbols, fontsize-3, fontflag, 1, 1, 1)
	lfd:SetPoint("BOTTOM", hp, 0, -1)
	self:Tag(lfd, '[Mlight:LFD]')
	
	local raidname = createFont(hp, "OVERLAY", font, fontsize, fontflag, 1, 1, 1)
	raidname:SetPoint("BOTTOMRIGHT", hp, "BOTTOMRIGHT", -1, 5)
	if cfg.nameclasscolormode then
		self:Tag(raidname, '[Mlight:color][Mlight:raidname]')
	else
		self:Tag(raidname, '[Mlight:raidname]')
	end
	
    local ricon = hp:CreateTexture(nil, "OVERLAY", 1)
	ricon:SetSize(10 ,10)
    ricon:SetPoint("BOTTOM", hp, "TOP", 0 , -5)
    self.RaidIcon = ricon
	
	local status = createFont(hp, "OVERLAY", font, fontsize-2, fontflag, 1, 1, 1)
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
	auras:SetFrameLevel(3)
    auras:SetSize(16, 16)
    auras:SetPoint("LEFT", hp, "LEFT", 15, 0)
	auras.tfontsize = 10
	auras.cfontsize = 10
	self.MlightAuras = auras
	
	-- Tankbuff
    local tankbuff = CreateFrame("Frame", nil, self)
	tankbuff:SetFrameLevel(3)
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
	
	if cfg.arrow.enable then
		self.freebRange = range
	else
		self.Range = range
	end
end

local dfunc = function(self, unit)

	OnMouseOver(self)
    self:RegisterForClicks"AnyUp"
	self.mouseovers = {}
	
	-- highlight --
	self.hl = self:CreateTexture(nil, "HIGHLIGHT")
    self.hl:SetAllPoints()
    self.hl:SetTexture(cfg.highlighttexture)
    self.hl:SetVertexColor( 1, 1, 1, .3)
    self.hl:SetBlendMode("ADD")
	
	-- backdrop --
	self.bg = self:CreateTexture(nil, "BACKGROUND")
    self.bg:SetAllPoints()
    self.bg:SetTexture(cfg.texture)
	if cfg.tranparentmode then
		self.bg:SetGradientAlpha("VERTICAL", .5, .5, .5, .5, 0, 0, 0, .2)
	else
		self.bg:SetGradientAlpha("VERTICAL", .3, .3, .3, 1, .1, .1, .1, 1)
	end
	
	-- border --
	self.backdrop = createBackdrop(self, self, 0)
	
    local hp = createStatusbar(self, cfg.texture, "ARTWORK", nil, nil, 1, 1, 1, 1)
	hp:SetFrameLevel(2)
    hp:SetAllPoints(self)
    hp.frequentUpdates = true
	
	if cfg.tranparentmode then
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
	
	local lfd = createFont(hp, "OVERLAY", symbols, fontsize-3, fontflag, 1, 1, 1)
	lfd:SetPoint("LEFT", hp, 1, -1)
	self:Tag(lfd, '[Mlight:LFD]')
		
	local raidname = createFont(hp, "OVERLAY", font, fontsize, fontflag, 1, 1, 1, 'RIGHT')
	raidname:SetPoint"CENTER"
	if cfg.nameclasscolormode then
		self:Tag(raidname, '[Mlight:color][Mlight:raidname]')
	else
		self:Tag(raidname, '[Mlight:raidname]')
	end
	
    local ricon = hp:CreateTexture(nil, "OVERLAY", 1)
	ricon:SetSize(10 ,10)
    ricon:SetPoint("BOTTOM", hp, "TOP", 0 , -5)
    self.RaidIcon = ricon
	
	local status = createFont(hp, "OVERLAY", font, fontsize-2, fontflag, 1, 1, 1)
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
	
	if cfg.arrow.enable then
		self.freebRange = range
	else
		self.Range = range
	end
end

oUF:RegisterStyle("Mlight_Healerraid", func)
oUF:RegisterStyle("Mlight_DPSraid", dfunc)

local healerraid
local dpsraid

local function Spawnhealraid()
	oUF:SetActiveStyle"Mlight_Healerraid"
	healerraid = oUF:SpawnHeader('HealerRaid_Mlight', nil, 'raid,party,solo',
		'oUF-initialConfigFunction', ([[
		self:SetWidth(%d)
		self:SetHeight(%d)
		self:SetScale(%d)
		]]):format(cfg.healerraidwidth, cfg.healerraidheight, 1),
		'showPlayer', true,
		'showSolo', cfg.showsolo,
		'showParty', true,
		'showRaid', true,
		'xOffset', 5,
		'yOffset', -5,
		'point', cfg.anchor,
		'groupFilter', cfg.healergroupfilter,
		'groupingOrder', '1,2,3,4,5,6,7,8',
		'groupBy', 'GROUP',
		'maxColumns', 8,
		'unitsPerColumn', 5,
		'columnSpacing', 5,
		'columnAnchorPoint', cfg.partyanchor
	)
	healerraid:SetPoint(unpack(cfg.healerraidposition))
end

local groupBy = cfg.dpsraidgroupbyclass and "CLASS" or "GROUP"
local groupingOrder = cfg.dpsraidgroupbyclass and "WARRIOR, DEATHKNIGHT, PALADIN, WARLOCK, SHAMAN, MAGE, MONK, HUNTER, PRIEST, ROGUE, DRUID" or "1,2,3,4,5,6,7,8"

local function Spawndpsraid()
	oUF:SetActiveStyle"Mlight_DPSraid"
	dpsraid = oUF:SpawnHeader('DpsRaid_Mlight', nil, 'raid,party,solo',
		'oUF-initialConfigFunction', ([[
		self:SetWidth(%d)
		self:SetHeight(%d)
		self:SetScale(%d)
		]]):format(cfg.dpsraidwidth, cfg.dpsraidheight, 1),
		'showPlayer', true,
		'showSolo', cfg.showsolo,
		'showParty', true,
		'showRaid', true,
		'xOffset', 5,
		'yOffset', -5,
		'point', "TOP",
		'groupFilter', cfg.dpsgroupfilter,
		'groupingOrder', groupingOrder,
		'groupBy', groupBy,
		'maxColumns', 8,
		'unitsPerColumn', cfg.unitnumperline,
		'columnSpacing', 5,
		'columnAnchorPoint', "LEFT"
	)
	dpsraid:SetPoint(unpack(cfg.dpsraidposition))
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
	if cfg.showsolo and f:GetAttribute("showSolo") then f:SetAttribute("showSolo", false) end
	if f:GetAttribute("showParty") then f:SetAttribute("showParty", false) end
	if f:GetAttribute("showRaid") then f:SetAttribute("showRaid", false) end
end

local function showrf(f)
	if cfg.showsolo and not f:GetAttribute("showSolo") then f:SetAttribute("showSolo", true) end
	if not f:GetAttribute("showParty") then f:SetAttribute("showParty", true) end
	if not f:GetAttribute("showRaid") then f:SetAttribute("showRaid", true) end
end

function togglerf()
	local Role = CheckRole()
	if Role then
		hiderf(dpsraid)
		showrf(healerraid)
	else
		hiderf(healerraid)
		showrf(dpsraid)
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
	if arg1 ~= "oUF_Mlight" then return end
	Spawnhealraid()
	Spawndpsraid()
end

function EventFrame:PLAYER_TALENT_UPDATE()
	if not cfg.switch.auto then
		if cfg.switch.onlyhealer then
			hiderf(dpsraid)
			showrf(healerraid)
		elseif cfg.switch.onlydps then
			hiderf(healerraid)
			showrf(dpsraid)
		else
			togglerf()
		end
		EventFrame:UnregisterEvent("PLAYER_TALENT_UPDATE")
	else
		togglerf()
	end
end

function EventFrame:PLAYER_ENTERING_WORLD()
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
		showrf(healerraid)
    elseif (cmd:match"dps") then
		hiderf(healerraid)
		showrf(dpsraid)
    else
      print("|c0000FF00oUF_Mlight command list:|r")
      print("|c0000FF00\/rf healer")
      print("|c0000FF00\/rf dps")
    end
end

SlashCmdList["MlightRaid"] = SlashCmd;
SLASH_MlightRaid1 = "/rf"