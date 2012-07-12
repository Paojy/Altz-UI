local ADDON_NAME, ns = ...
local cfg = ns.cfg

if not cfg.enableraid then return end

local mediaPath = cfg.mediaPath
local texture = cfg.texture
local glowTex = cfg.glowTex
local font, fontsize = cfg.font, cfg.raidfontsize
local myclass = select(2, UnitClass("player"))
local Role

CheckRole = function()
	local role
	local tree = GetSpecialization()
	if ((myclass == "MONK" and tree == 2) or (myclass == "PRIEST" and (tree == 1 or tree ==2)) or (myclass == "PALADIN" and tree == 1)) or (myclass == "DRUID" and tree == 4) or (myclass == "SHAMAN" and tree == 3) then
		role = "Healer"
	end
	return role
end

local func = function(self, unit)

    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    self:RegisterForClicks"AnyUp"
	
	-- shadow border for health bar --
    ns.backdrop(self, self, 0, 3)

    local hp = CreateFrame("StatusBar", nil, self)
    hp:SetAllPoints(self)
	hp:SetStatusBarTexture(texture)
	
    hp.frequentUpdates = true
    hp.Smooth = true
    if cfg.smoothhealthcolor then
        self.colors.smooth = {1,0,0, 1,1,0, 1,1,0}
        hp.colorSmooth = true
    else
	    hp.colorClass = true
        hp.colorReaction = true
    end
	
	if not cfg.classcolormode then
		hp:SetReverseFill(true)
	end
	
	if not cfg.classcolormode then
		hp:SetReverseFill(true)
	end
	
	hp.PostUpdate = function(hp, unit, min, max)
	
		if not cfg.classcolormode then
			if UnitIsDeadOrGhost(unit) then hp:SetValue(0)
			else hp:SetValue(max - hp:GetValue()) end
		end
		
		return ns.updatehealthcolor(hp:GetParent(), 'PostUpdateHealth', unit)
	end
	
    self.Health = hp
	
	-- backdrop color --
	local gradient = hp:CreateTexture(nil, "BACKGROUND")
	gradient:SetPoint("TOPLEFT")
	gradient:SetPoint("BOTTOMRIGHT")
	gradient:SetTexture(cfg.texture)
	gradient:SetGradientAlpha("VERTICAL", .3, .3, .3, .3, .1, .1, .1, .3)
	
	self.gradient = gradient
	
    local info = hp:CreateFontString(nil, "OVERLAY")
    info:SetPoint("TOP")
    info:SetFont(font, fontsize-3, "OUTLINE")
    info:SetShadowOffset(0, 0)
    info:SetTextColor(1, 1, 1)
    self:Tag(info, '[Mlight:raidinfo]')
	
	local raidname = hp:CreateFontString(nil, "OVERLAY")
	raidname:SetPoint("BOTTOMRIGHT", hp, "BOTTOMRIGHT", -1, 5)

    raidname:SetFont(font, fontsize, "OUTLINE")
    raidname:SetShadowOffset(0, 0)
	if not cfg.classcolormode then
		self:Tag(raidname, '[Mlight:color][Mlight:shortname]')
	else
		self:Tag(raidname, '[Mlight:shortname]')
	end
	
    local ricon = hp:CreateTexture(nil, "OVERLAY")
    ricon:SetPoint("BOTTOM", hp, "TOP", 0 , -5)
    ricon:SetSize(10 ,10)
    self.RaidIcon = ricon

	-- Auras
    local auras = CreateFrame("Frame", nil, self)
    auras:SetSize(16, 16)
    auras:SetPoint("LEFT", hp, "LEFT", 5, 0)
	auras.tfontsize = 13
	auras.cfontsize = 8
	self.MlightAuras = auras
	

	-- Indicators
	self.MlightIndicators = true
	
	-- Range
    local range = {
        insideAlpha = 1,
        outsideAlpha = 0.5,
    }
    self.Range = range
	
end

local dfunc = function(self, unit)

    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    self:RegisterForClicks"AnyUp"
	
	-- shadow border for health bar --
    ns.backdrop(self, self, 0, 3)

    local hp = CreateFrame("StatusBar", nil, self)
    hp:SetAllPoints(self)
	hp:SetStatusBarTexture(texture)
	
    hp.frequentUpdates = true
    hp.Smooth = true
    if cfg.smoothhealthcolor then
        self.colors.smooth = {1,0,0, 1,1,0, 1,1,0}
        hp.colorSmooth = true
    else
	    hp.colorClass = true
        hp.colorReaction = true
    end
	
	if not cfg.classcolormode then
		hp:SetReverseFill(true)
	end
	
	if not cfg.classcolormode then
		hp:SetReverseFill(true)
	end
	
	hp.PostUpdate = function(hp, unit, min, max)
	
		if not cfg.classcolormode then
			if UnitIsDeadOrGhost(unit) then hp:SetValue(0)
			else hp:SetValue(max - hp:GetValue()) end
		end
		
		return ns.updatehealthcolor(hp:GetParent(), 'PostUpdateHealth', unit)
	end
	
    self.Health = hp
	
	-- backdrop color --
	local gradient = hp:CreateTexture(nil, "BACKGROUND")
	gradient:SetPoint("TOPLEFT")
	gradient:SetPoint("BOTTOMRIGHT")
	gradient:SetTexture(cfg.texture)
	gradient:SetGradientAlpha("VERTICAL", .3, .3, .3, .3, .1, .1, .1, .3)
	
	self.gradient = gradient
	
    local info = hp:CreateFontString(nil, "OVERLAY")
    info:SetPoint("TOP")
    info:SetFont(font, fontsize-3, "OUTLINE")
    info:SetShadowOffset(0, 0)
    info:SetTextColor(1, 1, 1)
    self:Tag(info, '[Mlight:raidinfo]')
	
	local raidname = hp:CreateFontString(nil, "OVERLAY")
	raidname:SetPoint("BOTTOMLEFT", hp, "BOTTOMRIGHT", 5, 0)

    raidname:SetFont(font, fontsize, "OUTLINE")
    raidname:SetShadowOffset(0, 0)
	if not cfg.classcolormode then
		self:Tag(raidname, '[Mlight:color][Mlight:shortname]')
	else
		self:Tag(raidname, '[Mlight:shortname]')
	end
	
    local ricon = hp:CreateTexture(nil, "OVERLAY")
    ricon:SetPoint("BOTTOM", hp, "TOP", 0 , -5)
    ricon:SetSize(10 ,10)
    self.RaidIcon = ricon

	-- Auras
    local auras = CreateFrame("Frame", nil, self)
    auras:SetSize(10, 10)
    auras:SetPoint("LEFT", hp, "LEFT", 5, 0)
	auras.tfontsize = 1
	auras.cfontsize = 1
	self.MlightAuras = auras
	
	-- Range
    local range = {
        insideAlpha = 1,
        outsideAlpha = 0.5,
    }
    self.Range = range
	
end

oUF:RegisterStyle("Mlight_Healerraid", func)
oUF:RegisterStyle("Mlight_DPSraid", dfunc)

local healerraid, dpsraid

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
'xoffset', 5,
'yOffset', -5,
'point', "LEFT",
'groupFilter', '1,2,3,4,5,6,7,8',
'groupingOrder', '1,2,3,4,5,6,7,8',
'groupBy', 'GROUP',
'maxColumns', 5,
'unitsPerColumn', 5,
'columnSpacing', 5,
'columnAnchorPoint', "TOP"
)
healerraid:SetPoint(unpack(cfg.healerraidposition))

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
'xoffset', 5,
'yOffset', -5,
'point', "TOP",
'groupFilter', '1,2,3,4,5,6,7,8',
'groupingOrder', '1,2,3,4,5,6,7,8',
'groupBy', 'GROUP',
'maxColumns', 5,
'unitsPerColumn', 5,
'columnSpacing', 5,
'columnAnchorPoint', "TOP"
)
dpsraid:SetPoint(unpack(cfg.dpsraidposition))

function hiderf(f)
	show = f.Show
	f:Hide()
	f.Show = f.Hide
	f.show = show
	f.mode = 0
end

function showrf(f)
	f.Show = f.show
	f:Show()
	f.mode = 1
end

hiderf(healerraid)
hiderf(dpsraid)

local RoleUpdater = CreateFrame("Frame")
function RoleUpdater:togglerf()
	Role = CheckRole()
	if Role then
		if dpsraid.mode == 1 then hiderf(dpsraid) end
		if healerraid.mode == 0 then showrf(healerraid) end
	else
		if healerraid.mode == 1 then hiderf(healerraid) end
		if dpsraid.mode == 0 then showrf(dpsraid) end
	end
end

RoleUpdater:RegisterEvent("PLAYER_ENTERING_WORLD")
RoleUpdater:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
RoleUpdater:RegisterEvent("PLAYER_TALENT_UPDATE")
RoleUpdater:RegisterEvent("CHARACTER_POINTS_CHANGED")
RoleUpdater:RegisterEvent("UNIT_INVENTORY_CHANGED")
RoleUpdater:RegisterEvent("UPDATE_BONUS_ACTIONBAR")

RoleUpdater:SetScript("OnEvent", RoleUpdater.togglerf)

local function SlashCmd(cmd)
    if (cmd:match"healer") then
		if dpsraid.mode == 1 then hiderf(dpsraid) end
		if healerraid.mode == 0 then showrf(healerraid) end
    elseif (cmd:match"dps") then
		if healerraid.mode == 1 then hiderf(healerraid) end
		if dpsraid.mode == 0 then showrf(dpsraid) end
    else
      print("|c0000FF00oUF_Mlight command list:|r")
      print("|c0000FF00\/rf healer")
      print("|c0000FF00\/rf dps")
    end
end

SlashCmdList["MlightRaid"] = SlashCmd;
SLASH_MlightRaid1 = "/rf"

--hide raid
local f = CreateFrame("Frame");
f:RegisterEvent("PLAYER_ENTERING_WORLD");

f.EventHandler = function(self, ...)
	CompactRaidFrameManager:Hide();
	CompactRaidFrameManager:UnregisterAllEvents();
	CompactRaidFrameContainer:Hide();
	CompactRaidFrameContainer:UnregisterAllEvents();
	CompactRaidFrameManager.Show = CompactRaidFrameManager.Hide;
	CompactRaidFrameContainer.Show = CompactRaidFrameContainer.Hide;
	
	self:UnregisterAllEvents();
	self:SetScript("OnEvent", nil);
	self = nil;
end

f:SetScript("OnEvent", f.EventHandler);