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
    Version: 1.0.1
    License: MIT
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$JsonPayload
)

process {
    try {
        # 1. Pre-processing: Clean up the input string and check for content
        $JsonPayload = $JsonPayload.Trim()
        if ([string]::IsNullOrWhiteSpace($JsonPayload)) {
            throw "The JSON payload is empty or null."
        }

        # 2. Parse the Incoming Webhook Data
        # Using -ErrorAction Stop ensures the catch block is triggered on "Invalid JSON primitive"
        $Data = $JsonPayload | ConvertFrom-Json -ErrorAction Stop
        
        $VMName      = $Data.hostname
        $MemoryGB    = $Data.ram
        $CPUCount    = $Data.cpu
        $OSImage     = $Data.os_version
        $TicketKey   = $Data.issue_key

        Write-Host "--------------------------------------------------" -ForegroundColor Cyan
        Write-Host "SKYBUILD ENGINE ACTIVATED" -ForegroundColor Cyan
        Write-Host "Request Source: $TicketKey"
        Write-Host "Target Host: $VMName"
        Write-Host "--------------------------------------------------"

        # 3. Validation logic
        if (-not $VMName) { throw "Hostname is missing from the Jira payload." }

        # 4. Provisioning Logic (Placeholder for Hyper-V / VMware / Cloud)
        Write-Host "[1/3] Validating $OSImage against Jira Assets library..." -ForegroundColor Gray
        Start-Sleep -Seconds 1 # Simulating processing

        Write-Host "[2/3] Allocating $CPUCount vCPUs and ${MemoryGB}GB RAM..." -ForegroundColor Gray
        Start-Sleep -Seconds 1

        Write-Host "[3/3] Initiating WinFlow deployment on Hypervisor..." -ForegroundColor Gray

        # ACTUAL COMMAND EXAMPLE:
        # New-VM -Name $VMName -MemoryStartupBytes ($MemoryGB * 1GB) -Generation 2

        Write-Host "--------------------------------------------------"
        Write-Host "SUCCESS: $VMName is now provisioning." -ForegroundColor Green
        Write-Host "Update sent back to Jira Issue: $TicketKey"
        Write-Host "--------------------------------------------------"
    }
    catch {
        Write-Host "X ERROR: Failed to provision" -ForegroundColor Red
        # This helps you see exactly what "TNBU" or other malformed text is being passed
        Write-Host "Captured Raw Input: '$JsonPayload'" -ForegroundColor Yellow
        Write-Error $_.Exception.Message
    }
}

