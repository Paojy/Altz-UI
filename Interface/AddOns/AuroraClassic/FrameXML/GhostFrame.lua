local _, ns = ...
local B, C, L, DB = unpack(ns)

tinsert(C.defaultThemes, function()
	local r, g, b = DB.r, DB.g, DB.b

	for i = 1, 6 do
		select(i, GhostFrame:GetRegions()):Hide()
	end
	B.ReskinIcon(GhostFrameContentsFrameIcon)

	local bg = B.SetBD(GhostFrame, 0)
	B.CreateGradient(bg)
	GhostFrame:SetHighlightTexture(DB.bdTex)
	GhostFrame:GetHighlightTexture():SetVertexColor(r, g, b, .25)
end)