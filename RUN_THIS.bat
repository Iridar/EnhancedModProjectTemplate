@echo off

REM vstemplate cannot create files near solution file, only inside the project folder.
REM And X2ModBuildCommon files need to be in the solution folder.
REM The only solution is to create X2MBC files inside project folder, and then use this batch file to move them to the solution folder.

move ".gitignore" "..\.gitignore"
move ".scripts" "..\.scripts"

REM vstemplate cannot create empty folders, so we do it here.

mkdir "Content"
mkdir "ContentForCook"

REM Use the shipped text editor.
REM vstemplate requires the XCOM2.targets to be present and readable, and the XCOM2.targets is located in the X2MBC folder we have moved,
REM so we adjust the .x2proj file to point to the new location of the .targets file.

replace_text.exe $ModSafeName$.x2proj "<SolutionRoot>$(MSBuildProjectDirectory)\</SolutionRoot>" "<SolutionRoot>$(MSBuildProjectDirectory)\..\</SolutionRoot>"

REM All files created by vstemplate need to be referenced in .x2proj file during project creation,
REM but X2MBC and some of the others don't need to be there, so clean them out.

replace_text.exe $ModSafeName$.x2proj --remove --c-style ".scripts\\X2ModBuildCommon\\XCOM2.targets"
replace_text.exe $ModSafeName$.x2proj --remove --c-style ".scripts\\X2ModBuildCommon\\README.md"
replace_text.exe $ModSafeName$.x2proj --remove --c-style ".scripts\\X2ModBuildCommon\\LICENSE"
replace_text.exe $ModSafeName$.x2proj --remove --c-style ".scripts\\X2ModBuildCommon\\InvokePowershellTask.cs"
replace_text.exe $ModSafeName$.x2proj --remove --c-style ".scripts\\X2ModBuildCommon\\EmptyUMap"
replace_text.exe $ModSafeName$.x2proj --remove --c-style ".scripts\\X2ModBuildCommon\\clean_cooker_output.ps1"
replace_text.exe $ModSafeName$.x2proj --remove --c-style ".scripts\\X2ModBuildCommon\\clean.ps1"
replace_text.exe $ModSafeName$.x2proj --remove --c-style ".scripts\\X2ModBuildCommon\\CHANGELOG.md"
replace_text.exe $ModSafeName$.x2proj --remove --c-style ".scripts\\X2ModBuildCommon\\build_common.ps1"
replace_text.exe $ModSafeName$.x2proj --remove --c-style ".scripts\\build.ps1"
replace_text.exe $ModSafeName$.x2proj --remove --c-style ".gitignore"
replace_text.exe $ModSafeName$.x2proj --remove --c-style "RUN_THIS.bat"
replace_text.exe $ModSafeName$.x2proj --remove --c-style "replace_text.exe"

REM " and \ are tough to handle, so it needs to be done in two steps.

replace_text.exe $ModSafeName$.x2proj --remove --c-style .scripts\\X2ModBuildCommon\\
replace_text.exe $ModSafeName$.x2proj --remove --c-style .scripts\\

replace_text.exe $ModSafeName$.x2proj --remove --c-style "<Folder Include=\"\" />"
replace_text.exe $ModSafeName$.x2proj --remove --c-style "<Content Include=\"\" />"

REM Bandaid fix for path to XCOM2.targets file we ruined by one of the commands above.

replace_text.exe $ModSafeName$.x2proj "$(SolutionRoot)" $(SolutionRoot).scripts\\

echo X2ModBuildCommon v1.2.1 successfully installed. > ReadMe.txt
echo Edit build.ps1 if you want to enable cooking. >> ReadMe.txt
echo Enjoy making your mod, and may the odds be ever in your favor. >> ReadMe.txt

REM Delete text editor.
del replace_text.exe

REM Delete this batch file.
del %0