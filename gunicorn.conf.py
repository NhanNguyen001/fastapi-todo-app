# Gunicorn configuration file
import multiprocessing
import os

# Prevent Python from generating __pycache__
os.environ["PYTHONDONTWRITEBYTECODE"] = "1"

# Server socket
bind = "0.0.0.0:8000"
backlog = 2048

# Worker processes
workers = multiprocessing.cpu_count() * 2 + 1
worker_class = "uvicorn.workers.UvicornWorker"
worker_connections = 1000
timeout = 30
keepalive = 2

# Python optimization
pythonoptimize = 2  # Enable Python optimization (-OO)

# Logging
accesslog = "-"
errorlog = "-"
loglevel = "info"

# Process naming
proc_name = "fastapi_todo"

# Server mechanics
daemon = False
pidfile = None
umask = 0
user = None
group = None
tmp_upload_dir = None

# SSL config
# certfile = "/path/to/fullchain.pem"
# keyfile = "/path/to/privkey.pem"
