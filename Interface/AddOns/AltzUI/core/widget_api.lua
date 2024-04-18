local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)

----------------------------
-- 			通用		  --
----------------------------

local function Click(b)
	local func = b:GetScript("OnMouseDown") or b:GetScript("OnClick")
	func(b)
end