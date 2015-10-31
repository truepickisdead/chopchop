gameevent.Listen("player_connect")
gameevent.Listen("player_disconnect")

hook.Add("player_connect", "ShowConnect", function( data )
	chopchop.chat:Send(
		player.GetAll(),
		chopchop.settings.chatMsgDefaultColor, translate.make( "msgPlyConnect", data["name"] )
	)
end)

hook.Add("player_disconnect", "ShowDisconnect", function( data )
	chopchop.chat:Send(
		player.GetAll(),
		chopchop.settings.chatMsgDefaultColor, translate.make( "msgPlyDisconnect", data["name"] )
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