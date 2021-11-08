local _, ns = ...
local F, C = unpack(ns)

local function reskinPanelSection(frame)
	F.StripTextures(frame)
	F.CreateBDFrame(frame, .25)
	_G[frame:GetName().."Title"]:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 5, 2)
end

tinsert(C.defaultThemes, function()
	local styledOptions = false

	VideoOptionsFrame:HookScript("OnShow", function()
		if styledOptions then return end

		F.StripTextures(VideoOptionsFrameCategoryFrame)
		F.StripTextures(VideoOptionsFramePanelContainer)
		F.StripTextures(VideoOptionsFrame.Header)
		VideoOptionsFrame.Header:ClearAllPoints()
		VideoOptionsFrame.Header:SetPoint("TOP", VideoOptionsFrame, 0, 0)

		F.SetBD(VideoOptionsFrame)
		VideoOptionsFrame.Border:Hide()
		F.Reskin(VideoOptionsFrameOkay)
		F.Reskin(VideoOptionsFrameCancel)
		F.Reskin(VideoOptionsFrameDefaults)
		F.Reskin(VideoOptionsFrameApply)

		local line = VideoOptionsFrame:CreateTexture(nil, "ARTWORK")
		line:SetSize(C.mult, 512)
		line:SetPoint("LEFT", 205, 30)
		line:SetColorTexture(1, 1, 1, .25)

		Display_:HideBackdrop()
		Graphics_:HideBackdrop()
		RaidGraphics_:HideBackdrop()
		GraphicsButton:DisableDrawLayer("BACKGROUND")
		RaidButton:DisableDrawLayer("BACKGROUND")

		reskinPanelSection(AudioOptionsSoundPanelPlayback)
		reskinPanelSection(AudioOptionsSoundPanelHardware)
		reskinPanelSection(AudioOptionsSoundPanelVolume)

		local hline = Display_:CreateTexture(nil, "ARTWORK")
		hline:SetSize(580, C.mult)
		hline:SetPoint("TOPLEFT", GraphicsButton, "BOTTOMLEFT", 14, -4)
		hline:SetColorTexture(1, 1, 1, .2)

		local videoPanels = {
			"Display_",
			"Graphics_",
			"RaidGraphics_",
			"Advanced_",
			"NetworkOptionsPanel",
			"InterfaceOptionsLanguagesPanel",
			"AudioOptionsSoundPanel",
			"AudioOptionsVoicePanel",
		}
		for _, name in pairs(videoPanels) do
			local frame = _G[name]
			if frame then
				for i = 1, frame:GetNumChildren() do
					local child = select(i, frame:GetChildren())
					if child:IsObjectType("CheckButton") then
						F.ReskinCheck(child)
					elseif child:IsObjectType("Button") then
						F.Reskin(child)
					elseif child:IsObjectType("Slider") then
						F.ReskinSlider(child)
					elseif child:IsObjectType("Frame") and child.Left and child.Middle and child.Right then
						F.ReskinDropDown(child)
					end
				end
			end
		end

		local testInputDevie = AudioOptionsVoicePanelTestInputDevice
		F.Reskin(testInputDevie.ToggleTest)
		F.StripTextures(testInputDevie.VUMeter)
		testInputDevie.VUMeter.Status:SetStatusBarTexture(C.bdTex)
		local bg = F.CreateBDFrame(testInputDevie.VUMeter, .3)
		bg:SetInside(nil, 4, 4)

		styledOptions = true
	end)

	hooksecurefunc("AudioOptionsVoicePanel_InitializeCommunicationModeUI", function(self)
		if not self.styled then
			F.Reskin(self.PushToTalkKeybindButton)
			self.styled = true
		end
	end)
end)