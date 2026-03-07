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
            # Explicitly use UTF8 encoding to prevent binary/garbled text artifacts
            $reader = New-Object System.IO.StreamReader($request.InputStream, [System.Text.Encoding]::UTF8)
            $payload = $reader.ReadToEnd()
            
            # Clean up the reader immediately to flush the stream
            $reader.Close()
            $reader.Dispose()

            if (-not [string]::IsNullOrWhiteSpace($payload)) {
                Write-Host "Signal received! Triggering Invoke-WinFlow..." -ForegroundColor Cyan
                
                # Sanitize the payload by trimming and ensuring it's passed as a clean string
                $sanitizedPayload = $payload.Trim()
                
                # Execute the engine script from the relative scripts folder
                .\scripts\Invoke-WinFlow.ps1 -JsonPayload $sanitizedPayload
            }
            else {
                Write-Host "Warning: Received an empty POST request." -ForegroundColor Yellow
            }
        }

        # Send a 200 OK response back to the sender (Jira)
        $response = $context.Response
        $response.StatusCode = 200
        $response.Close()
    }
}
catch {
    Write-Error "Listener Error: $($_.Exception.Message)"
}
finally {
    $listener.Stop()
}
