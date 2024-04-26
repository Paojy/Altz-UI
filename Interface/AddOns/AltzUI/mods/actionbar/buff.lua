local T, C, L, G = unpack(select(2, ...))

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
				
		aura.bd = T.createBackdrop(aura.Icon, nil, 2, aura)
		
		hooksecurefunc(aura, "UpdateAuraType", function(self, auraType)
			self.DebuffBorder:Hide()
			self.TempEnchantBorder:Hide()		
			if self.auraType == "Buff" then
				self.bd:SetBackdropBorderColor(0, 0, 0)
			elseif self.auraType == "Debuff" or self.auraType == "DeadlyDebuff" then
				local color = DebuffTypeColor["none"]
				self.bd:SetBackdropBorderColor(color.r, color.g, color.b)
			elseif self.auraType == "TempEnchant" then
				self.bd:SetBackdropBorderColor(.5, 0, 1)
			end
		end)
		
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