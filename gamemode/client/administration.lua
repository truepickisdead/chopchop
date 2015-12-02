chopchop.admin = {}

function chopchop.admin.conCmd( ply, cmd, args, _ )
	net.Start( "RunAdminCommand" )
		net.WriteString( string.Implode( " ", args ) )
	net.SendToServer()
end

function chopchop.admin.conCmdAutoComplete( cmd, strargs )
	local out = {}
	local pluginNames = {}
	local foundPlugins = {}
	local args = string.Explode( " ", strargs:lower():sub(2) )

	table.insert( pluginNames, "help" )
	for k, plugin in pairs( chopchop.admin.plugins ) do
		for k1, plugcmd in pairs( plugin.Commands ) do
			table.insert( pluginNames, plugcmd )
		end
	end

	for k, pluginName in pairs( pluginNames ) do
		if args[1] == "help" &&
		( args[2] == nil || pluginName:find( args[2] ) == 1 ) ||
		pluginName:find( args[1] ) == 1 then
			table.insert( foundPlugins, pluginName )
		end
	end

	if args[1] == "help" then
		for k,plugcmd in pairs(foundPlugins) do
			if plugcmd ~= "help" then
				table.insert( out, "cc help " .. plugcmd )
			end
		end
	else
		for k,plugcmd in pairs(foundPlugins) do
			table.insert( out, "cc " .. plugcmd )
		end
	end

	table.sort( out )
	-- make help option on the top if no arguments yet
	if args[1] == "" then
		table.RemoveByValue( out, "cc help" )
		table.insert( out, 1, "cc help" )
	end

	return out
end

function chopchop.admin:LoadPlugins()
	-- hacky hack: do not send request immediately
	timer.Simple( 1, function()
		if chopchop.settings.debug then chopchop:ConMsg( "Sending request for plugin list to server..." ) end
		net.Start( "GetAdminPlugins" )
		net.SendToServer()
	end)
end

net.Receive( "AdminPlugins", function( len )
	chopchop.admin.plugins = net.ReadTable()
	if chopchop.settings.debug then chopchop:ConMsg( "Plugin list received" ) end
end)

concommand.Add( "cc", chopchop.admin.conCmd, chopchop.admin.conCmdAutoComplete, "The ultimate master-function of ChopChop" )
