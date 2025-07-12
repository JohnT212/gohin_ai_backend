# AI Education Backend - Makefile
# Industrial-standard development workflow commands

.PHONY: help install install-dev test test-unit test-integration test-e2e lint format security-check
.PHONY: run run-dev migrate db-upgrade db-downgrade docker-build docker-up docker-down
.PHONY: clean coverage docs pre-commit setup-project

# Default target
.DEFAULT_GOAL := help

# Variables
PYTHON := python
PIP := pip
PROJECT_NAME := ai-education-backend
DOCKER_COMPOSE := docker-compose
COVERAGE_THRESHOLD := 80

# Help command - shows all available commands
help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Setup Commands

setup-project: ## Complete project setup (run this first!)
	@echo "Setting up AI Education Backend..."
	$(PYTHON) -m venv venv
	@echo "Virtual environment created. Activate it with:"
	@echo "Windows: .\\venv\\Scripts\\activate"
	@echo "Linux/Mac: source venv/bin/activate"
	$(MAKE) install-dev
	$(MAKE) setup-pre-commit
	@echo "Project setup complete!"

install: ## Install production dependencies
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt

install-dev: install ## Install development dependencies
	$(PIP) install -r requirements-dev.txt
	pre-commit install

setup-pre-commit: ## Setup pre-commit hooks
	pre-commit install
	pre-commit run --all-files || true

##@ Development Commands

run: ## Run the application
	uvicorn app.main:app --host 0.0.0.0 --port 8000

run-dev: ## Run with auto-reload (development)
	uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload

run-worker: ## Run background worker (for async tasks)
	celery -A app.worker worker --loglevel=info

##@ Testing Commands

test: ## Run all tests
	pytest tests/ -v --cov=app --cov-report=term-missing

test-unit: ## Run unit tests only
	pytest tests/unit/ -v --cov=app --cov-report=term-missing

test-integration: ## Run integration tests
	pytest tests/integration/ -v

test-e2e: ## Run end-to-end tests
	pytest tests/e2e/ -v

coverage: ## Generate coverage report
	pytest tests/ --cov=app --cov-report=html --cov-report=term
	@echo "Coverage report generated in htmlcov/"
	@$(PYTHON) -c "import webbrowser; webbrowser.open('htmlcov/index.html')"

coverage-check: ## Check if coverage meets threshold
	pytest tests/ --cov=app --cov-fail-under=$(COVERAGE_THRESHOLD)

##@ Code Quality Commands

lint: ## Run all linters
	@echo "Running flake8..."
	flake8 app/ tests/
	@echo "Running pylint..."
	pylint app/
	@echo "Running mypy..."
	mypy app/

format: ## Format code with black and isort
	@echo "Running isort..."
	isort app/ tests/
	@echo "Running black..."
	black app/ tests/

format-check: ## Check code formatting
	isort --check-only app/ tests/
	black --check app/ tests/

security-check: ## Run security checks
	bandit -r app/
	safety check

##@ Database Commands

migrate: ## Create a new migration
	@read -p "Enter migration message: " msg; \
	alembic revision --autogenerate -m "$$msg"

db-upgrade: ## Apply migrations
	alembic upgrade head

db-downgrade: ## Rollback last migration
	alembic downgrade -1

db-reset: ## Reset database (DANGEROUS!)
	alembic downgrade base
	alembic upgrade head

##@ Docker Commands

docker-build: ## Build Docker images
	$(DOCKER_COMPOSE) -f docker/docker-compose.yml build

docker-up: ## Start all services
	$(DOCKER_COMPOSE) -f docker/docker-compose.yml up -d

docker-down: ## Stop all services
	$(DOCKER_COMPOSE) -f docker/docker-compose.yml down

docker-logs: ## View logs
	$(DOCKER_COMPOSE) -f docker/docker-compose.yml logs -f

docker-clean: ## Remove all containers and volumes (DANGEROUS!)
	$(DOCKER_COMPOSE) -f docker/docker-compose.yml down -v

##@ Documentation Commands

docs: ## Generate API documentation
	@echo "Generating OpenAPI schema..."
	$(PYTHON) -c "from app.main import app; import json; print(json.dumps(app.openapi()))" > docs/api/openapi.json
	@echo "Documentation generated in docs/api/"

docs-serve: ## Serve documentation locally
	mkdocs serve

##@ Utility Commands

clean: ## Clean up generated files
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete
	find . -type f -name "*.coverage" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".mypy_cache" -exec rm -rf {} + 2>/dev/null || true
	rm -rf htmlcov/
	rm -rf dist/
	rm -rf build/

env-check: ## Validate environment variables
	$(PYTHON) scripts/validate_env.py

seed-db: ## Seed database with sample data
	$(PYTHON) scripts/seed.py

##@ Git Workflow Commands

pre-commit: ## Run pre-commit checks
	pre-commit run --all-files

commit: pre-commit ## Run checks and commit
	@echo "All checks passed! Ready to commit."

##@ Production Commands

build: clean ## Build for production
	$(PYTHON) setup.py sdist bdist_wheel

deploy-staging: ## Deploy to staging
	@echo "Deploying to staging environment..."
	# Add your staging deployment commands here

deploy-production: ## Deploy to production (requires confirmation)
	@echo "WARNING: This will deploy to PRODUCTION!"
	@read -p "Are you sure? (type 'yes' to confirm): " confirm; \
	if [ "$$confirm" = "yes" ]; then \
		echo "Deploying to production..."; \
		# Add your production deployment commands here \
	else \
		echo "Deployment cancelled."; \
	fi 