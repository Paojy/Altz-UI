
  -- // rBuffFrameStyler
  -- // zork - 2010

  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...
  local cfg = CreateFrame("Frame")
  ns.cfg = cfg

  -----------------------------
  -- CONFIG
  -----------------------------

  cfg.buffframe = {
    scale           = 0.9,
    pos             = { a1 = "TOPRIGHT", af = "UIParent", a2 = "TOPRIGHT", x = -15, y = -16 }, 
    userplaced      = false, --want to place the bar somewhere else?
    locked          = true, --frame locked, can be unlocked ingame via /rbuff
    rowSpacing      = 10,
    colSpacing      = 3,
    buffsPerRow     = 14,
    gap             = 10, --gap in pixel between buff and debuff
  }

  cfg.tempenchant = {
    scale           = 0.9,
    pos             = { a1 = "BOTTOMRIGHT", a2 = "BOTTOMRIGHT", af = "UIParent", x = -10, y = 10 },
    userplaced      = true, --want to place the bar somewhere else?
    locked          = true, --frame locked, can be unlocked ingame via /rbuff
    colSpacing      = 7,
  }

  cfg.font = GameFontHighlight:GetFont()
