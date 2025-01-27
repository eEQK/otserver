local config = {
	bossName = "Lloyd",
	bossPosition = Position(32799, 32827, 14),
	requiredLevel = 250,
	entranceTiles = {
		{ pos = Position(32759, 32868, 14), destination = Position(32800, 32831, 14) },
		{ pos = Position(32759, 32869, 14), destination = Position(32800, 32831, 14) },
		{ pos = Position(32759, 32870, 14), destination = Position(32800, 32831, 14) },
		{ pos = Position(32759, 32871, 14), destination = Position(32800, 32831, 14) },
		{ pos = Position(32759, 32872, 14), destination = Position(32800, 32831, 14) },
	},
	monsters = {
		{ name = "cosmic energy prism a invu", pos = Position(32801, 32827, 14) },
		{ name = "cosmic energy prism b invu", pos = Position(32798, 32827, 14) },
		{ name = "cosmic energy prism c invu", pos = Position(32803, 32826, 14) },
		{ name = "cosmic energy prism d invu", pos = Position(32796, 32826, 14) },
	},
	zoneArea = {
		from = Position(32785, 32813, 14),
		to = Position(32812, 32838, 14),
	},
	exitTpDestination = Position(32815, 32873, 13),
}

local lever = BossLever(config)
lever:position(Position(32759, 32867, 14))
lever:register()
