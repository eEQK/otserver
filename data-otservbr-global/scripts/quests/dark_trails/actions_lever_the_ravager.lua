local setting = {
	centerRoom = { x = 33487, y = 32079, z = 8 },
	range = 10,
	entranceTiles = {
		Position(33417, 32102, 10),
		Position(33418, 32102, 10),
		Position(33419, 32102, 10),
		Position(33420, 32102, 10),
	},
	newPositions = {
		Position(33487, 32088, 8),
		Position(33487, 32088, 8),
		Position(33487, 32088, 8),
		Position(33487, 32088, 8),
	},
	canopicJarPositions = {
		Position(33486, 32081, 8),
		Position(33488, 32081, 8),
		Position(33486, 32083, 8),
		Position(33488, 32083, 8),
	},
}

local leverTheRavager = Action()
function leverTheRavager.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 2772 then
		if roomIsOccupied(setting.centerRoom, false, setting.range, setting.range) then
			player:say("Someone is fighting against the boss! You need wait awhile.", TALKTYPE_MONSTER_SAY)
			return true
		end

		local storePlayers, playerTile = {}
		for i = 1, #setting.entranceTiles do
			local creature = Tile(setting.entranceTiles[i]):getTopCreature()
			if not creature or not creature:isPlayer() then
				player:sendCancelMessage("You need 4 of players to fight with The Ravager.")
				return true
			end
			storePlayers[#storePlayers + 1] = playerTile
		end

		for i = 1, #setting.canopicJarPositions do
			Game.createMonster("greater canopic jar", setting.canopicJarPositions[i])
		end
		Game.createMonster("the ravager", { x = 33487, y = 32108, z = 9 })

		local players
		for i = 1, #storePlayers do
			players = storePlayers[i]
			setting.entranceTiles[i]:sendMagicEffect(CONST_ME_POFF)
			players:teleportTo(setting.newPositions[i])
			setting.newPositions[i]:sendMagicEffect(CONST_ME_ENERGYAREA)
		end
		item:transform(2773)
	elseif item.itemid == 2773 then
		item:transform(2772)
	end
	return true
end

leverTheRavager:uid(30001)
leverTheRavager:register()
