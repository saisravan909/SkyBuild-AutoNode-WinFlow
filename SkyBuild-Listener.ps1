# SkyBuild-Listener.ps1 - The Bridge between Jira and your Engine
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
            # Fix: Force UTF8 encoding to prevent garbled text/TNBU errors
            $reader = New-Object System.IO.StreamReader($request.InputStream, [System.Text.Encoding]::UTF8)
            $payload = $reader.ReadToEnd()

            Write-Host "Signal received! Triggering Invoke-WinFlow..." -ForegroundColor Cyan

            # Fix: Trim the payload and ensure correct syntax to pass to the engine
            .\scripts\Invoke-WinFlow.ps1 -JsonPayload ($payload.Trim())
        }

        $response = $context.Response
        $response.StatusCode = 200
        $response.Close()
    }
} finally {
    $listener.Stop()
}
