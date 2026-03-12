# Placeholder module for Redis caching (Phase 2)

import os


class RedisCache:
    def __init__(self):
        # in a real deployment you'd connect to Redis using environment vars
        self.url = os.environ.get("REDIS_URL", "redis://localhost:6379/0")
        # dummy store
        self._store = {}

    def get(self, key):
        return self._store.get(key)

    def set(self, key, value, expire_seconds=None):
        self._store[key] = value
        # ignore expiration in this stub

    def clear(self):
        self._store.clear()
