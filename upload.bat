@echo off

echo BUILDING: HTML5
lime build htmls --times

echo BUILDING: WINDOWS
lime build windows --times

echo UPLOADING: HTML5
butler push ./export/release/html5/bin bopel-maki-macohi/simple-click:html5 --userversion-file version.txt
echo UPLOADING: WINDOWS
butler push ./export/release/windows/bin bopel-maki-macohi/simple-click:windows --userversion-file version.txt

.\dev/zip.bat