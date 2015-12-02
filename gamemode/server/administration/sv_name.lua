CC_PLUGIN.Name = "Change name"
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

function CC_PLUGIN:Execute( cmd, sender, args )
	local tr = translate.plugins[ self.Name ]

	if args != nil and #args > 0 then
		sender:SetNWString( "CCName", string.Implode( " ", args ) )
		chopchop.chat:Send(
			sender,
			chopchop.settings.colors.chatMsgInfo, tr.nameChanged:insert( sender:GetNWString( "CCName" ) )
		)
	else
		chopchop.chat:Send(
			sender,
			chopchop.settings.colors.chatMsgError, tr.specifyName
		)
	end
end