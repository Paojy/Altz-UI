local _, ns = ...
local F, C = unpack(ns)

tinsert(C.defaultThemes, function()

	local styled
	hooksecurefunc("LossOfControlFrame_SetUpDisplay", function(self)
		if not styled then
			F.ReskinIcon(self.Icon, true)

			styled = true
		end
	end)
end)