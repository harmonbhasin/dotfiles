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

Prefer cohesive files with predictable flow over premature splitting. Split a file only when it has more than one clear responsibility or when keeping it together makes the public boundary harder to understand.

Use file length as a review trigger, not a rule. When a module approaches roughly 500 lines, pause and ask whether it still has one clear boundary, predictable internal structure, and a small public surface. Split only when the file has multiple responsibilities, the public boundary becomes harder to understand, or extracting a deeper helper module would hide meaningful complexity. Keep a long cohesive module together if splitting would create shallow pass-through files or scatter one concept across places.

### Readability Structure

When a file grows, first improve its internal structure:
- Put the public API first, then the main workflow, then helper functions.
- Use light section comments for scanability when they clarify the flow, such as `# Public models`, `# Main workflow`, `# Parsing`, or `# Helpers`.
- Do not add decorative banners or comments that repeat what the function names already say.

Every module should start with an orienting docstring. It should briefly explain:
- what boundary the file owns,
- what it consumes,
- what it produces,
- how the public classes or functions connect,
- and a small concrete example when the boundary is data-shaped.

When adding or changing public classes in a module, update the relevant docstring so a reader can understand the class relationships in natural language before reading method bodies. Prefer existing project vocabulary from the PR plan, interface spec, and surrounding code. If a new term is necessary, define it at the boundary where it first appears; otherwise use the established name instead of creating a parallel abstraction.

## Data Modeling & External APIs

Never add default values to schema fields without explicit user approval. Defaults hide failures and cause silent bugs.

External API response types must account for null on any field the API can actually return as null. Inaccurate types bypass the type system and cause runtime crashes.

Before building something new, check whether existing API calls or data sources already contain the information you need.

## Logging & Observability

Add logging anywhere it aids debugging, especially around code paths where bugs have already surfaced. Err toward more signal, not less.

All logs, client and server, should land in one place an agent can read easily (a single file or a unified stream), not scattered across separate consoles or terminals. The point is that debugging an issue means reading one source, not stitching several together.

## Testing

Test cases should represent real-world examples, not synthetic data. If you're testing against external behavior, use realistic inputs that exercise the actual edge cases. If you're unsure whether an example could actually occur in this code, ask before writing it rather than inventing a plausible-looking case.

Tests should explain the behavior they protect in concrete project terms. For each test, include a short docstring or comment that says what case the test represents and what must remain true. Prefer domain language over generic testing language.

Good:
`"""A markdown file with frontmatter is rejected because metadata comes from the path."""`

Avoid:
`"""Catches regressions in parser validation."""`

## Pre-Commit Review

Before committing, run the `complexity-reviewer` agent, the `code-reviewer` agent, and the `code-simplifier` agent on the changes. The complexity reviewer checks for unnecessary complexity, shallow modules, information leakage, and other design red flags. The code reviewer checks for correctness, security, and maintainability. Address any issues they raise before committing.

## Agent Shorthand

- "Look at the issues" → GitHub issues
- "Look at pane N" → tmux pane, use `tmux capture-pane -t <pane_number> -p -S -100`
- Always read the whole file, don't read parts of it

## Documentation

Docs go in the right place: README (quick-start), docs/onboarding.md (first day), docs/developers.md (reference).

Keep onboarding/first-run docs to one successful path from zero to a concrete result. Move branches, tuning, exhaustive config, environment variants, and troubleshooting out unless they are required for that first success.

Put durable operational knowledge in developer/operator reference: setup variants, command tables, config knobs, inspection commands, failure modes, and tuning guidance.

When shortening docs, preserve useful detail by relocating it to the right doc and linking to it at the point of need.

Use realistic examples: code samples, inputs, and scenarios that could actually occur in this codebase, not toy `foo`/`bar` placeholders. If you're unsure whether an example is realistic, ask.

Write docs for the current design, not its history. Don't mention what changed, flag deprecated approaches, or hedge for backward compatibility. The reader has never seen the previous design, so docs (and code) should read as if it never existed. Exception: when I explicitly ask you to explain why something is designed the way it is.

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

## Common Commands

When a project has commands people run repeatedly (build, test, lint, run, format, deploy), add a `Makefile` that wraps them with short, memorable targets (`make test`, `make run`). It gives humans and agents one discoverable place to find how to operate the project.

## Long-Running Operations

Show progress for any operation that runs longer than a few seconds, so it's clear the job is alive and how far along it is. Use a progress bar or periodic logging of how much is done, how much remains, and a rough rate. Never leave a multi-minute operation silent. For example, an ML training loop should log step/epoch, loss, and throughput; a bulk download or data migration should report items completed out of the total.

## Language-Specific

### Python

- Add packages with `uv add <package>`, not by editing `pyproject.toml` directly. Let `uv` manage versions and the lockfile.
- Use `uv run` to execute scripts and commands within the project environment.

### TypeScript

- Add packages with `pnpm add <package>` (or `npm install`, `yarn add`, whichever the project uses). Don't manually edit version strings in `package.json`.
