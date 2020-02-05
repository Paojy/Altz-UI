local addonName, ns = ...

ns[1] = {} -- F, functions
ns[2] = {} -- C, config
ns[3] = {} -- L, locales

AuroraClassicDB = {} -- Saved Variables

local F, C, L = unpack(ns)

local function GetCurrentScale()
	local mult = 1e5
	local scale = UIParent:GetScale()
	return floor(scale * mult + .5) / mult
end

function F:SetupPixelFix()
	local screenHeight = select(2, GetPhysicalScreenSize())
	local scale = GetCurrentScale()
	local uiScale = AuroraClassicDB.UIScale
	if uiScale and uiScale > 0 then scale = uiScale end
	local pixel = 1
	local ratio = 768 / screenHeight
	C.mult = (pixel / scale) - ((pixel - ratio) / scale)
end

function F:LoadSkins(event, addon)
	if event == "UI_SCALE_CHANGED" then
		F:SetupPixelFix()
	elseif event == "PLAYER_LOGOUT" then
		AuroraClassicDB.UIScale = GetCurrentScale()
	else
		if not C.mult then F:SetupPixelFix() end

		if addon == "AuroraClassic" then
			local color = AuroraClassicDB.FlatMode and C.options.FlatColor or C.options.GradientColor
			C.buttonR, C.buttonG, C.buttonB, C.buttonA = unpack(color)

			if AuroraClassicDB.UseCustomColor then
				C.r, C.g, C.b = AuroraClassicDB.CustomColor.r, AuroraClassicDB.CustomColor.g, AuroraClassicDB.CustomColor.b
			end

			for key in pairs(AuroraClassicDB) do
				if C.options[key] == nil then AuroraClassicDB[key] = nil end
			end

			for key, value in pairs(C.options) do
				if AuroraClassicDB[key] == nil then
					if type(value) == "table" then
						AuroraClassicDB[key] = {}
						for k in pairs(value) do
							AuroraClassicDB[key][k] = value[k]
						end
					else
						AuroraClassicDB[key] = value
					end
				end
			end

			for _, func in pairs(C.themes[addon]) do
				func()
			end
		else
			local func = C.themes[addon]
			if func then func() end
		end
	end
end

local host = CreateFrame("Frame")
host:RegisterEvent("ADDON_LOADED")
host:RegisterEvent("PLAYER_LOGOUT")
host:RegisterEvent("UI_SCALE_CHANGED")
host:SetScript("OnEvent", F.LoadSkins)

_G[addonName] = ns