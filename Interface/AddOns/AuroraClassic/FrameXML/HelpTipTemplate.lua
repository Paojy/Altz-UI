local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local function reskinAlertFrame(frame)
		if not frame.styled then
			if frame.OkayButton then F.Reskin(frame.OkayButton) end
			if frame.CloseButton then F.ReskinClose(frame.CloseButton) end

			frame.styled = true
		end
	end

	local microButtons = {
		CharacterMicroButtonAlert,
		TalentMicroButtonAlert,
		CollectionsMicroButtonAlert,
		LFDMicroButtonAlert,
		EJMicroButtonAlert,
		StoreMicroButtonAlert,
		GuildMicroButtonAlert,
		ZoneAbilityButtonAlert,
	}

	for _, frame in pairs(microButtons) do
		reskinAlertFrame(frame)
	end

	hooksecurefunc(HelpTip, "Show", function(self)
		for frame in self.framePool:EnumerateActive() do
			reskinAlertFrame(frame)
		end
	end)
end)