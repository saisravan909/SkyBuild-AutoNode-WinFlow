# SkyBuild-Listener.ps1 - Improved with Corrected Error Handling
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
            # Fix: Force UTF8 encoding to prevent garbled text
            $reader = New-Object System.IO.StreamReader($request.InputStream, [System.Text.Encoding]::UTF8)
            $payload = $reader.ReadToEnd()

            Write-Host "Signal received! Triggering Invoke-WinFlow..." -ForegroundColor Cyan

            try {
                # Fix: Use call operator (&) and absolute/relative path properly
                $scriptPath = Join-Path $PSScriptRoot "scripts\Invoke-WinFlow.ps1"
                & $scriptPath -JsonPayload ($payload.Trim())
            }
            catch {
                Write-Host "ERROR: Failed to execute WinFlow engine: $($_.Exception.Message)" -ForegroundColor Red
            }
        }

        # Send response back to Jira immediately to prevent timeout
        $response = $context.Response
        $response.StatusCode = 200
        $response.Close()
    }
}
catch {
    Write-Host "ERROR: Critical failure in listener loop: $($_.Exception.Message)" -ForegroundColor Red
}
finally {
    # This only executes if the loop is broken or an unhandled error occurs
    if ($null -ne $listener) {
        $listener.Stop()
        Write-Host "Listener stopped." -ForegroundColor Yellow
    }
}
