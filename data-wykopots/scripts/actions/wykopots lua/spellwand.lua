local monsters = { "Rat", "Green Frog", "Chicken" }

local spellwand = Action()

function spellwand.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getTile():hasFlag(TILESTATE_PROTECTIONZONE) then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return true
	end
	if not target:isPlayer() then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return true
	end
	if math.random(100) <= 25 then
		item:remove()
		player:say("The spellwand broke.", TALKTYPE_MONSTER_SAY)
		if math.random(100) <= 75 and player:getStorageValue(Storage.madSheepSummon) <= os.time() then
			Game.createMonster("Mad Sheep", fromPosition)
			--player:setStorageValue(Storage.madSheepSummon, os.time() + 60 * 60)
		end
	else
		target:setMonsterOutfit(monsters[math.random(#monsters)], 60 * 1000)
		target:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		return true
	end
	return true
end

spellwand:id(651)
spellwand:register()