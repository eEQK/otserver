local setting = {
	centerRoom = { x = 33487, y = 32111, z = 9 },
	range = 10,
	entranceTiles = {
		{ x = 33583, y = 31844, z = 10 },
		{ x = 33584, y = 31844, z = 10 },
		{ x = 33585, y = 31844, z = 10 },
		{ x = 33586, y = 31844, z = 10 },
		{ x = 33587, y = 31844, z = 10 },
	},
	newPositions = {
		{ x = 33486, y = 32120, z = 9 },
		{ x = 33486, y = 32120, z = 9 },
		{ x = 33486, y = 32120, z = 9 },
		{ x = 33486, y = 32120, z = 9 },
		{ x = 33486, y = 32120, z = 9 },
	},
	minionPositions = {
		{ x = 33482, y = 32105, z = 9 },
		{ x = 33484, y = 32105, z = 9 },
		{ x = 33484, y = 32107, z = 9 },
		{ x = 33481, y = 32109, z = 9 },
		{ x = 33482, y = 32111, z = 9 },
		{ x = 33488, y = 32106, z = 9 },
		{ x = 33490, y = 32106, z = 9 },
		{ x = 33492, y = 32109, z = 9 },
		{ x = 33492, y = 32112, z = 9 },
		{ x = 33490, y = 32112, z = 9 },
	},
}

local leverDeathPriestShargon = Action()
function leverDeathPriestShargon.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 2772 then
		if roomIsOccupied(setting.centerRoom, false, setting.range, setting.range) then
			player:say("Someone is fighting against the boss! You need wait awhile.", TALKTYPE_MONSTER_SAY)
			return true
		end

		local storePlayers, playerTile = {}
		for i = 1, #setting.entranceTiles do
			local creature = Tile(setting.entranceTiles[i]):getTopCreature()
			if not creature or not creature:isPlayer() then
				player:sendCancelMessage("You need 5 of players to fight with Death Priest Shargon.")
				return true
			end
			storePlayers[#storePlayers + 1] = playerTile
		end

		for i = 1, #config.minionPositions do
			Game.createMonster("greater death minion", config.minionPositions[i])
		end
		Game.createMonster("death priest shargon", { x = 33487, y = 32108, z = 9 })

		local players
		for i = 1, #storePlayers do
			players = storePlayers[i]
			config.entranceTiles[i]:sendMagicEffect(CONST_ME_POFF)
			players:teleportTo(config.newPositions[i])
			config.newPositions[i]:sendMagicEffect(CONST_ME_ENERGYAREA)
		end
		item:transform(2773)
	elseif item.itemid == 2773 then
		item:transform(2772)
	end
	return true
end

leverDeathPriestShargon:uid(30002)
leverDeathPriestShargon:register()
