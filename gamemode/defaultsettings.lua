chopchop.settings = {
	-- global
	debug = true,
	language = "eng",
	maxCorpsesPerPlayer = 2,
	maxCorpsesPerServer = 20,
	ghostSpawnDelay = 5,
	ghostFadeInDelay = 2,

	-- weapons
	-- (bonus weapons: "weapon_name" = [appearance chance], minimal chance is 0.01)
	playerDefaultWeapons = {},
	murdererMainWeapons = { "weapon_crowbar" },
	murdererBonusWeapons = {},
	bystanderGun = "weapon_357",
	bystanderBonusWeapons = { ["weapon_357"] = 0.1 },
	
	-- movement settings
	plyDuckSpeed = 0.35,
	plyCanWalk = true,
	onlyMurdererCanRun = true
}

-- visuals
chopchop.settings.colors = {
	chatMsgDefault = Color( 255, 255, 100 ),
	chatMsgInfo = Color( 100, 150, 255 ),
	chatMsgError = Color( 255, 50, 50 ),

	ghosts = Color( 255, 255, 255, 5 ),
	ghostsMaterial = "models/props/cs_office/clouds"
}

-- rounds
chopchop.settings.rounds = {
	restartTime = 5,
	limit = 10
}

-- gender specific settings
chopchop.settings.genders = {
	male = {
		moveSpeedModifier = 1,
		sprintSpeedModifier = 1,
		crouchedSpeedModifier = 1,
		models = {
			"models/player/Group01/Male_01.mdl",
			"models/player/Group01/Male_02.mdl",
			"models/player/Group01/Male_03.mdl",
			"models/player/Group01/Male_04.mdl",
			"models/player/Group01/Male_05.mdl",
			"models/player/Group01/Male_06.mdl",
			"models/player/Group01/Male_07.mdl",
			"models/player/Group01/Male_08.mdl"
		}
	},

	female = {
		moveSpeedModifier = 1,
		sprintSpeedModifier = 1.1,
		crouchedSpeedModifier = 1.2,
		models = {
			"models/player/Group01/Female_01.mdl",
			"models/player/Group01/Female_02.mdl",
			"models/player/Group01/Female_03.mdl",
			"models/player/Group01/Female_04.mdl",
			"models/player/Group01/Female_06.mdl"
		}
	}
}