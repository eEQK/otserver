local mType = Game.createMonsterType("Destroyer")
local monster = {}

monster.description = "a destroyer"
monster.experience = 2500
monster.outfit = {
	lookType = 236,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 287
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Pits of Inferno, Formorgar Mines, Alchemist Quarter, Oramond Dungeon.",
}

monster.health = 3700
monster.maxHealth = 3700
monster.race = "undead"
monster.corpse = 6319
monster.speed = 150
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
	pet = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "COME HERE AND DIE!", yell = false },
	{ text = "Destructiooooon!", yell = false },
	{ text = "It's a good day to destroy!", yell = false },
}

monster.loot = {
	{ name = "gold coin", chance = 99560, maxCount = 346 },
	{ id = 3577, chance = 55070, maxCount = 3 },
	{ name = "demonic essence", chance = 19000 },
	{ id = 3304, chance = 15285 },
	{ id = 3449, chance = 10930, maxCount = 12 },
	{ id = 3383, chance = 10000 },
	{ id = 3033, chance = 7532, maxCount = 2 },
	{ id = 10298, chance = 7042 },
	{ name = "soul orb", chance = 6996 },
	{ id = 3456, chance = 6070 },
	{ id = 3357, chance = 5050 },
	{ name = "platinum coin", chance = 3950, maxCount = 3 },
	{ id = 3281, chance = 1570 },
	{ name = "great health potion", chance = 990 },
	{ name = "steel boots", chance = 940 },
	{ id = 7427, chance = 810 },
	{ id = 7419, chance = 820 },
	{ id = 3008, chance = 570 },
	{ id = 3062, chance = 620 },
	{ id = 6299, chance = 80 },
	{ id = 5741, chance = 100 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -480 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -200, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = false },
}

monster.defenses = {
	defense = 35,
	armor = 35,
	{ name = "speed", interval = 2000, chance = 8, speedChange = 636, effect = CONST_ME_MAGIC_RED, target = false, duration = 7000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
