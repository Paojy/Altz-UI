Mod_AddonSkins = CreateFrame("Frame")
local Mod_AddonSkins = Mod_AddonSkins

local font = GameFontHighlight:GetFont()

function Mod_AddonSkins:SkinBackgroundFrame(frame)
	createskinpxBD(frame)
	createskingrowBD(frame)
end

function Mod_AddonSkins:SkinBackgroundFrame11(frame) -- without pxborder
	createskingrowBD(frame)
end

function Mod_AddonSkins:SkinButton(button)
	createskinpxBD(frame)
	createskingrowBD(frame)
end

function Mod_AddonSkins:SkinActionButton(button)
	if not button then return end
	self:SkinButton(button)
	local name = button:GetName()
	button.count = button.count or _G[name.."Count"]
	if button.count then
		button.count:SetFont(self.font,self.fontSize,self.fontFlags)
		button.count:SetDrawLayer("OVERLAY")
	end
	button.hotkey = button.hotkey or _G[name.."HotKey"]
	if button.hotkey then
		button.hotkey:SetFont(self.font,self.fontSize,self.fontFlags)
		button.hotkey:SetDrawLayer("OVERLAY")
	end
	button.icon = button.icon or _G[name.."Icon"]
	if button.icon then
		button.icon:SetTexCoord(unpack(self.buttonZoom))
		button.icon:SetDrawLayer("ARTWORK",-1)
		button.icon:ClearAllPoints()
		button.icon:SetPoint("TOPLEFT",button,"TOPLEFT",self.borderWidth, -self.borderWidth)
		button.icon:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-self.borderWidth, self.borderWidth)
	end
	button.textName = button.textName or _G[name.."Name"]
	if button.textName then
		button.textName:SetAlpha(0)
	end
	button.cd = button.cd or _G[name.."Cooldown"]
end
Mod_AddonSkins.barTexture = "Interface\\AddOns\\aCore\\media\\statusbar"
Mod_AddonSkins.bgTexture = "Interface\\AddOns\\aCore\\media\\statusbar"
Mod_AddonSkins.font = font
Mod_AddonSkins.smallFont = font
Mod_AddonSkins.fontSize = 10
Mod_AddonSkins.buttonSize = 27
Mod_AddonSkins.buttonSpacing = 4
Mod_AddonSkins.borderWidth = 2
Mod_AddonSkins.buttonZoom = {.08,.92,.08,.92}
Mod_AddonSkins.barSpacing = 1
Mod_AddonSkins.barHeight = 20
Mod_AddonSkins.skins = {}
Mod_AddonSkins.__index = Mod_AddonSkins
local CustomSkin = setmetatable(CustomSkin or {},Mod_AddonSkins)
if not CustomSkin.PositionSexyCooldownBar then
	function CustomSkin:PositionSexyCooldownBar(bar)
		if bar.settings.bar.name == "actionbar" then
			self:SCDStripLayoutSettings(bar)
			bar.settings.bar.inactiveAlpha = 1
			bar:SetHeight(self.buttonSize)
			bar:SetWidth(ActionBarBackground:GetWidth() - 2 * self.buttonSpacing)
			bar:SetPoint("TOPLEFT",ActionBarBackground,"TOPLEFT",self.buttonSpacing,-self.buttonSpacing)
			bar:SetPoint("TOPRIGHT",ActionBarBackground,"TOPRIGHT",-self.buttonSpacing,-self.buttonSpacing)
			if not ActionBarBackground.resized then
				ActionBarBackground:SetHeight(ActionBarBackground:GetHeight() + self.buttonSize + self.buttonSpacing)
				InvActionBarBackground:SetHeight(ActionBarBackground:GetHeight())
				ActionBarBackground.resized = true
			end
		elseif bar.settings.bar.name == "infoleft" then
			self:SCDStripLayoutSettings(bar)
			bar.settings.bar.inactiveAlpha = 0
			bar:SetAllPoints(dataleftp)
		elseif bar.settings.bar.name == "inforight" then
			self:SCDStripLayoutSettings(bar)
			bar.settings.bar.inactiveAlpha = 0
			bar:SetAllPoints(datarightp)
		end
	end
end
function dummy() end
function Mod_AddonSkins:RegisterSkin(name, initFunc)
	self = Mod_AddonSkins 
	if type(initFunc) ~= "function" then error("initFunc must be a function!",2) end
	self.skins[name] = initFunc
	if name == "LibSharedMedia" then 
		initFunc(self, CustomSkin, self, CustomSkin, CustomSkin)
		self.skins[name] = nil
	end
end
Mod_AddonSkins:RegisterEvent("PLAYER_LOGIN")
Mod_AddonSkins:SetScript("OnEvent",function(self)
	self:UnregisterEvent("PLAYER_LOGIN")
	self:SetScript("OnEvent",nil)
	for name, func in pairs(self.skins) do
		func(self,CustomSkin,self,CustomSkin,CustomSkin)
	end
end)
