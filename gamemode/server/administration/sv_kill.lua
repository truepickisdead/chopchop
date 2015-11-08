CC_PLUGIN.Name = "Kill"
CC_PLUGIN.Commands = {"kill"}

CC_PLUGIN.Translate = {
	eng = {
		usage = "kill, kill [name]",
		description = "Simply kills a player. If no arguments passed, kills yourself.",

		killed = "{1} killed {2}",
		killedHimself = "{1} killed himself"
	},
	rus = {
		usage = "kill, kill [имя]",
		description = "Убивает игрока. Если не указаны агрументы, убивает вас.",

		killed = "{1} убил {2}",
		killedHimself = "{1} убил себя"
	}
}

function CC_PLUGIN.Execute( cmd, sender, args )
	local tr = translate.plugins[ "Kill" ]
	local targets = {}

	local function doIt( ply )
		if !ply:GetNWBool( "Died", false ) then
			ply:Kill()
		else
			if ply == sender then
				chopchop.chat:Send(
					sender,
					chopchop.settings.colors.chatMsgError, translate.msg.suicideAlreadyDead
				)
			else
				chopchop.chat:Send(
					sender,
					chopchop.settings.colors.chatMsgError, translate.msg.alreadyDead:insert( ply:Nick() )
				)
			end

			table.remove( targets, table.contains( targets, ply ) )
		end
	end

	if args ~= nil and #args > 0 then
		targets = chopchop.admin.findPlys( string.Implode( " ", args ) )


		if targets && #targets > 0 then
			-- travel backvards to remove values in loop and not get things screwed up
			for i = #targets, 1, -1 do
				doIt( targets[i] )
			end

			local senderNum = table.contains( targets, sender )
			if senderNum then
				chopchop.chat:Send(
					player.GetAll(),
					chopchop.settings.colors.chatMsgInfo, tr.killedHimself:insert( sender:Nick() )
				)
				table.remove( targets, senderNum )
			end

			if #targets > 0 then chopchop.chat:Send(
				player.GetAll(),
				chopchop.settings.colors.chatMsgInfo, tr.killed:insert( sender:Nick(), chopchop.admin.plysToString( targets ) )
			) end
		else
			chopchop.chat:Send(
				sender,
				chopchop.settings.colors.chatMsgError, translate.admin.noTarget
			)
		end
	else
		doIt( sender )
	end
end
