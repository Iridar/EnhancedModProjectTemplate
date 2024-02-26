//---------------------------------------------------------------------------------------
//  FILE:    X2DLCInfo_$ModSafeName$.uc
//  AUTHOR:  Iridar / Enhanced Mod Project Template --  26/02/2024
//  PURPOSE: Contains various DLC hooks, with examples on using the most popular ones.
//           Delete this file if you do not end up using it, as every class
//           that extends X2DownloadableContentInfo adds a tiny performance cost.
//---------------------------------------------------------------------------------------

class X2DLCInfo_$ModSafeName$ extends X2DownloadableContentInfo;

// Sockets Part 1 of 3: variable for storing a new socket.
// var private SkeletalMeshSocket ExampleSocket;


//=======================================================================================
//                           ON POST TEMPLATES CREATED (OPTC)
//---------------------------------------------------------------------------------------

// Purpose: patching templates.
// Runs: every time the game starts, after creating templates.
//
// static event OnPostTemplatesCreated()
// {
// 
// }

// Purpose: adds the specified GTS unlock to GTS. 
// Use: call from OPTC.
//
// static private function AddGTSUnlockTemplate(const name UnlockTemplateName)
// {
//     local X2StrategyElementTemplateManager  TechMgr;
//     local X2FacilityTemplate                Template;
//     local array<X2DataTemplate>             DifficultyVariants;
//     local X2DataTemplate                    DifficultyVariant;
// 
//     TechMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
// 
//     TechMgr.FindDataTemplateAllDifficulties('OfficerTrainingSchool', DifficultyVariants);
// 
//     foreach DifficultyVariants(DifficultyVariant)
//     {
//         Template = X2FacilityTemplate(DifficultyVariant);
//         if (Template != none)
//         {
//            Template.SoldierUnlockTemplates.AddItem(UnlockTemplateName);
//         }
//     }
// }

// Purpose: example script for patching character templates.
// Use: call from OPTC.
//
// static private function PatchCharacterTemplates()
// {
//  local X2CharacterTemplateManager    CharMgr;
//  local X2CharacterTemplate           CharTemplate;
// 	local array<X2DataTemplate>			DifficultyVariants;
// 	local X2DataTemplate				DifficultyVariant;
// 	local X2DataTemplate				DataTemplate;
// 	
//  CharMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
// 
// 	CharMgr.FindDataTemplateAllDifficulties('CharTemplateName', DifficultyVariants);
// 	foreach DifficultyVariants(DifficultyVariant)
// 	{
// 		CharTemplate = X2CharacterTemplate(DifficultyVariant);
// 		if (CharTemplate == none)
// 			continue;
// 
// 		// Patch one specific template here.
// 	}
// 	
// 	
// 	foreach CharMgr.IterateTemplates(DataTemplate, none)
// 	{
// 		CharMgr.FindDataTemplateAllDifficulties(DataTemplate.DataName, DifficultyVariants);
// 		foreach DifficultyVariants(DifficultyVariant)
// 		{
// 			CharTemplate = X2CharacterTemplate(DifficultyVariant);
// 			if (CharTemplate == none)
// 				continue;
// 			
// 			// Cycle over all templates for blanket or filtered patching.
// 		}
// 	}
// }

// Purpose: helper function for copying localization from one ability template to another.
// Use: call from OPTC.
//
// static private function CopyLocalization(const name TemplateName, const name DonorTemplateName)
// {
// 	local X2AbilityTemplateManager	AbilityTemplateManager
// 	local X2AbilityTemplate			Template;
// 	local X2AbilityTemplate			DonorTemplate;
// 	
// 	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
// 	Template = AbilityTemplateManager.FindAbilityTemplate(TemplateName);
// 	DonorTemplate = AbilityTemplateManager.FindAbilityTemplate(DonorTemplateName);
// 
// 	if (Template == none || DonorTemplate == none)
// 		return;
// 	
// 	Template.LocFriendlyName = DonorTemplate.LocFriendlyName;
// 	Template.LocHelpText = DonorTemplate.LocHelpText;                   
// 	Template.LocLongDescription = DonorTemplate.LocLongDescription;
// 	Template.LocPromotionPopupText = DonorTemplate.LocPromotionPopupText;
// 	Template.LocFlyOverText = DonorTemplate.LocFlyOverText;
// 	Template.LocMissMessage = DonorTemplate.LocMissMessage;
// 	Template.LocHitMessage = DonorTemplate.LocHitMessage;
// 	Template.LocFriendlyNameWhenConcealed = DonorTemplate.LocFriendlyNameWhenConcealed;      
// 	Template.LocLongDescriptionWhenConcealed = DonorTemplate.LocLongDescriptionWhenConcealed;   
// 	Template.LocDefaultSoldierClass = DonorTemplate.LocDefaultSoldierClass;
// 	Template.LocDefaultPrimaryWeapon = DonorTemplate.LocDefaultPrimaryWeapon;
// 	Template.LocDefaultSecondaryWeapon = DonorTemplate.LocDefaultSecondaryWeapon;
// }

//=======================================================================================
//                               ON LOADED SAVE GAME
//---------------------------------------------------------------------------------------

// Purpose: adding items, tech states and other things required for a mod to work
// if it's added mid-campaign.
// Runs: when the player loads a save that was made before activating this mod.
//
// static event OnLoadedSavedGame()
// {
// 
// }

// Purpose: adds the specified infinite item to the Avenger's inventory
// when the mod is added mid-campaign, // but only if it reasonably should be there:
// if it's a starting item or the schematic or tech that produces this item
// has been acquired. 
// Use: Use only from OnLoadedSavedGame() and other similar functions.
// DO NOT use from InstallNewCampaign(), it's unnecessary and will break the game.
//
// static private function MaybeAddItemToInventory(const name ItemName)
// {
// 	local XComGameState_HeadquartersXCom	XComHQ;	
// 	local X2ItemTemplateManager				ItemMgr;
// 	local name								ItemName;
// 	local X2ItemTemplate					ItemTemplate;
// 	local XComGameState						NewGameState;
// 	local XComGameState_Item				ItemState;
// 	local XComGameStateHistory				History;
// 	local X2StrategyElementTemplateManager	StratMgr;
// 
// 	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ(true);
// 	if (XComHQ == none)
// 		return;
// 	
// 	// Exit if the item is already in the inventory.
// 	if (XComHQ.HasItemByName(ItemName))
// 		return;
// 
// 	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
// 	ItemTemplate = ItemMgr.FindItemTemplate(ItemName);
// 	if (ItemTemplate == none)
// 		return;
// 		
// 	// Exit if the item is not infinite.
// 	if (!ItemTemplate.bInfiniteItem)
// 		return;
// 
// 	// Add the item if it's a starting item, or if the schematic or tech that produces it has been acquired.
// 	if (ItemTemplate.StartingItem || XComHQ.HasItemByName(ItemTemplate.CreatorTemplateName) || XComHQ.IsTechResearched(ItemTemplate.CreatorTemplateName))
// 	{	
// 		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Add items to HQ:" $ ItemName);
// 		XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(XComHQ.Class, XComHQ.ObjectID));
// 		ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
// 		XComHQ.AddItemToHQInventory(ItemState);	
// 		`XCOMHISTORY.AddGameStateToHistory(NewGameState);
// 	}
// }


// Purpose: adds tech state to a campaign if the mod adding this tech is added mid-campaign.
// Use: only from OnLoadedSavedGame() and other similar functions.
// DO NOT use from InstallNewCampaign(), it's unnecessary and will break the game.
// 
// static private function AddTechStateIfNotPresent(const name ProjectName)
// {
// 	local X2StrategyElementTemplateManager	StratMgr;
// 	local XComGameState						NewGameState;
// 	local X2TechTemplate					TechTemplate;
// 
// 	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
// 	if (!IsResearchInHistory(ProjectName))
// 	{
// 		TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate(ProjectName));
// 		if (TechTemplate != none)
// 		{
// 			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding Tech State: " $ ProjectName);
// 			NewGameState.CreateNewStateObject(class'XComGameState_Tech', TechTemplate);
// 			`XCOMHISTORY.AddGameStateToHistory(NewGameState);
// 		}
// 	}
// }

// Purpose: helper function for AddTechStateIfNotPresent()
// Use: no need to use manually.
// 
// static private function bool IsResearchInHistory(const name ResearchName)
// {
// 	local XComGameState_Tech	TechState;
// 	local XComGameStateHistory	History;
// 	
// 	History = `XCOMHISTORY;
// 
// 	foreach History.IterateByClassType(class'XComGameState_Tech', TechState)
// 	{
// 		if (TechState.GetMyTemplateName() == ResearchName)
// 		{
// 			return true;
// 		}
// 	}
// 	return false;
// }

//=======================================================================================
//                                  DLC HOOKS
//---------------------------------------------------------------------------------------

// Purpose: creating and modifying state objects at campaign start.
// Runs: every time the player starts a new campaign. Also runs at every game start
// due to the game starting a fake campaign to display a soldier behind the main menu.
//
// static event InstallNewCampaign(XComGameState StartState)
// {
// 
// }

//=======================================================================================
//                       FINALIZE UNIT ABILITIES FOR INIT
//---------------------------------------------------------------------------------------

// Purpose: making changes to the list of abilities that will be initialized for the unit
// when they will enter tactical.
// Runs: right before the unit enters tactical.
//
// static function FinalizeUnitAbilitiesForInit(XComGameState_Unit UnitState, out array<AbilitySetupData> SetupData, optional XComGameState StartState, optional XComGameState_Player PlayerState, optional bool bMultiplayerDisplay)
// {
// }

// Purpose: adds the specified ability and its additional abilities to a unit.
// Use: only from FinalizeUnitAbilitiesForInit().
//
// static private function GrantAbility(const name TemplateName, const StateObjectReference WeaponRef, out array<AbilitySetupData> SetupData)
// {
// 	local X2AbilityTemplate			AbilityTemplate;
// 	local X2AbilityTemplate			AdditionalAbility;
// 	local AbilitySetupData			NewSetupData;
// 	local name						AdditionalAbilityName;
// 	local X2AbilityTemplateManager	AbilityTemplateManager;
// 
// 	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
// 	
// 	AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(TemplateName);
// 	if (AbilityTemplate == none)
// 		return;
// 	
// 	NewSetupData.TemplateName = TemplateName;
// 	NewSetupData.Template = AbilityTemplate;
// 	NewSetupData.SourceWeaponRef = WeaponRef;
// 	SetupData.AddItem(NewSetupData);
// 
// 	foreach AbilityTemplate.AdditionalAbilities(AdditionalAbilityName)
// 	{
// 		AdditionalAbility = AbilityTemplateManager.FindAbilityTemplate(AdditionalAbilityName);
// 		if (AdditionalAbility == none)
// 			continue;
// 			
// 		NewSetupData.TemplateName = AdditionalAbilityName;
// 		NewSetupData.Template = AdditionalAbility;
// 		SetupData.AddItem(NewSetupData);
// 	}
// }

//======================================================================================
//                            HIGHLANDER DLC HOOKS
//
// These hooks will run only if Highlander is active.
//---------------------------------------------------------------------------------------

// Purpose: making changes right before creating templates. Can also be used as a way
// to run code that needs to run as early as possible.
// Runs: every time the game starts, before creating templates.
//
// static function OnPreCreateTemplates()
// {
// 	
// 

// Purpose: making changes to weapon visualizer after it has been initialized.
// Typical use case: reskinning a weapon or replacing its animations or projectile.
// Runs: every time a weapon visualizer is created for a soldier.
//
// static function WeaponInitialized(XGWeapon WeaponArchetype, XComWeapon Weapon, optional XComGameState_Item ItemState = none)
// {
// 	local XComGameState_Unit	UnitState;
// 	local X2WeaponTemplate		WeaponTemplate;
// 
//  if (ItemState == none) 
// 	{	
// 		ItemState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(WeaponArchetype.ObjectID));
// 	}
// 	if (ItemState == none)
// 		return;
// 
// 	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ItemState.OwnerStateObject.ObjectID));
// 	if (UnitState == none || UnitState.GetMyTemplate().bIsCosmetic) 
// 		return;
// 
// 	WeaponTemplate = X2WeaponTemplate(ItemState.GetMyTemplate());
// 	if (WeaponTemplate == none)
// 		return;
// 		
// }


// Purpose: bypassing or creating restrictions on what items can be equipped by the unit.
// Use sparingly: not good for performance.
// Use carefully: improper use may break soldiers' inventory.
// Runs: every time the unit attempts to equip an item.
//
// static function bool CanAddItemToInventory_CH_Improved(out int bCanAddItem, const EInventorySlot Slot, const X2ItemTemplate ItemTemplate, int Quantity, XComGameState_Unit UnitState, optional XComGameState CheckGameState, optional out string DisabledReason, optional XComGameState_Item ItemState) 
// {
//     local XGParamTag                    LocTag;
//     local bool							OverrideNormalBehavior;
//     local bool							DoNotOverrideNormalBehavior;
//     local X2SoldierClassTemplateManager Manager;
// 
//     OverrideNormalBehavior = CheckGameState != none;
//     DoNotOverrideNormalBehavior = CheckGameState == none;
// 
//     if(DisabledReason != "")
//         return DoNotOverrideNormalBehavior;
// 
// 	// Example of overriding behavior to forbid a soldier of a specific soldier class from equipping a certain item.
// 	if (ItemNotAllowedForSoldierClass()) // Implement your check here
// 	{
// 		Manager = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
// 		LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
// 		LocTag.StrValue0 = Manager.FindSoldierClassTemplate(UnitState.GetSoldierClassTemplateName()).DisplayName;
// 		DisabledReason = class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(`XEXPAND.ExpandString(class'UIArmory_Loadout'.default.m_strUnavailableToClass));
// 		bCanAddItem = 0;
// 		return OverrideNormalBehavior;
// 	}
// 
// 	// Example of overriding behavior to forbid a specific soldier from equipping an item of a specific category.
// 	if (ItemCategoryNotAllowedForUnit()) // Implement your check here
// 	{
// 		LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
// 		LocTag.StrValue0 = ItemTemplate.GetLocalizedCategory(); // or ItemTemplate.FriendlyName
// 		DisabledReason = class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(`XEXPAND.ExpandString(class'UIArmory_Loadout'.default.m_strCategoryRestricted));
// 		bCanAddItem = 0;
// 		return OverrideNormalBehavior;
// 	}
// 
// 	// Example of overriding behavior to allow a specific soldier equipping a specific item.
// 	if (ItemAllowedForUnit()) // Implement your check here
// 	{
// 		// Must check if the slot is already occupied before overriding normal behavior to allow equipping the item.
// 		// If we don't do this, the soldier will end up with multiple items in the same slot.
// 		// For multi-item slots the check would be different.
// 		if (CheckGameState != none && UnitState.GetItemInSlot(Slot, CheckGameState) == none)
// 		{
// 			bCanAddItem = 1;
// 		}
// 		DisabledReason = "";
// 		return OverrideNormalBehavior;
// 	}
// 	
//     return DoNotOverrideNormalBehavior;
// }

// Sockets Part 3 of 3: add new sockets to all pawns.
// Purpose: adding or modifying skeletal mesh sockets for unit pawns.
// Runs: every time a unit pawn enters play.
// Use: original intent for this function is to return a path to a copy of
// soldier head mesh with new sockets, and then the Highlander would copy new sockets
// from the head mesh to the pawn's skeletal mesh. However, this method causes 
// redscreens, requires dynamic asset loading every time a pawn enters play, 
// and is hugely inconvenient when sockets must be added conditionally.
// Optimization: declare new socket objects as class variables,
// configure them in defaultproperties, and append to the mesh directly.
//
// static function string DLCAppendSockets(XComUnitPawn Pawn)
// {
// 	local array<SkeletalMeshSocket> NewSockets;
// 
// 	NewSockets.AddItem(default.ExampleSocket);
// 
// 	Pawn.Mesh.AppendSockets(NewSockets, true);
// 
// 	return "";
// }

// Purpose: adding new AnimSets to the unit pawn or overriding existing ones.
// Runs: every time a unit pawn updates animations, which happens when the pawn enters
// play, and later more as needed.
// Use sparingly: UpdateAnimations should be your last resort, as it runs a lot,
// and is not optimal for performance.
//
// static function UpdateAnimations(out array<AnimSet> CustomAnimSets, XComGameState_Unit UnitState, XComUnitPawn Pawn)
// {
// 
// }

// Purpose: using dynamic values in ability localization.
// Runs: every time a localized string is expanded. 
// This can happen during template creation or dynamically as needed. 
// Instructions:
// https://www.reddit.com/r/xcom2mods/wiki/index/localization#wiki_abilitytagexpandhandler
//
// static function bool AbilityTagExpandHandler_CH(string InString, out string OutString, Object ParseObj, Object StrategyParseOb, XComGameState GameState)
// {	
// 	switch (InString)
// 	{
// 	case "YourUniqueTag":
// 		OutString = YourDynamicValue;
// 		return true;
// 
// 	default:
// 		return false;
// 	}
// 
// 	return false;
// }

// Purpose: helper function for AbilityTagExpandHandler_CH().
// Use: to reduce the displayed number of decimals after the dot.
// Credit: originally created by Pavonis for LW2 rocket scatter text.
//
// static private function string TruncateFloat(float fValue)
// {
// 	local string TempString;
// 	local string FloatString;
// 	local int i;
// 	local float TestFloat;
// 	local float TempFloat;
// 	local int places;
// 
// 	TempFloat = value;
// 	
// 	// How many decimals after the dot should be displayed.
// 	places = 2;
// 	
// 	for (i=0; i < places; i++)
// 	{
// 		TempFloat *= 10.0;
// 	}
// 	
// 	TempFloat = Round(TempFloat);
// 	for (i=0; i < places; i++)
// 	{
// 		TempFloat /= 10.0;
// 	}
// 
// 	TempString = string(TempFloat);
// 	for (i = InStr(TempString, ".") + 1; i < Len(TempString) ; i++)
// 	{
// 		FloatString = Left(TempString, i);
// 		TestFloat = float(FloatString);
// 		if (TempFloat ~= TestFloat)
// 		{
// 			break;
// 		}
// 	}
// 
// 	if (Right(FloatString, 1) == ".")
// 	{
// 		FloatString $= "0";
// 	}
// 
// 	return FloatString;
// }

// Purpose: helper function for AbilityTagExpandHandler_CH().
// Use: get the name of the weapon to which the ability is bound.
// Typical use case: dynamic localization for an ability that can be assigned
// to different inventory slots for a soldier class.
//
// static private function string GetBoundWeaponName(Object ParseObj, Object StrategyParseObj, XComGameState GameState)
// {
// 	local X2AbilityTemplate		AbilityTemplate;
// 	local X2ItemTemplate		ItemTemplate;
// 	local XComGameState_Effect	EffectState;
// 	local XComGameState_Ability	AbilityState;
// 	local XComGameState_Item	ItemState;
// 
// 	AbilityTemplate = X2AbilityTemplate(ParseObj);
// 	if (StrategyParseObj != none && AbilityTemplate != none)
// 	{
// 		ItemTemplate = GetItemBoundToAbilityFromUnit(XComGameState_Unit(StrategyParseObj), AbilityTemplate.DataName, GameState);
// 	}
// 	else
// 	{
// 		EffectState = XComGameState_Effect(ParseObj);
// 		if (EffectState != none)
// 		{
// 			AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
// 		}
// 		else
// 		{
// 			AbilityState = XComGameState_Ability(ParseObj);
// 		}
// 
// 		if (AbilityState != none)
// 		{
// 			ItemState = AbilityState.GetSourceWeapon();
// 
// 			if (ItemState != none)
// 				ItemTemplate = ItemState.GetMyTemplate();
// 		}
// 	}
// 
// 	if (ItemTemplate != none)
// 	{
// 		return ItemTemplate.GetItemAbilityDescName();
// 	}
// 	return AbilityTemplate.LocDefaultPrimaryWeapon;
// }


// Purpose: helper function for GetBoundWeaponName().
// Use: no need to use manually.
//
// static private function X2ItemTemplate GetItemBoundToAbilityFromUnit(XComGameState_Unit UnitState, name AbilityName, XComGameState GameState)
// {
// 	local SCATProgression		Progression;
// 	local XComGameState_Item	ItemState;
// 	local EInventorySlot		Slot;
// 
// 	if (UnitState == none)
// 		return none;
// 
// 	Progression = UnitState.GetSCATProgressionForAbility(AbilityName);
// 	if (Progression.iRank == INDEX_NONE || Progression.iBranch == INDEX_NONE)
// 		return none;
// 
// 	Slot = UnitState.AbilityTree[Progression.iRank].Abilities[Progression.iBranch].ApplyToWeaponSlot;
// 	if (Slot == eInvSlot_Unknown)
// 		return none;
// 
// 	ItemState = UnitState.GetItemInSlot(Slot, GameState);
// 	if (ItemState != none)
// 	{
// 		return ItemState.GetMyTemplate();
// 	}
// 
// 	return none;
// }

// Purpose: helper function for AbilityTagExpandHandler_CH().
// Use: apply HTML hex color to a string. 
// Tip: If you need multiple colors, creating copies of the function with hardcoded
// color values is recommended for convenience.
// Tip: hex color codes can be acquired at https://htmlcolorcodes.com/
// 
// static private function string ColorText(coerce string strInput)
// {
// 	return "<font color='#ffd700'>" $ strInput $ "</font>"; // gold
// }



//=======================================================================================
//                                    EMPT HELPERS
//---------------------------------------------------------------------------------------

// Purpose: checks if the mod with the specified modname is active.
// Tip: modname is the name of the .XComMod file without the extension.
// Use: Use from anywhere, but preferably cache the check into a global config bool var
// and then check the var. Explained in detail here:
// https://www.reddit.com/r/xcom2mods/wiki/index/good_coding_practices#wiki_1._assign_the_default_value_of_a_config_var_from_anywhere_in_the_code
//
// static final function bool IsModActive(const name ModName)
// {
//     local XComOnlineEventMgr    EventManager;
//     local int                   Index;
// 
//     EventManager = `ONLINEEVENTMGR;
// 
//     for (Index = EventManager.GetNumDLC() - 1; Index >= 0; Index--) 
//     {
//         if (EventManager.GetDLCNames(Index) == ModName) 
//         {
//             return true;
//         }
//     }
//     return false;
// }

//---------------------------------------------------------------------------------------

// defaultproperties
// {
// 	// Sockets Part 2 of 3: set up new socket's properties.
// 	// These can be copied directly from the socket editor.
// 	Begin Object Class=SkeletalMeshSocket Name=DefaultExampleSocket
// 		SocketName = "SocketName"
// 		BoneName = "BoneName"
// 		RelativeRotation=(Pitch=0, Yaw=0, Roll=0)
// 	End Object
// 	ExampleSocket = DefaultExampleSocket;
// }
