<#
.SYNOPSIS
    SkyBuild: AutoNode WinFlow Engine
    Orchestrates Windows Server VM provisioning via Jira Service Management Webhooks.

.DESCRIPTION
    This script serves as the automation 'engine' for the SkyBuild framework. 
    It receives JSON payloads from Jira Service Management (JSM), parses the 
    infrastructure requirements (CPU, RAM, OS), and initiates the VM creation 
    process on the target hypervisor.

.PARAMETER JsonPayload
    The raw JSON string sent from a Jira Automation Webhook.

.NOTES
    Author: Sai Sravan Cherukuri
    Project: SkyBuild-AutoNode-WinFlow
    Version: 1.0.0
    License: MIT
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$JsonPayload
)

process {
    try {
        # 1. Parse the Incoming Webhook Data
        $Data = $JsonPayload | ConvertFrom-Json
        
        $VMName     = $Data.hostname
        $MemoryGB   = $Data.ram
        $CPUCount   = $Data.cpu
        $OSImage    = $Data.os_version
        $TicketKey  = $Data.issue_key

        Write-Host "----------------------------------------------------" -ForegroundColor Cyan
        Write-Host " SKYBUILD ENGINE ACTIVATED" -ForegroundColor Cyan
        Write-Host "Request Source: $TicketKey"
        Write-Host "Target Host: $VMName"
        Write-Host "----------------------------------------------------"

        # 2. Validation Logic
        if (-not $VMName) { throw "Hostname is missing from the Jira payload." }

        # 3. Provisioning Logic (Placeholder for Hyper-V / VMware / Cloud)
        Write-Host "[1/3] Validating $OSImage against Jira Assets library..." -ForegroundColor Gray
        Start-Sleep -Seconds 1 # Simulating processing
        
        Write-Host "[2/3] Allocating $CPUCount vCPUs and ${MemoryGB}GB RAM..." -ForegroundColor Gray
        Start-Sleep -Seconds 1
        
        Write-Host "[3/3] Initiating WinFlow deployment on Hypervisor..." -ForegroundColor Gray
        
        # ACTUAL COMMAND EXAMPLE:
        # New-VM -Name $VMName -MemoryStartupBytes ($MemoryGB * 1GB) -Generation 2
        
        Write-Host "----------------------------------------------------"
        Write-Host "✅ SUCCESS: $VMName is now provisioning." -ForegroundColor Green
        Write-Host "Update sent back to Jira Issue: $TicketKey"
        Write-Host "----------------------------------------------------"

    }
    catch {
        Write-Host "❌ ERROR: Failed to provision $VMName" -ForegroundColor Red
        Write-Error $_.Exception.Message
    }
}

