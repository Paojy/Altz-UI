
  --get the addon namespace
  local addon, ns = ...
  --get the config values
  local cfg = ns.cfg
  local dragFrameList = ns.dragFrameList

  ---------------------------------------
  -- CONSTANTS
  ---------------------------------------

  --disable consolidated buffs
  SetCVar("consolidateBuffs", 0)

  --rewrite the oneletter shortcuts
  HOUR_ONELETTER_ABBR = "%dh";
  DAY_ONELETTER_ABBR = "%dd";
  MINUTE_ONELETTER_ABBR = "%dm";
  SECOND_ONELETTER_ABBR = "%ds";
  
textures = {
	blank             = "Interface\\Buttons\\WHITE8x8",
    normal            = "Interface\\AddOns\\rBuffFrameStyler\\media\\gloss",
    outer_shadow      = "Interface\\AddOns\\rBuffFrameStyler\\media\\outer_shadow",
  }

-- grow
local backdrop = {
    bgFile = "",
    edgeFile = textures.outer_shadow,
    tile = false,
    edgeSize = 3,
    insets = { left = 3, right = 3, top = 3, bottom = 3 },
  }
  
-- border  
local backdrop2 = {
    bgFile = "",
	edgeFile = textures.blank,
	edgeSize = 1,
    insets = {top = 1, left = 1, bottom = 1, right = 1},
}


  ---------------------------------------
  -- FUNCTIONS
  ---------------------------------------

  --create drag frame for temp enchant icons
  local function createTempEnchantHolder()
    local frame = CreateFrame("Frame", "rBFS_TempEnchantHolder", UIParent)
    frame:SetSize(50,50)
    frame:SetPoint(cfg.tempenchant.pos.a1,cfg.tempenchant.pos.af,cfg.tempenchant.pos.a2,cfg.tempenchant.pos.x,cfg.tempenchant.pos.y)
    if cfg.tempenchant.userplaced then
      rCreateDragFrame(frame, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
    end
  end

  --create drag frame for buff icons
  local function createBuffFrameHolder()
    local frame = CreateFrame("Frame", "rBFS_BuffFrameHolder", UIParent)
    frame:SetSize(50,50)
    frame:SetPoint(cfg.buffframe.pos.a1,cfg.buffframe.pos.af,cfg.buffframe.pos.a2,cfg.buffframe.pos.x,cfg.buffframe.pos.y)
    if cfg.buffframe.userplaced then
      rCreateDragFrame(frame, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
    end
  end

  --create the drag frames
  createTempEnchantHolder()
  createBuffFrameHolder()

  --move tempenchant frame
  local function moveTempEnchantFrame()
    local f = rBFS_TempEnchantHolder
    TemporaryEnchantFrame:SetParent(f)
    TemporaryEnchantFrame:ClearAllPoints()
    TemporaryEnchantFrame:SetPoint("TOPLEFT",0,0)
  end

  --move buff frame
  local function moveBuffFrame()
    local f = rBFS_BuffFrameHolder
    BuffFrame:SetParent(f)
    BuffFrame:ClearAllPoints()
    BuffFrame:SetPoint("TOPRIGHT",0,0)
  end

  --apply aura frame texture func
  local function applySkin(b,type)
    if not b or (b and b.styled) then return end

    local name = b:GetName()
    --print("applying skin for "..name)
    local border = _G[name.."Border"]
    local icon = _G[name.."Icon"]

    if border then
      border:SetTexture(textures.normal)
      border:SetTexCoord(0,1,0,1)
      border:SetDrawLayer("BACKGROUND",-7)
      if type == "wpn" then
        border:SetVertexColor(0.7,0,1)
      end
      border:ClearAllPoints()
      border:SetAllPoints(b)
      b.Border = border
    else
      --create border (for buff icons)
      local new = b:CreateTexture(nil,"BACKGROUND",nil,-7)
      new:SetAllPoints(b)
      new:SetTexture(textures.normal)
      new:SetVertexColor(0, 0, 0)
      b.Border = border
    end

    --icon
    icon:SetTexCoord(0.1,0.9,0.1,0.9)
    icon:SetPoint("TOPLEFT", b, "TOPLEFT", 2, -2)
    icon:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -2, 2)
    icon:SetDrawLayer("BACKGROUND",-8)

    --duration
    b.duration:SetFont(cfg.font, 11, "THINOUTLINE")
    b.duration:ClearAllPoints()
    b.duration:SetPoint("BOTTOM", 2, -10)

    --count
    b.count:SetFont(cfg.font, 12, "THINOUTLINE")
    b.count:ClearAllPoints()
    b.count:SetPoint("TOPRIGHT", 0, 0)

    --shadow
    local back = CreateFrame("Frame", nil, b)
    back:SetPoint("TOPLEFT", b, "TOPLEFT", -1, 1)
    back:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 1, -1)
    back:SetFrameLevel(b:GetFrameLevel()-2)
    back:SetBackdrop(backdrop)
    back:SetBackdropBorderColor(0, 0, 0, 1)
    local back1 = CreateFrame("Frame", nil, b)
    back1:SetPoint("TOPLEFT", b, "TOPLEFT", 1, -1)
    back1:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -1, 1)
    back1:SetFrameLevel(b:GetFrameLevel()-1)
    back1:SetBackdrop(backdrop2)
    back1:SetBackdropBorderColor(0, 0, 0, 1)
	
    --set button styled variable
    b.styled = true
  end

  --update buff anchors
  local function updateBuffAnchors()
    --print(BUFF_ACTUAL_DISPLAY)
    local numBuffs = 0
    local buff, previousBuff, aboveBuff
    for i = 1, BUFF_ACTUAL_DISPLAY do
      buff = _G["BuffButton"..i]
      if not buff.styled then applySkin(buff,"buff") end
      buff:SetParent(BuffFrame)
      buff.consolidated = nil
      buff.parent = BuffFrame
      buff:ClearAllPoints()
      numBuffs = numBuffs + 1
      index = numBuffs
      if ((index > 1) and (mod(index, cfg.buffframe.buffsPerRow) == 1)) then
        buff:SetPoint("TOP", aboveBuff, "BOTTOM", 0, -cfg.buffframe.rowSpacing)
        aboveBuff = buff
      elseif (index == 1) then
        buff:SetPoint("TOPRIGHT", BuffFrame, "TOPRIGHT", 0, 0)
        aboveBuff = buff
      else
        buff:SetPoint("RIGHT", previousBuff, "LEFT", -cfg.buffframe.colSpacing, 0)
      end
      previousBuff = buff
    end
  end

  --update debuff anchors
  local function updateDebuffAnchors(buttonName,index)
    local numBuffs = BUFF_ACTUAL_DISPLAY
    local rows = ceil(numBuffs/cfg.buffframe.buffsPerRow)
    local gap = cfg.buffframe.gap
    if rows == 0 then gap = 0 end
    local buff = _G[buttonName..index]
    if not buff.styled then applySkin(buff,"debuff") end
    -- Position debuffs
    if ((index > 1) and (mod(index, cfg.buffframe.buffsPerRow) == 1)) then
      buff:SetPoint("TOP", _G[buttonName..(index-cfg.buffframe.buffsPerRow)], "BOTTOM", 0, -cfg.buffframe.rowSpacing)
    elseif (index == 1) then
      buff:SetPoint("TOPRIGHT", BuffFrame, "TOPRIGHT", 0, -(rows*(cfg.buffframe.rowSpacing+buff:GetHeight())+gap))
    else
      buff:SetPoint("RIGHT", _G[buttonName..(index-1)], "LEFT", -cfg.buffframe.colSpacing, 0)
    end
  end

  --update wpn enchant icon positions
  local function updateTempEnchantAnchors()
    for i=1, NUM_TEMP_ENCHANT_FRAMES do
      local b = _G["TempEnchant"..i]
	  b:ClearAllPoints()
        if (i == 1) then
          b:SetPoint("TOPLEFT", TemporaryEnchantFrame, "TOPLEFT", 0, 0)
        else
		  local previousBuff = _G["TempEnchant"..i-1]
          b:SetPoint("LEFT", previousBuff, "RIGHT", cfg.tempenchant.colSpacing, 0)
        end
    end
  end

  --init func
  local function init()
    --BuffFrame scale
    BuffFrame:SetScale(cfg.buffframe.scale)
    --temp enchantframe scale
    TemporaryEnchantFrame:SetScale(cfg.tempenchant.scale)
    --position buff frame
    moveBuffFrame()
    --position temp enchant icons
    moveTempEnchantFrame()
    --skin temp enchant
    for i=1, NUM_TEMP_ENCHANT_FRAMES do
      local b = _G["TempEnchant"..i]
      if b and not b.styled then
        applySkin(b, "wpn")
      end
    end
    --move temp enchant icons in position
    updateTempEnchantAnchors()
    --hook the consolidatedbuffs
    if ConsolidatedBuffs then
      ConsolidatedBuffs:UnregisterAllEvents()
      ConsolidatedBuffs:HookScript("OnShow", function(s)
        s:Hide()
        moveTempEnchantFrame()
      end)
      ConsolidatedBuffs:HookScript("OnHide", function(s)
        moveTempEnchantFrame()
      end)
      ConsolidatedBuffs:Hide()
    end
  end

  ---------------------------------------
  -- CALLS // HOOKS
  ---------------------------------------

  --hook Blizzard functions to move the buffframe
  hooksecurefunc("BuffFrame_UpdateAllBuffAnchors",    updateBuffAnchors)
  hooksecurefunc("DebuffButton_UpdateAnchors",        updateDebuffAnchors)

  local a = CreateFrame("Frame")
  a:RegisterEvent("PLAYER_LOGIN")
  a:SetScript("OnEvent", init)