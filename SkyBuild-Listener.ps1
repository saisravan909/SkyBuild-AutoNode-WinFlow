<#
.SYNOPSIS
    SkyBuild-Listener.ps1 - The Bridge between Jira and your Engine
    Listens for incoming webhooks and routes them to the WinFlow provisioning script.

.NOTES
    Project: SkyBuild-AutoNode-WinFlow
    Port: 8080
#>

$port = 8080
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://*:$port/")
$listener.Start()

Write-Host "SKYBUILD LISTENER ACTIVE" -ForegroundColor Green
Write-Host "Waiting for Jira signals on http://localhost:$port..." -ForegroundColor Gray

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        
        if ($request.HttpMethod -eq "POST") {
            # Use a StreamReader to capture the request body
            $reader = New-Object System.IO.StreamReader($request.InputStream)
            $payload = $reader.ReadToEnd()
            $reader.Close() # Explicitly close to ensure the stream is flushed

            if (-not [string]::IsNullOrWhiteSpace($payload)) {
                Write-Host "Signal received! Triggering Invoke-WinFlow..." -ForegroundColor Cyan
                
                # Pass the trimmed payload to the engine to avoid encoding artifacts
                .\scripts\Invoke-WinFlow.ps1 -JsonPayload ($payload.Trim())
            }
            else {
                Write-Host "Warning: Received an empty POST request." -ForegroundColor Yellow
            }
        }

        # Send a 200 OK response back to the sender
        $response = $context.Response
        $response.StatusCode = 200
        $response.Close()
    }
}
catch {
    Write-Error $_.Exception.Message
}
finally {
    $listener.Stop()
}
