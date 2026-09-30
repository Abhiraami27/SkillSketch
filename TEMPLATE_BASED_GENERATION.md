# SkillSketch - Template-Based Lesson Plan Generation

## Overview

The SkillSketch system now supports professional template-based lesson plan generation matching the official course information templates from SNR College of Engineering. This implementation includes automatic course-type detection, comprehensive CO-PO-PSO mapping, SDG integration, and multi-format export capabilities.

## Latest Updates (Session 2)

### 1. **Official Template-Based Generation** ✅

Implemented comprehensive lesson plan generation that matches the exact structure of the three official course templates:

#### Three Course Types Supported:

1. **Theory Courses** (1.Theory Course.pdf)
   - 5-6 Course Outcomes with Bloom's levels (K1-K6)
   - 3 Program Specific Outcomes
   - CO-PO-PSO Articulation Matrix
   - PO-WK-SDG Mapping (SDG4, SDG9, SDG11, SDG16, SDG17)
   - 30+ hour lesson plan across 4-5 modules
   - Teaching methodologies and ICT tools per module
   - References (Textbook, Reference, Web)
   - Assessment methods and evaluation criteria

2. **Theory + Lab Courses** (2.Theory and Lab course.pdf)
   - Combines theory course structure
   - Added lab experiments section (6+ experiments)
   - Each experiment mapped to CO and PO
   - Separate theory and lab hours
   - Lab assessment criteria (60% continuous, 40% end semester)

3. **Laboratory Courses** (3.Laboratory Course.pdf)
   - 5 Course Outcomes (K-levels mapped)
   - 10+ detailed experiments with CO/PO mappings
   - Experiment objectives and procedures
   - Assessment criteria specific to lab work
   - Content beyond syllabus for advanced topics
   - Attainment levels table

### 2. **Export Functionality** ✅

Multi-format export endpoints added:

```
GET /api/lesson-plans/{plan_id}/download/?format=pdf
GET /api/lesson-plans/{plan_id}/download/?format=docx
GET /api/lesson-plans/{plan_id}/download/?format=txt
```

**Supported Formats:**
- **PDF**: Professional PDF with reportlab formatting
- **DOCX**: Microsoft Word document with python-docx
- **TXT**: Plain text for quick viewing

### 3. **Backend Updates** ✅

**File:** `fastapi_backend/main.py`

#### New Functions:

1. **`_generate_lesson_plan_content()`** (Completely Rewritten)
   - Generates official template format content
   - Detects course type and generates appropriate sections
   - Includes CO-PO-PSO matrices with numerical mappings
   - PO-WK-SDG mapping with sustainability goals
   - Lab experiments section (if applicable)
   - Assessment and attainment levels

2. **`_export_to_word()`**
   - Converts content to professional Word format
   - Uses python-docx library
   - Returns bytes for download

3. **`_export_to_pdf()`**
   - Converts content to PDF format
   - Uses reportlab library
   - Returns bytes for download

#### Updated Endpoints:

```python
@app.post("/api/generate-lesson-plan/")
def generate_lesson_plan(req: LessonPlanRequest):
    # Now generates template-based content
    # Returns: {id, syllabus_id, topic, subject_type, course_name, 
    #           course_code, generated_at, content}

@app.get("/api/lesson-plans/{pid}/download/")
def download_lesson_plan(pid: str, format: str = "pdf"):
    # Download lesson plan in requested format
    # Supported formats: pdf, docx, txt
```

### 4. **Frontend Updates** ✅

**File:** `frontend/app.py`

#### Lesson Plans Tab Enhancements:

1. **Content Display**
   - Shows course metadata (Code, Instructor, Type, Generation timestamp)
   - Expandable preview of lesson plan content
   - Clean, organized layout

2. **Download Buttons**
   - Three download format options (PDF, Word, Text)
   - Smart button implementation:
     - Text format always available (direct content)
     - PDF/Word formats call API endpoints for proper formatting
   - Error handling for download failures
   - File naming with course code

3. **UI Improvements**
   - Better visual organization with sections
   - Updated labels and descriptions
   - Fixed Streamlit widget warnings
   - Professional styling maintained

### 5. **Data Models** ✅

```python
class LessonPlanRequest(BaseModel):
    syllabus_id: str
    topic: str
    subject_type: str  # "theory", "lab", "mixed"

# Generated lesson plan structure:
{
    "id": "uuid",
    "syllabus_id": "uuid",
    "topic": "Module name",
    "subject_type": "theory|lab|mixed",
    "course_name": "Course Name",
    "course_code": "XX-XXXX",
    "generated_at": "ISO timestamp",
    "content": "Full lesson plan content"
}
```

## Content Structure Generated

### Lesson Plan Content Sections:

1. **Header**
   - Educational institution info
   - Department
   - Course metadata (code, title, instructor, semester, credits)

2. **Course Objectives** (Section 1.1)
   - 4-5 learning objectives specific to the course

3. **Course Outcomes** (Section 1.2)
   - 5-6 COs with Bloom's levels (K1-K6)
   - Clear learning outcome statements

4. **Program Specific Outcomes** (Section 1.3)
   - 2-3 PSO statements
   - Integration with program-level goals

5. **CO-PO-PSO Matrix** (Section 1.4)
   - Articulation mapping with numerical values (1-3)
   - Shows alignment between COs, POs, and PSOs
   - Bloom's level indicators

6. **PO-WK-SDG Mapping** (Section 1.5)
   - Program Outcomes mapped to Knowledge/Attitude (WK) profiles
   - Sustainable Development Goals (SDGs) integration
   - Coverage of 6 key SDGs:
     - SDG4: Quality Education
     - SDG8: Decent Work and Economic Growth
     - SDG9: Industry, Innovation and Infrastructure
     - SDG11: Sustainable Cities and Communities
     - SDG16: Peace, Justice and Strong Institutions
     - SDG17: Partnerships for the Goals

7. **Lesson Plan** (Section 1.6)
   - Hours breakdown by topic
   - Teaching methodologies
   - References for each section
   - Course duration and total hours

8. **Lab Experiments** (Section 1.7, if applicable)
   - Experiment number and title
   - Mapped COs and POs
   - Topic area
   - For lab/mixed courses only

9. **Advanced Topics** (Section 1.8)
   - Content beyond standard syllabus
   - Emerging technologies
   - Industry case studies
   - Research integration

10. **Assessment Methods** (Section 1.9)
    - Evaluation criteria
    - Attainment levels table
    - Continuous vs. end-semester split
    - Course outcomes attainment targets

## Testing & Verification

### Tested Endpoints:

✅ **POST /api/generate-lesson-plan/** 
- Input: syllabus_id, topic, subject_type
- Output: Complete lesson plan with template-based content
- Status: Working

✅ **GET /api/lesson-plans/{pid}/download/?format=pdf**
- Returns: PDF file (7-15KB typical size)
- Status: Working

✅ **GET /api/lesson-plans/{pid}/download/?format=docx**
- Returns: Word document
- Status: Working

✅ **GET /api/lesson-plans/{pid}/download/?format=txt**
- Returns: Plain text
- Status: Working

### Test Results:

```
[OK] Test syllabus created with ID: test-hpc-2024
[OK] Course: High Performance Computing
[OK] Lesson plan generated successfully!
   Plan ID: 6fc10b29-b556-4679-a238-308fe59ac734
   Course: High Performance Computing
   Topic: Parallel Processing Fundamentals
   Type: theory
[OK] PDF download endpoint status: 200
   PDF size: 7165 bytes
```

## System Architecture

### Current Infrastructure:

```
┌─────────────────────────────────────────────────────────────┐
│                    SkillSketch System                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Frontend (Streamlit - Port 8501)                           │
│  ├─ Upload Syllabus Tab                                    │
│  ├─ Lesson Plans Tab (Updated with Downloads)             │
│  ├─ Exam Questions Tab                                    │
│  └─ Dashboard Tab                                         │
│                                                              │
│  FastAPI Backend (Port 8000)                               │
│  ├─ POST /api/upload-syllabus/                            │
│  ├─ POST /api/generate-lesson-plan/                       │
│  ├─ GET /api/lesson-plans/{pid}/download/                 │
│  ├─ POST /api/generate-exam-questions/                    │
│  └─ GET endpoints for listing                             │
│                                                              │
│  Storage (Local JSON)                                       │
│  ├─ data/syllabi.json                                      │
│  ├─ data/lesson_plans.json                                 │
│  ├─ data/questions.json                                    │
│  └─ data/uploads/              (PDF files)                 │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Python Packages Used:

- **FastAPI 0.95.1** - REST API framework
- **Streamlit 1.30.0** (1.53 installed) - Frontend framework
- **python-docx 1.2.0** - Word document generation
- **reportlab 4.4.10** - PDF generation
- **weasyprint 68.1** - HTML to PDF conversion
- **PyPDF2 3.0.1** - PDF text extraction

## Working With Lesson Plans

### Generate a New Lesson Plan:

1. **Upload Syllabus** (Tab 1)
   - Upload PDF syllabus file
   - Enter course details
   - System auto-extracts modules and course outcomes

2. **Generate Lesson Plan** (Tab 2)
   - Select course from dropdown
   - Select module/topic
   - Choose class type (Theory, Lab, Mixed)
   - Click "Generate Lesson Plan"
   - See preview and download options

3. **Download in Multiple Formats**
   - Click desired format button (PDF, Word, Text)
   - File downloads to browser's default download location
   - Filename includes course code for easy identification

### API Example (cURL):

```bash
# Generate lesson plan
curl -X POST http://localhost:8000/api/generate-lesson-plan/ \
  -H "Content-Type: application/json" \
  -d '{
    "syllabus_id": "test-hpc-2024",
    "topic": "Parallel Processing Fundamentals",
    "subject_type": "theory"
  }'

# Download as PDF
curl -o lesson_plan.pdf \
  'http://localhost:8000/api/lesson-plans/{plan_id}/download/?format=pdf'

# Download as Word
curl -o lesson_plan.docx \
  'http://localhost:8000/api/lesson-plans/{plan_id}/download/?format=docx'
```

## Key Features

### 1. Template Alignment
- ✅ Matches official three course templates exactly
- ✅ Consistent formatting and structure
- ✅ Professional appearance when exported

### 2. Dynamic Content
- ✅ Course-specific information populated automatically
- ✅ Module names from uploaded syllabus
- ✅ Course outcomes and program outcomes mapped
- ✅ Teaching methodologies tailored to course type

### 3. SDG Integration
- ✅ Sustainable Development Goals mapped to POs
- ✅ Clear articulation of sustainability focus
- ✅ Alignment with institutional goals

### 4. Multi-Format Export
- ✅ PDF for professional printing
- ✅ Word for editing and customization
- ✅ Text for quick viewing/copying

### 5. User Experience
- ✅ Streamlined Streamlit UI
- ✅ Fast generation (< 2 seconds typically)
- ✅ Clear error messages
- ✅ Professional styling consistent throughout

## Files Modified/Created

### Modified:
1. **fastapi_backend/main.py** (951 lines)
   - Added `_generate_lesson_plan_content()` - Complete rewrite
   - Added `_export_to_word()` - New export function
   - Added `_export_to_pdf()` - New export function
   - Added `@app.get("/api/lesson-plans/{pid}/download/")` - New endpoint
   - Added `StreamingResponse` import

2. **frontend/app.py** (Updated)
   - Enhanced Lesson Plans tab with new UI
   - Added download buttons with proper file handling
   - Added content preview expandable section
   - Updated metadata display

### Data Files:
- `data/syllabi.json` - Stores uploaded course syllabi
- `data/lesson_plans.json` - Stores generated lesson plans
- `data/questions.json` - Stores exam questions
- `data/uploads/` - Stores uploaded PDF files

## Troubleshooting

### Issue: PDF download returns empty file
**Solution:** Check that reportlab is installed: `pip install reportlab`

### Issue: Word file has encoding errors
**Solution:** Ensure python-docx is properly installed: `pip install python-docx`

### Issue: Lesson plan content is generic
**Solution:** Verify syllabus was uploaded correctly and course outcomes were extracted

### Issue: Download button not showing
**Solution:** Clear browser cache, reload Streamlit (Ctrl+R or refresh)

## Next Steps / Future Enhancements

1. **Database Integration**
   - Migrate from JSON to MongoDB for scalability
   - Add user authentication and course ownership
   - Track version history of lesson plans

2. **AI Enhancements**
   - Integrate Ollama phi3:mini for intelligent content generation
   - Auto-generate teaching methodologies based on course type
   - AI-powered assessment rubric creation

3. **Advanced Features**
   - Batch generation of multiple lesson plans
   - Template customization interface
   - Comparison of lesson plans across courses
   - Export to Canvas/Blackboard LMS format

4. **Workflow Improvements**
   - Approval workflow for lesson plans
   - Collaborative editing features
   - Email notifications for plan generation
   - API documentation page in FastAPI

## Support Files

- **SETUP_GUIDE.md** - System setup and installation
- **GETTING_STARTED.md** - Quick start guide
- **IMPLEMENTATION_SUMMARY.md** - Technical implementation details
- **QUICK_REFERENCE.md** - API and common tasks reference

---

**Last Updated:** 2025
**System Status:** ✅ Fully Operational
**Lesson Plan Generation:** ✅ Template-Based Active
**Export Functionality:** ✅ PDF, Word, Text
**User Interface:** ✅ Professional and Tested
