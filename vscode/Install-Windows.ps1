ForEach ($ln in (Get-Content .\Extensions)) {
    Write-Output ">> Install: $ln"
    code --install-extension "$ln"
}

Write-Output ">> Copy: settings.json"
Copy-Item .\settings.json "$env:APPDATA\Code\User\settings.json"

Write-Output ">> Done."