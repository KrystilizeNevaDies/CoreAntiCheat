
-- Info.lua

-- Implements the g_PluginInfo standard plugin description

g_PluginInfo = 
{
	Name = "Core",
	Version = "15",
	Date = "2014-06-11",
	SourceLocation = "https://github.com/KrystilizeNevaDies/CoreAntiCheat",
	Description = [[Implements basic Anti-Cheat that is useful in running a small server]],
	
	Commands =
	{
		["/ban"] = 
		{
			Permission = "core.ban",
			Handler = HandleBanCommand,
			HelpString = "Bans a player.",
		}
	},  -- Commands


	
	ConsoleCommands =
	{
		["ban"] =
		{
			Handler =  HandleConsoleBan,
			HelpString = "Bans a player by name.",
		},
	},  -- ConsoleCommands
	Permissions = 
	{
		["core.changegm"] =
		{
			Description = "Allows players to change gamemodes.",
			RecommendedGroups = "admins",
		},

		["core.enchant"] =
		{
			Description = "Allows players to add an enchantment to a player's held item.",
			RecommendedGroups = "everyone",
		},
	},  -- Permissions
}  -- g_PluginInfo


