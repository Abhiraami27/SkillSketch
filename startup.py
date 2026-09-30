#!/usr/bin/env python
"""
SkillSketch Local Startup Verification Script
Checks all local services and dependencies before running
"""

import os
import subprocess
import sys
import requests
from pathlib import Path

def check_python():
    """Verify Python 3.11+ is installed"""
    print("✓ Checking Python installation...")
    try:
        version = sys.version_info
        if version.major >= 3 and version.minor >= 11:
            print(f"  ✓ Python {version.major}.{version.minor}.{version.micro}")
            return True
        else:
            print(f"  ✗ Python 3.11+ required (found {version.major}.{version.minor})")
            return False
    except Exception as e:
        print(f"  ✗ Error checking Python: {e}")
        return False

def check_mongodb():
    """Verify MongoDB service is running"""
    print("✓ Checking MongoDB...")
    try:
        # Try to connect to MongoDB
        result = subprocess.run(
            ['mongosh', '--eval', 'db.adminCommand("ping")'],
            capture_output=True,
            text=True,
            timeout=5
        )
        if result.returncode == 0:
            print("  ✓ MongoDB is running on localhost:27017")
            return True
        else:
            print("  ✗ MongoDB not accessible. Start with: Start-Service MongoDB")
            return False
    except FileNotFoundError:
        print("  ✗ mongosh not found. Install MongoDB from https://www.mongodb.com/try/download/community")
        return False
    except Exception as e:
        print(f"  ⚠ MongoDB not responding: {e}")
        print("  → Start with: Start-Service MongoDB")
        return False

def check_ollama():
    """Verify Ollama is installed"""
    print("✓ Checking Ollama...")
    try:
        result = subprocess.run(['ollama', '--version'], capture_output=True, text=True)
        if result.returncode == 0:
            print(f"  ✓ {result.stdout.strip()}")
            return True
        else:
            print("  ✗ Ollama not found. Install from https://ollama.ai/")
            return False
    except FileNotFoundError:
        print("  ✗ Ollama not found. Install from https://ollama.ai/")
        return False

def check_ollama_model():
    """Verify phi3:mini model is available"""
    print("✓ Checking phi3:mini model...")
    try:
        result = subprocess.run(['ollama', 'ls'], capture_output=True, text=True)
        if 'phi3:mini' in result.stdout:
            print("  ✓ phi3:mini model is available")
            return True
        else:
            print("  ✗ phi3:mini model not found")
            print("  → Install with: ollama pull phi3:mini")
            return False
    except Exception as e:
        print(f"  ⚠ Could not check models: {e}")
        return False

def check_env_file():
    """Verify .env file exists"""
    print("✓ Checking .env file...")
    if Path('.env').exists():
        print("  ✓ .env file found")
        return True
    else:
        print("  ✗ .env file not found")
        print("  → Create with: cp .env.example .env")
        return False

def check_venvs():
    """Verify Python virtual environments are set up"""
    print("✓ Checking Python virtual environments...")
    venvs = [
        ('fastapi_backend', './fastapi_backend/venv'),
        ('frontend', './frontend/venv')
    ]
    
    all_exist = True
    for name, path in venvs:
        if Path(path).exists():
            print(f"  ✓ {name} venv exists")
        else:
            print(f"  ⚠ {name} venv not found (will be created on startup)")
            all_exist = False
    
    return True  # Not a critical failure; can be created

def run_verification():
    """Run all startup verification checks"""
    print("\n" + "="*60)
    print("SkillSketch Local Startup Verification")
    print("="*60 + "\n")
    
    checks = [
        check_python(),
        check_env_file(),
        check_mongodb(),
        check_ollama(),
        check_ollama_model(),
        check_venvs()
    ]
    
    print("\n" + "="*60)
    
    if not all(checks):
        print("⚠ Some checks failed. Fix issues above before starting.")
        print("\nTo start services manually, use the startup.ps1 script:")
        print("  PowerShell> .\\startup.ps1")
        sys.exit(1)
    
    print("✓ All checks passed!")
    print("="*60 + "\n")
    
    print("Local services ready to start:")
    print("  • FastAPI Backend:   http://localhost:8000")
    print("  • Streamlit UI:      http://localhost:8501")
    print("  • MongoDB:           localhost:27017")
    print("  • Ollama:            localhost:11434")
    print("\nStart with:")
    print("  PowerShell> .\\startup.ps1")
    print("\nOr manually start 3 terminals:")
    print("  Terminal 1: cd fastapi_backend && .\\venv\\Scripts\\Activate.ps1 && python -m uvicorn main:app --reload")
    print("  Terminal 2: cd frontend && .\\venv\\Scripts\\Activate.ps1 && streamlit run app.py")
    print("  Terminal 3: ollama serve")
    print("")

if __name__ == '__main__':
    run_verification()

