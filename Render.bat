@echo off
:blender
Echo by Github.com/Admin368
Echo Checking For Blender in System Path
where blender >loc.txt 2>null
Set /P blenderlocation=<loc.txt
echo %blenderlocation%|findstr /i blender.exe
if %errorlevel% equ 0 (
Rem if "%errorlevel%"=="0" (
Echo Blender Successfully Found
timeout /t 2
goto :Brute
) else (
Rem if "%errorlevel%"=="1" (
Echo Blender not Set in System Variables
Echo Searching For Blender Location
Echo Please Set Blender in System Variables
Echo To avoid this Process Everytime
Echo Please Wait, Might Take A Moment
for /f "delims=" %%a in ('
wmic product where "Name='blender\'" get InstallLocation ^| find "\"
') do set blenderlocation=%%a
Rem echo %blenderlocation%|findstr /i blender
cd \d %blenderlocation%
if exist blender.exe (
Echo Blender Location Found
Echo Blender_Location %blenderlocation%
Echo Adding Blender To System PATH
cd \d C:\
goto :Path
)
Echo Blender Not Found %blenderlocation%
Echo Please Add it Maunally And Try Again
pause
goto :EOF
)
)
goto :blender


:Path
set PATH=%PATH%;%blenderlocation%
goto :Blender
:Brute
Echo Wuld you like to Brute Force Through it
Echo With Default Settings set in you Project
Echo Make a copy of the file you want to render 
Echo And Make Sure to Name the copied file is called "Auto_Render.blend"
set /p brute_force=Brute_Force?[Yes/No]:
if /i '%brute_force%' == 'yes' goto :Brute_Yes
if /i '%brute_force%' == 'y' goto :Brute_Yes
if /i '%brute_force%' == 'no' goto :Manual
if /i '%brute_force%' == 'n' goto :Manual
goto :Brute

:Brute_Yes
blender -b Auto_Render.blend -a
if %errorlevel% equ 0 Echo No file Auto_Render Found
goto :EOF

:Manual
:File_Location
set /p file_location=File_Location(can_skip):
if NOT '%file_location%' == '' (goto :Render_Location
) else (
        if exist %file_location% (
        cd /d %file_location%
        goto :Render_Location
    ) else (
        Echo '%file_location%' Not Found
        Echo Enter Correct Folder Name
        Echo Leave blank if in Correct Folder
        goto :File_Location
    )
)
goto :File_location

:Render_Location
set /p render_location=Render_Location(can_skip):
if NOT '%render_location%' == '' (
if exist %render_location% (goto :Name)
)
Echo No Render Location Preference Found
Echo Creating Render Location
set %render_location%=Render
mkdir %render_location%
goto : Name


:Name
if exist Auto_Render.blend (
    Echo Auto_Render.Blend Found
    Echo Press Y To Use
    set /p Ans:[y/n]:
    if '%ans%' == 'y' (
        Echo Auto_Render Accepted
        Set file_name=Auto_Render
        goto :Frames
    )
)
:Name2
set /p file_name=File_Name:
if exist %file_name% (
    goto :Frames
) else (
    Echo File Not File
    Echo Enter Correct File Name
    goto :Name
)
goto :Name2


:Frames
set /p start_frame=start_frame:
set /p end_frame=End_frame:

:Engine
Echo Use the Number to Select Engine
Echo 1 for EEVEE
Echo 2 for CYCLES
set /p render_engine=Render_Engine:
if '%render_engine%' == '1' (
set render_engine=BLENDER_EEVEE   
goto :Procedure)
if '%render_engine%' == '2' (
set render_engine=CYCLES
goto :Procedure)
if /i '%render_engine%' == 'eevee' (
set render_engine=BLENDER_EEVEE   
goto :Procedure)
if /i '%render_engine%' == 'cycles' (
set render_engine=CYCLES
goto :Procedure)
goto : Engine

:Procedure

:1
echo %file_name%|findstr /i ".blend"
if %errorlevel% equ 0 (
blender -b %file_name% -E %Render_Engine% -s %start_frame% -e %End_frame% -o %render_location% -a
)

:2

Rem CYCLES
BLENDER_EEVEE
Rem blender -b OR_1.4.2.blend -E BLENDER_EEVEE -s 9 -e 10 -a

:EOF