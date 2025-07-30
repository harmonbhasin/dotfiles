# Write Feature Documentation

Create comprehensive documentation in the `docs/` folder for the feature just implemented. The documentation must be so clear and complete that a developer unfamiliar with the codebase can understand and modify the feature.

## Documentation Structure

Create a markdown file in `docs/features/[feature-name].md` with these sections:

### 1. Feature Overview (Self-Contained)
Write a complete introduction that requires no prior context:
- What problem does this feature solve?
- What is the expected behavior?
- Who are the users of this feature?
- Include a simple example showing the feature in action

### 2. Technical Architecture
Document the implementation details explicitly:
- List ALL files involved (with exact paths)
- Describe each component's responsibility
- Show the data flow with concrete examples
- Include any state management or side effects

### 3. Integration Guide
Provide step-by-step instructions for using/modifying:
- Exact import statements needed
- Complete code examples (not fragments)
- All required dependencies and setup
- Configuration options with defaults shown

### 4. API Reference
Document every public interface:
- Function signatures with all parameters
- Type definitions (show the actual types)
- Return values and what they mean
- Include edge cases and error conditions

### 5. Error Handling
Be explicit about what can go wrong:
- List exact error messages that might appear
- Explain what causes each error
- Provide solutions for each error case
- Show error handling code examples

### 6. Testing Guide
Help developers verify their changes:
- How to run existing tests
- What each test validates
- How to add new test cases
- Expected test output examples

### 7. Common Modifications
Anticipate what developers might need to change:
- "To add a new [X], modify these files..."
- "To change the behavior of [Y], update..."
- Include complete before/after examples

### 8. Debugging Tips
Make troubleshooting explicit:
- Common symptoms and their causes
- Useful log locations and what to look for
- Debug commands or tools
- "If you see X, check Y"

## Writing Principles

1. **No Implicit Knowledge**: Assume the reader knows nothing about the codebase
2. **Complete Examples**: Never show fragments - always complete, runnable code
3. **Exact Paths**: Use full file paths from project root
4. **Concrete Over Abstract**: Show actual values, not placeholders
5. **Test Everything**: Include commands to verify each claim

## Documentation Checklist

Before finishing, verify:
- [ ] A new developer could implement a similar feature using only this doc
- [ ] All code examples can be copy-pasted and run
- [ ] Every technical term is defined on first use
- [ ] File paths are absolute from project root
- [ ] Error messages are quoted exactly
- [ ] No references to "above" or "below" - each section stands alone

## Example Structure

```markdown
# User Authentication Feature

## Feature Overview

This feature provides secure user authentication using JWT tokens. Users can register, login, and access protected resources.

**Problem it solves**: Restricts access to sensitive data to authenticated users only.

**Example usage**:
```typescript
// Register a new user
const user = await auth.register({
  email: 'user@example.com',
  password: 'SecurePass123!'
});

// Login and get token
const { token } = await auth.login({
  email: 'user@example.com',
  password: 'SecurePass123!'
});
```

[Continue with remaining sections...]
```

Remember: Write as if explaining to someone who has never seen this codebase before but needs to modify it tomorrow.