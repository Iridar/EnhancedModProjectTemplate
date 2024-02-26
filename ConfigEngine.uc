//---------------------------------------------------------------------------------------
//  FILE:    ConfigEngine.uc
//  AUTHOR:  Iridar / Enhanced Mod Project Template --  26/02/2024
//  PURPOSE: Helper class for setting up configurable values.       
//---------------------------------------------------------------------------------------

class ConfigEngine extends Object config(Game) abstract;

//=======================================================================================
//                                     OVERVIEW
//---------------------------------------------------------------------------------------
// 
// Config Engine aims to resolve two issues:
// 
// 1. Setting up configuration variables is a chore.
// 
// This problem is resolved by removing the need to declare configuration variables. 
// You simply specify the name of the property, and use that property in config files. 
// Config Engine connects the two automatically.
// 
// 2. Other mods have trouble reliably overriding shipped default config.
// 
// This happens because config load order is unpredictable from the modmaker's end.
// In other words, while there are ways to enforce particular config load order, 
// they must be implemented on the end of the mod user, 
// and cannot be enforced by you, the modmaker.
// 
// This problem is resolved by adding a Priority value to each configuration entry, which
// has the final word on which config entry gets used, irrespective of config load order
// (unless several entries have the same Priority, in which case the latest entry in 
// config load order will be used).
// 
//=======================================================================================
//                              SETTING CONFIG ENTRIES
//---------------------------------------------------------------------------------------
//
//Some examples of specifying config values. Default config file is XComGame.ini, 
//but you can change it to whatever you want in the class definition above.
/*

[$ModSafeName$.ConfigEngine]

+Configs = (N = "SomeIntProperty", V = "10")

+Configs = (N = "SomeIntArrayProperty", VA = ("1", "2", "3", "4"))

; Same thing written differently.
+Configs = (N = "SomeIntArrayProperty", VA[0] = "1", VA[1] = "2", VA[2} = "3", VA[3] = "4")

; Specify higher priority to make sure your config entry overrides entries with lower priority (default 50).
; Useful for changing configuration of another mod that uses Config Engine.
+Configs = (N = "SomeIntProperty", V = "20", Priority = 55)

+Configs = (N = "SomeCostProperty",\\
	Cost = (ResourceCosts[0] = (ItemTemplateName = "Supplies", Quantity = 48),\\
			ResourceCosts[1] = (ItemTemplateName = "AlienAlloy", Quantity = 6),\\
			ResourceCosts[2] = (ItemTemplateName = "EleriumDust", Quantity = 6)))
			
+Configs = (N = "SomeRequirementsProperty",\\
	Requirements = (RequiredTechs[0] = "AutopsyArchon", RequiredEngineeringScore=20, bVisibleIfPersonnelGatesNotMet=true))
	
*/
//=======================================================================================
//                              GETTING CONFIG ENTRIES
//---------------------------------------------------------------------------------------
// 
// You can call Config Engine functions directly, for example:
// 
// IntValue = int(class'ConfigEngine'.static.GetConfig("SomeIntProperty").V);
// 
// But that can get cumbersome, so helper functions and global macros are used 
// to keep code compact.
/*

IntValue = `GetConfigInt("SomeIntProperty");

IntArray = `GetConfigArrayInt("SomeIntArrayProperty");

*/
// While the GetConfig functions and macros accept names, 
// it's recommended to use strings to avoid polluting the name table.
// 
//=======================================================================================
//                              CONFIG ENGINE IMPLEMENTATION
//---------------------------------------------------------------------------------------

struct ConfigStruct
{
	// Config property name
	var string				N; 

	// Properties
	var string				V;	// Value of the property
	var array<string>		VA; // Array of values (when appropriate)
	var WeaponDamageValue	Damage;
	var StrategyCost		Cost;
	var StrategyRequirement	Requirements;

	var array<name>			RDLC;		// List of required modnames for this config entry to be considered
	var int					Priority;	// Priority. If several config entries share the same name N, the entry with highest priority will be used. 
										// If priority matches, the latest entry in config load order will be used.
	structdefaultproperties
	{
		Priority = 50
	}
};
var private config array<ConfigStruct> Configs;

static final function ConfigStruct GetConfig(const coerce string ConfigName, optional bool bCanBeNull)
{
	local ConfigStruct ReturnConfig;
	local ConfigStruct CycleConfig;
	local ConfigStruct EmptyConfig;

	foreach default.Configs(CycleConfig)
	{
		if (!class'Help'.static.AreModsActive(CycleConfig.RDLC))
		{
			continue;
		}
		if (CycleConfig.N == ConfigName && CycleConfig.Priority >= ReturnConfig.Priority)
		{
			ReturnConfig = CycleConfig;
		}
	}

	if (ReturnConfig == EmptyConfig && !bCanBeNull)
	{
		`redscreen("WARNING :: Failed to find Config with N name:" @ ConfigName);
		`redscreen(GetScriptTrace());
	}

	return ReturnConfig;
}

static final function string GetConfigValue(const coerce string ConfigName)
{
	return GetConfig(ConfigName).V;
}

static final function bool GetConfigBool(const coerce string ConfigName)
{
	return bool(GetConfigValue(ConfigName));
}

static final function int GetConfigInt(const coerce string ConfigName)
{
	return int(GetConfigValue(ConfigName));
}

static final function float GetConfigFloat(const coerce string ConfigName)
{
	return float(GetConfigValue(ConfigName));
}

static final function name GetConfigName(const coerce string ConfigName)
{
	return name(GetConfigValue(ConfigName));
}

static final function string GetConfigString(const coerce string ConfigName)
{
	return GetConfigValue(ConfigName);
}

static final function array<int> GetConfigArrayInt(const coerce string ConfigName)
{
	local array<string>	StringArray;
	local array<int>	ReturnArray;
	local int			Index;

	StringArray = GetConfig(ConfigName).VA;
	for (Index = 0; Index < StringArray.Length; Index++)
	{
		ReturnArray.AddItem(int(StringArray[Index]));
	}

	return ReturnArray;
}

static final function array<float> GetConfigArrayFloat(const coerce string ConfigName)
{
	local array<string>	StringArray;
	local array<float>	ReturnArray;
	local int			Index;

	StringArray = GetConfig(ConfigName).VA;
	for (Index = 0; Index < StringArray.Length; Index++)
	{
		ReturnArray.AddItem(float(StringArray[Index]));
	}

	return ReturnArray;
}

static final function array<name> GetConfigArrayName(const coerce string ConfigName, optional bool bCanBeNull)
{
	local array<string>	StringArray;
	local array<name>	ReturnArray;
	local int			Index;

	StringArray = GetConfig(ConfigName, bCanBeNull).VA;
	for (Index = 0; Index < StringArray.Length; Index++)
	{
		ReturnArray.AddItem(name(StringArray[Index]));
	}

	return ReturnArray;
}

static final function WeaponDamageValue GetConfigDamage(const coerce string ConfigName)
{
    return GetConfig(ConfigName).Damage;
}
