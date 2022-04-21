# Enhanced Mod  Project Template

Enhanced Mod  Project Template (EMPT) is an XCOM 2 War of the Chosen mod project template. It can be used to create new mods quickly, without spending time and effort on menial tasks, like setting up [X2ModBuildCommon](https://github.com/X2CommunityCore/X2ModBuildCommon) manually.

It also contains Config Engine, and some commonly used or referenced snippets of Unreal Script, and some global macros.

## Installation

Follow these instructions if you have not used EMPT previously.

1. Download the .zip archive with the [latest release](https://github.com/Iridar/EnhancedModProjectTemplate/releases/latest).
2. Put it here: `..\steamapps\common\XCOM 2 War of the Chosen SDK\Binaries\Win32\ModBuddy\Extensions\Application\ProjectTemplates\XCOM2Mod\1033`
3. Done. The next time you create a new mod project with modbuddy, select the Enhanced Mod project template.

## Updating

Follow these instructions if you have already installed and used EMPT. Modbuddy caches the previously used Mod Project templates, so just replacing the file is not enough for the update to take effect.

1. Download the .zip archive with the [latest release](https://github.com/Iridar/EnhancedModProjectTemplate/releases/latest). 
2. Move all files out of this folder: `..\steamapps\common\XCOM 2 War of the Chosen SDK\Binaries\Win32\ModBuddy\Extensions\Application\ProjectTemplates\XCOM2Mod\1033`
3. Start Modbuddy and click to create a new mod project. You should see only the Blank Project template.
4. Cancel the dialog and close Modbuddy.
5. Move files back into the mentioned folder.
6. Put the updated EMPT .zip archive there as well, replacing the old file.
7. Done. The next time you create a new mod project with Modbuddy, the updated Enhanced Mod project template will be available.

## Usage

1) Use Modbuddy to create the mod project using Enhanced Mod project template.

**Note:** when creating mod projects using this project template, it is **extremely important** that project Name, Solution name and Title match **exactly**. Otherwise there will be issues during first time setup and the mod project will become broken.

2) Perform once-per-project setup by running the "RUN_THIS.bat" batch file inside the created mod project directory. The file will automatically delete itself afterwards.

3) Enjoy. If your mod project doesn't require some of the files and folders created by EMPT, feel free to delete them.

4) As with any other mod project that uses X2MobBuildCommon, you have to use [Alternative Mod Uploader](https://steamcommunity.com/sharedfiles/filedetails/?id=1134322341) to upload it to workshop.

## X2ModBuildCommon

EMPT includes [X2ModBuildCommon](https://github.com/X2CommunityCore/X2ModBuildCommon) of version 1.2.1. 

### Localization

The localization files shipped with the mod project use UTF-8 encoding, so changes to them can be previewed by Git and other version control systems. Modbuddy creates UTF-16 localization files by default, so if you need more localization files, it is preferable to copy the existing ones, rather than create new ones.

### Cooking

To enable cooking with X2MBC, open `.scripts\build.ps1` file and uncomment the `$builder.SetContentOptionsJsonFilename("ContentOptions.json")` line by removing the `#` at the start.

You can find some basic instructions for [cooking here](https://www.reddit.com/r/xcom2mods/wiki/index/cooking_for_dummies).

### Global Macros

X2MBC allows adding more global macros to be used in your mod project. EMPT comes with a few macros included, notably the `AMLOG()` macro, which is more compact and can be used to toggle all logging in one place.

## Config Engine

Config Engine is an Unreal Script helper class that makes it easier to set up configurable variables. Full documentation is in the comments inside ConfigEngine.uc.

## Help.uc

Help.uc is an Unreal Script helper class with Unreal Script snippets of commonly used or referenced code. 

## Building against Highlander

To build your mod against Highlander, run this command in Git terminal:

`git submodule add https://github.com/X2CommunityCore/X2WOTCCommunityHighlander.git`

Then open `.scripts\build.ps1` and uncomment the `$builder.IncludeSrc("$srcDirectory\X2WOTCCommunityHighlander\X2WOTCCommunityHighlander\Src")` line by removing the `#` at the start.

# Credits

[Find And Replace Text](http://fart-it.sourceforge.net/) command line tool (replace_text.exe) by by Lionello Lunesu
