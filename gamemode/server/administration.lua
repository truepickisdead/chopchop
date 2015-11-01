chopchop.admin = {}

function chopchop:LoadAdminPlugins()
	chopchop.admin.plugins = {}
	local msg = "Loaded admin plugins: "
	
	local fls, flds = file.Find( GM.FolderName .. "/gamemode/server/administration/*.lua", "LUA" )
	for k, fl in ipairs( fls ) do
		local prefix = string.Left( fl, string.find( fl, "_" ) - 1 )
		CC_PLUGIN = {}

		-- if file is shared or client-side, send and include on clients
		if prefix == "sh" or prefix == "cl" then
			chopchop:sendAndInclude( "server/administration/" .. fl )
		end
		include( "server/administration/" .. fl )
		chopchop.admin.plugins[ CC_PLUGIN.Name ] = CC_PLUGIN

		msg = msg .. CC_PLUGIN.Name .. " (" .. fl .. ")" .. (k != #fls and ", " or "")
	end
	chopchop:ConMsg( msg )
end

function chopchop.admin.checkCmd( sender, text )
	local args = string.Explode(" ", text)
	local cmd = string.sub(args[1], 2)
	table.remove(args, 1)

	local pluginExists = false
	local pluginName
	for k,v in pairs(chopchop.admin.plugins) do
		for k2,v2 in pairs( v.Commands ) do
			if v2 == cmd then
				pluginExists = true
				pluginName = v.Name
			end
		end
	end

	if pluginExists then
		chopchop:ConMsg(
			sender:Nick() .. " ran command " .. cmd .. " with arguments " .. "{" .. string.Implode( ", ", args ) .. "}"
		)

		chopchop.admin.plugins[ pluginName ].Execute( cmd, sender, args )
	else
		chopchop.chat:Send(
			sender,
			chopchop.settings.colors.chatMsgError, 'This command does not exist!'
		)
		return false
	end

	return true
end
