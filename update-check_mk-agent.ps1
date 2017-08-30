$ComputerName = Get-Content 'list.txt'
$SourceFile = "\\SHARE\check_mk_agent.msi"
foreach ($Computer in $ComputerName)
{
    Write-host "Current computer: " $Computer
????$DestinationFolder = "\\$Computer\C$\Temp\"
????if (!(Test-Path -path $DestinationFolder))
????{
????????New-Item $DestinationFolder -Type Directory
????}
????Copy-Item -Path $SourceFile -Destination $DestinationFolder -Force
????Invoke-Command -ComputerName $Computer -ScriptBlock {
        try {
            Start-Process -FilePath "msiexec" -ArgumentList "/i c:\Temp\check_mk_agent.msi /qn" -Wait
            }
        catch{
            Write-Host "Installation finished with errors."
        }
    }
}