@echo off
REM Rebuild FoxFW SD-card release zips.
REM   rebuild_release_zips.bat          builds BOTH (core + wav_player)
REM   rebuild_release_zips.bat -Core    core.zip only (the one that usually changes)
REM   rebuild_release_zips.bat -Music   wav_player.zip only (rarely changes)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0rebuild_release_zips.ps1" %*
echo.
pause
