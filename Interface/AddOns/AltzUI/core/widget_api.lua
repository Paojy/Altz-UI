local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)

----------------------------
-- 			通用		  --
----------------------------

local arrowDegree = {
	["up"] = 0,
	["down"] = 180,
	["left"] = 90,
	["right"] = -90,
}

T.SetupArrow = function(tex, direction)
	tex:SetTexture([[Interface\AddOns\AltzUI\media\arrow.tga]])
	tex:SetRotation(rad(arrowDegree[direction]))
end
