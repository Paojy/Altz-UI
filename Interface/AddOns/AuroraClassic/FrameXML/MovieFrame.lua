local _, ns = ...
local F, C = unpack(ns)

tinsert(C.defaultThemes, function()
	-- Cinematic

	CinematicFrameCloseDialog:HookScript("OnShow", function(self)
		self:SetScale(UIParent:GetScale())
	end)

	F.StripTextures(CinematicFrameCloseDialog)
	local bg = F.SetBD(CinematicFrameCloseDialog)
	bg:SetFrameLevel(1)
	F.Reskin(CinematicFrameCloseDialogConfirmButton)
	F.Reskin(CinematicFrameCloseDialogResumeButton)

	-- Movie

	local closeDialog = MovieFrame.CloseDialog

	closeDialog:HookScript("OnShow", function(self)
		self:SetScale(UIParent:GetScale())
	end)

	F.StripTextures(closeDialog)
	local bg = F.SetBD(closeDialog)
	bg:SetFrameLevel(1)
	F.Reskin(closeDialog.ConfirmButton)
	F.Reskin(closeDialog.ResumeButton)
end)