$uname = Read-Host -Prompt "Username: "
$passwd = Read-Host -Prompt "Password: " -MaskInput

# Define vCenter server details
$vcenterServers = @(
    @{ Name = "HO-rack-1-vc-1"; Server = "rack-1-vc-1.vcfho.secure.capfed.com" },
    @{ Name = "HO-rack-1-vc-3"; Server = "rack-1-vc-3.vcfho.secure.capfed.com" },
    @{ Name = "HO-vcenter-1"; Server = "vcenter-1.vcfho.secure.capfed.com" },
    @{ Name = "NH-rack-1-vc-2"; Server = "rack-1-vc-2.vcfnh.secure.capfed.com" },
    @{ Name = "NH-rack-1-vc-3"; Server = "rack-1-vc-3.vcfnh.secure.capfed.com" },
    @{ Name = "NH-vcenter-1"; Server = "vcenter-1.vcfnh.secure.capfed.com" },
    @{ Name = "BR-cfbrvctr01"; Server = "cfbrvctr01.secure.capfed.com" }
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