# SkillSketch — Local Setup Guide (No Docker)

## Prerequisites

- **Python 3.11+** — [Download](https://www.python.org/downloads/)
- **MongoDB 6.0** — [Download](https://www.mongodb.com/try/download/community)
- **Ollama** — [Download](https://ollama.ai)
- **Windows PowerShell** (or Git Bash)
- **~3GB free disk space** for phi3:mini model
- **~2GB free RAM** (8GB+ recommended)

---

## Step 1: Install MongoDB

### Option A: Manual Install (Windows)
1. Download MongoDB Community from https://www.mongodb.com/try/download/community
2. Run the installer and follow default options
3. MongoDB will start as a Windows service automatically
4. Verify: `mongo --version`

### Option B: Chocolatey (if installed)
```powershell
choco install mongodb-community
```

Verify MongoDB is running:
```powershell
mongo --version
# Should show version info
```

---

## Step 2: Install Ollama

1. Download from https://ollama.ai
2. Run the installer and follow prompts
3. After installation, pull the phi3:mini model:
```powershell
ollama pull phi3:mini
```
This downloads ~2.2GB. **Wait for completion before continuing.**

Verify model is installed:
```powershell
ollama ls
# Should show: phi3:mini (or phi3 latest)
```

---

## Step 3: Clone & Setup Project

```powershell
# Navigate to project
cd D:\skillsketch-main\skillsketch-main

# Copy env template
copy .env.example .env

# Edit .env with your settings (optional)
notepad .env
```

**Important .env variables:**
```env
MONGO_INITDB_ROOT_USERNAME=admin
MONGO_INITDB_ROOT_PASSWORD=pass123
MONGO_URI=mongodb://admin:pass123@localhost:27017/skillsketch?authSource=admin
OLLAMA_HOST=http://localhost:11434
OLLAMA_MODEL=phi3:mini
```

---

## Step 4: Install Python Dependencies

### Backend (FastAPI)
```powershell
cd D:\skillsketch-main\skillsketch-main\fastapi_backend

# Create virtual environment
python -m venv venv

# Activate
.\venv\Scripts\Activate.ps1

# Install dependencies
pip install -r requirements.txt
```

### Frontend (Streamlit)
```powershell
# In a new PowerShell terminal
cd D:\skillsketch-main\skillsketch-main\frontend

# Create virtual environment
python -m venv venv

# Activate
.\venv\Scripts\Activate.ps1

# Install dependencies
pip install -r requirements.txt
```

---

## Step 5: Start Services

### Terminal 1: Start FastAPI Backend
```powershell
cd D:\skillsketch-main\skillsketch-main\fastapi_backend
.\venv\Scripts\Activate.ps1
python -m uvicorn main:app --host 127.0.0.1 --port 8000 --reload
```

You should see:
```
Uvicorn running on http://127.0.0.1:8000
```

### Terminal 2: Start Streamlit Frontend
```powershell
cd D:\skillsketch-main\skillsketch-main\frontend
.\venv\Scripts\Activate.ps1
streamlit run app.py
```

You should see:
```
You can now view your Streamlit app in your browser.
Local URL: http://localhost:8501
```

### Terminal 3: Ensure Ollama is Running
```powershell
# Ollama should auto-start, verify:
ollama serve
```

---

## Step 6: Access the Application

1. **Streamlit UI**: http://localhost:8501
2. **FastAPI Docs**: http://localhost:8000/docs
3. **API Health Check**: http://localhost:8000/api/health/

---

## Verify Everything Works

### Test API Health
```powershell
curl http://localhost:8000/api/health/
# Should return: {"status":"ok","service":"FastAPI"}
```

### Test Ollama Status
```powershell
curl http://localhost:8000/api/ollama/status/
# Should return: {"available":true,"models":[...]}
```

### Run Integration Tests
```powershell
cd D:\skillsketch-main\skillsketch-main
python tests/api_test.py
python tests/upload_test.py
```

---

## Troubleshooting

### MongoDB won't start
```powershell
# Check if service is running
Get-Service MongoDB
# If not, start it
Start-Service MongoDB
```

### Ollama not responding
```powershell
# Make sure Ollama service is running
ollama serve
# Should show: Listening on 127.0.0.1:11434
```

### FastAPI won't start (port in use)
```powershell
# Check what's using port 8000
netstat -ano | findstr :8000
# Kill the process or use different port:
python -m uvicorn main:app --host 127.0.0.1 --port 8001 --reload
```

### Streamlit won't start
```powershell
# Kill any existing Streamlit processes
taskkill /F /IM streamlit.exe
# Try again
streamlit run app.py
```

### Models not loading in API
```powershell
# Verify model is installed
ollama ls
# Pull again if missing
ollama pull phi3:mini
# Restart services
```

---

## File Locations

| Service | Port | Health Check |
|---------|------|--------------|
| FastAPI | 8000 | http://localhost:8000/api/health/ |
| Streamlit | 8501 | http://localhost:8501 |
| MongoDB | 27017 | (no HTTP endpoint) |
| Ollama | 11434 | http://localhost:11434/ |

---

## Data Storage (Local)

All data is stored in the `data/` folder:
- **data/uploads/** — PDF files uploaded
- **data/syllabi.json** — Syllabus metadata
- **data/lesson_plans.json** — Generated lesson plans
- **data/questions.json** — Generated exam questions

---

## Stopping Services

### Graceful Shutdown
1. **FastAPI**: Press `Ctrl+C` in terminal
2. **Streamlit**: Press `Ctrl+C` in terminal
3. **Ollama**: Press `Ctrl+C` or close the window
4. **MongoDB**: Service will stop when system shuts down (or: `Stop-Service MongoDB`)

---

## Next Steps

- Check [QUICK_REFERENCE.md](QUICK_REFERENCE.md) for API endpoints
- Review [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) for architecture
- Upload a test PDF via http://localhost:8501
- Generate a lesson plan and exam questions

---

## Support

If issues persist:
1. Check service logs (each terminal shows output)
2. Verify all services are running: `ollama ls`, `mongo --version`
3. Check firewall: ensure ports 8000, 8501, 27017, 11434 are not blocked
4. Review error messages in terminal windows

**Happy lesson planning! 🎓**
