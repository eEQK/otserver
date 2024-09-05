local mType = Game.createMonsterType("Metal Gargoyle")
local monster = {}

monster.description = "a metal gargoyle"
monster.experience = 1400
monster.outfit = {
	lookType = 601,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1039
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Workshop Quarter, Glooth Factory, Underground Glooth Factory, Abandoned Sewers, \z
		Oramond Dungeon (depending on Magistrate votes), Jaccus Maxxens Dungeon."
		}
		
monster.health = 2100
monster.maxHealth = 2100
monster.race = "venom"
monster.corpse = 20976
monster.speed = 95
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "*click*", yell = false},
	{text = "*stomp*", yell = false}
}

monster.loot = {
	{name = "gold coin", chance = 100000, maxCount = 200},
	{id = 21755, chance = 2330},
	{id = 21193, chance = 17260},
	{name = "platinum coin", chance = 45000, maxCount = 2},
	{id = 236, chance = 8490, maxCount = 2},
	{id = 237, chance = 9130, maxCount = 2},
	{id = 21171, chance = 870},
	{id = 3051, chance = 490},
	{id = 3052, chance = 490},
	{id = 10310, chance = 1290},
	{id = 21169, chance = 2990},
	{id = 21168, chance = 1030},
	{id = 8896, chance = 2520},
	{id = 8082, chance = 1050},
	{id = 5880, chance = 520}
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200},
	{name ="combat", interval = 2000, chance = 12, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -220, length = 8, spread = 0, effect = CONST_ME_YELLOWENERGY, target = false},
	{name ="combat", interval = 2000, chance = 9, type = COMBAT_LIFEDRAIN, minDamage = 0, maxDamage = -130, range = 7, radius = 3, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true},
	{name ="metal gargoyle curse", interval = 2000, chance = 13, target = false}
}

monster.defenses = {
	defense = 33,
	armor = 26
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 15},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 10},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -5},
	{type = COMBAT_HOLYDAMAGE , percent = 0},
	{type = COMBAT_DEATHDAMAGE , percent = 80}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
