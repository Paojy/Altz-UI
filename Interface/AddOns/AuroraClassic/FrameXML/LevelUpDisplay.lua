local _, ns = ...
local F, C = unpack(ns)

tinsert(C.defaultThemes, function()
	if C.isNewPatch then return end

	LevelUpDisplaySide:HookScript("OnShow", function(self)
		for i = 1, #self.unlockList do
			local f = _G["LevelUpDisplaySideUnlockFrame"..i]

			if not f.bg then
				f.bg = F.ReskinIcon(f.icon)
			end
		end
	end)
end)