# Codeflows Template

Use this when creating or revising a durable codeflow document such as
`docs/codeflows.md`.

## Shape

```markdown
# Codeflows

This page is the implementation reference for common changes. It names entry
points, call stacks, owning modules/classes, data shapes, side effects,
invariants, and tests.

Use architecture docs for the system model and design reasons. Use this file
when changing code.

## Contents

- [Planning Skeleton](#planning-skeleton)
- [Boundary Rules](#boundary-rules)
- [Flow Index](#flow-index)
- [Type Map](#type-map)
- [Type Diagrams](#type-diagrams)
- [Flow Name](#flow-name)
- [Fast Navigation](#fast-navigation)

## Planning Skeleton

\```text
Change:
Entry point:
Owning module:
Existing types:
New or changed data shape:
Call stack:
Artifact side effects:
Invariants:
Tests:
\```

## Boundary Rules

- `<entrypoint>` owns argument parsing and output formatting.
- `<orchestrator>` owns ordering, branching, retries, progress, and composition.
- `<stage module>` owns row schemas, IDs, validation, and writes.
- `<store>` owns storage layout and IO.
- `<pure module>` owns decision logic and has no external calls.

## Flow Index

| Change | Entry Point | Primary Owners | Data Shapes | Tests |
|---|---|---|---|---|
| ... | ... | ... | ... | ... |

## Type Map

| Type or Function | Module | Consumes | Produces | Owns |
|---|---|---|---|---|
| ... | ... | ... | ... | ... |

## Type Diagrams

\```text
SourceType
`-- Owner
    `-- ProducedType
        |-- important_field
        `-- important_field
\```

## Flow Name

Use for ...

Entry stack:

\```text
external command or request
-> entrypoint
-> config/parser
-> orchestrator
-> stage owner
\```

Stage branches:

\```text
orchestrator_step
-> read_existing
   [hit] return typed rows
   [miss] stage_owner.method
          -> external client or pure helper
          -> write typed rows
\```

Data path:

\```text
InputShape -> IntermediateShape -> OutputShape
\```

Side effects:

| Stage | Files, network calls, DB writes, emitted events |
|---|---|
| ... | ... |

Invariants:

- ...

Tests:

- ...

## Fast Navigation

| Change | Start Here | Boundary | Then Check | Tests |
|---|---|---|---|---|
| ... | ... | ... | ... | ... |
```

## What To Include

- Public entry points: CLI commands, API routes, jobs, scripts, event handlers,
  workers.
- Deep owners: modules/classes that own schemas, persistence, external calls,
  core decisions, retries, identity, and validation.
- Data handoff types: request models, config models, domain records, event
  payloads, DB rows, manifest files, API responses.
- Branches that affect behavior: cache hit/miss, retries, validation, fallback,
  streaming state, background work, missing upstream artifacts.
- Side effects: filesystem, database, queue, network, logs, metrics, artifacts.
- Tests that protect each flow.

## What To Omit

- Every helper function.
- Historical migration notes.
- Deep prose explaining why the architecture exists.
- Generic descriptions that do not name code.
- Unverified guesses about ownership.
