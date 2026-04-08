@echo off
echo BUILDING HTML5
lime build html5
echo UPLOADING TO ITCH
butler push ./export/release/html5/bin https://bopel-maki-macohi.itch.io/simple-click:html5