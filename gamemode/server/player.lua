function chopchop:PlayerThink()
	for k, ply in pairs( player.GetAll() ) do
		-- make ghosts "fly" a little when they are falling fast
		if ply:GetNWBool( "Died" ) && ply:GetVelocity().z < -250 then
			ply:SetVelocity( Vector( 0, 0, 25) )
		end
	end
end

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
			ply:SetRunSpeed( 225 * genderSettings.sprintSpeedModifier )
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
	else
	-- player died previously, spawn as observer
		local corpse = ply:GetRagdollEntity()
		if corpse ~= nil then
			--ply:SetPos( corpse:GetPos() + Vector( 0, 0, -35) )
		end

		-- make player look in same direction as before death
		--ply:SetEyeAngles( ply:GetNWVector( "DeathEyeAngle", Vector( 0, 0, 0) ) )

		ply:GodEnable()
		
		-- make players look like ghostsGM:PlayerCanPickupItem
		ply:SetColor( chopchop.settings.colors.ghosts )
		ply:SetRenderMode( RENDERMODE_TRANSALPHA )
		ply:SetCustomCollisionCheck( true )
		ply:DrawShadow( false )
		ply:SetMaterial( chopchop.settings.colors.ghostsMaterial )
	end
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
	ply:SetTeam( chopchop.settings.debug and 1 or 2 )
	
	-- do not spawn player on join
	timer.Simple(0, function () if IsValid(ply) then ply:KillSilent() end end)
end

function GM:PlayerDeath( victim, inflictor, attacker )
	victim:SetNWFloat( "DeathTime", CurTime() )
end

function GM:GetFallDamage( ply, speed )
	return ( speed / 8 )
end

function GM:PlayerShouldTakeDamage( ply, attacker )
	if ply:GetNWBool( "Died" ) then
		return false
	end

	return true
end

function GM:CanPlayerSuicide( ply )
	if ply:GetNWBool( "Died", false ) then
		chopchop.chat:Send(
			ply,
			chopchop.settings.colors.chatMsgError, translate.msg.suicideAlreadyDead
		)
		return false
	end

	return true
end

hook.Add( "PlayerDeathThink", "PlyDeathHook", function( ply )
	ply:SetNWBool( "Died", true )
	--ply:SetNWVector( "DeathEyeAngle", ply:EyeAngles() )
end)

hook.Add( "PlayerUse", "GhostsCannotUse", function( ply, ent )
	if ply:GetNWBool( "Died", false ) then return false end
end)

-- =======================
-- DISABLED BASE FUNCTIONS
-- =======================
function GM:PlayerDeathSound() return true end