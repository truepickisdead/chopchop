CC_PLUGIN.Name = "Teleport"
CC_PLUGIN.Commands = {"tp"}

CC_PLUGIN.Translate = {
	eng = {
		usage = "tp [where], tp [who] [where]",
		description = "Teleport players. If only one argument passed, teleports you to player.",

		tped = "{1} teleported {2} to {3}",
		cannotHere = "{1} cannot be placed here"
	},
	rus = {
		usage = "tp [к кому], tp [кого] [к кому]",
		description = "Перемещает игроков. Если указан только один аргумент, перемещает вас к игроку.",

		tped = "{1} переместил {2} к {3}",
		cannotHere = "Нельзя поместить {1} здесь"
	}
}

function CC_PLUGIN:Execute( cmd, sender, args )
	local tr = translate.plugins[ "Teleport" ]
	local who = {sender}
	local where = {}

	if args ~= nil and #args > 0 and #args < 3 then
		if #args == 1 then
			where = chopchop.admin.findPlys( args[1] )
		elseif #args == 2 then
			who = chopchop.admin.findPlys( args[1] )
			where = chopchop.admin.findPlys( args[2] )
		end

		table.RemoveByValue( where, sender )

		-- cannot teleport to several places
		if #where > 1 then
			chopchop.chat:Send(
				sender,
				chopchop.settings.colors.chatMsgError, translate.admin.tooManyTargets:insert( chopchop.admin.plysToString(where) )
			)
			return
		end

		-- don't know whom we're going to teleport
		if !who || !where || #where < 1 then
			chopchop.chat:Send(
				sender,
				chopchop.settings.colors.chatMsgError, translate.admin.noTarget
			)
			return
		end

		-- do the thing
		local succeeded = {}
		for k, ply in pairs(who) do
			local filter = {}
			if ply:GetNWBool("Died") then
				for k, ply2 in pairs( player.GetAll() ) do
					table.insert( filter, ply2 )
				end
			end
			local pos = chopchop:FindSuitablePosition( where[1]:GetPos(), ply, {around = 40, above = 80}, filter )

			if pos then 
				ply:SetPos( pos )
				table.insert( succeeded, ply )
			else
				chopchop.chat:Send(
					sender,
					chopchop.settings.colors.chatMsgError, tr.cannotHere:insert( ply:Nick() )
				)
			end
		end

		chopchop.chat:Send(
			player.GetAll(),
			chopchop.settings.colors.chatMsgError, tr.tped:insert( sender:Nick(), chopchop.admin.plysToString( succeeded ), where[1]:Nick() )
		)
	else
		chopchop.chat:Send(
			sender,
			chopchop.settings.colors.chatMsgError, translate.admin.wrongArgs:insert( self.Name )
		)
	end
end
