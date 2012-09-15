local addon, ns = ...

local function LoadVariables()
	oUF_MlightDB = {}
	
	oUF_MlightDB.enablefade = true
	oUF_MlightDB.fadingalpha = 0.2
	
	oUF_MlightDB.fontfile = "Interface\\AddOns\\oUF_Mlight\\media\\font.TTF"
	oUF_MlightDB.fontsize = 12

	-- health/power
	oUF_MlightDB.classcolormode = true					
	oUF_MlightDB.transparentmode = true
	oUF_MlightDB.nameclasscolormode = true

	-- size
	oUF_MlightDB.height	= 16 
	oUF_MlightDB.width = 230
	oUF_MlightDB.widthpet = 70
	oUF_MlightDB.widthboss = 170
	oUF_MlightDB.scale = 1.0 -- slider
	oUF_MlightDB.hpheight = 0.9 -- slider

	-- castbar
	oUF_MlightDB.castbars = true
	oUF_MlightDB.cbIconsize = 32

	-- auras
	oUF_MlightDB.auras = true
	oUF_MlightDB.auraborders = true
	oUF_MlightDB.auraperrow = 9 -- slider
	oUF_MlightDB.playerdebuffenable = true
	oUF_MlightDB.playerdebuffnum = 7 -- slider

	oUF_MlightDB.AuraFilterignoreBuff = false
	oUF_MlightDB.AuraFilterignoreDebuff = false
	oUF_MlightDB.AuraFilterwhitelist = {}

	oUF_MlightDB.showthreatbar = true
	oUF_MlightDB.tbvergradient = false

	-- show/hide boss
	oUF_MlightDB.bossframes = true

	--[[ share ]]--
	oUF_MlightDB.enableraid = true
	oUF_MlightDB.raidfontsize = 10
	oUF_MlightDB.showsolo = true
	oUF_MlightDB.autoswitch = true
	oUF_MlightDB.raidonlyhealer = false
	oUF_MlightDB.raidonlydps = false
	
	oUF_MlightDB.enablearrow = true
	oUF_MlightDB.arrowsacle = 1.0

	--[[ healer mode ]]--
	oUF_MlightDB.healergroupfilter = '1,2,3,4,5'
	oUF_MlightDB.healerraidheight = 30
	oUF_MlightDB.healerraidwidth = 70
	oUF_MlightDB.anchor = "TOP" -- dropdown
	oUF_MlightDB.partyanchor = "LEFT" -- dropdown
	oUF_MlightDB.showgcd = true
	oUF_MlightDB.healprediction = true

	--[[ dps/tank mode ]]--
	oUF_MlightDB.dpsgroupfilter = '1,2,3,4,5'
	oUF_MlightDB.dpsraidheight = 15
	oUF_MlightDB.dpsraidwidth = 70
	oUF_MlightDB.dpsraidgroupbyclass = true
	oUF_MlightDB.unitnumperline = 25
end
ns.LoadVariables = LoadVariables
