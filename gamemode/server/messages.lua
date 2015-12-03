-- ==================
-- =====< CHAT >=====
-- ==================
chopchop.chat = {}
util.AddNetworkString("CC_ChatSentToClient")

function chopchop.chat:Send( receivers, ... )
	local args = { ... }
	local msgdata = {}

	-- repack message in a table
	for k,v in pairs(args) do
		table.insert( msgdata, v )
	end
	
	-- send message to receivers
	net.Start("CC_ChatSentToClient")
		net.WriteTable(msgdata)
	net.Send(receivers)
end

function GM:PlayerSay( sender, text, teamChat )
	-- check if player tried to use command
	if (string.StartWith(text, "!") || string.StartWith(text, "/")) && chopchop.admin then
		chopchop.admin.cmd( sender, text:sub(2) )
	-- if not, just send message from his GameName
	else
		local name = sender:GetNWString( "CC_Name", "Mr. Error" )

		-- alive players cannot see ghosts chat
		local receivers = {}
		for k, ply in pairs( player.GetAll() ) do
			if self:PlayerCanHear( ply, sender ) then table.insert( receivers, ply ) end
		end

		print( ( sender:GetNWBool( "Died", false ) and "*ghost* " or "") .. sender:Nick() .. " (" .. name .. "): " .. text )
		chopchop.chat:Send(
			receivers,
			(sender:GetNWVector( "CC_Color", Vector( 1, 1, 0.4 ) )):ToColor(), name,
			Color(255, 255, 255), ": " .. text
		)
	end

	return false
end
