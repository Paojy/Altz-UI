local T, C, L, G = unpack(select(2, ...))

ChatTypeInfo["WHISPER"].sticky= 0
function ChatEdit_CustomTabPressed(self)
	if strsub(tostring(self:GetText()), 1, 1) == "/" then return end

	if  (self:GetAttribute("chatType") == "SAY")  then
		if (select(2, GetInstanceInfo()) == 'pvp') then
			self:SetAttribute("chatType", "BATTLEGROUND");
			ChatEdit_UpdateHeader(self);
		elseif IsInRaid() then
			self:SetAttribute("chatType", "RAID");
			ChatEdit_UpdateHeader(self);
		elseif IsInGroup() then
			self:SetAttribute("chatType", "PARTY");
			ChatEdit_UpdateHeader(self);
		elseif IsInGuild() then
			self:SetAttribute("chatType", "GUILD");
			ChatEdit_UpdateHeader(self);
		else
			return;
		end
	elseif (self:GetAttribute("chatType") == "BATTLEGROUND") then
		if IsInRaid() then
			self:SetAttribute("chatType", "RAID");
			ChatEdit_UpdateHeader(self);
		elseif IsInGroup() then
			self:SetAttribute("chatType", "PARTY");
			ChatEdit_UpdateHeader(self);
		elseif IsInGuild() then
			self:SetAttribute("chatType", "GUILD");
			ChatEdit_UpdateHeader(self)
		else
			self:SetAttribute("chatType", "SAY");
			ChatEdit_UpdateHeader(self);
		end			
	elseif (self:GetAttribute("chatType") == "RAID") then
		if IsInGroup() then
			self:SetAttribute("chatType", "PARTY");
			ChatEdit_UpdateHeader(self);
		elseif IsInGuild() then
			self:SetAttribute("chatType", "GUILD");
			ChatEdit_UpdateHeader(self)
		else
			self:SetAttribute("chatType", "SAY");
			ChatEdit_UpdateHeader(self);
		end
	elseif (self:GetAttribute("chatType") == "PARTY") then
		if IsInGuild() then
			self:SetAttribute("chatType", "GUILD");
			ChatEdit_UpdateHeader(self)
		else
			self:SetAttribute("chatType", "SAY");
			ChatEdit_UpdateHeader(self);
		end
	elseif (self:GetAttribute("chatType") == "GUILD") then
		self:SetAttribute("chatType", "SAY");
		ChatEdit_UpdateHeader(self);
	end
end