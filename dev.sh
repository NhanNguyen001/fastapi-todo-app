#!/bin/bash

# Prevent Python from generating __pycache__
export PYTHONDONTWRITEBYTECODE=1

# Function to display usage
usage() {
    echo "Usage: $0 [setup|format|lint|type|security|build|all]"
    echo "Commands:"
    echo "  setup     - Install development dependencies"
    echo "  format    - Format code with black"
    echo "  lint      - Run flake8 linting"
    echo "  type      - Run mypy type checking"
    # echo "  test      - Run pytest"
    # echo "  coverage  - Run tests with coverage"
    echo "  security  - Run security checks"
    echo "  build     - Build the package"
    echo "  all       - Run all checks"
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

# Function to install dependencies
install_deps() {
    echo "Installing dependencies..."
    pip install -r requirements.txt
    if [ -f "requirements-dev.txt" ]; then
        echo "Installing development dependencies..."
        pip install -r requirements-dev.txt
    fi
}

# Function to format code
format_code() {
    echo "Formatting code with black..."
    black .
}

# Function to run linting
run_lint() {
    echo "Running flake8..."
    flake8 .
}

# Function to run type checking
run_type_check() {
    echo "Running mypy..."
    mypy .
}

# Function to run tests
# run_tests() {
#     echo "Running pytest..."
#     pytest
# }

# Function to run tests with coverage
# run_coverage() {
#     echo "Running tests with coverage..."
#     pytest --cov=. --cov-report=xml
# }

# Function to run security checks
run_security() {
    echo "Running bandit security checks..."
    bandit -r .
}

# Function to build package
build_package() {
    echo "Building package..."
    pip install build
    python -m build
}

# Function to run all checks
run_all() {
    format_code
    run_lint
    run_type_check
    # run_tests
    run_security
}

case "$1" in
    setup)
        install_deps
        ;;
    format)
        format_code
        ;;
    lint)
        run_lint
        ;;
    type)
        run_type_check
        ;;
    # test)
    #     run_tests
    #     ;;
    # coverage)
    #     run_coverage
    #     ;;
    security)
        run_security
        ;;
    build)
        build_package
        ;;
    all)
        run_all
        ;;
    *)
        usage
        ;;
esac 