# SkillSketch — Quick Reference Card

## 🚀 Quick Start (Local Setup)

```powershell
# 1. Configure
copy .env.example .env

# 2. Start services (opens 3 new terminals)
.\startup.ps1

# 3. Access
# Streamlit:  http://localhost:8501
# FastAPI:    http://localhost:8000/docs
# API:        http://localhost:8000/api/health/
```

---

## 📋 Workflow

### 1️⃣ Upload Syllabus (Tab 1)
- Course Name: Enter name (e.g., "DSP")
- Upload: Select PDF
- Click: "Upload & Process Syllabus"
- Result: Syllabus ID + chunk count

### 2️⃣ Generate Lesson Plan (Tab 2)
- Select: Syllabus from dropdown
- Topic: Enter topic (e.g., "Fourier Transform")
- Type: Select theory/lab/theory-cum-lab
- Click: "Generate Lesson Plan"
- Result: Structured lesson plan (download as .txt)

### 3️⃣ Generate Questions (Tab 3)
- Select: Same syllabus
- Topic: (Optional) topic focus
- Count: Slide to select 5-50 questions
- Click: "Generate Exam Questions"
- Result: MCQ, short/long answer questions (download)

### 4️⃣ View History (Tab 4)
- See all uploaded syllabi
- See all generated plans
- See question generation sessions

---

## 🔌 API Quick Reference

```bash
# Health
GET http://localhost:8000/api/health/

# Ollama Status
GET http://localhost:8000/api/ollama/status/

# Upload PDF
curl -X POST http://localhost:8000/api/upload-syllabus/ \
  -F "file=@syllabus.pdf" \
  -F "course_name=DSP"

# Generate Plan (need syllabus_id from upload response)
curl -X POST http://localhost:8000/api/generate-lesson-plan/ \
  -H "Content-Type: application/json" \
  -d '{
    "syllabus_id": "COPY_ID_HERE",
    "topic": "Fourier Transform",
    "subject_type": "theory"
  }'

# Generate Questions
curl -X POST http://localhost:8000/api/generate-exam-questions/ \
  -H "Content-Type: application/json" \
  -d '{
    "syllabus_id": "COPY_ID_HERE",
    "topic": "Signals",
    "question_count": 10
  }'

# List Syllabi
GET http://localhost:8000/api/syllabi/

# List Plans
GET http://localhost:8000/api/lesson-plans/
```

---

## 🐛 Troubleshooting Quick Fixes

| Issue | Fix |
|-------|-----|
| **"Backend Offline"** | Check Terminal 1: `cd fastapi_backend && python -m uvicorn main:app --reload` |
| **"Ollama Offline"** | Check Terminal 3: `ollama serve` |
| **"Streamlit won't load"** | Check Terminal 2: `cd frontend && streamlit run app.py` |
| **"MongoDB Error"** | Start service: `Start-Service MongoDB` |
| **"No text from PDF"** | Use text-based PDF (not scanned image) |
| **Slow generation** | First run loads model (normal: 20-60s) |
| **Port already in use** | Stop services and restart with `.\startup.ps1` |

---

## 📁 Important Files

| File | What to Edit |
|------|-------------|
| `.env` | Passwords, LLM model, URLs |
| `fastapi_backend/main.py` | API endpoint logic |
| `fastapi_backend/requirements.txt` | Backend dependencies |
| `frontend/app.py` | UI changes |
| `frontend/requirements.txt` | Frontend dependencies |
| `startup.ps1` | Service startup configuration |
| `LOCAL_SETUP.md` | Complete setup guide |

---

## ⚙️ Environment Variables (`.env`)

```env
# Required
MONGO_INITDB_ROOT_PASSWORD=YourPassword123!

# Optional (defaults shown)
DEBUG=False
OLLAMA_MODEL=phi3:mini
OLLAMA_HOST=http://localhost:11434
MONGO_INITDB_ROOT_USERNAME=admin
BACKEND_URL=http://127.0.0.1:8000
```

---

## 📊 Performance Baseline

| Task | Time |
|------|------|
| PDF upload (10 pages) | 5-10s |
| Lesson plan (first) | 30-60s |
| Lesson plan (cached) | 5-15s |
| Questions generation | 25-70s |

---

## 🧪 Testing

```bash
# Full integration test
python tests/api_test.py

# MongoDB test
python tests/mongo_test.py

# Bash test suite
bash tests/test_api.sh
```

---

## 🔒 Security Checklist

- [ ] Changed `MONGO_INITDB_ROOT_PASSWORD`
- [ ] Generated new `SECRET_KEY`
- [ ] Set `DEBUG=False`
- [ ] Restricted `CORS_ALLOWED_ORIGINS`
- [ ] Used HTTPS in production
- [ ] Backed up MongoDB
- [ ] Monitored logs

---

## 📚 Documentation Files

- **README.md** — Overview & features
- **SETUP_GUIDE.md** — Detailed setup & workflows
- **IMPLEMENTATION_SUMMARY.md** — Architecture & implementation
- **QUICK_REFERENCE.md** — This file!

---

## 💡 Tips & Tricks

**Tip 1:** Use short topics for faster generation
- ✅ "Fourier Transform"
- ❌ "Advanced Signal Processing Techniques in Digital Domain"

**Tip 2:** First request takes longer (model loading)
- First: 30-60s
- Subsequent: 5-15s

**Tip 3:** Keep PDFs small (~10-20 pages)
- Easier to process
- Better context retrieval

**Tip 4:** Download results immediately
- Browser cache may clear them
- Save locally for reference

---

## 🆘 Emergency Commands

```powershell
# Stop everything
docker compose down

# Remove all containers & volumes
docker compose down -v

# View all logs
docker compose logs -f

# Restart specific service
docker compose restart fastapi
docker compose restart ollama
docker compose restart mongo

# Rebuild from scratch
docker compose build --no-cache
docker compose up -d

# Check if services are running
docker compose ps

# Enter a container
python -c "cd fastapi_backend && python -m uvicorn main:app --reload"
docker compose exec ollama bash
```

---

## 📞 When Stuck

1. **Check logs:** `docker compose logs -f`
2. **Run tests:** `python tests/api_test.py`
3. **Verify services:** `docker compose ps`
4. **Read:** Check SETUP_GUIDE.md for troubleshooting
5. **Restart:** `docker compose restart` (usually fixes it!)

---

## 🎓 Example Workflow

```
1. Open http://localhost:8501 (Streamlit)
2. Tab 1: Upload syllabus PDF
   → Wait 10s → Get Syllabus ID
3. Tab 2: Select syllabus → Enter "Signal Processing" → Generate
   → Wait 40s → Get lesson plan
4. Tab 3: Generate 10 questions
   → Wait 45s → Get questions
5. Download both files
6. Done! ✓
```

---

**Last Updated:** Feb 4, 2026  
**Version:** SkillSketch v1.0  
**Status:** ✅ Production Ready
