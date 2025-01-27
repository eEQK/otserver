/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "creatures/monsters/monster.hpp"
#include "creatures/players/player.hpp"
#include "config/configmanager.hpp"
#include "game/game.hpp"
#include "io/ioprey.hpp"
#include "lib/metrics/metrics.hpp"

// Prey class
PreySlot::PreySlot(PreySlot_t id) :
	id(id) {
	state = PreyDataState_Selection;
	option = PreyOption_None;
	bonusPercentage = 5;
	bonusRarity = 1;
	selectedRaceId = 0;
	freeRerollTimeStamp = OTSYS_TIME() + g_configManager().getNumber(PREY_FREE_REROLL_TIME, __FUNCTION__) * 1000;
}

void IOPrey::initializePreyMonsters() {
	std::map<std::string, std::shared_ptr<MonsterType>> monsters = g_monsters().monsters;
	for (std::pair<std::string, std::shared_ptr<MonsterType>> monster : monsters) {
		MonsterType* monsterType = monster.second.get();
		auto &monsterInfo = monsterType->info;
		auto &name = monsterType->typeName;
		if (monsterInfo.raceid <= 0) {
			continue;
		}
		if (!whitelist.contains(name)) {
			continue;
		}

		double raceid = monsterInfo.raceid;
		double healthMax = monsterInfo.healthMax;
		double experience = monsterInfo.experience;
		double difficulty = floor((1 + experience / healthMax) * healthMax);

		PreyMonster preyMonster;
		preyMonster.name = name;
		preyMonster.raceid = raceid;
		preyMonster.difficulty = difficulty;
		preyMonsters.push_back(preyMonster);
	}
}

void PreyMonsterBuilder::init() {
	monsters = g_ioprey().preyMonsters;
	std::random_device rd;
	std::mt19937 rng(rd());
	std::shuffle(monsters.begin(), monsters.end(), rng);
}

void PreyMonsterBuilder::filterByLevel(uint32_t level) {
	const double baseIndex = 2 * (level * pow(std::log10(level), 2) * 2 + 1);
	double minDifficulty = baseIndex * 2 - 100;
	double maxDifficulty = baseIndex * (1 + std::log10(baseIndex)) + 100;
	if (level >= 200) {
		minDifficulty = 4500.0;
		maxDifficulty = std::numeric_limits<double>::max();
	}

	std::vector<PreyMonster> result;
	for (PreyMonster preyMonster : monsters) {
		double difficulty = preyMonster.difficulty;
		if (minDifficulty <= difficulty && difficulty <= maxDifficulty) {
			result.push_back(preyMonster);
		}
		if (result.size() >= 36) {
			break;
		}
	}
	monsters = result;
}

void PreyMonsterBuilder::trim(uint16_t newSize) {
	std::vector<PreyMonster> result;
	for (PreyMonster preyMonster : monsters) {
		result.push_back(preyMonster);
		if (result.size() >= 9) {
			break;
		}
	}
	monsters = result;
}

void PreyMonsterBuilder::filterByBlacklist(std::vector<uint16_t> raceIdBlacklist) {
	std::vector<PreyMonster> result;
	for (PreyMonster preyMonster : monsters) {
		if (std::find(raceIdBlacklist.begin(), raceIdBlacklist.end(), preyMonster.raceid) == raceIdBlacklist.end()) {
			result.push_back(preyMonster);
		}
		if (result.size() >= PreyGridSize) {
			break;
		}
	}
	monsters = result;
}

std::vector<PreyMonster> PreyMonsterBuilder::get() {
	return monsters;
}

// Vaigu custom
void PreySlot::reloadMonsterGrid(std::vector<uint16_t> raceIdBlacklist, uint32_t level) {
	if (!g_configManager().getBoolean(PREY_ENABLED, __FUNCTION__)) {
		return;
	}

	raceIdList.clear();

	PreyMonsterBuilder builder;
	builder.init();
	builder.filterByLevel(level);
	builder.filterByBlacklist(raceIdBlacklist);
	builder.trim(PreyGridSize);
	std::vector<PreyMonster> filteredMonsters = builder.get();
	for (auto &preyMonster : filteredMonsters) {
		const auto raceid = preyMonster.raceid;
		raceIdList.push_back(raceid);
	}
}

// Task hunting class
TaskHuntingSlot::TaskHuntingSlot(PreySlot_t id) :
	id(id) {
	freeRerollTimeStamp = OTSYS_TIME() + g_configManager().getNumber(TASK_HUNTING_FREE_REROLL_TIME, __FUNCTION__) * 1000;
}

void TaskHuntingSlot::reloadMonsterGrid(std::vector<uint16_t> blackList, uint32_t level) {
	raceIdList.clear();

	if (!g_configManager().getBoolean(TASK_HUNTING_ENABLED, __FUNCTION__)) {
		return;
	}

	// Disabling task hunting system if the server have less then 36 registered monsters on bestiary because:
	// - Impossible to generate random lists without duplications on slots.
	// - Stress the server with unnecessary loops.
	std::map<uint16_t, std::string> bestiary = g_game().getBestiaryList();
	if (bestiary.size() < 36) {
		return;
	}

	uint8_t stageOne;
	uint8_t stageTwo;
	uint8_t stageThree;
	uint8_t stageFour;
	if (auto levelStage = static_cast<uint32_t>(std::floor(level / 100));
	    levelStage == 0) { // From level 0 to 99
		stageOne = 3;
		stageTwo = 3;
		stageThree = 2;
		stageFour = 1;
	} else if (levelStage <= 2) { // From level 100 to 299
		stageOne = 1;
		stageTwo = 3;
		stageThree = 3;
		stageFour = 2;
	} else if (levelStage <= 4) { // From level 300 to 499
		stageOne = 1;
		stageTwo = 2;
		stageThree = 3;
		stageFour = 3;
	} else { // From level 500 to ...
		stageOne = 1;
		stageTwo = 1;
		stageThree = 3;
		stageFour = 4;
	}

	uint8_t tries = 0;
	auto maxIndex = static_cast<int32_t>(bestiary.size() - 1);
	while (raceIdList.size() < 9) {
		uint16_t raceId = (*(std::next(bestiary.begin(), uniform_random(0, maxIndex)))).first;
		tries++;

		if (std::count(blackList.begin(), blackList.end(), raceId) != 0) {
			continue;
		}

		blackList.push_back(raceId);
		const auto mtype = g_monsters().getMonsterTypeByRaceId(raceId);
		if (!mtype || mtype->info.experience == 0) {
			continue;
		} else if (stageOne != 0 && mtype->info.bestiaryStars <= 1) {
			raceIdList.push_back(raceId);
			--stageOne;
		} else if (stageTwo != 0 && mtype->info.bestiaryStars == 2) {
			raceIdList.push_back(raceId);
			--stageTwo;
		} else if (stageThree != 0 && mtype->info.bestiaryStars == 3) {
			raceIdList.push_back(raceId);
			--stageThree;
		} else if (stageFour != 0 && mtype->info.bestiaryStars >= 4) {
			raceIdList.push_back(raceId);
			--stageFour;
		} else if (tries >= 10) {
			raceIdList.push_back(raceId);
			tries = 0;
		}
	}
}

void TaskHuntingSlot::reloadReward() {
	if (!g_configManager().getBoolean(TASK_HUNTING_ENABLED, __FUNCTION__)) {
		return;
	}

	if (rarity >= 4) {
		rarity = 5;
		return;
	}

	int32_t chance;
	if (rarity == 0) {
		chance = uniform_random(0, 100);
	} else if (rarity == 1) {
		chance = uniform_random(0, 70);
	} else if (rarity == 2) {
		chance = uniform_random(0, 45);
	} else if (rarity == 3) {
		chance = uniform_random(0, 20);
	} else {
		return;
	}

	if (chance <= 5) {
		rarity = 5;
	} else if (chance <= 20) {
		rarity = 4;
	} else if (chance <= 45) {
		rarity = 3;
	} else if (chance <= 70) {
		rarity = 2;
	} else {
		rarity = 1;
	}
}

// Prey/Task hunting global class
void IOPrey::reducePlayerPreyTime(std::shared_ptr<Player> player, uint8_t timeTaken, uint16_t raceId) const {
	if (!player) {
		return;
	}
	for (uint8_t slotId = PreySlot_First; slotId <= PreySlot_Last; slotId++) {
		const auto &slot = player->getPreySlotById(static_cast<PreySlot_t>(slotId));
		if (!(slot && slot->isOccupied())) {
			continue;
		}
		if (slot.get()->selectedRaceId == raceId) {

			slot->bonusTimeLeft -= timeTaken;
			player->sendPreyTimeLeft(slot);
		}
	}
}

// Triggers when player kills a prey monster and lowers its prey time
void IOPrey::updatePlayerPreyStatus(std::shared_ptr<Player> player) const {
	if (!player) {
		return;
	}
	for (uint8_t slotId = PreySlot_First; slotId <= PreySlot_Last; slotId++) {
		const auto &slot = player->getPreySlotById(static_cast<PreySlot_t>(slotId));
		if (!(slot && slot->isOccupied())) {
			continue;
		}
		if (slot->bonusTimeLeft > 0) {
			continue;
		}

		std::string message = "";

		bool maintainBonusType = false;
		bool maintainOption = false;
		bool maintainState = true;
		bool maintainMonster = false;

		bool refreshTime = false;
		bool rerollType = false;
		uint16_t rarityPenalty = 0;

		PreyOption_t nextOption = PreyOption_None;
		PreyDataState_t nextState = PreyDataState_Selection;
		uint16_t nextRaceId = 0;

		if (slot->option == PreyOption_AutomaticReroll) {
			if (player->usePreyCards(static_cast<uint16_t>(g_configManager().getNumber(PREY_BONUS_REROLL_PRICE, __FUNCTION__)))) {
				maintainBonusType = false;
				maintainMonster = true;
				maintainOption = true;
				rarityPenalty = 3;
				refreshTime = true;
				rerollType = true;
				message = fmt::format("Your prey time has been succesfully refreshed, monster has not been changed, the bonus was randomized, and up to {} stars were deduced from this prey slot.", rarityPenalty);
			} else {
				message = "You don't have enough prey cards to enable automatic reroll when your slot expire.";
			}
		}
		if (slot->option == PreyOption_Locked) {
			if (player->usePreyCards(static_cast<uint16_t>(g_configManager().getNumber(PREY_SELECTION_LIST_PRICE, __FUNCTION__)))) {
				maintainBonusType = true;
				maintainMonster = true;
				maintainOption = true;
				refreshTime = true;
				rarityPenalty = 2;
				rerollType = false;
				message = fmt::format("Your prey time has been succesfully refreshed, monster has not been changed, and up to {} stars were deduced from this prey slot.", rarityPenalty);
			} else {
				message = "You don't have enough prey cards to lock monster and its bonus when the slot expire.";
			}
		}
		if (slot->option != PreyOption_AutomaticReroll && slot->option != PreyOption_Locked) {
			maintainBonusType = false;
			maintainMonster = false;
			maintainOption = false;
			refreshTime = false;
			rarityPenalty = 0;
			rerollType = true;
			message = "Your prey bonus has expired.";
		}

		player->sendTextMessage(MESSAGE_STATUS, message);
		slot->refreshBonus(
			maintainOption,
			maintainState,
			maintainMonster,

			nextOption,
			nextState,
			nextRaceId,

			maintainBonusType,
			refreshTime,
			rerollType,
			rarityPenalty
		);
		player->reloadPreySlot(static_cast<PreySlot_t>(slotId)); // This only sends data to client
		continue;
	}
}

// Triggers when player clicks prey action (reroll type/star, requests new random 9 monstes, chooess monster from grid etc.)
void IOPrey::parsePreyAction(std::shared_ptr<Player> player, PreySlot_t slotId, PreyAction_t action, PreyOption_t option, int8_t index, uint16_t raceId) const {
	const auto &slot = player->getPreySlotById(slotId);
	if (!slot || slot->state == PreyDataState_Locked) {
		player->sendMessageDialog("To unlock this prey slot first you must buy it on store.");
		return;
	}
	bool maintainBonusType = true;
	bool maintainOption = true;
	bool maintainState = true;
	bool maintainMonster = true;

	bool refreshTime = false;
	bool rerollType = false;
	bool rerollRarity = false;
	uint16_t rarityPenalty = 0;

	PreyOption_t nextOption = PreyOption_None;
	PreyDataState_t nextState = PreyDataState_Active;
	uint16_t nextRaceId = 0;

	if (action == PreyAction_GridReroll) {
		if (slot->freeRerollTimeStamp > OTSYS_TIME() && !g_game().removeMoney(player, player->getPreyRerollPrice(), 0, true)) {
			player->sendMessageDialog("You don't have enough money to reroll the prey slot.");
			return;
		} else if (slot->freeRerollTimeStamp <= OTSYS_TIME()) {
			slot->freeRerollTimeStamp = OTSYS_TIME() + g_configManager().getNumber(PREY_FREE_REROLL_TIME, __FUNCTION__) * 1000;
		} else {
			g_metrics().addCounter("balance_decrease", player->getPreyRerollPrice(), { { "player", player->getName() }, { "context", "prey_reroll" } });
		}

		rerollType = true;
		maintainBonusType = true;
		maintainMonster = false;
		nextOption = PreyOption_None;
		maintainOption = false;
		if (slot->bonus != PreyBonus_None) {
			nextState = PreyDataState_SelectionChangeMonster;
			maintainState = false;
		}
		slot->reloadMonsterGrid(player->getPreyBlackList(), player->getLevel());
	} else if (action == PreyAction_GridSelection) {
		if (slot->isOccupied()) {
			player->sendMessageDialog("You already have an active monster on this prey slot.");
			return;
		} else if (!slot->canSelect() || index == -1 || (index + 1) > slot->raceIdList.size()) {
			player->sendMessageDialog("There was an error while processing your action. Please try reopening the prey window.");
			return;
		} else if (player->getPreyWithMonster(slot->raceIdList[index])) {
			player->sendMessageDialog("This creature is already selected on another slot.");
			return;
		}

		rarityPenalty = 1;
		nextState = PreyDataState_Active;
		maintainState = false;
		nextRaceId = slot->raceIdList[index];
		maintainMonster = false;
		refreshTime = true;
	} else if (action == PreyAction_ListAll_Cards) {
		if (!player->usePreyCards(static_cast<uint16_t>(g_configManager().getNumber(PREY_SELECTION_LIST_PRICE, __FUNCTION__)))) {
			player->sendMessageDialog("You don't have enough prey cards to choose a monsters on the list.");
			return;
		}

		maintainMonster = false;
		nextState = PreyDataState_ListSelection;
		maintainState = false;
	} else if (action == PreyAction_ListAll_Selection) {
		const auto mtype = g_monsters().getMonsterTypeByRaceId(raceId);
		if (slot->isOccupied()) {
			player->sendMessageDialog("You already have an active monster on this prey slot.");
			return;
		} else if (!slot->canSelect() || slot->state != PreyDataState_ListSelection) {
			player->sendMessageDialog("There was an error while processing your action. Please try reopening the prey window.");
			return;
		} else if (player->getPreyWithMonster(raceId)) {
			player->sendMessageDialog("This creature is already selected on another slot.");
			return;
		}

		rerollType = true;
		nextRaceId = raceId;
		maintainMonster = false;
		rarityPenalty = 3;
		nextState = PreyDataState_Active;
		maintainState = false;
		refreshTime = true;
	} else if (action == PreyAction_BonusReroll) {
		if (!slot->isOccupied()) {
			player->sendMessageDialog("You don't have any active monster on this prey slot.");
			return;
		} else if (!player->usePreyCards(static_cast<uint16_t>(g_configManager().getNumber(PREY_BONUS_REROLL_PRICE, __FUNCTION__)))) {
			player->sendMessageDialog("You don't have enough prey cards to reroll this prey slot bonus type.");
			return;
		}

		refreshTime = true;
		rerollType = true;
		rerollRarity = true;
	} else if (action == PreyAction_Option) {
		if (option == PreyOption_AutomaticReroll && player->getPreyCards() < static_cast<uint64_t>(g_configManager().getNumber(PREY_BONUS_REROLL_PRICE, __FUNCTION__))) {
			player->sendMessageDialog("You don't have enough prey cards to enable automatic reroll when your slot expire.");
			return;
		} else if (option == PreyOption_Locked && player->getPreyCards() < static_cast<uint64_t>(g_configManager().getNumber(PREY_SELECTION_LIST_PRICE, __FUNCTION__))) {
			player->sendMessageDialog("You don't have enough prey cards to lock monster and bonus when the slot expire.");
			return;
		}

		maintainOption = false;
		nextOption = option;
	} else {
		g_logger().warn("[IOPrey::parsePreyAction] - Unknown prey action: {}", fmt::underlying(action));
		return;
	}

	slot->refreshBonus(
		maintainOption,
		maintainState,
		maintainMonster,

		nextOption,
		nextState,
		nextRaceId,

		maintainBonusType,
		refreshTime,
		rerollType,
		rerollRarity,
		rarityPenalty
	);
	player->reloadPreySlot(slotId);
}

void IOPrey::parseTaskHuntingAction(std::shared_ptr<Player> player, PreySlot_t slotId, PreyTaskAction_t action, bool upgrade, uint16_t raceId) const {
	const auto &slot = player->getTaskHuntingSlotById(slotId);
	if (!slot || slot->state == PreyTaskDataState_Locked) {
		player->sendMessageDialog("To unlock this task hunting slot first you must buy it on store.");
		return;
	}

	if (action == PreyTaskAction_ListReroll) {
		if (slot->disabledUntilTimeStamp >= OTSYS_TIME()) {
			std::ostringstream ss;
			ss << "You need to wait " << ((slot->disabledUntilTimeStamp - OTSYS_TIME()) / 60000) << " minutes to select a new creature on task.";
			player->sendMessageDialog(ss.str());
			return;
		} else if (slot->freeRerollTimeStamp > OTSYS_TIME() && !g_game().removeMoney(player, player->getTaskHuntingRerollPrice(), 0, true)) {
			player->sendMessageDialog("You don't have enough money to reroll the task hunting slot.");
			return;
		} else if (slot->freeRerollTimeStamp <= OTSYS_TIME()) {
			slot->freeRerollTimeStamp = OTSYS_TIME() + g_configManager().getNumber(TASK_HUNTING_FREE_REROLL_TIME, __FUNCTION__) * 1000;
		} else {
			g_metrics().addCounter("balance_decrease", player->getTaskHuntingRerollPrice(), { { "player", player->getName() }, { "context", "hunting_task_reroll" } });
		}

		slot->eraseTask();
		slot->reloadReward();
		slot->state = PreyTaskDataState_Selection;
		slot->reloadMonsterGrid(player->getTaskHuntingBlackList(), player->getLevel());
	} else if (action == PreyTaskAction_RewardsReroll) {
		if (!player->usePreyCards(static_cast<uint16_t>(g_configManager().getNumber(TASK_HUNTING_BONUS_REROLL_PRICE, __FUNCTION__)))) {
			player->sendMessageDialog("You don't have enough prey cards to reroll you task reward rarity.");
			return;
		}

		slot->reloadReward();
	} else if (action == PreyTaskAction_ListAll_Cards) {
		if (slot->disabledUntilTimeStamp >= OTSYS_TIME()) {
			std::ostringstream ss;
			ss << "You need to wait " << ((slot->disabledUntilTimeStamp - OTSYS_TIME()) / 60000) << " minutes to select a new creature on task.";
			player->sendMessageDialog(ss.str());
			return;
		} else if (!player->usePreyCards(static_cast<uint16_t>(g_configManager().getNumber(TASK_HUNTING_SELECTION_LIST_PRICE, __FUNCTION__)))) {
			player->sendMessageDialog("You don't have enough prey cards to choose a creature on list for you task hunting slot.");
			return;
		}

		slot->selectedRaceId = 0;
		slot->state = PreyTaskDataState_ListSelection;
	} else if (action == PreyTaskAction_MonsterSelection) {
		if (slot->disabledUntilTimeStamp >= OTSYS_TIME()) {
			std::ostringstream ss;
			ss << "You need to wait " << ((slot->disabledUntilTimeStamp - OTSYS_TIME()) / 60000) << " minutes to select a new creature on task.";
			player->sendMessageDialog(ss.str());
			return;
		} else if (!slot->canSelect()) {
			player->sendMessageDialog("There was an error while processing your action. Please try reopening the task window.");
			return;
		} else if (slot->isOccupied()) {
			player->sendMessageDialog("You already have an active monster on this task hunting slot.");
			return;
		} else if (slot->state == PreyTaskDataState_Selection && !slot->isCreatureOnList(raceId)) {
			player->sendMessageDialog("There was an error while processing your action. Please try reopening the task window.");
			return;
		} else if (player->getTaskHuntingWithCreature(raceId)) {
			player->sendMessageDialog("This creature is already selected on another slot.");
			return;
		}

		if (const auto mtype = g_monsters().getMonsterTypeByRaceId(raceId)) {
			slot->currentKills = 0;
			slot->selectedRaceId = raceId;
			slot->removeMonsterType(raceId);
			slot->state = PreyTaskDataState_Active;
			slot->upgrade = upgrade && player->isCreatureUnlockedOnTaskHunting(mtype);
		}
	} else if (action == PreyTaskAction_Cancel) {
		if (!g_game().removeMoney(player, player->getTaskHuntingRerollPrice(), 0, true)) {
			player->sendMessageDialog("You don't have enough money to cancel your current task hunting.");
			return;
		}

		g_metrics().addCounter("balance_decrease", player->getTaskHuntingRerollPrice(), { { "player", player->getName() }, { "context", "hunting_task_cancel" } });
		slot->eraseTask();
		slot->reloadReward();
		slot->state = PreyTaskDataState_Selection;
		slot->reloadMonsterGrid(player->getTaskHuntingBlackList(), player->getLevel());
	} else if (action == PreyTaskAction_Claim) {
		if (!slot->isOccupied()) {
			player->sendMessageDialog("You cannot claim your task reward with an empty task hunting slot.");
			return;
		}

		if (const auto &option = getTaskRewardOption(slot)) {
			uint64_t reward;
			int32_t boostChange = uniform_random(0, 100);
			if (slot->rarity >= 4 && boostChange <= 5) {
				boostChange = 20;
			} else if (slot->rarity >= 4 && boostChange <= 10) {
				boostChange = 15;
			} else {
				boostChange = 10;
			}

			if (slot->upgrade && slot->currentKills >= option->secondKills) {
				reward = option->secondReward;
			} else if (!slot->upgrade && slot->currentKills >= option->firstKills) {
				reward = option->firstReward;
			} else {
				player->sendMessageDialog("There was an error while processing you task hunting reward. Please try reopening the window.");
				return;
			}

			std::ostringstream ss;
			reward = static_cast<uint64_t>(std::ceil((reward * boostChange) / 10));
			ss << "Congratulations! You have earned " << reward;
			if (boostChange == 20) {
				ss << " Hunting Task points including a 100% bonus.";
			} else if (boostChange == 15) {
				ss << " Hunting Task points including a 50% bonus.";
			} else {
				ss << " Hunting Task points.";
			}

			slot->eraseTask();
			slot->reloadReward();
			slot->state = PreyTaskDataState_Inactive;
			player->addTaskHuntingPoints(reward);
			player->sendMessageDialog(ss.str());
			slot->reloadMonsterGrid(player->getTaskHuntingBlackList(), player->getLevel());
			slot->disabledUntilTimeStamp = OTSYS_TIME() + g_configManager().getNumber(TASK_HUNTING_LIMIT_EXHAUST, __FUNCTION__) * 1000;
		}
	} else {
		g_logger().warn("[IOPrey::parseTaskHuntingAction] - Unknown task action: {}", fmt::underlying(action));
		return;
	}
	player->reloadTaskSlot(slotId);
}

void IOPrey::initializeTaskHuntOptions() {
	if (!g_configManager().getBoolean(TASK_HUNTING_ENABLED, __FUNCTION__)) {
		return;
	}

	// Move it to config.lua

	// Kill stage is the multiplier for kills and rewards on task hunting
	uint8_t killStage = 25;

	// This is hardcoded on client but i'm saving it in case that they change it in the future
	uint8_t limitOfStars = 5;
	uint16_t kills = killStage;
	NetworkMessage msg;
	for (uint8_t difficulty = PreyTaskDifficult_First; difficulty <= PreyTaskDifficult_Last; ++difficulty) { // Difficulties of creatures on bestiary.
		auto reward = static_cast<uint16_t>(std::round((10 * kills) / killStage));
		// Amount of task stars on task hunting
		for (uint8_t star = 1; star <= limitOfStars; ++star) {
			const auto &option = taskOption.emplace_back(std::make_unique<TaskHuntingOption>());

			option->difficult = static_cast<PreyTaskDifficult_t>(difficulty);
			option->rarity = star;

			option->firstKills = kills;
			option->firstReward = reward;

			option->secondKills = kills * 2;
			option->secondReward = reward * 2;

			reward = static_cast<uint16_t>(std::round((reward * (115 + (difficulty * limitOfStars))) / 100));
		}

		kills *= 4;
	}

	msg.addByte(0xBA);
	std::map<uint16_t, std::string> bestiaryList = g_game().getBestiaryList();
	msg.add<uint16_t>(static_cast<uint16_t>(bestiaryList.size()));
	std::for_each(bestiaryList.begin(), bestiaryList.end(), [&msg](auto mType) {
		const auto mtype = g_monsters().getMonsterType(mType.second);
		if (!mtype) {
			return;
		}

		msg.add<uint16_t>(mtype->info.raceid);
		if (mtype->info.bestiaryStars <= 1) {
			msg.addByte(0x01);
		} else if (mtype->info.bestiaryStars <= 3) {
			msg.addByte(0x02);
		} else {
			msg.addByte(0x03);
		}
	});

	msg.addByte(static_cast<uint8_t>(taskOption.size()));
	std::for_each(taskOption.begin(), taskOption.end(), [&msg](const std::unique_ptr<TaskHuntingOption> &option) {
		msg.addByte(static_cast<uint8_t>(option->difficult));
		msg.addByte(option->rarity);
		msg.add<uint16_t>(option->firstKills);
		msg.add<uint16_t>(option->firstReward);
		msg.add<uint16_t>(option->secondKills);
		msg.add<uint16_t>(option->secondReward);
	});
	baseDataMessage = msg;
}

const std::unique_ptr<TaskHuntingOption> &IOPrey::getTaskRewardOption(const std::unique_ptr<TaskHuntingSlot> &slot) const {
	if (!slot) {
		return TaskHuntingOptionNull;
	}

	const auto mtype = g_monsters().getMonsterTypeByRaceId(slot->selectedRaceId);
	if (!mtype) {
		return TaskHuntingOptionNull;
	}

	PreyTaskDifficult_t difficult;
	if (mtype->info.bestiaryStars <= 1) {
		difficult = PreyTaskDifficult_Easy;
	} else if (mtype->info.bestiaryStars <= 3) {
		difficult = PreyTaskDifficult_Medium;
	} else {
		difficult = PreyTaskDifficult_Hard;
	}

	auto it = std::find_if(taskOption.begin(), taskOption.end(), [difficult, &slot](const std::unique_ptr<TaskHuntingOption> &optionIt) {
		return optionIt->difficult == difficult && optionIt->rarity == slot->rarity;
	});

	if (it != taskOption.end()) {
		return *it;
	}

	return TaskHuntingOptionNull;
}
