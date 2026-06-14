---
name: map-codeflows
description: Map an unfamiliar or evolving codebase into implementation-facing codeflow docs and plans. Use when asked to create or improve docs/codeflows.md, explain how code is implemented with classes/types/interfaces and call stacks, produce an implementation map, plan a feature using pseudocode types and boundaries, identify ownership boundaries, or help agents navigate a codebase faster than normal architecture docs.
---

# Map Codeflows

Use this skill to turn code into an implementation map. The output is not a
high-level architecture essay and not exhaustive API reference. It is a working
map for humans and agents who need to change code: entry points, call stacks,
types, composition, boundaries, side effects, invariants, and tests.

## Output Modes

- **Codeflow document:** Create or update `docs/codeflows.md` unless the repo has
  another obvious place. Read `references/codeflows-template.md`.
- **Implementation plan:** Produce a plan shaped around types, interfaces,
  module boundaries, call stacks, and testable increments. Read
  `references/plan-template.md`.
- **Diagram pass:** Add or refine ASCII diagrams that show containment,
  composition, data handoff, and runtime flow. Read
  `references/diagram-patterns.md`.

Multiple modes can apply. For example, a user asking to plan a feature and
document how it fits may need both the plan template and diagram patterns.

## Workflow

1. Read project instructions first.
2. Inspect existing docs: `README`, architecture/design docs, developer docs,
   runbooks, existing `docs/codeflows.md`, and relevant PR plans.
3. Find entry points with `rg --files`, package manifests, CLIs, route handlers,
   workers, jobs, tests, and Makefile or task files.
4. Read the relevant implementation files. Prefer public modules, config models,
   data models, orchestrators, storage boundaries, and tests.
5. Separate the codebase into flows. Name each flow by the change a developer
   would make: generation, training, checkout, auth, billing, sync, indexing,
   runtime scoring, and similar.
6. For each flow, capture:
   - entry point
   - call stack
   - owning modules/classes/functions
   - data shapes crossing boundaries
   - side effects and durable artifacts
   - invariants and "does not own" boundaries
   - tests to run
7. Use both lookup tables and ASCII diagrams when they help different tasks:
   tables for fast lookup, diagrams for composition and handoff.
8. Keep `architecture.md` or design docs focused on "why"; keep codeflow docs
   focused on "where and how the code is wired."

## Boundary Rules

- Prefer the repo's terms over inventing new abstractions.
- Do not document every function. Document stable implementation boundaries and
  call paths that help with changes.
- Keep call stacks nominal but mark important branches: cache hit/miss, async
  fan-out, retries, validation failures, missing upstream data, persistence.
- Identify the deepest owner for a decision. A caller can orchestrate work
  without owning row schemas, ID generation, storage layout, retry policy, or
  business rules.
- Treat tests as part of the map. A codeflow section without tests is usually
  incomplete.
- For plans, surface hard-to-reverse design choices and wait for alignment
  before implementing them.

## Good Codeflow Artifacts

Good outputs are:

- scannable during implementation
- concrete about modules and classes
- explicit about data crossing boundaries
- clear about what each layer does not own
- useful to a fresh agent without recreating the whole codebase search
- short enough that a reader can find the right section quickly

Bad outputs are:

- broad architecture summaries
- exhaustive API inventories
- narratives that hide the call stack
- diagrams without owning modules or tests
- plans that describe tasks but not the types, interfaces, and boundaries being
  changed

## Resources

- `references/codeflows-template.md`: structure for a durable
  `docs/codeflows.md` implementation reference.
- `references/plan-template.md`: structure for implementation plans based on
  pseudocode types, interfaces, composition, boundaries, and call stacks.
- `references/diagram-patterns.md`: ASCII diagram patterns for containment,
  handoff, call stacks, and runtime state.
