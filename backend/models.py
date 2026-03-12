import sqlite3
import threading
from typing import Dict


class Database:
    _instance = None
    _lock = threading.Lock()

    def __new__(cls, db_path: str = "audioclick.db"):
        # simple singleton so multiple imports share the same connection
        with cls._lock:
            if cls._instance is None:
                cls._instance = super(Database, cls).__new__(cls)
                cls._instance._init(db_path)
        return cls._instance

    def _init(self, db_path: str):
        self.conn = sqlite3.connect(db_path, check_same_thread=False)
        self._ensure_schema()

    def _ensure_schema(self):
        c = self.conn.cursor()
        c.execute(
            """
            CREATE TABLE IF NOT EXISTS analyses (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
            )
            """
        )
        self.conn.commit()

    def record_analysis(self) -> None:
        c = self.conn.cursor()
        c.execute("INSERT INTO analyses DEFAULT VALUES")
        self.conn.commit()

    def get_statistics(self) -> Dict[str, int]:
        c = self.conn.cursor()
        c.execute("SELECT COUNT(*) FROM analyses")
        total = c.fetchone()[0]
        return {"total_analyses": total}
