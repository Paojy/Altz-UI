local F, C = unpack(select(2, ...))

tinsert(C.themes["Aurora"], function()
	local frame = LossOfControlFrame
	frame.RedLineTop:SetTexture(nil)
	frame.RedLineBottom:SetTexture(nil)
	frame.blackBg:SetTexture(nil)
	
	frame.Icon:SetTexCoord(.1, .9, .1, .9)
	F.CreateBG(frame.Icon)
end)