CC_PLUGIN.Name = "Health"
CC_PLUGIN.Commands = {"health"}

function CC_PLUGIN:Execute( cmd, sender, args )
	if #args == 0 then 
		chopchop.chat:Send( player.GetAll(), sender.GameName .. "'s health is " .. sender:Health() .. "hp" )
	elseif #args == 1 then
		sender:SetHealth( args[1] )
		chopchop.chat:Send( player.GetAll(), sender.GameName .. " set his health to " .. sender:Health() .. "hp" )
	end
end