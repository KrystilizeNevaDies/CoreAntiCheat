-- Config File
-- Specify various plugin parameters here

-- PingAllowance: Defines the allowance placed on players with the most latency
-- Integer between 0 and 10. 1 allows the least and 10 allows the most.
-- 0 means that PingAllowance is disabled. (3 is recommended)
-- Use this setting if players are reporting a large amount of lag-backs
PingAllowance = 3

-- MovementRestriction: Defines how harsh the plugin is on player movement.
-- Integer between 0 and 10. 1 is the most restrictive and 10 is the least restrictive.
-- 0 means that movement restriction is disabled. (3 is recommended)
MovementRestriction = 3



-- Config Fetch Function
-- Ignore this function if you are only editing the plugins config
function getconfig(num)
	configtable = {}
	table.insert(configtable, PingAllowance)
	table.insert(configtable, MovementRestriction)
	return configtable[num]
end