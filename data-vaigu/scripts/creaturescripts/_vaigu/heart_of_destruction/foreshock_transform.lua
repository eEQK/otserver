local foreshockTransform = CreatureEvent("ForeshockTransform")
function foreshockTransform.onThink(creature)
	if not creature:isMonster() then
		return true
	end

	local sparkOfDestructionPositions = {
		{ x = 5436, y = 1374, z = 14 },
		{ x = 5438, y = 1379, z = 14 },
		{ x = 5443, y = 1379, z = 14 },
		{ x = 5445, y = 1374, z = 14 },
	}

	local monsterTable = {
		[80] = { fromStage = 0, toStage = 1 },
		[60] = { fromStage = 1, toStage = 2 },
		[40] = { fromStage = 2, toStage = 3 },
		[20] = { fromStage = 3, toStage = 4 },
		[10] = { fromStage = 4, toStage = 5 },
	}

	for index, value in pairs(monsterTable) do
		local hp = (creature:getHealth() / creature:getMaxHealth()) * 100
		foreshockHealth = creature:getHealth()
		if hp <= index and foreshockStage == value.fromStage then
			creature:remove()
			for i = 1, #sparkOfDestructionPositions do
				Game.createMonster("spark of destruction", sparkOfDestructionPositions[i], false, true)
			end
			local monster = Game.createMonster("aftershock", { x = 5441, y = 1376, z = 14 }, false, true)
			monster:addHealth(-monster:getHealth() + aftershockHealth, COMBAT_PHYSICALDAMAGE)
			foreshockStage = value.toStage
		end
	end
	return true
end
foreshockTransform:register()
