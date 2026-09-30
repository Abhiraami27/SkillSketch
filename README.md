# SkillSketch — AI-Powered Lesson Plan Generator with RAG

An AI-driven syllabus-based lesson plan generation system for engineering faculty supporting outcome-based education.

**✨ Key Features:**
- 📄 **PDF Syllabus Upload** with automatic text extraction
- 🧠 **RAG (Retrieval-Augmented Generation)** for context-aware generation
- 📚 **AI Lesson Plan Generation** with learning objectives, methodologies, ALM
- ❓ **Automatic Exam Question Extraction** (MCQ, short/long answer, difficulty levels)
- 🎯 **4-Tab Web Interface** (Upload | Lesson Plans | Questions | History)
- 🔒 **Data Privacy** - locally hosted LLM via Ollama, no cloud dependency
- ⚡ **Fast & Efficient** - FAISS vector search, MongoDB persistence

**Tech Stack:**
- Backend: **FastAPI** + **uvicorn** (modern async REST API)
- Frontend: Streamlit (4-tab web UI)
- Database: MongoDB
- Vector DB: FAISS (semantic search)
- LLM: Ollama (phi3-mini, locally hosted)
- Embeddings: sentence-transformers

---

## Quick Start (Local Setup)

### 1. Clone/Navigate to Project
```bash
cd D:\skillsketch-main\skillsketch-main
```

### 2. Configure Environment
```powershell
copy .env.example .env
# Edit .env and set secure passwords
```

### 3. Install MongoDB (Local)
```powershell
# Download from https://www.mongodb.com/try/download/community
# Or use Windows Package Manager: choco install mongodb-community
```

### 4. Install & Start Ollama (Local)
```powershell
# Download from https://ollama.ai
# Start Ollama service and pull model:
ollama pull phi3:mini
```

### 5. Start Backend (FastAPI)
```powershell
cd fastapi_backend
python -m pip install -r requirements.txt
python -m uvicorn main:app --host 127.0.0.1 --port 8000 --reload
```

### 6. Start Frontend (Streamlit) - In New Terminal
```powershell
cd frontend
python -m pip install -r requirements.txt
streamlit run app.py
```

### 7. Access Application
- **Streamlit UI:** http://localhost:8501
- **FastAPI Docs:** http://localhost:8000/docs
- **API Health:** http://localhost:8000/api/health/
- **MongoDB:** localhost:27017 (if running locally)

---

## Workflow: Upload → Generate Plans → Extract Questions

### Step 1: Upload Syllabus (Tab 1)
- Upload PDF course syllabus
- Automatic text extraction + chunking
- Vector embeddings created (FAISS)
- Stored in MongoDB

### Step 2: Generate Lesson Plan (Tab 2)
- Select uploaded syllabus
- Enter topic (e.g., "Fourier Transform")
- RAG retrieves relevant chunks
- Ollama AI generates structured lesson plan
- Includes: objectives, methodologies, ALM, lab ideas

### Step 3: Generate Exam Questions (Tab 3)
- Select same syllabus
- Specify question count (5-50)
- AI analyzes syllabus patterns
- Generates: MCQ, short answer, long answer questions
- Includes difficulty levels

### Step 4: View History (Tab 4)
- All uploaded syllabi
- All generated lesson plans
- Reuse previous results

---

## Project Structure

```
skillsketch/
├── fastapi_backend/
│   ├── main.py                       # FastAPI app with all endpoints
│   ├── requirements.txt              # FastAPI dependencies
│   └── (no Dockerfile - local only)
│
├── frontend/
│   ├── app.py                        # Streamlit 4-tab UI
│   ├── requirements.txt              # Streamlit dependencies
│   └── (no Dockerfile - local only)
│
├── fastapi_backend/                  # FastAPI REST API (uvicorn)
│   ├── README.md
│
├── tests/
│   ├── api_test.py                   # Integration test script
│   └── upload_test.py                # Upload endpoint test
│
├── scripts/
│   ├── find_ollama.ps1               # Find Ollama installation
│   ├── check_user_ollama.ps1         # Check user Ollama path
│   └── probe_ollama_paths.ps1        # Probe common Ollama locations
│
├── data/                             # Local data storage
│   ├── uploads/                      # PDF uploads
│   ├── syllabi.json                  # Syllabus metadata
│   ├── lesson_plans.json             # Generated lesson plans
│   └── questions.json                # Generated exam questions
│
├── .env.example                      # Configuration template
├── .gitignore
├── README.md                         # This file
├── SETUP_GUIDE.md                    # Detailed setup & troubleshooting
├── GETTING_STARTED.md                # Quick start guide
├── FASTAPI_STARTUP.md                # FastAPI-specific guide
├── IMPLEMENTATION_SUMMARY.md         # Feature summary & architecture
├── QUICK_REFERENCE.md                # Quick reference guide
├── startup.py                        # Startup verification script
└── verify.py                         # Service verification script
```

---

## API Endpoints

### Health & Status
```
GET  /api/health/                    # Backend status
GET  /api/ollama/status/             # Ollama availability
```

### Syllabus Management
```
POST /api/upload-syllabus/           # Upload PDF (multipart form-data)
GET  /api/syllabi/                   # List all syllabi
GET  /api/syllabi/{id}/              # Get syllabus details
DELETE /api/syllabi/{id}/            # Delete syllabus
```

### Lesson Plan Generation
```
POST /api/generate-lesson-plan/      # Generate RAG-based lesson plan
GET  /api/lesson-plans/              # List generated plans
GET  /api/lesson-plans/{id}/         # Get specific plan
```

### Exam Question Generation
```
POST /api/generate-exam-questions/   # Generate questions from syllabus
```

---

## Example Usage

### Upload Syllabus
```bash
curl -X POST http://localhost:8000/api/upload-syllabus/ \
  -F "file=@syllabus.pdf" \
  -F "course_name=Digital Signal Processing"
```

### Generate Lesson Plan (with RAG context)
```bash
curl -X POST http://localhost:8000/api/generate-lesson-plan/ \
  -H "Content-Type: application/json" \
  -d '{
    "syllabus_id": "SYLLABUS_ID_HERE",
    "topic": "Fourier Transform",
    "subject_type": "theory"
  }'
```

### Generate Exam Questions
```bash
curl -X POST http://localhost:8000/api/generate-exam-questions/ \
  -H "Content-Type: application/json" \
  -d '{
    "syllabus_id": "SYLLABUS_ID_HERE",
    "topic": "Signal Processing",
    "question_count": 10
  }'
```

---

## Testing

### Run Integration Tests
```bash
# Python test script
python tests/api_test.py

# Or bash script (requires curl & jq)
bash tests/test_api.sh
```

### Manual Testing
```powershell
# Health check
curl http://localhost:8000/api/health/

# MongoDB connection
python tests/mongo_test.py

# Ollama status
curl http://localhost:8000/api/ollama/status/
```

---

## Performance Expectations

| Operation | Time | Notes |
|-----------|------|-------|
| PDF Upload (10 pages) | 5-10s | Text extraction + chunking |
| Embedding Creation | 2-3s | Per 50 chunks |
| Lesson Plan Generation | 20-60s | First: model loading; subsequent: 5-15s |
| Question Generation | 25-70s | Depends on model & question count |

---

## Troubleshooting

### Backend Not Running
```powershell
docker compose logs fastapi
docker compose up -d --build
```

### Ollama Not Available
```powershell
ollama ls
ollama pull phi3:mini
```

### MongoDB Connection Error
```powershell
# Check MongoDB service is running
Get-Service MongoDB

# If not running, start it:
Start-Service MongoDB
```

### PDF Text Not Extracted
- Ensure PDF is text-based (not scanned image)
- Try with different PDF file
- Check file is valid PDF

---

## Development Setup (Local - No Docker)

### Backend (FastAPI)
```bash
python -m venv .venv
.\.venv\Scripts\Activate.ps1  # Windows

pip install -r fastapi_backend/requirements.txt
cd fastapi_backend
python -m uvicorn main:app --host 127.0.0.1 --port 8000 --reload
```

### Frontend (Streamlit)
```bash
python -m venv .venv
.\.venv\Scripts\Activate.ps1

pip install -r frontend/requirements.txt
streamlit run frontend/app.py
```

### MongoDB (Local)
```bash
# Windows: Download from https://www.mongodb.com/try/download/community
# Then start the MongoDB service
# Or use Docker for just MongoDB:
docker run -d -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=pass123 mongo:6.0
```

### Ollama (Local)
```bash
# Download from https://ollama.ai and install
# Start Ollama and pull phi3 model:
ollama pull phi3:mini
```

---

## Security (Production)

⚠️ **Before going to production:**

1. Change all default credentials in `.env`
2. Set `DEBUG=False`
3. Generate new `SECRET_KEY`:
   ```bash
python -c "import secrets; print(secrets.token_urlsafe(50))"
   ```
4. Enable HTTPS (use reverse proxy)
5. Restrict CORS origins
6. Regular MongoDB backups
7. Monitor logs for security events

---

## System Architecture

```
┌─────────────────────────────────────┐
│    STREAMLIT WEB UI (Tab 1-4)       │
│ Upload | Plans | Questions | History│
└──────────────┬──────────────────────┘
               │ HTTP (port 8501)
┌──────────────▼──────────────────────┐
│    FASTAPI REST API (UVICORN)       │
│  ├─ POST /upload-syllabus/          │
│  ├─ POST /generate-lesson-plan/     │
│  ├─ POST /generate-exam-questions/  │
│  └─ GET /syllabi/, /lesson-plans/   │
└──────────┬────────────────┬─────────┘
           │                │
    ┌──────▼──────┐  ┌──────▼──────┐
    │  MONGODB    │  │  OLLAMA LLM │
    │  (storage)  │  │ (generation)│
    └─────────────┘  └─────────────┘
           │
    ┌──────▼──────────┐
    │  FAISS Vector   │
    │  Index (search) │
    └─────────────────┘
```

---

## Key Technologies

| Component | Technology | Purpose |
|-----------|-----------|---------|
| Backend | FastAPI 0.95.1 + uvicorn | REST API |
| Frontend | Streamlit | Web UI |
| Database | MongoDB | Document storage |
| Vector DB | FAISS | Semantic search |
| Embeddings | sentence-transformers | Text vectorization |
| LLM | Ollama + phi3-mini | Local AI |
| PDF Processing | PyPDF2 | Text extraction |
| Containerization | Docker Compose | Orchestration |

---

## Limitations & Future Work

- [ ] Course Outcome (CO) → Program Outcome (PO) mapping
- [ ] UN Sustainable Development Goals (SDG) alignment
- [ ] Multi-LLM support (GPT, Llama, Claude)
- [ ] User authentication & roles
- [ ] Batch processing
- [ ] Export formats (GIFT, IMS-QTI)
- [ ] Performance analytics dashboard

---

## Support & Contributing

**For issues:**
1. Check [SETUP_GUIDE.md](SETUP_GUIDE.md) for detailed troubleshooting
2. View logs: `docker compose logs -f`
3. Run tests: `python tests/api_test.py`

**To contribute:**
1. Create a feature branch
2. Make changes
3. Test with `api_test.py`
4. Submit PR

---

## Documentation

- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** — Complete setup, usage, and troubleshooting
- **[IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)** — Feature overview and architecture
- **API Documentation** — See "API Endpoints" section above

---

## License

[Specify your license, e.g., MIT, Apache 2.0]

---

## Contact & Support

For questions, issues, or contributions:
- Create an issue with error details and logs
- Include sample PDF if PDF-related
- Provide environment info (Windows/Linux, Docker version, etc.)

---

**Happy lesson planning! 🎓✨**

*SkillSketch v1.0 — Local AI-Powered Education Technology*
