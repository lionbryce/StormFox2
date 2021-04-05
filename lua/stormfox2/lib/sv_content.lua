
-- Adds SF content
if not StormFox.WorkShopVersion then
	local i = 0
	local function AddDir(dir,dirlen)
		if not dirlen then dirlen = dir:len() end
		local files, folders = file.Find(dir .. "/*", "GAME")
		for _, fdir in ipairs(folders) do
			if fdir ~= ".svn" then
				AddDir(dir .. "/" .. fdir)
			end
		end
		for k, v in ipairs(files) do
			local fil = dir .. "/" .. v
			resource.AddFile(fil)
			i = i + 1
		end
	end
	AddDir("materials/stormfox2")
	AddDir("sound/stormfox2")
	AddDir("models/stormfox2")
	StormFox.Msg("Added " .. i .. " content files.")
-- Add the workshop
else
	resource.AddWorkshop(string.match(StormFox.WorkShopURL, "%d+$"))
	StormFox.Msg("Added content files from workshop.")
end