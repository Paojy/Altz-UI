local T, C, L, G = unpack(select(2, ...))
local F = unpack(AuroraClassic)

local function Skin(self, timer, value, maxvalue, paused, label)	
	local frame = MirrorTimerContainer.activeTimers[timer]
	if not frame then return end
	
	local statusbar = frame.StatusBar
	local text = frame.Text

	if not frame.isSkinned then
		local regions = {frame:GetRegions()}
		for k, region in pairs(regions) do
			if region:GetObjectType() == "Texture" then
				region:Hide()
			end
		end
		
		statusbar.backdrop = F.CreateBDFrame(statusbar, 0.5)
		statusbar.backdrop:SetPoint("BOTTOMRIGHT", statusbar, 1, -1)
		T.CreateSD(statusbar.backdrop, 2)
		
		text:ClearAllPoints()
		text:SetFont(G.norFont, 12, "OUTLINE")
		text:SetPoint("CENTER", statusbar)
			
		frame.isSkinned = true
	end
	
	statusbar:SetStatusBarTexture(G.media.ufbar)
	statusbar:SetStatusBarColor(0, .7, 1)
end

hooksecurefunc(MirrorTimerContainer, "SetupTimer", Skin)