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