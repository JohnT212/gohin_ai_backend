# AI Education Backend - Project Structure

```
ai-education-backend/
│
├── .github/                      # GitHub specific files
│   ├── workflows/               # CI/CD workflows
│   │   ├── test.yml            # Automated testing
│   │   ├── lint.yml            # Code quality checks
│   │   └── deploy.yml          # Deployment pipeline
│   └── PULL_REQUEST_TEMPLATE.md
│
├── app/                         # Main application code
│   ├── api/                    # API layer
│   │   ├── v1/                # API versioning
│   │   │   ├── endpoints/     # Route handlers
│   │   │   │   ├── questions.py
│   │   │   │   ├── health.py
│   │   │   │   └── __init__.py
│   │   │   └── __init__.py
│   │   └── deps.py           # Dependencies injection
│   │
│   ├── core/                  # Core functionality
│   │   ├── config.py         # Configuration management
│   │   ├── security.py       # Security utilities
│   │   ├── exceptions.py     # Custom exceptions
│   │   └── logging.py        # Logging configuration
│   │
│   ├── models/               # Data models
│   │   ├── domain/          # Domain models
│   │   │   ├── question.py
│   │   │   ├── subject.py
│   │   │   └── __init__.py
│   │   ├── schemas/         # Pydantic schemas
│   │   │   ├── question.py
│   │   │   ├── response.py
│   │   │   └── __init__.py
│   │   └── database/        # Database models
│   │       ├── base.py
│   │       ├── question.py
│   │       └── __init__.py
│   │
│   ├── services/            # Business logic
│   │   ├── ai/             # AI-related services
│   │   │   ├── openai_client.py
│   │   │   ├── prompt_manager.py
│   │   │   └── question_generator.py
│   │   ├── verification/    # Verification services
│   │   │   ├── verifier.py
│   │   │   ├── quality_scorer.py
│   │   │   └── validation_rules.py
│   │   └── question_service.py
│   │
│   ├── infrastructure/      # External integrations
│   │   ├── database/       # Database setup
│   │   │   ├── session.py
│   │   │   └── init_db.py
│   │   ├── cache/          # Caching layer
│   │   │   └── redis_client.py
│   │   └── messaging/      # Message queue (future)
│   │
│   ├── utils/              # Utility functions
│   │   ├── validators.py
│   │   ├── formatters.py
│   │   └── common.py
│   │
│   └── main.py            # Application entry point
│
├── tests/                  # Test suite
│   ├── unit/              # Unit tests
│   │   ├── services/
│   │   ├── models/
│   │   └── utils/
│   ├── integration/       # Integration tests
│   │   ├── api/
│   │   └── services/
│   ├── e2e/              # End-to-end tests
│   ├── fixtures/         # Test data
│   └── conftest.py       # Pytest configuration
│
├── scripts/              # Utility scripts
│   ├── migrate.py       # Database migrations
│   ├── seed.py         # Seed data
│   └── validate_env.py  # Environment validation
│
├── docs/                # Documentation
│   ├── api/            # API documentation
│   ├── architecture/   # Architecture decisions
│   └── deployment/     # Deployment guides
│
├── docker/             # Docker files
│   ├── Dockerfile
│   └── docker-compose.yml
│
├── alembic/           # Database migrations
│   ├── versions/
│   └── alembic.ini
│
├── .env.example       # Environment variables template
├── .gitignore
├── .pre-commit-config.yaml  # Pre-commit hooks
├── pyproject.toml     # Project configuration
├── requirements.txt   # Production dependencies
├── requirements-dev.txt  # Development dependencies
├── Makefile          # Common commands
└── README.md
```

## Component Explanations

### 1. API Layer (`app/api/`)
- **Purpose**: HTTP interface for external systems
- **v1/**: API versioning for backward compatibility
- **endpoints/**: Separated route handlers for different resources
- **deps.py**: Dependency injection for database sessions, auth, etc.

### 2. Core (`app/core/`)
- **config.py**: Centralized configuration using Pydantic Settings
- **security.py**: API key validation, rate limiting
- **exceptions.py**: Custom exceptions for proper error handling
- **logging.py**: Structured logging with correlation IDs

### 3. Models (`app/models/`)
- **domain/**: Pure Python classes representing business entities
- **schemas/**: Pydantic models for request/response validation
- **database/**: SQLAlchemy models for persistence

### 4. Services (`app/services/`)
- **ai/**: OpenAI integration with retry logic, prompt templates
- **verification/**: Business logic for question quality checks
- **question_service.py**: Orchestrates question generation workflow

### 5. Infrastructure (`app/infrastructure/`)
- **database/**: Database connection pooling, session management
- **cache/**: Redis for caching generated questions
- **messaging/**: Future: async processing with RabbitMQ/Kafka

### 6. Testing (`tests/`)
- **unit/**: Isolated component tests with mocks
- **integration/**: Tests with real dependencies
- **e2e/**: Full workflow tests
- **fixtures/**: Reusable test data

### 7. DevOps
- **GitHub Actions**: Automated testing, linting, deployment
- **Docker**: Containerization for consistent environments
- **Alembic**: Database schema version control

## Git Workflow Commands

```bash
# Initial setup
git init
git remote add origin <your-repo-url>

# Feature development
git checkout -b feature/question-generation
git add .
git commit -m "feat: implement question generation service"
git push -u origin feature/question-generation

# Code review process
# Create PR on GitHub
# After approval:
git checkout main
git pull origin main
git merge --no-ff feature/question-generation
git push origin main

# Hotfix
git checkout -b hotfix/critical-bug
# ... fix ...
git commit -m "fix: resolve critical bug in question validation"
git push -u origin hotfix/critical-bug

# Release
git checkout -b release/1.0.0
# Update version numbers
git commit -m "chore: prepare release 1.0.0"
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin release/1.0.0 --tags
``` 