
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
    scale           = 1,
    pos             = { a1 = "TOPRIGHT", af = "UIParent", a2 = "TOPRIGHT", x = -15, y = -16 }, 
    userplaced      = false, --want to place the bar somewhere else?
    locked          = true, --frame locked, can be unlocked ingame via /rbuff
    rowSpacing      = 10,
    colSpacing      = 3,
    buffsPerRow     = 14,
    gap             = 10, --gap in pixel between buff and debuff
  }

  cfg.tempenchant = {
    scale           = 1,
    pos             = { a1 = "TOPLEFT", a2 = "BOTTOMLEFT", af = Minimap, x = -1, y = -2 },
    userplaced      = false, --want to place the bar somewhere else?
    locked          = true, --frame locked, can be unlocked ingame via /rbuff
    colSpacing      = 3,
  }

  cfg.font = GameFontHighlight:GetFont()
