translate.welcome = "Язык успешно загружен."

-- core
translate.core = {
	loadFilesStart = "Начинаем загрузку файлов",
	loadFilesServer = "Загруженные файлы сервера",
	loadFilesClient = "Загруженные файлы клиента",
	loadFilesShared = "Загруженные общие файлы",
	loadFilesFinish = "Загрузка файлов завершена",

	checkingData = "Проверяем данные",
	checkingDataFirstTime = "ChopChop был запущен в первый раз. Создаем директории",
	checkingDataOK = "Директории в порядке",

	adminLoadPlugins = "Загруженные административные плагины",
	adminLoadLangFailed = "ОШИБКА: Невозможно найти перевод на выбранный язык в плагине '{1}', используем '{2}'",

	noNamePlayer = "Незнакомец"
}

-- messages
translate.msg = {
	plyConnect = "К нам скоро зайдет {1}!",
	plyDisconnect = "{1} ушел",

	alreadyDead = "{1} уже мертв",
	suicideAlreadyDead = "Вы уже мертвы"
}

-- administration
translate.admin = {
	help = "[ Основная информация ]\n" ..
		"Доступ к административным возможностям режима предоставляется двумя способами:\n" ..
		"- через консоль (рекомендуется):\n" ..
		"    Введите в консоль 'cc '. Снизу появятся всплывающие подсказки, помогающие вам найти нужную команду.\n" ..
		"- через чат:\n" ..
		"    Начните ввод с восклицательного знака, либо сомвола '/', здесь вы должны ввести команду целиком, подсказок не будет." ..
		"\n" ..
		"Сразу после предложенных \"префиксов\" нужно ввести команду, которую вы хотите выполнить.\n" ..
		"Развернутую помощь по какой-либо отдельной команде вы можете получить, если введете 'help' перед командой.\n" ..
		"Например, для получения справки по команде 'kill', вам нужно ввести 'cc help kill' в консоли, либо '!help kill' в чате.\n" ..
		"Настоятельно рекомендуем использовать консоль, т.к. там имеется функция автозаполнения и помощи.\n" ..
		"\n" ..
		"Вот список всех доступных для вас на данный момент команд (заходите в эту справку чаще, здесь может что-то измениться):\n" ..
		"    название (команды) - описание",

	separatorAnd = "и",

	pluginInfo = "Использование плагина '{1}'",
	pluginTemplate = "Шаблон",
	pluginDescription = "Описание",
	noPluginDescription = "Нет описания",
	noPluginInfo = "Извините, инструкции для данного плагина нет. Пока что ;)",
	wrongCommand = "Команда '{1}' не существует!",

	commandRun = "{1} выполнил команду '{2}' с аргументами {{3}}",
	noTarget = "Не могу найти игроков с указанным именем",
	wrongArgs = "Неверные параметры. Введите 'cc help {1}' для получения инструкции по данной команде.",
	tooManyTargets = "Под ваш запрос подходят {1}. Нужна только одна цель."
}

translate.names = {
	male = {
		[1] = {
			"Черный",
			"Лысый",
			"Мелкий",
			"Голый",
			"Зеленый",
			"Грязный",
			"Падший",
			"Глупый",
			"Обычный",
			"Крутой",
			"Особенный"
		},
		[2] = {
			"Паша",
			"Геннадий",
			"Пенис",
			"Сырок",
			"Бомж",
			"Петушок",
			"Василий",
			"Помидор"
		}
	},
	female = {
		[1] = {
			"Черная",
			"Лысая",
			"Мелкая",
			"Голая",
			"Зеленая",
			"Грязная",
			"Падшая",
			"Глупая",
			"Обычная",
			"Крутая",
			"Особенная"
		},
		[2] = {
			"Морковка",
			"Тамара",
			"Зефирка",
			"Птичка",
			"Пися",
			"Цыпа",
			"Зинаида",
			"Барбариска"
		}
	}
}
