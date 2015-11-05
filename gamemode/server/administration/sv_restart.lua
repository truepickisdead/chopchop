CC_PLUGIN.Name = "Restart"
CC_PLUGIN.Commands = {"restart"}

CC_PLUGIN.Translate = {
	eng = {
		usage = "restart map, restart round",

		restartingMap = "{1} is restarting map...",
		restartingRound = "{1} is restarting round..."
	},
	rus = {
		usage = "restart map, restart round",

		restartingMap = "{1} перезапускает карту...",
		restartingRound = "{1} перезапускает раунд..."
	}
}

function CC_PLUGIN.Execute( cmd, sender, args )
	local tr = translate.plugins[ "Restart" ]
	
	if #args > 0 then
		if args[1] == "map" then
			chopchop.chat:Send(
				player.GetAll(),
				chopchop.settings.colors.chatMsgInfo, tr.restartingMap:insert( sender:Nick() )
			)
			timer.Simple( 3, function()
				RunConsoleCommand( "changelevel", game.GetMap() )
			end)
		elseif args[1] == "round" then
			chopchop.chat:Send(
				player.GetAll(),
				chopchop.settings.colors.chatMsgInfo, tr.restartingRound:insert( sender:Nick() )
			)
			-- TODO: cannot access GM from here
			timer.Simple( 3, function()
				GM.Round.Count = GM.Round.Count - 1
				GM:StartRound( GM.Round.Mode )
			end)
		end
	end
end