$uname = Read-Host -Prompt "Username: "
$passwd = Read-Host -Prompt "Password: " -MaskInput

# Define vCenter server details
$vcenterServers = @(
    @{ Name = "<VCenter1 Common Name>"; Server = "<VCenter1 FQDN>" },
    @{ Name = "<VCenter2 Common Name>"; Server = "<VCenter2 FQDN>" }
    ###  Add as many VCenter servers as needed  ###
)

# Loop through each vCenter server and attempt to connect
foreach ($vcenter in $vcenterServers) {
    try {
        # Connect to vCenter server
        Connect-VIServer -Server $vcenter.Server -User $uname -Password $passwd -ErrorAction Stop

        # Check if the connection was successful
        if ($?) {
            Write-Host "Successfully connected to $($vcenter.Name) ($($vcenter.Server))" -ForegroundColor Green
            # Perform operations on the connected vCenter server here
            # Example: Get-VM
        } else {
            Write-Host "Failed to connect to $($vcenter.Name) ($($vcenter.Server))" -ForegroundColor Red
        }
    } catch {
        Write-Host "Error connecting to $($vcenter.Name) ($($vcenter.Server)): $($_.Exception.Message)" -ForegroundColor Red
    }

}
