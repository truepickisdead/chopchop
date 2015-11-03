-- show messages for player join and leave
gameevent.Listen("player_connect")
hook.Add("player_connect", "ShowConnect", function( data )
	chopchop.chat:Send(
		player.GetAll(),
		chopchop.settings.colors.chatMsgDefault, translate.msg.plyConnect:insert( data["name"] )
	)
end)

gameevent.Listen("player_disconnect")
hook.Add("player_disconnect", "ShowDisconnect", function( data )
	chopchop.chat:Send(
		player.GetAll(),
		chopchop.settings.colors.chatMsgDefault, translate.msg.plyDisconnect:insert( data["name"] )
	)
end)

-- ==================
-- =====< CHAT >=====
-- ==================
chopchop.chat = {}
util.AddNetworkString("ChatSentToClient")

function chopchop.chat:Send( receivers, ... )
	local args = { ... }
	local msgdata = {}

	-- repack message in a table
	for k,v in pairs(args) do
		table.insert( msgdata, v )
	end
	
	-- send message to receivers
	net.Start("ChatSentToClient")
		net.WriteTable(msgdata)
	net.Send(receivers)
end

function GM:PlayerSay( sender, text, teamChat )
	-- check if player tried to use command
	if string.StartWith(text, "!") || string.StartWith(text, "/") then
		chopchop.admin.checkCmd (sender, text)
	-- if not, just send message from his GameName
	else
		chopchop.chat:Send(
			player.GetAll(),
			Color(255, 255, 100), sender.GameName .. ": ",
			Color(255, 255, 255), text
		)
	end

	return false
end
