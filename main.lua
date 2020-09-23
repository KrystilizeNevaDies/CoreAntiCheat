-- main.lua

-- Implements the main plugin entrypoint





-- Configuration
--  Use prefixes or not.
--  If set to true, messages are prefixed, e. g. "[FATAL]". If false, messages are colored.
g_UsePrefixes = true

-- Called by Cuberite on plugin start to initialize the plugin
function Initialize(Plugin)
	Plugin:SetName("CoreAntiCheat")
	Plugin:SetVersion(tonumber(g_PluginInfo["Version"]))

	-- Register for all hooks needed
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_MOVING, OnPlayerMoving);

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
				Player:SendMessageInfo("-- Config --")
				Player:SendMessageInfo("Ping Allowance: " .. getconfig(1))
				Player:SendMessageInfo("MovementRestriction: " .. getconfig(2))
			else
				Player:SendMessageFailure("Incorrect Argument")
			end
		else
			Player:SendMessageFailure("CoreAntiCheat is disabled!")
		end
	end
	return true
end

-- Command SubFunctions



-- AntiCheat Logic

function OnPlayerMoving(Player, OldPosition, NewPosition)
  local XD = math.abs(OldPosition.x-NewPosition.x)
  local YD = math.abs(OldPosition.y-NewPosition.y)
  local ZD = math.abs(OldPosition.z-NewPosition.z)
  local Speed = math.sqrt(math.pow(XD,2) + math.pow(ZD, 2))
  local MaxSpeed = (Player:GetMaxSpeed() * 0.22) + (getconfig(2) * 0.1)
  
  if getconfig(3) then
    Player:SendMessageInfo(Speed .. " out of " .. MaxSpeed)
	end
  
  if Speed > MaxSpeed then
    return true
	end
end