. "D:\data\navicat\script\rotation_script.ps1"
$exclude = ("daily", "monthly", "weekly","tst-mysql", "rds-itrack-logs", "rds-itrack-db")
$dir = Get-ChildItem D:\data\navicat\backup -Recurse -Directory -Exclude $exclude
foreach($folder in $dir){
    #Write-Host "Current directory is: $($folder.FullName)" -ForegroundColor Yellow
    Rotate-Logs -LogDir $folder
}