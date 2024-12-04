# FastAPI Todo Application

A modern, fast (high-performance) web API for managing todos, built with FastAPI and PostgreSQL.

## Features

- ✨ Modern Python 3.12 with type hints
- 🚀 FastAPI for high performance
- 🔐 JWT Authentication
- 🗃️ PostgreSQL database
- 📝 SQLAlchemy ORM
- 🔄 Alembic migrations
- 🧪 Pytest for testing
- 📊 Code coverage reporting
- 🎨 Black code formatting
- 🔍 Flake8 linting
- ⚡ MyPy type checking
- 🔒 Security checks with Bandit
- 🚦 GitHub Actions CI/CD pipeline

## Requirements

- Python 3.12+
- PostgreSQL 14+
- Poetry 1.7+ (for dependency management)

## Installation

1. Clone the repository:

```bash
git clone https://github.com/yourusername/fastapi-todo-app.git
cd fastapi-todo-app
```

2. Install Poetry if you haven't already:

```bash
curl -sSL https://install.python-poetry.org | python3 -
```

3. Install dependencies:

```bash
# Configure Poetry to create the virtual environment in the project directory
poetry config virtualenvs.in-project true

# Install all dependencies (including development)
poetry install

# Or install only production dependencies
poetry install --only main
```

4. Activate the virtual environment:

```bash
poetry shell
```

## Configuration

1. Create a `.env` file based on `.env.example`:

```bash
cp .env.example .env
```

2. Update the environment variables:

```env
DATABASE_URL=postgresql://user:password@localhost:5432/fastapi_todo
SECRET_KEY=your-super-secret-key-here
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
DEBUG=False
```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| DATABASE_URL | PostgreSQL connection URL | postgresql://user:password@localhost:5432/fastapi_todo |
| SECRET_KEY | JWT secret key | your-super-secret-key-here |
| ALGORITHM | JWT algorithm | HS256 |
| ACCESS_TOKEN_EXPIRE_MINUTES | Token expiration time | 30 |
| DEBUG | Debug mode | False |

## Development

All development commands are available through `dev.sh`:

```bash
# Show available commands
./dev.sh

# Format code
./dev.sh format

# Run linting
./dev.sh lint

# Run type checking
./dev.sh type

# Run security checks
./dev.sh security

# Run development server
./run.sh dev
```

## Database Migrations

Migration commands are available through `migrate.sh`:

```bash
# Show available commands
./migrate.sh

# Initialize migrations
./migrate.sh init

# Create a new migration
./migrate.sh create "migration message"

# Apply migrations
./migrate.sh up

# Rollback migrations
./migrate.sh down
```

## Production Deployment

1. Set up environment variables
2. Install production dependencies:

```bash
poetry install --only main
```

3. Run database migrations
4. Start the production server:

```bash
./run.sh prod
```

## API Documentation

Once the application is running, you can access:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## API Endpoints

### Authentication
- `POST /auth/` - Register new user
- `POST /auth/token` - Login and get access token

### Users
- `GET /user/` - Get current user
- `PUT /user/password` - Change password
- `PUT /user/phonenumber/{phone_number}` - Update phone number

### Todos
- `GET /` - List all todos
- `GET /todo/{todo_id}` - Get specific todo
- `POST /todo` - Create new todo
- `PUT /todo/{todo_id}` - Update todo
- `DELETE /todo/{todo_id}` - Delete todo

### Admin
- `GET /admin/todo` - List all todos (admin only)
- `DELETE /admin/todo/{todo_id}` - Delete any todo (admin only)

## Dependencies

The project uses Poetry for dependency management. Here are the key dependencies:

### Main Dependencies

```toml
[tool.poetry.dependencies]
python = "^3.12"
fastapi = "^0.109.2"
uvicorn = "^0.27.0"
gunicorn = "^21.2.0"
python-jose = "^3.3.0"
passlib = "^1.7.4"
bcrypt = "^4.0.1"
python-multipart = "^0.0.17"
SQLAlchemy = "^2.0.36"
alembic = "^1.14.0"
psycopg2-binary = "^2.9.10"
python-dotenv = "^1.0.1"
pydantic = "^2.9.2"
pydantic-settings = "^2.0.0"
```

### Development Dependencies

```toml
[tool.poetry.group.dev.dependencies]
pytest = "^8.3.3"
pytest-cov = "^4.1.0"
black = "^24.10.0"
flake8 = "^7.0.0"
mypy = "^1.9.0"
httpx = "^0.27.2"
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.