//---------------------------------------------------------------------------------------
//  FILE:    Help.uc
//  AUTHOR:  Iridar / Enhanced Mod Project Template --  26/02/2024
//  PURPOSE: Helper class for static functions and script snippet repository.     
//---------------------------------------------------------------------------------------

class Help extends Object abstract;

//=======================================================================================
//                           WORKING WITH GAME STATES
//---------------------------------------------------------------------------------------

// Creating and Submitting a Game State

static final function CreateAndSubmitGameState()
{
	local XComGameState NewGameState;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Optional Debug Comment");

	`GAMERULES.SubmitGameState(NewGameState);
}

//=======================================================================================
//                           RANDOM NUMBER GENERATION
//---------------------------------------------------------------------------------------
/*
// Returns a random `float` value from the [0; 1] range. 
// Can only return 32 768 distinct results. (c) robojumper
FRand() 

// Returns a random `int` value from [0; x] range.
int(x * FRand())

// Returns a random `flaot` value from [0; 1) range
`SYNC_FRAND()
`SYNC_FRAND_STATIC()

// Returns a random `int` value from [0; x) range.
`SYNC_RAND(x)
`SYNC_RAND_STATIC(x)

// Returns a random `vector`, each component of the vector will have value from (-1; 1) range.
`SYNC_VRAND()
`SYNC_VRAND_STATIC()

// Return a random `vector` where each component is from the (-x; x) range.
`SYNC_VRAND() * x

*/
//=======================================================================================
//                           ACTION POINTS REFERENCE
//---------------------------------------------------------------------------------------
/*

class'X2CharacterTemplateManager'.default.StandardActionPoint
class'X2CharacterTemplateManager'.default.MoveActionPoint
class'X2CharacterTemplateManager'.default.OverwatchReserveActionPoint
class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint
class'X2CharacterTemplateManager'.default.GremlinActionPoint
class'X2CharacterTemplateManager'.default.RunAndGunActionPoint
class'X2CharacterTemplateManager'.default.EndBindActionPoint
class'X2CharacterTemplateManager'.default.GOHBindActionPoint
class'X2CharacterTemplateManager'.default.CounterattackActionPoint
class'X2CharacterTemplateManager'.default.UnburrowActionPoint
class'X2CharacterTemplateManager'.default.ReturnFireActionPoint
class'X2CharacterTemplateManager'.default.DeepCoverActionPoint
class'X2CharacterTemplateManager'.default.MomentumActionPoint
class'X2CharacterTemplateManager'.default.SkirmisherInterruptActionPoint

*/
//=======================================================================================
//                           ABILITY ICON COLORS REFERENCE
//---------------------------------------------------------------------------------------
/*

'eAbilitySource_Perk'		: yellow
'eAbilitySource_Debuff'		: red
'eAbilitySource_Psionic'	: purple
'eAbilitySource_Commander'	: green 
'eAbilitySource_Item'		: blue (cyan)
'eAbilitySource_Standard'	: blue (cyan)

*/
//=======================================================================================
//                           WORKING WITH PERSISTENT EFFECTS
//---------------------------------------------------------------------------------------
/*

// Check if unit is affected by an effect.
UnitState.IsUnitAffectedByEffectName('NameOfTheEffect')


// Get an Effect State from unit
local XComGameState_Effect EffectState;
EffectState = UnitState.GetUnitAffectedByEffectState('NameOfTheEffect');

if (EffectState != none)
{
    // Do stuff
}


// Iterate over all effects on unit
local StateObjectReference EffectRef;
local XComGameStateHistory History;
local XComGameState_Effect EffectState;

History = `XCOMHISTORY;

foreach UnitState.AffectedByEffects(EffectRef)
{
    EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
	if (EffectState == none || EffectState.bRemoved)
		continue;
		
    // Do stuff with EffectState
}

*/
//=======================================================================================
//                           WORKING WITH CLASS DEFAULT OBJECTS (CDO)
//---------------------------------------------------------------------------------------
/*
// Use sparingly: these functions are expensive to call. 
// If you need CDOs in hot code, call them elsewhere and cache the result.

class'Engine'.static.FindClassDefaultObject(string ClassName)
class'XComEngine'.static.GetClassDefaultObject(class SeachClass);
class'XComEngine'.static.GetClassDefaultObjectByName(name ClassName);

// This function will give you an array of CDOs for the specified class 
// and all of its subclasses, in case you need to handle them as well.

class'XComEngine'.static.GetClassDefaultObjects(class SeachClass);
*/
//=======================================================================================
//                           WORKING WITH UNITS
//---------------------------------------------------------------------------------------
/*
// Check if a Unit can see a Location

if (class'X2TacticalVisibilityHelpers'.static.CanUnitSeeLocation(UnitState.ObjectID, TileLocation))
{
    // Do stuff
}

*/

// Get Bond Level between two soldiers
static final function int GetBondLevel(const XComGameState_Unit SourceUnit, const XComGameState_Unit TargetUnit)
{
    local SoldierBond BondInfo;

    if (SourceUnit.GetBondData(SourceUnit.GetReference(), BondInfo))
    {
        if (BondInfo.Bondmate.ObjectID == TargetUnit.ObjectID)
        {
            return BondInfo.BondLevel;
        }
    }
    return 0;
}

// Check if a Unit has a Weapon of specified WeaponCategory equipped
static final function bool HasWeaponOfCategory(const XComGameState_Unit UnitState, const name WeaponCat, optional XComGameState CheckGameState)
{
    local XComGameState_Item Item;
    local StateObjectReference ItemRef;

    foreach UnitState.InventoryItems(ItemRef)
    {
        Item = UnitState.GetItemGameState(ItemRef, CheckGameState);

        if (Item != none && Item.GetWeaponCategory() == WeaponCat)
        {
            return true;
        }
    }

    return false;
}

// Similar check, but also for a specific slot:
static final function bool HasWeaponOfCategoryInSlot(const XComGameState_Unit UnitState, const name WeaponCat, const EInventorySlot Slot, optional XComGameState CheckGameState)
{
    local XComGameState_Item Item;
    local StateObjectReference ItemRef;

    foreach UnitState.InventoryItems(ItemRef)
    {
        Item = UnitState.GetItemGameState(ItemRef, CheckGameState);

        if (Item != none && Item.GetWeaponCategory() == WeaponCat && Item.InventorySlot == Slot)
        {
            return true;
        }
    }
    return false;
}

// Check if a Unit has one of the specified items equipped
static final function bool UnitHasItemEquipped(const XComGameState_Unit UnitState, const array<name> ItemNames, optional XComGameState CheckGameState)
{
    local XComGameState_Item Item;
    local StateObjectReference ItemRef;

    foreach UnitState.InventoryItems(ItemRef)
    {
        Item = UnitState.GetItemGameState(ItemRef, CheckGameState);

        if (Item != none && ItemNames.Find(Item.GetMyTemplateName()) != INDEX_NONE)
        {
            return true;
        }
    }

    return false;
}

static final function int TileDistanceBetweenUnitAndTile(const XComGameState_Unit UnitState, const TTile TileLocation)
{
	local XComWorldData WorldData;
	local vector UnitLoc, TargetLoc;
	local float Dist;
	local int Tiles;

	if (UnitState.TileLocation == TileLocation)
		return 0;

	WorldData = `XWORLD;
	UnitLoc = WorldData.GetPositionFromTileCoordinates(UnitState.TileLocation);
	TargetLoc = WorldData.GetPositionFromTileCoordinates(TileLocation);
	Dist = VSize(UnitLoc - TargetLoc);
	Tiles = Dist / WorldData.WORLD_StepSize;

	return Tiles;
}

// Calculate Tile Distance Between Tiles
static final function int GetTileDistanceBetweenTiles(const TTile TileA, const TTile TileB) 
{
	local XComWorldData WorldData;
	local vector LocA;
	local vector LocB;
	local float Dist;
	local int TileDistance;

	WorldData = `XWORLD;
	LocA = WorldData.GetPositionFromTileCoordinates(TileA);
	LocB = WorldData.GetPositionFromTileCoordinates(TileB);

	Dist = VSize(LocA - LocB);
	TileDistance = Dist / WorldData.WORLD_StepSize;
	
	return TileDistance;
}

// Rank = 0 for Squaddie
// Note: ModifyEarnedSoldierAbilities DLC hook is usually better for non-temporary ability granting.
static function GiveSoldierAbilityToUnit(const name AbilityName, const int Rank, XComGameState_Unit UnitState, XComGameState NewGameState)
{	
	local SoldierClassAbilityType AbilityStruct;
	local int Index;

	AbilityStruct.AbilityName = AbilityName;
	UnitState.AbilityTree[Rank].Abilities.AddItem(AbilityStruct);

	Index = UnitState.AbilityTree[Rank].Abilities.Length - 1;

	UnitState.BuySoldierProgressionAbility(NewGameState, Rank, Index, 0); // 0 = ability points cost
}

static final function array<XComGameState_Unit> GetSquadUnitStates()
{
	local XComGameState_HeadquartersXCom	XComHQ;
	local StateObjectReference				SquadUnitRef;
	local array<XComGameState_Unit>			UnitStates;
	local XComGameState_Unit				UnitState;
	local XComGameStateHistory				History;

	XComHQ = `XCOMHQ;
	History = `XCOMHISTORY;
	foreach XComHQ.Squad(SquadUnitRef)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(SquadUnitRef.ObjectID));
		if (UnitState != none)
		{
			UnitStates.AddItem(UnitState);
		}
	}
	return UnitStates;
}

//=======================================================================================
//                           STRATEGIC HELPERS
//---------------------------------------------------------------------------------------

static final function XComGameState_HeadquartersXCom GetAndPrepXComHQ(XComGameState NewGameState)
{
    local XComGameState_HeadquartersXCom XComHQ;

    foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
    {
        break;
    }

    if (XComHQ == none)
    {
        XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
        XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
    }

    return XComHQ;
}

static final function bool IsInStrategy()
{
    return `HQPRES != none;
}

static final function bool ReallyIsInStrategy()
{
	return `HQGAME  != none && `HQPC != None && `HQPRES != none;
}

static final function PlayStrategySoundEvent(string strKey, Actor InActor)
{
	local string	SoundEventPath;
	local AkEvent	SoundEvent;

	foreach class'XComStrategySoundManager'.default.SoundEventPaths(SoundEventPath)
	{
		if (InStr(SoundEventPath, strKey) != INDEX_NONE)
		{
			SoundEvent = AkEvent(`CONTENT.RequestGameArchetype(SoundEventPath));
			if (SoundEvent != none)
			{
				InActor.WorldInfo.PlayAkEvent(SoundEvent);
				return;
			}
		}
	}
}

static final function int GetForceLevel()
{
	local XComGameStateHistory		History;
	local XComGameState_BattleData	BattleData;

	History = `XCOMHISTORY;
	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData', true));
	if (BattleData == none)
	{
		`AMLOG("WARNING :: No Battle Data!" @ GetScriptTrace());
		return -1;
	}

	return BattleData.GetForceLevel();
}

static final function AddItemToHQInventory(const name TemplateName)
{
    local XComGameState						NewGameState;
    local XComGameState_HeadquartersXCom    XComHQ;
    local XComGameState_Item                ItemState;
    local X2ItemTemplate                    ItemTemplate;
    local X2ItemTemplateManager				ItemMgr;

    ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();    

    ItemTemplate = ItemMgr.FindItemTemplate(TemplateName);

    if (ItemTemplate == none)
	{
		`AMLOG("WARNING :: No Item Template!" @ TemplateName @ GetScriptTrace());
		return;
	}
    
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding item to HQ Inventory");
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', `XCOMHQ.ObjectID));

	ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);     
	
	if (ItemTemplate.bInfiniteItem)
	{
		// XComHQ.PutItemInInventory() is unable to work with infinite items.
		XComHQ.AddItemToHQInventory(ItemState);
	}
	else
	{
		XComHQ.PutItemInInventory(NewGameState, ItemState);
	}
	`GAMERULES.SubmitGameState(NewGameState);
}

//=======================================================================================
//                           LOCALIZATION HELPER
//---------------------------------------------------------------------------------------
// 
// The GetLocalizedString() function is a helper with purpose similar to Config Engine:
// make using localized strings more convenient without having to explicitly declare them
// as variables.
// 
// It relies on using Localize() function, which probably is not optimal in terms of 
// performance, so you probably shouldn't use it *too much*, 
// especially in performance-sensitive code.

static final function string GetLocalizedString(const coerce string StringName)
{
	return Localize("Help", StringName, "$ModSafeName$");
}

//=======================================================================================
//                              SETTING LOCALIZED STRING
//---------------------------------------------------------------------------------------
/*

$ModSafeName$.int
[Help]
StringName = "Wow fancy localized string!"

*/
//=======================================================================================
//                              GETTING LOCALIZED STRING
//---------------------------------------------------------------------------------------
/*

YourString = class'Help'.static.GetLocalizedString('StringName');

// Or with global macro for brevity:

YourString = `GetLocalizedString('StringName');

*/
//=======================================================================================
//                              STRING HELPERS
//---------------------------------------------------------------------------------------

// Create a single big string out of an array of smaller strings, separated by an optional delimiter.
static final function string JoinStrings(array<string> Arr, optional string Delim = "")
{
	local string ReturnString;
	local int i;

	// Handle it this way so there's no delim after the final member.
	for (i = 0; i < Arr.Length - 1; i++)
	{
		ReturnString $= Arr[i] $ Delim;
	}
	if (Arr.Length > 0)
	{
		ReturnString $= Arr[Arr.Length - 1];
	}
	return ReturnString;
}

//=======================================================================================
//                              ITEM AND WEAPON HELPERS
//---------------------------------------------------------------------------------------

static final function bool AreItemTemplatesMutuallyExclusive(const X2ItemTemplate TemplateA, const X2ItemTemplate TemplateB)
{
	return TemplateA.ItemCat == TemplateB.ItemCat || 
			X2WeaponTemplate(TemplateA) != none && X2WeaponTemplate(TemplateB) != none && 
			X2WeaponTemplate(TemplateA).WeaponCat == X2WeaponTemplate(TemplateB).WeaponCat;
}


static final function bool IsItemUniqueEquipInSlot(X2ItemTemplateManager ItemMgr, const X2ItemTemplate ItemTemplate, const EInventorySlot Slot)
{
	local X2WeaponTemplate WeaponTemplate;

	if (class'X2TacticalGameRulesetDataStructures'.static.InventorySlotBypassesUniqueRule(Slot))
		return false;

	WeaponTemplate = X2WeaponTemplate(ItemTemplate);

	return ItemMgr.ItemCategoryIsUniqueEquip(ItemTemplate.ItemCat) || WeaponTemplate != none && ItemMgr.ItemCategoryIsUniqueEquip(WeaponTemplate.WeaponCat);
}

static final function bool WeaponHasUpgrade(const XComGameState_Item ItemState, const name UpgradeName)
{
	local array<name> UpgradeNames;

	UpgradeNames = ItemState.GetMyWeaponUpgradeTemplateNames();

	return UpgradeNames.Find(UpgradeName) != INDEX_NONE;
}

//=======================================================================================
//                              MOD HELPERS
//---------------------------------------------------------------------------------------

static final function bool IsModActive(name ModName)
{
    local XComOnlineEventMgr    EventManager;
    local int                   Index;

    EventManager = `ONLINEEVENTMGR;

    for (Index = EventManager.GetNumDLC() - 1; Index >= 0; Index--) 
    {
        if (EventManager.GetDLCNames(Index) == ModName) 
        {
            return true;
        }
    }
    return false;
}

static final function bool AreModsActive(const array<name> ModNames)
{
	local name ModName;

	foreach ModNames(ModName)
	{
		if (!IsModActive(ModName))
		{
			return false;
		}
	}
	return true;
}
