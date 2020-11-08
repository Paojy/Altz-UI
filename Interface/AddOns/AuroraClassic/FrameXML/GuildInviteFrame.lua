local _, ns = ...
local F, C = unpack(ns)

tinsert(C.defaultThemes, function()

	F.SetBD(GuildInviteFrame)
	for i = 1, 10 do
		select(i, GuildInviteFrame:GetRegions()):Hide()
	end
	F.Reskin(GuildInviteFrameJoinButton)
	F.Reskin(GuildInviteFrameDeclineButton)
end)