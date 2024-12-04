# FastAPI Todo Application

A robust RESTful API built with FastAPI for managing todos with user authentication, authorization, and background tasks using Celery.

## Features

- 🔐 JWT Authentication
- 👥 User Management
- ✅ Todo CRUD Operations
- 🔄 Background Tasks with Celery
- 📊 PostgreSQL Database
- 🚀 Docker Support
- ✨ Modern Python (3.12+)

## Tech Stack

- FastAPI (^0.115.6)
- PostgreSQL
- Redis
- Celery (^5.4.0)
- SQLAlchemy (^2.0.36)
- Pydantic (^2.10.3)
- Poetry for dependency management

## Prerequisites

- Python 3.12+
- Poetry
- Docker and Docker Compose (optional)
- PostgreSQL (if running locally)
- Redis (if running locally)

## Installation

### Using Poetry (Local Development)

1. Install Poetry:

```bash
curl -sSL https://install.python-poetry.org | python3 -
```

2. Clone the repository:

```bash
git clone <repository-url>
cd fastapi-todo-app
```

3. Install dependencies:

```bash
poetry install
```

4. Create a `.env` file:

```bash
cp .env.example .env
# Edit .env with your configuration
```

5. Run migrations:

```bash
poetry run alembic upgrade head
```

### Using Docker

1. Clone the repository:

```bash
git clone <repository-url>
cd fastapi-todo-app
```

2. Build and run with Docker Compose:

```bash
docker-compose up --build
```

## Running the Application

### Local Development

1. Start the FastAPI application:

```bash
poetry run uvicorn app.main:app --reload
```

2. Start Celery worker:

```bash
poetry run celery -A app.worker.celery worker --loglevel=info
```

### Docker Environment

```bash
docker-compose up
```

## API Documentation

Once the application is running, you can access:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## API Endpoints

### Authentication
- POST `/api/auth/register` - Register new user
- POST `/api/auth/login` - Login user
- POST `/api/auth/refresh` - Refresh access token

### Todos
- GET `/api/todos` - List all todos
- POST `/api/todos` - Create new todo
- GET `/api/todos/{todo_id}` - Get specific todo
- PUT `/api/todos/{todo_id}` - Update todo
- DELETE `/api/todos/{todo_id}` - Delete todo

## Development Tools

This project uses several development tools:

- **Black** (^24.10.0) - Code formatting
- **Flake8** (^7.0.0) - Linting
- **MyPy** (^1.9.0) - Static type checking
- **Pytest** (^8.3.3) - Testing
- **Ruff** - Fast Python linter

### Running Tests

```bash
poetry run pytest
```

### Code Formatting

```bash
poetry run black .
poetry run flake8
poetry run mypy .
```

## Environment Variables

Create a `.env` file with the following variables:

```env
DATABASE_URL=postgresql://postgres:postgres@db:5432/todos
REDIS_URL=redis://redis:6379/0
SECRET_KEY=your-secret-key-here
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
```

## Docker Services

- **web**: FastAPI application
- **db**: PostgreSQL database
- **redis**: Redis for Celery
- **celery_worker**: Celery worker for background tasks

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Docker Setup

### Prerequisites

- Docker Engine 24.0+
- Docker Compose V2

### Docker Configuration

The application uses Docker Compose to manage multiple services:

1. `web`: FastAPI application container
   - Exposes port 8000
   - Handles API requests
   - Auto-reloads during development

2. `db`: PostgreSQL database
   - Exposes port 5432
   - Persists data in a Docker volume
   - Configured with environment variables

3. `redis`: Redis server
   - Exposes port 6379
   - Used as message broker for Celery
   - Handles caching

4. `celery_worker`: Celery worker
   - Processes background tasks
   - Connects to Redis broker
   - Runs in worker mode

### Docker Commands

Start all services:

```bash
docker compose up
```

Start services in detached mode:

```bash
docker compose up -d
```

Build and start services:

```bash
docker compose up --build
```

Stop all services:

```bash
docker compose down
```

View logs:

```bash
docker compose logs
```

View logs for specific service:

```bash
docker compose logs [service_name]
```

### Docker Volumes

The application uses Docker volumes for data persistence:

- `postgres_data`: Stores PostgreSQL data
- `redis_data`: Stores Redis data

### Environment Variables

When using Docker, the environment variables in `.env` file should use the service names as hostnames:

```env
DATABASE_URL=postgresql://username:password@db:5432/database_name
REDIS_URL=redis://redis:6379/0
```

Note: Replace `username`, `password`, and `database_name` with your actual credentials.