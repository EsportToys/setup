REM should write `start "vscode" "%~dp0..\Code.exe" %*`
set bat=start "vscode" "%%~dp0..\Code.exe" %%*
echo %bat% > %localappdata%\Programs\"Microsoft VS Code"\bin\code.bat