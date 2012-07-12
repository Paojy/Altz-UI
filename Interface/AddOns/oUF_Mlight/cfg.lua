local ADDON_NAME, ns = ...
local cfg = CreateFrame("Frame")

---------------------------------------------------------------------------------------
-------------------[[        Config        ]]------------------------------------------ 
---------------------------------------------------------------------------------------
-- media
cfg.mediaPath = "Interface\\AddOns\\oUF_Mlight\\media\\"
cfg.texture = "Interface\\Buttons\\WHITE8x8"
cfg.font, cfg.fontflag =  cfg.mediaPath.."font.TTF", "OUTLINE"
cfg.glowTex = cfg.mediaPath.."grow"
cfg.buttonTex = cfg.mediaPath.."buttontex"
cfg.fontsize = 12

-- color mode
-- true: health colored based on class/disable to make health colored based on percentage
-- false: power colored based on power type/disable to make power colored based on class
cfg.classcolormode = true

-- postion (type /mhelp to help you move it)
cfg.playerx = 180 
cfg.playery = 53
cfg.focusy = 200

-- size
cfg.height, cfg.width = 16, 215--height and width for player,focus and target
cfg.width1 = 80 -- width for pet and tot
cfg.scale = 1.0
cfg.hpheight = .90 -- hpheight/unitheight

-- castbar
cfg.castbars = true   -- disable all castbars
cfg.cbIconsize = 20
cfg.CBuserplaced = true  -- disabled to make castbars locked to their owner
    cfg.CBwidth = 250		
    cfg.focusCBposition = {"CENTER",UIParent,"CENTER",13,120}
    cfg.playerCBposition = {"CENTER",UIParent,"CENTER",13,-120}
    cfg.targetCBposition = {"CENTER",UIParent,"CENTER",-13,-95}

-- auras
cfg.auras = true  -- disable all auras
cfg.auraborders = true -- auraborder colored based on debuff type
cfg.onlyShowPlayer = false -- only show player debuffs on target

-- runebar
cfg.Ruserplaced = false --enable to make a bigger one on center of screen
cfg.Rheight, cfg.Rwidth = 6, 220
cfg.Runesp = {"BOTTOM",UIParent,"BOTTOM",0,200}

-- eclipse bar
cfg.Euserplaced = false --enable to make a bigger one on center of screen
cfg.Eheight, cfg.Ewidth = 8, 220
cfg.Eclipsep = {"BOTTOM",UIParent,"BOTTOM",0,200}

-- holy power /soul shards /shadow orb /chi
cfg.customsp = false --enable to make a bigger one on center of screen (smile stars)
cfg.spp = {"CENTER",UIParent,"BOTTOM",0,200}
cfg.spfontsize = 25 --fontsize

-- combo points
cfg.combop = {"CENTER",UIParent,"BOTTOM",10,200}--position
cfg.combofontsize = 25 --fontsize

-- show/hide unit

-- boss
cfg.bossframes = true

-- raid/party
cfg.enableraid = true
cfg.raidfontsize = 13 -- the fontsize of raid/party members' name
cfg.showsolo = true -- show raidframe when solo?

cfg.toggle = true
 -- Set Raidframemode(healer/dpstank) when Specialization changes.
 -- You can also use /rf to switch between them.
 -- healer mode(5*5)
cfg.healerraidposition = {"BOTTOM", UIParent, "BOTTOM", 0, 150}
cfg.healerraidheight, cfg.healerraidwidth = 35, 70
 -- dps/tank mode(1*25)
cfg.dpsraidposition = {"TOPLEFT", Minimap, "BOTTOMLEFT", 0, -15}
cfg.dpsraidheight, cfg.dpsraidwidth = 15, 70

---------------------------------------------------------------------------------------
-------------------[[        My         Config        ]]------------------------------- 
---------------------------------------------------------------------------------------
if GetUnitName("player") == "伤心蓝" or GetUnitName("player") == "Scarlett" then

end
  
if IsAddOnLoaded("Aurora") then
cfg.font = GameFontHighlight:GetFont()
end
---------------------------------------------------------------------------------------
-------------------[[        Config        End        ]]-------------------------------  
---------------------------------------------------------------------------------------
  -- HANDOVER
  ns.cfg = cfg