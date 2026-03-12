from flask import Flask, request, jsonify
import os
from werkzeug.utils import secure_filename

from models import Database
from audio_processor import AudioProcessor

app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 104857600  # 100MB max file size
UPLOAD_DIR = '/tmp'

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

@app.route('/analyze', methods=['POST'])
def analyze():
    # Check if file is in request
    if 'file' not in request.files:
        return jsonify({"error": "No file provided"}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({"error": "No file selected"}), 400
    
    # Validate file type
    ext = os.path.splitext(file.filename)[1].lower().lstrip('.')
    processor = AudioProcessor()
    if ext not in processor.supported_formats:
        return jsonify({"error": f"Unsupported file type: {ext}"}), 400
    
    # Save temp file
    filename = secure_filename(file.filename)
    tmp_path = os.path.join(UPLOAD_DIR, filename)
    file.save(tmp_path)
    
    # Process audio
    result = processor.process(tmp_path)
    
    # Record in database
    db = Database()
    db.record_analysis()
    
    return jsonify(result), 200

if __name__ == '__main__':
    port = int(os.environ.get('PORT', '5001'))
    app.run(host='0.0.0.0', port=port, debug=False)

