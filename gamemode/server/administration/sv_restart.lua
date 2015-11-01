CC_PLUGIN.Name = "Restart"
CC_PLUGIN.Commands = {"restart"}

function CC_PLUGIN.Execute( cmd, sender, args )
	RunConsoleCommand( "changelevel", game.GetMap() )
end