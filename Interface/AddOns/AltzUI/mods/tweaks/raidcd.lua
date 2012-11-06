--original author : Allez
local T, C, L, G = unpack(select(2, ...))
local F = unpack(Aurora)
local dragFrameList = G.dragFrameList

if not aCoreCDB.raidcdenable then return end

local width, height = aCoreCDB.raidcdwidth, aCoreCDB.raidcdheight
local spacing = 3
local fontsize = aCoreCDB.raidcdfontsize
local flag = "OUTLINE"
local texture = "Interface\\AddOns\\AltzUI\\media\\statusbar"

local spells = {
	--[20484] = 600,	-- 复生
	--[61999] = 600,	-- 复活盟友
	--[20707] = 900,	-- 灵魂石复活
	--[6346] = 180,	-- 防护恐惧结界
	--[29166] = 180,	-- 激活
	--[32182] = 300,	-- 英勇
	--[2825] = 300,	-- 嗜血
	--[80353] = 300,	-- 时间扭曲
	--[90355] = 300,	-- 远古狂乱

	--团队免伤技能	
	[97462] = 180,  -- 集结呐喊
	[98008] = 180,  -- 灵魂链接图腾
	[62618] = 180,  -- 真言术: 障
	[51052] = 120,  -- 反魔法领域
	[31821] = 120,  -- 光环掌握
	[64843] = 180,  -- 神圣赞美诗 *
	[740]   = 180,  -- 宁静 *
	[87023] = 60,   --春哥
	[16190] = 180,  --潮汐
	[105763] =120,  --奶萨 2T13
	[105914] =120,  --战士 4T13
	[105739] =180,  --小德 4T13
	[115213] = 180,	-- 慈悲庇护
	
	--[33076] = 10, --愈合祷言
	--[34861] = 10, --治疗之环
}

local show = {
	raid = true,
	party = true,
	arena = true,
}

local filter = COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_MINE
local band = bit.band
local sformat = string.format
local floor = math.floor
local timer = 0

local bars = {}

local anchorframe = CreateFrame("Frame", "Altz_RaidCDanchorframe", UIParent)
anchorframe.movingname = L["RaidCD"]
anchorframe:SetSize(width, 20)
anchorframe:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 180, 170)
T.CreateDragFrame(anchorframe, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp

local UpdatePositions = function()
	for i = 1, #bars do
		bars[i]:ClearAllPoints()
		if i == 1 then
			bars[i]:SetPoint("BOTTOMLEFT", anchorframe, "TOPLEFT", 0, 8)
		else
			bars[i]:SetPoint("BOTTOMLEFT", bars[i-1], "TOPLEFT", 0, spacing)
		end
		bars[i].id = i
	end
end

local StopTimer = function(bar)
	bar:SetScript("OnUpdate", nil)
	bar:Hide()
	tremove(bars, bar.id)
	UpdatePositions()
end

local BarUpdate = function(self, elapsed)
	local curTime = GetTime()
	if self.endTime < curTime then
		StopTimer(self)
		return
	end
	self.status:SetValue(100 - (curTime - self.startTime) / (self.endTime - self.startTime) * 100)
	self.right:SetText(T.FormatTime(self.endTime - curTime))
end

local OnEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddLine(self.spell)
	GameTooltip:SetClampedToScreen(true)
	GameTooltip:Show()
end

local OnLeave = function(self)
	GameTooltip:Hide()
end

local OnMouseDown = function(self, button)
	if button == "LeftButton" then
		SendChatMessage(sformat("Cooldown %s %s: %s", self.left:GetText(), self.spell, self.right:GetText()), "RAID")
	elseif button == "RightButton" then
		StopTimer(self)
	end
end

local CreateBar = function()
	local bar = CreateFrame("Frame", nil, UIParent)
	bar:SetSize(width, height)
	
	bar.icon = CreateFrame("button", nil, bar)
	bar.icon:SetSize(height, height)
	bar.icon:SetPoint("BOTTOMLEFT", 0, 0)
	
	bar.status = CreateFrame("Statusbar", nil, bar)
	bar.status:SetPoint("BOTTOMLEFT", bar.icon, "BOTTOMRIGHT", 5, 0)
	bar.status:SetPoint("BOTTOMRIGHT", 0, 0)
	bar.status:SetHeight(height)
	bar.status:SetStatusBarTexture(texture)
	bar.status:SetMinMaxValues(0, 100)
	bar.status:SetFrameLevel(bar:GetFrameLevel()-1)	
	
	bar.left = T.createtext(bar, "OVERLAY", fontsize, flag, "LEFT")
	bar.left:SetPoint('LEFT', bar.status, 2, 1)
	
	bar.right = T.createtext(bar, "OVERLAY", fontsize, flag, "RIGHT")
	bar.right:SetPoint('RIGHT', bar.status, -2, 1)
	
	F.CreateSD(bar.icon, 4, 0, 0, 0, 1, -2)
	F.CreateBD(bar.icon, 0.5)
	F.CreateSD(bar.status, 4, 0, 0, 0, 1, -2)
	F.CreateBD(bar.status, 0.5)
	return bar
end

local StartTimer = function(name, spellId)
	local spell, rank, icon = GetSpellInfo(spellId)
	for _, v in pairs(bars) do
		if v.name == name and v.spell == spell then
			return
		end
	end
	
	local bar = CreateBar()
	bar.endTime = GetTime() + spells[spellId]
	bar.startTime = GetTime()
	bar.left:SetText(name)
	bar.name = name
	bar.right:SetText(T.FormatTime(spells[spellId]))
	bar.spell = spell

	if icon and bar.icon then
		bar.icon:SetNormalTexture(icon)
		bar.icon:GetNormalTexture():SetTexCoord(0.07, 0.93, 0.07, 0.93)
	end
	
	bar:Show()
	
	local color = G.Ccolors[select(2, UnitClass(name))]
	bar.status:SetStatusBarColor(color.r, color.g, color.b)
	
	bar:EnableMouse(true)

	bar:SetScript("OnEnter", OnEnter)
	bar:SetScript("OnLeave", OnLeave)
	bar:SetScript("OnMouseDown", OnMouseDown)
	bar:SetScript("OnUpdate", BarUpdate)

	tinsert(bars, bar)
	UpdatePositions()
end

local OnEvent = function(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local timestamp, eventType, _, sourceGUID, sourceName, sourceFlags = ...
		if band(sourceFlags, filter) == 0 then return end
		if eventType == "SPELL_RESURRECT" or eventType == "SPELL_CAST_SUCCESS" or eventType == "SPELL_AURA_APPLIED" then
			local spellId = select(12, ...)
			if spells[spellId] and show[select(2, IsInInstance())] then
				StartTimer(sourceName, spellId)
			end
		end
	elseif event == "ZONE_CHANGED_NEW_AREA" and select(2, IsInInstance()) == "arena" then
		for k, v in pairs(bars) do
			StopTimer(v)
		end
	end
end

local eventf = CreateFrame("frame")
eventf:SetScript('OnEvent', OnEvent)
eventf:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
eventf:RegisterEvent("ZONE_CHANGED_NEW_AREA")

anchorframe.dragFrame:SetScript('OnShow', function()
	StartTimer(UnitName('player'), 97462)
	StartTimer(UnitName('player'), 98008)
	StartTimer(UnitName('player'), 51052)
end)