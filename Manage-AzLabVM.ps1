$ResourceGroup = "MyLab-RG"
$VMName = "MyLabVM"

$Status = (Get-AzVM -ResourceGroupName $ResourceGroup -Name $VMName -Status).Statuses[1].DisplayStatus
Write-Host "Current VM Status: $Status" -ForegroundColor Cyan
Write-Host ""
Write-Host "What would you like to do?" -ForegroundColor Yellow
Write-Host "  1. Start VM"
Write-Host "  2. Stop VM"
Write-Host "  3. Check status"
Write-Host ""
$Choice = Read-Host "Enter selection (1-3)"

if ($Choice -eq "1") {
    Write-Host "Starting VM..." -ForegroundColor Cyan
    Start-AzVM -ResourceGroupName $ResourceGroup -Name $VMName
    Write-Host "VM started successfully." -ForegroundColor Green
} elseif ($Choice -eq "2") {
    Write-Host "Stopping VM..." -ForegroundColor Cyan
    Stop-AzVM -ResourceGroupName $ResourceGroup -Name $VMName -Force
    Write-Host "VM stopped successfully." -ForegroundColor Green
} else {
    Write-Host "VM Status: $Status" -ForegroundColor Green
}

$FinalStatus = (Get-AzVM -ResourceGroupName $ResourceGroup -Name $VMName -Status).Statuses[1].DisplayStatus
Write-Host ""
Write-Host "Final Status: $FinalStatus" -ForegroundColor Cyan