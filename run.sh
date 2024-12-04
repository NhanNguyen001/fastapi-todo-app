#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 [dev|prod|clean]"
    echo "  dev   - Run in development mode with uvicorn"
    echo "  prod  - Run in production mode with gunicorn"
    echo "  clean - Remove __pycache__ directories"
    exit 1
}

# Check if argument is provided
if [ $# -eq 0 ]; then
    usage
fi

# Function to clean __pycache__ directories
clean_pycache() {
    echo "Cleaning __pycache__ directories..."
    find . -type d -name "__pycache__" -exec rm -r {} +
    find . -type f -name "*.pyc" -delete
    find . -type f -name "*.pyo" -delete
    find . -type f -name "*.pyd" -delete
    echo "Cleanup completed."
}

# Prevent Python from generating __pycache__
export PYTHONDONTWRITEBYTECODE=1

# Activate virtual environment if it exists
if [ -d "venv" ]; then
    source venv/bin/activate
fi

case "$1" in
    dev)
        echo "Starting development server..."
        clean_pycache
        python -B -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
        ;;
    prod)
        echo "Starting production server..."
        clean_pycache
        python -B -m gunicorn main:app -c gunicorn.conf.py
        ;;
    clean)
        clean_pycache
        ;;
    *)
        usage
        ;;
esac 