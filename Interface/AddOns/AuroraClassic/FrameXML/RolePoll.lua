local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.CreateBD(RolePollPopup)
	F.CreateSD(RolePollPopup)
	F.Reskin(RolePollPopupAcceptButton)
	F.ReskinClose(RolePollPopupCloseButton)

	F.ReskinRole(RolePollPopupRoleButtonTank, "TANK")
	F.ReskinRole(RolePollPopupRoleButtonHealer, "HEALER")
	F.ReskinRole(RolePollPopupRoleButtonDPS, "DPS")
end)