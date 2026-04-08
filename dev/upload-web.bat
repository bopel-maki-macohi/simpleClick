@echo off
echo BUILDING HTML5
lime build html5
echo UPLOADING TO ITCH
butler push ./export/release/html5/bin bopel-maki-macohi/simple-click:html5