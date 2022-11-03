local addonName, ns = ...

ns[1] = {} -- B, functions
ns[2] = {} -- C, config
ns[3] = {} -- L, locales
ns[4] = {} -- DB, database

AuroraClassicDB = {} -- Saved Variables

local B, C, L, DB = unpack(ns)

local function GetCurrentScale()
	local mult = 1e5
	local scale = UIParent:GetScale()
	return floor(scale * mult + .5) / mult
end

function B:SetupPixelFix()
	local screenHeight = select(2, GetPhysicalScreenSize())
	local scale = GetCurrentScale()
	local uiScale = AuroraClassicDB.UIScale
	if uiScale and uiScale > 0 then scale = uiScale end
	local pixel = 1
	local ratio = 768 / screenHeight
	C.mult = (pixel / scale) - ((pixel - ratio) / scale)
end

function B:LoadSkins(event, addon)
	if event == "UI_SCALE_CHANGED" then
		B:SetupPixelFix()
	elseif event == "PLAYER_LOGOUT" then
		AuroraClassicDB.UIScale = GetCurrentScale()
	else
		if not C.mult then B:SetupPixelFix() end

		if addon == "AuroraClassic" then
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

			for _, func in pairs(C.defaultThemes) do
				func()
			end
			wipe(C.defaultThemes)

			for addonName, func in pairs(C.themes) do
				local isLoaded, isFinished = IsAddOnLoaded(addonName)
				if isLoaded and isFinished then
					func()
					C.themes[addonName] = nil
				end
			end
		else
			local func = C.themes[addon]
			if func then
				func()
				C.themes[addonName] = nil
			end
		end
	end
end

local host = CreateFrame("Frame")
host:RegisterEvent("ADDON_LOADED")
host:RegisterEvent("PLAYER_LOGOUT")
host:RegisterEvent("UI_SCALE_CHANGED")
host:SetScript("OnEvent", B.LoadSkins)

_G[addonName] = ns