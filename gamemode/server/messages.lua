gameevent.Listen("player_connect")
gameevent.Listen("player_disconnect")

hook.Add("player_connect", "ShowConnect", function( data )
	chopchop.chat:Send(
		player.GetAll(),
		chopchop.settings.colors.chatMsgDefault, translate.msg.plyConnect:insert( data["name"] )
	)
end)

hook.Add("player_disconnect", "ShowDisconnect", function( data )
	chopchop.chat:Send(
		player.GetAll(),
		chopchop.settings.colors.chatMsgDefault, translate.msg.plyDisonnect:insert( data["name"] )
	)
end)

-- ====
-- CHAT
-- ====
chopchop.chat = {}
util.AddNetworkString("ChatSentToClient")

function chopchop.chat:Send( receivers, ... )
	local args = { ... }
	local msgdata = {}

	for k,v in pairs(args) do
		table.insert( msgdata, v )
	end
	
	net.Start("ChatSentToClient")
		net.WriteTable(msgdata)
	net.Send(receivers)
end

function GM:PlayerSay( sender, text, teamChat )
	if string.StartWith(text, "!") || string.StartWith(text, "/") then
		chopchop.admin.checkCmd (sender, text)
	else
		chopchop.chat:Send(
			player.GetAll(),
			Color(255, 255, 100), sender.GameName .. ": ",
			Color(255, 255, 255), text
		)
	end

	return false
end
