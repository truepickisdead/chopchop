CC_PLUGIN.Name = "Debug Tools"
CC_PLUGIN.Commands = {"debug"}

function CC_PLUGIN:Execute( cmd, sender, args )
	if args ~= nil and #args > 0 then
		if args[1] == "class" then
			local target = sender:GetEyeTrace().Entity
			chopchop.chat:Send(
				sender,
				chopchop.settings.colors.chatMsgInfo, target and target:GetClass() or "No target"
			)
		end
	else
		chopchop.chat:Send(
			sender,
			chopchop.settings.colors.chatMsgError, "No arguments"
		)
	end
end
