local _, ns = ...
local F, C = unpack(ns)

tinsert(C.defaultThemes, function()
	local r, g, b = C.r, C.g, C.b

	for i = 1, 6 do
		select(i, GhostFrame:GetRegions()):Hide()
	end
	F.ReskinIcon(GhostFrameContentsFrameIcon)

	local bg = F.SetBD(GhostFrame, 0)
	F.CreateGradient(bg)
	GhostFrame:SetHighlightTexture(C.bdTex)
	GhostFrame:GetHighlightTexture():SetVertexColor(r, g, b, .25)
end)