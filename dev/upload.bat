@echo off

echo BUILDING HTML5
lime build html5 --times

echo BUILDING WINDOWS
lime build windows --times


echo UPLOADING TO ITCH

butler push ./export/release/html5/bin bopel-maki-macohi/simple-click:html5
butler push ./export/release/windows/bin bopel-maki-macohi/simple-click:windows