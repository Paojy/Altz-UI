
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
    bar1 = {
      enable          = true,
      scale           = 1,
      padding         = 2, --frame padding
      buttons         = {
        size            = 25,
        margin          = 4,
      },
      pos             = { a1 = "TOP", a2 = "CENTER", af = "UIParent", x = 0, y = -142 },
      userplaced      = {
        enable          = false,
      },
      mouseover       = {
        enable          = true,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 0.4, alpha = 0},
      },
	  eventfader      = {
        enable          = true,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 1.5, alpha = 0},
      },
    },
    overridebar = { --the new vehicle and override bar
      enable          = true,
      scale           = 1,
      padding         = 2, --frame padding
      buttons         = {
        size            = 25,
        margin          = 4,
      },
      pos             = { a1 = "TOP", a2 = "CENTER", af = "UIParent", x = 0, y = -142 },
      userplaced      = {
        enable          = false,
      },
      mouseover       = {
        enable          = false,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 0.4, alpha = 0},
      },
    },
    bar2 = {
      enable          = true,
	  combineBar23    = true,--by choosing true both bar 2 and 3 will react to the same hover effect, thus show/hide at the same time, settings for bar5 will be ignored
      scale           = 1,
      padding         = 2, --frame padding
      buttons         = {
        size            = 25,
        margin          = 4,
      },
      pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 15 },
      userplaced      = {
        enable          = false,
      },
      mouseover       = {
        enable          = true,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 0.4, alpha = 0},
      },		
	  eventfader      = {
        enable          = false,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 1.5, alpha = 0},
      },
    },
    bar3 = {
      enable          = true,
      scale           = 1,
      padding         = 2, --frame padding
      buttons         = {
        size            = 25,
        margin          = 4,
      },
      pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 83 },
      userplaced      = {
        enable          = false,
      },
      mouseover       = {
        enable          = true,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 0.4, alpha = 0},
      },		
	  eventfader      = {
        enable          = false,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 1.5, alpha = 0},
      },
    },
    bar4 = {
      enable          = true,
      combineBar4AndBar5  = true, --by choosing true both bar 4 and 5 will react to the same hover effect, thus show/hide at the same time, settings for bar5 will be ignored
      scale           = 1,
      padding         = 10, --frame padding
      buttons         = {
        size            = 25,
        margin          = 4,
      },
      pos             = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = 0, y = 0 },
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
    bar5 = {
      enable          = true,
      scale           = 1,
      padding         = 10, --frame padding
      buttons         = {
        size            = 25,
        margin          = 4,
      },
      pos             = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -31, y = 0 },
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
        fadeOut         = {time = 1.5, alpha = 0},
      },
    },
    petbar = {
      enable          = true,
	  show            = true, --true/false
	  uselayout5x2    = false,
      scale           = 0.7,
      padding         = 2, --frame padding
      buttons         = {
        size            = 33,
        margin          = 4,
      },
      pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 115 },
      userplaced      = {
        enable          = false,
      },
      mouseover       = {
        enable          = true,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 0.4, alpha = 0},
      },
	  eventfader      = {
        enable          = true,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 1.5, alpha = 0},
      },
    },
    stancebar = {
      enable          = true,
      show            = true, --true/false
      scale           = 1,
      padding         = 2, --frame padding
      buttons         = {
        size            = 20,
        margin          = 4,
      },
      pos             = { a1 = "TOPLEFT", a2 = "BOTTOMLEFT", af = Minimap, x = -3, y = -4 },
      userplaced      = {
        enable          = false,
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
      scale           = 1.5,
      padding         = 10, --frame padding
      buttons         = {
        size            = 36,
        margin          = 4,
      },
      pos             = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 210, y = -30 },
      userplaced      = {
        enable          = false,
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
