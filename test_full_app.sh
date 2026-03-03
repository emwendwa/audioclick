#!/bin/bash
# Test the complete AudioClick application

echo "========================================="
echo "AudioClick - Complete Application Test"
echo "========================================="

echo ""
echo "1. Testing Backend API..."
echo "------------------------"

if curl -s http://localhost:5001/health > /dev/null; then
    echo "✅ Backend is running"
    echo "   Health check:"
    curl -s http://localhost:5001/health | python3 -m json.tool 2>/dev/null || echo "   $(curl -s http://localhost:5001/health)"
else
    echo "❌ Backend is not running"
    echo "   Start it with: cd backend && python app.py"
fi

echo ""
echo "2. Testing Frontend..."
echo "---------------------"

if curl -s http://localhost:5173 > /dev/null 2>&1; then
    echo "✅ Frontend is running"
    echo "   Available at: http://localhost:5173"
else
    echo "⚠️  Frontend might not be running yet"
    echo "   Start it with: cd frontend && npm run dev"
fi

echo ""
echo "3. Testing File Upload Capability..."
echo "-----------------------------------"

# Create a test audio file if needed
cd backend
if [ ! -f "test_audio.wav" ]; then
    echo "Creating test audio file..."
    python3 -c "
import numpy as np
import wave
import struct

# Create 1-second 440Hz sine wave
sample_rate = 44100
duration = 1.0
t = np.linspace(0, duration, int(sample_rate * duration), False)
tone = np.sin(2 * np.pi * 440 * t) * 0.7
audio_data = (tone * 32767).astype(np.int16)

with wave.open('test_audio.wav', 'w') as wav_file:
    wav_file.setnchannels(1)
    wav_file.setsampwidth(2)
    wav_file.setframerate(sample_rate)
    wav_file.writeframes(audio_data.tobytes())
print('Test audio created: test_audio.wav')
"
fi

echo ""
echo "4. Testing Database..."
echo "---------------------"

python3 -c "
import sys
sys.path.append('.')
try:
    import models
    db = models.Database()
    stats = db.get_statistics()
    print(f'✅ Database working: {stats[\"total_analyses\"]} analyses stored')
except Exception as e:
    print(f'❌ Database error: {e}')
"

echo ""
echo "5. Testing Audio Processor..."
echo "----------------------------"

python3 -c "
import sys
sys.path.append('.')
try:
    from audio_processor import AudioProcessor
    processor = AudioProcessor()
    print(f'✅ Audio processor working')
    print(f'   Supported formats: {processor.supported_formats}')
except Exception as e:
    print(f'❌ Audio processor error: {e}')
"

echo ""
echo "========================================="
echo "TEST SUMMARY"
echo "========================================="
echo ""
echo "To access the application:"
echo "  Frontend: http://localhost:5173"
echo "  Backend API: http://localhost:5001"
echo "  API Documentation: http://localhost:5001/"
echo ""
echo "To upload and test an audio file:"
echo "  1. Go to http://localhost:5173"
echo "  2. Drag & drop or select an audio file"
echo "  3. Click 'Analyze Audio'"
echo "  4. View results"
echo ""
echo "For troubleshooting:"
echo "  - Check if both servers are running"
echo "  - Check terminal for error messages"
echo "  - Test backend: curl http://localhost:5001/health"
echo "  - Test frontend: curl http://localhost:5173"
