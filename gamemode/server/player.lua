-- ================
-- PLAYER LIFECYCLE
-- ================

function GM:PlayerSpawn( ply )
	if !ply:GetNWBool( "Died", false ) && ply:Team() ~= 2 then
	-- player just spawned
		ply:SetNWBool( "Died", false )
		ply.Gender = table.Random( {"male", "female"} )
		local genderSettings = chopchop.settings.genders[ ply.Gender ]

		-- set up models for player and hands
		ply:SetModel( table.Random( genderSettings.models ) )
		ply:SetupHands()

		-- some movement properties
			-- gender specific
			ply:SetRunSpeed( 200 * genderSettings.sprintSpeedModifier )
			ply:SetWalkSpeed( 120 * genderSettings.moveSpeedModifier )
			ply:SetCrouchedWalkSpeed( 0.5 * genderSettings.crouchedSpeedModifier )
			-- global
			ply:SetCanWalk( chopchop.settings.plyCanWalk )
			ply:SetDuckSpeed( chopchop.settings.plyDuckSpeed )
			ply:SetUnDuckSpeed( chopchop.settings.plyDuckSpeed )

		-- undo ghost look
		ply:SetColor( Color( 255, 255, 255, 255 ) )
		ply:SetRenderMode( RENDERMODE_NORMAL )
		ply:SetCustomCollisionCheck( false )
		ply:DrawShadow( true )
		ply:SetMaterial( "" )
		ply:SetBloodColor( BLOOD_COLOR_RED )

		chopchop:SetupPlayer( ply )
	else
	-- player died previously, spawn as ghost
		local corpse = ply:GetNWEntity( "DeathRagdoll" )
		if !(!corpse || corpse == NULL || !IsValid(corpse)) then
			local pos = chopchop:FindSuitablePosition( corpse:GetPos(), ply, {around = 40, above = 80}, player.GetAll() )
			if pos then ply:SetPos( pos ) end
		end

		ply:GodEnable()
		
		-- make players look like ghosts
		ply:SetColor( chopchop.settings.colors.ghosts )
		ply:SetRenderMode( RENDERMODE_TRANSALPHA )
		ply:SetCustomCollisionCheck( true )
		ply:DrawShadow( false )
		ply:SetMaterial( chopchop.settings.colors.ghostsMaterial )
		ply:SetBloodColor( DONT_BLEED )
	end
end

function chopchop:SetupPlayer( ply )
	-- setup player color
	local col
	while !col ||
		col.x + col.y + col.z > 2.5 || -- check if color is not too bright
		math.max( math.abs(col.x - col.y), math.abs(col.y - col.z), math.abs(col.z - col.x) ) < 0.25 do -- check if color has enough saturation
		col = Vector(
			math.random(255) / 255,
			math.random(255) / 255,
			math.random(255) / 255
		)
	end

	ply:SetPlayerColor( col )
	ply:SetNWVector( "CCColor", col )

	-- setup player name
	local parts = {}
	for k, v in pairs( translate.names[ ply.Gender ] or translate.names.none ) do
		local part = table.Random( v )
		table.insert( parts, 1, part )
	end

	ply:SetNWString( "CCName", string.Implode( " ", parts ) )
end

function chopchop:PlayerLoadout( ply )
	if ply then
		for k, wep in pairs( chopchop.settings.playerDefaultWeapons ) do
			ply:Give( wep )
		end

		if ply.IsManiac then
			ply:Give( chopchop.settings.maniacMainWeapon )
			for wep, chance in pairs( chopchop.settings.maniacBonusWeapons ) do
				if math.random( chance*100 ) == 1 then ply:Give( wep ) end
			end
		else
			for wep, chance in pairs( chopchop.settings.bystanderBonusWeapons ) do
				if !ply:HasWeapon( wep ) && math.random( chance*100 ) == 1 then ply:Give( wep ) end
			end
		end

		ply:Give( "cc_weapon_hands" )
		ply:SelectWeapon( "cc_weapon_hands" )
	end
end

function GM:PlayerCanPickupWeapon( ply, wep )
	-- ghosts cannot pickup anything
	if ply:GetNWBool( "Died" ) then return false end
	-- disallow double weapon pickup
	if ply:HasWeapon( wep:GetClass() ) then return false end

	return true
end

function GM:PlayerCanPickupItem( ply, item )
	-- ghosts cannot pickup anything
	if ply:GetNWBool( "Died" ) then return false end

	return true
end

function GM:PlayerSetHandsModel( ply, ent )
	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end
end

function GM:PlayerInitialSpawn( ply )
	-- move to spectators on join
	ply:SetTeam( 1 )
	
	-- do not spawn player on join
	timer.Simple(0, function () if IsValid(ply) then ply:KillSilent() end end)
end

function GM:PlayerDeath( victim, inflictor, attacker )
	victim:SetNWBool( "Died", true )
	victim:SetNWFloat( "DeathTime", CurTime() )
end

hook.Add( "DoPlayerDeath", "DropWeaponsOnDeath", function( ply, attacker, dmginfo )
	-- create a table of not-drop weapons
	local noDrop = { chopchop.settings.maniacMainWeapon, "weapon_physgun", "cc_weapon_hands" }
	table.Add( noDrop, playerDefaultWeapons )
	for k, wep2 in pairs( chopchop.settings.maniacBonusWeapons ) do
		table.insert( noDrop, wep2 )
	end
	
	-- drop stored weapons
	for k,wep in pairs( ply:GetWeapons() ) do
		if !table.HasValue( noDrop, wep:GetClass() ) then ply:DropWeapon( wep ) end
	end
	if !table.HasValue( noDrop, ply:GetActiveWeapon():GetClass() ) then
		ply:DropWeapon( ply:GetActiveWeapon() )
	end
end)

function GM:PlayerSilentDeath( victim )
	victim:SetNWBool( "Died", true )
end

function GM:GetFallDamage( ply, speed )
	return ( speed / 6 )
end

function GM:PlayerShouldTakeDamage( ply, attacker )
	if ply:GetNWBool( "Died" ) then
		return false
	end

	return true
end

function GM:CanPlayerSuicide( ply )
	if ply:GetNWBool( "Died" ) then
		chopchop.chat:Send(
			ply,
			chopchop.settings.colors.chatMsgError, translate.msg.suicideAlreadyDead
		)
		return false
	end

	return true
end

hook.Add( "PlayerUse", "GhostsCannotUse", function( ply, ent )
	if ply:GetNWBool( "Died" ) then return false end
end)

-- =======================
-- DISABLED BASE FUNCTIONS
-- =======================
function GM:PlayerDeathSound() return true end
function GM:PlayerSpray( ply ) return true end