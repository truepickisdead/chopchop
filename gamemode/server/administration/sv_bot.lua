CC_PLUGIN.Name = "Add bots"
CC_PLUGIN.Commands = {"bot"}

CC_PLUGIN.Translate = {
	eng = {
		usage = "bot",
		description = "Adds one bot."
	},
	rus = {
		usage = "bot",
		description = "Добавляет бота."
	}
}

function CC_PLUGIN:Execute( cmd, sender, args )
	RunConsoleCommand( "bot", "" )
end
