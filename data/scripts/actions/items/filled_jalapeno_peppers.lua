local speedCondition = Condition(CONDITION_HASTE)
speedCondition:setParameter(CONDITION_PARAM_TICKS, 60 * 60 * 1000)
speedCondition:setParameter(CONDITION_PARAM_SPEED, 729)

local filledJalapenoPeppers = Action()

function filledJalapenoPeppers.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local errorMessage = player:errorIfCannotUseCooldownItem("special-foods-cooldown")
	if errorMessage then
		player:say(errorMessage)
	end

	player:addCondition(speedCondition)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your speed has been increased.")
	player:say("Munch.", TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	player:setExhaustion("special-foods-cooldown", 10 * 60)
	item:remove(1)
	return true
end

filledJalapenoPeppers:id(9085)
filledJalapenoPeppers:register()
