if not IsAddOnLoaded("Numeration") then return end
--====================================================--
--[[               -- Numeration --                 ]]--
--====================================================--
creategrowBD(NumerationFrame, 0, 0, 0, 0.2, 1)
NumerationFrame.border:SetPoint("TOPLEFT", "NumerationFrame", "TOPLEFT", 0, -8)
NumerationFrame.border:SetPoint("BOTTOMRIGHT", "NumerationFrame", "BOTTOMRIGHT", 2, -1)
