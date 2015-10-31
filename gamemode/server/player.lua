-- ================
-- PLAYER LIFECYCLE
-- ================

function GM:PlayerSpawn( ply )
	ply.Gender = table.Random( {"male", "female"} )

	-- set up models for player and hands
	ply:SetModel( table.Random( chopchop.settings.genders[ ply.Gender ].models ) )
	ply:SetupHands()

	-- some movement properties
	ply:SetCrouchedWalkSpeed( chopchop.settings.plyCrouchedMoveSpeed )
	ply:SetRunSpeed( chopchop.settings.plySprintSpeed )
	ply:SetWalkSpeed( chopchop.settings.plyMoveSpeed )
	ply:SetDuckSpeed( chopchop.settings.plyDuckSpeed )
	ply:SetUnDuckSpeed( chopchop.settings.plyDuckSpeed )
	ply:SetCanWalk ( chopchop.settings.plyCanWalk )

	-- loadout player
	self:PlayerLoadout( ply )
end