## Code

Mimic the style of the surrounding code. Write the simplest version that works. If you can delete code and tests still pass, delete it.

Docstrings should explain the algorithm, not just the interface. A skimming reader should understand *how* it works, not just what it returns.

Comments should describe things at a **different level of abstraction** than the code. Interface comments go higher: describe *what* and *why*, not *how*. Implementation comments go lower: explain non-obvious details, invariants, or reasoning that the code itself can't convey. If a comment says the same thing as the code next to it, delete it.

Design principles (apply during code review and implementation):
- **Modules should be deep**: simple interfaces hiding complex functionality.
- **Hide information aggressively**: one source of truth per design decision.
- **Pull complexity downward**: make the caller's life easy, even if the implementation is harder.
- **Define errors out of existence**: design APIs so exceptional conditions can't arise.

Use descriptive, self-explanatory names. A reader should understand what a variable holds or a function does without tracing through the code.

Separate data-fetching from decision logic. Functions that interpret data should be pure and never make external calls. Design for testability: small functions, no hidden dependencies, easy to test in isolation. Use dependency injection so external systems (DBs, APIs, clocks) can be swapped for fakes in tests.

Prefer small, modular files over large ones. Split by responsibility; if a file is doing several unrelated things, break it up.

## Data Modeling & External APIs

Never add default values to schema fields without explicit user approval. Defaults hide failures and cause silent bugs.

External API response types must account for null on any field the API can actually return as null. Inaccurate types bypass the type system and cause runtime crashes.

Before building something new, check whether existing API calls or data sources already contain the information you need.

## Testing

Test cases should represent real-world examples, not synthetic data. If you're testing against external behavior, use realistic inputs that exercise the actual edge cases.

## Pre-Commit Review

Before committing, run the `complexity-reviewer` agent, the `code-reviewer` agent, and the `code-simplifier` agent on the changes. The complexity reviewer checks for unnecessary complexity, shallow modules, information leakage, and other design red flags. The code reviewer checks for correctness, security, and maintainability. Address any issues they raise before committing.

## Agent Shorthand

- "Look at the issues" → GitHub issues
- "Look at pane N" → tmux pane, use `tmux capture-pane -t <pane_number> -p -S -100`
- Always read the whole file, don't read parts of it

## Documentation

Docs go in the right place: README (quick-start), ONBOARDING (first day), DEVELOPERS (reference). See DEVELOPERS.md for details.

## Architecture Decision Records

Write an ADR when a decision is hard to reverse, affects multiple components, or has clear rejected alternatives. Use Nygard's template (Title, Status, Context, Decision, Consequences). Number sequentially, never edit. Supersede instead.

## Agent-Driven Development

Don't make design decisions unilaterally. Surface trade-offs, propose options, and wait for alignment before implementing anything that's hard to reverse. Implementation is yours; design decisions are ours.

1. **Document the feature**: goal, behavior, success criteria
2. **Break into testable pieces**: each piece builds on the last, maps to one PR
3. **Plan with the agent**: iterate until solid. Ask: "How will you test this?" and "What patterns should this follow?"
4. **Consider alternatives**: before picking an approach, sketch 2–3 different abstractions or system designs and compare trade-offs.
5. **Research first**: unless told otherwise, research the subject (docs, prior art, existing code) before designing or implementing.

Tips: be specific, point to existing patterns ("follow the pattern in X" beats explaining from scratch), keep pieces small.

## Git Workflow

Branch naming: `type/description` (lowercase, kebab-case). Types: `feature/`, `fix/`, `hotfix/`, `refactor/`, `chore/`, `docs/`.

For large features, use **stacked PRs**: break work into small, dependent PRs that each represent a working, testable increment. Each PR should be reviewable on its own.

**Squash merge** feature branches to keep history clean. Use regular (non-squash) merges for release merges to preserve development history.

## Language-Specific

### Python

- Add packages with `uv add <package>`, not by editing `pyproject.toml` directly. Let `uv` manage versions and the lockfile.
- Use `uv run` to execute scripts and commands within the project environment.

### TypeScript

- Add packages with `pnpm add <package>` (or `npm install`, `yarn add`, whichever the project uses). Don't manually edit version strings in `package.json`.
