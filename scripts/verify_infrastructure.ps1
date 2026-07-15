# Infrastructure Verification Script for Socduacl
# This script checks that all infrastructure services are running and properly configured

# Load environment variables from .env if it exists
$envFile = ".env"
if (Test-Path $envFile) {
    Get-Content $envFile | Where-Object { $_ -match '^[A-Z_]+=' } | ForEach-Object {
        $key, $value = $_ -split '=', 2
        [Environment]::SetEnvironmentVariable($key, $value, "Process")
    }
}

# Default values
$POSTGRES_HOST = if ($env:POSTGRES_HOST) { $env:POSTGRES_HOST } else { "localhost" }
$POSTGRES_PORT = if ($env:POSTGRES_PORT) { $env:POSTGRES_PORT } else { "5432" }
$POSTGRES_USER = if ($env:POSTGRES_USER) { $env:POSTGRES_USER } else { "socduacl" }
$POSTGRES_DB = if ($env:POSTGRES_DB) { $env:POSTGRES_DB } else { "socduacl_db" }

$REDIS_HOST = if ($env:REDIS_HOST) { $env:REDIS_HOST } else { "localhost" }
$REDIS_PORT = if ($env:REDIS_PORT) { $env:REDIS_PORT } else { "6379" }

$RABBITMQ_HOST = if ($env:RABBITMQ_HOST) { $env:RABBITMQ_HOST } else { "localhost" }
$RABBITMQ_PORT = if ($env:RABBITMQ_PORT) { $env:RABBITMQ_PORT } else { "5672" }
$RABBITMQ_UI_PORT = if ($env:RABBITMQ_UI_PORT) { $env:RABBITMQ_UI_PORT } else { "15672" }
$RABBITMQ_USER = if ($env:RABBITMQ_DEFAULT_USER) { $env:RABBITMQ_DEFAULT_USER } else { "socduacl" }
$RABBITMQ_PASS = if ($env:RABBITMQ_DEFAULT_PASS) { $env:RABBITMQ_DEFAULT_PASS } else { "socduacl_secret" }

$MINIO_HOST = if ($env:MINIO_HOST) { $env:MINIO_HOST } else { "localhost" }
$MINIO_PORT = if ($env:MINIO_PORT) { $env:MINIO_PORT } else { "9000" }
$MINIO_USER = if ($env:MINIO_ROOT_USER) { $env:MINIO_ROOT_USER } else { "socduacl" }
$MINIO_PASS = if ($env:MINIO_ROOT_PASSWORD) { $env:MINIO_ROOT_PASSWORD } else { "socduacl_secret" }

$MINIO_BUCKET = "socduacl-public"

Write-Host "Infrastructure Verification Script" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

$allPassed = $true

# Function to test TCP port
function Test-Port {
    param($hostname, $port, $timeout = 5)
    try {
        $tcp = New-Object System.Net.Sockets.TcpClient
        $tcp.ReceiveTimeout = $timeout * 1000
        $tcp.SendTimeout = $timeout * 1000
        $tcp.Connect($hostname, $port)
        $tcp.Close()
        return $true
    } catch {
        return $false
    }
}

# Function to test HTTP endpoint
function Test-HttpEndpoint {
    param($url, $timeout = 5)
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec $timeout
        return $response.StatusCode -eq 200
    } catch {
        return $false
    }
}

# Test PostgreSQL
Write-Host "Testing PostgreSQL..." -ForegroundColor Yellow
if (Test-Port -hostname $POSTGRES_HOST -port $POSTGRES_PORT) {
    Write-Host "  [PASS] PostgreSQL is listening on port $POSTGRES_PORT" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] PostgreSQL is not responding on port $POSTGRES_PORT" -ForegroundColor Red
    $allPassed = $false
}

# Test Redis
Write-Host "Testing Redis..." -ForegroundColor Yellow
if (Test-Port -hostname $REDIS_HOST -port $REDIS_PORT) {
    Write-Host "  [PASS] Redis is listening on port $REDIS_PORT" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Redis is not responding on port $REDIS_PORT" -ForegroundColor Red
    $allPassed = $false
}

# Test RabbitMQ AMQP
Write-Host "Testing RabbitMQ AMQP..." -ForegroundColor Yellow
if (Test-Port -hostname $RABBITMQ_HOST -port $RABBITMQ_PORT) {
    Write-Host "  [PASS] RabbitMQ AMQP is listening on port $RABBITMQ_PORT" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] RabbitMQ AMQP is not responding on port $RABBITMQ_PORT" -ForegroundColor Red
    $allPassed = $false
}

# Test RabbitMQ Management UI
Write-Host "Testing RabbitMQ Management UI..." -ForegroundColor Yellow
$rabbitMqUiUrl = "http://${RABBITMQ_HOST}:${RABBITMQ_UI_PORT}"
if (Test-HttpEndpoint $rabbitMqUiUrl) {
    Write-Host "  [PASS] RabbitMQ Management UI is responding at $rabbitMqUiUrl" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] RabbitMQ Management UI is not responding at $rabbitMqUiUrl" -ForegroundColor Red
    $allPassed = $false
}

# Test MinIO Health
Write-Host "Testing MinIO..." -ForegroundColor Yellow
$minioHealthUrl = "http://${MINIO_HOST}:${MINIO_PORT}/minio/health/live"
if (Test-HttpEndpoint $minioHealthUrl) {
    Write-Host "  [PASS] MinIO health endpoint is responding at $minioHealthUrl" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] MinIO health endpoint is not responding at $minioHealthUrl" -ForegroundColor Red
    $allPassed = $false
}

# Test MinIO Bucket Existence and Policy
Write-Host "Testing MinIO Bucket Configuration..." -ForegroundColor Yellow
try {
    # Check if mc CLI is available
    $mcAvailable = Get-Command mc -ErrorAction SilentlyContinue
    if ($mcAvailable) {
        # Set up mc alias
        $envSet = mc alias set local "http://${MINIO_HOST}:${MINIO_PORT}" $MINIO_USER $MINIO_PASS 2>&1
        if ($LASTEXITCODE -eq 0) {
            # Check bucket exists
            $bucketExists = mc ls local/$MINIO_BUCKET 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  [PASS] Bucket '$MINIO_BUCKET' exists" -ForegroundColor Green
                
                # Check policy
                $policy = mc anonymous get local/$MINIO_BUCKET 2>&1
                if ($policy -match "download") {
                    Write-Host "  [PASS] Bucket has public-read (download) policy" -ForegroundColor Green
                } else {
                    Write-Host "  [FAIL] Bucket does not have expected public-read policy" -ForegroundColor Red
                    Write-Host "  Current policy: $policy" -ForegroundColor Red
                    $allPassed = $false
                }
            } else {
                Write-Host "  [FAIL] Bucket '$MINIO_BUCKET' does not exist" -ForegroundColor Red
                $allPassed = $false
            }
        } else {
            Write-Host "  [WARN] Could not configure mc CLI, skipping bucket verification" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  [WARN] mc CLI not found, skipping bucket verification" -ForegroundColor Yellow
        Write-Host "  Install mc CLI from https://min.io/docs/minio/linux/reference/minio-mc.html" -ForegroundColor Gray
    }
} catch {
    Write-Host "  [WARN] Error checking MinIO bucket configuration: $_" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=================================" -ForegroundColor Cyan
if ($allPassed) {
    Write-Host "All infrastructure checks PASSED" -ForegroundColor Green
    exit 0
} else {
    Write-Host "Some infrastructure checks FAILED" -ForegroundColor Red
    exit 1
}
