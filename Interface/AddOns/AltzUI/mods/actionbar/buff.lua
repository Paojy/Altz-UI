local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)

  ---------------------------------------
  -- FUNCTIONS
  ---------------------------------------

  --apply aura frame texture func
local function applySkin(aura)
	if not aura.styled then
		aura.Icon:SetTexCoord(0.1,0.9,0.1,0.9)
		aura.Icon:SetDrawLayer("BACKGROUND",-7)
		
		aura.duration:SetFont(G.numFont, 14, "THINOUTLINE")
		aura.duration:SetShadowOffset(0, 0)
		
		if aura.count then
			aura.count:SetFont(G.numFont, 14, "THINOUTLINE")
			aura.count:SetShadowOffset(0, 0)
			aura.count:ClearAllPoints()
			aura.count:SetPoint("TOPRIGHT", 2, 2)
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