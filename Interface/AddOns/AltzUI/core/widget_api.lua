local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)

----------------------------
-- 			材质		  --
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

----------------------------
-- 			文本		  --
----------------------------

T.memFormat = function(num)
	if num > 1024 then
		return format("%.2f mb", (num / 1024))
	else
		return format("%.1f kb", floor(num))
	end
end