@echo off

@REM echo BUILDING: HTML5
@REM lime build html5 -clean --times

echo BUILDING: WINDOWS
lime build windows -clean --times

@REM echo UPLOADING: HTML5
@REM butler push ./export/release/html5/bin bopel-maki-macohi/simple-click:html5 --userversion-file version.txt
echo UPLOADING: WINDOWS
butler push ./export/release/windows/bin bopel-maki-macohi/simple-click-private:windows --userversion-file version.txt

@REM .\dev/zip.bat