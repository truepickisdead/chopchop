function GM:ShouldCollide( ent1, ent2 )
	-- disable collision between ghosts and players
	if ent1:IsPlayer() && ent2:IsPlayer() then
		if ent1:GetNWBool( "Died", false ) ~= ent2:GetNWBool( "Died", false ) ||
		ent1:GetNWBool( "Died", true ) || ent2:GetNWBool( "Died", true ) then
			return false
		end
	end

	-- disable collision between ghosts and props
	local classes = {
		prop_physics = true,
		prop_physics_multiplayer = true,
		prop_dynamic = true,
		prop_static = true,
		func_door = true,
		func_lookdoor = true,
		func_door_rotating = true,
		prop_door_rotating = true,
		--func_movelinear = true,
		func_breakable = true,
		func_physbox = true,
		func_breakable_surf = true
	}
	if ent1:IsPlayer() && classes[ ent2:GetClass() ] ||
	ent2:IsPlayer() && classes[ ent1:GetClass() ] then
		return false
	end

	return true
end