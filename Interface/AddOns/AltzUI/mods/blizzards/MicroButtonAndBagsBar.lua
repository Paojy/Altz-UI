local T, C, L, G = unpack(select(2, ...))

local frame = MicroButtonAndBagsBar
local name = frame:GetName()

frame.movingname = L["主菜单和背包"]
frame.point = {
	healer = {a1 = "BOTTOMRIGHT", parent = "UIParent", a2 = "BOTTOMRIGHT", x = -10, y = 10},
	dpser = {a1 = "BOTTOMRIGHT", parent = "UIParent", a2 = "BOTTOMRIGHT", x = -10, y = 10},
}

T.CreateDragFrame(frame)

hooksecurefunc("UIParent_ManageFramePositions", function()
	if aCoreCDB["FramePoints"] then
		local role = T.CheckRole()
		local points = aCoreCDB["FramePoints"][name][role]
		frame:ClearAllPoints()
		frame:SetPoint(points.a1, _G[points.parent], points.a2, points.x, points.y)
	end
end)

MainMenuMicroButton.MainMenuBarPerformanceBar:Hide()