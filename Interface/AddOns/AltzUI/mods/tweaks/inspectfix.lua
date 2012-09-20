InspectFix = CreateFrame("Button", "InspectFixHiddenFrame", UIParent)
local addonName = "InspectFix"
local revision = tonumber(("$Revision: 26 $"):match("%d+"))

local BlizzardNotifyInspect = _G.NotifyInspect
local InspectPaperDollFrame_SetLevel = nil
local InspectPaperDollFrame_OnShow = nil
local InspectGuildFrame_Update = nil
local loaded = false
local debugging = false

local function debug(msg)
  if debugging then
     DEFAULT_CHAT_FRAME:AddMessage("\124cFFFF0000"..addonName.."\124r: "..msg)
  end
end

local lastunit
local function unitchange(self)
  local unit = self.unit
  if loaded and unit and unit ~= lastunit then
    lastunit = unit
    BlizzardNotifyInspect(unit)
    InspectFrame_UnitChanged(InspectFrame)
  end
end

local function inspectfilter(self, event, ...) 
  --myprint(event,...)
  if loaded then
    -- ignore an inspect target disappearance or change to non-player - ie, keep the window open
    if (event == "PLAYER_TARGET_CHANGED" or event == nil) and
       self.unit == "target" and
       (not UnitExists("target") or not UnitIsPlayer("target")) then
      return false
    end
  end
  return true
end
local function inspectonevent(self, event, ...)
  if inspectfilter(self, event, ...) then
    InspectFrame_OnEvent(self, event, ...)
    InspectFix:Update()
  end
end
local function inspectonupdate(self)
  if inspectfilter(self, nil) then
    InspectFrame_OnUpdate(self)
    InspectFix:Update()
  end
end

-- cache the inspect contents in case we lose our target (so GameTooltip:SetInventoryItem() no longer works)
local scantt = CreateFrame("GameTooltip", "InspectFix_Tooltip", UIParent, "GameTooltipTemplate")
scantt:SetOwner(UIParent, "ANCHOR_NONE");
local inspect_item = {}
local inspect_unit = nil
local function pdfupdate(self)
  if loaded then
    local id = self:GetID()
    local unit = InspectFrame.unit
    if unit and id then
      local link = GetInventoryItemLink(unit, id)
      inspect_unit = unit
      inspect_item[id] = link

      scantt:SetOwner(UIParent, "ANCHOR_NONE");
      scantt:SetInventoryItem(unit, id)
      local _, scanlink = scantt:GetItem()
      if scanlink and scanlink ~= link then
        inspect_item[id] = scanlink
        debug("Updating "..(link or "nil").." to "..scanlink)
      end
      --if debugging then printlink(id.." "..(link or "nil")) end
    end
  end
end
local function pdfonenter(self)
  if loaded then
    local id = self:GetID()
    if id and inspect_item[id] and inspect_unit == InspectFrame.unit and
       GameTooltip:IsVisible() then
      if GameTooltip:NumLines() == 1 then -- fill in a bogus inspect result
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        GameTooltip:SetHyperlink(inspect_item[id])
      else
        local name,link = GameTooltip:GetItem()
	if link and link ~= inspect_item[id] then
	  debug("Updating "..(inspect_item[id] or "nil").." to "..link)
          inspect_item[id] = link
	end
      end
      --if debugging then printlink(id.." "..inspect_item[id]) end
    end
  end
end

function InspectFix:GetID() return self.val end
InspectFix.val = INVSLOT_FIRST_EQUIPPED
function InspectFix:Update() 
 for slot = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
   InspectFix.val = slot
   pdfupdate(InspectFix)
 end
end


local blockmsg = {}

-- prevent NotifyInspect interference from other addons
local function NIhook(unit)
  InspectFix:tryhook()
  if loaded and (not unit or not CanInspect(unit)) then
    debug("Blocked a bogus NotifyInspect("..(unit or "nil")..")")
    return
  end
  local ifvis = InspectFrame and InspectFrame:IsVisible()
  local exvis = Examiner and Examiner:IsVisible()
  if loaded and (ifvis or exvis) then
    local str = debugstack(2)
    --print(str)
    local addon = string.match(str,'[%s%c]+([^:%s%c]*)\\[^\\:%s%c]+:')
    addon = string.gsub(addon or "unknown",'I?n?t?e?r?f?a?c?e\\AddOns\\',"")
    if not string.find(str,ifvis and "Blizzard_InspectUI" or "Examiner") then
      blockmsg[addon] = blockmsg[addon] or {}
      local count = (blockmsg[addon].count or 0) + 1
      blockmsg[addon].count = count
      local now = GetTime()
      if not blockmsg[addon].lastwarn or (now - blockmsg[addon].lastwarn > 30) then -- throttle warnings
        --print("InspectFix blocked a conflicting inspect request from "..addon.." ("..count.." occurences)")
	debug(str)
        blockmsg[addon].lastwarn = now
      end
      return
    end
  end
  BlizzardNotifyInspect(unit)
end

-- prevent a lua error bug in pdf
local function pdffilter(context)
  if not loaded then
    return true
  elseif InspectFrame and InspectFrame.unit and CanInspect(InspectFrame.unit) then
    return true
  else
    debug(context.."_hook blocked a potential lua error")
    return false
  end
end
local function setlevel_hook()
  if pdffilter("setlevel") then
    return InspectPaperDollFrame_SetLevel()
  end
end

local function pdfshow_hook()
  if pdffilter("pdfshow") then
    return InspectPaperDollFrame_OnShow()
  end
end

local function guildframe_hook()
  if pdffilter("guildframe") then
    return InspectGuildFrame_Update()
  end
end

local hookcnt = 0
local hooked = {}
function InspectFix:tryhook()
  if false and not hooked[unitchange] and InspectFrame_UnitChanged then
    hooksecurefunc("InspectFrame_UnitChanged", unitchange)
    hooked[unitchange] = true
  end

  if _G.NotifyInspect and _G.NotifyInspect ~= NIhook then
    if not hooked["notifyinspect"] then
      BlizzardNotifyInspect = _G.NotifyInspect
      _G.NotifyInspect = NIhook
      hookcnt = hookcnt + 1
      hooked["notifyinspect"] = true
      debug("Hooked notifyinspect")
    else
      debug("NotifyInspect hooked by another addon")
    end
  end

  if _G.InspectFrame_OnEvent and InspectFrame:GetScript("OnEvent") ~= inspectonevent then
    InspectFrame:SetScript("OnEvent", inspectonevent)
    if not hooked[inspectonevent] then
      hookcnt = hookcnt + 1
      hooked[inspectonevent] = true
      debug("Hooked inspectonevent")
    else
      debug("Re-Hooked inspectonevent")
    end
  end

  if _G.InspectFrame_OnUpdate and InspectFrame:GetScript("OnUpdate") ~= inspectonupdate then
    InspectFrame:SetScript("OnUpdate", inspectonupdate)
    if not hooked[inspectonupdate] then
      hookcnt = hookcnt + 1
      hooked[inspectonupdate] = true
      debug("Hooked inspectonupdate")
    else
      debug("Re-Hooked inspectonupdate")
    end
  end

  if _G.InspectPaperDollFrame_SetLevel and _G.InspectPaperDollFrame_SetLevel ~= setlevel_hook then
    if not hooked[setlevel_hook] then
      InspectPaperDollFrame_SetLevel = _G.InspectPaperDollFrame_SetLevel
      _G.InspectPaperDollFrame_SetLevel = setlevel_hook
      hooked[setlevel_hook] = true
      hookcnt = hookcnt + 1
      debug("Hooked setlevel_hook")
    else
      debug("InspectPaperDollFrame_SetLevel hooked by another addon")
    end
  end

  if _G.InspectGuildFrame_Update and _G.InspectGuildFrame_Update ~= guildframe_hook then
    if not hooked[guildframe_hook] then
      InspectGuildFrame_Update = _G.InspectGuildFrame_Update
      _G.InspectGuildFrame_Update = guildframe_hook
      hooked[guildframe_hook] = true
      hookcnt = hookcnt + 1
      debug("Hooked guildframe_hook")
    else
      debug("InspectGuildFrame_Update hooked by another addon")
    end
  end

  if _G.InspectPaperDollFrame_OnShow and _G.InspectPaperDollFrame_OnShow ~= pdfshow_hook then
    InspectPaperDollFrame:SetScript("OnShow", pdfshow_hook)
    if not hooked[pdfshow_hook] then
      InspectPaperDollFrame_OnShow = _G.InspectPaperDollFrame_OnShow
      _G.InspectPaperDollFrame_OnShow = pdfshow_hook
      hooked[pdfshow_hook] = true
      hookcnt = hookcnt + 1
      debug("Hooked pdfshow_hook")
    else
      debug("Re-Hooked pdfshow_hook")
    end
  end

  if not hooked[pdfupdate] and InspectPaperDollItemSlotButton_Update and InspectPaperDollItemSlotButton_OnEnter then
    hooksecurefunc("InspectPaperDollItemSlotButton_Update", pdfupdate)
    hooksecurefunc("InspectPaperDollItemSlotButton_OnEnter", pdfonenter)
    hookcnt = hookcnt + 1
    hooked[pdfupdate] = true
    debug("Hooked pdfupdate")
  end

  if hookcnt == 7 then
    hookcnt = hookcnt + 1
    --print("InspectFix hook activated.")
  end
end
function InspectFix_OnEvent(self, event)
  if event == "ADDON_LOADED" then
    InspectFix:tryhook()
  end
end
InspectFix:SetScript("OnEvent", InspectFix_OnEvent)
InspectFix:RegisterEvent("ADDON_LOADED")

function InspectFix:Load()
  InspectFix:tryhook()
  loaded = true
  local revstr 
  revstr = GetAddOnMetadata("InspectFix", "X-Curse-Packaged-Version")
  if not revstr then
  revstr = GetAddOnMetadata("InspectFix", "Version")
  end
  if not revstr or string.find(revstr, "@") then
    revstr = "r"..tostring(revision)
  end
  --print("InspectFix "..revstr.." loaded.")
end

function InspectFix:Unload()
  loaded = false
  --print("InspectFix unloaded.")
end

InspectFix:Load()

SLASH_INSPECTFIX1 = "/inspectfix"
SLASH_INSPECTFIX2 = "/if"
SlashCmdList["INSPECTFIX"] = function(msg)
        local cmd = msg:lower()
        if cmd == "load" or cmd == "on" or cmd == "ver" then
          InspectFix:Load()
        elseif cmd == "unload" or cmd == "off" then
          InspectFix:Unload()
        elseif cmd == "debug" then
          debugging = not debugging
	  print("InspectFix debugging "..(debugging and "enabled" or "disabled"))
        else
          print("/inspectfix [ on | off | debug ]")
        end
end
