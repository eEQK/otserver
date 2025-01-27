local config = {
	bossName = "The Unwelcome",
	bossPosition = Position(33708, 31539, 14),
	requiredLevel = 250,
	entranceTiles = {
		{ pos = Position(33736, 31537, 14), destination = Position(33707, 31545, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33737, 31537, 14), destination = Position(33707, 31545, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33738, 31537, 14), destination = Position(33707, 31545, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33739, 31537, 14), destination = Position(33707, 31545, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(33740, 31537, 14), destination = Position(33707, 31545, 14), effect = CONST_ME_TELEPORT },
	},
	zoneArea = {
		from = Position(33699, 31529, 14),
		to = Position(33719, 31546, 14),
	},
	exitTpDestination = Position(33611, 31528, 10),
}

local lever = BossLever(config)
lever:position({ x = 33735, y = 31537, z = 14 })
lever:register()
