-- main.lua

-- Implements the main plugin entrypoint





-- Configuration
--  Use prefixes or not.
--  If set to true, messages are prefixed, e. g. "[FATAL]". If false, messages are colored.
g_UsePrefixes = true





-- Global variables
Messages = {}
WorldsSpawnProtect = {}
WorldsWorldLimit = {}
WorldsWorldDifficulty = {}
lastsender = {}




-- Called by Cuberite on plugin start to initialize the plugin
function Initialize(Plugin)
	Plugin:SetName("Core")
	Plugin:SetVersion(tonumber(g_PluginInfo["Version"]))

	-- Register for all hooks needed
	cPluginManager:AddHook(cPluginManager.HOOK_CHAT,                  OnChat)
	cPluginManager:AddHook(cPluginManager.HOOK_CRAFTING_NO_RECIPE,    OnCraftingNoRecipe)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_DESTROYED,      OnDisconnect)
	cPluginManager:AddHook(cPluginManager.HOOK_KILLING,               OnKilling)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_BREAKING_BLOCK, OnPlayerBreakingBlock)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED,         OnPlayerJoined)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_MOVING,         OnPlayerMoving)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_PLACING_BLOCK,  OnPlayerPlacingBlock)
	cPluginManager:AddHook(cPluginManager.HOOK_SPAWNING_ENTITY,       OnSpawningEntity)
	cPluginManager:AddHook(cPluginManager.HOOK_TAKE_DAMAGE,           OnTakeDamage)

	-- Bind ingame commands:

	-- Load the InfoReg shared library:
	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")

	-- Bind all the commands:
	RegisterPluginInfoCommands()

	-- Bind all the console commands:
	RegisterPluginInfoConsoleCommands()

	-- Load SpawnProtection and WorldLimit settings for individual worlds:
	cRoot:Get():ForEachWorld(
		function (a_World)
			LoadWorldSettings(a_World)
		end
	)

	-- Initialize the banlist, load its DB, do whatever processing it needs on startup:
	InitializeBanlist()

	-- Initialize the whitelist, load its DB, do whatever processing it needs on startup:
	InitializeWhitelist()

	-- Initialize the Item Blacklist (the list of items that cannot be obtained using the give command)
	IntializeItemBlacklist( Plugin )

	-- Add webadmin tabs:
	Plugin:AddWebTab("Manage Server",   HandleRequest_ManageServer)
	Plugin:AddWebTab("Server Settings", HandleRequest_ServerSettings)
	Plugin:AddWebTab("Chat",            HandleRequest_Chat)
	Plugin:AddWebTab("Players",         HandleRequest_Players)
	Plugin:AddWebTab("Whitelist",       HandleRequest_WhiteList)
	Plugin:AddWebTab("Permissions",     HandleRequest_Permissions)
	Plugin:AddWebTab("Plugins",         HandleRequest_ManagePlugins)
	Plugin:AddWebTab("Time & Weather",  HandleRequest_Weather)
	Plugin:AddWebTab("Ranks",           HandleRequest_Ranks)
	Plugin:AddWebTab("Player Ranks",    HandleRequest_PlayerRanks)

	LoadMotd()

	WEBLOGINFO("Core is initialized")
	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())

	return true
end

function OnDisable()
	LOG( "Disabled Core!" )
end


-- Initialising Functions
function PlayerJoin(Player)
	aMap = cRoot:Get():GetWorld("worlds/world")
	aMap:QueueTask(function (aMap)
		if GetPlayerAmountByWorld(cRoot:Get():GetWorld("worlds/Map1")) < 3 then
			PlayerJoinMap(Player, "worlds/Map1")
		elseif GetPlayerAmountByWorld(cRoot:Get():GetWorld("worlds/Map1")) < 3 then
			PlayerJoinMap(Player, "worlds/Map2")
		elseif GetPlayerAmountByWorld(cRoot:Get():GetWorld("worlds/Map1")) < 3 then
			PlayerJoinMap(Player, "worlds/Map3")
		elseif GetPlayerAmountByWorld(cRoot:Get():GetWorld("worlds/Map1")) < 3 then
			PlayerJoinMap(Player, "worlds/Map4")
		elseif GetPlayerAmountByWorld(cRoot:Get():GetWorld("worlds/Map1")) < 3 then
			PlayerJoinMap(Player, "worlds/Map5")
		else
			Player:SendMessageFailure("Error: Not enough Slots")
		end
	end)
end
function PlayerJoinMap(aPlayer, Map)
	local aMap = cRoot:Get():GetWorld(Map)
	aMap:ScheduleTask(1, function (aMap)
		aPlayer:MoveToWorld(aMap)
		aMap:ScheduleTask(1, function (aMap)
		aPlayer:SendMessage(aPlayer:GetName() .. " Joined " .. aMap:GetName() .. " Which has " .. GetPlayerAmountByWorld(aMap) .. " Players!")
		end)
	end)
end

-- Global Functions
function GetPlayersByWorld(aWorld)
	assert(aWorld)
	local PlayerTable = {}
	aWorld:ForEachPlayer(
		function(aPlayer)
			table.insert(PlayerTable, aPlayer:GetName())
		end
	)
	return PlayerTable
end
function GetPlayerAmountByWorld(aWorld)
	assert(aWorld)
	local Players = 0
	aWorld:ForEachPlayer(
		function(aPlayer)
			Players = Players + 1
		end
	)
	return Players
end
function SpawnMonster()
	return true
end

-- Command Functions
function Kry(Split, Player)
		Player:SendMessage("Testing")
	return true
end
function TpAll(Split, Player)
	cRoot:Get():ForEachWorld(
		function(aWorld)
			aWorld:ForEachEntity( 
			function (aEntity)
			aEntity:MoveToWorld(Player:GetWorld())
			aEntity:TeleportToEntity(Player)
			end
			)
		end
	)
	return true
end
function KillAll(Split, Player)
	cRoot:Get():ForEachWorld(
		function(aWorld)
			aWorld:ForEachEntity( 
			function (aEntity)
				if aEntity:GetClass() == "cPlayer" then
					aEntity:SendMessage("Testing")
				else
					aEntity:TakeDamage(0, Player, 999, 0)
				end
			end
			)
		end
	)
	return true
end
function PlayersByWorld(Split, Player)
		Player:SendMessage("Players in: 'World' - " .. GetPlayerAmountByWorld(cRoot:Get():GetWorld("worlds/world")))
		Player:SendMessage("Players in: 'Map1' - " .. GetPlayerAmountByWorld(cRoot:Get():GetWorld("worlds/Map1")))
		Player:SendMessage("Players in: 'Map2' - " .. GetPlayerAmountByWorld(cRoot:Get():GetWorld("worlds/Map2")))
		Player:SendMessage("Players in: 'Map3' - " .. GetPlayerAmountByWorld(cRoot:Get():GetWorld("worlds/Map3")))
		Player:SendMessage("Players in: 'Map4' - " .. GetPlayerAmountByWorld(cRoot:Get():GetWorld("worlds/Map4")))
		Player:SendMessage("Players in: 'Map5' - " .. GetPlayerAmountByWorld(cRoot:Get():GetWorld("worlds/Map5")))
	return true
end
function Freeze(Split, Player)
	if Player:IsFrozen() then
	Player:Unfreeze()
	else
	Player:Freeze(Player:GetPosition())
	end
	return true
end
function UnFreezeAll(Split, Player)
	cRoot:Get():ForEachPlayer(
		function(aPlayer)
				if aPlayer:IsFrozen() then
					aPlayer:Unfreeze()
				else
					aPlayer:SendMessage("Testing")
				end
		end
	)
	return true
end
function PlaceBlockBelow(Player)
	Player:GetWorld():SetBlock(Player:GetPosX(), Player:GetPosY() - 1, Player:GetPosZ(), 1, 0)
	return true
end
function StartTheGame()
	CountDownGame(cRoot:Get():GetWorld("worlds/Map1"))
	return true
end

-- Command SubFunctions
function CountDownGame(Map)
	Map:ForEachPlayer(
		function(aPlayer)
			aPlayer:SendMessage("Game Starting in 5 Seconds.")
			Map:ScheduleTask(20, function (Map)
				aPlayer:SendMessage("Game Starting in 4 Seconds.")
				end)
			Map:ScheduleTask(40, function (Map)
				aPlayer:SendMessage("Game Starting in 3 Seconds.")
				end)
			Map:ScheduleTask(60, function (Map)
				aPlayer:SendMessage("Game Starting in 2 Seconds.")
				end)
			Map:ScheduleTask(80, function (Map)
				aPlayer:SendMessage("Game Starting in 1 Seconds.")
				end)
			Map:ScheduleTask(100, function (Map)
				aPlayer:SendMessage("Game Starting.")
				end)
		end
	)
end