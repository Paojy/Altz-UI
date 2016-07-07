--[[ Element: Runes Bar

 Handle updating and visibility of the Death Knight's Rune indicators.

 Widget

 Runes - An array holding six StatusBar's.

 Sub-Widgets

 .bg - A Texture which functions as a background. It will inherit the color of
       the main StatusBar.

 Notes

 The default StatusBar texture will be applied if the UI widget doesn't have a
             status bar texture or color defined.

 Sub-Widgets Options

 .multiplier - Defines a multiplier, which is used to tint the background based
               on the main widgets R, G and B values. Defaults to 1 if not
               present.

 Examples

   local Runes = {}
   for index = 1, 6 do
      -- Position and size of the rune bar indicators
      local Rune = CreateFrame('StatusBar', nil, self)
      Rune:SetSize(120 / 6, 20)
      Rune:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', index * 120 / 6, 0)
   
      Runes[index] = Rune
   end
   
   -- Register with oUF
   self.Runes = Runes
]]

if select(2, UnitClass("player")) ~= "DEATHKNIGHT" then return end

local parent, ns = ...
local oUF = ns.oUF

local runemap = { 1, 2, 3, 4, 5, 6 }

local OnUpdate = function(self, elapsed)
	local duration = self.duration + elapsed
	if(duration >= self.max) then
		return self:SetScript("OnUpdate", nil)
	else
		self.duration = duration
		return self:SetValue(duration)
	end
end

local UpdateRune = function(self, event, rid)
	local runes = self.Runes
	local rune = runes[runemap[rid]]
	if(not rune) then return end

	if(UnitHasVehicleUI'player') then
		return rune:Hide()
	else
		rune:Show()
	end

	local start, duration, runeReady = GetRuneCooldown(rid)
	if(runeReady) then
		rune:SetMinMaxValues(0, 1)
		rune:SetValue(1)
		rune:SetScript("OnUpdate", nil)
	elseif start then
		rune.duration = GetTime() - start
		rune.max = duration
		rune:SetMinMaxValues(1, duration)
		rune:SetScript("OnUpdate", OnUpdate)
	end

	if(runes.PostUpdateRune) then
		return runes:PostUpdateRune(rune, rid, start, duration, runeReady)
	end
end

local Update = function(self, event)
	for i=1, 6 do
		UpdateRune(self, event, i)
	end
end

local ForceUpdate = function(element)
	return Update(element.__owner, 'ForceUpdate')
end

local Enable = function(self, unit)
	local runes = self.Runes
	if(runes and unit == 'player') then
		runes.__owner = self
		runes.ForceUpdate = ForceUpdate

		for i=1, 6 do
			local rune = runes[runemap[i]]
			if(rune:IsObjectType'StatusBar' and not rune:GetStatusBarTexture()) then
				rune:SetStatusBarTexture[[Interface\TargetingFrame\UI-StatusBar]]
			end
		end

		self:RegisterEvent("RUNE_POWER_UPDATE", UpdateRune, true)

		-- oUF leaves the vehicle events registered on the player frame, so
		-- buffs and such are correctly updated when entering/exiting vehicles.
		--
		-- This however makes the code also show/hide the RuneFrame.
		RuneFrame.Show = RuneFrame.Hide
		RuneFrame:Hide()

		return true
	end
end

local Disable = function(self)
	RuneFrame.Show = nil
	RuneFrame:Show()

	self:UnregisterEvent("RUNE_POWER_UPDATE", UpdateRune)
end

oUF:AddElement("Runes", Update, Enable, Disable)
