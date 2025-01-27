local startupItemsPetrus = {
	{ pos = { 0, 2, 0 }, id = 1949, aid = Storage.BezpieczenstwoIHigienaPracy.Portals.ToMagicianTown },
	{ pos = { 0, 3, 4 }, id = 7348, aid = Storage.BezpieczenstwoIHigienaPracy.Spawns.Petrus },
}

local startupItemsStatic = {
	{ pos = { 6121, 1488, 5 }, id = 4399, aid = Storage.BezpieczenstwoIHigienaPracy.KrolTile },
}

local startupItemsMagicians = {
	{ pos = { 22, 11, -5 }, id = 1949, aid = Storage.BezpieczenstwoIHigienaPracy.Portals.ToPetrus },
}

local npcs = {
	{ name = "xXxTurdstinxXx", pos = { 5921, 1626, 7 } },
	{ name = "xe'na", pos = { 5741, 1500, 5 } },
	{ name = "rat of kings", pos = { 6118, 1490, 6 } },
}

local function resetSpawnLocks()
	for _, spawnLock in pairs(Storage.BezpieczenstwoIHigienaPracy.Spawns) do
		Game.setStorageValue(spawnLock, 0)
	end
end

local bhpInit = GlobalEvent("bezpieczenstwoIHigienaPracyInit")
function bhpInit.onStartup()
	LoadStartupItems(startupItemsPetrus, PETRUS_CIEMIEZCA_ANCHOR)
	LoadStartupItems(startupItemsMagicians, MIRKO_MAGICIANS_ANCHOR)
	LoadStartupItems(startupItemsStatic)
	LoadStartupNpc(npcs)
	resetSpawnLocks()
end
bhpInit:register()
