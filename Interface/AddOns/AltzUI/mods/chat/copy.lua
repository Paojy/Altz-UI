local T, C, L, G = unpack(select(2, ...))
if not aCoreCDB["ChatOptions"]["copychat"] then return end

local _AddMessage = ChatFrame1.AddMessage 
local _SetItemRef = SetItemRef 
local blacklist = { 
   [ChatFrame2] = true, 
} 

local ts = G.classcolor..'|HyCopy|h%s|h|r %s' 
local AddMessage = function(self, text, ...) 
   if(type(text) == 'string') then 
        if showtime then 
          text = format(ts, date'%H:%M', text)  --text = format(ts, date'%H:%M:%S', text) 
        else 
     text = format(ts, '> ', text) 
       end 
end 

   return _AddMessage(self, text, ...) 
end 

for i=1, NUM_CHAT_WINDOWS do 
   local cf = _G['ChatFrame'..i] 
   if(not blacklist[cf]) then 
      cf.AddMessage = AddMessage 
   end 
end 

local MouseIsOver = function(frame) 
   local s = frame:GetParent():GetEffectiveScale() 
   local x, y = GetCursorPosition() 
   x = x / s 
   y = y / s 

   local left = frame:GetLeft() 
   local right = frame:GetRight() 
   local top = frame:GetTop() 
   local bottom = frame:GetBottom() 

   if(not left) then 
      return 
   end 

   if((x > left and x < right) and (y > bottom and y < top)) then 
      return 1 
   else 
      return 
   end 
end 

local borderManipulation = function(...) 
   for l = 1, select('#', ...) do 
      local obj = select(l, ...) 
      if(obj:GetObjectType() == 'FontString' and MouseIsOver(obj)) then 
         local text = obj:GetText()
		 return string.sub(text, 27)
      end 
   end 
end 

local eb = ChatFrame1EditBox 
SetItemRef = function(link, text, button, ...) 
   if(link:sub(1, 5) ~= 'yCopy') then return _SetItemRef(link, text, button, ...) end 

   local text = borderManipulation(SELECTED_CHAT_FRAME.FontStringContainer:GetRegions())
   if(text) then 
      text = text:gsub('|c%x%x%x%x%x%x%x%x(.-)|r', '%1') 
      text = text:gsub('|H.-|h(.-)|h', '%1') 

      eb:Insert(text) 
      eb:Show() 
      eb:HighlightText() 
      eb:SetFocus() 
   end 
end