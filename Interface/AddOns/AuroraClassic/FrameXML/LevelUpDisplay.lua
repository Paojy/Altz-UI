local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	LevelUpDisplaySide:HookScript("OnShow", function(self)
		for i = 1, #self.unlockList do
			local f = _G["LevelUpDisplaySideUnlockFrame"..i]

			if not f.bg then
				f.bg = F.ReskinIcon(f.icon)
			end
		end
	end)
end)