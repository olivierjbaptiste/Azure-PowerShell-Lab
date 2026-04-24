# =============================================================
# New-AzLabVM.ps1
# Deploy a simple Windows VM in Azure for learning purposes
# Author: Olivier Jean-Baptiste
# =============================================================

# Variables — customize these
$ResourceGroup = "MyLab-RG"
$Location      = "EastUS"
$VMName        = "MyLabVM"
$VMSize        = "Standard_B1s"

# Step 1 — Create Resource Group (skips if already exists)
Write-Host "Creating Resource Group..." -ForegroundColor Cyan
New-AzResourceGroup -Name $ResourceGroup -Location $Location -Force
Write-Host "Resource Group ready." -ForegroundColor Green

# Step 2 — Create the VM
Write-Host "Deploying VM — this takes 3-5 minutes..." -ForegroundColor Cyan
$VMParams = @{
    ResourceGroupName   = $ResourceGroup
    Name                = $VMName
    Location            = $Location
    Size                = $VMSize
    Image               = "MicrosoftWindowsServer:WindowsServer:2022-datacenter:latest"
    Credential          = Get-Credential -Message "Set your VM admin username and password"
    OpenPorts           = 3389
}
New-AzVM @VMParams
Write-Host "VM deployed successfully." -ForegroundColor Green

# Step 3 — Verify VM is running
Write-Host "Checking VM status..." -ForegroundColor Cyan
Get-AzVM -ResourceGroupName $ResourceGroup -Name $VMName -Status |
    Select-Object Name, @{N="Status";E={$_.Statuses[1].DisplayStatus}}
