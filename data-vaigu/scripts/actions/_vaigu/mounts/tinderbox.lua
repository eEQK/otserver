local config = {
	item = 20357,
	target = 20356,
	reward = 20355,
}

local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == config.item and target.itemid == config.target then
		item:remove(1)
		target:remove(1)
		player:addItem(config.reward, 1)
	end

	return true
end

action:id(20357)
action:register()
