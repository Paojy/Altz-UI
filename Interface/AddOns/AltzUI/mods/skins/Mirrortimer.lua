local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)

local total = MIRRORTIMER_NUMTIMERS

local function Skin(timer, value, maxvalue, scale, paused, label)
	for i = 1, total, 1 do
		local frame = _G["MirrorTimer"..i]
		local statusbar = frame.StatusBar
		local border = frame.Border
		local text = frame.Text
		local textborder = frame.TextBorder
		
		if not frame.isSkinned then
			statusbar:ClearAllPoints()
			statusbar:SetPoint("TOPLEFT", frame, 2, -2)
			statusbar:SetPoint("BOTTOMRIGHT", frame, -2, 8)

			local regions = {frame:GetRegions()}
			for k, region in pairs(regions) do
				if region:GetObjectType() == "Texture" then
					region:SetAlpha(0)
				end
			end
			
			statusbar.backdrop = F.CreateBDFrame(statusbar, 0.5)
			statusbar.backdrop:SetPoint("BOTTOMRIGHT", statusbar, 1, -1)
			T.CreateSD(statusbar.backdrop, 2)
			
			text:ClearAllPoints()
			text:SetFont(G.norFont, 12, "OUTLINE")
			text:SetPoint("CENTER", statusbar)
			
			border:SetTexture(nil)
			textborder:Hide()
			
			frame.isSkinned = true
		end
		
		statusbar:SetStatusBarTexture(G.media.ufbar)
		statusbar:SetStatusBarColor(0, .7, 1)
	end
end

hooksecurefunc(MirrorTimerContainer, "SetupTimer", Skin)