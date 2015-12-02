function chopchop:GhostsThink()
	for k, ply in pairs( player.GetAll() ) do
		if ply:GetNWBool( "Died" ) then
			-- make ghosts "fly" a little when they are falling fast
			if ply:GetVelocity().z < -250 then
				ply:SetVelocity( Vector( 0, 0, 25) )
			end

			if ply:KeyDown( IN_JUMP ) && ply:GetVelocity().z < 200 then
				ply:SetVelocity( Vector( 0, 0, 25) )
			end
		end
	end
end
