
  -- // rActionBarStyler
  -- // zork - 2012

  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local cfg = CreateFrame("Frame")
  local addon, ns = ...
  ns.cfg = cfg
  -----------------------------
  -- CONFIG
  -----------------------------

  --use "/rabs" to see the command list

  cfg.bars = {
    bar12 = {
      enable          = true,
      scale           = 1,
      padding         = 4, --frame padding
      buttons         = {
        size            = 25,
        margin          = 4,
      },
      pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 15 },
      userplaced      = {
        enable          = true,
      },
      mouseover       = {
        enable          = true,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 0.4, alpha = 0.4},
      },
	  eventfader      = {
        enable          = true,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 1.5, alpha = 0.4},
      },
    },
    overridebar = { --the new vehicle and override bar
      enable          = true,
      scale           = 1,
      padding         = 4, --frame padding
      buttons         = {
        size            = 35,
        margin          = 4,
      },
      pos             = { a1 = "BOTTOMLEFT", a2 = "BOTTOM", af = "UIParent", x = -140, y = 30 },
      userplaced      = {
        enable          = false,
      },
      mouseover       = {
        enable          = false,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 0.4, alpha = 0},
      },
    },
    bar3 = {
      enable          = true,
	  layout3x2x2     = true,
	  space1          = 5, -- the space between the left part and the right part are (bar12's width + 2*space1). only available when enable layout3x2x2. 
      scale           = 1,
      padding         = 4, --frame padding
      buttons         = {
        size            = 25,
        margin          = 4,
      },
      pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 15 },
      userplaced      = {
        enable          = true,
      },
      mouseover       = {
        enable          = true,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 0.4, alpha = 0.4},
      },		
	  eventfader      = {
        enable          = false,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 1.5, alpha = 0},
      },
    },
    bar45 = {
      enable          = true,
      scale           = 1,
      padding         = 4, --frame padding
      buttons         = {
        size            = 25,
        margin          = 4,
      },
      pos             = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -6, y = 0 },
      userplaced      = {
        enable          = true,
      },
      mouseover       = {
        enable          = true,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 0.3, alpha = 0.1},
      },		
	  eventfader      = {
        enable          = false,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 0.4, alpha = 0},
      },
    },
    petbar = {
      enable          = true,
	  show            = true, --true/false
	  uselayout5x2    = false,
      scale           = 0.7,
      padding         = 4, --frame padding
      buttons         = {
        size            = 33,
        margin          = 4,
      },
      pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 115 },
      userplaced      = {
        enable          = true,
      },
      mouseover       = {
        enable          = true,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 0.4, alpha = 0.2},
      },
	  eventfader      = {
        enable          = false,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 1.5, alpha = 0},
      },
    },
    stancebar = {
      enable          = true,
      show            = true, --true/false
      scale           = 1,
      padding         = 4, --frame padding
      buttons         = {
        size            = 20,
        margin          = 4,
      },
      pos             = { a1 = "TOPLEFT", a2 = "BOTTOMLEFT", af = Minimap, x = -2, y = -2 },
      userplaced      = {
        enable          = true,
      },
      mouseover       = {
        enable          = false,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 0.4, alpha = 0.5},
      },
	  eventfader      = {
        enable          = false,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 1.5, alpha = 0},
      },
    },
    extrabar = {
      enable          = true,
      scale           = 1,
      padding         = 10, --frame padding
      buttons         = {
        size            = 30,
        margin          = 4,
      },
      pos             = { a1 = "TOP", a2 = "CENTER", af = "UIParent", x = 0, y = -200 },
      userplaced      = {
        enable          = true,
      },
      mouseover       = {
        enable          = false,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 0.3, alpha = 0.2},
      },
    },
    leave_vehicle = {
      enable          = true, --enable module
      scale           = 1,
      padding         = 10, --frame padding
      buttons         = {
        size            = 30,
        margin          = 5,
      },
      pos             = { a1 = "BOTTOMLEFT", a2 = "BOTTOM", af = "UIParent", x = 280, y = 20 },
      userplaced      = {
        enable          = true,
      },
      mouseover       = {
        enable          = false,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 0.3, alpha = 0.2},
      },
    },
    micromenu = {
      enable          = true,
	  show            = true, --true/false
      scale           = 0.8,
      padding         = 10, --frame padding
      pos             = { a1 = "TOP", a2 = "TOP", af = "UIParent", x = 0, y = 25 },
      userplaced      = {
        enable          = true,
      },
      mouseover       = {
        enable          = true,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 0.4, alpha = 0},
      },
    },
  }
