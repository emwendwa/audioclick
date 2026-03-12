# AudioClick

Audio keyword detection system powered by AI.

## Quick Start

The `start.sh` script now brings up both backend and frontend when possible. Ensure you have Python and Node installed.

```bash
# Install dependencies
cd backend && python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt
cd ../frontend && npm install
cd ..

# Start the server (backend listens on port 5001 by default; frontend will also be launched if Node is installed)
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
│   ├── main.py      # Main application (runs on port 5001 by default)
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

- API Docs: http://localhost:5001/docs
- Phase 1: Basic keyword detection
- Phase 2: Production deployment with K8s
- Phase 3: Live streaming, analytics

## Docker / Compose

To bring up the full stack including PostgreSQL, backend, and frontend containers:

```bash
docker-compose up --build
```

The backend will be reachable on **http://localhost:5001** and the frontend on **http://localhost:3000** (or 5173 if you run `npm run dev` locally).

## Tech Stack

- Backend: FastAPI, OpenAI Whisper, SQLAlchemy
- Frontend: React, Vite, TailwindCSS
- Deployment: Docker, Kubernetes
- Database: SQLite (local), PostgreSQL (production)
