Param(
    [string] $srcDirectory, # the path that contains your mod's .XCOM_sln
    [string] $sdkPath, # the path to your SDK installation ending in "XCOM 2 War of the Chosen SDK"
    [string] $gamePath, # the path to your XCOM 2 installation ending in "XCOM2-WaroftheChosen"
    [string] $config # build configuration
)

$ScriptDirectory = Split-Path $MyInvocation.MyCommand.Path
$common = Join-Path -Path $ScriptDirectory "X2ModBuildCommon\build_common.ps1"
Write-Host "Sourcing $common"
. ($common)

$builder = [BuildProject]::new("$ModSafeName$", $srcDirectory, $sdkPath, $gamePath)

# Building against Highlander option 1:
# Use Git to add Highlander submodule by running this command in the terminal:
# git submodule add https://github.com/X2CommunityCore/X2WOTCCommunityHighlander.git
# Uncomment the next line to enable building against Highlander.
# $builder.IncludeSrc("$srcDirectory\X2WOTCCommunityHighlander\X2WOTCCommunityHighlander\Src")

# Building against Highlander option 2:
# Specify path to your local Highlander repository or the Highlander's mod folder,
# and uncomment the line:
# $builder.IncludeSrc("C:\Users\Iridar\Documents\Firaxis ModBuddy\X2WOTCCommunityHighlander\X2WOTCCommunityHighlander\Src")

# Uncomment to use additional global Custom Src to build against.
# $builder.IncludeSrc("C:\Users\Iridar\Documents\Firaxis ModBuddy\CustomSrc")

switch ($config)
{
    "debug" {
        $builder.EnableDebug()
    }
    "default" {
        # Nothing special
    }
    "" { ThrowFailure "Missing build configuration" }
    default { ThrowFailure "Unknown build configuration $config" }
}

# Uncomment this line to enable cooking.
# $builder.SetContentOptionsJsonFilename("ContentOptions.json")
$builder.InvokeBuild()