@echo off
set ver=1.0
mode con: cols=111 lines=35
color 76
title CSPSPdevTools-%ver%
set auto=0

:sign_binaries
cls
set check_counter=0
set fix=0
set prx=0
if exist C:\pspsdk\bin\fix-relocations.exe set /A fix += 1
if exist C:\pspsdk\bin\prxEncrypter.exe set /A prx += 2
set /A check_counter=%fix% + %prx%
::messages
:sign_check
if /i {%check_counter%}=={3} (set notification=/i\ Sign binaries are installed!) else (set notification=/!\ Sign binaries are NOT installed!)
if /i {%check_counter%}=={2} (set notification=/!\ You cannot sign any EBOOT.PBP, fix-relocations.exe is missing!)
if /i {%check_counter%}=={1} (set notification=/!\ You cannot sign any EBOOT.PBP, prxEncrypter.exe is missing!)
goto main_menu
:clsd
cls
if /i {%cleaned%}=={1} (set notification=/i\ Cleaned files!)
goto main_menu
:compd
cls
if /i {%compiled%}=={1} (set notification=/i\ Compiled!)
goto main_menu
:fcd
cls
if /i {%ffolder%}=={1} (set notification=/i\ Folder created!)
goto main_menu
:main_sign
cls
if /i {%fsigned%}=={1} (set notification=/i\ Signed EBOOT.PBP!) else (set notification=/i\ EBOOT.PBP not found! Compile CSPSP before choosing this!) 
goto main_menu

set error=0
:main_menu
echo(
echo(
echo 	Notifications ^> [ %notification% ]
echo 	^^^^^^^^^^^^^^^^^^^^^^^^^^
set cleaned=0
set compiled=0
set ffolder=0
set fsigned=0
::messages
echo(
echo 		(1) Clean
echo(
echo 		(2) Compile
echo(
echo 		(3) Sign EBOOT.PBP
echo(
echo 		(4) Create the final CSPSP folder
echo(
echo 		(5) Automatic (Clean, compile, sign and create the final folder)
echo(
echo(
echo 		(6) Credits and About
echo(
echo 		(0) Exit
echo(
if /i {%error%}=={1} (goto 1)
goto 0
:1
echo(
echo 	/!\ Please choose a correct option!
echo(
echo 	Choose an option:
set /p option=^>
echo(
set error=0
goto options_menu
:0
echo(
echo 	Choose an option:
set /p option=^>
echo(

:options_menu
if /i {%option%}=={1} (goto option1)
if /i {%option%}=={2} (goto option2)
if /i {%option%}=={3} (goto option3)
if /i {%option%}=={4} (goto option4)
if /i {%option%}=={5} (set auto=1
goto option1
)
if /i {%option%}=={6} (goto option6)
if /i {%option%}=={0} (exit)
cls
set error=1
goto main_menu

:option1
make -f Makefile.3xx clean
rm data.psp
set cleaned=1
cls
if /i {%auto%}=={0} (
goto clsd
)

:option2
make -f Makefile.3xx
set compiled=1
if /i {%auto%}=={0} (
pause
goto compd
)
echo(

:option3
if not exist EBOOT.PBP (
echo ^> error
echo /!\
set fsigned=0
cls
goto main_sign
)
echo ^> Signing...
echo(
fix-relocations.exe cspsp.prx
prxEncrypter.exe cspsp.prx
pack-pbp EBOOT.PBP PARAM.SFO icon.png NULL NULL pic1.png NULL data.psp NULL
echo(
echo ^> Finished!"
set fsigned=1
if /i {%auto%}=={0} (
goto main_sign
)
echo(

:option4
set /p input=Enter the version of your build : 
if exist CSPSP-%input% (
echo(
echo 	This version exists! Try again, you are an idiot.
echo(
goto option4
)

mkdir CSPSP-%input%
xcopy "bin" "CSPSP-%input%" /E /Y
xcopy "EBOOT.PBP" "CSPSP-%input%" /Y
echo(
set ffolder=1
if /i {%auto%}=={0} (
goto fcd
)
goto sign_binaries

:option6
cls
echo(             _______________
echo              ^|C R E D I T S^|
echo(
ping -n 1 localhost>nul
echo ^| Leajian (for the this tool programming and research)
echo(
ping -n 1 localhost>nul
echo ^| Kamil Jarosz(for some features of this program, which wouldn't be without him)
echo(
ping -n 1 localhost>nul
echo ^| wololo (for his guides and signing instructions)
echo(
ping -n 1 localhost>nul
echo ^| http://ss64.com (for all cmd information I needed)
echo(
ping -n 1 localhost>nul
echo ^| http://stackoverflow.com (for all questions I had)
echo(
ping -n 1 localhost>nul
echo ^| PLACEHOLDER (for those I forget)
echo(
ping -n 1 localhost>nul
echo(
echo +==================================================+
echo ^| Development tool for CSPSP.   :::   by Leajian   ^|
echo ^|==================================================+
echo ^| Features:                           ver. %ver%   ^|
echo ^|                                                  ^|
echo ^|  Compile CSPSP for 3xx kernel, sign EBOOT.PBP    ^|
echo ^|  and create the whole CSPSP game folder, ready   ^|
echo ^|  to copy to ms0:/PSP/GAME/ folder on your PSP.   ^|
echo +==================================================+
echo(
pause
goto sign_binaries