translate.welcome = "Language successefully loaded."

-- core
translate.core = {
	loadFilesStart = "Started loading files",
	loadFilesServer = "Included server files",
	loadFilesClient = "Included client files",
	loadFilesShared = "Included shared files",
	loadFilesFinish = "Done loading files",

	checkingData = "Checking data",
	checkingDataFirstTime = "ChopChop was launched first time. Creating data folders",
	checkingDataOK = "Folders are OK",

	adminLoadPlugins = "Loaded admin plugins",
	adminLoadLangFailed = "ERROR: Couldn't find translation for current language in plugin '{1}', using '{2}' instead"
}

-- messages
translate.msg = {
	plyConnect = "{1} gonna join us!",
	plyDisconnect = "{1} left",

	alreadyDead = "{1} is already dead",
	suicideAlreadyDead = "You are already dead"
}

-- administration
translate.admin = {
	help = "[ General information ]\n" ..
		"There are 2 ways of accessing administrative functions of gamemode:\n" ..
		"- through console (recommended):\n" ..
		"    Type 'cc ' in console. Autocompletion hints will appear below to help you find needed command.\n" ..
		"- through chat:\n" ..
		"    Begin your message with '!' or '/', here you have to enter the whole command, there's no hints and autocompletion.\n" ..
		"\n" ..
		"After these \"prefixes\" enter the command you want to execute.\n" ..
		"To get more information on desired command, use 'help' command.\n" ..
		"For example, to get help on command 'kill' you should enter 'cc help kill' in console or '!help kill' in chat.\n" ..
		"We strongly insist on using console as there are autocomplete and hints system.\n" ..
		"\n" ..
		"Here's a full list of plugins available for you now (look this help sometimes as things are likely to change here with updates):\n" ..
		"    name (commands) - description",

	separatorAnd = "and",

	pluginInfo = "Usage of plugin '{1}'",
	pluginTemplate = "Template",
	pluginDescription = "Description",
	noPluginDescription = "No description",
	noPluginInfo = "Sorry, no info for this plugin. Yet ;)",
	wrongCommand = "Command '{1}' does not exist!",

	commandRun = "{1} ran command '{2}' with arguments {{3}}",
	noTarget = "Cannot find players using this pattern"
}
