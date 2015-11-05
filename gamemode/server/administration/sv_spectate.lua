CC_PLUGIN.Name = "Move to spectators"
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
	local tr = translate.plugins[ "Move to spectators" ]

	local function doIt( ply )
		-- prevent being "alive spectator"
		if ply:Alive() then ply:KillSilent() end

		-- toggle team between spectators and players
		ply:SetTeam( ply:Team() == 1 and 2 or 1 )
		chopchop.chat:Send(
			player.GetAll(),
			chopchop.settings.colors.chatMsgInfo, ( ply:Team() == 1 and tr.toSpectators or tr.toPlayers ):insert( ply:Nick() )
		)
	end

	if args ~= nil && #args > 0 then
		for k,v in pairs( chopchop.admin.findPlys( string.Implode( " ", args ) ) ) do
			doIt( v )
		end
	else
		doIt( sender )
	end

end