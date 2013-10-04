local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)
if not IsAddOnLoaded("DBM-Core") or not aCoreCDB["SkinOptions"]["setDBM"] then return end

--	DBM skin(by Affli)
local croprwicons = true					-- Crops blizz shitty borders from icons in RaidWarning messages
local rwiconsize = 12						-- RaidWarning icon size. Works only if croprwicons = true

local glow = G.media.glow
local blank = G.media.bar
local backdrop = {
	bgFile = blank,
	insets = {left = 0, right = 0, top = 0, bottom = 0},
}

local DBMSkin = CreateFrame("Frame")
DBMSkin:RegisterEvent("PLAYER_LOGIN")
DBMSkin:SetScript("OnEvent", function(self, event, addon)
		local function SkinBars(self)
			for bar in self:GetBarIterator() do
				if not bar.injected then
					bar.ApplyStyle = function()
						local frame = bar.frame
						local tbar = _G[frame:GetName().."Bar"]
						local texture = _G[frame:GetName().."BarTexture"]
						local icon1 = _G[frame:GetName().."BarIcon1"]
						local icon2 = _G[frame:GetName().."BarIcon2"]
						local name = _G[frame:GetName().."BarName"]
						local timer = _G[frame:GetName().."BarTimer"]

						if (icon1.overlay) then
							icon1.overlay = _G[icon1.overlay:GetName()]
						else
							icon1.overlay = CreateFrame("Frame", "$parentIcon1Overlay", tbar)
							icon1.overlay:SetWidth(23)
							icon1.overlay:SetHeight(23)
							icon1.overlay:SetFrameStrata("BACKGROUND")
							icon1.overlay:SetPoint("BOTTOMRIGHT", tbar, "BOTTOMLEFT", -2, -2)
							T.CreateSD(icon1.overlay, 3, 0, 0, 0, 1, -3)
						end

						if (icon2.overlay) then
							icon2.overlay = _G[icon2.overlay:GetName()]
						else
							icon2.overlay = CreateFrame("Frame", "$parentIcon2Overlay", tbar)
							icon2.overlay:SetWidth(23)
							icon2.overlay:SetHeight(23)
							icon2.overlay:SetFrameStrata("BACKGROUND")
							icon2.overlay:SetPoint("BOTTOMLEFT", tbar, "BOTTOMRIGHT", 5, -2)
							T.CreateSD(icon2.overlay, 3, 0, 0, 0, 1, -3)
						end
						
						if bar.enlarged then frame:SetWidth(bar.owner.options.HugeWidth) else frame:SetWidth(bar.owner.options.Width) end
						if bar.enlarged then tbar:SetWidth(bar.owner.options.HugeWidth) else tbar:SetWidth(bar.owner.options.Width) end

						frame:SetScale(1)
						if not frame.styled then
							frame:SetHeight(23)
							T.CreateSD(frame, 4, 0, 0, 0, 1, -3)
							F.CreateBD(frame, 0.7)
							frame.styled = true
						end
			
						if not icon1.styled then
							icon1:SetTexCoord(0.1, 0.9, 0.1, 0.9)
							icon1:ClearAllPoints()
							icon1:SetPoint("TOPLEFT", icon1.overlay, 2, -2)
							icon1:SetPoint("BOTTOMRIGHT", icon1.overlay, -2, 2)
							icon1.styled = true
						end
						
						if not icon2.styled then
							icon2:SetTexCoord(0.1, 0.9, 0.1, 0.9)
							icon2:ClearAllPoints()
							icon2:SetPoint("TOPLEFT", icon2.overlay, 2, -2)
							icon2:SetPoint("BOTTOMRIGHT", icon2.overlay, -2, 2)
							icon2.styled = true
						end
						
						if not texture.styled then
							texture:SetTexture(blank)
							texture.styled = true
						end
						
						if not tbar.styled then
							tbar:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
							tbar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
							tbar.styled = true
						end

						if not name.styled then
							name:ClearAllPoints()
							name:SetPoint("LEFT", frame, "LEFT", 4, 0)
							name:SetPoint("RIGHT", frame, "RIGHT", -10, 0)
							name:SetHeight(8)
							name:SetFont(G.norFont, 10, "OUTLINE")
							name:SetShadowOffset(0, 0, 0, 0)
							name:SetJustifyH("LEFT")
							name.SetFont = dummy
							name.styled = true
						end
						
						if not timer.styled then	
							timer:ClearAllPoints()
							timer:SetPoint("RIGHT", frame, "RIGHT", -5, 0)
							timer:SetFont(G.norFont, 10, "OUTLINE")
							timer:SetShadowOffset(0, 0, 0, 0)
							timer:SetJustifyH("RIGHT")
							timer.SetFont = dummy
							timer.styled = true
						end
						
						if bar.owner.options.IconLeft then icon1:Show() icon1.overlay:Show() else icon1:Hide() icon1.overlay:Hide() end
						if bar.owner.options.IconRight then icon2:Show() icon2.overlay:Show() else icon2:Hide() icon2.overlay:Hide() end
						tbar:SetAlpha(1)
						frame:SetAlpha(1)
						texture:SetAlpha(1)
						frame:Show()
						bar:Update(0)
						bar.injected = true
					end
					bar:ApplyStyle()
				end
			end
		end

		local SkinBossTitle = function()
			local anchor = DBMBossHealthDropdown:GetParent()
			if not anchor.styled then
				local header = {anchor:GetRegions()}
				if header[1]:IsObjectType("FontString") then
					header[1]:SetFont(G.norFont, 10, "OUTLINE")
					header[1]:SetShadowOffset(0, 0, 0, 0)
					header[1]:SetTextColor(1, 1, 1, 1)
					anchor.styled = true	
				end
				header = nil
			end
			anchor = nil
		end
		
		local SkinBoss = function()
			local count = 1
			while (_G[format("DBM_BossHealth_Bar_%d", count)]) do
				local bar = _G[format("DBM_BossHealth_Bar_%d", count)]
				local background = _G[bar:GetName().."BarBorder"]
				local progress = _G[bar:GetName().."Bar"]
				local name = _G[bar:GetName().."BarName"]
				local timer = _G[bar:GetName().."BarTimer"]
				local prev = _G[format("DBM_BossHealth_Bar_%d", count-1)]

				if (count == 1) then
					local _, anch, _ , _, _ = bar:GetPoint()
					bar:ClearAllPoints()
					if DBM_SavedOptions.HealthFrameGrowUp then
						bar:SetPoint("BOTTOM", anch, "TOP", 0, 3)
					else
						bar:SetPoint("TOP", anch, "BOTTOM", 0, -3)
					end
				else
					bar:ClearAllPoints()
					if DBM_SavedOptions.HealthFrameGrowUp then
						bar:SetPoint("BOTTOMLEFT", prev, "TOPLEFT", 0, 3)
					else
						bar:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -3)
					end
				end

				if not bar.styled then
					bar:SetScale(1)
					bar:SetHeight(19)
					T.CreateSD(bar, 4, 0, 0, 0, 1, -3)
					F.CreateBD(bar, 0.7)
					background:SetNormalTexture(nil)
					bar.styled = true
				end	
				
				if not progress.styled then
					progress:SetStatusBarTexture(blank)
				end
				progress:ClearAllPoints()
				progress:SetPoint("TOPLEFT", bar, "TOPLEFT", 2, -2)
				progress:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -2, 2)

				if not name.styled then
					name:ClearAllPoints()
					name:SetPoint("LEFT", bar, "LEFT", 4, 0)
					name:SetFont(G.norFont, 10, "OUTLINE")
					name:SetShadowOffset(0, 0, 0, 0)
					name:SetJustifyH("LEFT")
					name.styled = true
				end
				
				if not timer.styled then
					timer:ClearAllPoints()
					timer:SetPoint("RIGHT", bar, "RIGHT", -5, 0)
					timer:SetFont(G.norFont, 10, "OUTLINE")
					timer:SetShadowOffset(0, 0, 0, 0)
					timer:SetJustifyH("RIGHT")
					timer.styled = true
				end
				count = count + 1
			end
		end
		
		local SkinInfo = function()
			local infoframe = _G["DBMInfoFrame"]
			F.SetBD(infoframe)
			F.CreateBD(infoframe, 0)
		end
		
		hooksecurefunc(DBT, "CreateBar", SkinBars)
		hooksecurefunc(DBM.BossHealth, "Show", SkinBossTitle)
		hooksecurefunc(DBM.BossHealth, "AddBoss", SkinBoss)
		hooksecurefunc(DBM.BossHealth,"UpdateSettings",SkinBoss)
		--hooksecurefunc(DBM.InfoFrame,"Show",SkinInfo)
		DBM.RangeCheck:Show()
		DBM.RangeCheck:Hide()
		
		F.SetBD(_G["DBMRangeCheckRadar"])
		F.SetBD(_G["DBMRangeCheck"])
		
		if croprwicons then
			local replace = string.gsub
			local old = RaidNotice_AddMessage
			RaidNotice_AddMessage = function(noticeFrame, textString, colorInfo)
				if textString:find(" |T") then
					textString=replace(textString,"(:12:12)",":"..rwiconsize..":"..rwiconsize..":0:0:64:64:5:59:5:59")
				end
				return old(noticeFrame, textString, colorInfo)
			end
		end
end)