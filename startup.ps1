#!/usr/bin/env pwsh
<#
SkillSketch Local Startup Script (FastAPI + phi3-mini)
Starts all required services for local development
This script opens 3 new PowerShell windows for FastAPI, Streamlit, and Ollama
#>

Write-Host "================================" -ForegroundColor Cyan
Write-Host "SkillSketch Local Startup" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check prerequisites
Write-Host "Step 1: Checking prerequisites..." -ForegroundColor Yellow

# Check Python
$pythonVersion = python --version 2>&1
if ($pythonVersion -match "Python 3") {
    Write-Host "  OK Python: $pythonVersion" -ForegroundColor Green
} else {
    Write-Host "  ERROR Python 3.11+ not found" -ForegroundColor Red
    exit 1
}

# Check MongoDB
$mongoRunning = Get-Service MongoDB -ErrorAction SilentlyContinue
if ($mongoRunning.Status -eq 'Running') {
    Write-Host "  OK MongoDB: Running" -ForegroundColor Green
} else {
    Write-Host "  WARNING MongoDB: Not running" -ForegroundColor Yellow
}

# Check Ollama
$ollamaPath = (Get-Command ollama -ErrorAction SilentlyContinue)
if ($ollamaPath) {
    Write-Host "  OK Ollama: Installed" -ForegroundColor Green
    $modelList = ollama ls 2>&1
    if ($modelList -match "phi3:mini") {
        Write-Host "  OK phi3:mini: Model available" -ForegroundColor Green
    } else {
        Write-Host "  WARNING phi3:mini: Not found" -ForegroundColor Yellow
    }
} else {
    Write-Host "  ERROR Ollama not found" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Step 2: Create .env if not exists
Write-Host "Step 2: Setting up .env file..." -ForegroundColor Yellow
if (!(Test-Path .env)) {
    Write-Host "  Creating .env from template..." -ForegroundColor Green
    Copy-Item .env.example .env -ErrorAction Stop
    Write-Host "  OK .env created" -ForegroundColor Green
} else {
    Write-Host "  OK .env already exists" -ForegroundColor Green
}
Write-Host ""

# Step 3: Setup FastAPI backend
Write-Host "✓ Step 3: Setting up FastAPI backend..." -ForegroundColor Yellow
$fastApiDir = ".\fastapi_backend"
if (!(Test-Path "$fastApiDir\venv")) {
    Write-Host "  Creating Python venv..." -ForegroundColor Green
    Push-Location $fastApiDir
    python -m venv venv
    .\venv\Scripts\Activate.ps1
    pip install -q -r requirements.txt
    Pop-Location
    Write-Host "  ✓ FastAPI venv created and dependencies installed" -ForegroundColor Green
} else {
    Write-Host "  ✓ FastAPI venv already exists" -ForegroundColor Green
}
Write-Host ""

# Step 4: Setup Streamlit frontend
Write-Host "✓ Step 4: Setting up Streamlit frontend..." -ForegroundColor Yellow
$frontendDir = ".\frontend"
if (!(Test-Path "$frontendDir\venv")) {
    Write-Host "  Creating Python venv..." -ForegroundColor Green
    Push-Location $frontendDir
    python -m venv venv
    .\venv\Scripts\Activate.ps1
    pip install -q -r requirements.txt
    Pop-Location
    Write-Host "  ✓ Streamlit venv created and dependencies installed" -ForegroundColor Green
} else {
    Write-Host "  ✓ Streamlit venv already exists" -ForegroundColor Green
}
Write-Host ""

# Step 5: Start MongoDB service
Write-Host "✓ Step 5: Starting MongoDB service..." -ForegroundColor Yellow
if ($mongoRunning.Status -ne 'Running') {
    Write-Host "  Starting MongoDB..." -ForegroundColor Green
    Start-Service MongoDB -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 3
    Write-Host "  ✓ MongoDB started" -ForegroundColor Green
} else {
    Write-Host "  ✓ MongoDB already running" -ForegroundColor Green
}
Write-Host ""

# Step 6: Open 3 terminal windows for services
Write-Host "✓ Step 6: Opening service terminals..." -ForegroundColor Yellow
Write-Host "  This will open 3 new PowerShell windows:" -ForegroundColor Gray
Write-Host "    - Terminal 1: FastAPI (port 8000)" -ForegroundColor Gray
Write-Host "    - Terminal 2: Streamlit (port 8501)" -ForegroundColor Gray
Write-Host "    - Terminal 3: Ollama verification" -ForegroundColor Gray
Write-Host ""

# FastAPI Terminal
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd d:\skillsketch-main\skillsketch-main\fastapi_backend; .\venv\Scripts\Activate.ps1; python -m uvicorn main:app --host 127.0.0.1 --port 8000 --reload" -WindowStyle Normal

# Streamlit Terminal
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd d:\skillsketch-main\skillsketch-main\frontend; .\venv\Scripts\Activate.ps1; streamlit run app.py" -WindowStyle Normal

# Ollama verification terminal
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd d:\skillsketch-main\skillsketch-main; Write-Host 'Ollama Terminal - Running ollama serve'; ollama serve" -WindowStyle Normal

Write-Host "  ✓ Service terminals opened" -ForegroundColor Green
Write-Host ""
Start-Sleep -Seconds 3

# Step 7: Verify services
Write-Host "✓ Step 7: Verifying services..." -ForegroundColor Yellow
$maxRetries = 6
$retryCount = 0

# Wait for FastAPI
while ($retryCount -lt $maxRetries) {
    $fastApiHealth = curl -s http://127.0.0.1:8000/api/health/ 2>&1
    if ($fastApiHealth -match "ok") {
        Write-Host "  ✓ FastAPI responding on port 8000" -ForegroundColor Green
        break
    }
    $retryCount++
    if ($retryCount -lt $maxRetries) {
        Write-Host "  Waiting for FastAPI... ($retryCount/$maxRetries)" -ForegroundColor Gray
        Start-Sleep -Seconds 2
    }
}
if ($retryCount -eq $maxRetries) {
    Write-Host "  ⚠ FastAPI not responding yet (may take longer)" -ForegroundColor Yellow
}

# Check Ollama
$ollamaStatus = curl -s http://127.0.0.1:11434/api/tags 2>&1
if ($ollamaStatus) {
    Write-Host "  ✓ Ollama responding on port 11434" -ForegroundColor Green
} else {
    Write-Host "  ⚠ Ollama not responding yet (starting up)" -ForegroundColor Yellow
}

Write-Host ""

# Step 8: Display access information
Write-Host "================================" -ForegroundColor Green
Write-Host "✓ SkillSketch is Starting!" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""
Write-Host "Access the application in your browser:" -ForegroundColor Cyan
Write-Host "  🌐 Streamlit UI:     http://localhost:8501" -ForegroundColor White
Write-Host "  📡 FastAPI Docs:     http://localhost:8000/docs" -ForegroundColor White
Write-Host "  🔌 API Base:         http://localhost:8000/api/" -ForegroundColor White
Write-Host ""
Write-Host "Service Ports:" -ForegroundColor Cyan
Write-Host "  FastAPI:             localhost:8000" -ForegroundColor White
Write-Host "  Streamlit:           localhost:8501" -ForegroundColor White
Write-Host "  MongoDB:             localhost:27017" -ForegroundColor White
Write-Host "  Ollama:              localhost:11434" -ForegroundColor White
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Open http://localhost:8501 in your browser" -ForegroundColor White
Write-Host "  2. Upload a PDF syllabus (Tab 1)" -ForegroundColor White
Write-Host "  3. Generate lesson plan (Tab 2)" -ForegroundColor White
Write-Host "  4. Generate exam questions (Tab 3)" -ForegroundColor White
Write-Host ""
Write-Host "Useful commands:" -ForegroundColor Cyan
Write-Host "  Ctrl+C in each terminal to stop services" -ForegroundColor White
Write-Host "  Get-Service MongoDB to check MongoDB status" -ForegroundColor White
Write-Host "  ollama ls to check available models" -ForegroundColor White
Write-Host "  Start-Service MongoDB to start MongoDB" -ForegroundColor White
Write-Host ""
Write-Host "================================" -ForegroundColor Green
Write-Host "Happy lesson planning! 🎓" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""
Write-Host "This window can be closed. Service windows will stay open." -ForegroundColor Gray
