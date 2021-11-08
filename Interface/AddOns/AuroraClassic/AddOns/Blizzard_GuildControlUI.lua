local _, ns = ...
local F, C = unpack(ns)

local function updateGuildRanks()
	for i = 1, GuildControlGetNumRanks() do
		local rank = _G["GuildControlUIRankOrderFrameRank"..i]
		if not rank.styled then
			rank.upButton.icon:Hide()
			rank.downButton.icon:Hide()
			rank.deleteButton.icon:Hide()

			F.ReskinArrow(rank.upButton, "up")
			F.ReskinArrow(rank.downButton, "down")
			F.ReskinClose(rank.deleteButton)
			F.ReskinInput(rank.nameBox, 20)

			rank.styled = true
		end
	end
end

C.themes["Blizzard_GuildControlUI"] = function()
	local r, g, b = C.r, C.g, C.b

	F.SetBD(GuildControlUI)

	for i = 1, 9 do
		select(i, GuildControlUI:GetRegions()):Hide()
	end

	for i = 1, 8 do
		select(i, GuildControlUIRankBankFrameInset:GetRegions()):Hide()
	end

	GuildControlUIRankSettingsFrameOfficerBg:SetAlpha(0)
	GuildControlUIRankSettingsFrameRosterBg:SetAlpha(0)
	GuildControlUIRankSettingsFrameBankBg:SetAlpha(0)
	GuildControlUITopBg:Hide()
	GuildControlUIHbar:Hide()
	GuildControlUIRankBankFrameInsetScrollFrameTop:SetAlpha(0)
	GuildControlUIRankBankFrameInsetScrollFrameBottom:SetAlpha(0)

	-- Guild ranks
	local f = CreateFrame("Frame")
	f:RegisterEvent("GUILD_RANKS_UPDATE")
	f:SetScript("OnEvent", updateGuildRanks)
	hooksecurefunc("GuildControlUI_RankOrder_Update", updateGuildRanks)

	-- Guild tabs
	local checkboxes = {"viewCB", "depositCB"}
	hooksecurefunc("GuildControlUI_BankTabPermissions_Update", function()
		for i = 1, GetNumGuildBankTabs() + 1 do
			local tab = "GuildControlBankTab"..i
			local bu = _G[tab]
			if bu and not bu.styled then
				local ownedTab = bu.owned

				_G[tab.."Bg"]:Hide()
				F.ReskinIcon(ownedTab.tabIcon)
				F.CreateBDFrame(bu, .25)
				F.Reskin(bu.buy.button)
				F.ReskinInput(ownedTab.editBox)

				for _, name in pairs(checkboxes) do
					local box = ownedTab[name]
					box:SetNormalTexture("")
					box:SetPushedTexture("")
					box:SetHighlightTexture(C.bdTex)

					local check = box:GetCheckedTexture()
					check:SetDesaturated(true)
					check:SetVertexColor(r, g, b)

					local bg = F.CreateBDFrame(box, 0, true)
					bg:SetInside(box, 4, 4)

					local hl = box:GetHighlightTexture()
					hl:SetInside(bg)
					hl:SetVertexColor(r, g, b, .25)
				end

				bu.styled = true
			end
		end
	end)

	F.ReskinCheck(GuildControlUIRankSettingsFrameOfficerCheckbox)
	for i = 1, 20 do
		local checbox = _G["GuildControlUIRankSettingsFrameCheckbox"..i]
		if checbox then
			F.ReskinCheck(checbox)
		end
	end

	F.Reskin(GuildControlUIRankOrderFrameNewButton)
	F.ReskinClose(GuildControlUICloseButton)
	F.ReskinScroll(GuildControlUIRankBankFrameInsetScrollFrameScrollBar)
	F.ReskinDropDown(GuildControlUINavigationDropDown)
	F.ReskinDropDown(GuildControlUIRankSettingsFrameRankDropDown)
	F.ReskinDropDown(GuildControlUIRankBankFrameRankDropDown)
	F.ReskinInput(GuildControlUIRankSettingsFrameGoldBox, 20)
end