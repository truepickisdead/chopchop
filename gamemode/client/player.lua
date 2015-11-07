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

hook.Add( "HUDPaint", "DrawScreenOverlay",function()
	if LocalPlayer():GetNWBool( "Died" ) then
		local isGhost = CurTime() > LocalPlayer():GetNWFloat( "DeathTime" ) + chopchop.settings.ghostSpawnDelay
		local percent = !isGhost and
			((CurTime() - LocalPlayer():GetNWFloat( "DeathTime" )) / chopchop.settings.ghostSpawnDelay) or
			math.Clamp( 1 - (( CurTime() - LocalPlayer():GetNWFloat( "DeathTime" ) - chopchop.settings.ghostSpawnDelay ) / chopchop.settings.ghostFadeInDelay), 0, 1 )
		local deathColors = {
			[ "$pp_colour_addr" ] = 0,
			[ "$pp_colour_addg" ] = 0,
			[ "$pp_colour_addb" ] = isGhost and 0.01 + 0.19*percent or 0.2*percent,
			[ "$pp_colour_brightness" ] = 0.1*percent,
			[ "$pp_colour_contrast" ] = (1 - percent)^2,
			[ "$pp_colour_colour" ] = (isGhost and 0.5 or 1)*(1 - percent),
			[ "$pp_colour_mulr" ] = 0,
			[ "$pp_colour_mulg" ] = 0,
			[ "$pp_colour_mulb" ] = 0
		}

		if percent ~= 0 then
			DrawMotionBlur( 1 - 1*percent*0.98, 1, 0.01 )
			DrawBloom( 1 - percent*0.98, 2, 9, 9, 3, 1, 1, 1, 1 )
		end

		DrawColorModify( deathColors )
	end
end)
