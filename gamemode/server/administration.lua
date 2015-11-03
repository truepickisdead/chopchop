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
		if prefix == "sh" or prefix == "cl" then
			chopchop:sendAndInclude( "server/administration/" .. fl )
		end

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

function chopchop.admin.checkCmd( sender, text )
	local args = string.Explode(" ", text)
	-- get the command out of message
	local cmd = string.sub(args[1], 2)
	-- remove command from args, keeping args 'clean'
	table.remove(args, 1)

	-- check if we have plugin for this command
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

	-- execute if there's
	if pluginExists then
		chopchop:ConMsg(
			translate.admin.commandRun:insert( sender:Nick(), cmd, string.Implode( ", ", args ) )
		)

		chopchop.admin.plugins[ pluginName ].Execute( cmd, sender, args )
	else
		chopchop.chat:Send(
			sender,
			chopchop.settings.colors.chatMsgError, translate.admin.wrongCommand:insert(cmd)
		)
		return false
	end

	return true
end
