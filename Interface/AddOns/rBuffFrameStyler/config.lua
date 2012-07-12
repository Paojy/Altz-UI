
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
    pos             = { a1 = "TOPRIGHT", af = "UIParent", a2 = "TOPRIGHT", x = -10, y = -15 }, 
    userplaced      = true, --want to place the bar somewhere else?
    locked          = true, --frame locked, can be unlocked ingame via /rbuff
    rowSpacing      = 10,
    colSpacing      = 6,
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

  cfg.textures = {
    normal            = "Interface\\AddOns\\rBuffFrameStyler\\media\\gloss",
    outer_shadow      = "Interface\\AddOns\\rBuffFrameStyler\\media\\outer_shadow",
  }

  cfg.background = {
    showshadow        = true,   --show an outer shadow?
    shadowcolor       = { r = 0, g = 0, b = 0, a = 0.9},
    inset             = 4,
  }

  cfg.color = {
    normal            = { r = 0.4, g = 0.35, b = 0.35, },
    classcolored      = false,
  }

  cfg.duration = {
    fontsize        = 13,
    pos             = { a1 = "BOTTOM", x = 5, y = -10 },
  }

  cfg.count = {
    fontsize        = 12,
    pos             = { a1 = "TOPRIGHT", x = 0, y = 0 },
  }

  cfg.font = GameFontHighlight:GetFont()
