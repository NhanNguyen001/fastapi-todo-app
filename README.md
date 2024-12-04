# FastAPI Todo Application

A robust RESTful API built with FastAPI for managing todos with user authentication and authorization.

## Features

- 🔐 JWT Authentication
- 👥 User Management
- ✅ Todo CRUD Operations
- 🔑 Role-based Access Control
- 📝 Database Migrations with Alembic
- 🐳 Production-ready with Gunicorn
- 🔄 Environment-based Configuration

## Tech Stack

- FastAPI
- PostgreSQL
- SQLAlchemy
- Alembic
- Pydantic
- Python-Jose (JWT)
- Passlib
- Gunicorn
- Uvicorn

## Prerequisites

- Python 3.8+
- PostgreSQL
- Virtual Environment (recommended)

## Installation

1. Clone the repository:

```bash
git clone <repository-url>
cd fastapi-todo-app
```

2. Create and activate virtual environment:

```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. Install dependencies:

```bash
# For production
pip install -r requirements.txt

# For development
pip install -r requirements-dev.txt
```

4. Set up environment variables:

```bash
cp .env.example .env
# Edit .env with your configuration
```

5. Initialize the database:

```bash
./migrate.sh up
```

## Running the Application

### Development

```bash
./run.sh dev
```

### Production

```bash
./run.sh prod
```

### Database Migrations

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

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| DATABASE_URL | PostgreSQL connection URL | postgresql://user:password@localhost:5432/fastapi_todo |
| SECRET_KEY | JWT secret key | your-super-secret-key-here |
| ALGORITHM | JWT algorithm | HS256 |
| ACCESS_TOKEN_EXPIRE_MINUTES | Token expiration time | 30 |
| DEBUG | Debug mode | False |
| ALLOWED_ORIGINS | CORS allowed origins | http://localhost:3000,http://localhost:8000 |

## Development

1. Install development dependencies:

```bash
pip install -r requirements-dev.txt
```

2. Format code:

```bash
black .
```

3. Run linting:

```bash
flake8 .
```

4. Run type checking:

```bash
mypy .
```

5. Run tests:

```bash
pytest
```

## Project Structure

```
fastapi-todo-app/
├── alembic/              # Database migrations
├── routers/              # API route handlers
│   ├── auth.py          # Authentication routes
│   ├── todos.py         # Todo routes
│   ├── users.py         # User routes
│   └── admin.py         # Admin routes
├── tests/               # Test files
├── config.py            # Configuration management
├── database.py          # Database setup
├── models.py            # SQLAlchemy models
├── requirements.txt     # Production dependencies
├── requirements-dev.txt # Development dependencies
├── run.sh              # Server run script
└── migrate.sh          # Migration management script
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.