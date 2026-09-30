# SkillSketch - API Testing & Examples

## System Status Check

```bash
# Check FastAPI
curl http://localhost:8000/docs
# Should return HTML with Swagger UI

# Check Streamlit  
curl http://localhost:8501
# Should return Streamlit app

# Check health
curl http://localhost:8000/
# Should return {"status": "ok"} or similar
```

## Complete Workflow Example

### 1. Upload Syllabus

```python
import requests
import json

# Create test syllabus data
test_course = {
    "course_name": "High Performance Computing",
    "course_code": "CS-4501",
    "instructor": "Dr. Jane Smith",
    "semester": "7",
    "course_outcomes": [
        {"id": "CO1", "description": "Understand parallel processing fundamentals"},
        {"id": "CO2", "description": "Design parallel algorithms"},
        {"id": "CO3", "description": "Implement GPU-based solutions"},
        {"id": "CO4", "description": "Optimize parallel applications"},
        {"id": "CO5", "description": "Analyze performance metrics"}
    ]
}

# Upload via API (if there's an upload endpoint)
# Or insert directly into database
from pathlib import Path
import sys
sys.path.insert(0, './fastapi_backend')
from main import _load_db, _save_db

SYLLABI_DB = Path('data/syllabi.json')
sdb = _load_db(SYLLABI_DB)
syllabus_id = "cs-4501-2025"
sdb[syllabus_id] = test_course
_save_db(SYLLABI_DB, sdb)
print(f"Syllabus saved with ID: {syllabus_id}")
```

### 2. Generate Lesson Plan

```python
import requests

response = requests.post(
    'http://localhost:8000/api/generate-lesson-plan/',
    json={
        "syllabus_id": "cs-4501-2025",
        "topic": "Parallel Processing Fundamentals",
        "subject_type": "theory"
    },
    timeout=15
)

if response.status_code == 200:
    lesson_plan = response.json()
    plan_id = lesson_plan['id']
    print(f"Lesson plan generated: {plan_id}")
    print(f"Course: {lesson_plan['course_name']}")
    print(f"Content length: {len(lesson_plan['content'])} chars")
    
    # Save for later reference
    with open('last_plan_id.txt', 'w') as f:
        f.write(plan_id)
else:
    print(f"Error: {response.status_code}")
    print(response.text)
```

### 3. Download in Different Formats

```python
import requests

# Read the last plan ID
with open('last_plan_id.txt', 'r') as f:
    plan_id = f.read().strip()

# Download as PDF
print("Downloading PDF...")
pdf_response = requests.get(
    f'http://localhost:8000/api/lesson-plans/{plan_id}/download/?format=pdf',
    timeout=15
)
if pdf_response.status_code == 200:
    with open('lesson_plan.pdf', 'wb') as f:
        f.write(pdf_response.content)
    print(f"PDF saved: lesson_plan.pdf ({len(pdf_response.content)} bytes)")

# Download as Word
print("Downloading Word document...")
docx_response = requests.get(
    f'http://localhost:8000/api/lesson-plans/{plan_id}/download/?format=docx',
    timeout=15
)
if docx_response.status_code == 200:
    with open('lesson_plan.docx', 'wb') as f:
        f.write(docx_response.content)
    print(f"Word saved: lesson_plan.docx ({len(docx_response.content)} bytes)")

# Download as Text
print("Downloading Text...")
txt_response = requests.get(
    f'http://localhost:8000/api/lesson-plans/{plan_id}/download/?format=txt',
    timeout=15
)
if txt_response.status_code == 200:
    with open('lesson_plan.txt', 'w', encoding='utf-8') as f:
        f.write(txt_response.text)
    print(f"Text saved: lesson_plan.txt ({len(txt_response.text)} bytes)")
```

## Full Test Suite

```python
#!/usr/bin/env python3
"""
SkillSketch Complete Testing Suite
Tests all functionality: upload, generation, download
"""

import requests
import json
from pathlib import Path
import time

class SkillSketchTester:
    def __init__(self, api_url="http://localhost:8000"):
        self.api_url = api_url
        self.test_results = []
        
    def log_test(self, name, status, details=""):
        """Log test result"""
        result = f"[{'PASS' if status else 'FAIL'}] {name}"
        if details:
            result += f" - {details}"
        print(result)
        self.test_results.append((name, status, details))
    
    def test_api_health(self):
        """Test if API is running"""
        try:
            response = requests.get(f"{self.api_url}/docs", timeout=5)
            self.log_test("API Health Check", response.status_code == 200)
            return response.status_code == 200
        except Exception as e:
            self.log_test("API Health Check", False, str(e))
            return False
    
    def test_lesson_plan_generation(self):
        """Test lesson plan generation"""
        try:
            # Create test syllabus
            test_id = "test-course-" + str(int(time.time()))
            test_data = {
                "course_name": "Data Science Fundamentals",
                "course_code": "CS-3201",
                "instructor": "Dr. John Doe",
                "semester": "5",
                "course_outcomes": [
                    {"id": "CO1", "description": "Understand ML concepts"},
                    {"id": "CO2", "description": "Implement algorithms"},
                    {"id": "CO3", "description": "Analyze data patterns"},
                    {"id": "CO4", "description": "Develop models"},
                    {"id": "CO5", "description": "Evaluate performance"}
                ]
            }
            
            # Save to database
            import sys
            sys.path.insert(0, 'fastapi_backend')
            from main import _load_db, _save_db
            
            SYLLABI_DB = Path('data/syllabi.json')
            sdb = _load_db(SYLLABI_DB)
            sdb[test_id] = test_data
            _save_db(SYLLABI_DB, sdb)
            
            # Request lesson plan
            response = requests.post(
                f"{self.api_url}/api/generate-lesson-plan/",
                json={
                    "syllabus_id": test_id,
                    "topic": "Machine Learning Basics",
                    "subject_type": "theory"
                },
                timeout=15
            )
            
            success = response.status_code == 200
            if success:
                plan = response.json()
                details = f"Generated plan {plan.get('id', 'unknown')[:8]}..."
            else:
                details = f"Status {response.status_code}: {response.text[:100]}"
            
            self.log_test("Lesson Plan Generation", success, details)
            return response.json() if success else None
            
        except Exception as e:
            self.log_test("Lesson Plan Generation", False, str(e))
            return None
    
    def test_pdf_download(self, plan_id):
        """Test PDF download endpoint"""
        try:
            response = requests.get(
                f"{self.api_url}/api/lesson-plans/{plan_id}/download/?format=pdf",
                timeout=15
            )
            
            success = response.status_code == 200
            details = f"{len(response.content)} bytes" if success else f"Status {response.status_code}"
            self.log_test("PDF Download", success, details)
            return response.content if success else None
            
        except Exception as e:
            self.log_test("PDF Download", False, str(e))
            return None
    
    def test_docx_download(self, plan_id):
        """Test Word document download endpoint"""
        try:
            response = requests.get(
                f"{self.api_url}/api/lesson-plans/{plan_id}/download/?format=docx",
                timeout=15
            )
            
            success = response.status_code == 200
            details = f"{len(response.content)} bytes" if success else f"Status {response.status_code}"
            self.log_test("Word Download", success, details)
            return response.content if success else None
            
        except Exception as e:
            self.log_test("Word Download", False, str(e))
            return None
    
    def test_list_endpoints(self):
        """Test list endpoints"""
        try:
            # List lesson plans
            response = requests.get(
                f"{self.api_url}/api/lesson-plans/",
                timeout=10
            )
            
            success = response.status_code == 200
            if success:
                data = response.json()
                count = len(data) if isinstance(data, list) else "unknown"
                details = f"Found {count} lesson plans"
            else:
                details = f"Status {response.status_code}"
            
            self.log_test("List Lesson Plans", success, details)
            return success
            
        except Exception as e:
            self.log_test("List Lesson Plans", False, str(e))
            return False
    
    def run_all_tests(self):
        """Run complete test suite"""
        print("\n" + "="*60)
        print("SkillSketch Testing Suite")
        print("="*60 + "\n")
        
        # Health check
        if not self.test_api_health():
            print("\nAPI is not responding. Aborting tests.")
            return False
        
        # Generate lesson plan
        plan = self.test_lesson_plan_generation()
        
        if plan:
            plan_id = plan.get('id')
            
            # Test downloads
            self.test_pdf_download(plan_id)
            self.test_docx_download(plan_id)
        
        # List endpoints
        self.test_list_endpoints()
        
        # Summary
        print("\n" + "="*60)
        passed = sum(1 for _, status, _ in self.test_results if status)
        total = len(self.test_results)
        print(f"Test Summary: {passed}/{total} tests passed")
        print("="*60 + "\n")
        
        return passed == total

if __name__ == "__main__":
    tester = SkillSketchTester()
    tester.run_all_tests()
```

## cURL Examples

### Generate Lesson Plan
```bash
curl -X POST http://localhost:8000/api/generate-lesson-plan/ \
  -H "Content-Type: application/json" \
  -d '{
    "syllabus_id": "cs-4501-2025",
    "topic": "Parallel Processing Fundamentals",
    "subject_type": "theory"
  }' | jq .
```

### Download PDF
```bash
curl -o "lesson_plan.pdf" \
  "http://localhost:8000/api/lesson-plans/{PLAN_ID}/download/?format=pdf"
```

### Download Word
```bash
curl -o "lesson_plan.docx" \
  "http://localhost:8000/api/lesson-plans/{PLAN_ID}/download/?format=docx"
```

### Download Text
```bash
curl -o "lesson_plan.txt" \
  "http://localhost:8000/api/lesson-plans/{PLAN_ID}/download/?format=txt"
```

### List Lesson Plans
```bash
curl http://localhost:8000/api/lesson-plans/ | jq .
```

### Get Single Lesson Plan
```bash
curl "http://localhost:8000/api/lesson-plans/{PLAN_ID}/" | jq .
```

## Response Examples

### Lesson Plan Response
```json
{
  "id": "6fc10b29-b556-4679-a238-308fe59ac734",
  "syllabus_id": "cs-4501-2025",
  "topic": "Parallel Processing Fundamentals",
  "subject_type": "theory",
  "course_name": "High Performance Computing",
  "course_code": "CS-4501",
  "generated_at": "2025-01-15T10:30:45.123Z",
  "content": "====================================...\nCOURSE INFORMATION - OFFICIAL TEMPLATE\n..."
}
```

### Error Response
```json
{
  "detail": "Syllabus not found"
}
```

## Performance Metrics

| Operation | Time | Size |
|-----------|------|------|
| Lesson Plan Generation | < 2 sec | 50-100 KB |
| PDF Export | < 1 sec | 7-15 KB |
| Word Export | < 1 sec | 15-25 KB |
| List Plans | < 0.5 sec | ~10 KB |

## Stress Testing

```python
import requests
import time
from concurrent.futures import ThreadPoolExecutor

def test_concurrent_generation(num_requests=10):
    """Test concurrent lesson plan generation"""
    
    def generate_plan(i):
        try:
            response = requests.post(
                'http://localhost:8000/api/generate-lesson-plan/',
                json={
                    "syllabus_id": f"test-{i}",
                    "topic": f"Topic {i}",
                    "subject_type": "theory"
                },
                timeout=15
            )
            return response.status_code == 200
        except:
            return False
    
    start = time.time()
    with ThreadPoolExecutor(max_workers=5) as executor:
        results = list(executor.map(generate_plan, range(num_requests)))
    elapsed = time.time() - start
    
    success = sum(results)
    print(f"Concurrent Test: {success}/{num_requests} successful in {elapsed:.2f}s")
```

## Expected Output Examples

### Successful Generation
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

### Download Success
```bash
$ curl -o lesson.pdf "http://localhost:8000/api/lesson-plans/abc123/download/?format=pdf"
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7165  100  7165    0     0  71650      0 --:--:-- --:--:-- --:--:--  100
$ ls -lh lesson.pdf
-rw-r--r--  1 user  staff  7.0K Jan 15 10:30 lesson.pdf
```

## Debugging Tips

### Enable Verbose Logging
```python
import logging
logging.basicConfig(level=logging.DEBUG)

# Your requests code here
```

### Test Individual Components
```bash
# Check Python packages
python -c "import fastapi; print(fastapi.__version__)"
python -c "import streamlit; print(streamlit.__version__)"
python -c "import docx; print('python-docx OK')"
python -c "import reportlab; print('reportlab OK')"

# Check file permissions
ls -la data/
stat data/syllabi.json
```

### Monitor Port Usage
```bash
# Windows
netstat -ano | findstr 8000
netstat -ano | findstr 8501

# Linux/Mac
lsof -i :8000
lsof -i :8501
```

---

**Last Updated:** January 2025
**API Version:** 1.0
**Template Version:** Official 2025
