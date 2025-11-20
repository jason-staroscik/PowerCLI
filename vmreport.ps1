# Get Reports
#$vmReport = Get-VM | Get-VMGuest | Select-Object VMName, HostName, State, Notes
$vmReport = Get-VM | Select-Object Name, PowerState, @{N="OS HostName";E={$_.extensiondata.Guest.HostName}}, @{N="Configured OS";E={$_.extensiondata.Config.GuestFullName}}, @{N="Running OS";E={$_.extensiondata.Guest.GuestFullName}}, @{N="IP Address";E={$_.extensiondata.Guest.IpAddress}}, @{N="VM Tools Status";E={$_.extensiondata.Guest.ToolsStatus}}, @{N="Notes";E={$_.extensiondata.Config.Annotation}}
$vmSnapshotReport = Get-VM | Get-Snapshot | Select-Object VM, Name, Description, Created, SizeMB

# Define Excel Path
#$excelPath = "\\hofs01\homedirs\2962\My Documents\VMWReports\VMReport.xlsx"
#$filename = "VMReport-$([datetime]::Now.ToString("yyyyMMdd")).xlsx"
$excelPath = "\\hofs01\is\VMReport\VMReport-$([datetime]::Now.ToString("yyyyMMdd")).xlsx"

# Export to Excel with multiple sheets
$vmReport | Export-Excel -Path $excelPath -WorksheetName "VM Report" -AutoSize
$vmSnapshotReport | Export-Excel -Path $excelPath -WorksheetName "Snapshot Report" -AutoSize -Append

Write-Host "Multi-tab Excel Report generated: $excelPath"

# Get the credential
#$credential = Get-Credential

## Define the Send-MailMessage parameters
$mailParams = @{
    SmtpServer                 = '10.0.3.79' #'mail.secure.capfed.com'
    Port                       = '25' #'587' # or '25' if not using TLS
    UseSSL                     = $false ## or not if using non-TLS
    #Credential                 = $credential
    From                       = 'VMReport@capfed.com'
    #To                         = 'hoitserverinfrastructure@capfed.com'
    To                         = 'jstaroscik@capfed.com'
    Subject                    = "VM Report - $(Get-Date -Format g)"
    Body                       = 'A new VM report, including application and snapshot information, has been generated and saved at \\hofs01\is\VMReport\'
    DeliveryNotificationOption = 'OnFailure', 'OnSuccess'
}

## Send the message
Send-MailMessage @mailParams
