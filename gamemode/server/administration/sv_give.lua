CC_PLUGIN.Name = "Give"
CC_PLUGIN.Commands = {"give"}

function CC_PLUGIN.Execute( cmd, sender, args )
	sender:Give( args[1] )
end