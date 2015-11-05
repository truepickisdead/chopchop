local defaultCol = chopchop.settings.colors.ghosts

hook.Add( "Think", "PlayerRender", function()
	local imDead = LocalPlayer():GetNWBool( "Died", false )

	for k, ply in pairs( player.GetAll() ) do
		local dead = ply:GetNWBool( "Died", false )

		if imDead then
			ply:SetColor( defaultCol )
		else
			if dead then
				ply:SetColor( Color( 255, 255, 255, 0 ) )
			else
				ply:SetColor( defaultCol )
			end
		end
	end
end)