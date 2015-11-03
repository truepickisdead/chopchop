CC_PLUGIN.Name = "Kill"
CC_PLUGIN.Commands = {"kill"}

CC_PLUGIN.Translate = {
	eng = {
		killed = "{1} killed {2}",
		killedHimself = "{1} killed himself"
	},
	rus = {
		killed = "{1} убил {2}",
		killedHimself = "{1} убил себя"
	}
}

function CC_PLUGIN.Execute( cmd, sender, args )
	local tr = translate.plugins[ "Kill" ]

	if args ~= nil and #args > 0 then
		name = string.Implode( " ", args )
		local targets = chopchop.admin.findPlys( name )

		if #targets > 0 then
			for k,target in pairs(targets) do target:Kill() end
			chopchop.chat:Send(
				player.GetAll(),
				chopchop.settings.colors.chatMsgInfo, tr.killed:insert( sender:Nick(), chopchop.admin.plysToString( targets ) )
			)
		else
			chopchop.chat:Send(
				sender,
				chopchop.settings.colors.chatMsgError, translate.admin.noTarget
			)
		end
	else
		chopchop.chat:Send(
			player.GetAll(),
			chopchop.settings.colors.chatMsgError, tr.killedHimself( sender:Nick(), target:Nick() )
		)
	end
end
