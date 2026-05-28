---
name: Bug Report
about: Report a bug
labels: ["bug"]
---

## Bug Summary
<!-- One sentence: what's broken and where. -->


## Current Behavior
<!-- What happens now? Include error messages, console output, screenshots, or HTTP status codes. -->


## Expected Behavior
<!-- What should happen instead? -->


## Steps to Reproduce
<!-- Minimal steps, URL, or test case that triggers the bug. Include browser + auth state if relevant. -->
1.
2.
3.

## Acceptance Criteria
<!-- Testable conditions that define "fixed." Each should be independently verifiable. -->
- [ ]
- [ ]
- [ ] `pnpm lint`, `pnpm typecheck`, and `pnpm run build` all pass

## Technical Pointers
<!-- File paths, function names, relevant code. Be as specific as possible. -->

Files likely involved:
-

Relevant patterns / references:
-

## Scope & Boundaries

Do not modify (unless the bug is in one of these):
- `convex/schema.ts` — production schema
- `convex/_generated/**` — generated files
- `convex/auth.ts` / `middleware.ts` — auth gating
- `src/data/roles.ts` ↔ `VALID_ROLE_SLUGS` in `convex/applications.ts` — keep slugs in sync
