
  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...
  local dragFrameList = ns.dragFrameList

  local buttonssize = aCoreCDB.bar45size
  local buttonspace = aCoreCDB.bar45space
  local padding = 4
  local mouseover       = {
        enable          = aCoreCDB.bar45mfade,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 0.4, alpha = aCoreCDB.bar45fademinaplha},
		}
  local eventfader      = {
        enable          = aCoreCDB.bar45efade,
        fadeIn          = {time = 0.4, alpha = 1},
        fadeOut         = {time = 1.5, alpha = aCoreCDB.bar45fademinaplha},
        }
  -----------------------------
  -- FUNCTIONS
  -----------------------------

  local num = NUM_ACTIONBAR_BUTTONS
  local buttonList = {}

  --create the frame to hold the buttons
  local frame = CreateFrame("Frame", "rABS_MultiBarRight", UIParent, "SecureHandlerStateTemplate")
  frame:SetWidth(2*buttonssize + (2-1)*buttonspace + 2*padding)
  frame:SetHeight(num*buttonssize + (num-1)*buttonspace + 2*padding)
  frame:SetPoint("RIGHT", UIParent, "RIGHT", -6, 0)
  
  --move the buttons into position and reparent them
  MultiBarRight:SetParent(frame)
  MultiBarRight:EnableMouse(false)
  MultiBarLeft:SetParent(frame)
  MultiBarLeft:EnableMouse(false)

  for i=1, num do
    local button = _G["MultiBarRightButton"..i]
    table.insert(buttonList, button) --add the button object to the list
    button:SetSize(buttonssize, buttonssize)
    button:ClearAllPoints()
    if i == 1 then
      button:SetPoint("TOPRIGHT", frame, -padding, -padding)
    else
      local previous = _G["MultiBarRightButton"..i-1]
      button:SetPoint("TOP", previous, "BOTTOM", 0, -buttonspace)
    end
  end

  for i=1, num do
    local button = _G["MultiBarLeftButton"..i]
    table.insert(buttonList, button) --add the button object to the list
    button:SetSize(buttonssize, buttonssize)
    button:ClearAllPoints()
    if i == 1 then
        button:SetPoint("TOPRIGHT", frame, -(padding+buttonspace+buttonssize), -padding)
    else
      local previous = _G["MultiBarLeftButton"..i-1]
      button:SetPoint("TOP", previous, "BOTTOM", 0, -buttonspace)
    end
  end

  --hide the frame when in a vehicle!
  RegisterStateDriver(frame, "visibility", "[petbattle][overridebar][vehicleui] hide; show")

  --create drag frame and drag functionality
  rCreateDragFrame(frame, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp

  --create the mouseover functionality
  if mouseover.enable then
    ActionbarFader(frame, buttonList, mouseover.fadeIn, mouseover.fadeOut) --frame, buttonList, fadeIn, fadeOut
	frame.mouseover = mouseover
  end

  --create the fade on condition functionality
  if eventfader.enable then
    ActionbarEventFader(frame, buttonList, eventfader.fadeIn, eventfader.fadeOut) --frame, fadeIn, fadeOut
	frame.mouseover = eventfader
  end