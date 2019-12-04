
-- Info.lua

-- Implements the g_PluginInfo standard plugin description

g_PluginInfo = 
{
	Name = "CoreAntiCheat",
	Version = "1",
	Date = "2014-06-11",
	SourceLocation = "https://github.com/KrystilizeNevaDies/CoreAntiCheat",
	Description = [[Implements basic Anti-Cheat that is useful in running a small server]],
	
	Commands =
	{
		["/anticheat"] = 
		{
			Permission = "coreanticheat.cmd",
			Handler = CoreAntiCheatCommand,
			HelpString = "Universal Anticheat Command",
			ParameterCombinations =
			{
				{
					Params = "test",
					Help = "Test Command",
				},
				{
					Params = "config",
					Help = "Lists the config",
				},
			}
		}
	},  -- Commands


	
	ConsoleCommands =
	{
		["anticheat"] =
		{
			Handler =  CoreAntiCheatConsoleCommand,
			HelpString = "Universal Anticheat Command",
		},
	},  -- ConsoleCommands
	Permissions = 
	{
		["coreanticheat.cmd"] =
		{
			Description = "Allows use of anticheat command",
			RecommendedGroups = "admins",
		},
	},  -- Permissions
}  -- g_PluginInfo


