
--[[
	Unlike SF1, this doesn't support networking.
	
	Data.Set( sKey, zVar, nDelta )	Sets the data. Supports lerping if given delta.
	Data.Get( sKey, zDefault )		Returns the data. Returns zDefault if nil.
	Data.GetFinal( zKey, zDefault)	Returns the data without calculating the lerp.
	Data.IsLerping( sKey )			Returns true if the data is currently lerping.

	Hooks:
		- stormFox.data.change		sKey	zVar		Called when data changed or started lerping.
		- stormfox.data.lerpstart	sKey	zVar		Called when data started lerping
		- stormfox.data.lerpend		sKey	zVar		Called when data stopped lerping (This will only be called if we check for the variable)
]]
StormFox.Data = {}

StormFox_DATA = {}		-- Var
StormFox_AIMDATA = {} 	-- Var, start, end

--[[TODO: There are still problems with nil varables.

]]

-- Returns the final data. This will never lerp.
function StormFox.Data.GetFinal( sKey, zDefault )
	if StormFox_AIMDATA[sKey] then
		return StormFox_AIMDATA[sKey][1]
	end
	if StormFox_DATA[sKey] ~= nil then
		return StormFox_DATA[sKey]
	end
	return zDefault
end

local lerpCache = {}
do
	local function isColor(t)
		if type(t) ~= "table" then return false end
		return t.r and t.g and t.b and true or false
	end
	local function LerpVar(fraction, from, to)
		local t = type(from)
		if t ~= type(to) then
			StormFox.Warning("Can't lerp " .. type(from) .. " to " .. type(to) .. "!")
			return to
		end
		if t == "number" then
			return Lerp(fraction, from, to)
		elseif t == "string" then
			return fraction > .5 and to or from
		elseif isColor(from) then
			local r = Lerp(fraction, from.r, to.r)
			local g = Lerp(fraction, from.g, to.g)
			local b = Lerp(fraction, from.b, to.b)
			local a = Lerp(fraction, from.a, to.a)
			return Color(r,g,b,a)
		elseif t == "vector" then
			return LerpVector(fraction, from, to)
		elseif t == "angle" then
			return LerpAngle(fraction, from, to)
		elseif t == "boolean" then
			if fraction > .5 then
				return to
			else
				return from
			end
		else
			print("UNKNOWN", t,"TO",to)
		end
	end
	local function calcFraction(start_cur, end_cur)
		local n = CurTime()
		if n >= end_cur then return 1 end
		local d = end_cur - start_cur
		return (n - start_cur) / d
	end

	-- Returns data
	function StormFox.Data.Get( sKey, zDefault )
		-- Check if lerping
		local var1 = StormFox_DATA[sKey]
		if not StormFox_AIMDATA[sKey] then
			if var1 ~= nil then
				return var1
			else
				return zDefault
			end
		end
		-- Check cache and return
		if lerpCache[sKey] ~= nil then return lerpCache[sKey] end
		-- Calc
		local fraction = calcFraction(StormFox_AIMDATA[sKey][2],StormFox_AIMDATA[sKey][3])
		local var2 = StormFox_AIMDATA[sKey][1]
		if fraction <= 0 then
			return var1
		elseif fraction < 1 then
			lerpCache[sKey] = LerpVar( fraction, var1, var2 )
			return lerpCache[sKey] or zDefault
		else -- Fraction end
			StormFox_DATA[sKey] = var2
			StormFox_AIMDATA[sKey] = nil
			hook.Run("stormFox.data.lerpend",sKey,var2)
			return var2 or zDefault
		end
	end
	local n = 0
	-- Reset cache after 4 frames
	hook.Add("Think", "stormfox.resetdatalerp", function()
		n = n + 1
		if n < 4 then return end
		n = 0
		lerpCache = {}
	end)
end

-- Sets data. Will lerp if given delta.
function StormFox.Data.Set( sKey, zVar, nDelta )
	if not zVar then
		StormFox_DATA[sKey] = nil
		StormFox_AIMDATA[sKey] = nil
		return
	end
	-- Delete old cache
	lerpCache[sKey] = nil
	-- Check if vars are the same
	if StormFox_DATA[sKey] ~= nil then
		if StormFox_DATA[sKey] == zVar then return end
	end
	-- If delta is 0 or below. (Or no prev data). Set it.
	if not nDelta or nDelta <= 0 or StormFox_DATA[sKey] == nil then
		StormFox_AIMDATA[sKey] = nil
		StormFox_DATA[sKey] = zVar
		hook.Run("stormfox.data.change",sKey,zVar)
		return
	end
	-- Get the current lerping value and set that as a start
	if StormFox_AIMDATA[sKey] then
		StormFox_DATA[sKey] = StormFox.Data.Get( sKey )
	end
	StormFox_AIMDATA[sKey] = {zVar, CurTime(), CurTime() + nDelta}
	hook.Run("stormFox.data.lerpstart",sKey,zVar, nDelta)
	hook.Run("stormFox.data.change", sKey, zVar, nDelta)
end

function StormFox.Data.IsLerping( sKey )
	if not StormFox_AIMDATA[sKey] then return false end
	-- Check and see if we're done lerping
	local fraction = calcFraction(StormFox_AIMDATA[sKey][2],StormFox_AIMDATA[sKey][3])
	if fraction < 1 then
		return true
	end
	-- We're done lerping.
	StormFox_DATA[sKey] = StormFox.Data.GetFinal( sKey )
	StormFox_AIMDATA[sKey] = nil
	lerpCache[sKey] = nil
	hook.Run("stormFox.data.lerpend",sKey,zVar)
	return true
end