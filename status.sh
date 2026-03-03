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
