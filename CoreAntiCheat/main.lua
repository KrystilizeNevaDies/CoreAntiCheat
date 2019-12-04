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

	-- Load the InfoReg shared library:
	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")

	-- Bind all the commands:
	RegisterPluginInfoCommands()

	-- Bind all the console commands:
	RegisterPluginInfoConsoleCommands()

	-- Initialise variables
	CACenabled = true

	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())

	return true
end

function OnDisable()
	LOG( "Disabled CoreAntiCheat!" )
end

-- Global Functions


-- Command Functions
function CoreAntiCheatCommand(Split, Player, World)
	if Split[2] == "toggle" then
		if CACenabled then
			CACenabled = false
			Player:SendMessageInfo("CoreAntiCheat Disabled!")
		else
			CACenabled = true
			Player:SendMessageInfo("CoreAntiCheat Enabled!")
		end
	else
		if CACenabled then
			if Split[2] == "test" then
				cRoot:Get():BroadcastChat("test")
			elseif Split[2] == "config" then
					Player:SendMessageFailure(getconfig(1))
			else
				Player:SendMessageFailure("Incorrect Argument")
			end
		else
			Player:SendMessageFailure("CoreAntiCheat is Disabled!")
		end
	end
	return true
end

-- Command SubFunctions

