$url = %CMK_AGENT_URL%
$ComputerName = get-adcomputer -Filter * | Sort-Object
 
foreach ($Computer in $ComputerName.DNSHostName)
{
    Write-host "Current computer: " $Computer
    $DestinationFolder = "\\$Computer\C$\Temp\"
    if (!(Test-Path -path $DestinationFolder))
    {
        New-Item $DestinationFolder -Type Directory
    }
    Invoke-WebRequest -Uri "$url" -OutFile "$DestinationFolder\check_mk_agent.msi"
    Invoke-Command -ComputerName $Computer -ScriptBlock {
        try {
            Start-Process -FilePath "msiexec" -ArgumentList "/i c:\Temp\check_mk_agent.msi /qn" -Wait
            }
        catch{
            Write-Host "Installation finished with errors."
        }
    }
}
