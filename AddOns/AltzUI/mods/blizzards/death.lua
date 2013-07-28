local T, C, L, G = unpack(select(2, ...))

local eventframe = CreateFrame("Frame")

eventframe:SetScript("OnEvent", function(self, event)
	if UnitIsDead("player") then
		StaticPopup_Show("DEATH")
	end
end)

eventframe:RegisterEvent("PLAYER_ENTERING_WORLD")

hooksecurefunc("StaticPopup_Show", function(which, text_arg1, text_arg2, data)
	if which == "DEATH" and not UnitIsDead("player") then
      StaticPopup_Hide("DEATH")
   end
end)