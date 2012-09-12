local ADDON_NAME, ns = ...
local cfg = CreateFrame("Frame")

---------------------------------------------------------------------------------------
-------------------[[        Config        ]]------------------------------------------ 
---------------------------------------------------------------------------------------
-- media
cfg.mediaPath = "Interface\\AddOns\\oUF_Mlight\\media\\"
cfg.texture = "Interface\\Buttons\\WHITE8x8"
cfg.highlighttexture = cfg.mediaPath.."highlight"
cfg.font, cfg.fontflag = cfg.mediaPath.."font.TTF", "OUTLINE"
cfg.glowTex = cfg.mediaPath.."grow"
cfg.fontsize = 12

-- health/power
cfg.classcolormode = true  -- true  : health colored based on class, power colored based on powertype
						   -- flase : health colored based on health percentage, power colored based on class
cfg.tranparentmode = true -- transparent unit frames?
cfg.nameclasscolormode = true -- classcolor/white?

-- size
cfg.height, cfg.width = 16, 230--height and width for player,focus and target
cfg.width1 = 70 -- width for pet and tot
cfg.width2 = 170 -- width for boss 1-5
cfg.scale = 1.0
cfg.hpheight = .90 -- hpheight/unitheight

-- postion
cfg.playerpos = {"BOTTOM","UIParent","CENTER", 0, -135}
cfg.petpos = {"BOTTOMLEFT","UIParent","CENTER", cfg.width/2 +10, -135}
cfg.targetpos = {"TOPLEFT","UIParent","CENTER", 150, -50}
cfg.totpos = {"TOPLEFT","UIParent","CENTER", 150 +cfg.width +10, -50}
cfg.focuspos = {"TOPLEFT","UIParent","CENTER", 150, 50}
cfg.focustarget = {"TOPLEFT","UIParent","CENTER", 150 +cfg.width +10, 50}
cfg.boss1pos = {"TOPRIGHT","UIParent","TOPRIGHT", -10, -200}
cfg.bossspace = 60

-- castbar
cfg.castbars = true   -- disable all castbars
cfg.cbIconsize = 32
cfg.uninterruptable = {1, 0, 0, 0.1}

-- auras
cfg.auras = true  -- disable all auras
cfg.auraborders = true -- auraborder colored based on debuff type
cfg.auraperrow = 9 -- number of auras each row, this control the size of icon
cfg.playerdebuff = { 
	enable = true, -- show debuffs on playerframe ?
	num = 7, -- number of auras each row, this control the size of icon
}
cfg.AuraFilter = { -- target and focus
	ignoreBuff = false, -- hide others' buff on friend
	ignoreDebuff = false, -- hide others' debuff on enemy
	whitelist = {  -- show auras in whitelist if they are hidden by rules above
		--[589] = true, -- sw:pain test
		--[588] = true, -- inner fire test
		},
}

-- threatbar
cfg.showthreatbar = true
cfg.tbvergradient = false -- set threat bar color gradient orientation to vertical
cfg.tbuserplaced = {
	enable = false, -- want to place it somewhere else?
	width = 200,
	height = 10,
	pos = {'CENTER', UIParent, 'CENTER', 0, 0},
}

-- show/hide boss
cfg.bossframes = true

---------------------------------------------------------------------------------------
-------------------[[        Raid/Party       Config        ]]------------------------- 
---------------------------------------------------------------------------------------
--[[ share ]]--
cfg.enableraid = true
cfg.raidfontsize = 10 -- the fontsize of raid/party members' name
cfg.showsolo = true -- show raidframe when solo?
cfg.switch = {
	auto = true, -- automaticly swith raidframe style when you change current specialization. use /rf to switch between them manually.
	onlyhealer = false, -- only available when auto set to false
	onlydps = false, -- only available when auto set to false
	-- if auto ,onlyhealer and onlydps all set to false, then it will choose the raid frame match your specialization when log-in.
	}
cfg.arrow = { 
	enable = true,
	scale = 1.0,
	}

--[[ healer mode ]]--
cfg.healerraidposition = {'TOPLEFT', 'UIParent','CENTER', 150, -100}
cfg.healergroupfilter = '1,2,3,4,5' --'1,2,3,4,5,6,7,8' if you want to show 40 group members
cfg.healerraidheight, cfg.healerraidwidth = 30, 70
cfg.anchor = "TOP"
cfg.partyanchor = "LEFT"
cfg.showgcd = true
cfg.healprediction = {
	enable = true,
	mycolor = { 110/255, 210/255, 0/255, 0.5},
	othercolor = { 0/255, 110/255, 0/255, 0.5},
	}

--[[ dps/tank mode ]]--
cfg.dpsraidposition = {"TOPLEFT", UIParent, "TOPLEFT", 20, -168}
cfg.dpsraidgroupbyclass = true -- sort the members by class
cfg.dpsgroupfilter = '1,2,3,4,5' --'1,2,3,4,5,6,7,8' if you want to show 40 group members
cfg.unitnumperline = 25 -- unit number per line
cfg.dpsraidheight, cfg.dpsraidwidth = 15, 70
---------------------------------------------------------------------------------------
-------------------[[        My         Config        ]]------------------------------- 
---------------------------------------------------------------------------------------
if GetUnitName("player") == "伤心蓝" or GetUnitName("player") == "Scarlett" then

end
  
if IsAddOnLoaded("Aurora") and IsAddOnLoaded("aCore") then
cfg.font = GameFontHighlight:GetFont()
	cfg.showsolo = false
	cfg.showthreatbar = true
	cfg.tbvergradient = true
	cfg.tbuserplaced = {
	enable = true,
	width = 185,
	height = 4,
	pos = {'TOPLEFT', UIParent, 'TOPLEFT', 150, -10},
	}
end
---------------------------------------------------------------------------------------
-------------------[[        Config        End        ]]-------------------------------  
---------------------------------------------------------------------------------------
--[[ CPU and Memroy testing
local interval = 0
cfg:SetScript("OnUpdate", function(self, elapsed)
 	interval = interval - elapsed
	if interval <= 0 then
		UpdateAddOnMemoryUsage()
			print("----------------------")
			print("|cffBF3EFFoUF_Mlight|r CPU  "..GetAddOnCPUUsage("oUF_Mlight").." Memory "..format("%.1f kb", floor(GetAddOnMemoryUsage("oUF_Mlight"))))
			print("|cffFFFF00oUF|r CPU  "..GetAddOnCPUUsage("oUF").."  Memory  "..format("%.1f kb", floor(GetAddOnMemoryUsage("oUF"))))
			print("----------------------")
		interval = 4
	end
end)
]]--
-- HANDOVER
ns.cfg = cfg