local defenseCondition = Condition(CONDITION_ATTRIBUTES)
defenseCondition:setParameter(CONDITION_PARAM_SUBID, JeanPierreDefense)
defenseCondition:setParameter(CONDITION_PARAM_BUFF_SPELL, 1)
defenseCondition:setParameter(CONDITION_PARAM_TICKS, 60 * 60 * 1000)
defenseCondition:setParameter(CONDITION_PARAM_SKILL_SHIELD, 10)
defenseCondition:setParameter(CONDITION_PARAM_FORCEUPDATE, true)

local errorMessage = "You need to wait before using it again."
local roastedDragonWings = Action()

function roastedDragonWings.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local canUse = player:canUseCooldownItem("special-foods-cooldown")
	if not canUse then
		player:say(errorMessage)
	end

	if IsOnEvent(player) then
		player:sendCancelMessage("You cannot eat dishes on this event.")
		return true
	end
	
	player:addCondition(defenseCondition)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You feel less vulnerable.")
	player:say("Chomp.", TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	player:setExhaustion("special-foods-cooldown", 10 * 60)
	item:remove(1)
	return true
end

roastedDragonWings:id(9081)
roastedDragonWings:register()
