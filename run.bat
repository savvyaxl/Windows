@echo off
rem set "CurrentDir=%cd%"
rem echo The current directory is: %CurrentDir%
rem powershell c:\temp\GetDate.ps1

setlocal

rem Get current directory
set "CurrentDir=%cd%"
echo Current directory is: %CurrentDir%

rem Run PowerShell script and capture output
for /f "usebackq delims=" %%A in (`powershell -NoProfile -ExecutionPolicy Bypass -File "GetDate.ps1"`) do (
    set "SelectedDate=%%A"
)

rem Handle Cancel case
if "%SelectedDate%"=="UserCancelled" (
    echo User cancelled the date selection.
	rem Otherwise, show the selected date
)

echo Selected date is: %SelectedDate%


endlocal
