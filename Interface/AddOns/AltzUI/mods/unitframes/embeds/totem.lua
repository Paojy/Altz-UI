local T, C, L, G = unpack(select(2, ...))
local oUF = AltzUF or oUF

local totemcolor = {
	["Interface\\Icons\\ability_monk_summonserpentstatue"] = {0, 1, .6},
	["Interface\\Icons\\monk_ability_summonoxstatue"] = {1, .8, 0},
	["Interface\\Icons\\ability_socererking_arcanemines"] = {.5, .5, 1},
}

local textcolor = {
	["Interface\\Icons\\ability_monk_summonserpentstatue"] = {0, 1, .6},
	["Interface\\Icons\\monk_ability_summonoxstatue"] = {1, .8, 0},
	["Interface\\Icons\\ability_socererking_arcanemines"] = {.5, .5, 1},
}

local total = 0
local delay = 0.01

local OnEnter = function(self)
	if(not self:IsVisible()) then return end

	GameTooltip:SetText(select(2, GetTotemInfo(self:GetID())), 1, 1, 1)
	GameTooltip:Show()
end

local OnLeave = function()
	GameTooltip:Hide()
end

local UpdateTotem = function(self, event, slot)
	local totems = self.TotemBar
	
	local totem = totems[slot]
	
	totem:SetMinMaxValues(0, 1)

	totem.ID = slot
	
	local haveTotem, name, startTime, duration, totemIcon = GetTotemInfo(slot)
	if totemcolor[totemIcon] then
		totem:SetStatusBarColor(unpack(totemcolor[totemIcon]))
		if totems.ShowValue then
			totem.value:SetTextColor(unpack(textcolor[totemIcon]))
		end
	end
	-- If we have a totem then set his value 
	if(haveTotem) then
		if(duration > 0) then
			totem:Show()
			totem:SetValue(1 - ((GetTime() - startTime) / duration))
			-- Status bar update
			totem:SetScript("OnUpdate",function(self,elapsed)
				total = total + elapsed
				if total >= delay then
					total = 0
					haveTotem, name, startTime, duration, totemIcon = GetTotemInfo(self.ID)
					if ((GetTime() - startTime) >= duration) then
						self:SetScript("OnUpdate",nil)
						self:Hide()
						self:SetValue(0)
						if self.value then
							self.value:SetText("")
						end			
					else
						self:SetValue(1 - ((GetTime() - startTime) / duration))
						if self.value then
							self.value:SetText(T.FormatTime(duration-(GetTime() - startTime)))
						end
					end
				end
			end)					
		else
			-- There's no need to update because it doesn't have any duration
			totem:SetScript("OnUpdate",nil)
			totem:Hide()
			totem:SetValue(0)
			if totem.value then
				totem.value:SetText("")
			end			
		end 
	else
		-- No totem = no time
		totem:Hide()		
		totem:SetValue(0)
		if totem.value then
			totem.value:SetText("")
		end
	end

	if(totems.PostUpdate) then
		return totems:PostUpdate(slot, haveTotem, name, start, duration, icon)
	end
end

local Path = function(self, ...)
	return (self.TotemBar.Override or UpdateTotem) (self, ...)
end

local Update = function(self, event)
	for i = 1, MAX_TOTEMS do
		Path(self, event, i)
	end
end

local ForceUpdate = function(element)
	return Update(element.__owner, 'ForceUpdate')
end

local Enable = function(self)
	local totems = self.TotemBar

	if(totems) then
		totems.__owner = self
		totems.ForceUpdate = ForceUpdate

		for i = 1, MAX_TOTEMS do
			local totem = totems[i]
			
			totem:SetID(i)
			
			if totems.ShowValue and not totem.value then
				totem.value = T.createtext(totem, "OVERLAY", totems.Valuefs or 12, "OUTLINE", "CENTER")
				totem.value:SetPoint("CENTER")
			end
			
			totem:SetScript('OnEnter', OnEnter)
			totem:SetScript('OnLeave', OnLeave)
		end

		self:RegisterEvent('PLAYER_TOTEM_UPDATE', Path, true)

		--TotemFrame.Show = TotemFrame.Hide
		--TotemFrame:Hide()

		TotemFrame:UnregisterEvent"PLAYER_TOTEM_UPDATE"
		TotemFrame:UnregisterEvent"PLAYER_ENTERING_WORLD"
		TotemFrame:UnregisterEvent"UPDATE_SHAPESHIFT_FORM"
		TotemFrame:UnregisterEvent"PLAYER_TALENT_UPDATE"

		return true
	end
end

local Disable = function(self)
	if(self.TotemBar) then
		--TotemFrame.Show = nil
		--TotemFrame:Show()

		TotemFrame:RegisterEvent"PLAYER_TOTEM_UPDATE"
		TotemFrame:RegisterEvent"PLAYER_ENTERING_WORLD"
		TotemFrame:RegisterEvent"UPDATE_SHAPESHIFT_FORM"
		TotemFrame:RegisterEvent"PLAYER_TALENT_UPDATE"

		self:UnregisterEvent('PLAYER_TOTEM_UPDATE', Path)
	end
end

oUF:AddElement("TotemBar", Update, Enable, Disable)