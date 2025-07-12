# Development Workflow Guide

## Stop! Before You Code...

As a junior developer, your instinct is to start coding immediately. **WRONG.**

Professional developers spend 80% thinking, 20% coding. Here's the industrial workflow:

## 1. Requirements Analysis (Before ANY Code)

### For Question Generation Feature:

**Questions to Answer FIRST:**
1. What makes two questions "similar"?
   - Same difficulty level?
   - Same topic coverage?
   - Same question type (multiple choice, essay)?
   - Same cognitive level (recall, analysis, synthesis)?

2. What are the constraints?
   - Must maintain same subject?
   - Must have same number of options?
   - Must test same knowledge points?

3. What defines "quality"?
   - Grammatical correctness?
   - Semantic coherence?
   - Educational value?
   - Difficulty consistency?

4. What are failure scenarios?
   - OpenAI returns inappropriate content
   - Generated question is identical to input
   - API rate limits exceeded
   - Network failures

### Document Your Decisions:
```markdown
# docs/architecture/ADR-001-question-similarity.md
# Architecture Decision Record: Question Similarity Definition

## Status: Accepted
## Date: 2024-01-12

## Context
We need to define what makes two questions "similar" for our generation system.

## Decision
Two questions are similar if they:
1. Test the same knowledge points (±10% overlap)
2. Have the same difficulty level (±1 level)
3. Use the same question format
4. Target the same cognitive level

## Consequences
- Need similarity scoring algorithm
- Requires knowledge point extraction
- Must validate against these criteria
```

## 2. Test-Driven Development (TDD)

### The Professional Way:

**Step 1: Write the test FIRST**
```python
# tests/unit/services/test_question_generator.py
def test_generate_similar_question_maintains_difficulty():
    # Given
    original_question = create_test_question(difficulty=3)
    generator = QuestionGenerator()
    
    # When
    new_question = generator.generate_similar(original_question)
    
    # Then
    assert new_question.difficulty == original_question.difficulty
```

**Step 2: Run test (it MUST fail)**
```bash
make test-unit
# FAILED - QuestionGenerator doesn't exist
```

**Step 3: Write minimal code to pass**
```python
class QuestionGenerator:
    def generate_similar(self, question):
        # Minimal implementation
        pass
```

**Step 4: Refactor with confidence**

### Why TDD?
1. **Forces you to think about interface first**
2. **Guarantees testable code**
3. **Documents expected behavior**
4. **Prevents over-engineering**

## 3. Branching Strategy (Git Flow)

### Branch Types:

1. **main**: Production-ready code
2. **develop**: Integration branch
3. **feature/**: New features
4. **hotfix/**: Emergency fixes
5. **release/**: Release preparation

### Workflow Example:

```bash
# 1. Start new feature
git checkout develop
git pull origin develop
git checkout -b feature/question-generation

# 2. Make changes with meaningful commits
git add app/services/ai/question_generator.py
git commit -m "feat: implement base question generator class

- Add QuestionGenerator with generate_similar method
- Implement prompt template management
- Add retry logic for API calls

Refs: #123"

# 3. Keep branch updated
git checkout develop
git pull origin develop
git checkout feature/question-generation
git rebase develop

# 4. Push and create PR
git push -u origin feature/question-generation
```

### Commit Message Convention:
```
<type>(<scope>): <subject>

<body>

<footer>
```

Types:
- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation
- **style**: Formatting
- **refactor**: Code restructuring
- **test**: Adding tests
- **chore**: Maintenance

## 4. Code Review Process

### Before Submitting PR:

1. **Self-review checklist:**
   - [ ] All tests pass
   - [ ] Code coverage maintained/improved
   - [ ] No commented-out code
   - [ ] No debug prints
   - [ ] Documentation updated
   - [ ] Type hints added
   - [ ] Error handling complete

2. **Run quality checks:**
   ```bash
   make lint
   make format-check
   make test
   make coverage-check
   ```

### PR Description Template:
```markdown
## Summary
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No new warnings
```

## 5. Development Environment Setup

### Local Development:

1. **Virtual Environment (ALWAYS)**
   ```bash
   python -m venv venv
   # Windows
   .\venv\Scripts\activate
   # Linux/Mac
   source venv/bin/activate
   ```

2. **Environment Variables**
   ```bash
   # .env.local
   OPENAI_API_KEY=sk-...
   DATABASE_URL=postgresql://user:pass@localhost/edu_db
   REDIS_URL=redis://localhost:6379
   LOG_LEVEL=DEBUG
   ```

3. **Pre-commit Hooks**
   ```yaml
   # .pre-commit-config.yaml
   repos:
     - repo: https://github.com/psf/black
       rev: 23.1.0
       hooks:
         - id: black
     - repo: https://github.com/pycqa/isort
       rev: 5.12.0
       hooks:
         - id: isort
     - repo: https://github.com/pycqa/flake8
       rev: 6.0.0
       hooks:
         - id: flake8
   ```

## 6. Debugging Like a Pro

### DON'T:
- Print statements everywhere
- Guess and check
- Change multiple things at once

### DO:
1. **Use proper debugging tools**
   ```python
   import pdb; pdb.set_trace()  # Breakpoint
   # or in VS Code/PyCharm: Use IDE breakpoints
   ```

2. **Structured logging**
   ```python
   logger.debug(f"Generating question", extra={
       "original_question_id": question.id,
       "difficulty": question.difficulty,
       "correlation_id": request_id
   })
   ```

3. **Hypothesis-driven debugging**
   - Form hypothesis
   - Test hypothesis
   - Document findings

## 7. Performance Profiling

### Before optimizing:
```python
import cProfile
import pstats

profiler = cProfile.Profile()
profiler.enable()

# Your code here
result = generate_similar_question(input_question)

profiler.disable()
stats = pstats.Stats(profiler).sort_stats('cumulative')
stats.print_stats()
```

### Rules:
1. **Measure first, optimize second**
2. **Profile in production-like environment**
3. **Focus on bottlenecks only**

## 8. Documentation Standards

### Code Documentation:
```python
def generate_similar_question(
    self,
    original_question: Question,
    similarity_threshold: float = 0.8,
    max_retries: int = 3
) -> Question:
    """
    Generate a similar question using AI.
    
    This method creates a new question that maintains the same
    educational objectives and difficulty level as the original.
    
    Args:
        original_question: The source question to base generation on
        similarity_threshold: Minimum similarity score (0.0-1.0)
        max_retries: Maximum generation attempts
        
    Returns:
        A new Question instance with similar characteristics
        
    Raises:
        QuestionGenerationError: If generation fails after retries
        ValidationError: If generated question fails validation
        
    Example:
        >>> generator = QuestionGenerator()
        >>> new_q = generator.generate_similar(original_q)
        >>> assert new_q.difficulty == original_q.difficulty
    """
```

### API Documentation:
```python
@router.post(
    "/questions/generate-similar",
    response_model=QuestionResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Generate a similar question",
    description="""
    Creates a new question similar to the provided one.
    
    The generated question will:
    - Test the same knowledge points
    - Maintain the same difficulty level
    - Use a similar format
    - Be verified for quality
    """
)
```

## 9. Monitoring & Observability

### What to track:
1. **Business Metrics**
   - Question generation success rate
   - Average generation time
   - Similarity scores distribution

2. **Technical Metrics**
   - API response times
   - Error rates by type
   - OpenAI API usage

3. **Logging Levels**
   ```python
   logger.debug("Detailed diagnostic info")
   logger.info("General informational messages")
   logger.warning("Warning messages")
   logger.error("Error messages")
   logger.critical("Critical issues")
   ```

## 10. Continuous Improvement

### Weekly Reviews:
1. **Code metrics review**
   - Test coverage trends
   - Code complexity scores
   - Technical debt tracking

2. **Performance review**
   - API response times
   - Error rates
   - Resource usage

3. **Process review**
   - CI/CD pipeline performance
   - PR review times
   - Bug escape rate

### Remember:
> "Any fool can write code that a computer can understand. Good programmers write code that humans can understand." - Martin Fowler

Your code will be read 10x more than it's written. Optimize for readability. 