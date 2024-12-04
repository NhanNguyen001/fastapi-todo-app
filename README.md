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
- Poetry (optional)

## Installation

1. Clone the repository:

```bash
git clone https://github.com/yourusername/fastapi-todo-app.git
cd fastapi-todo-app
```

2. Create a virtual environment:

```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. Install dependencies:

```bash
pip install -r requirements.txt
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

1. Install development dependencies:

```bash
pip install -r requirements-dev.txt
```

2. Run development server:

```bash
./run.sh dev
```

3. Format code:

```bash
./dev.sh format
```

4. Run linting:

```bash
./dev.sh lint
```

5. Run type checking:

```bash
./dev.sh type
```

6. Run security checks:

```bash
./dev.sh security
```

## Database Migrations

- Initialize migrations:

```bash
./migrate.sh init
```

- Create a new migration:

```bash
./migrate.sh create "migration message"
```

- Apply migrations:

```bash
./migrate.sh up
```

- Rollback migrations:

```bash
./migrate.sh down
```

## Production Deployment

1. Set up environment variables
2. Run database migrations
3. Start the production server:

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

### Main Dependencies
- FastAPI==0.109.2
- SQLAlchemy==2.0.25
- Alembic==1.13.1
- Pydantic==2.5.3
- python-jose==3.3.0
- passlib==1.7.4
- psycopg2-binary==2.9.9
- python-multipart==0.0.6
- python-dotenv==1.0.0
- uvicorn==0.27.0.post1
- gunicorn==21.2.0

### Development Dependencies
- black==24.1.1
- flake8==7.0.0
- mypy==1.8.0
- pytest==8.0.0
- pytest-cov==4.1.0
- bandit==1.7.6
- httpx==0.26.0

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.