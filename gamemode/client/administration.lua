chopchop.admin = {}

function chopchop.admin.conCmd( ply, cmd, args, _ )
	net.Start( "RunAdminCommand" )
		net.WriteString( string.Implode( " ", args ) )
	net.SendToServer()
end

function chopchop.admin.conCmdAutoComplete( cmd, strargs )
	local out = {}
	local plugins = {}
	local args2 = string.Explode( " ", strargs:lower():sub(2) )

	table.insert( plugins, "help" )
	for k, plugin in pairs( chopchop.admin.plugins ) do
		for k1, plugcmd in pairs( plugin.Commands ) do
			if args2[1] == "help" &&
			( args2[2] == nil || plugcmd:find( args2[2] ) == 1 ) ||
			plugcmd:find( args2[1] ) == 1 then
				table.insert( plugins, plugcmd )
			end
		end
	end

	if args2[1] == "help" then
		for k,plugcmd in pairs(plugins) do
			if plugcmd ~= "help" then
				table.insert( out, "cc help " .. plugcmd )
			end
		end
	else
		for k,plugcmd in pairs(plugins) do
			table.insert( out, "cc " .. plugcmd )
		end
	end

	table.sort( out )
	-- make help option on the top if no arguments yet
	if args2[1] == "" then
		table.RemoveByValue( out, "cc help" )
		table.insert( out, 1, "cc help" )
	end

	return out
end

function chopchop:LoadAdminPlugins()
	-- hacky hack: do not send request immediately
	timer.Simple( 1, function()
		chopchop:ConMsg( "Sending request for plugin list to server..." )
		net.Start( "GetAdminPlugins" )
		net.SendToServer()
	end)
end

net.Receive( "AdminPlugins", function( len )
	chopchop.admin.plugins = net.ReadTable()
	chopchop:ConMsg( "Plugin list received" )
end)

concommand.Add( "cc", chopchop.admin.conCmd, chopchop.admin.conCmdAutoComplete, "The ultimate master-function of ChopChop" )
