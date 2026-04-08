cd "export/release/html5/bin/"
wsl zip -r "html5.zip" *
wsl mv "html5.zip" ../../../../export/

cd "../../../../export/release/windows/bin/"
wsl zip -r "windows.zip" *
wsl mv "windows.zip" ../../../../export/