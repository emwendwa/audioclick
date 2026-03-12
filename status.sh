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

# Check if port 5001 is listening (backend default)
if lsof -Pi :5001 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo "✓ Port 5001: Listening"
else
    echo "✗ Port 5001: Not listening"
fi
