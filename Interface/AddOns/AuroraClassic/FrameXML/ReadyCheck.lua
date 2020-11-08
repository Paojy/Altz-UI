local _, ns = ...
local F, C = unpack(ns)

tinsert(C.defaultThemes, function()

	-- Ready check
	F.SetBD(ReadyCheckFrame)
	ReadyCheckPortrait:SetAlpha(0)
	select(2, ReadyCheckListenerFrame:GetRegions()):Hide()

	ReadyCheckFrame:HookScript("OnShow", function(self)
		if self.initiator and UnitIsUnit("player", self.initiator) then
			self:Hide()
		end
	end)

	F.Reskin(ReadyCheckFrameYesButton)
	F.Reskin(ReadyCheckFrameNoButton)

	-- Role poll
	F.StripTextures(RolePollPopup)
	F.SetBD(RolePollPopup)
	F.Reskin(RolePollPopupAcceptButton)
	F.ReskinClose(RolePollPopupCloseButton)

	F.ReskinRole(RolePollPopupRoleButtonTank, "TANK")
	F.ReskinRole(RolePollPopupRoleButtonHealer, "HEALER")
	F.ReskinRole(RolePollPopupRoleButtonDPS, "DPS")
end)