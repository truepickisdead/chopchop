function chopchop:ConMsg( text )
	print("[chopchop] " .. text)
end

function chopchop:Start()
	chopchop:ConMsg("Gamemode initialized.")

	chopchop:LoadFiles()
	if SERVER then
		chopchop:CheckDirectories()
	end
end

function chopchop:LoadFiles()
	-- greetings
	chopchop:ConMsg("")
	chopchop:ConMsg("Started loading files...")

	local base_folder = GM.FolderName.."/gamemode/"
	local fls, flds
	local flcount = 0

	-- load server files
	if SERVER then
		chopchop:ConMsg("|")
		chopchop:ConMsg("|-> Included server files:")

		fls, flds = file.Find( base_folder .. "server/*.lua", "LUA" )
		for k, fl in ipairs( fls ) do
			include( "server/" .. fl )
			chopchop:ConMsg("| " .. fl)
		end
		flcount = flcount + #fls
	end

	-- load client files
	chopchop:ConMsg("|")
	chopchop:ConMsg("|-> Included client files:")

	fls, flds = file.Find( base_folder .. "client/*.lua", "LUA" )
	for k, fl in ipairs( fls ) do
		if SERVER then
			AddCSLuaFile( "client/" .. fl )
			chopchop:ConMsg( "| " .. fl )
		elseif CLIENT then
			include( "client/" .. fl )
			chopchop:ConMsg( "| " .. fl )
		end
	end
	flcount = flcount + #fls

	-- load shared files
	chopchop:ConMsg("|")
	chopchop:ConMsg("|-> Included shared files:")

	fls, flds = file.Find( base_folder .. "shared/*.lua", "LUA" )
	for k, fl in ipairs( fls ) do
		if SERVER then AddCSLuaFile( "shared/" .. fl ) end
		include( "shared/" .. fl )
		chopchop:ConMsg("| " .. fl)
	end
	flcount = flcount + #fls

	-- outro
	chopchop:ConMsg("Total " .. flcount .. " files found")
end

function chopchop:CheckDirectories()
	chopchop:ConMsg("")
	chopchop:ConMsg("Checking data...")

	if !file.CheckFolder("chopchop", "DATA") then
		chopchop:ConMsg("| ChopChop was launched first time. Creating data folders...")
	end

	chopchop:ConMsg("Folders are OK")
end