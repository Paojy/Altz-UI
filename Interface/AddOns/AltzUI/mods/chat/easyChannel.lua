local T, C, L, G = unpack(select(2, ...))

local wantws = true
--ChatTypeInfo["WHISPER"].sticky= 0
function ChatEdit_CustomTabPressed(self)
	if strsub(tostring(self:GetText()), 1, 1) == "/" then return end
	local name = self:GetAttribute("tellTarget")
	local chattype = self:GetAttribute("chatType")
	local channel = self:GetAttribute("channelTarget")	
	local header = _G[self:GetName().."Header"]
	
	if  (chattype == "SAY")  then
		if name then
			--print("target",name)
			if BNet_GetBNetIDAccount(name) then
				--print("bn")
				self:SetAttribute("chatType", "BN_WHISPER")
				header:SetFormattedText(CHAT_BN_WHISPER_SEND, name)
			else
				--print("ws")
				self:SetAttribute("chatType", "WHISPER")
				header:SetFormattedText(CHAT_WHISPER_SEND, name)
			end
		elseif IsInInstance() and HasLFGRestrictions() then
			self:SetAttribute("chatType", "INSTANCE_CHAT")
			ChatEdit_UpdateHeader(self)
		elseif IsInRaid() then
			self:SetAttribute("chatType", "RAID")
			ChatEdit_UpdateHeader(self)
		elseif IsInGroup() then
			self:SetAttribute("chatType", "PARTY")
			ChatEdit_UpdateHeader(self)
		elseif IsInGuild() then
			self:SetAttribute("chatType", "GUILD")
			ChatEdit_UpdateHeader(self)
		elseif GetChannelName(2) == 2 then
			self:SetAttribute("channelTarget", 2)
			self:SetAttribute("chatType", "CHANNEL")
			ChatEdit_UpdateHeader(self)
		elseif GetChannelName(1) == 1 then
			self:SetAttribute("channelTarget", 1)
			self:SetAttribute("chatType", "CHANNEL")
			ChatEdit_UpdateHeader(self)
		else
			return
		end
	elseif (chattype == "BN_WHISPER") or (chattype == "WHISPER") then
		if IsInInstance() and HasLFGRestrictions() then
			self:SetAttribute("chatType", "INSTANCE_CHAT")
			ChatEdit_UpdateHeader(self)
		elseif IsInRaid() then
			self:SetAttribute("chatType", "RAID")
			ChatEdit_UpdateHeader(self)
		elseif IsInGroup() then
			self:SetAttribute("chatType", "PARTY")
			ChatEdit_UpdateHeader(self)
		elseif IsInGuild() then
			self:SetAttribute("chatType", "GUILD")
			ChatEdit_UpdateHeader(self)
		elseif GetChannelName(2) == 2 then
			self:SetAttribute("channelTarget", 2)
			self:SetAttribute("chatType", "CHANNEL")
			ChatEdit_UpdateHeader(self)
		elseif GetChannelName(1) == 1 then
			self:SetAttribute("channelTarget", 1)
			self:SetAttribute("chatType", "CHANNEL")
			ChatEdit_UpdateHeader(self)
		else
			self:SetAttribute("chatType", "SAY")
			ChatEdit_UpdateHeader(self)
		end		
	elseif (chattype == "INSTANCE_CHAT") then
		if IsInRaid() then
			self:SetAttribute("chatType", "RAID")
			ChatEdit_UpdateHeader(self)
		elseif IsInGroup() then
			self:SetAttribute("chatType", "PARTY")
			ChatEdit_UpdateHeader(self)
		elseif IsInGuild() then
			self:SetAttribute("chatType", "GUILD")
			ChatEdit_UpdateHeader(self)
		elseif GetChannelName(2) == 2 then
			self:SetAttribute("channelTarget", 2)
			self:SetAttribute("chatType", "CHANNEL")
			ChatEdit_UpdateHeader(self)
		elseif GetChannelName(1) == 1 then
			self:SetAttribute("channelTarget", 1)
			self:SetAttribute("chatType", "CHANNEL")
			ChatEdit_UpdateHeader(self)
		else
			self:SetAttribute("chatType", "SAY")
			ChatEdit_UpdateHeader(self)
		end			
	elseif (chattype == "RAID") then
		if IsInGroup() then
			self:SetAttribute("chatType", "PARTY")
			ChatEdit_UpdateHeader(self)
		elseif IsInGuild() then
			self:SetAttribute("chatType", "GUILD")
			ChatEdit_UpdateHeader(self)
		elseif GetChannelName(2) == 2 then
			self:SetAttribute("channelTarget", 2)
			self:SetAttribute("chatType", "CHANNEL")
			ChatEdit_UpdateHeader(self)
		elseif GetChannelName(1) == 1 then
			self:SetAttribute("channelTarget", 1)
			self:SetAttribute("chatType", "CHANNEL")
			ChatEdit_UpdateHeader(self)
		else
			self:SetAttribute("chatType", "SAY")
			ChatEdit_UpdateHeader(self)
		end
	elseif (chattype == "PARTY") then
		if IsInGuild() then
			self:SetAttribute("chatType", "GUILD")
			ChatEdit_UpdateHeader(self)
		elseif GetChannelName(2) == 2 then
			self:SetAttribute("channelTarget", 2)
			self:SetAttribute("chatType", "CHANNEL")
			ChatEdit_UpdateHeader(self)
		elseif GetChannelName(1) == 1 then
			self:SetAttribute("channelTarget", 1)
			self:SetAttribute("chatType", "CHANNEL")
			ChatEdit_UpdateHeader(self)
		else
			self:SetAttribute("chatType", "SAY")
			ChatEdit_UpdateHeader(self)
		end
	elseif (chattype == "GUILD") then
		if GetChannelName(2) == 2 then
			self:SetAttribute("channelTarget", 2)
			self:SetAttribute("chatType", "CHANNEL")
			ChatEdit_UpdateHeader(self)
		elseif GetChannelName(1) == 1 then
			self:SetAttribute("channelTarget", 1)
			self:SetAttribute("chatType", "CHANNEL")
			ChatEdit_UpdateHeader(self)
		else
			self:SetAttribute("chatType", "SAY")
			ChatEdit_UpdateHeader(self)
		end
	elseif (chattype == "CHANNEL") and channel == 2 then
		if GetChannelName(1) == 1 then
			self:SetAttribute("channelTarget", 1)
			self:SetAttribute("chatType", "CHANNEL")
			ChatEdit_UpdateHeader(self)
		else
			self:SetAttribute("chatType", "SAY")
			ChatEdit_UpdateHeader(self)
		end
	elseif (chattype == "CHANNEL") and channel == 1 then
		self:SetAttribute("chatType", "SAY")
		ChatEdit_UpdateHeader(self)
	end
end