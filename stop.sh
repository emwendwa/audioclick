#!/bin/bash
# AudioClick - Stop Script

echo "Stopping AudioClick..."
pkill -f "uvicorn main:app" || true
pkill -f "celery" || true
echo "✓ Stopped"
