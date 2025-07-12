# AI Education Backend

An industrial-grade FastAPI backend for AI-powered educational question generation.

## 🎯 Project Overview

This backend service provides AI-driven capabilities for educational platforms, starting with intelligent question generation that maintains educational integrity while creating diverse assessment content.

### Key Features (Planned)
- **AI Question Generation**: Create similar questions while maintaining difficulty and knowledge points
- **Self-Verification**: Automated quality assurance for generated content
- **Scalable Architecture**: Built for future educational platform features
- **Industrial Standards**: Production-ready code with comprehensive testing

## 🏗️ Architecture

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Java Backend  │────▶│  FastAPI Layer  │────▶│   OpenAI API    │
└─────────────────┘     └────────┬────────┘     └─────────────────┘
                                 │
                        ┌────────▼────────┐
                        │   PostgreSQL    │
                        │   Redis Cache   │
                        └─────────────────┘
```

### Design Principles
- **Clean Architecture**: Separation of concerns with distinct layers
- **Domain-Driven Design**: Business logic isolated from infrastructure
- **Test-Driven Development**: Comprehensive test coverage
- **SOLID Principles**: Maintainable and extensible codebase

## 🚀 Quick Start

### Prerequisites
- Python 3.11+
- PostgreSQL 14+
- Redis 6+
- Git

### Initial Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd ai-education-backend
   ```

2. **Run the setup command**
   ```bash
   make setup-project
   ```
   This will:
   - Create a virtual environment
   - Install all dependencies
   - Set up pre-commit hooks

3. **Configure environment**
   ```bash
   cp .env.example .env.local
   # Edit .env.local with your configuration
   ```

4. **Start services with Docker**
   ```bash
   make docker-up
   ```

5. **Run the application**
   ```bash
   make run-dev
   ```

Visit http://localhost:8000/docs for the API documentation.

## 📁 Project Structure

```
app/
├── api/              # HTTP layer (routes, dependencies)
├── core/             # Core functionality (config, security)
├── models/           # Data models (domain, schemas, database)
├── services/         # Business logic
├── infrastructure/   # External integrations
└── utils/           # Helper functions

tests/
├── unit/            # Isolated component tests
├── integration/     # Integration tests
└── e2e/            # End-to-end tests
```

See `project_structure.md` for detailed explanation.

## 🛠️ Development

### Common Commands

```bash
# Development
make run-dev         # Run with hot-reload
make test           # Run all tests
make test-unit      # Run unit tests only
make lint           # Run linters
make format         # Format code

# Database
make migrate        # Create new migration
make db-upgrade     # Apply migrations
make db-downgrade   # Rollback migration

# Docker
make docker-build   # Build containers
make docker-up      # Start services
make docker-down    # Stop services
```

### Development Workflow

1. **Create feature branch**
   ```bash
   git checkout -b feature/your-feature
   ```

2. **Write tests first (TDD)**
   ```bash
   # Write test
   # Run: make test-unit
   # See it fail
   # Implement feature
   # See test pass
   ```

3. **Ensure quality**
   ```bash
   make lint
   make format
   make test
   make coverage-check
   ```

4. **Submit PR**
   - Follow PR template
   - Ensure all checks pass
   - Request review

See `docs/development-workflow.md` for detailed practices.

## 🧪 Testing

### Test Categories

- **Unit Tests** (80%): Fast, isolated tests
- **Integration Tests** (15%): Test with real dependencies
- **E2E Tests** (5%): Full workflow validation

### Running Tests

```bash
# All tests with coverage
make test

# Specific categories
make test-unit
make test-integration
make test-e2e

# Generate coverage report
make coverage
```

### Writing Tests

```python
# tests/unit/services/test_question_generator.py
def test_generate_similar_maintains_difficulty():
    # Given
    original = create_test_question(difficulty=3)
    
    # When
    result = generator.generate_similar(original)
    
    # Then
    assert result.difficulty == original.difficulty
```

## 📊 API Documentation

### Interactive Docs
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

### Example Request

```bash
curl -X POST "http://localhost:8000/api/v1/questions/generate-similar" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: your-api-key" \
  -d @question_sample_json.txt
```

## 🔒 Security

- API key authentication
- Rate limiting per client
- Input validation and sanitization
- SQL injection prevention
- Secure secret management

## 📈 Monitoring

- Structured logging with correlation IDs
- Prometheus metrics endpoint
- Health check endpoints
- Performance profiling tools

## 🚢 Deployment

### Environment Configuration

```bash
# Production
export ENVIRONMENT=production
export LOG_LEVEL=INFO
export DATABASE_URL=postgresql://...
export REDIS_URL=redis://...
export OPENAI_API_KEY=sk-...
```

### Docker Deployment

```bash
# Build production image
docker build -f docker/Dockerfile -t ai-edu-backend:latest .

# Run container
docker run -d \
  --name ai-edu-backend \
  -p 8000:8000 \
  --env-file .env.production \
  ai-edu-backend:latest
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Follow development workflow
4. Submit pull request

See `CONTRIBUTING.md` for guidelines.

## 📝 License

[Your License Here]

## 🆘 Support

- Documentation: `docs/`
- Issues: GitHub Issues
- Discussions: GitHub Discussions

---

**Remember**: Good code is not clever code. Good code is clear code that your future self (and teammates) can understand. 