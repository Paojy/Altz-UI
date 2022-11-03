local _, ns = ...
local B, C, L, DB = unpack(ns)

tinsert(C.defaultThemes, function()
	local styled
	hooksecurefunc("LossOfControlFrame_SetUpDisplay", function(self)
		if not styled then
			B.ReskinIcon(self.Icon, true)

			styled = true
		end
	end)
end)