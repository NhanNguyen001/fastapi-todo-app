#!/bin/bash

# Function to display usage
usage() {
    echo "Development Task Runner"
    echo
    echo "Usage: $0 [command]"
    echo
    echo "Commands:"
    echo "  setup     - Install all dependencies and setup development environment"
    echo "  format    - Format code with black and isort"
    echo "  lint      - Run linting checks (ruff, flake8)"
    echo "  type      - Run type checking with mypy"
    echo "  test      - Run tests with pytest"
    echo "  coverage  - Generate test coverage report"
    echo "  security  - Run security checks with bandit"
    echo "  check-all - Run all checks (format, lint, type, test, security)"
    echo "  clean     - Remove all generated files"
    echo "  build     - Build the package"
    echo "  help      - Show this help message"
    exit 1
}

# Check if argument is provided
if [ $# -eq 0 ]; then
    usage
fi

# Activate virtual environment if it exists
if [ -d "venv" ]; then
    source venv/bin/activate
fi

# Function to run a command and check its status
run_command() {
    echo "Running: $1"
    eval "$1"
    status=$?
    if [ $status -ne 0 ]; then
        echo "Error: $1 failed"
        exit $status
    fi
    echo "✅ Success: $1"
    echo
}

# Function to clean up generated files
cleanup() {
    echo "Cleaning up generated files..."
    find . -type d -name "__pycache__" -exec rm -r {} +
    find . -type f -name "*.pyc" -delete
    find . -type f -name "*.pyo" -delete
    find . -type f -name "*.pyd" -delete
    find . -type d -name "*.egg-info" -exec rm -r {} +
    find . -type d -name "*.egg" -exec rm -r {} +
    find . -type d -name ".pytest_cache" -exec rm -r {} +
    find . -type d -name ".coverage" -exec rm -r {} +
    find . -type d -name ".mypy_cache" -exec rm -r {} +
    find . -type d -name ".ruff_cache" -exec rm -r {} +
    find . -type d -name "dist" -exec rm -r {} +
    find . -type d -name "build" -exec rm -r {} +
    find . -type f -name "coverage.xml" -delete
    find . -type f -name ".coverage" -delete
    echo "✅ Cleanup complete"
}

case "$1" in
    setup)
        echo "Setting up development environment..."
        run_command "python -m pip install --upgrade pip"
        run_command "pip install -e '.[dev]'"
        run_command "pip install build hatchling ruff"
        ;;
    format)
        echo "Formatting code..."
        run_command "black ."
        run_command "ruff check --fix ."
        ;;
    lint)
        echo "Running linting checks..."
        run_command "ruff check ."
        run_command "flake8 ."
        ;;
    type)
        echo "Running type checks..."
        run_command "mypy ."
        ;;
    test)
        echo "Running tests..."
        run_command "pytest -v"
        ;;
    coverage)
        echo "Generating coverage report..."
        run_command "pytest --cov=./ --cov-report=term-missing --cov-report=xml"
        ;;
    security)
        echo "Running security checks..."
        run_command "bandit -r . -c pyproject.toml"
        run_command "safety check"
        ;;
    check-all)
        echo "Running all checks..."
        run_command "black . --check"
        run_command "ruff check ."
        run_command "flake8 ."
        run_command "mypy ."
        run_command "pytest -v --cov=./ --cov-report=term-missing --cov-report=xml"
        run_command "bandit -r . -c pyproject.toml"
        run_command "safety check"
        ;;
    clean)
        cleanup
        ;;
    build)
        echo "Building package..."
        cleanup
        run_command "python -m build"
        ;;
    help)
        usage
        ;;
    *)
        usage
        ;;
esac 