CC_PLUGIN.Name = "GameName"
CC_PLUGIN.Commands = {"name"}

CC_PLUGIN.Translate = {
	eng = {
		nameChanged = "Your name was changed to '{1}'",
		specifyName = "Please specify the name after command"
	},
	rus = {
		nameChanged = "Ваше имя изменено на '{1}'",
		specifyName = "Пожалуйста, укажите имя после команды"
	}
}

function CC_PLUGIN.Execute( cmd, sender, args )
	local tr = translate.plugins[ "GameName" ]

	if args != nil and #args > 0 then
		sender.GameName = string.Implode( " ", args )
		chopchop.chat:Send(
			sender,
			chopchop.settings.colors.chatMsgInfo, tr.nameChanged:insert( sender.GameName )
		)
	else
		chopchop.chat:Send(
			sender,
			chopchop.settings.colors.chatMsgError, tr.specifyName
		)
	end
end