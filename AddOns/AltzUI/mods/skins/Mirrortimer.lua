local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)

local total = MIRRORTIMER_NUMTIMERS

local function Skin(timer, value, maxvalue, scale, paused, label)
	for i = 1, total, 1 do
		local frame = _G["MirrorTimer"..i]
		if not frame.isSkinned then
			local statusbar = _G[frame:GetName().."StatusBar"]
			local border = _G[frame:GetName().."Border"]
			local text = _G[frame:GetName().."Text"]
			
			statusbar:ClearAllPoints()
			statusbar:SetPoint("TOPLEFT", frame, 2, -2)
			statusbar:SetPoint("BOTTOMRIGHT", frame, -2, 8)
			statusbar:SetStatusBarTexture("Interface\\AddOns\\AltzUI\\media\\statusbar")
			
			local region = frame:GetRegions()
			if region:GetObjectType() == "Texture" then
				region:SetAlpha(0)
			end
		
			statusbar.backdrop = F.CreateBDFrame(statusbar, 0.5)
			statusbar.backdrop:SetPoint("BOTTOMRIGHT", statusbar, 1, -2)
			T.CreateSD(statusbar.backdrop, 2, 0, 0, 0, 1, -1)
			
			text:ClearAllPoints()
			text:SetFont(G.norFont, 12, "OUTLINE")
			text:SetPoint("CENTER", statusbar)
			
			border:SetTexture(nil)
			
			frame.isSkinned = true
		end
	end
end

hooksecurefunc("MirrorTimer_Show", Skin)