
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
  if gcfg.bars.bar2.combineBar23 then return end
  
  local num = NUM_ACTIONBAR_BUTTONS
  local buttonList = {}

  --create the frame to hold the buttons
  local frame = CreateFrame("Frame", "rABS_MultiBarBottomRight", UIParent, "SecureHandlerStateTemplate")
  frame:SetWidth(num*cfg.buttons.size + (num-1)*cfg.buttons.margin + 2*cfg.padding)
  frame:SetHeight(cfg.buttons.size + 2*cfg.padding)
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
      button:SetPoint("LEFT", frame, cfg.padding, 0)
    else
      local previous = _G["MultiBarBottomRightButton"..i-1]
      button:SetPoint("LEFT", previous, "RIGHT", cfg.buttons.margin, 0)
    end
  end

  --hide the frame when in a vehicle!
  RegisterStateDriver(frame, "visibility", "[vehicleui] hide;show")

  --create drag frame and drag functionality
  if cfg.userplaced.enable then
    rCreateDragFrame(frame, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
  end

  --create the mouseover functionality
  if cfg.mouseover.enable then
    rButtonBarFader(frame, buttonList, cfg.mouseover.fadeIn, cfg.mouseover.fadeOut) --frame, buttonList, fadeIn, fadeOut
	frame.mouseover = cfg.mouseover
  end

  --create the fade on condition functionality
  if cfg.eventfader.enable then
    ActionbarEventFader(frame, buttonList, cfg.eventfader.fadeIn, cfg.eventfader.fadeOut) --frame, fadeIn, fadeOut
	frame.mouseover = cfg.eventfader
  end