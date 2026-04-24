# =============================================================
# New-HubSpokeNetwork.ps1
# Deploy a Hub and Spoke Virtual Network in Azure
# Author: Olivier Jean-Baptiste
# =============================================================

$ResourceGroup = "MyLab-RG"
$Location      = "northcentralus"

Write-Host "Building Hub and Spoke Network..." -ForegroundColor Cyan
Write-Host ""

# ── Step 1: Create Hub VNet ──────────────────────────────────
Write-Host "Step 1 — Creating Hub VNet..." -ForegroundColor Yellow
$HubVNet = New-AzVirtualNetwork `
    -ResourceGroupName $ResourceGroup `
    -Location $Location `
    -Name "Hub-VNet" `
    -AddressPrefix "10.0.0.0/16"

# Add Hub Subnet
$HubSubnetConfig = Add-AzVirtualNetworkSubnetConfig `
    -Name "HubSubnet" `
    -AddressPrefix "10.0.1.0/24" `
    -VirtualNetwork $HubVNet

$HubVNet | Set-AzVirtualNetwork | Out-Null
Write-Host "Hub VNet created — 10.0.0.0/16" -ForegroundColor Green

# ── Step 2: Create Spoke 1 VNet (Your VM lives here) ─────────
Write-Host "Step 2 — Creating Spoke 1 VNet (VM Spoke)..." -ForegroundColor Yellow
$Spoke1VNet = New-AzVirtualNetwork `
    -ResourceGroupName $ResourceGroup `
    -Location $Location `
    -Name "Spoke1-VNet" `
    -AddressPrefix "10.1.0.0/16"

$Spoke1SubnetConfig = Add-AzVirtualNetworkSubnetConfig `
    -Name "Spoke1Subnet" `
    -AddressPrefix "10.1.1.0/24" `
    -VirtualNetwork $Spoke1VNet

$Spoke1VNet | Set-AzVirtualNetwork | Out-Null
Write-Host "Spoke 1 VNet created — 10.1.0.0/16" -ForegroundColor Green

# ── Step 3: Create Spoke 2 VNet (Future use) ─────────────────
Write-Host "Step 3 — Creating Spoke 2 VNet (Future Spoke)..." -ForegroundColor Yellow
$Spoke2VNet = New-AzVirtualNetwork `
    -ResourceGroupName $ResourceGroup `
    -Location $Location `
    -Name "Spoke2-VNet" `
    -AddressPrefix "10.2.0.0/16"

$Spoke2SubnetConfig = Add-AzVirtualNetworkSubnetConfig `
    -Name "Spoke2Subnet" `
    -AddressPrefix "10.2.1.0/24" `
    -VirtualNetwork $Spoke2VNet

$Spoke2VNet | Set-AzVirtualNetwork | Out-Null
Write-Host "Spoke 2 VNet created — 10.2.0.0/16" -ForegroundColor Green

# ── Step 4: Peer Hub to Spoke 1 ──────────────────────────────
Write-Host "Step 4 — Peering Hub to Spoke 1..." -ForegroundColor Yellow
$HubVNet = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroup -Name "Hub-VNet"
$Spoke1VNet = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroup -Name "Spoke1-VNet"

Add-AzVirtualNetworkPeering `
    -Name "Hub-to-Spoke1" `
    -VirtualNetwork $HubVNet `
    -RemoteVirtualNetworkId $Spoke1VNet.Id `
    -AllowForwardedTraffic | Out-Null

Add-AzVirtualNetworkPeering `
    -Name "Spoke1-to-Hub" `
    -VirtualNetwork $Spoke1VNet `
    -RemoteVirtualNetworkId $HubVNet.Id `
    -AllowForwardedTraffic | Out-Null

Write-Host "Hub <-> Spoke 1 peering established." -ForegroundColor Green

# ── Step 5: Peer Hub to Spoke 2 ──────────────────────────────
Write-Host "Step 5 — Peering Hub to Spoke 2..." -ForegroundColor Yellow
$Spoke2VNet = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroup -Name "Spoke2-VNet"

Add-AzVirtualNetworkPeering `
    -Name "Hub-to-Spoke2" `
    -VirtualNetwork $HubVNet `
    -RemoteVirtualNetworkId $Spoke2VNet.Id `
    -AllowForwardedTraffic | Out-Null

Add-AzVirtualNetworkPeering `
    -Name "Spoke2-to-Hub" `
    -VirtualNetwork $Spoke2VNet `
    -RemoteVirtualNetworkId $HubVNet.Id `
    -AllowForwardedTraffic | Out-Null

Write-Host "Hub <-> Spoke 2 peering established." -ForegroundColor Green

# ── Step 6: Verify Everything ─────────────────────────────────
Write-Host ""
Write-Host "Step 6 — Verifying network topology..." -ForegroundColor Yellow
Get-AzVirtualNetwork -ResourceGroupName $ResourceGroup |
    Select-Object Name, @{N="AddressSpace";E={$_.AddressSpace.AddressPrefixes}} |
    Format-Table -AutoSize

Write-Host "Hub and Spoke network deployed successfully." -ForegroundColor Green
Write-Host ""
Write-Host "Network Summary:" -ForegroundColor Cyan
Write-Host "  Hub-VNet    : 10.0.0.0/16 — Central hub for all traffic"
Write-Host "  Spoke1-VNet : 10.1.0.0/16 — Your VM spoke"
Write-Host "  Spoke2-VNet : 10.2.0.0/16 — Future spoke"
Write-Host "  Peerings    : Hub<->Spoke1, Hub<->Spoke2"