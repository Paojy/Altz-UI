--nccooldownflash

local lib = LibStub("LibCooldown")
if not lib then error("CooldownFlash requires LibCooldown") return end

local filter = {
	["pet"] = "all",
	["item"] = {
		[6948] = true, -- hearthstone
	},
	["spell"] = {
	},
}

local backdrop = {
	  bgFile = [[Interface\Buttons\WHITE8x8]], 
	  edgeFile = [[Interface\AddOns\rActionBarStyler\media\outer_shadow]], 
	  tile = false, tileSize = 0, edgeSize = 4, 
	  insets = { left = 4, right = 4, top = 4, bottom = 4}
	}
	
local flash = CreateFrame("Frame", nil, UIParent)
flash.icon = flash:CreateTexture(nil, "OVERLAY")

flash:SetScript("OnEvent", function()
	flash:SetPoint("CENTER", UIParent)
	flash:SetSize(50,50)
	flash:SetBackdrop(backdrop)
	flash:SetBackdropColor( 0, 0, 0)
	flash:SetBackdropBorderColor(0, 0, 0)
	
	flash.icon:SetPoint("TOPLEFT", 4, -4)
	flash.icon:SetPoint("BOTTOMRIGHT", -4, 4)
	flash.icon:SetTexCoord(.08, .92, .08, .92)
	
	flash:Hide()
	
	flash:SetScript("OnUpdate", function(self, e)
		flash.e = flash.e + e
		if flash.e > .75 then
			flash:Hide()
		elseif flash.e < .25 then
			flash:SetAlpha(flash.e*4)
		elseif flash.e > .5 then
			flash:SetAlpha(1-(flash.e%.5)*4)
		end
	end)
	
	flash:UnregisterEvent("PLAYER_ENTERING_WORLD")
	flash:SetScript("OnEvent", nil)
	
end)

flash:RegisterEvent("PLAYER_ENTERING_WORLD")

lib:RegisterCallback("stop", function(id, class)
	if filter[class]=="all" or filter[class][id] then return end
	flash.icon:SetTexture(class=="item" and GetItemIcon(id) or select(3, GetSpellInfo(id)))
	flash.e = 0
	flash:Show()
end)