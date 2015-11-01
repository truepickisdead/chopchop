CC_PLUGIN.Name = "GameName"
CC_PLUGIN.Commands = {"name"}

function CC_PLUGIN.Execute( cmd, sender, args )
	if args != nil and #args > 0 then
		sender.GameName = string.Implode( " ", args )
		chopchop.chat:Send(
			sender,
			chopchop.settings.colors.chatMsgInfo, translate.make( "pluginGameName_nameChanged", sender.GameName )
		)
	else
		chopchop.chat:Send(
			sender,
			chopchop.settings.colors.chatMsgError, translate.pluginGameName_specifyName
		)
	end
end