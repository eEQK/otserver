local doorPosition = Position(6545, 796, 6) -- koordy drzwi co sie zamkna  {x = 6545, y = 796, z = 6}
local shadowNexusPosition = Position(6721, 1798, 11) -- magic wall na nexusie {x = 6721, y = 1798, z = 11}
local effectPositions = {
	Position(6720, 1798, 11), --lewa kosc {x = 6720, y = 1798, z = 11}
	Position(6722, 1798, 11), -- prawa kosc {x = 6722, y = 1798, z = 11}
}

local function revertItem(position, itemId, transformId)
	local item = Tile(position):getItemById(itemId)
	if item then
		item:transform(transformId)
	end
end

local function nexusMessage(player, message)
	local spectators = Game.getSpectators(shadowNexusPosition, false, true, 3, 3)
	for i = 1, #spectators do
		player:say(message, TALKTYPE_MONSTER_YELL, false, spectators[i], shadowNexusPosition)
	end
end

local storages = {
	[4008] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave1,
	[4009] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave2,
	[4010] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave3,
	[4011] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave4,
	[4012] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave5,
	[4013] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave6,
	[4014] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave7,
	[4015] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave8,
	[4016] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave9,
	[4017] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave10,
	[4018] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave11,
	[4019] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave12,
	[4020] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave13,
	[4021] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave14,
	[4022] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave15,
	[4023] = Storage.TibiaTales.RestInHallowedGround.Graves.Grave16,
}

local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- Eclipse
	if target.actionid == 2000 then
		if player:getStorageValue(Storage.TheInquisition.Questline) ~= 4 then
			return true
		end
		item:remove(1)
		toPosition:sendMagicEffect(CONST_ME_FIREAREA)
		-- The Inquisition Questlog- 'Mission 2: Eclipse'
		player:setStorageValue(Storage.TheInquisition.Mission02, 2)
		player:setStorageValue(Storage.TheInquisition.Questline, 5)
		return true

	-- Haunted Ruin
	elseif target.actionid == 2003 then
		if player:getStorageValue(Storage.TheInquisition.Questline) ~= 12 then
			return true
		end

		Game.createMonster("Pirate Ghost", toPosition)
		item:remove(1)

		-- The Inquisition Questlog- 'Mission 4: The Haunted Ruin'
		player:setStorageValue(Storage.TheInquisition.Questline, 13)
		player:setStorageValue(Storage.TheInquisition.Mission04, 2)

		local doorItem = Tile(doorPosition):getItemById(7869) -- id otwartych drzwi
		if doorItem then
			doorItem:transform(7868) -- id zamknietych drzwi
		end
		addEvent(revertItem, 10 * 1000, doorPosition, 7868, 7869)
		return true
	end

	-- Shadow Nexus
	if isInArray({ 7925, 7927, 7929 }, target.itemid) then
		target:transform(target.itemid + 1)
		target:decay()
		nexusMessage(player, player:getName() .. " damaged the shadow nexus! You can't damage it while it's burning.")
		shadowNexusPosition:sendMagicEffect(CONST_ME_HOLYAREA)
	elseif target.itemid == 7931 then
		local NexusPos = { x = 6721, y = 1798, z = 11 }
		function RemoveNexus()
			local nexus = getTileItemById(NexusPos, 7931) -- nexus na koordach
			if nexus then --jak jest
				doRemoveItem(nexus.uid, 1) --to go usuwa
			end
			return true
		end

		function onTimer()
			local item = Game.createItem(7925, 1, NexusPos)
			Game.setStorageValue(GlobalStorage.NexusLock, 0)
		end

		if Game.getStorageValue(GlobalStorage.NexusLock) ~= 1 then
			Game.setStorageValue(GlobalStorage.NexusLock, 1)
			addEvent(RemoveNexus, 20000)
			addEvent(onTimer, 20100)
		end

		if player:getStorageValue(Storage.TheInquisition.Questline) < 22 then
			-- The Inquisition Questlog- 'Mission 7: The Shadow Nexus'
			player:setStorageValue(Storage.TheInquisition.Mission07, 2)
			player:setStorageValue(Storage.TheInquisition.Questline, 22)
		end

		for i = 1, #effectPositions do
			effectPositions[i]:sendMagicEffect(CONST_ME_HOLYAREA)
		end

		nexusMessage(player, player:getName() .. " destroyed the shadow nexus! In 20 seconds it will return to its original state.")
		item:remove(1)
	elseif target.actionid > 4007 and target.actionid < 4024 then
		local graveStorage = storages[target.actionid]
		if player:getStorageValue(graveStorage) == 1 or player:getStorageValue(Storage.TibiaTales.RestInHallowedGround.Questline) ~= 3 then
			return false
		end

		player:setStorageValue(graveStorage, 1)

		local cStorage = player:getStorageValue(Storage.TibiaTales.RestInHallowedGround.HolyWater)
		if cStorage < 14 then
			player:setStorageValue(Storage.TibiaTales.RestInHallowedGround.HolyWater, math.max(0, cStorage) + 1)
		elseif cStorage == 14 then
			player:setStorageValue(Storage.TibiaTales.RestInHallowedGround.HolyWater, -1)
			player:setStorageValue(Storage.TibiaTales.RestInHallowedGround.Questline, 4)
			item:transform(2874, 0)
		end

		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end
	return true
end

action:id(7494)
action:register()
