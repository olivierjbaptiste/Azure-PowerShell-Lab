# =============================================================
# Set-VMAutoShutdown.ps1
# Automatically shuts down a lab VM at a scheduled time daily
# Author: Olivier Jean-Baptiste
# =============================================================

$ResourceGroup = "MyLab-RG"
$VMName        = "MyLabVM"
$ShutdownTime  = "2300"
$TimeZone      = "Eastern Standard Time"
$Location      = "northcentralus"

$SubscriptionId = (Get-AzContext).Subscription.Id

$ScheduledShutdownResourceId = "/subscriptions/{0}/resourceGroups/{1}/providers/microsoft.devtestlab/schedules/shutdown-computevm-{2}" -f `
    $SubscriptionId, $ResourceGroup, $VMName

$Properties = @{
    status           = "Enabled"
    taskType         = "ComputeVmShutdownTask"
    dailyRecurrence  = @{ time = $ShutdownTime }
    timeZoneId       = $TimeZone
    targetResourceId = (Get-AzVM -ResourceGroupName $ResourceGroup -Name $VMName).Id
    notificationSettings = @{ status = "Disabled" }
}

New-AzResource -ResourceId $ScheduledShutdownResourceId `
               -Location $Location `
               -Properties $Properties `
               -Force

Write-Host "Auto-shutdown enabled — VM will shut down daily at 11:00 PM Eastern." -ForegroundColor Green
