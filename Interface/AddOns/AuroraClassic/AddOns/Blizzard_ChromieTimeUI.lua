local _, ns = ...
local F, C = unpack(ns)

--/run LoadAddOn"Blizzard_ChromieTimeUI" ChromieTimeFrame:Show()
C.themes["Blizzard_ChromieTimeUI"] = function()
	local frame = ChromieTimeFrame

	F.StripTextures(frame)
	F.SetBD(frame)
	F.ReskinClose(frame.CloseButton)
	F.Reskin(frame.SelectButton)

	local header = frame.Title
	header:DisableDrawLayer("BACKGROUND")
	header.Text:SetFontObject(SystemFont_Huge1)
	F.CreateBDFrame(header, .25)

	frame.CurrentlySelectedExpansionInfoFrame.Name:SetTextColor(1, .8, 0)
	frame.CurrentlySelectedExpansionInfoFrame.Description:SetTextColor(1, 1, 1)
end