# Codeflow Plan Template

Use this when planning a feature or refactor. The plan should look like
pseudocode composed of types, interfaces, composition, boundaries, call stacks,
and testable increments.

## Plan Shape

```markdown
## Goal

One or two sentences describing the behavior to produce.

## Current Flow

\```text
entrypoint
-> current owner
-> current data shape
-> current side effect
\```

## Proposed Flow

\```text
entrypoint
-> new_or_existing_owner
-> changed data shape
-> downstream owner
\```

## Types And Interfaces

\```python
class ExistingConfig(BaseModel):
    existing_field: str

class NewBoundaryModel(BaseModel):
    source_id: str
    decision_field: str

class ExistingProtocol(Protocol):
    def existing_method(self, value: ExistingType) -> OutputType: ...
\```

## Ownership

| Decision | Owner | Does Not Own |
|---|---|---|
| schema validation | `module.py` | orchestration |
| ordering/retry/progress | `orchestrator.py` | row semantics |

## Data Path

\```text
InputType
-> NewBoundaryModel
-> ExistingOutputType
-> DurableArtifact
\```

## Call Stack

\```text
command or request
-> entrypoint
-> config reader
-> orchestrator
-> owner.method
-> storage or external client
\```

## Invariants

- ...

## Test Plan

- Unit tests for pure interpretation logic.
- Contract tests for schemas and validation.
- Integration tests for orchestration and side effects.
- Regression tests for known failure cases.

## Implementation Slices

1. Add or change data shape and validation.
2. Wire owner into orchestration.
3. Persist or expose the new behavior.
4. Update docs and examples.
```

## Planning Rules

- Start with existing types and interfaces before inventing new ones.
- Define the public boundary first, then pull complexity downward into the
  owner.
- Separate fetching, orchestration, interpretation, and persistence.
- Prefer pure decision functions behind impure orchestration.
- Name which module owns each decision and what callers do not need to know.
- Split work into increments that each compile and have a focused test surface.
- Mark hard-to-reverse design decisions explicitly and pause for alignment.

## Useful Prompts

- "Show the current call stack before proposing changes."
- "Plan this as types/interfaces plus owners and tests."
- "What data shape crosses each boundary?"
- "Which module should own this decision?"
- "What can callers stop knowing after this change?"
- "What tests prove the boundary and the orchestration separately?"
