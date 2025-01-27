local config = {
	bossName = "Tarbaz",
	bossPosition = Position(33459, 32844, 11),

	timeToDefeat = 30 * 60,
	entranceTiles = {
		{ pos = Position(33418, 32849, 11), destination = Position(33459, 32848, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(33418, 32850, 11), destination = Position(33459, 32848, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(33418, 32851, 11), destination = Position(33459, 32848, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(33418, 32852, 11), destination = Position(33459, 32848, 11), effect = CONST_ME_TELEPORT },
		{ pos = Position(33418, 32853, 11), destination = Position(33459, 32848, 11), effect = CONST_ME_TELEPORT },
	},
	zoneArea = {
		from = Position(33447, 32832, 11),
		to = Position(33473, 32856, 11),
	},
	exitTpDestination = Position(33319, 32318, 13),
}

local lever = EncounterData(config)
lever:uid(1027)
lever:register()
