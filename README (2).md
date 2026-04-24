# Azure PowerShell Lab — Infrastructure Automation

A collection of PowerShell scripts for automating Azure infrastructure management using the Az PowerShell module. Built and tested in a personal Azure lab environment as part of a hands-on learning path toward AZ-104 and AZ-500 certifications.

---

## Overview

Instead of clicking through the Azure portal to deploy and manage virtual machines, these scripts handle common infrastructure tasks through a single PowerShell command. Each script is designed to be simple, reusable, and easy to customize for different environments.

**Key capabilities:**
- Deploy a Windows Server VM in Azure via PowerShell
- Start, stop, and check VM status through an interactive menu
- Configure automatic daily shutdown to save credits and control costs

---

## Scripts

### `New-AzLabVM.ps1`
Deploys a Windows Server 2022 VM in Azure with a single script execution.

**What it does:**
1. Creates a Resource Group if it doesn't exist
2. Prompts for VM admin credentials securely
3. Deploys a Windows Server 2022 VM with RDP port open
4. Verifies the VM is running after deployment

**Usage:**
```powershell
.\New-AzLabVM.ps1
```

**Configurable variables at the top of the script:**
```powershell
$ResourceGroup = "MyLab-RG"
$Location      = "northcentralus"
$VMName        = "MyLabVM"
$VMSize        = "Standard_B2als_v2"
```

---

### `Manage-AzLabVM.ps1`
Interactive script to start, stop, or check the status of your Azure lab VM.

**What it does:**
1. Checks and displays the current VM status
2. Presents an interactive menu
3. Executes the selected action and confirms the result

**Usage:**
```powershell
.\Manage-AzLabVM.ps1
```

**Example output:**
```
Current VM Status: VM deallocated

What would you like to do?
  1. Start VM
  2. Stop VM
  3. Check status

Enter selection (1-3): 1
Starting VM...
VM started successfully.
Final Status: VM running
```

---

### `Set-VMAutoShutdown.ps1`
Configures a daily automatic shutdown schedule for your Azure VM to prevent unnecessary credit consumption.

**What it does:**
- Enables auto-shutdown on the target VM
- Sets a daily shutdown time (default: 11:00 PM Eastern)
- Configures timezone automatically

**Usage:**
```powershell
.\Set-VMAutoShutdown.ps1
```

**Configurable variables:**
```powershell
$ShutdownTime = "2300"                    # 11:00 PM in 24hr format
$TimeZone     = "Eastern Standard Time"   # Your local timezone
```

---

## Requirements

- PowerShell 7+ — download at `aka.ms/powershell`
- Az PowerShell Module

### Install Az Module
```powershell
Install-Module Az -Scope CurrentUser -Force
```

### Connect to Azure
```powershell
Connect-AzAccount
```

---

## Setup

### 1. Clone the Repository
```bash
git clone https://github.com/YOUR-USERNAME/azure-powershell-lab.git
cd azure-powershell-lab
```

### 2. Connect to Your Azure Account
```powershell
Connect-AzAccount
```

### 3. Update Configuration Variables
Open each script and update the variables at the top to match your environment:
```powershell
$ResourceGroup = "YourResourceGroup"
$Location      = "YourPreferredRegion"
$VMName        = "YourVMName"
$VMSize        = "YourPreferredSize"
```

### 4. Deploy Your Lab VM
```powershell
.\New-AzLabVM.ps1
```

### 5. Set Auto-Shutdown
```powershell
.\Set-VMAutoShutdown.ps1
```

### 6. Manage Your VM Daily
```powershell
.\Manage-AzLabVM.ps1
```

---

### `New-HubSpokeNetwork.ps1`
Deploys a hub and spoke virtual network topology in Azure — the standard enterprise network architecture used in production Azure environments.

**What it does:**
1. Creates a Hub VNet (10.0.0.0/16) — central network all traffic flows through
2. Creates Spoke 1 VNet (10.1.0.0/16) — isolated network for workloads
3. Creates Spoke 2 VNet (10.2.0.0/16) — isolated network for future use
4. Peers Hub to Spoke 1 with forwarded traffic enabled
5. Peers Hub to Spoke 2 with forwarded traffic enabled
6. Verifies all peerings are connected

**Usage:**
```powershell
.\New-HubSpokeNetwork.ps1
```


## Finding Available VM Sizes

Azure for Students and free tier subscriptions have quota restrictions. Use this command to find VM sizes available in your region with no restrictions:

```powershell
Get-AzComputeResourceSku | Where-Object {
    $_.ResourceType -eq "virtualMachines" -and
    $_.Restrictions.Count -eq 0 -and
    $_.LocationInfo.Location -contains "YOUR-REGION"
} | Select-Object Name -First 20
```

---

## Cost Management Tips

- Always run `Set-VMAutoShutdown.ps1` after deploying a new VM
- Use `Manage-AzLabVM.ps1` to stop the VM when not in use
- B-series VMs (`Standard_B2als_v2`) are the most cost-effective for lab work
- Monitor your spending at `portal.azure.com` → Education → Overview

---

## Certification Alignment

This project covers hands-on implementation of objectives from:

| Certification | Relevant Areas |
|---|---|
| AZ-900 — Azure Fundamentals | Resource Groups, Virtual Machines, Azure regions, cost management |
| AZ-104 — Azure Administrator | VM deployment, PowerShell automation, resource management, cost control |
| AZ-500 — Azure Security Engineer | VM security, network security groups, access control |

---

## Roadmap

Upcoming additions to this repository:

- [ ] `New-HubSpokeNetwork.ps1` — Deploy a hub and spoke virtual network topology
- [ ] `Get-VMCostReport.ps1` — Generate a cost report for all lab resources
- [ ] `New-AzSnapshot.ps1` — Automate VM disk snapshots for backup
- [ ] `Set-VMTags.ps1` — Apply consistent tags to all lab resources for cost tracking
- [ ] `Remove-AzLab.ps1` — Clean up all lab resources in one command

---

## Author

**Olivier Jean-Baptiste**
Systems Administrator | Azure Infrastructure & Automation
- GitHub: [your-github-url]
- LinkedIn: [your-linkedin-url]

---

## License

MIT License — feel free to use, modify, and adapt for your own lab environment.

---

## Disclaimer

These scripts are provided for educational and lab purposes. Always review scripts before running them in any environment. The author is not responsible for unexpected Azure charges — always configure auto-shutdown and monitor your spending.
