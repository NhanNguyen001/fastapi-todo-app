#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 [init|create|up|down|history|current|clean|fix|pip]"
    echo "Commands:"
    echo "  init     - Initialize Alembic migrations"
    echo "  create   - Create a new migration (requires message)"
    echo "  up       - Upgrade to the latest migration"
    echo "  down     - Downgrade the last migration"
    echo "  history  - Show migration history"
    echo "  current  - Show current migration version"
    echo "  clean    - Clean up duplicate data before migration"
    echo "  fix      - Fix migration issues (downgrade and upgrade)"
    echo "  pip      - Upgrade pip to latest version"
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

# Prevent Python from generating __pycache__
export PYTHONDONTWRITEBYTECODE=1

# Function to upgrade pip
upgrade_pip() {
    echo "Current pip version:"
    pip --version
    echo "Upgrading pip..."
    python -m pip install --upgrade pip
    echo "New pip version:"
    pip --version
}

# Function to check if table exists
check_table_exists() {
    local table_name=$1
    psql "${DATABASE_URL}" -t -c "SELECT to_regclass('public.${table_name}');" | grep -q "${table_name}"
    return $?
}

# Function to clean duplicate emails
clean_duplicates() {
    # Check if users table exists
    if ! check_table_exists "users"; then
        echo "Table 'users' does not exist. No cleanup needed."
        return 0
    fi

    echo "Checking for duplicate emails..."
    local duplicate_count=$(psql "${DATABASE_URL}" -t -c "
        SELECT COUNT(*) 
        FROM (
            SELECT email 
            FROM users 
            GROUP BY email 
            HAVING COUNT(*) > 1
        ) t;")

    if [ "$duplicate_count" -eq "0" ]; then
        echo "No duplicate emails found."
        return 0
    fi

    echo "Found ${duplicate_count} duplicate email(s). Cleaning up..."
    psql "${DATABASE_URL}" << EOF
-- Keep only one row for each email, delete duplicates
DELETE FROM users a USING (
    SELECT MIN(ctid) as ctid, email
    FROM users 
    GROUP BY email HAVING COUNT(*) > 1
) b
WHERE a.email = b.email 
AND a.ctid <> b.ctid;

-- Update any NULL or empty emails to be unique
UPDATE users 
SET email = CONCAT('user_', id, '@example.com')
WHERE email IS NULL OR email = '';
EOF
    echo "Cleanup completed."
}

# Function to fix migration
fix_migration() {
    echo "Fixing migration issues..."
    echo "1. Downgrading to base..."
    alembic downgrade base || {
        echo "Error during downgrade. Please check your database connection."
        exit 1
    }
    echo "2. Cleaning up data..."
    clean_duplicates
    echo "3. Upgrading to head..."
    alembic upgrade head || {
        echo "Error during upgrade. Please check your migration files."
        exit 1
    }
}

# Function to install dependencies
install_deps() {
    echo "Installing dependencies..."
    pip install -r requirements.txt
    if [ -f "requirements-dev.txt" ]; then
        echo "Installing development dependencies..."
        pip install -r requirements-dev.txt
    fi
}

# Function to update dependencies to latest versions
update_deps() {
    echo "Updating dependencies to latest versions..."
    
    # Create a backup of current requirements
    cp requirements.txt requirements.txt.bak
    if [ -f "requirements-dev.txt" ]; then
        cp requirements-dev.txt requirements-dev.txt.bak
    fi
    
    # Update main requirements
    echo "# Main dependencies" > requirements.txt
    echo "fastapi" >> requirements.txt
    echo "uvicorn" >> requirements.txt
    echo "gunicorn" >> requirements.txt
    echo "python-jose" >> requirements.txt
    echo "passlib" >> requirements.txt
    echo "bcrypt" >> requirements.txt
    echo "python-multipart" >> requirements.txt
    echo "SQLAlchemy" >> requirements.txt
    echo "alembic" >> requirements.txt
    echo "psycopg2-binary" >> requirements.txt
    echo "python-dotenv" >> requirements.txt
    echo "pydantic" >> requirements.txt
    echo "starlette" >> requirements.txt
    
    # Install and freeze latest versions
    pip install -r requirements.txt --upgrade
    pip freeze | grep -iE "fastapi|uvicorn|gunicorn|python-jose|passlib|bcrypt|python-multipart|sqlalchemy|alembic|psycopg2-binary|python-dotenv|pydantic|starlette" > requirements.txt
    
    if [ -f "requirements-dev.txt" ]; then
        # Update dev requirements
        echo "# Development dependencies" > requirements-dev.txt
        echo "-r requirements.txt" >> requirements-dev.txt
        echo "" >> requirements-dev.txt
        echo "# Testing" >> requirements-dev.txt
        echo "pytest" >> requirements-dev.txt
        echo "pytest-cov" >> requirements-dev.txt
        echo "" >> requirements-dev.txt
        echo "# Linting and formatting" >> requirements-dev.txt
        echo "black" >> requirements-dev.txt
        echo "flake8" >> requirements-dev.txt
        echo "mypy" >> requirements-dev.txt
        echo "" >> requirements-dev.txt
        echo "# Development tools" >> requirements-dev.txt
        echo "httpx  # For testing FastAPI applications" >> requirements-dev.txt
        
        # Install and freeze latest versions
        pip install -r requirements-dev.txt --upgrade
        pip freeze | grep -iE "pytest|black|flake8|mypy|httpx" >> requirements-dev.txt
    fi
    
    echo "Dependencies updated. Old requirements saved as requirements.txt.bak"
    if [ -f "requirements-dev.txt" ]; then
        echo "Development dependencies updated. Old requirements saved as requirements-dev.txt.bak"
    fi
}

case "$1" in
    init)
        echo "Initializing Alembic migrations..."
        alembic init alembic
        ;;
    create)
        if [ -z "$2" ]; then
            echo "Error: Migration message is required"
            echo "Usage: $0 create \"your migration message\""
            exit 1
        fi
        echo "Creating new migration..."
        alembic revision --autogenerate -m "$2"
        ;;
    up)
        echo "Upgrading to the latest migration..."
        alembic upgrade head
        ;;
    down)
        echo "Downgrading the last migration..."
        alembic downgrade -1
        ;;
    history)
        echo "Showing migration history..."
        alembic history --verbose
        ;;
    current)
        echo "Showing current migration version..."
        alembic current
        ;;
    clean)
        echo "Cleaning up duplicate data..."
        clean_duplicates
        ;;
    fix)
        fix_migration
        ;;
    deps)
        install_deps
        ;;
    update)
        update_deps
        ;;
    pip)
        upgrade_pip
        ;;
    *)
        usage
        ;;
esac 