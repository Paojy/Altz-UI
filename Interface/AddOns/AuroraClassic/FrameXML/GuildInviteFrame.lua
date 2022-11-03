local _, ns = ...
local B, C, L, DB = unpack(ns)

tinsert(C.defaultThemes, function()
	B.SetBD(GuildInviteFrame)
	for i = 1, 10 do
		select(i, GuildInviteFrame:GetRegions()):Hide()
	end
	B.Reskin(GuildInviteFrameJoinButton)
	B.Reskin(GuildInviteFrameDeclineButton)
end)