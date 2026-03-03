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
