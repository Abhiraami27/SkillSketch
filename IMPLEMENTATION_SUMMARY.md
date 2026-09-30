# SkillSketch — PDF Syllabus + RAG + Exam Questions Feature Complete ✓

## What's New

Your SkillSketch system now has **complete PDF syllabus processing with RAG and exam question generation**:

### ✅ Implemented Features

1. **PDF Syllabus Upload & Processing**
   - Upload PDF files directly from Streamlit UI
   - Automatic text extraction (PyPDF2)
   - Text chunking (500 chars, 100 char overlap)
   - Stored in MongoDB for persistence

2. **Retrieval-Augmented Generation (RAG)**
   - Vector embeddings using `sentence-transformers` (all-MiniLM-L6-v2)
   - FAISS indexing for semantic search
   - Relevant chunks retrieved for context
   - Augmented prompts sent to Ollama

3. **Syllabus-Grounded Lesson Plans**
   - Generates lesson plans using syllabus as context
   - Includes: topics, learning objectives (Bloom's Taxonomy), methodologies, ALM, lab ideas
   - 4 subject types: theory, laboratory, theory-cum-laboratory
   - Downloadable as `.txt`

4. **Important Exam Question Generation**
   - Analyzes syllabus to extract key concepts
   - Generates diverse question types: MCQ, short answer, long answer
   - Assigns difficulty levels
   - Configurable question count (5-50)
   - Downloadable output

5. **Web Interface (Streamlit)**
   - Tab 1: Upload Syllabus with course name
   - Tab 2: Generate Lesson Plan (RAG-based)
   - Tab 3: Generate Exam Questions
   - Tab 4: View history of all uploads/generations
   - Real-time service status monitoring

6. **REST API (FastAPI + uvicorn)**
   - `POST /api/upload-syllabus/` — Upload PDF
   - `GET /api/syllabi/` — List syllabi
   - `POST /api/generate-lesson-plan/` — RAG-based generation
   - `POST /api/generate-exam-questions/` — Question extraction
   - `GET /api/lesson-plans/` — View generated plans

---

## New Files Created

### Backend
- `skillsketch/pdf_utils.py` — PDF extraction & text chunking
- `skillsketch/rag_engine.py` — Vector embeddings & semantic search (FAISS)
- Updated `lessonplans/views.py` — New endpoints for upload, generation
- Updated `skillsketch/urls.py` — Route new endpoints
- `backend/Dockerfile` — Container config
- Updated `requirements.txt` — Added FAISS, sentence-transformers

### Frontend
- Updated `frontend/app.py` — Complete 4-tab UI
- Tab 1: PDF upload with metadata
- Tab 2: Lesson plan generation with downloads
- Tab 3: Exam question generation
- Tab 4: History & statistics

### Documentation
- `SETUP_GUIDE.md` — Complete setup & workflow guide
- `tests/api_test.py` — Integration test script

---

## How It Works (User Journey)

### Step 1: Upload Syllabus
```
User uploads PDF in Streamlit → 
  PDF text extracted (PyPDF2) → 
  Text chunked & cleaned → 
  Embeddings created (sentence-transformers) → 
  Stored in MongoDB + FAISS index
```

### Step 2: Generate Lesson Plan
```
User selects syllabus + topic + subject type → 
  RAG retrieves top 5 relevant chunks → 
  Augmented prompt created with context → 
  Sent to Ollama (phi3-mini) → 
  Generated plan stored in MongoDB → 
  Displayed in Streamlit
```

### Step 3: Generate Exam Questions
```
User selects syllabus + question count → 
  RAG retrieves top 8 relevant chunks → 
  Augmented prompt with analysis instructions → 
  Ollama generates diverse question types → 
  Stored in MongoDB → 
  Downloadable in Streamlit
```

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────┐
│             STREAMLIT UI                        │
│  (Tabs: Upload | Lesson Plan | Questions | History)
└──────────────────┬──────────────────────────────┘
                   │ HTTP
┌──────────────────▼──────────────────────────────┐
│             FASTAPI REST API (UVICORN)          │
│  ├─ POST /upload-syllabus/                      │
│  ├─ POST /generate-lesson-plan/                 │
│  ├─ POST /generate-exam-questions/              │
│  └─ GET /syllabi/, /lesson-plans/               │
└──────────┬──────────────────────────┬───────────┘
           │                          │
    ┌──────▼─────────┐       ┌────────▼────────┐
    │  MONGODB       │       │  OLLAMA (LLM)   │
    │  ├─ syllabi    │       │  Model: phi3-   │
    │  ├─ lesson_    │       │  mini (~2.7GB)  │
    │  │  plans      │       │                 │
    │  └─ exam_      │       │  Generates:     │
    │     questions  │       │  - Lesson plans │
    └────────────────┘       │  - Questions    │
         (CRUD)              └─────────────────┘
           │
    ┌──────▼─────────┐
    │ Vector Storage │
    │  ├─ FAISS      │  Semantic search
    │  │  Index      │  & retrieval
    │  └─ Chunks +   │
    │     Metadata   │
    └────────────────┘
```

---

## API Examples

### Upload Syllabus
```bash
curl -X POST http://localhost:8000/api/upload-syllabus/ \
  -F "file=@syllabus.pdf" \
  -F "course_name=Digital Signal Processing"

# Response:
# {
#   "id": "507f1f77bcf86cd799439011",
#   "course_name": "Digital Signal Processing",
#   "chunks": 45,
#   "text_length": 23456
# }
```

### Generate Lesson Plan (RAG)
```bash
curl -X POST http://localhost:8000/api/generate-lesson-plan/ \
  -H "Content-Type: application/json" \
  -d '{
    "syllabus_id": "507f1f77bcf86cd799439011",
    "topic": "Fourier Transform",
    "subject_type": "theory"
  }'

# Response:
# {
#   "id": "507f1f77bcf86cd799439012",
#   "topic": "Fourier Transform",
#   "lesson_plan": "## Fourier Transform..."
# }
```

### Generate Exam Questions
```bash
curl -X POST http://localhost:8000/api/generate-exam-questions/ \
  -H "Content-Type: application/json" \
  -d '{
    "syllabus_id": "507f1f77bcf86cd799439011",
    "topic": "Signal Processing",
    "question_count": 10
  }'

# Response:
# {
#   "id": "507f1f77bcf86cd799439013",
#   "questions": "1) MCQ: ...\n2) Short Answer: ..."
# }
```

---

## Performance Expectations

| Operation | Time | Notes |
|-----------|------|-------|
| PDF Upload (10 pages) | 5-10s | Text extraction + chunking |
| Embedding Creation (50 chunks) | 2-3s | Using all-MiniLM-L6-v2 |
| FAISS Index Build | 1-2s | Per 50 chunks |
| Lesson Plan Generation | 20-60s | First run: model loading; subsequent: 5-15s |
| Question Generation (10 Qs) | 25-70s | Depends on LLM speed |

---

## Configuration (`.env`)

```env
# Core Settings
SECRET_KEY=your-secret-key-here
DEBUG=False
ALLOWED_HOSTS=localhost,127.0.0.1

# MongoDB
MONGO_INITDB_ROOT_USERNAME=admin
MONGO_INITDB_ROOT_PASSWORD=secure_password_here
MONGO_DB=skillsketch
MONGO_URI=mongodb://admin:secure_password_here@mongo:27017/skillsketch?authSource=admin

# Ollama
OLLAMA_HOST=http://ollama:11434
OLLAMA_MODEL=phi3-mini

# CORS
CORS_ALLOWED_ORIGINS=http://localhost:8501,http://127.0.0.1:8501,http://streamlit:8501

# Frontend
BACKEND_URL=http://127.0.0.1:8000/api
```

---

## Quick Start (Recap)

```powershell
# 1. Configure
copy .env.example .env
# Edit .env with passwords

# 2. Start Stack
docker compose up -d --build

# 3. Access
# Streamlit:     http://localhost:8501
# API:           http://localhost:8000/api/health/
# Mongo Express: http://localhost:8081

# 4. Test (optional)
python tests/api_test.py
```

---

## Next Steps

1. **Pull phi3-mini model:**
   ```powershell
   docker compose exec ollama ollama pull phi3-mini
   ```

2. **Upload your first PDF** in Streamlit Tab 1

3. **Generate lesson plans** in Tab 2

4. **Extract exam questions** in Tab 3

5. **View all data** in Tab 4 or Mongo Express

---

## Troubleshooting

### "No text extracted from PDF"
- Ensure PDF is text-based (not scanned image)
- Try with different PDF

### Generation is slow
- First request: model loads into RAM (20-60s normal)
- Subsequent: should be 5-15s
- Allocate more RAM to Docker if issues persist

### MongoDB connection error
- Check MongoDB service is running: `Get-Service MongoDB`
- Verify MONGO_INITDB_ROOT_PASSWORD is set in `.env`
- Start MongoDB: `Start-Service MongoDB`

### Ollama not found
```powershell
# Install Ollama from https://ollama.ai/
ollama pull phi3:mini
```

---

## Files Summary

| File | Purpose |
|------|---------|
| `fastapi_backend/main.py` | FastAPI REST API endpoints |
| `fastapi_backend/requirements.txt` | Backend Python dependencies |
| `frontend/app.py` | Streamlit 4-tab UI |
| `frontend/requirements.txt` | Frontend Python dependencies |
| `LOCAL_SETUP.md` | Complete local setup & usage guide |
| `GETTING_STARTED.md` | Quick start guide |
| `data/` | Local JSON storage (syllabi, plans, questions) |
| `tests/api_test.py` | Integration test script |
| `startup.ps1` | Automated service startup (PowerShell) |
| `startup.py` | Startup verification (Python) |
| `verify.py` | Service health verification |

---

## Success Criteria ✓

- [x] PDF upload and storage
- [x] Text extraction and chunking
- [x] Vector embeddings (FAISS)
- [x] RAG-based lesson plan generation
- [x] Exam question generation
- [x] MongoDB persistence
- [x] REST API endpoints
- [x] Streamlit UI with 4 tabs
- [x] Download functionality
- [x] Complete documentation

**System is fully functional and ready for local development!**

---

**To start using:**
```powershell
.\startup.ps1          # Start all services
python verify.py       # Check services are running
```

Then open http://localhost:8501 in your browser.

Happy lesson planning! 🎓
