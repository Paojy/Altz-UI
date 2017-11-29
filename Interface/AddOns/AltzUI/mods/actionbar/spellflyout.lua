local T, C, L, G = unpack(select(2, ...))

--spell flyout fader
--this one is tricky...when hovering a bar with mouveover fading you want the bar to stay when leaving the bar but hovering the flyoutframe
--thus on loadup of the flyout frame the fader has to adept to the current flyout button

local function addFlyoutFramesToFader(self)
	--print(self:GetParent():GetParent():GetParent():GetName())
	local fade, minalpha = false, 0
	local frame = self:GetParent():GetParent():GetParent()
	local fname = frame:GetName()
	if fname == "Altz_Bar1&2" then
		fade = aCoreCDB["ActionbarOptions"]["bar12mfade"] or aCoreCDB["ActionbarOptions"]["bar12efade"]
		minalpha = aCoreCDB["ActionbarOptions"]["bar12fademinaplha"]
	elseif fname == "Altz_Bar3" then
		fade = aCoreCDB["ActionbarOptions"]["bar3mfade"] or aCoreCDB["ActionbarOptions"]["bar3efade"]
		minalpha = aCoreCDB["ActionbarOptions"]["bar3fademinaplha"]
	elseif fname == "Altz_Bar4&5" then
		fade = aCoreCDB["ActionbarOptions"]["bar45mfade"] or aCoreCDB["ActionbarOptions"]["bar45efade"]
		minalpha = aCoreCDB["ActionbarOptions"]["bar45fademinaplha"]
	end
	
	if fade and minalpha then
		local NUM_FLYOUT_BUTTONS = 10
		local buttonList = {}
		local fadeIn = {time = 0.4, alpha = 1}
		local fadeOut = {time = 1.5, alpha = minalpha}
		for i = 1, NUM_FLYOUT_BUTTONS do
			local button = _G["SpellFlyoutButton"..i]
			if button then
				table.insert(buttonList, button) --add the button object to the list
			end
		end
		T.SpellFlyoutFader(frame, buttonList, fadeIn, fadeOut)
	end
end

SpellFlyout:HookScript("OnShow", addFlyoutFramesToFader)