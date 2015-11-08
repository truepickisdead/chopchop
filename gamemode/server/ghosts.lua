function chopchop:PlayerThink()
	for k, ply in pairs( player.GetAll() ) do
		-- make ghosts "fly" a little when they are falling fast
		if ply:GetNWBool( "Died" ) && ply:GetVelocity().z < -250 then
			ply:SetVelocity( Vector( 0, 0, 25) )
		end
	end
end