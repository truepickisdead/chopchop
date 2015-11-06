function GM:PlayerThink()
	for k, ply in pairs( player.GetAll() ) do
		-- make ghosts "fly" a little when they are falling fast
		if ply:GetNWBool( "Died" ) && ply:GetVelocity().z < -200 then
			ply:SetVelocity( Vector( 0, 0, 50) )
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
			ply:SetRunSpeed( 300 * genderSettings.sprintSpeedModifier )
			ply:SetWalkSpeed( 200 * genderSettings.moveSpeedModifier )
			ply:SetCrouchedWalkSpeed( 0.5 * genderSettings.crouchedSpeedModifier )
			-- global
			ply:SetCanWalk( chopchop.settings.plyCanWalk )
			ply:SetDuckSpeed( chopchop.settings.plyDuckSpeed )
			ply:SetUnDuckSpeed( chopchop.settings.plyDuckSpeed )

		-- loadout player
		self:PlayerLoadout( ply )

		-- undo ghost look
		ply:SetColor( Color( 255, 255, 255, 255 ) )
		ply:SetRenderMode( RENDERMODE_NORMAL )
		ply:SetCustomCollisionCheck( false )
		ply:DrawShadow( true )
		ply:SetMaterial( "" )

		ply:Give( "weapon_357" )
	else
	-- player died previously, spawn as observer
		local corpse = ply:GetRagdollEntity()
		if corpse ~= nil then
			ply:GodEnable()
			ply:SetPos( corpse:GetPos() + Vector( 0, 0, -35) )
		end

		-- make player look in same direction as before death
		ply:SetEyeAngles( ply:GetNWVector( "DeathEyeAngle", Vector( 0, 0, 0) ) )

		-- make players look like ghosts
		ply:SetColor( chopchop.settings.colors.ghosts )
		ply:SetRenderMode( RENDERMODE_TRANSALPHA )
		ply:SetCustomCollisionCheck( true )
		ply:DrawShadow( false )
		ply:SetMaterial( chopchop.settings.colors.ghostsMaterial )
	end
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
	ply:SetNWVector( "DeathEyeAngle", ply:EyeAngles() )
end)

hook.Add( "PlayerUse", "GhostsCannotUse", function( ply, ent )
	if ply:GetNWBool( "Died", false ) then return false end
end)

-- =======================
-- DISABLED BASE FUNCTIONS
-- =======================
function GM:PlayerDeathSound() return true end