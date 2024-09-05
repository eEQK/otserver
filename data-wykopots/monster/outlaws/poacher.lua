local mType = Game.createMonsterType("Poacher")
local monster = {}

monster.description = "a poacher"
monster.experience = 70
monster.outfit = {
	lookType = 129,
	lookHead = 115,
	lookBody = 119,
	lookLegs = 119,
	lookFeet = 115,
	lookAddons = 1,
	lookMount = 0
}

monster.raceId = 376
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "South of Elvenbane and Ab'Dendriel, Ferngrims Gate, Northeast of Carlin, \z
		Edron Hunter Camps, Yalahar - Trade Quarter and Foreigner Quarter."
		}
		
monster.health = 90
monster.maxHealth = 90
monster.race = "blood"
monster.corpse = 18206
monster.speed = 99
monster.manaCost = 530

monster.changeTarget = {
	interval = 5000,
	chance = 0
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 5,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "You will not live to tell anyone!", yell = false},
	{text = "You are my game today!", yell = false},
	{text = "Look what has stepped into my trap!", yell = false}
}

monster.loot = {
	{id = 3559, chance = 26740},
	{id = 3355, chance = 30600},
	{id = 3601, chance = 11110, maxCount = 2},
	{id = 3350, chance = 14930},
	{id = 3447, chance = 49500, maxCount = 17},
	{id = 3448, chance = 2930, maxCount = 3},
	{id = 2920, chance = 5280},
	{id = 3481, chance = 880}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 25, attack = 20},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -35, range = 7, shootEffect = CONST_ANI_ARROW, target = false}
}

monster.defenses = {
	defense = 10,
	armor = 10
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 0},
	{type = COMBAT_FIREDAMAGE, percent = 0},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 0}
}

monster.immunities = {
	{type = "paralyze", condition = false},
	{type = "outfit", condition = false},
	{type = "invisible", condition = false},
	{type = "bleed", condition = false}
}

mType:register(monster)
