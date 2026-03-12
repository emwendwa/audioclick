import os


class AudioProcessor:
    """Simple audio processor that pretends to detect keywords.

    In a full implementation this would call Whisper or another model to
    analyze audio. For now we provide a stubbed interface with a list of
    supported formats and a fake `process` method.
    """

    def __init__(self):
        # supported file extensions
        self.supported_formats = ["wav", "mp3", "flac", "m4a"]

    def process(self, filepath: str) -> dict:
        """Analyze the audio file at `filepath`.

        Returns a dictionary with fake results that mimic keyword detection.
        """
        ext = os.path.splitext(filepath)[1].lower().lstrip(".")
        if ext not in self.supported_formats:
            raise ValueError(f"Unsupported format: {ext}")

        # In a real app, you'd run the model here to obtain word timestamps
        # and context snippets. We'll return a dummy response with a single
        # keyword and a bit of "context" text.
        return {
            "keywords": [
                {
                    "word": "test",
                    "start": 0.5,
                    "end": 0.8,
                    "confidence": 0.99,
                }
            ],
            "duration": 1.0,
            "context": "This is a placeholder context extracted from the audio."
        }
