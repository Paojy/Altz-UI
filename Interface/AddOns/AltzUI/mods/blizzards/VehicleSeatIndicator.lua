local T, C, L, G = unpack(select(2, ...))

local frame = VehicleSeatIndicator
local name = frame:GetName()

frame.movingname = L["多人坐骑控制框"]
frame.point = {
	healer = {a1 = "TOPRIGHT", parent = "UIParent", a2 = "TOPRIGHT", x = -50, y = -200},
	dpser = {a1 = "TOPRIGHT", parent = "UIParent", a2 = "TOPRIGHT", x = -50, y = -200},
}

T.CreateDragFrame(frame)

hooksecurefunc("UIParent_ManageFramePositions", function()
	local role = T.CheckRole()
	local points = aCoreCDB["FramePoints"][name][role]
	frame:ClearAllPoints()
	frame:SetPoint(points.a1, _G[points.parent], points.a2, points.x, points.y)
end)
