# Diagram Patterns

Use ASCII diagrams for relationships that are hard to scan in tables. Keep them
small and factual. A diagram should name real types, owners, and fields.

## Containment

```text
ParentType
`-- child_records: tuple[ChildType, ...]
    `-- ChildType
        |-- id
        |-- source_field
        `-- decision_field
```

Use for config models, manifests, aggregate roots, AST-like structures, and
parsed source records.

## Data Handoff

```text
SourceType
`-- OwnerA
    `-- IntermediateType
        |
        v
    OwnerB
    `-- OutputType
```

Use for pipelines, request processing, code generation, ETL, indexing, training,
calibration, and artifact creation.

## Call Stack With Branches

```text
entrypoint
-> orchestrator
-> read_existing
   [hit] return ExistingType
   [miss] owner.build
          -> external_client.call
          -> store.write
```

Use for cache/reuse, retries, missing upstream artifacts, fallback paths,
feature flags, and validation branches.

## Interface Boundary

```text
Caller
-> Protocol.method(input: InputType) -> OutputType
   ^ implemented by RealClient
   ^ implemented by FakeClient
```

Use when dependency injection makes tests possible or when real external systems
sit behind small protocols.

## Runtime State

```text
start(input)
-> State(user_input, accumulated_output="", score=0.0)

step(State, delta)
-> recompute or update score
-> State(accumulated_output += delta, score=next_score)
```

Use for streaming, incremental parsing, synchronization, background jobs, and
state machines.

## Storage Boundary

```text
DomainType
-> Store.write_domain_type(id, rows)
-> durable path/table/topic

durable path/table/topic
-> Store.read_domain_type(id)
-> DomainType
```

Use when storage layout should be hidden from callers.
