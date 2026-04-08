@echo off

echo HTML5
lime build html5 --times
butler push ./export/release/html5/bin bopel-maki-macohi/simple-click:html5 --userversion-file version.txt

echo WINDOWS
lime build windows --times
butler push ./export/release/windows/bin bopel-maki-macohi/simple-click:windows --userversion-file version.txt

.\dev/zip.bat