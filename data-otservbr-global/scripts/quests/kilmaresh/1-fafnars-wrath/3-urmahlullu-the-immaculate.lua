-- lever to urmahlullu room

local config = {
	requiredLevel = 100,
	daily = true,
	roomCenterPosition = Position(33919, 31648, 8),
	playerPositions = {
		Position(33918, 31626, 8),
		Position(33919, 31626, 8),
		Position(33920, 31626, 8),
		Position(33921, 31626, 8),
		Position(33922, 31626, 8),
	},
	teleportPosition = Position(33918, 31657, 8),
	bossPosition = Position(33918, 31641, 8),
	bossName = "Urmahlullu the Immaculate",
}

local leverboss = Action()

function leverboss.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 8911 then
		-- Check if the player that pulled the lever is on the correct position
		if player:getPosition() ~= config.playerPositions[1] then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can't start the battle.")
			return true
		end

		local team, participant = {}

		for i = 1, #config.playerPositions do
			participant = Tile(config.playerPositions[i]):getTopCreature()

			-- Check there is a participant player
			if participant and participant:isPlayer() then
				-- Check participant level
				if participant:getLevel() < config.requiredLevel then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "All the players need to be level " .. config.requiredLevel .. " or higher.")
					return true
				end

				-- Check participant boss timer
				if config.daily and not participant:canFightBoss(config.bossName) then
					player:getPosition():sendMagicEffect(CONST_ME_POFF)
					player:sendCancelMessage("Not all players are ready yet from last battle.")
					return true
				end

				team[#team + 1] = participant
			end
		end

		-- Check if a team currently inside the boss room
		local specs, spec = Game.getSpectators(config.roomCenterPosition, false, false, 14, 14, 13, 13)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A team is already inside the boss room.")
				return true
			end

			spec:remove()
		end

		-- Spawn boss
		Game.createMonster("Urmahlullu the Immaculate", config.bossPosition)

		-- Teleport team participants
		for i = 1, #team do
			team[i]:getPosition():sendMagicEffect(CONST_ME_POFF)
			team[i]:teleportTo(config.teleportPosition)
			-- Assign boss timer
			team[i]:setEncounterLockout(config.bossName, os.time() + configManager.getNumber(configKeys.BOSS_DEFAULT_TIME_TO_FIGHT_AGAIN)) -- 20 hours
		end

		config.teleportPosition:sendMagicEffect(CONST_ME_ENERGYAREA)
	end

	item:transform(8911)
	return true
end

leverboss:uid(9545)
leverboss:register()
