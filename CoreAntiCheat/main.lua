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
	Plugin:SetName("CoreAntiCheat")
	Plugin:SetVersion(tonumber(g_PluginInfo["Version"]))

	-- Register for all hooks needed

	-- Bind ingame commands:

	-- Load the InfoReg shared library:
	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")

	-- Bind all the commands:
	RegisterPluginInfoCommands()

	-- Bind all the console commands:
	RegisterPluginInfoConsoleCommands()

	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())

	return true
end

function OnDisable()
	LOG( "Disabled CoreAntiCheat!" )
end


-- Initialising Functions


-- Global Functions


-- Command Functions
function CoreAntiCheatCommand(Split, Player, World)
	if Split[1] == test then
		cRoot:BroadcastChat("Test")
	end
	return true
end

-- Command SubFunctions

