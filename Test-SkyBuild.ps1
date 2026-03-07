# Test-SkyBuild.ps1 - Simulates a Jira Webhook
$uri = "http://localhost:8080"
$body = @{
    hostname  = "WSVR-PROD-01"
    ram       = 16
    cpu       = 4
    os_version = "Windows Server 2022"
    issue_key = "INFRA-452"
} | ConvertTo-Json

Write-Host "Sending test payload to SkyBuild Listener..." -ForegroundColor Yellow
Invoke-RestMethod -Uri $uri -Method Post -Body $body -ContentType "application/json"
Write-Host "Test complete." -ForegroundColor Green
