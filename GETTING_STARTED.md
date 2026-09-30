# SkillSketch — Getting Started (Local Setup)

## 🎯 What You Have

✅ **FastAPI Backend** (fast, modern REST API)  
✅ **phi3:mini Model** (already installed on your system)  
✅ **Streamlit UI** (beautiful 4-tab interface)  
✅ **MongoDB** (data storage - local or Docker optional)  
✅ **RAG** (context-aware generation)  

---

## 🚀 Start Here (Windows PowerShell)

### Prerequisites (One-time Setup)
1. **MongoDB** installed and running
2. **Ollama** installed with `phi3:mini` pulled (verify: `ollama ls`)
3. **Python 3.11+** installed

### Quick Start (3 terminals)

**Terminal 1: FastAPI Backend**
```powershell
cd D:\skillsketch-main\skillsketch-main\fastapi_backend
python -m venv venv
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt
python -m uvicorn main:app --host 127.0.0.1 --port 8000 --reload
```

**Terminal 2: Streamlit Frontend**
```powershell
cd D:\skillsketch-main\skillsketch-main\frontend
python -m venv venv
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt
streamlit run app.py
```

**Terminal 3: Verify Ollama**
```powershell
ollama serve
```

---

## 🌐 After Startup: Access URLs

| Service | URL | What it is |
|---------|-----|-----------|
| **Streamlit** | http://localhost:8501 | 👈 **Start here!** Your web UI |
| **FastAPI Docs** | http://localhost:8000/docs | Interactive API testing |
| **Health Check** | http://localhost:8000/api/health/ | API status |
| **Ollama** | http://localhost:11434/ | LLM server |

---

## 📖 Step-by-Step Usage

### Step 1: Upload Syllabus PDF (2-3 minutes)

```
1. Open http://localhost:8501
2. Click Tab 1: "Upload Syllabus"
3. Enter Course Name: e.g., "Digital Signal Processing"
4. Select your PDF file
5. Click "Upload & Process Syllabus"
6. Wait 5-10 seconds
✓ You'll see: Syllabus ID, chunk count, text length
```

**What happens behind the scenes:**
- PDF text is extracted
- Text is split into chunks
- Chunks are converted to vectors (embeddings)
- Metadata stored in `data/syllabi.json`

---

### Step 2: Generate Lesson Plan (15-30 seconds)

```
1. Click Tab 2: "Generate Lesson Plan"
2. Select your uploaded syllabus from dropdown
3. Enter Topic: e.g., "Fourier Transform"
4. Select Subject Type: theory / laboratory / theory-cum-laboratory
5. Click "Generate Lesson Plan"
6. Wait 20-60 seconds (first time slower)
✓ You'll see: Complete lesson plan with:
   - Topic explanation
   - Learning objectives (Bloom's Taxonomy)
   - Teaching methodologies
   - Active Learning Methods
   - Lab/Activity ideas
7. Click "Download as Text" to save
```

**What happens:**
- Your topic + syllabus context is sent to FastAPI
- Ollama LLM generates lesson plan using context
- Result stored in `data/lesson_plans.json`
- Displayed in Streamlit with download option

---

### Step 3: Generate Exam Questions (20-30 seconds)

```
1. Click Tab 3: "Generate Exam Questions"
2. Select same syllabus
3. Optional: Enter topic focus
4. Set question count: 5-50 questions
5. Click "Generate Exam Questions"
6. Wait 25-70 seconds
✓ You'll see: Mix of:
   - Multiple Choice Questions (MCQ)
   - Short answer questions
   - Long answer questions
   - Difficulty levels assigned
7. Click "Download Questions" to save
```

---

### Step 4: View History (5 seconds)

```
1. Click Tab 4: "View History"
2. See all uploaded syllabi
3. See all generated lesson plans
4. See last 10 question generation sessions
```

---

## ⏱️ Performance Timeline

| Step | Time | What it's doing |
|------|------|-----------------|
| **Startup** | 5-10s | Starting services |
| **PDF upload** | 5-10s | Extract text, chunk, embed, index |
| **First lesson plan** | 30-60s | Loading model into RAM + generation |
| **Subsequent plans** | 5-15s | Model already in RAM |
| **Questions** | 25-70s | Analyzing + generating |

---

## 🔧 Common Issues & Fixes

### Issue: "API not responding"
```powershell
# Check if FastAPI is running on port 8000
curl http://localhost:8000/api/health/

# If not, check Terminal 1 for errors
# Common issue: port already in use
netstat -ano | findstr :8000
```

### Issue: "Streamlit won't load"
```powershell
# Check if running on port 8501
# If not, check Terminal 2 for errors
# Port in use?
netstat -ano | findstr :8501
```

### Issue: "Ollama not available"
```powershell
# Check Ollama is running
ollama serve

# Verify phi3:mini is installed
ollama ls
# Should show: phi3:mini

# If missing, pull it:
ollama pull phi3:mini
```

### Issue: "MongoDB connection error"
```powershell
# Check MongoDB service
Get-Service MongoDB
# If not running:
Start-Service MongoDB
```

---

## 🎓 FastAPI Advantages

**Why we use FastAPI instead of Django:**

- ✅ **Faster** — 2x faster request handling
- ✅ **Lighter** — ~100MB vs ~200MB memory
- ✅ **Auto Docs** — Interactive API at `/docs`
- ✅ **Modern** — Built on latest Python async
- ✅ **Easy** — Simpler code, less boilerplate

**Interactive API Testing:**
1. Open http://localhost:8000/docs
2. Click any endpoint
3. Click "Try it out"
4. Enter parameters
5. Click "Execute"
6. See live response!

---

## 🧪 Testing

### Verify Everything Works
```powershell
# Check FastAPI health
curl http://localhost:8000/api/health/

# Check Ollama
curl http://localhost:8000/api/ollama/status/

# Run tests
cd D:\skillsketch-main\skillsketch-main
python tests/api_test.py
python tests/upload_test.py
```

---

## 📊 System Requirements

**Minimum:**
- 8 GB RAM
- 10 GB free disk space (for models & data)
- Windows 10/11 or Linux/Mac

**Recommended:**
- 16 GB RAM
- 30 GB free disk space
- SSD storage

---

## 🛑 Stopping Services

### Graceful Stop
```powershell
# Terminal 1: FastAPI
Ctrl+C

# Terminal 2: Streamlit
Ctrl+C

# Terminal 3: Ollama
Ctrl+C
```

### Restart
Just re-run the commands in each terminal.

---

## 📁 Files You Need to Know

| File | Purpose |
|------|---------|
| `.env` | Configuration (passwords, URLs) |
| `fastapi_backend/main.py` | FastAPI code |
| `fastapi_backend/requirements.txt` | Python dependencies |
| `frontend/app.py` | Streamlit code |
| `frontend/requirements.txt` | Streamlit dependencies |
| `data/` | Local storage (PDFs, metadata) |

---

## 🔒 Security Notes

Before deploying or sharing:
- [ ] Changed `MONGO_INITDB_ROOT_PASSWORD` in `.env`
- [ ] Generated new `SECRET_KEY`
- [ ] Restricted `CORS_ALLOWED_ORIGINS`
- [ ] Backed up `data/` folder
- [ ] Used HTTPS in production (reverse proxy)

---

## 💡 Pro Tips

1. **First request is slow?** Normal — LLM loads into RAM. Subsequent requests are fast.

2. **Want to test API without Streamlit?**
   - Go to http://localhost:8000/docs
   - Click any endpoint
   - Click "Try it out"
   - Test interactively!

3. **Data stored where?**
   - PDFs & lesson plans: `data/` folder
   - Models: Ollama installation directory

4. **Need to reset everything?**
   ```powershell
   Remove-Item -Recurse -Force .\data
   mkdir data
   ```

5. **Check what's running:**
   ```powershell
   netstat -ano | findstr :8000
   netstat -ano | findstr :8501
   ```

---

## 📞 Troubleshooting Checklist

Before asking for help, try:

1. ✓ Is MongoDB running? `Get-Service MongoDB`
2. ✓ Is Ollama running? `ollama serve`
3. ✓ Is phi3:mini installed? `ollama ls`
4. ✓ Check FastAPI logs (Terminal 1)
5. ✓ Check Streamlit logs (Terminal 2)
6. ✓ Verify ports: 8000, 8501, 27017, 11434

---

## 🎉 You're Ready!

1. Start all three services (FastAPI, Streamlit, Ollama)
2. Open http://localhost:8501
3. Upload a PDF
4. Generate lesson plans & questions
5. Download and use!

---

**Questions?** Check:
- `LOCAL_SETUP.md` — Complete local setup guide
- `QUICK_REFERENCE.md` — Quick cheat sheet
- `SETUP_GUIDE.md` — Comprehensive guide

---

**Happy lesson planning! 🎓**

SkillSketch — Local AI-Powered Education Technology


---

## 🌐 After Startup: Access URLs

| Service | URL | What it is |
|---------|-----|-----------|
| **Streamlit** | http://localhost:8501 | 👈 **Start here!** Your web UI |
| **FastAPI Docs** | http://localhost:8000/docs | Interactive API testing |
| **Mongo Express** | http://localhost:8081 | Database viewer (admin/pass123) |
| **Health Check** | http://localhost:8000/api/health/ | API status |

---

## 📖 Step-by-Step Usage

### Step 1: Upload Syllabus PDF (2-3 minutes)

```
1. Open http://localhost:8501
2. Click Tab 1: "Upload Syllabus"
3. Enter Course Name: e.g., "Digital Signal Processing"
4. Select your PDF file
5. Click "Upload & Process Syllabus"
6. Wait 5-10 seconds
✓ You'll see: Syllabus ID, chunk count, text length
```

**What happens behind the scenes:**
- PDF text is extracted
- Text is split into chunks
- Chunks are converted to vectors (embeddings)
- Vectors are stored in FAISS for fast search
- Metadata stored in MongoDB

---

### Step 2: Generate Lesson Plan (15-30 seconds)

```
1. Click Tab 2: "Generate Lesson Plan"
2. Select your uploaded syllabus from dropdown
3. Enter Topic: e.g., "Fourier Transform"
4. Select Subject Type: theory / laboratory / theory-cum-laboratory
5. Click "Generate Lesson Plan"
6. Wait 20-60 seconds (first time slower)
✓ You'll see: Complete lesson plan with:
   - Topic explanation
   - Learning objectives (Bloom's Taxonomy)
   - Teaching methodologies
   - Active Learning Methods
   - Lab/Activity ideas
7. Click "Download as Text" to save
```

**What happens:**
- Your topic + syllabus context is sent to FastAPI
- RAG searches FAISS index for top 5 relevant chunks
- Ollama LLM generates lesson plan using context
- Result stored in MongoDB
- Displayed in Streamlit with download option

---

### Step 3: Generate Exam Questions (20-30 seconds)

```
1. Click Tab 3: "Generate Exam Questions"
2. Select same syllabus
3. Optional: Enter topic focus
4. Set question count: 5-50 questions
5. Click "Generate Exam Questions"
6. Wait 25-70 seconds
✓ You'll see: Mix of:
   - Multiple Choice Questions (MCQ)
   - Short answer questions
   - Long answer questions
   - Difficulty levels assigned
7. Click "Download Questions" to save
```

---

### Step 4: View History (5 seconds)

```
1. Click Tab 4: "View History"
2. See all uploaded syllabi
3. See all generated lesson plans
4. See last 10 question generation sessions
```

---

## ⏱️ Performance Timeline

| Step | Time | What it's doing |
|------|------|-----------------|
| **Startup** | 30-60s | Starting containers |
| **phi3-mini download** | 5-15 min | One-time model download (2.7GB) |
| **PDF upload** | 5-10s | Extract text, chunk, embed, index |
| **First lesson plan** | 30-60s | Loading model into RAM + generation |
| **Subsequent plans** | 5-15s | Model already in RAM |
| **Questions** | 25-70s | Analyzing + generating |

---

## 🔧 Common Issues & Fixes

### Issue: "Streamlit not loading"
```powershell
# Check if running
docker compose ps streamlit

# Restart
docker compose restart streamlit

# View logs
docker compose logs -f streamlit
```

### Issue: "phi3-mini not found"
```powershell
# Pull it again
docker compose exec ollama ollama pull phi3-mini

# Takes 5-15 minutes - be patient!
# Then verify
docker compose exec ollama ollama ls
```

### Issue: "Connection refused" to API
```powershell
# Wait 30 seconds and try again

# Or restart FastAPI
docker compose restart fastapi

# Check logs
docker compose logs fastapi
```

### Issue: "MongoDB connection error"
```powershell
# Check password in .env matches docker-compose

# Reset MongoDB
docker compose down mongo
docker compose up -d mongo
```

### Issue: Port 8501/8000 already in use
```powershell
# Find process using port
netstat -ano | findstr :8501

# Or just restart everything
docker compose down
docker compose up -d --build
```

---

## 🎓 FastAPI Advantages

**Why we use FastAPI instead of Django:**

- ✅ **Faster** - 2x faster request handling
- ✅ **Lighter** - ~100MB vs ~200MB memory
- ✅ **Auto Docs** - Interactive API at `/docs`
- ✅ **Modern** - Built on latest Python async
- ✅ **Easy** - Simpler code, less boilerplate
- ✅ **Same Features** - All endpoints work identically

**Interactive API Testing:**
1. Open http://localhost:8000/docs
2. Click any endpoint
3. Click "Try it out"
4. Enter parameters
5. Click "Execute"
6. See live response!

---

## 🧪 Testing

### Verify Everything Works
```powershell
# Python verification script
python verify.py

# Expected output:
# ✓ FastAPI: http://localhost:8000/api/health/
# ✓ Streamlit: http://localhost:8501
# ✓ Ollama: http://localhost:11434/api/tags
# ✓ phi3-mini model is ready!
```

### Quick API Test
```powershell
# Check health
curl http://localhost:8000/api/health/

# Should return: {"status":"ok","service":"FastAPI"}
```

### Test with Sample PDF
1. Create or download a sample PDF
2. Upload through Streamlit UI (Tab 1)
3. Generate lesson plan (Tab 2)
4. Verify output appears

---

## 📊 System Requirements

**Minimum:**
- 8 GB RAM
- 20 GB free disk space
- Windows 10/11, Mac, or Linux
- Docker Desktop

**Recommended:**
- 16 GB RAM
- 30 GB free disk space
- SSD storage
- Fast internet (for model download)

---

## 🛑 Stopping & Starting

### Stop (preserve data)
```powershell
docker compose stop
```

### Start again
```powershell
docker compose start
```

### Restart all
```powershell
docker compose restart
```

### Stop everything (delete containers)
```powershell
docker compose down
```

### Stop and delete data
```powershell
docker compose down -v
```

---

## 📁 Files You Need to Know

| File | Purpose |
|------|---------|
| `.env` | Configuration (passwords, URLs) |
| `docker-compose.yml` | Service definitions |
| `startup.ps1` | Automated startup script |
| `verify.py` | Service verification |
| `fastapi_backend/main.py` | FastAPI code |
| `frontend/app.py` | Streamlit code |

---

## 🔒 Security Checklist

Before sharing/deploying:
- [ ] Changed `MONGO_INITDB_ROOT_PASSWORD` in `.env`
- [ ] Generated new `SECRET_KEY`
- [ ] Set `DEBUG=False` (if applicable)
- [ ] Restricted `CORS_ALLOWED_ORIGINS`
- [ ] Backed up MongoDB data
- [ ] Used HTTPS in production

---

## 💡 Pro Tips

1. **First request is slow?** Normal - LLM loads into RAM. Subsequent requests are fast.

2. **Want to test API without Streamlit?**
   - Go to http://localhost:8000/docs
   - Click any endpoint
   - Click "Try it out"
   - Test interactively!

3. **Data stored where?**
   - PDFs & lesson plans: MongoDB
   - Vector indices: FAISS (in memory)
   - Model: Ollama container

4. **Need to reset everything?**
   ```powershell
   docker compose down -v
   docker compose up -d --build
   docker compose exec ollama ollama pull phi3-mini
   ```

5. **Check what's running:**
   ```powershell
   docker compose ps
   ```

6. **View live logs:**
   ```powershell
   docker compose logs -f SERVICE_NAME
   ```

---

## 📞 Troubleshooting Checklist

Before asking for help, try:

1. ✓ Is Docker running? `docker ps`
2. ✓ Are containers up? `docker compose ps`
3. ✓ Check logs: `docker compose logs -f`
4. ✓ Restart service: `docker compose restart fastapi`
5. ✓ Reset everything: `docker compose down -v && docker compose up -d --build`

---

## 🎉 You're Ready!

1. Run `.\startup.ps1` (or manual steps)
2. Wait for phi3-mini to download
3. Open http://localhost:8501
4. Upload a PDF
5. Generate lesson plans & questions
6. Download and use!

---

**Questions?** Check:
- `FASTAPI_STARTUP.md` — Detailed startup guide
- `SETUP_GUIDE.md` — Comprehensive guide
- `QUICK_REFERENCE.md` — Quick cheat sheet

---

**Happy lesson planning! 🎓**

SkillSketch v1.0 with FastAPI & phi3-mini  
Built with ❤️ for engineering education
