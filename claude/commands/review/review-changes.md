---
allowed-tools: Bash(git status:*)
description: Review changes
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`

## Your task

Review the above changes, ultrathink.

First verify correctness (does it solve the problem, handle edge cases, avoid race conditions?), then ensure clarity (would a junior dev understand this in 6 months?), and finally check architectural fit (consistency with existing patterns, appropriate abstraction level). Run through a basic checklist: adequate test coverage, proper error handling, no obvious security vulnerabilities, and consideration of performance implications for hot paths. Approach reviews with curiosity rather than authority—ask "what happens if X?" instead of demanding fixes, focus on the code not the coder, and suggest alternatives with clear tradeoffs. Avoid bikeshedding on style issues that linters should catch, reviewing to boost your ego, or blocking on non-critical issues. Apply the 80/20 rule: spend most effort on logic, correctness, and security rather than style or premature optimization. Pick 2-3 major issues to address rather than drowning the author in 20 nitpicks.
