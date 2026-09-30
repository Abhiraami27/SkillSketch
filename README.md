# 🎓 SkillSketch — AI-Powered Lesson Plan Generator with RAG

> **An AI-powered, syllabus-based lesson planning and assessment generation platform for engineering faculty, built around Retrieval-Augmented Generation (RAG) and locally hosted AI.**

SkillSketch helps faculty transform course syllabi into structured **lesson plans** and **exam questions** using AI.

The system accepts PDF syllabi, extracts and indexes their content, retrieves relevant syllabus context using **FAISS**, and generates educational content using a locally hosted **Ollama LLM**.

The application is designed with a **FastAPI backend**, **Streamlit frontend**, **MongoDB persistence**, **FAISS semantic search**, and **Sentence-Transformers embeddings**.

---

## 🚀 Key Features

### 📄 Syllabus Upload

* Upload PDF-based course syllabi
* Automatic PDF text extraction
* Text chunking and preprocessing
* Syllabus metadata persistence

### 🧠 Retrieval-Augmented Generation

SkillSketch uses RAG to ground AI-generated content in the uploaded syllabus.

**Pipeline:**

```text
PDF Syllabus
     ↓
Text Extraction
     ↓
Text Chunking
     ↓
Sentence Embeddings
     ↓
FAISS Vector Index
     ↓
Relevant Context Retrieval
     ↓
Ollama LLM
     ↓
Generated Educational Content
```

### 📚 AI Lesson Plan Generation

Generate structured lesson plans based on syllabus content.

Generated plans can include:

* Learning objectives
* Teaching methodologies
* Activity-Based Learning (ALM)
* Laboratory ideas
* Topic-specific teaching content

### ❓ Automatic Exam Question Generation

Generate questions from uploaded syllabus content.

Supported question types include:

* Multiple Choice Questions
* Short-answer questions
* Long-answer questions
* Different difficulty levels

Question count can be configured from **5–50 questions**.

### 🖥️ Four-Tab Web Interface

The Streamlit application provides four major sections:

```text
┌─────────────────────────────────────────────┐
│              SKILLSKETCH UI                 │
├───────────┬───────────┬──────────┬─────────┤
│  Upload   │  Lesson   │ Questions│ History │
│           │   Plans   │          │         │
└───────────┴───────────┴──────────┴─────────┘
```

### 🔒 Local AI & Privacy

The project uses **Ollama** for local LLM inference, reducing dependency on external cloud AI services.

This allows syllabus content and generated educational material to remain within the local development environment.

### ⚡ Semantic Search

FAISS is used for efficient vector similarity search, while Sentence-Transformers generates embeddings for syllabus content.

---

# 🏗️ System Architecture

```text
                    ┌───────────────────────┐
                    │       FACULTY         │
                    └───────────┬───────────┘
                                │
                                ▼
                    ┌───────────────────────┐
                    │   STREAMLIT WEB UI    │
                    │                       │
                    │ Upload | Plans |       │
                    │ Questions | History   │
                    └───────────┬───────────┘
                                │
                         HTTP Requests
                                │
                                ▼
                    ┌───────────────────────┐
                    │    FASTAPI BACKEND    │
                    │       Uvicorn         │
                    └───────────┬───────────┘
                                │
              ┌─────────────────┼─────────────────┐
              │                 │                 │
              ▼                 ▼                 ▼
       ┌────────────┐    ┌────────────┐    ┌────────────┐
       │  MongoDB   │    │   FAISS    │    │   Ollama   │
       │  Storage   │    │ Vector DB  │    │ Local LLM  │
       └────────────┘    └─────┬──────┘    └────────────┘
                               │
                               ▼
                    Sentence-Transformers
                         Embeddings
```

---

# 🛠️ Tech Stack

| Component        | Technology            | Purpose                     |
| ---------------- | --------------------- | --------------------------- |
| Language         | Python                | Application development     |
| Backend          | FastAPI               | REST API                    |
| Server           | Uvicorn               | ASGI application server     |
| Frontend         | Streamlit             | Interactive web interface   |
| Database         | MongoDB               | Persistent application data |
| Vector Search    | FAISS                 | Semantic similarity search  |
| Embeddings       | Sentence-Transformers | Text vectorization          |
| LLM              | Ollama + Phi-3 Mini   | Local AI generation         |
| PDF Processing   | PyPDF2                | Syllabus text extraction    |
| Configuration    | `.env`                | Environment configuration   |
| Containerization | Docker Compose        | Service orchestration       |

The documented stack specifies FastAPI/Uvicorn, Streamlit, MongoDB, FAISS, Ollama with `phi3:mini`, and Sentence-Transformers.

---

# 🔄 Application Workflow

## 1️⃣ Upload Syllabus

```text
Faculty
   ↓
Upload PDF
   ↓
Extract Text
   ↓
Chunk Content
   ↓
Generate Embeddings
   ↓
Create FAISS Index
   ↓
Store Metadata in MongoDB
```

The uploaded syllabus becomes the knowledge source for subsequent AI generation.

---

## 2️⃣ Generate Lesson Plan

```text
Select Syllabus
       ↓
Enter Topic
       ↓
Retrieve Relevant Chunks
       ↓
Build RAG Context
       ↓
Ollama LLM
       ↓
Structured Lesson Plan
```

Example topic:

```text
Fourier Transform
```

The system retrieves relevant syllabus information before asking the local LLM to generate the lesson plan.

---

## 3️⃣ Generate Exam Questions

```text
Select Syllabus
       ↓
Select Topic
       ↓
Specify Question Count
       ↓
Retrieve Syllabus Context
       ↓
AI Question Generation
       ↓
MCQ / Short / Long Questions
       ↓
Difficulty Classification
```

---

## 4️⃣ View History

Faculty can access previously stored:

* Uploaded syllabi
* Generated lesson plans
* Generated questions

This allows previously generated educational content to be reused.

---

# 📁 Project Structure

```text
skillsketch/
│
├── fastapi_backend/
│   ├── main.py
│   └── requirements.txt
│
├── frontend/
│   ├── app.py
│   └── requirements.txt
│
├── tests/
│   ├── api_test.py
│   └── upload_test.py
│
├── scripts/
│   ├── find_ollama.ps1
│   ├── check_user_ollama.ps1
│   └── probe_ollama_paths.ps1
│
├── data/
│   ├── uploads/
│   ├── syllabi.json
│   ├── lesson_plans.json
│   └── questions.json
│
├── .env.example
├── .gitignore
├── README.md
├── SETUP_GUIDE.md
├── GETTING_STARTED.md
├── FASTAPI_STARTUP.md
├── IMPLEMENTATION_SUMMARY.md
├── QUICK_REFERENCE.md
├── startup.py
└── verify.py
```

The structure includes separate backend and frontend components, test scripts, Ollama utility scripts, local data storage, and setup documentation.

---

# 🔌 API Endpoints

## Health & Status

```http
GET /api/health/
GET /api/ollama/status/
```

## Syllabus Management

```http
POST   /api/upload-syllabus/
GET    /api/syllabi/
GET    /api/syllabi/{id}/
DELETE /api/syllabi/{id}/
```

## Lesson Plan Generation

```http
POST /api/generate-lesson-plan/
GET  /api/lesson-plans/
GET  /api/lesson-plans/{id}/
```

## Exam Question Generation

```http
POST /api/generate-exam-questions/
```

These endpoints are documented in the project's API specification.

---

# 💻 Quick Start

## Prerequisites

Make sure the following are installed:

* Python
* MongoDB
* Ollama
* Git

---

## 1. Clone the Repository

```powershell
git clone https://github.com/Abhiraami27/SkillSketch.git
cd SkillSketch
```

> Replace the repository URL if your GitHub repository uses a different name.

---

## 2. Create Virtual Environment

```powershell
python -m venv .venv
```

Activate it:

```powershell
.\.venv\Scripts\Activate.ps1
```

---

## 3. Configure Environment

```powershell
copy .env.example .env
```

Open `.env` and configure the required values.

---

## 4. Install MongoDB

Install and start MongoDB locally.

The project documentation uses:

```text
localhost:27017
```

for the local MongoDB instance.

---

## 5. Install Ollama

Install Ollama and download the required model:

```powershell
ollama pull phi3:mini
```

Verify:

```powershell
ollama ls
```

---

# ▶️ Start the Backend

Open a terminal:

```powershell
cd fastapi_backend
python -m pip install -r requirements.txt
python -m uvicorn main:app --host 127.0.0.1 --port 8000 --reload
```

Backend:

```text
http://localhost:8000
```

Swagger API documentation:

```text
http://localhost:8000/docs
```

---

# 🖥️ Start the Frontend

Open another terminal:

```powershell
cd frontend
python -m pip install -r requirements.txt
streamlit run app.py
```

Open:

```text
http://localhost:8501
```

The documented local setup uses port **8000** for FastAPI and **8501** for Streamlit.

---

# 🧪 API Examples

## Upload Syllabus

```bash
curl -X POST http://localhost:8000/api/upload-syllabus/ \
  -F "file=@syllabus.pdf" \
  -F "course_name=Digital Signal Processing"
```

---

## Generate Lesson Plan

```bash
curl -X POST http://localhost:8000/api/generate-lesson-plan/ \
  -H "Content-Type: application/json" \
  -d '{
    "syllabus_id": "SYLLABUS_ID_HERE",
    "topic": "Fourier Transform",
    "subject_type": "theory"
  }'
```

---

## Generate Exam Questions

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

# 🧪 Testing

Integration tests can be executed using:

```powershell
python tests/api_test.py
```

Additional upload testing:

```powershell
python tests/upload_test.py
```

Health check:

```powershell
curl http://localhost:8000/api/health/
```

Ollama status:

```powershell
curl http://localhost:8000/api/ollama/status/
```

The repository includes dedicated API and upload test scripts.

---

# 📊 Expected Performance

| Operation               |       Expected Time |
| ----------------------- | ------------------: |
| PDF Upload — 10 pages   |            5–10 sec |
| Embedding Creation      | 2–3 sec / 50 chunks |
| Lesson Plan Generation  |           20–60 sec |
| Subsequent Lesson Plans |            5–15 sec |
| Question Generation     |           25–70 sec |

Actual performance depends on the machine, model loading time, syllabus size, and question count.

---

# 🔐 Security & Privacy

Before deploying the application beyond a local development environment:

* Change default credentials
* Keep secrets inside `.env`
* Set `DEBUG=False`
* Generate a secure `SECRET_KEY`
* Enable HTTPS
* Restrict CORS origins
* Configure regular MongoDB backups
* Monitor application logs

The project documentation specifically recommends these production hardening steps.

---

# 🧠 Why RAG?

Traditional generative AI can produce answers based on general model knowledge.

SkillSketch instead follows a **retrieval-first approach**:

```text
                  Traditional AI

             User Topic
                  ↓
               LLM
                  ↓
             AI Response
```

SkillSketch:

```text
             User Topic
                  ↓
          Search Syllabus
                  ↓
           FAISS Retrieval
                  ↓
        Relevant Context
                  ↓
             Ollama LLM
                  ↓
        Syllabus-Grounded
             Response
```

This architecture makes the generated lesson plans and questions specifically informed by the uploaded course syllabus.

---

# 🎯 Educational Use Case

SkillSketch is designed to support engineering faculty in:

```text
Course Syllabus
      │
      ├──► Lesson Planning
      │
      ├──► Learning Objectives
      │
      ├──► Teaching Methodologies
      │
      ├──► Activity-Based Learning
      │
      ├──► Lab Ideas
      │
      └──► Exam Question Generation
```

The system therefore combines **education technology + RAG + local LLM inference** into one workflow.

---

# 🔮 Future Enhancements

The documented roadmap includes:

* [ ] Course Outcome → Program Outcome mapping
* [ ] UN Sustainable Development Goals alignment
* [ ] Multi-LLM support
* [ ] User authentication and role management
* [ ] Batch processing
* [ ] GIFT export
* [ ] IMS-QTI export
* [ ] Performance analytics dashboard

---

# 📚 Documentation

Additional project documentation:

| Document                    | Description                        |
| --------------------------- | ---------------------------------- |
| `SETUP_GUIDE.md`            | Complete setup and troubleshooting |
| `GETTING_STARTED.md`        | Quick-start instructions           |
| `FASTAPI_STARTUP.md`        | FastAPI-specific instructions      |
| `IMPLEMENTATION_SUMMARY.md` | Feature and architecture summary   |
| `QUICK_REFERENCE.md`        | Quick reference guide              |

---

# 🤝 Contributing

Contributions are welcome.

```text
1. Fork the repository
2. Create a feature branch
3. Implement your changes
4. Run the available tests
5. Commit your changes
6. Push the branch
7. Create a Pull Request
```

---

# 📜 License

A specific open-source license should be selected and added to the repository before publishing this project for external reuse.

---

# 👩‍💻 Author

**Abhiraami SP**

Integrated M.Tech — Computer Science and Engineering
Sri Ramakrishna Engineering College

### Areas of Interest

* Artificial Intelligence
* Machine Learning
* Generative AI
* Retrieval-Augmented Generation
* Web Development
* Educational Technology

---

# ⭐ Project Highlights

```text
🎓 AI-Powered Education
🧠 Retrieval-Augmented Generation
📄 PDF Syllabus Intelligence
📚 Automated Lesson Planning
❓ AI Exam Question Generation
🔎 FAISS Semantic Retrieval
🤖 Local Ollama LLM
⚡ FastAPI Backend
🖥️ Streamlit Interface
🍃 MongoDB Persistence
🔒 Local & Privacy-Focused AI
```

---

## 🎓 SkillSketch

**Turning course syllabi into intelligent, structured teaching resources with RAG and local AI.**

> **SkillSketch v1.0 — Local AI-Powered Education Technology**
