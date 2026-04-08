@echo off
echo BUILDING WINDOWS
lime build windows
echo UPLOADING TO ITCH
butler push ./export/release/windows/bin https://bopel-maki-macohi.itch.io/simple-click:windows