# Code Design Principles

- Apply YAGNI: Build only what's needed now
- Follow SOLID principles when they add value (not dogmatically)
- Prefer simplicity (KISS) over premature abstraction
- Eliminate duplication (DRY) only when it's actual duplication, not coincidental similarity

# Before Writing Code

- Clarify requirements if ambiguous
- Identify the simplest solution that could work
- Consider maintenance implications
- Assess if existing code can be reused/adapted

# Code Quality Standards

- Handle errors explicitly - no silent failures
- Validate inputs at boundaries
- Write self-documenting code (clear naming > comments)
- Keep functions focused and small
- Make dependencies explicit

# Testing

- Write tests for behavior, not implementation
- Test edge cases and error paths
- Use appropriate test framework for the language

# Security & Performance

- Never trust external input
- Consider performance implications for scale
- Profile before optimizing

# Code Review Mindset

- Question every abstraction
- Challenge complex solutions
- Suggest simpler alternatives with tradeoffs
