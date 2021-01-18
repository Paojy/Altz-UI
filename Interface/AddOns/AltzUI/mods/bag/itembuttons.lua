local T, C, L, G = unpack(select(2, ...))

if not aCoreCDB["ItemOptions"]["itembuttons"] then return true end

local icon_size = aCoreCDB["ItemOptions"]["itembuttons_size"]
local font_size = aCoreCDB["ItemOptions"]["itembuttons_fsize"]
local num = aCoreCDB["ItemOptions"]["number_perline"]
local space = aCoreCDB["ItemOptions"]["button_space"]
local growdirection_v = aCoreCDB["ItemOptions"]["growdirection_v"]
local growdirection_h = aCoreCDB["ItemOptions"]["growdirection_h"]
local update_lock

local IB_Frame = CreateFrame("Frame", G.uiname.."IB_Frame", UIParent)
IB_Frame:SetSize(icon_size, icon_size)
IB_Frame.movingname = L["便捷物品按钮"]
IB_Frame.point = {
	healer = {a1 = "BOTTOMLEFT", parent = "Minimap", a2 = "TOPLEFT", x = 0, y = 5},
	dpser = {a1 = "BOTTOMLEFT", parent = "Minimap", a2 = "TOPLEFT", x = 0, y = 5},
}
T.CreateDragFrame(IB_Frame)

local IB_Buttons = {}

local function Lineup_IB()
	if not InCombatLockdown() and not update_lock then
	
		update_lock = true
		C_Timer.After(1, function() update_lock = false end)
		
		table.sort(IB_Buttons, function(a,b) return a.ind < b.ind end)
		
		local index = 0
		
		for i = 1, #IB_Buttons do
			local Button = IB_Buttons[i]
			if Button and Button:IsShown() then
				Button:ClearAllPoints()
				if growdirection_v == "UP" then
					if growdirection_h == "RIGHT" then
						Button:SetPoint("BOTTOMLEFT", IB_Frame, "BOTTOMLEFT", (index%num)*(icon_size+space), (floor(index/num))*(icon_size+space))
					else
						Button:SetPoint("BOTTOMRIGHT", IB_Frame,"BOTTOMRIGHT", -(index%num)*(icon_size+space), (floor(index/num))*(icon_size+space))
					end
				else
					if growdirection_h == "RIGHT" then
						Button:SetPoint("TOPLEFT", IB_Frame, "TOPLEFT", (index%num)*(icon_size+space), -(floor(index/num))*(icon_size+space))
					else
						Button:SetPoint("TOPRIGHT", IB_Frame, "TOPRIGHT", -(index%num)*(icon_size+space), -(floor(index/num))*(icon_size+space))
					end
				end
				
				index = index + 1
			end
		end
	end
end

local function Create_IB(ItemID, index, exactItem, showCount, All, OrderHall, Raid, Dungeon, PVP)
	local bu = CreateFrame("Button", G.uiname.."IB"..index, IB_Frame, "SecureActionButtonTemplate")
	bu:SetSize(icon_size, icon_size)

	T.CreateSD(bu, 3, 0, 0, 0, 0, -2)
	
	bu.ind = index
	
	local texture = bu:CreateTexture(nil,"HIGH")
	texture:SetPoint("TOPLEFT", bu, "TOPLEFT")
	texture:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT")
	texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	bu.icon = texture

	bu.text = T.createnumber(bu, "ARTWORK", font_size, "OUTLINE", "RIGHT")
	bu.text:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -1, 1)

	table.insert(IB_Buttons, bu)
end

local updateTime = {}

local function Update_IB(bagID)
	
	if InCombatLockdown() or G.bag_sorting then return end
	
	for k, bu in pairs(IB_Buttons) do
		local orderhall = false -- C_Garrison.IsPlayerInGarrison(LE_GARRISON_TYPE_7_0)
		local instanceType = select(2, GetInstanceInfo())
		
		local hasitem = false
		local info = aCoreCDB["ItemOptions"]["itembuttons_table"][bu.ind]
		
		if info.All or (info.OrderHall and orderhall) or (info.Raid and instanceType == "raid") or (info.Dungeon and instanceType == "party") or (info.PVP and instanceType == "pvp") then
			
			if bagID then
				
				if (not updateTime[bagID]) or (GetTime() - updateTime[bagID] > 1) then
					
					for slot = 1, GetContainerNumSlots(bagID) do
					
						local itemID = GetContainerItemID(bagID, slot)            
						local itemSpell = GetItemSpell(itemID)
						
						if (itemID == info.itemID) or (not info.exactItem and itemSpell and itemSpell == GetItemSpell(info.itemID)) then
						
							local icon = GetItemIcon(itemID)                
							bu.icon:SetTexture(icon)              
							
							if info.showCount then
								bu.text:SetText(GetItemCount(itemID))
							else
								bu.text:SetText("")
							end
							
							bu:Show()
							if GetMouseFocus() == bu then
								GameTooltip:SetBagItem(bagID, slot)
							end
							bu:SetAttribute("type", "item")                
							bu:SetAttribute("item", "item:"..itemID)               
							
							bu:SetScript("OnEnter", function()
								GameTooltip:SetOwner(bu, "ANCHOR_TOPRIGHT")	
								GameTooltip:SetBagItem(bagID, slot)
								GameTooltip:Show()
							end)
							bu:SetScript("OnLeave", function()
								GameTooltip:Hide()
							end)
							
							hasitem = true
							
							updateTime[bagID] = GetTime()
						end
						
					end
					
				end				
			else
				for bag = 0, NUM_BAG_SLOTS do
					if (not updateTime[bagID]) or (GetTime() - updateTime[bagID] > 1) then
					
						for slot = 1, GetContainerNumSlots(bag) do
						
							local itemID = GetContainerItemID(bag, slot)            
							local itemSpell = GetItemSpell(itemID)
							
							if (itemID == info.itemID) or (not info.exactItem and itemSpell and itemSpell == GetItemSpell(info.itemID)) then
							
								local icon = GetItemIcon(itemID)                
								bu.icon:SetTexture(icon)              
								
								if info.showCount then
									bu.text:SetText(GetItemCount(itemID))
								else
									bu.text:SetText("")
								end
								
								bu:Show()
								if GetMouseFocus() == bu then
									GameTooltip:SetBagItem(bag, slot)
								end
								bu:SetAttribute("type", "item")                
								bu:SetAttribute("item", "item:"..itemID)               
								
								bu:SetScript("OnEnter", function()
									GameTooltip:SetOwner(bu, "ANCHOR_TOPRIGHT")	
									GameTooltip:SetBagItem(bag, slot)
									GameTooltip:Show()
								end)
								bu:SetScript("OnLeave", function()
									GameTooltip:Hide()
								end)
								
								hasitem = true
								
								updateTime[bag] = GetTime()
							end
							
						end
					
					end
				end
			end
			
		end	

		if not hasitem then			
			bu:SetAttribute("type", nil)
			bu:SetAttribute("item", nil) 
			bu:Hide()
		end
		
	end
	
	Lineup_IB()
end

T.Update_IB = Update_IB

IB_Frame:RegisterEvent("PLAYER_REGEN_ENABLED")
IB_Frame:RegisterEvent("PLAYER_REGEN_DISABLED")
IB_Frame:RegisterEvent("ADDON_LOADED")
IB_Frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
IB_Frame:RegisterEvent("BAG_UPDATE")

IB_Frame:SetScript("OnEvent", function(self, event, arg1)
	if event == "PLAYER_REGEN_ENABLED" then
		IB_Frame:Show()
	elseif event == "PLAYER_REGEN_DISABLED" then
		IB_Frame:Hide()
	elseif event == "ADDON_LOADED" then
		if arg1 == "AltzUI" then
			for index, info in pairs(aCoreCDB["ItemOptions"]["itembuttons_table"]) do
				Create_IB(info.itemID, index, info.exactItem, info.showCount, info.All, info.OrderHall, info.Raid, info.Dungeon, info.PVP)
			end
			Update_IB()
		end
	else
		Update_IB(arg1)
	end
end)
