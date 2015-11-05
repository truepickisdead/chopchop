chopchop.settings = {

	-- global
	debug = true,
	language = "eng",
	maxCorpsesPerPlayer = 2,
	maxCorpsesPerServer = 20,

	-- rounds
	rounds = {
		restartTime = 5,
		limit = 10
	},

	-- visuals
	colors = {
		chatMsgDefault = Color( 255, 255, 100 ),
		chatMsgInfo = Color( 100, 150, 255 ),
		chatMsgError = Color( 255, 50, 50 ),
	},
	
	-- movement settings
	plyDuckSpeed = 0.35,
	plyCanWalk = true,
	onlyMurdererCanRun = true,

	-- gender specific settings
	genders = {

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

}