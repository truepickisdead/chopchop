CC_PLUGIN.Name = "Spectate"
CC_PLUGIN.Commands = {"spectate"}

CC_PLUGIN.Translate = {
	eng = {
		toSpectators = "{1} is now spectating",
		toPlayers = "{1} is now playing"
	},
	rus = {
		toSpectators = "{1} теперь наблюдает",
		toPlayers = "{1} теперь играет"
	}
}

function CC_PLUGIN.Execute( cmd, sender, args )
	local tr = translate.plugins[ "Spectate" ]

	-- toggle team between spectators and players
	sender:SetTeam( sender:Team() == 1 and 2 or 1 )
	chopchop.chat:Send(
		player.GetAll(),
		chopchop.settings.colors.chatMsgInfo, ( sender:Team() == 1 and tr.toSpectators or tr.toPlayers ):insert( sender:Nick() )
	)
end