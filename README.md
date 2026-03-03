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
