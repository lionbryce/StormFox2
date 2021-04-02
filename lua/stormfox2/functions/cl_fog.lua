--[[-------------------------------------------------------------------------
Use the map-data to set a minimum and maximum fogdistance
---------------------------------------------------------------------------]]
StormFox.Setting.AddCL("enable_fog",true)
StormFox.Setting.AddSV("enable_fogz",false,nil, "Effect")
StormFox.Fog = {}
--[[TODO: There are still problems with the fog looking strange.


	Notes:
		- Source only support kFogLinear fog.
		- Source supports negative fog .. but not realy?
		- Depth-render requires; render.view, RT and skyboxes cause problems

		Ideas:
		. Make fog max at 0.9 and insert a dome in the back?
			- Add fog takes the avg color around the area, https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/Dense_Seattle_Fog.jpg/1200px-Dense_Seattle_Fog.jpg 

		- EndMeter = fDen * fDen * fDen ... == 1
]]

local _fS, _fE, _fD = 0,400000,1
local function fogStart( f )
	_fS = f
end
local function fogEnd( f )
	_fE = f
end
local function fogDensity( f )
	_fD = f
end
local function getFogStart()
	return math.max(0, _fS)
end
local function getFogEnd()
	if _fS >= 0 then
		return _fE
	end
	return _fE 
end
local function getFogFill()
	if _fS >= 0 then return 0 end
	return -_fS / (_fE - _fS) * _fD * 0.1
end

-- Can't make the fog linear .. the variables are just far too sensitive for changes. 
local e = 2.71828
local function fogCalc(b, a, p)
	if a == b then return a end
	p = e^(-8.40871*p)
	local d = b - a
	return a + d * p
end

local max_Dist, inf_Dist = 6000, false
-- Fog distance shouldn't be linear mix
local clearFogDist = StormFox.Weather.Get("Clear"):Get('fogDistance') or 400000
local clearFogDistIndoor = StormFox.Weather.Get("Clear"):Get('fogIndoorDistance') or 3000
hook.Add("Think", "StormFox.Fog.Updater", function()
	local cW = StormFox.Weather.GetCurrent()
	local aim_dist = clearFogDist
	local inD = clearFogDistIndoor
	if cW ~= clear then
		local wP =  StormFox.Weather.GetProcent()
		if wP ~= 0 then
			if wP == 1 then
				aim_dist = cW:Get('fogDistance') or 400000
				inD = cW:Get('fogIndoorDistance') or 3000
			else
				aim_dist = fogCalc(clearFogDist, cW:Get('fogDistance') or 400000,wP)
				inD = fogCalc(clearFogDistIndoor, cW:Get('fogIndoorDistance') or 3000,wP)
			end
		end
	end

	local env = StormFox.Environment.Get()
	--if _fE == aim_dist then return end
	if not env.outside then
		local inD = StormFox.Mixer.Get("fogIndoorDistance",3000)
		if not env.nearest_outside then
			aim_dist = math.max(inD, aim_dist)
		else
			local dis = StormFox.util.RenderPos():Distance(env.nearest_outside) * 40
			aim_dist =  math.max(math.min(dis, inD), aim_dist)
		end
	end
	_fE = math.Approach(_fE, math.min(aim_dist, StormFox.Fog.GetFarZ()), math.max(10, _fE) * FrameTime())
	if _fE > 3000 then
		_fS = 0
	else
		_fS = _fE - 3000
	end
end)

local f_Col = color_white
local SkyFog = function(scale)
	if _fD <= 0 then return end
	if not scale then scale = 1 end
	if not StormFox.Setting.GetCache("enable_fog",true) then return end
	f_Col = StormFox.Mixer.Get("fogColor", StormFox.Mixer.Get("bottomColor",color_white) )
	-- Apply fog
	local tD = StormFox.Thunder.GetLight() / 2055
	render.FogMode( 1 )
	render.FogStart( getFogStart() * scale )
	render.FogEnd( getFogEnd() * scale )
	render.FogMaxDensity( _fD - tD )
	render.FogColor( f_Col.r,f_Col.g,f_Col.b )
	return true
end
hook.Add("SetupSkyboxFog","StormFox.Sky.Fog",SkyFog)
hook.Add("SetupWorldFog","StormFox.Sky.WorldFog",SkyFog)

function StormFox.Fog.GetAmount()
	return 1 - _fE / max_Dist
end

for k, v in ipairs( StormFox.Map.FindClass('env_fog_controller') ) do
	inf_Dist = inf_Dist or v.farz < 0
	max_Dist = math.max(max_Dist, v.farz)
end

local m_fog = Material('stormfox2/effects/fog_sphere')
local l_fogz = 0
hook.Add("StormFox.2DSkybox.FogLayer", "StormFox.Fog.RSky", function( v )
	local y = math.rad( EyeAngles().y )
	local v = Vector(math.cos( y ), math.sin( y ), 0)
	local dis = StormFox.Environment.Get().z_distance or 16000
	render.SetMaterial( m_fog ) -- If you use Material, cache it!
	m_fog:SetVector("$color", Vector(f_Col.r,f_Col.g,f_Col.b) / 255)
	m_fog:SetFloat("$alpha", 1 or math.Clamp(5000 / _fE, 0, 1))
	local tH = math.min(StormFox.Environment.GetZHeight(), 2100)
	if tH ~= l_fogz then
		local delta = math.abs(l_fogz, tH) / 2
		l_fogz = math.Approach( l_fogz, tH, math.max(delta, 10) * 5 * FrameTime() )
	end
	--local p = Vector(0,0,-1000) + v * 8000
	--render.DrawQuadEasy( p, -v, 2000, 50000, Color(f_Col.r,f_Col.g,f_Col.b,255), 90)
	local h = 2000 + 6000 * StormFox.Fog.GetAmount()
	render.DrawSphere( Vector(0,0,h - l_fogz * 4) , -300000, 30, 30, color_white)
end)

local mat = Material("color")
local v1 = Vector(1,1,1)
hook.Add("PostDrawOpaqueRenderables", "StormFox.Sky.FogPDE", function()
	if _fS >= 0 or _fD <= 0 then return end
	local a = getFogFill()
	mat:SetVector("$color",Vector(f_Col.r,f_Col.g,f_Col.b) / 255)
	mat:SetFloat("$alpha",a)
	render.SetMaterial(mat)
	render.DrawScreenQuad()
	mat:SetVector("$color",v1)
	mat:SetFloat("$alpha",1)
end)

function StormFox.Fog.GetFarZ()
	local n_Dis = StormFox.Data.GetFinal("fogDistance", max_Dist + 700)
	if inf_Dist then return n_Dis end
	return math.min(max_Dist, n_Dis + 700)
end

function StormFox.Fog.GetColor()
	return f_Col or color_white
end

function StormFox.Fog.GetDistance()
	return _fE or max_Dist
end