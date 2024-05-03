local T, C, L, G = unpack(select(2, ...))

local handlers = {}
local running = {}
local scrolldowns = {}
local delay = 15  -- Change this value if you want a different delay between your last scroll
                  -- and the time the frame resets.  This value is in seconds.
				  
local frame = CreateFrame("Frame")
frame:Hide()
frame:SetScript("OnUpdate", function (frame, elapsed)   
    if not aCoreCDB["ChatOptions"]["autoscroll"] then return end
	for name,v in pairs(handlers) do      
        if running[name] then
            v.elapsed = v.elapsed + elapsed
            if v.elapsed >= v.rate then
	            v.func(unpack(v))            
 	            v.elapsed = 0  
	     	end      
        end 
    end
end)

local function Register(name, func, rate, ...)
    handlers[name] = {
		name = name,
		func = func,
		rate = rate or 0,
		...
	}
end

local function Start(name)   
    handlers[name].elapsed = 0   
    running[name] = true   
    frame:Show()
end

local function Stop(name)   
    running[name] = nil   
    if not next(running) then
		frame:Hide()
	end
end
	  
local function ResetFrame(name, frame)   
    Stop(name.."DownTimeout")   
    Start(name.."DownTick")
end

local function ScrollOnce(name, frame)
	if frame:AtBottom() then
		Stop(name.."DownTick")
	else 
		scrolldowns[name](frame)
	end
end

local funcs = {"ScrollUp", "ScrollDown", "ScrollToTop", "PageUp", "PageDown"}

for i = 1, NUM_CHAT_WINDOWS do
	local name = 'ChatFrame'..i 
	local frame = _G[name]  
	scrolldowns[name] = frame.ScrollDown   
	Register(name.."DownTick", ScrollOnce, 0, name, frame)   
	Register(name.."DownTimeout", ResetFrame, delay, name, frame)
    for _,func in ipairs(funcs) do      
        local orig = frame[func]      
        frame[func] = function(...)         
            Stop(name.."DownTick")         
            Start(name.."DownTimeout", 1)         
            orig(...)      
        end   
    end 
end

function FloatingChatFrame_OnMouseScroll(self, delta)
	if ( delta > 0 ) then
		if IsModifierKeyDown() then
			self:ScrollToTop()
		else
			self:ScrollUp()
		end
	else
		if IsModifierKeyDown() then
			self:ScrollToBottom()
		else
			self:ScrollDown()
		end
	end
end