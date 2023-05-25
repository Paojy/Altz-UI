local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)

  ---------------------------------------
  -- FUNCTIONS
  ---------------------------------------

  --apply aura frame texture func
local function applySkin(aura)
	if not aura.isAuraAnchor and not aura.styled then
		aura.Icon:SetTexCoord(0.1,0.9,0.1,0.9)
		aura.Icon:SetDrawLayer("BACKGROUND",-7)
		
		aura.Duration:SetFont(G.norFont, 10, "THINOUTLINE")
		aura.Duration:SetShadowOffset(0, 0)
		
		if aura.Count then
			aura.Count:SetFont(G.norFont, 10, "THINOUTLINE")
			aura.Count:SetShadowOffset(0, 0)
			aura.Count:ClearAllPoints()
			aura.Count:SetPoint("TOPRIGHT", 2, 2)
		end
		
		aura.bd = T.createBackdrop(aura, aura.Icon, 0)
		
		if aura.GetFilter and aura:GetFilter() == "HARMFUL" then
			aura.Border:SetTexture(G.media.blank)
			aura.Border:SetDrawLayer("BACKGROUND",-8)
			aura.bd:SetPoint("TOPLEFT", aura.Icon, "TOPLEFT", -4, 4)
			aura.bd:SetPoint("BOTTOMRIGHT", aura.Icon, "BOTTOMRIGHT", 4, -4)
		end
		
		aura.styled = true
	end
end

  --update buff
local function updateBufflayout()
	for index, aura in ipairs(BuffFrame.auraFrames) do
		applySkin(aura)
	end
end

  --update debuff
local function updateDebufflayout()
	for index, aura in ipairs(DebuffFrame.auraFrames) do
		applySkin(aura)
	end
end
  ---------------------------------------
  -- INIT
  ---------------------------------------

--hook Blizzard functions
hooksecurefunc(BuffFrame.AuraContainer, "UpdateGridLayout", updateBufflayout)
hooksecurefunc(DebuffFrame.AuraContainer, "UpdateGridLayout", updateDebufflayout)