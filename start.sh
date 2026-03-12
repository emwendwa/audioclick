#!/bin/bash
# AudioClick - Start Script

echo "🎵 Starting AudioClick..."
echo ""

# Start backend
echo "Starting backend..."
cd backend
# if virtualenv missing, create it and install requirements
if [ ! -d "venv" ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv venv
fi
source venv/bin/activate
if [ -f requirements.txt ]; then
    pip install -r requirements.txt
fi
# allow overriding the port via PORT environment variable; tests expect 5001
PORT=${PORT:-5001}
python main.py &
BACKEND_PID=$!
cd ..

echo "✓ Backend started (PID: $BACKEND_PID)"
echo ""
echo "Access at: http://localhost:$PORT"
echo "API Docs: http://localhost:$PORT/docs"
echo ""
echo "Press Ctrl+C to stop"

# Start frontend if Node is installed and frontend folder exists
if command -v npm >/dev/null 2>&1 && [ -d "frontend" ]; then
    echo "Starting frontend..."
    (cd frontend && npm install && npm run dev) &
    FRONTEND_PID=$!
    echo "✓ Frontend started (PID: $FRONTEND_PID)"
    echo "Available at http://localhost:5173"
fi

# Wait for Ctrl+C
trap "
    kill $BACKEND_PID 2>/dev/null || true;
    kill ${FRONTEND_PID:-} 2>/dev/null || true;
    echo 'Stopped';
    exit
" INT
wait
