param(
    [Parameter(Mandatory = $false)]
    [string]$ConfigPath = "..\..\..\config.json",

    [Parameter(Mandatory = $false)]
    [string]$EnvPath = "..\..\..\.env"
)

$ErrorActionPreference = "Stop"

Write-Host "`n=== D365 Connection Test ===" -ForegroundColor Cyan

$testsPassed = 0
$testsFailed = 0

# Resolve paths safely
function Resolve-PathSafe {
    param([string]$Path)
    try {
        return (Resolve-Path $Path -ErrorAction Stop).Path
    }
    catch {
        return $null
    }
}

$ConfigPath = Resolve-PathSafe $ConfigPath
$EnvPath = Resolve-PathSafe $EnvPath

# -------------------------
# Test 1: Check configuration files
# -------------------------
Write-Host "`n[1/3] Checking configuration files..." -ForegroundColor Yellow

if ($EnvPath -and (Test-Path $EnvPath)) {
    Write-Host "  * .env file found at: $EnvPath" -ForegroundColor Green
    $testsPassed++
}
else {
    Write-Host "  X .env file not found (expected at: ..\..\..\.env)" -ForegroundColor Red
    Write-Host "    Create from .env.template in project root" -ForegroundColor Yellow
    $testsFailed++
}

if ($ConfigPath -and (Test-Path $ConfigPath)) {
    Write-Host "  * config.json found at: $ConfigPath" -ForegroundColor Green
    $testsPassed++
}
else {
    Write-Host "  X config.json not found (expected at: ..\..\..\config.json)" -ForegroundColor Red
    Write-Host "    Create from config.json.template in project root" -ForegroundColor Yellow
    $testsFailed++
}

if ($testsFailed -gt 0) {
    Write-Host "`nTest failed: Missing configuration files" -ForegroundColor Red
    exit 1
}

# -------------------------
# Test 2: Load configuration
# -------------------------
Write-Host "`n[2/3] Loading configuration..." -ForegroundColor Yellow

try {
    # Load .env variables
    Get-Content $EnvPath | ForEach-Object {
        $line = $_.Trim()
        if ($line -and -not $line.StartsWith("#") -and $line -match '^([^=]+)=(.*)$') {
            $key = $matches[1].Trim()
            $value = $matches[2]  # allow empty values
            [System.Environment]::SetEnvironmentVariable($key, $value, 'Process')
        }
    }

    # Load config.json
    $config = Get-Content $ConfigPath | ConvertFrom-Json

    $tenantId = $env:D365_TENANT_ID
    $clientId = $env:D365_CLIENT_ID
    $clientSecret = $env:D365_CLIENT_SECRET
    $environment = $config.d365Environment

    # Ensure environment URL has protocol
    if ($environment -and -not $environment.StartsWith("http")) {
        $environment = "https://$environment"
    }

    # Validate values
    if ($tenantId) { Write-Host "  * Tenant ID loaded" -ForegroundColor Green; $testsPassed++ }
    else { Write-Host "  X D365_TENANT_ID missing" -ForegroundColor Red; $testsFailed++ }

    if ($clientId) { Write-Host "  * Client ID loaded" -ForegroundColor Green; $testsPassed++ }
    else { Write-Host "  X D365_CLIENT_ID missing" -ForegroundColor Red; $testsFailed++ }

    if ($clientSecret) { Write-Host "  * Client Secret loaded" -ForegroundColor Green; $testsPassed++ }
    else { Write-Host "  X D365_CLIENT_SECRET missing" -ForegroundColor Red; $testsFailed++ }

    if ($environment) { Write-Host "  * Environment URL loaded: $environment" -ForegroundColor Green; $testsPassed++ }
    else { Write-Host "  X d365Environment missing" -ForegroundColor Red; $testsFailed++ }

    if ($testsFailed -gt 0) {
        Write-Host "`nTest failed: Missing credentials" -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "  X Failed to load configuration: $_" -ForegroundColor Red
    exit 1
}

# -------------------------
# Test 3: OAuth Authentication + DMF API
# -------------------------
Write-Host "`n[3/3] Testing OAuth 2.0 authentication..." -ForegroundColor Yellow

try {
    # Modern OAuth (recommended)
    $tokenBody = @{
        client_id     = $clientId
        client_secret = $clientSecret
        scope         = "$environment/.default"
        grant_type    = "client_credentials"
    }

    $tokenUri = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"

    $tokenResponse = Invoke-RestMethod -Uri $tokenUri -Method Post -Body $tokenBody -ErrorAction Stop

    $accessToken = $tokenResponse.access_token
    $expiresIn = $tokenResponse.expires_in

    Write-Host "  * OAuth authentication successful" -ForegroundColor Green
    Write-Host "    Token expires in: $expiresIn seconds" -ForegroundColor Gray
    $testsPassed++

    # Test DMF API connectivity
    $headers = @{
        Authorization  = "Bearer $accessToken"
        "Content-Type" = "application/json"
    }

    $testFileName = "test_$(Get-Date -Format 'yyyyMMddHHmmss').zip"
    $getUrlBody = @{ uniqueFileName = $testFileName } | ConvertTo-Json

    # Correct DMF API URL
    $apiUrl = "$environment/api/data/DataManagementDefinitionGroups/Microsoft.Dynamics.DataEntities.GetAzureWriteUrl"

    $getUrlResponse = Invoke-RestMethod -Uri $apiUrl -Method Post -Headers $headers -Body $getUrlBody -ErrorAction Stop
    [VOID]$getUrlResponse  # We don't care about the response content for this test

    Write-Host "  * D365 environment is reachable" -ForegroundColor Green
    Write-Host "  * DMF REST API is accessible" -ForegroundColor Green
    $testsPassed += 2
}
catch {
    Write-Host "  X Authentication or API connectivity failed" -ForegroundColor Red
    Write-Host "    Error: $($_.Exception.Message)" -ForegroundColor Red
    $testsFailed++
    exit 1
}

# -------------------------
# Summary
# -------------------------
Write-Host "`n=== Test Summary ===" -ForegroundColor Cyan
Write-Host "Tests passed: $testsPassed" -ForegroundColor Green
Write-Host "Tests failed: $testsFailed" -ForegroundColor $(if ($testsFailed -eq 0) { "Green" } else { "Red" })

if ($testsFailed -eq 0) {
    Write-Host "`n* Connection test PASSED" -ForegroundColor Green
    Write-Host "  All systems are ready for data package imports" -ForegroundColor Green
    exit 0
}
else {
    Write-Host "`nX Connection test FAILED" -ForegroundColor Red
    exit 1
}
