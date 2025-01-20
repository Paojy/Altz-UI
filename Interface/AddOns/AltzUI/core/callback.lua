local T, C, L, G = unpack(select(2, ...))

----------------------------------------------------------
---------------[[        Callbacks        ]]--------------
----------------------------------------------------------

do
	local callbacks = {}

	function fireEvent(event, ...)
		if not callbacks[event] then return end
		for _, v in ipairs(callbacks[event]) do
		    securecall(v, event, ...)
		end
	end

	T.FireEvent = function(event, ...)
		fireEvent(event, ...)
	end

	T.IsCallbackRegistered = function (event, f)
		if not event or type(f) ~= "function" then
			error("Usage: IsCallbackRegistered(event, callbackFunc)", 2)
		end
		if not callbacks[event] then return end
		for i = 1, #callbacks[event] do
			if callbacks[event][i] == f then return true end
		end
		return false
	end

	T.RegisterCallback = function(event, f)
		if not event or type(f) ~= "function" then
			error("Usage: T.RegisterCallback(event, callbackFunc)", 2)
		end
		callbacks[event] = callbacks[event] or {}
		tinsert(callbacks[event], f)
		return #callbacks[event]
	end

	T.UnregisterCallback = function(event, f)
		if not event or not callbacks[event] then return end
		if f then
			if type(f) ~= "function" then
				error("Usage: T.UnregisterCallback(event, callbackFunc)", 2)
			end
			--> checking from the end to start and not stoping after found one result in case of a func being twice registered.
			for i = #callbacks[event], 1, -1 do
				if callbacks[event][i] == f then
					tremove(callbacks[event], i)
				end
			end
		else
			error("Usage: T.UnregisterCallback(event, callbackFunc)", 2)
		end
	end
end

----------------------------------------------------------
----------------------[[    API    ]]---------------------
----------------------------------------------------------

local CallbackEvents = {
	
}

T.RegisterEventAndCallbacks = function(frame, events)
	if events then
		for event, units in pairs(events) do
			if CallbackEvents[event] then
				if not frame.OnEventAndCallback then
					local func = frame:GetScript("OnEvent")
					frame.OnEventAndCallback = function(...)
						func(frame, ...)
					end
				end
				if not frame.CallbackRegisted then
					frame.CallbackRegisted = {}
				end
				if not frame.CallbackRegisted[event] then
					T.RegisterCallback(event, frame.OnEventAndCallback)
					frame.CallbackRegisted[event] = true
				end
			else
				if type(units) == "table" then
					frame:RegisterUnitEvent(event, unpack(units))
				else
					frame:RegisterEvent(event)
				end
			end
		end
	end
end

T.UnregisterEventAndCallbacks = function(frame, events)
	if events then
		for event in pairs(events) do
			if CallbackEvents[event] then
				if frame.OnEventAndCallback and frame.CallbackRegisted and frame.CallbackRegisted[event] then
					T.UnregisterCallback(event, frame.OnEventAndCallback)
					frame.CallbackRegisted[event] = nil
				end
			else
				frame:UnregisterEvent(event)
			end
		end
	end
end

