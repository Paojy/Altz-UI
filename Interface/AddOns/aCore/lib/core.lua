ShortValue = function(v)
	if v >= 1e6 then
		return ("%.1fm"):format(v / 1e6):gsub("%.?0+([km])$", "%1")
	elseif v >= 1e3 or v <= -1e3 then
		return ("%.1fk"):format(v / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return v
	end
end

FormatTime = function(time)
	if time >= 60 then
		return string.format('%.2d:%.2d', floor(time / 60), time % 60)
	else
		return string.format('%.2d', time)
	end
end