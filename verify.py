#!/usr/bin/env python3
"""
SkillSketch Local Services Verification Script
Checks if all local services are running and ready
"""

import subprocess
import time
import sys
import requests
from pathlib import Path

def log_success(msg):
    print(f"✓ {msg}")

def log_error(msg):
    print(f"✗ {msg}")

def log_info(msg):
    print(f"ℹ {msg}")

def check_mongodb():
    """Check if MongoDB is running"""
    try:
        result = subprocess.run(
            ['mongosh', '--eval', 'db.adminCommand("ping")'],
            capture_output=True,
            text=True,
            timeout=3
        )
        return result.returncode == 0
    except:
        return False

def check_service(url, name):
    """Check if a service is responding"""
    try:
        response = requests.get(url, timeout=3)
        if response.status_code == 200:
            log_success(f"{name}: {url}")
            return True
        else:
            log_error(f"{name}: Status {response.status_code}")
            return False
    except Exception as e:
        log_error(f"{name}: {str(e)}")
        return False

def main():
    print("\n" + "="*60)
    print("SkillSketch Local Services Verification")
    print("="*60 + "\n")
    
    # Check MongoDB
    print("Checking local services...")
    print()
    
    if check_mongodb():
        log_success("MongoDB is running on localhost:27017")
    else:
        log_error("MongoDB is not running. Start with: Start-Service MongoDB")
    print()
    
    # Check other services
    print("Checking service endpoints...")
    services_ok = 0
    services_total = 0
    
    services = [
        ("http://localhost:8000/api/health/", "FastAPI Backend"),
        ("http://localhost:8000/docs", "FastAPI Docs"),
        ("http://localhost:8501", "Streamlit UI"),
        ("http://localhost:11434/api/tags", "Ollama LLM"),
    ]
    
    for url, name in services:
        services_total += 1
        if check_service(url, name):
            services_ok += 1
        time.sleep(0.5)
    
    print()
    print(f"Services: {services_ok}/{services_total} responding")
    print()
    
    # Check Ollama model
    print("Checking Ollama models...")
    try:
        response = requests.get("http://localhost:11434/api/tags", timeout=3)
        data = response.json()
        models = [m.get('name') for m in data.get('models', [])]
        if models:
            log_success(f"Models found: {', '.join(models)}")
            if any('phi3' in m for m in models):
                log_success("phi3:mini model is ready!")
            else:
                log_error("phi3:mini model not found. Run: ollama pull phi3:mini")
        else:
            log_error("No models found in Ollama")
    except Exception as e:
        log_error(f"Could not check Ollama: {e}")
    
    print()
    print("="*60)
    if services_ok >= 3:  # At least FastAPI, Streamlit, Ollama
        log_success("SkillSketch is ready!")
        print("\nAccess at:")
        print("  • Streamlit UI:   http://localhost:8501")
        print("  • FastAPI Docs:   http://localhost:8000/docs")
        print("  • API Base:       http://localhost:8000/api/")
    else:
        log_error("Some services are not responding. Check:")
        print("  • Is FastAPI running? Terminal 1")
        print("  • Is Streamlit running? Terminal 2")
        print("  • Is Ollama running? Terminal 3 (ollama serve)")
    print("="*60 + "\n")

if __name__ == '__main__':
    main()

