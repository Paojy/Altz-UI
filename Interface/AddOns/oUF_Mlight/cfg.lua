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

-- color mode
-- health colored based on class/disable to make health colored based on percentage
-- power colored based on power type/disable to make power colored based on class
cfg.classcolormode = false

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

-- raid/party
cfg.enableraid = true
cfg.raidfontsize = 10 -- the fontsize of raid/party members' name
cfg.showsolo = true -- show raidframe when solo?

cfg.toggle = true
 -- Set Raidframemode(healer/dpstank) when Specialization changes.
 -- You can also use /rf to switch between them.
 
 --[[ healer mode(5*5) ]]--
cfg.healerraidposition = {'TOPLEFT', 'UIParent','CENTER', 150, -100}
cfg.healerraidheight, cfg.healerraidwidth = 30, 70
cfg.anchor = "TOP"
cfg.partyanchor = "LEFT"
cfg.showgcd = true
cfg.showarrow = true
	cfg.arrowscale = 1.0
cfg.healprediction = true
	cfg.myhealpredictioncolor = { 110/255, 210/255, 0/255, 0.5}
	cfg.otherhealpredictioncolor = { 0/255, 110/255, 0/255, 0.5}
 --[[ dps/tank mode(1*25) ]]--
cfg.dpsraidposition = {"TOPLEFT", UIParent, "TOPLEFT", 20, -168}
cfg.dpsraidheight, cfg.dpsraidwidth = 15, 70
cfg.dpsraidgroupbyclass = true
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
  -- HANDOVER
  ns.cfg = cfg