# FastAPI Todo Application

A robust RESTful API built with FastAPI for managing todos with user authentication, authorization, and comprehensive monitoring.

## Features

- 🔐 JWT Authentication
- 👥 User Management
- ✅ Todo CRUD Operations
- 🔄 Background Tasks with Celery
- 📊 PostgreSQL Database
- 🚀 Docker Support
- 📈 Comprehensive Monitoring
  - Prometheus metrics
  - Grafana dashboards
  - Loki logging
  - Tempo tracing
- ✨ Modern Python (3.12+)

## Tech Stack

- FastAPI (^0.115.6)
- PostgreSQL
- Redis
- Celery (^5.4.0)
- SQLAlchemy (^2.0.36)
- Pydantic (^2.10.3)
- Poetry for dependency management
- Monitoring Stack:
  - Prometheus
  - Grafana
  - Loki
  - Tempo

## Prerequisites

- Python 3.12+
- Poetry
- Docker and Docker Compose
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

1. Install the Loki Docker driver:

```bash
docker plugin install grafana/loki-docker-driver:main --alias loki --grant-all-permissions
```

2. Clone the repository:

```bash
git clone <repository-url>
cd fastapi-todo-app
```

3. Create necessary directories:

```bash
mkdir -p loki/chunks loki/rules
```

4. Build and run with Docker Compose:

```bash
docker compose up --build
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
docker compose up
```

## Monitoring and Observability

### Available Endpoints

- FastAPI Application: http://localhost:8000
  - Swagger UI: http://localhost:8000/docs
  - ReDoc: http://localhost:8000/redoc
  - Metrics: http://localhost:8000/metrics

- Monitoring Stack:
  - Grafana: http://localhost:3000 (admin/admin)
  - Prometheus: http://localhost:9090
  - Tempo: http://localhost:3200
  - Loki: http://localhost:3100

### Monitoring Features

1. **Metrics (Prometheus)**
   - Request rates
   - Response times
   - Error rates
   - Custom business metrics

2. **Logging (Loki)**
   - Centralized logging
   - Structured log aggregation
   - Log correlation with traces
   - Real-time log viewing

3. **Tracing (Tempo)**
   - Distributed tracing
   - Request flow visualization
   - Performance bottleneck identification
   - Service dependencies

4. **Dashboards (Grafana)**
   - Pre-configured dashboards
   - Real-time monitoring
   - Custom visualization
   - Alerts configuration

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

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.