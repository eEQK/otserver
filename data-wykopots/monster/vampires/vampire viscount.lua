local mType = Game.createMonsterType("Vampire Viscount")
local monster = {}

monster.description = "a vampire viscount"
monster.experience = 800
monster.outfit = {
	lookType = 555,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 958
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Drefia, Edron Vampire Crypt.",
}

monster.health = 1200
monster.maxHealth = 1200
monster.race = "blood"
monster.corpse = 18961
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
	pet = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Prepare to BLEED!", yell = false },
	{ text = "Don't struggle. We don't want to waste a drop of blood now, do we?", yell = false },
	{ text = "Ah, refreshments have arrived!", yell = false },
}

monster.loot = {
	{ name = "gold coin", chance = 85500, maxCount = 50 },
	{ id = 237, chance = 7210 },
	{ id = 9685, chance = 7920 },
	{ id = 236, chance = 5840 },
	{ id = 18924, chance = 5140 },
	{ id = 18927, chance = 3830 },
	{ id = 3030, chance = 2790, maxCount = 2 },
	{ id = 11449, chance = 3000 },
	{ id = 3027, chance = 2460 },
	{ id = 3284, chance = 730 },
	{ id = 3039, chance = 260 },
	{ id = 3434, chance = 260 },
	{ id = 5911, chance = 160 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -150 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -50, maxDamage = -100, range = 5, radius = 3, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = true },
	-- bleed
	{ name = "condition", type = CONDITION_BLEEDING, interval = 2000, chance = 10, minDamage = -320, maxDamage = -560, radius = 6, effect = CONST_ME_BATS, target = false },
}

monster.defenses = {
	defense = 42,
	armor = 42,
	{ name = "outfit", interval = 2000, chance = 10, target = false, duration = 4000, outfitMonster = "Vicious Manbat" },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 300, effect = CONST_ME_MAGIC_RED, target = false, duration = 4000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
