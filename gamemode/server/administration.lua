chopchop.admin = {}

function chopchop:LoadAdminPlugins()
	chopchop.admin.plugins = {}
	translate.plugins = {}
	local msg = translate.core.adminLoadPlugins .. ": "
	
	-- search for plugins
	local fls, flds = file.Find( GM.FolderName .. "/gamemode/server/administration/*.lua", "LUA" )
	for k, fl in ipairs( fls ) do
		local prefix = string.Left( fl, string.find( fl, "_" ) - 1 )
		CC_PLUGIN = {}

		-- if file is shared or client-side, send and include on clients
		-- TODO: not working for this moment
		-- if prefix == "sh" or prefix == "cl" then
		-- 	chopchop:sendAndInclude( "server/administration/" .. fl )
		-- end

			-- add plugin to temp var
			include( "server/administration/" .. fl )
			-- add plugin to collection
			chopchop.admin.plugins[ CC_PLUGIN.Name ] = CC_PLUGIN
			-- add plugin's translatables if any
			if CC_PLUGIN.Translate then
				local lang
				local lang1 = nil
				local langFound = false

				for k,v in pairs(CC_PLUGIN.Translate) do
					if k == chopchop.settings.language then
						-- get the first language in list
						if lang1 == nil then lang1 = k end
						lang = k
						langFound = true
					end
				end

				-- failsafe: select first available language if no translation for selected language
				if !langFound then
					lang = lang1
					chopchop:ConMsg( translate.core.adminLoadLangFailed:insert( CC_PLUGIN.Name, lang ) )
				end

				translate.plugins[ CC_PLUGIN.Name ] = CC_PLUGIN.Translate[ lang ]
			end

		msg = msg .. CC_PLUGIN.Name .. " (" .. fl .. ")" .. (k != #fls and ", " or "")
	end
	chopchop:ConMsg( msg )
end

function chopchop.admin.cmd( sender, text )
	local args = string.Explode(" ", text)
	-- get the command out of message
	local cmd = args[1]
	-- remove command from args, keeping args 'clean'
	table.remove(args, 1)

	-- check if we have plugin for this command
	local pluginExists = false
	local pluginName
	for k,v in pairs(chopchop.admin.plugins) do
		for k2,v2 in pairs( v.Commands ) do
			-- get help for plugin if there's
			if v2 == (cmd == "help" and ((args[1] ~= nil) and args[1] or "whatever") or cmd) then
				pluginExists = true
				pluginName = v.Name
				break
			end
		end
	end

	-- execute if there's a plugin with this name
	if pluginExists || cmd == "help" then
		-- get info on requested plugin if help passed
		if cmd == "help" then
			if args[1] ~= nil then
				-- TODO: NIL VALUES PANIC! I DON F***ING HOW TO GET RID OF THEM
				-- ITS 8AM HERE AND THERE'RE STILL THESE ERRORS DAMN I'LL DO IT TOMORROW
				if translate.plugins[ pluginName ].usage ~= nil || translate.plugins[ pluginName ].description ~= nil then
					chopchop.chat:Send(
						sender,
						chopchop.settings.colors.chatMsgInfo, chopchop.admin.getPluginInfo( pluginName )
					)
				else
					chopchop.chat:Send(
						sender,
						chopchop.settings.colors.chatMsgInfo, translate.admin.noPluginInfo:insert(cmd)
					)
				end

				if pluginExists  then
					chopchop.chat:Send(
						sender,
						chopchop.settings.colors.chatMsgInfo, chopchop.admin.getPluginInfo( pluginName )
					)
				else
					chopchop.chat:Send(
						sender,
						chopchop.settings.colors.chatMsgError, translate.admin.wrongCommand:insert( args[1] )
					)
				end
			else
				local msg = translate.admin.help .. "\n\n"

				for name,plugin in pairs( chopchop.admin.plugins ) do
					msg = msg ..
						"    " .. name .. " (" .. string.Implode( ", ", plugin.Commands ) .. ")" ..
						" - " ..--[[ translate.plugins[ name ].description or]] translate.admin.noPluginDescription .. "\n"
				end

				chopchop.chat:Send(
					sender,
					chopchop.settings.colors.chatMsgInfo, msg
				)
			end
		else
			chopchop:ConMsg(
				translate.admin.commandRun:insert( sender:Nick(), cmd, string.Implode( ", ", args ) )
			)

			chopchop.admin.plugins[ pluginName ].Execute( cmd, sender, args )
		end
	else
		chopchop.chat:Send(
			sender,
			chopchop.settings.colors.chatMsgError, translate.admin.wrongCommand:insert( cmd == "help" and args[1] or cmd )
		)
	end
end

function chopchop.admin.getPluginInfo( name )
	local msg = "[ " .. name .. " ]" .. "\n" ..
		(translate.plugins[ name ].usage ~= nil and
			("    " .. translate.admin.pluginTemplate .. ":\n        " .. translate.plugins[ name ].usage .. "\n") or "") ..
		(translate.plugins[ name ].description ~= nil and
			("    " .. translate.admin.pluginDescription .. ":\n        " .. translate.plugins[ name ].description) or "")

	return msg
end

function chopchop.admin.findPlys( name )
	local plys = {}
	for k,v in pairs( player.GetAll() ) do
		if ( v:Nick():lower() ):find( name:lower() ) ~= nil then
			table.insert( plys, v )
		end
	end

	return plys
end

function chopchop.admin.plysToString( plys )
	local out = ""
	for k, ply in pairs(plys) do
		out = out .. ply:Nick()

		if #plys > 1 && k == #plys - 1 then
			out = out .. " " .. translate.admin.separatorAnd .. " "
		elseif #plys > 2 && k ~= #plys then
			out = out .. ", "
		end
	end

	return out
end

util.AddNetworkString( "AdminPlugins" )
util.AddNetworkString( "GetAdminPlugins" )
util.AddNetworkString( "RunAdminCommand" )
net.Receive( "GetAdminPlugins", function( len, ply )
	-- repack the table without functions as we can't send them
	local repack = {}
	for k,plugin in pairs( chopchop.admin.plugins ) do
		local entry = {
			Name = plugin.Name,
			Commands = plugin.Commands,
			Translate = plugin.Translate,
			Usage = plugin.Usage,
			Permissions = plugin.Permissions
		}

		repack[ entry.Name ] = entry
	end

	net.Start( "AdminPlugins" )
		net.WriteTable( repack )
	net.Send( ply )
end)

net.Receive( "RunAdminCommand", function( len, ply )
	chopchop.admin.cmd( ply, net.ReadString() )
end)