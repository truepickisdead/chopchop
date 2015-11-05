function GM:PlayerFootstep( ply, pos, foot, sound, volume, filter )
	if ply:GetNWBool( "Died", true ) then return true end
end