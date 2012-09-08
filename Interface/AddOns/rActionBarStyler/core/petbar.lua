
  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...
  local gcfg = ns.cfg
  --get some values from the namespace
  local cfg = gcfg.bars.petbar
  local dragFrameList = ns.dragFrameList

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  if not cfg.enable then return end

  local num = NUM_PET_ACTION_SLOTS
  local buttonList = {}

  --create the frame to hold the buttons
  local frame = CreateFrame("Frame", "rABS_PetBar", UIParent, "SecureHandlerStateTemplate")
  if not cfg.uselayout5x2 then
  frame:SetWidth(num*cfg.buttons.size + (num-1)*cfg.buttons.margin + 2*cfg.padding)
  frame:SetHeight(cfg.buttons.size + 2*cfg.padding)
  else
  frame:SetWidth(num/2*cfg.buttons.size + (num/2-1)*cfg.buttons.margin + 2*cfg.padding)
  frame:SetHeight(2*cfg.buttons.size + cfg.buttons.margin + 2*cfg.padding)
  end
  frame:SetPoint(cfg.pos.a1,cfg.pos.af,cfg.pos.a2,cfg.pos.x,cfg.pos.y)
  frame:SetScale(cfg.scale)

  --move the buttons into position and reparent them
  PetActionBarFrame:SetParent(frame)
  PetActionBarFrame:EnableMouse(false)

  for i=1, num do
    local button = _G["PetActionButton"..i]
    table.insert(buttonList, button) --add the button object to the list
    button:SetSize(cfg.buttons.size, cfg.buttons.size)
    button:ClearAllPoints()
    if i == 1 then
      button:SetPoint("TOPLEFT", frame, cfg.padding, -cfg.padding)
	elseif cfg.uselayout5x2 and i == 6 then
	  button:SetPoint("TOP", "PetActionButton1", "BOTTOM", 0, -cfg.buttons.margin)
    else
      local previous = _G["PetActionButton"..i-1]
      button:SetPoint("LEFT", previous, "RIGHT", cfg.buttons.margin, 0)
    end
    --cooldown fix
    local cd = _G["PetActionButton"..i.."Cooldown"]
    cd:SetAllPoints(button)
  end

  
  if not cfg.show then --wait...you no see me? :(
    frame:SetParent(rABS_BizzardHider)
    return
  end

  --hide the frame when in a vehicle!
  RegisterStateDriver(frame, "visibility", "[petbattle][overridebar][vehicleui] hide; [@pet,exists,nodead] show; hide")

  --create drag frame and drag functionality
  if cfg.userplaced.enable then
    rCreateDragFrame(frame, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
  end

  --create the mouseover functionality
  if cfg.mouseover.enable then
    ActionbarFader(frame, buttonList, cfg.mouseover.fadeIn, cfg.mouseover.fadeOut) --frame, buttonList, fadeIn, fadeOut
  end

  --create the fade on condition functionality
  if cfg.eventfader.enable then
    ActionbarEventFader(frame, buttonList, cfg.eventfader.fadeIn, cfg.eventfader.fadeOut) --frame, fadeIn, fadeOut
  end