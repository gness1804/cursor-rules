# Testing Best Practices & Standards

## General Testing Philosophy

### Integration Tests Over Unit Tests
- **Prefer integration tests**: Focus on testing complete workflows and component interactions rather than isolated units
- **Real-world scenarios**: Test how components work together in realistic conditions
- **End-to-end validation**: Ensure the entire system works as expected from user perspective
- **Reduced mocking**: Minimize mocking to test actual behavior and catch integration issues
- **Business logic focus**: Test business workflows and user journeys rather than implementation details

### Test Pyramid Balance
- **Foundation**: Unit tests for critical business logic and edge cases
- **Middle layer**: Integration tests for component interactions and API endpoints
- **Top layer**: End-to-end tests for complete user workflows
- **Focus**: Spend more effort on integration and E2E tests that validate real functionality

## Python Testing Standards

### Framework Selection
- **Primary**: Use `pytest` for all Python testing
- **Fixtures**: Leverage pytest fixtures for test data and setup
- **Parametrization**: Use `@pytest.mark.parametrize` for testing multiple scenarios
- **Plugins**: Use pytest plugins like `pytest-cov`, `pytest-mock`, `pytest-asyncio`

### Test Structure
```python
# test_example.py
import pytest
from unittest.mock import Mock, patch
from your_module import YourClass

class TestYourClass:
    """Test suite for YourClass functionality."""
    
    @pytest.fixture
    def sample_data(self):
        """Provide test data for tests."""
        return {"key": "value", "id": 123}
    
    def test_method_success_case(self, sample_data):
        """Test successful execution of method."""
        # Arrange
        instance = YourClass()
        
        # Act
        result = instance.method(sample_data)
        
        # Assert
        assert result is not None
        assert result.status == "success"
    
    @pytest.mark.parametrize("input_value,expected", [
        ("valid", True),
        ("invalid", False),
        ("", False),
    ])
    def test_validation_method(self, input_value, expected):
        """Test validation with multiple inputs."""
        instance = YourClass()
        result = instance.validate(input_value)
        assert result == expected
```

### Integration Testing
```python
# test_integration.py
import pytest
from your_app import create_app
from your_app.database import db

@pytest.fixture
def app():
    """Create test application."""
    app = create_app(testing=True)
    with app.app_context():
        db.create_all()
        yield app
        db.drop_all()

@pytest.fixture
def client(app):
    """Create test client."""
    return app.test_client()

def test_user_registration_flow(client):
    """Test complete user registration workflow."""
    # Test registration endpoint
    response = client.post('/register', json={
        'email': 'test@example.com',
        'password': 'secure123'
    })
    assert response.status_code == 201
    
    # Test login with registered user
    login_response = client.post('/login', json={
        'email': 'test@example.com',
        'password': 'secure123'
    })
    assert login_response.status_code == 200
    assert 'token' in login_response.json
```

### Async Testing
```python
import pytest
import asyncio
from your_module import async_function

@pytest.mark.asyncio
async def test_async_function():
    """Test async function."""
    result = await async_function()
    assert result is not None
```

## Ruby Testing Standards

### Framework Selection
- **Primary**: Use `RSpec` for Ruby testing
- **Rails**: Use `rspec-rails` for Rails applications
- **Fixtures**: Use FactoryBot for test data generation
- **Coverage**: Use SimpleCov for coverage reporting

### Test Structure
```ruby
# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'validates presence of email' do
      user = User.new(email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end
    
    it 'validates email format' do
      user = User.new(email: 'invalid-email')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('is invalid')
    end
  end
  
  describe 'associations' do
    it 'has many posts' do
      association = User.reflect_on_association(:posts)
      expect(association.macro).to eq :has_many
    end
  end
end
```

### Integration Testing
```ruby
# spec/requests/api/v1/users_spec.rb
require 'rails_helper'

RSpec.describe 'API::V1::Users', type: :request do
  describe 'POST /api/v1/users' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          user: {
            email: 'test@example.com',
            password: 'password123',
            name: 'Test User'
          }
        }
      end
      
      it 'creates a new user' do
        expect {
          post '/api/v1/users', params: valid_params
        }.to change(User, :count).by(1)
        
        expect(response).to have_http_status(:created)
        expect(json_response['user']['email']).to eq('test@example.com')
      end
      
      it 'sends welcome email' do
        expect {
          post '/api/v1/users', params: valid_params
        }.to have_enqueued_mail(UserMailer, :welcome_email)
      end
    end
  end
end
```

### FactoryBot Usage
```ruby
# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    name { 'Test User' }
    
    trait :admin do
      role { 'admin' }
    end
    
    trait :with_posts do
      after(:create) do |user|
        create_list(:post, 3, user: user)
      end
    end
  end
end
```

## JavaScript/TypeScript Testing Standards

### Framework Selection
- **Primary**: Use `Jest` for JavaScript/TypeScript testing
- **React**: Use `@testing-library/react` for React component testing
- **E2E**: Use `Playwright` or `Cypress` for end-to-end testing
- **Coverage**: Use Jest's built-in coverage reporting

### Test Structure
```typescript
// __tests__/userService.test.ts
import { UserService } from '../src/services/userService';
import { UserRepository } from '../src/repositories/userRepository';

describe('UserService', () => {
  let userService: UserService;
  let mockUserRepository: jest.Mocked<UserRepository>;
  
  beforeEach(() => {
    mockUserRepository = {
      findById: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
      delete: jest.fn(),
    } as jest.Mocked<UserRepository>;
    
    userService = new UserService(mockUserRepository);
  });
  
  describe('createUser', () => {
    it('should create a user successfully', async () => {
      // Arrange
      const userData = { email: 'test@example.com', name: 'Test User' };
      const expectedUser = { id: 1, ...userData };
      mockUserRepository.create.mockResolvedValue(expectedUser);
      
      // Act
      const result = await userService.createUser(userData);
      
      // Assert
      expect(result).toEqual(expectedUser);
      expect(mockUserRepository.create).toHaveBeenCalledWith(userData);
    });
    
    it('should throw error for invalid email', async () => {
      // Arrange
      const invalidUserData = { email: 'invalid-email', name: 'Test User' };
      
      // Act & Assert
      await expect(userService.createUser(invalidUserData))
        .rejects.toThrow('Invalid email format');
    });
  });
});
```

### React Component Testing
```typescript
// __tests__/components/UserCard.test.tsx
import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react';
import { UserCard } from '../src/components/UserCard';

describe('UserCard', () => {
  const mockUser = {
    id: 1,
    name: 'John Doe',
    email: 'john@example.com',
    avatar: 'https://example.com/avatar.jpg'
  };
  
  it('renders user information correctly', () => {
    render(<UserCard user={mockUser} />);
    
    expect(screen.getByText('John Doe')).toBeInTheDocument();
    expect(screen.getByText('john@example.com')).toBeInTheDocument();
    expect(screen.getByAltText('John Doe avatar')).toBeInTheDocument();
  });
  
  it('calls onEdit when edit button is clicked', () => {
    const mockOnEdit = jest.fn();
    render(<UserCard user={mockUser} onEdit={mockOnEdit} />);
    
    fireEvent.click(screen.getByRole('button', { name: /edit/i }));
    
    expect(mockOnEdit).toHaveBeenCalledWith(mockUser);
  });
});
```

### Integration Testing
```typescript
// __tests__/integration/userWorkflow.test.ts
import request from 'supertest';
import { app } from '../src/app';
import { setupTestDatabase, cleanupTestDatabase } from './testHelpers';

describe('User Workflow Integration', () => {
  beforeAll(async () => {
    await setupTestDatabase();
  });
  
  afterAll(async () => {
    await cleanupTestDatabase();
  });
  
  it('should complete user registration and login flow', async () => {
    // Register user
    const registerResponse = await request(app)
      .post('/api/users/register')
      .send({
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User'
      });
    
    expect(registerResponse.status).toBe(201);
    expect(registerResponse.body.user.email).toBe('test@example.com');
    
    // Login with registered user
    const loginResponse = await request(app)
      .post('/api/auth/login')
      .send({
        email: 'test@example.com',
        password: 'password123'
      });
    
    expect(loginResponse.status).toBe(200);
    expect(loginResponse.body.token).toBeDefined();
    
    // Access protected resource
    const protectedResponse = await request(app)
      .get('/api/users/profile')
      .set('Authorization', `Bearer ${loginResponse.body.token}`);
    
    expect(protectedResponse.status).toBe(200);
    expect(protectedResponse.body.user.email).toBe('test@example.com');
  });
});
```

## Test Organization & Structure

### File Naming Conventions
- **Python**: `test_*.py` or `*_test.py`
- **Ruby**: `*_spec.rb`
- **JavaScript**: `*.test.js` or `*.spec.js`
- **TypeScript**: `*.test.ts` or `*.spec.ts`

### Directory Structure
```
tests/
├── unit/           # Unit tests (minimal)
├── integration/    # Integration tests (preferred)
├── e2e/           # End-to-end tests
├── fixtures/      # Test data and fixtures
├── helpers/       # Test utilities and helpers
└── mocks/         # Mock implementations
```

### Test Categories
- **Unit Tests**: Test individual functions/methods in isolation
- **Integration Tests**: Test component interactions and workflows
- **Contract Tests**: Test API contracts and interfaces
- **End-to-End Tests**: Test complete user journeys
- **Performance Tests**: Test system performance under load

## Test Data Management

### Test Data Principles
- **Isolation**: Each test should have its own data
- **Cleanup**: Clean up test data after each test
- **Realistic**: Use realistic test data that mirrors production
- **Minimal**: Use only the data necessary for the test

### Fixture Management
```python
# Python pytest fixtures
@pytest.fixture
def sample_user():
    return User(email="test@example.com", name="Test User")

@pytest.fixture
def sample_users():
    return [
        User(email="user1@example.com", name="User 1"),
        User(email="user2@example.com", name="User 2"),
    ]
```

```ruby
# Ruby FactoryBot
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    name { "Test User" }
  end
end
```

## Mocking & Stubbing Guidelines

### When to Mock
- **External services**: APIs, databases, file systems
- **Slow operations**: Network calls, file I/O
- **Unpredictable behavior**: Random number generation, time-based functions
- **Expensive operations**: Complex calculations, image processing

### When NOT to Mock
- **Business logic**: Core application logic should be tested with real implementations
- **Simple objects**: Don't mock simple data objects
- **Internal dependencies**: Prefer real implementations for internal components

### Mock Examples
```python
# Python unittest.mock
from unittest.mock import Mock, patch

@patch('your_module.external_api_call')
def test_function_with_external_call(mock_api_call):
    mock_api_call.return_value = {'status': 'success'}
    result = your_function()
    assert result.status == 'success'
```

```typescript
// JavaScript Jest
jest.mock('../src/services/apiService');

import { ApiService } from '../src/services/apiService';
const mockApiService = ApiService as jest.Mocked<typeof ApiService>;

describe('UserService', () => {
  beforeEach(() => {
    mockApiService.fetchUser.mockResolvedValue({
      id: 1,
      name: 'Test User',
      email: 'test@example.com'
    });
  });
});
```

## Test Coverage & Quality

### Coverage Targets
- **Minimum**: 80% overall coverage
- **Critical paths**: 95% coverage for business-critical code
- **Integration tests**: Focus on covering user workflows and business scenarios
- **Quality over quantity**: Better to have fewer, high-quality tests

### Test Quality Metrics
- **Clarity**: Tests should be easy to understand and maintain
- **Reliability**: Tests should be stable and not flaky
- **Speed**: Tests should run quickly, especially unit tests
- **Maintainability**: Tests should be easy to update when code changes

### Continuous Integration
- **Automated testing**: Run tests on every commit
- **Parallel execution**: Run tests in parallel for faster feedback
- **Test reporting**: Generate and display test coverage reports
- **Failure notifications**: Alert team when tests fail

## Performance Testing

### Load Testing
- **Realistic scenarios**: Test with realistic data volumes
- **Performance baselines**: Establish performance benchmarks
- **Resource monitoring**: Monitor CPU, memory, and I/O during tests
- **Scalability testing**: Test system behavior under increasing load

### Performance Test Examples
```python
# Python with pytest-benchmark
import pytest

def test_user_creation_performance(benchmark):
    def create_user():
        return User.create(email="test@example.com", name="Test User")
    
    result = benchmark(create_user)
    assert result is not None
```

## Security Testing

### Security Test Categories
- **Authentication**: Test login/logout flows
- **Authorization**: Test access control and permissions
- **Input validation**: Test for injection attacks and malformed input
- **Data protection**: Test encryption and data handling

### Security Test Examples
```python
def test_sql_injection_protection():
    malicious_input = "'; DROP TABLE users; --"
    result = user_service.search_users(malicious_input)
    # Should not cause database issues
    assert result is not None
```

## Test Maintenance

### Refactoring Tests
- **Keep tests simple**: Avoid complex test logic
- **Single responsibility**: Each test should test one thing
- **Descriptive names**: Use clear, descriptive test names
- **Regular review**: Review and update tests regularly

### Test Debt Management
- **Remove obsolete tests**: Delete tests for removed features
- **Update broken tests**: Fix tests that break due to code changes
- **Improve test quality**: Continuously improve test coverage and quality
- **Documentation**: Keep test documentation up to date

## Best Practices Summary

1. **Prefer integration tests** over unit tests for better real-world validation
2. **Test user workflows** and business scenarios rather than implementation details
3. **Use realistic test data** that mirrors production scenarios
4. **Minimize mocking** to test actual behavior and catch integration issues
5. **Focus on business value** - test what matters to users and stakeholders
6. **Maintain test quality** through regular review and refactoring
7. **Automate everything** - run tests on every commit and deployment
8. **Document test scenarios** clearly for team understanding
9. **Balance test types** - use unit tests for critical logic, integration tests for workflows
10. **Measure what matters** - focus on test quality and business coverage over raw numbers