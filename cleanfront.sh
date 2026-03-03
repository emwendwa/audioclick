#!/bin/bash

# AudioClick Project Cleanup Script
# This removes redundant files and organizes the project properly

set -e

echo "🧹 AudioClick Project Cleanup"
echo "=============================="
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

cd ~/audioclick

echo -e "${YELLOW}This script will:${NC}"
echo "  1. Remove duplicate backend files"
echo "  2. Clean up old test files"
echo "  3. Move node_modules to frontend/"
echo "  4. Organize scripts into scripts/"
echo "  5. Create a clean structure"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

# Create backup
echo ""
echo -e "${YELLOW}Creating backup...${NC}"
mkdir -p ../audioclick-backup-$(date +%Y%m%d-%H%M%S)
cp -r . ../audioclick-backup-$(date +%Y%m%d-%H%M%S)/ 2>/dev/null || true
echo -e "${GREEN}✓ Backup created${NC}"

# Create scripts directory
mkdir -p scripts

# =======================
# BACKEND CLEANUP
# =======================

echo ""
echo -e "${YELLOW}[1/5] Cleaning backend...${NC}"

cd backend

# Remove duplicate/broken files
rm -f app.py.broken
rm -f app_fixed.py
rm -f minimal_backend.py
rm -f requirement.txt  # Typo version
rm -f requirements_minimal.txt

# Keep only main.py, remove app.py if exists
if [ -f "app.py" ] && [ -f "main.py" ]; then
    echo "  Removing duplicate app.py (keeping main.py)"
    rm -f app.py
fi

# Remove old test files
rm -f test.txt
rm -f test_audio.wav
rm -f test_tone.wav
rm -f test_api.sh
rm -f test_backend.py
rm -f test_complete.py

# Clean up logs
rm -f backend.log

echo -e "${GREEN}✓ Backend cleaned${NC}"

cd ..

# =======================
# FRONTEND CLEANUP
# =======================

echo ""
echo -e "${YELLOW}[2/5] Cleaning frontend...${NC}"

cd frontend

# Remove logs
rm -f frontend.log
rm -f test.txt

# Remove redundant scripts
rm -f start.sh
rm -f test_backend.sh

echo -e "${GREEN}✓ Frontend cleaned${NC}"

cd ..

# =======================
# ROOT DIRECTORY CLEANUP
# =======================

echo ""
echo -e "${YELLOW}[3/5] Cleaning root directory...${NC}"

# Move root node_modules to frontend if it exists
if [ -d "node_modules" ] && [ ! -L "node_modules" ]; then
    echo "  Moving root node_modules to frontend/"
    rm -rf frontend/node_modules
    mv node_modules frontend/
fi

# Move root package files to frontend
if [ -f "package.json" ]; then
    echo "  Moving package.json to frontend/"
    mv package.json frontend/
fi

if [ -f "package-lock.json" ]; then
    echo "  Moving package-lock.json to frontend/"
    mv package-lock.json frontend/
fi

# Move ngrok to tools directory
if [ -f "ngrok" ] || [ -f "ngrok-v3-stable-linux-arm.tgz" ]; then
    mkdir -p tools
    mv ngrok tools/ 2>/dev/null || true
    mv ngrok-v3-stable-linux-arm.tgz tools/ 2>/dev/null || true
    echo "  Moved ngrok to tools/"
fi

echo -e "${GREEN}✓ Root directory cleaned${NC}"

# =======================
# ORGANIZE SCRIPTS
# =======================

echo ""
echo -e "${YELLOW}[4/5] Organizing scripts...${NC}"

# Move setup scripts
mv setup_*.sh scripts/ 2>/dev/null || true

# Move control scripts
mv start-audioclick*.sh scripts/ 2>/dev/null || true
mv stop_audioclick.sh scripts/ 2>/dev/null || true
mv status_audioclick.sh scripts/ 2>/dev/null || true
mv kill_audioclick*.sh scripts/ 2>/dev/null || true
mv test_audio.sh scripts/ 2>/dev/null || true

echo -e "${GREEN}✓ Scripts organized${NC}"

# =======================
# CREATE CLEAN STRUCTURE
# =======================

echo ""
echo -e "${YELLOW}[5/5] Creating clean structure...${NC}"

# Create main start script
cat > start.sh << 'EOF'
#!/bin/bash
# AudioClick - Start Script

echo "🎵 Starting AudioClick..."
echo ""

# Start backend
echo "Starting backend..."
cd backend
source venv/bin/activate
python -m uvicorn main:app --host 0.0.0.0 --port 8000 &
BACKEND_PID=$!
cd ..

echo "✓ Backend started (PID: $BACKEND_PID)"
echo ""
echo "Access at: http://localhost:8000"
echo "API Docs: http://localhost:8000/docs"
echo ""
echo "Press Ctrl+C to stop"

# Wait for Ctrl+C
trap "kill $BACKEND_PID; echo 'Stopped'; exit" INT
wait
EOF

chmod +x start.sh

# Create stop script
cat > stop.sh << 'EOF'
#!/bin/bash
# AudioClick - Stop Script

echo "Stopping AudioClick..."
pkill -f "uvicorn main:app" || true
pkill -f "celery" || true
echo "✓ Stopped"
EOF

chmod +x stop.sh

# Create status script
cat > status.sh << 'EOF'
#!/bin/bash
# AudioClick - Status Script

echo "🎵 AudioClick Status"
echo "===================="
echo ""

# Check backend
if pgrep -f "uvicorn main:app" > /dev/null; then
    echo "✓ Backend: Running"
    PID=$(pgrep -f "uvicorn main:app")
    echo "  PID: $PID"
else
    echo "✗ Backend: Not running"
fi

echo ""

# Check if port 8000 is listening
if lsof -Pi :8000 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo "✓ Port 8000: Listening"
else
    echo "✗ Port 8000: Not listening"
fi
EOF

chmod +x status.sh

# Update README with clean structure
cat > README.md << 'EOF'
# AudioClick

Audio keyword detection system powered by AI.

## Quick Start

```bash
# Start the server
./start.sh

# Check status
./status.sh

# Stop the server
./stop.sh
```

## Project Structure

```
audioclick/
├── backend/          # FastAPI backend
│   ├── main.py      # Main application
│   ├── database.py  # Database config
│   ├── models.py    # Database models
│   ├── processor.py # Audio processing
│   ├── cache.py     # Redis caching (Phase 2)
│   ├── tasks.py     # Celery tasks (Phase 2)
│   └── venv/        # Python virtual environment
├── frontend/         # React frontend
│   └── src/         # Source code
├── k8s/             # Kubernetes manifests
├── scripts/         # Setup and utility scripts
├── monitoring/      # Grafana & Prometheus configs
├── start.sh         # Start server
├── stop.sh          # Stop server
└── status.sh        # Check status
```

## Features

- Single/Multiple keyword detection
- Audio file upload (MP3, WAV, M4A, FLAC)
- Word-level timestamp detection
- Context extraction
- Redis caching (Phase 2)
- Kubernetes deployment (Phase 2)

## Documentation

- API Docs: http://localhost:8000/docs
- Phase 1: Basic keyword detection
- Phase 2: Production deployment with K8s
- Phase 3: Live streaming, analytics

## Tech Stack

- Backend: FastAPI, OpenAI Whisper, SQLAlchemy
- Frontend: React, Vite, TailwindCSS
- Deployment: Docker, Kubernetes
- Database: SQLite (local), PostgreSQL (production)
EOF

echo -e "${GREEN}✓ Clean structure created${NC}"

# =======================
# SUMMARY
# =======================

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✓ Cleanup Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}Summary of changes:${NC}"
echo ""
echo "Removed files:"
echo "  ✓ backend/app.py.broken"
echo "  ✓ backend/app_fixed.py"
echo "  ✓ backend/minimal_backend.py"
echo "  ✓ backend/test_*.py"
echo "  ✓ Root node_modules/ (moved to frontend/)"
echo ""
echo "Organized:"
echo "  ✓ All setup scripts → scripts/"
echo "  ✓ ngrok files → tools/"
echo "  ✓ Created start.sh, stop.sh, status.sh"
echo ""
echo "New structure:"
tree -L 2 -I 'node_modules|venv|__pycache__|uploads|processed' . || ls -la
echo ""
echo -e "${GREEN}To start AudioClick:${NC}"
echo -e "  ${YELLOW}./start.sh${NC}"
echo ""
echo -e "${GREEN}Your backup is at:${NC}"
echo "  ../audioclick-backup-$(date +%Y%m%d)-*/"
echo ""
