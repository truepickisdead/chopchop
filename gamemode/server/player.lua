-- ================
-- PLAYER LIFECYCLE
-- ================

function GM:PlayerSpawn( ply )
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
		ply:SetDuckSpeed( chopchop.settings.plyDuckSpeed )
		ply:SetUnDuckSpeed( chopchop.settings.plyDuckSpeed )
		ply:SetCanWalk ( chopchop.settings.plyCanWalk )

	-- loadout player
	self:PlayerLoadout( ply )
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

-- =======================
-- DISABLED BASE FUNCTIONS
-- =======================
function GM:PlayerDeathSound() return true end