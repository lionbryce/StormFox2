-- This is a localization backup, in case the file didn't transferre.
if not file.Exists("resource/localization/en/stormfox.properties", "GAME") then return end
local str = [[
	#StormFox2.weather = weather
	# https://github.com/Facepunch/garrysmod/blob/master/garrysmod/resource/localization/en/community.properties Check this first
	# weather, day, night, sun, lightning, snow, cloud
	
	#Misc
	sf_auto=Auto
	sf_customization=Customization
	sf_window_effects=Window Effects
	footprints=footprints
	temperature=temperature
	
	#Weather
	sf_weather.clear=Clear
	sf_weather.clear.windy=Windy
	sf_weather.cloud=Cloudy
	sf_weather.cloud.thunder=Thunder
	sf_weather.cloud.storm=Storm
	sf_weather.rain=Raining
	sf_weather.rain.sleet=Sleet
	sf_weather.rain.snow=Snowing
	sf_weather.rain.thunder=Thunder
	sf_weather.rain.storm=Storm
	sf_weather.fog.low=Haze
	sf_weather.fog.medium=Fog
	sf_weather.fog.high=Thick Fog
	
	#Settings
	sf_mthreadwarning=These settings can boost your FPS:\n%s\nWarning\: Might crash some older AMD CPUs!
	sf_holdc=Hold C
	sf_weatherpercent=Weather Amount
	sf_setang=Set Angle
	sf_setang.desc=Sets the wind-angle to your view.
	sf_setwind=Sets the windspeed in m/s
	sf_wcontoller=SF Controller
	sf_map.light_environment.check=This map support fast lightchanges.
	sf_map.light_environment.problem=This map will cause lagspikes for clients, when the light changes.
	sf_map.env_wind.none=This map doesn't support windgusts.
	sf_map.logic_relay.check=This map has custome day/night relays.
	sf_map.logic_relay.none=This map doens't have custome day/night relays.
	sf_windmove_players=Affect players
	sf_windmove_players.desc=Affect player movment in strong wind.
	sf_enable_fogz=Overwrite farZ fog
	sf_enable_fogz.desc=Overwrites the maps farZ fog. This might look bad on some maps.
	sf_enable_ice=Enable ice
	sf_enable_ice.desc=Creates ice over water.
	sf_overwrite_fogdistance=Default fog-distance.
	sf_overwrite_fogdistance.desc=Overwrites the default fog-distance.
	
	#Details
	sf_quality_target=FPS Target
	sf_quality_target.desc=Adjusts the quality to reach targeted FPS.
	sf_quality_ultra=Ultra Quality
	sf_quality_ultra.desc=Allows for more effects.
	sf_12h_display=Time Display
	sf_12h_display.disc=Choose 12-hour or 24-hour clock.
	sf_display_temperature=Temperature Units
	sf_display_temperature.desc=Choose a temperature unit.
	sf_use_monthday=Date Display
	sf_use_monthday.disc=Choose MM/DD or DD/MM.
	
	#Wind
	sf_wind=Wind
	sf_winddescription.calm=Calm
	sf_winddescription.light_air=Light Air
	sf_winddescription.light_breeze=Light Breeze
	sf_winddescription.gentle_breeze=Gentle Breeze
	sf_winddescription.moderate_breeze=Moderate Breeze
	sf_winddescription.fresh_breeze=Fresh Breeze
	sf_winddescription.strong_breeze=Strong Breeze
	sf_winddescription.near_gale=Near Gale
	sf_winddescription.gale=Gale
	sf_winddescription.strong_gale=Strong Gale
	sf_winddescription.storm=Storm
	sf_winddescription.violent_storm=Violent Storm
	#Hurricane is also known as Category 1
	sf_winddescription.hurricane=Hurricane
	sf_winddescription.cat2=Category 2
	sf_winddescription.cat3=Category 3
	sf_winddescription.cat4=Category 4
	sf_winddescription.cat5=Category 5
	
	#Time
	sf_real_time=Real time
	sf_real_time.desc=Use the servers OS Time.
	sf_start_time=Start time
	sf_start_time.desc=Sets the start time.
	sf_time_speed=Time speed
	sf_time_speed.desc=Multiplies the in-game seconds with the given number.
	#Sun
	sf_sunrise=SunRise
	sf_sunrise.desc=Sets the time the sun rises.
	sf_sunset=SunSet
	sf_sunset.desc=Sets the time the sun sets.
	sf_sunyaw=SunYaw
	sf_sunyaw.desc=Sets the yaw for the sun.
	#Moon
	sf_moonlock=Moon Lock
	sf_moonlock.desc=Locks the moon to the sun's rotation.
	
	#'Maplight
	sf_maplight_max=Max Maplight
	sf_maplight_max.desc=The max lightlevel. You can adjust this if the map is too bright/dark.
	sf_maplight_min=Min Maplight
	sf_maplight_min.desc=The min lightlevel. You can adjust this if the map is too bright/dark.
	
	sf_maplight_smooth=Maplight Lerp.
	sf_maplight_smooth.desc=Enables smooth light transitions.
	sf_maplight_updaterate=Maplight UpdateRate
	sf_maplight_updaterate.desc=The max amount of times StormFox will update the maplight doing transitions. Will cause lag on large maps!
	sf_extra_lightsupport=Extra Lightsupport
	sf_extra_lightsupport.desc=Utilize engine.LightStyle to change the map-light. This can cause lag-spikes, but required on certain maps.
	
	#Effects
	sf_enable_fog=Enable Fog
	sf_enable_fog.desc=Allow StormFox to edit the fog.
	sf_footprint_enabled=Enable Footprints
	sf_footprint_enabled.desc=Enable footprint effects.
	sf_footprint_playeronly=Player Footprints Only.
	sf_footprint_playeronly.desc=Only players make footprints.
	sf_footprint_distance=Footprint Render Distance
	sf_footprint_distance.desc=Max render distance for footprints.
	sf_footprint_max=Max Footprints
	sf_footprint_max.desc=Max amount of footprints
	
	sf_extra_darkness=Extra Darkness
	sf_extra_darkness.desc=Adds a darkness-filter to make bright maps darker.
	sf_extra_darkness_amount=Extra Darkness Amount
	sf_extra_darkness_amount.desc=Scales the darkness-filter.
	
	sf_overwrite_extra_darkness=Overwrite Extra Darkness
	sf_overwrite_extra_darkness.desc=Overwrites the players sf_extra_darkness.
	sf_footprint_enablelogic=Enables Serverside Footprints
	sf_footprint_enablelogic.desc=Enables server-side footprints.
	
	sf_window_enable=Enable window effects
	sf_window_enable.desc=Enables window weather effects.
	sf_window_distance=Window Render Distance
	sf_window_distance.desc=The render distance for breakable windows.
	
	#Weather
	sf_auto_weather=Auto weather
	sf_auto_weather.desc=Automatically change weather over time.
	sf_max_weathers_prweek=Max Weathers Pr Week
	sf_max_weathers_prweek.desc=Max amount of weathers pr week.
	sf_temp_range=Temperature range
	sf_temp_range.desc=The min and max temperature.
	sf_temp_acc=Temperature change.
	sf_temp_acc.desc=The max temperature changes pr day.	
		]]

for k, v in ipairs( string.Explode("\n", str)) do
	if string.match(v, "%s-#") then continue end
	local a,b = string.match(v, "%s*(.+)=(.+)")
	if not a or not b then continue end
	language.Add(a, b)
end
