---
name: research-codebase
description: Deep codebase research via parallel sub-agents, synthesized into a structured report with file:line citations next to every claim. Use when the user asks how something works in *this* repo, how components connect, where a pattern is implemented, or for an architectural deep dive — anything that needs concrete file paths, not guesses.
---

## Task

Answer a question about the current codebase with concrete evidence — file paths, line numbers, and architectural insight. Output the findings directly in the chat. Do not write to a file.

Treat the user's request as the research question. If no question came in, reply with:

> "Ready to research the codebase. What's the question or area of interest?"

Then wait. Do not guess.

## Process

Phases run in order. Do not collapse them.

### Phase 1 — Read what the user already pointed at

If the user mentioned specific files (tickets, docs, JSON, configs, prior research):
- Read each one **fully** with `Read` (no `limit`/`offset`).
- Read them in the main context, before spawning any agents. You need this context to write good agent prompts.

Skip this phase only if no files were mentioned.

### Phase 2 — Decompose

Break the question into 3-6 independent research areas. Each area must:
- Target a different facet — *where it lives*, *how it works*, *who calls it*, *what it connects to*, *how it's tested*, *how it's configured*.
- Be answerable on its own. If two areas overlap, merge them.
- Be specific enough that the agent knows when it's done.

Write the areas down in the chat before launching agents so the user can course-correct.

Use `TaskCreate` to track the areas if there are 3+; otherwise keep it inline.

### Phase 3 — Spawn parallel agents

Send **all agent calls in a single message** so they run concurrently. Sequential launches waste minutes.

Pick agents by job:

| Job | Agent |
|-----|-------|
| Find *where* things live (files, configs, components) | `codebase-locator` |
| Understand *how* specific code works | `codebase-analyzer` |
| Find similar patterns or usage examples | `codebase-pattern-finder` |
| Broad exploration when the area is fuzzy | `explore-opus` |
| External/web context (only if user asked) | `web-search-researcher` |

Per-agent prompt rules:
- State the exact sub-question the agent owns.
- Tell it the *type* of answer you need: file paths, code excerpts, call graph, config values.
- Require concrete file:line references with every finding.
- Cap output: ~500 words of synthesis. Agents are scouts, not novelists.
- Do **not** instruct *how* to search — these agents know their craft. Tell them *what* to find.
- Read-only. No edits, no writes, no shell side effects.

### Phase 4 — Verify before synthesis

Before writing the report, sanity-check the agent outputs:
- Pick 2-3 cited file:line references and `Read` them. If a citation is wrong or fabricated, that agent's findings need a re-run.
- Did any agent come back thin or off-topic? Re-run that one with a sharper prompt before proceeding.
- Do agents disagree on how something works? Resolve it by reading the code yourself — do not paper over conflicts.

If verification surfaces a real gap, fix it. Do not move to Phase 5 with known bad inputs.

### Phase 5 — Synthesize

Output the report directly in the chat using **this exact structure**. Do not add or remove sections. Do not write to a file.

```
### Question
<user's question, verbatim>

### Bottom Line
<3-6 sentences. The answer, before the evidence. Lead with what the user should now know or do.>

### Detailed Findings

#### <Component / Area 1>
- <Finding> (`path/to/file.ext:123`)
- <Connection to other components>
- <Implementation detail worth knowing>

#### <Component / Area 2>
...

### Code References
- `path/to/file.py:123` — <what's there>
- `another/file.ts:45-67` — <what the block does>

### Architecture Insights
<Patterns, conventions, design decisions discovered. Skip if there's nothing real to say.>

### Open Questions
<What we still don't know. Be honest about gaps.>
```

Rules for content:
- Every factual claim has a `path:line` citation. No claim, no cite, no inclusion.
- Live codebase findings are the source of truth. If a doc/comment in the repo contradicts the code, trust the code and flag the doc.
- Don't recommend implementations. This skill researches, it does not propose changes.
- If a section has no real content, write `N/A — <one-line reason>`. Do not pad.

### Phase 6 — Follow-up questions

If the user asks a follow-up on the same topic:
- Spawn fresh agents for the new question — do not rely on prior findings being complete.
- Output a new report in the same format. Lead the Bottom Line with what changed or what's new.

## Hard Rules

- Always read user-mentioned files fully *before* spawning agents.
- Always launch agents in parallel (single message, multiple `Agent` tool calls).
- Always wait for every agent to return before synthesizing.
- Never propose or write implementation code in this skill — research only.
- Output in the chat. Do not create files. Do not offer to save the report unless the user asks.
- Stop after the report is written. Do not proactively start related research, refactors, or PRs.

## When NOT to use this skill

- Question is about the *outside world* (vendors, papers, "what's the standard approach to X") — use `research-report` instead.
- User wants a quick fact answerable in seconds — just answer them.
- User is mid-debugging and wants a fix, not research — help them debug.
