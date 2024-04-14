local T, C, L, G = unpack(select(2, ...))
local oUF = AltzUF or oUF

local Update = function(self, event, unit)
	if unit ~= self.unit or not InCombatLockdown() then return end
	
	local threatbar = self.ThreatBar
	local ind = self.ThreatBar.indictator
	local orientation = "HORIZONTAL"

	unit = unit or self.unit

	local isTanking, status, overtauntedprec, rawthreatprec = UnitDetailedThreatSituation("player", unit)
	
	if not overtauntedprec then
		T.UIFrameFadeOut(threatbar, 2, threatbar:GetAlpha(), 0)
		ind:ClearAllPoints()
		return
	else --if IsInRaid() or IsInGroup() then
		T.UIFrameFadeIn(threatbar, 1, threatbar:GetAlpha(), 1)
	end

	local Tankthreat
	if status <= 1 then -- unit is not tanking
		if rawthreatprec == 0 then
			Tankthreat = 0
		else
			Tankthreat = overtauntedprec/rawthreatprec*100
		end
		if rawthreatprec < 70 then -- safely threat
			threatbar:GetStatusBarTexture():SetGradient(orientation, CreateColor(.29, .09, .33, 1), CreateColor(.31, .94, .99, 1))
		elseif status == 1 then -- ot
			threatbar:GetStatusBarTexture():SetGradient(orientation, CreateColor(.48, .28, .02, 1), CreateColor(1, 0, 0, 1))
		else -- about to ot
			threatbar:GetStatusBarTexture():SetGradient(orientation, CreateColor(.48, .39, .04, 1), CreateColor(1, .41, .05, 1))
		end
	else -- unit is not tanking
		Tankthreat = overtauntedprec
		if status == 2 then -- about to lose threat
			threatbar:GetStatusBarTexture():SetGradient(orientation, CreateColor(.48, .39, .04, 1), CreateColor(1, .41, .05, 1))
		else -- safely tanking
			threatbar:GetStatusBarTexture():SetGradient(orientation, CreateColor(.27, .17, .12, 1), CreateColor(.92, .68, .31, 1))
		end
	end

	threatbar:SetValue(overtauntedprec)
	ind:SetPoint("CENTER", threatbar, "LEFT", Tankthreat/100*(threatbar:GetWidth()), 0)
end

local function ForceUpdate(element)
	return Update(element.__owner)
end

local Enable = function(self)
	local threatbar = self.ThreatBar
	if threatbar then
		threatbar.__owner = self
		threatbar.ForceUpdate = ForceUpdate
		
		threatbar:SetMinMaxValues(0, 100)
		threatbar:SetAlpha(0)
		threatbar.indictator = threatbar:CreateTexture(nil, "OVERLAY")
		threatbar.indictator:SetSize(15, threatbar:GetHeight()+10)
		threatbar.indictator:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
		threatbar.indictator:SetVertexColor(1, 1, 0)
		threatbar.indictator:SetBlendMode("ADD")

		threatbar:RegisterEvent("PLAYER_REGEN_ENABLED", true)
		threatbar:SetScript("OnEvent", function() T.UIFrameFadeOut(threatbar, 2, threatbar:GetAlpha(), 0) end)
		
		self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", Update, true)
		
		Update(self)
		
		return true
	end
end

local Disable = function(self)
	local threatbar = self.ThreatBar
	if threatbar then
		threatbar:UnregisterEvent("PLAYER_REGEN_ENABLED")
		self:UnregisterEvent("UNIT_THREAT_LIST_UPDATE", Update)
		
		T.UIFrameFadeOut(threatbar, 2, threatbar:GetAlpha(), 0)
	end
end

oUF:AddElement("ThreatBar", Update, Enable, Disable)