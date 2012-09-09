
  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...
  local gcfg = ns.cfg
  --get some values from the namespace
  local cfg = gcfg.bars.bar3
  local dragFrameList = ns.dragFrameList

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  if not cfg.enable then return end
  
  local num = NUM_ACTIONBAR_BUTTONS
  local buttonList = {}

  --create the frame to hold the buttons
  local frame = CreateFrame("Frame", "rABS_MultiBarBottomRight", UIParent, "SecureHandlerStateTemplate")
  if cfg.layout3x2x2 then
    frame:SetWidth(num/2*cfg.buttons.size +(num/2-2)*cfg.buttons.margin +2*cfg.padding +num*gcfg.bars.bar12.buttons.size +(num-1)*gcfg.bars.bar12.buttons.margin +2*cfg.padding +2*cfg.space1)
    frame:SetHeight(2*cfg.buttons.size + 2*cfg.padding + cfg.buttons.margin)
  else
    frame:SetWidth(num*cfg.buttons.size + (num-1)*cfg.buttons.margin + 2*cfg.padding)
    frame:SetHeight(cfg.buttons.size + 2*cfg.padding)
  end
  frame:SetPoint(cfg.pos.a1,cfg.pos.af,cfg.pos.a2,cfg.pos.x,cfg.pos.y)
  frame:SetScale(cfg.scale)

  --move the buttons into position and reparent them
  MultiBarBottomRight:SetParent(frame)
  MultiBarBottomRight:EnableMouse(false)

  for i=1, num do
    local button = _G["MultiBarBottomRightButton"..i]
    table.insert(buttonList, button) --add the button object to the list
    button:SetSize(cfg.buttons.size, cfg.buttons.size)
    button:ClearAllPoints()
    if i == 1 then
      button:SetPoint("TOPLEFT", frame, cfg.padding, -cfg.padding)
	elseif cfg.layout3x2x2 and i == 4 then
	  button:SetPoint("TOP", "MultiBarBottomRightButton1", "BOTTOM", 0, -cfg.buttons.margin)
	elseif cfg.layout3x2x2 and i == 7 then
	  button:SetPoint("TOPRIGHT", frame, -cfg.padding -2*cfg.buttons.size -2*cfg.buttons.margin, -cfg.padding)
	elseif cfg.layout3x2x2 and i == 10 then
	  button:SetPoint("TOP", "MultiBarBottomRightButton7", "BOTTOM", 0, -cfg.buttons.margin)
	else
      local previous = _G["MultiBarBottomRightButton"..i-1]
      button:SetPoint("LEFT", previous, "RIGHT", cfg.buttons.margin, 0)
    end
  end

  --hide the frame when in a vehicle!
  RegisterStateDriver(frame, "visibility", "[petbattle][overridebar][vehicleui] hide; show")

  --create drag frame and drag functionality
  if cfg.userplaced.enable then
    rCreateDragFrame(frame, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
  end

  --create the mouseover functionality
  if cfg.mouseover.enable then
    ActionbarFader(frame, buttonList, cfg.mouseover.fadeIn, cfg.mouseover.fadeOut) --frame, buttonList, fadeIn, fadeOut
	frame.mouseover = cfg.mouseover
  end

  --create the fade on condition functionality
  if cfg.eventfader.enable then
    ActionbarEventFader(frame, buttonList, cfg.eventfader.fadeIn, cfg.eventfader.fadeOut) --frame, fadeIn, fadeOut
	frame.mouseover = cfg.eventfader
  end