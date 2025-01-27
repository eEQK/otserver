local internalNpcName = "Tim, The Guard"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 131,
	lookHead = 0,
	lookBody = 19,
	lookLegs = 19,
	lookFeet = 19,
	lookAddons = 0,
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if (MsgContains(message, "trouble") or MsgContains(message, "problemy")) and player:getStorageValue(Storage.TheInquisition.TimGuard) < 1 and player:getStorageValue(Storage.TheInquisition.Mission01) ~= -1 then
		npcHandler:say(getPlayerLanguage(player) == "PL" and "Ehh, nic takiego.. Szczoteczka do zebow wpadla mi dzis do kibla." or "Ah, well. Just this morning my new toothbrush fell into the toilet.", npc, creature)
		if player:getStorageValue(Storage.TheInquisition.TimGuard) < 1 then
			player:setStorageValue(Storage.TheInquisition.TimGuard, 1)
			player:setStorageValue(Storage.TheInquisition.Mission01, player:getStorageValue(Storage.TheInquisition.Mission01) + 1) -- The Inquisition Questlog- "Mission 1: Interrogation"
			player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
		end
	end
	return true
end

keywordHandler:addKeyword({ "job" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Moim zajeciem jest obrona miasta.",
})

npcHandler:setMessage(MESSAGE_GREET, "NIECH ZYJE KROL!")
npcHandler:setMessage(MESSAGE_FAREWELL, "NIECH ZYJE KROL!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "NIECH ZYJE KROL!")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)
npcType:register(npcConfig)
