local internalNpcName = "Leon"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 129,
	lookHead = 117,
	lookBody = 97,
	lookLegs = 117,
	lookFeet = 42,
	lookAddons = 3,
}

npcConfig.flags = { floorchange = 0 }

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Luki, kusze, amunicja to moj chleb powszedni" },
	{ text = "Codziennie z rana ostrze grot kazdej wloczni" },
	{ text = "Kusza czy luk?" },
}

npcHandler:setMessage(MESSAGE_GREET, "Elo, |PLAYERNAME|. Sprzedaje kusze, luki, dzidy i amunicje.")
-- npcHandler:setMessage(MESSAGE_GREET_ENG, 'Hello, |PLAYERNAME|. My offers are bows, crossbows and ammunition. If you'd like to see, ask me for a {trade}.')

npcConfig.shop = {
	{ itemName = "quiver", clientId = 35562, buy = 400 },
	{ itemName = "red quiver", clientId = 35849, buy = 400 },
	{ itemName = "blue quiver", clientId = 35848, buy = 400 },
	{ itemName = "bow", clientId = 3350, sell = 100 },
	{ itemName = "crossbow", clientId = 3349, sell = 120 },
	{ itemName = "silkweaver bow", clientId = 8029, sell = 4000 },
	{ itemName = "elvish bow", clientId = 7438, sell = 2000 },
	{ itemName = "spear", clientId = 3277, sell = 3 },
	{ itemName = "modified crossbow", clientId = 8021, sell = 8000 },
	{ itemName = "crystal crossbow", clientId = 16163, sell = 35000 },
	{ itemName = "hive bow", clientId = 14246, sell = 28000 },
	{ itemName = "leaf star", clientId = 25735, sell = 50 },
	{ itemName = "chain bolter", clientId = 8022, sell = 40000 },
	{ itemName = "prismatic bolt", clientId = 16141, buy = 20 },
	{ itemName = "arrow", clientId = 3447, buy = 3 },
	{ itemName = "small stone", clientId = 1781, buy = 30 },
	{ itemName = "bolt", clientId = 3446, buy = 4 },
	{ itemName = "bow", clientId = 3350, buy = 400 },
	{ itemName = "crossbow", clientId = 3349, buy = 500 },
	{ itemName = "crystalline arrow", clientId = 15793, buy = 20 },
	{ itemName = "drill bolt", clientId = 16142, buy = 12 },
	{ itemName = "earth arrow", clientId = 774, buy = 5 },
	{ itemName = "envenomed arrow", clientId = 16143, buy = 12 },
	{ itemName = "assassin star", clientId = 7368, buy = 100 },
	{ itemName = "flaming arrow", clientId = 763, buy = 5 },
	{ itemName = "flash arrow", clientId = 761, buy = 5 },
	{ itemName = "onyx arrow", clientId = 7365, buy = 7 },
	{ itemName = "piercing bolt", clientId = 7363, buy = 5 },
	{ itemName = "power bolt", clientId = 3450, buy = 7 },
	{ itemName = "royal spear", clientId = 7378, buy = 15 },
	{ itemName = "shiver arrow", clientId = 762, buy = 5 },
	{ itemName = "sniper arrow", clientId = 7364, buy = 5 },
	{ itemName = "spear", clientId = 3277, buy = 9 },
	{ itemName = "tarsal arrow", clientId = 14251, buy = 6 },
	{ itemName = "throwing star", clientId = 3287, buy = 21 },
	{ itemName = "vortex bolt", clientId = 14252, buy = 6 },
	{ itemName = "diamond arrow", clientId = 35901, buy = 90 },
	{ itemName = "spectral bolt", clientId = 35902, buy = 70 },
}

-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType) end

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)
npcType:register(npcConfig)
