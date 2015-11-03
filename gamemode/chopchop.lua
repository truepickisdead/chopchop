function chopchop:ConMsg( text )
	print("[#] " .. text)
end

function chopchop:Start()
	chopchop:ConMsg("Gamemode initialized.")

	chopchop:ConMsg("")
	chopchop:ConMsg("|============================================================|")
	chopchop:ConMsg("| MESSAGES PREFIXED BY '[#]' ARE SENT FROM CHOPCHOP GAMEMODE |")
	chopchop:ConMsg("|============================================================|")
	chopchop:ConMsg("")


	translate = {}
	chopchop:LoadLanguage( chopchop.settings.language )
	chopchop:LoadFiles()
	if SERVER then
		chopchop:CheckDirectories()
		chopchop:LoadAdminPlugins()
	end

end

function chopchop:LoadFiles()
	-- greetings
	chopchop:ConMsg("")
	chopchop:ConMsg( translate.core.loadFilesStart .. ":" )

	local base_folder = GM.FolderName.."/gamemode/"
	local fls, flds

	-- load server files
	if SERVER then
		chopchop:ConMsg("|")
		chopchop:ConMsg("|-> " .. translate.core.loadFilesServer .. ":")

		fls, flds = file.Find( base_folder .. "server/*.lua", "LUA" )
		for k, fl in ipairs( fls ) do
			include( "server/" .. fl )
			chopchop:ConMsg("| " .. fl)
		end
	end

	-- load client files
	chopchop:ConMsg("|")
	chopchop:ConMsg("|-> " .. translate.core.loadFilesClient .. ":")

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

	-- load shared files
	chopchop:ConMsg("|")
	chopchop:ConMsg("|-> " .. translate.core.loadFilesShared .. ":")

	fls, flds = file.Find( base_folder .. "shared/*.lua", "LUA" )
	for k, fl in ipairs( fls ) do
		if SERVER then AddCSLuaFile( "shared/" .. fl ) end
		include( "shared/" .. fl )
		chopchop:ConMsg("| " .. fl)
	end

	-- outro
	chopchop:ConMsg("|")
	chopchop:ConMsg( translate.core.loadFilesFinish )
end

function chopchop:LoadLanguage( name )
	local languages = {}

	-- get languages list and send it to clients
	fls, flds = file.Find( GM.FolderName .. "/gamemode/lang/*.lua", "LUA" )
	for k, fl in ipairs( fls ) do
		if SERVER then AddCSLuaFile( "lang/" .. fl ) end
		languages[ string.Left( fl, string.find( fl, ".lua" ) - 1 ) ] = true
	end

	-- failsafe: if language not found, select 'eng'
	if !languages[ name ] then
		chopchop:ConMsg( "ERROR: Language '" .. name .. "' not found" )
		name = "eng"
	end 

	include( "lang/" .. name .. ".lua" )
	chopchop:ConMsg( "Language is set to '" .. name .. "'." )
	chopchop:ConMsg( translate.welcome )
end

function chopchop:CheckDirectories()
	chopchop:ConMsg("")
	chopchop:ConMsg( translate.core.checkingData .. "..." )

	if !file.CheckFolder("chopchop", "DATA") then
		chopchop:ConMsg( "| " .. translate.core.checkingDataFirstTime .. "..." )
	end

	chopchop:ConMsg( translate.core.checkingDataOK )
end