@echo off
setlocal enabledelayedexpansion
:menu
cls
echo ==================================================
echo    Rebuild FoxFW SD-card release zips
echo ==================================================
echo.
echo    [1]  Build BOTH            ( core.zip + wav_player.zip )
echo    [2]  core.zip only         ( usually the only one that changes )
echo    [3]  wav_player.zip only   ( rarely changes )
echo    [Q]  Quit
echo.
set "choice="
set /p "choice=Type 1, 2, 3 (or Q) and press Enter: "
if /i "%choice%"=="1" goto both
if /i "%choice%"=="2" goto core
if /i "%choice%"=="3" goto music
if /i "%choice%"=="Q" goto end
echo.
echo   "%choice%" is not a valid choice - please type 1, 2, 3 or Q.
echo.
pause
goto menu

:both
set "ARG="
goto run
:core
set "ARG=-Core"
goto run
:music
set "ARG=-Music"
goto run

:run
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0rebuild_release_zips.ps1" %ARG%
echo.
pause
goto end

:end
endlocal
