local mType = Game.createMonsterType("Enchanted Hellspawn")
local monster = {}

monster.description = "an enchanted hellspawn"
monster.experience = 9000
monster.outfit = { lookType = 322, lookHead = 0, lookBody = 0, lookLegs = 0, lookFeet = 0, lookAddons = 0, lookMount = 0 }

monster.health = 5500
monster.maxHealth = 5500
monster.race = "fire"
monster.corpse = 9009
monster.speed = 344
monster.manaCost = 0

monster.changeTarget = { interval = 3717, chance = 15 }

monster.strategiesTarget = { nearest = 70, health = 10, damage = 10, random = 10 }

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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = { level = 0, color = 0 }

monster.voices = {}

monster.loot = {}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -352 },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_FIREDAMAGE,
		minDamage = -150,
		maxDamage = -175,
		shootEffect = CONST_ANI_FIRE,
		effect = CONST_ME_FIREATTACK,
		target = false,
	},
}

monster.defenses = {
	defense = 40,
	armor = 40,
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_HEALING,
		minDamage = 120,
		maxDamage = 230,
		effect = CONST_ME_MAGIC_BLUE,
		target = false,
	},
	{
		name = "speed",
		interval = 2000,
		chance = 15,
		speedChange = 270,
		effect = CONST_ME_MAGIC_RED,
		target = false,
		duration = 4999,
	},
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 70 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = -90 },
	{ type = COMBAT_DEATHDAMAGE, percent = 30 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
