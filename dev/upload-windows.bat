@echo off
echo BUILDING WINDOWS
lime build windows
echo UPLOADING TO ITCH
butler push ./export/release/windows/bin bopel-maki-macohi/simple-click:windows