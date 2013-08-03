local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)
local dragFrameList = G.dragFrameList

local bodercolor = {r = 0.4, g = 0.35, b = 0.35}
local gloss = "Interface\\AddOns\\AltzUI\\media\\gloss"

local ceil, min, max = ceil, min, max
local ShouldShowConsolidatedBuffFrame = ShouldShowConsolidatedBuffFrame

local buffFrameHeight = 0
local seperate = aCoreCDB["BuffFrameOptions"]["seperate"]

local buff = {
	size = aCoreCDB["BuffFrameOptions"]["buffsize"],
	rowspace = aCoreCDB["BuffFrameOptions"]["buffrowspace"],
	iconpadding = aCoreCDB["BuffFrameOptions"]["buffcolspace"],
	durationsize = aCoreCDB["BuffFrameOptions"]["bufftimesize"],
	countsize = aCoreCDB["BuffFrameOptions"]["buffcountsize"],
	PerRow = aCoreCDB["BuffFrameOptions"]["buffsPerRow"],
}

local debuff = {
	size = aCoreCDB["BuffFrameOptions"]["debuffsize"],
	rowspace = aCoreCDB["BuffFrameOptions"]["debuffrowspace"],
	iconpadding = aCoreCDB["BuffFrameOptions"]["debuffcolspace"],
	durationsize = aCoreCDB["BuffFrameOptions"]["debufftimesize"],
	countsize = aCoreCDB["BuffFrameOptions"]["debuffcountsize"],
	PerRow = aCoreCDB["BuffFrameOptions"]["debuffsPerRow"],
}
  ---------------------------------------
  -- FUNCTIONS
  ---------------------------------------

  --apply aura frame texture func
local function applySkin(b)
    if not b or (b and b.styled) then return end
    --button name
    local name = b:GetName()
    --check the button type
    local tempenchant, consolidated, Debuff, Buff = false, false, false, false
    if (name:match("TempEnchant")) then
      tempenchant = true
    elseif (name:match("Consolidated")) then
      consolidated = true
    elseif (name:match("Debuff")) then
      Debuff = true
    else
      Buff = true
    end

    --button
	if Debuff then
		b:SetSize(debuff.size, debuff.size)
	else
		b:SetSize(buff.size, buff.size)
	end
	
    --icon
    local icon = _G[name.."Icon"]
    if consolidated then
     icon:SetTexture(select(3,GetSpellInfo(109077))) --cogwheel
    end
    icon:SetTexCoord(0.1,0.9,0.1,0.9)
    icon:ClearAllPoints()
	icon:SetPoint("TOPLEFT", b, "TOPLEFT", 0, 0)
	icon:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 0, 0)
	
    icon:SetDrawLayer("BACKGROUND",-8)
    b.icon = icon

    --border
    local border = _G[name.."Border"] or b:CreateTexture(name.."Border", "BACKGROUND", nil, -7)
    border:SetTexture(gloss)
    border:SetTexCoord(0,1,0,1)
    border:SetDrawLayer("BACKGROUND",-7)
    if tempenchant then
      border:SetVertexColor(0.7,0,1)
    elseif not Debuff then
      border:SetVertexColor(bodercolor.r,bodercolor.g,bodercolor.b)
    end
    border:ClearAllPoints()
    border:SetAllPoints(b)
    b.border = border

    --duration
	if Debuff then
		b.duration:SetFont(G.numFont, debuff.durationsize, "THINOUTLINE")
	else
		b.duration:SetFont(G.numFont, buff.durationsize, "THINOUTLINE")
	end
	b.duration:SetShadowOffset(0, 0)
    b.duration:ClearAllPoints()
    b.duration:SetPoint("CENTER", b, "BOTTOM")

    --count
	if Debuff then
		b.count:SetFont(G.numFont, debuff.countsize, "THINOUTLINE")
	else
		b.count:SetFont(G.numFont, buff.countsize, "THINOUTLINE")
	end
	b.count:SetShadowOffset(0, 0)
    b.count:ClearAllPoints()
    b.count:SetPoint("TOPRIGHT", 2, 2)
	
	T.createBackdrop(b, b, 0)
	
    --set button styled variable
    b.styled = true
end

  --update debuff anchors
local function updateDebuffAnchors(buttonName,index)
	local button = _G[buttonName..index]
    if not button then return end
    --apply skin
    if not button.styled then applySkin(button) end
    --position button
    button:ClearAllPoints()
    if index == 1 then
      if seperate then
        button:SetPoint("TOPRIGHT", _G[G.uiname.."DebuffDragFrame"], "TOPRIGHT", 0, 0)    
      else
        button:SetPoint("TOPRIGHT", _G[G.uiname.."BuffDragFrame"], "TOPRIGHT", 0, -buffFrameHeight)
      end     
    elseif index > 1 and mod(index, debuff.PerRow) == 1 then
      button:SetPoint("TOPRIGHT", _G[buttonName..(index-debuff.PerRow)], "BOTTOMRIGHT", 0, -debuff.rowspace)
    else
      button:SetPoint("TOPRIGHT", _G[buttonName..(index-1)], "TOPLEFT", -debuff.iconpadding, 0)
    end
end
  
  --update buff anchors
local function updateAllBuffAnchors()
    --variables
    local buttonName  = "BuffButton"
    local numEnchants = BuffFrame.numEnchants
    local numBuffs    = BUFF_ACTUAL_DISPLAY
    local offset      = numEnchants
    local realIndex, previousButton, aboveButton
    --position the tempenchant button depending on the consolidated button status
    if ShouldShowConsolidatedBuffFrame() then
      TempEnchant1:ClearAllPoints()
      TempEnchant1:SetPoint("TOPRIGHT", ConsolidatedBuffs, "TOPLEFT", -buff.iconpadding, 0)
      offset = offset + 1
    else
      TempEnchant1:ClearAllPoints()
      TempEnchant1:SetPoint("TOPRIGHT", _G[G.uiname.."BuffDragFrame"], "TOPRIGHT", 0, 0)
    end
    
    --calculate the previous button in case tempenchant or consolidated buff are loaded
    if BuffFrame.numEnchants > 0 then
      previousButton = _G["TempEnchant"..numEnchants]
    elseif ShouldShowConsolidatedBuffFrame() then
      previousButton = ConsolidatedBuffs
    end
    --calculate the above button in case tempenchant or consolidated buff are loaded
    if ShouldShowConsolidatedBuffFrame() then
      aboveButton = ConsolidatedBuffs
    elseif numEnchants > 0 then
      aboveButton = TempEnchant1
    end
    --loop on all active buff buttons
    local buffCounter = 0
    for index = 1, numBuffs do
      local button = _G[buttonName..index]
      if not button then return end
      if not button.consolidated then
        buffCounter = buffCounter + 1
        --apply skin
        if not button.styled then applySkin(button) end
        --position button
        button:ClearAllPoints()
        realIndex = buffCounter+offset
        if realIndex == 1 then
          button:SetPoint("TOPRIGHT", _G[G.uiname.."BuffDragFrame"], "TOPRIGHT", 0, 0)
          aboveButton = button
        elseif realIndex > 1 and mod(realIndex, buff.PerRow) == 1 then
          button:SetPoint("TOPRIGHT", aboveButton, "BOTTOMRIGHT", 0, -buff.rowspace)
          aboveButton = button
        else
          button:SetPoint("TOPRIGHT", previousButton, "TOPLEFT", -buff.iconpadding, 0)
        end
        previousButton = button
        
      end
    end
    --calculate the height of the buff rows for the debuff frame calculation later
    local rows = ceil((buffCounter+offset)/buff.PerRow)
    local height = buff.size*rows + buff.rowspace*rows
    buffFrameHeight = height
	--make sure the debuff frames update the position asap
    if DebuffButton1 and not seperate then    
      updateDebuffAnchors("DebuffButton", 1)
    end
end

  ---------------------------------------
  -- INIT
  ---------------------------------------

  --buff drag frame
local bf = CreateFrame("Frame", G.uiname.."BuffDragFrame", UIParent)
bf:SetSize(buff.size, buff.size)
bf.movingname = L["增益框"]
bf.point = {
	healer = {a1 = "TOPRIGHT", parent = "UIParent", a2 = "TOPRIGHT", x = -16, y = -20},
	dpser = {a1 = "TOPRIGHT", parent = "UIParent", a2 = "TOPRIGHT", x = -16, y = -20},
}
T.CreateDragFrame(bf) --frame, dragFrameList, inset, clamp

--debuff drag frame
if seperate then
	local df = CreateFrame("Frame", G.uiname.."DebuffDragFrame", UIParent)
	df:SetSize(debuff.size, debuff.size)	
	df.movingname = L["减益框"]
	df.point = {
		healer = {a1 = "TOPRIGHT", parent = "UIParent", a2 = "TOPRIGHT", x = -16, y = -96},
		dpser = {a1 = "TOPRIGHT", parent = "UIParent", a2 = "TOPRIGHT", x = -16, y = -96},
	}
	T.CreateDragFrame(df) --frame, dragFrameList, inset, clamp
end

--temp enchant stuff
applySkin(TempEnchant1)
applySkin(TempEnchant2)
applySkin(TempEnchant3)

--position the temp enchant buttons
TempEnchant1:ClearAllPoints()
TempEnchant1:SetPoint("TOPRIGHT", _G[G.uiname.."BuffDragFrame"], "TOPRIGHT", 0, 0) --button will be repositioned later in case temp enchant and consolidated buffs are both available
TempEnchant2:ClearAllPoints()
TempEnchant2:SetPoint("TOPRIGHT", TempEnchant1, "TOPLEFT", -buff.iconpadding, 0)
TempEnchant3:ClearAllPoints()
TempEnchant3:SetPoint("TOPRIGHT", TempEnchant2, "TOPLEFT", -buff.iconpadding, 0)

--consolidated buff stuff
ConsolidatedBuffs:SetScript("OnLoad", nil) --do not fuck up the icon anymore
applySkin(ConsolidatedBuffs)
--position the consolidate buff button
ConsolidatedBuffs:ClearAllPoints()
ConsolidatedBuffs:SetPoint("TOPRIGHT", _G[G.uiname.."BuffDragFrame"], "TOPRIGHT", 0, 0)
  
ConsolidatedBuffsTooltip:SetScale(1.2)
F.CreateBD(ConsolidatedBuffsTooltip)

--hook Blizzard functions
hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", updateAllBuffAnchors)
hooksecurefunc("DebuffButton_UpdateAnchors", updateDebuffAnchors)
