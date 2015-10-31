-- ===================
-- BASIC GAMEMODE INFO
-- ===================

GM.Name = "ChopChop"
GM.Author = "#Octothorp Team"
GM.Email = "mail@octothorp.team"
GM.Website = "http://chopchop.octothorp.team"
DeriveGamemode( "base" )

function GM:Initialize()
	
end

-- =================
-- CHOPCHOP SPECIFIC
-- =================

chopchop = {}
include( "chopchop.lua" )
include( "defaultsettings.lua" )
chopchop:Start()