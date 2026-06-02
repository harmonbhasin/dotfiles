---
name: diataxis-docs
description: Write, classify, critique, or restructure documentation with the Diataxis framework (tutorials, how-to guides, reference, explanation). Use when the user wants to write or improve docs, decide which kind of doc to write, document an API or feature, write a getting-started or installation guide, or clean up a messy docs site. Trigger on phrases like "write a getting-started guide", "document this", "document the API", "is this a tutorial or a how-to", "what kind of doc should this be", "how should I structure my docs", "my docs are a mess", "review my docs", "audit our documentation". Also trigger when the user shares a doc page and asks whether it is the right type or mixes concerns.
---

# Diataxis docs

Most bad documentation is bad because one page tries to do several jobs at once: a tutorial that breaks to explain theory, an API reference padded with opinions, a how-to guide that starts teaching from scratch. [Diataxis](https://diataxis.fr/) cuts through this by recognizing **four distinct kinds of documentation**, each serving one user need. Your job is to put the right content in the right type and keep the types from bleeding into each other.

The four types come from two questions about the reader: are they **studying** (acquiring skill) or **working** (applying skill), and does the content serve **action** (doing) or **cognition** (knowing)? ([foundations](https://diataxis.fr/foundations/))

| Type | Reader is | Serves | The one-line tell |
|------|-----------|--------|-------------------|
| **Tutorial** | studying | learning by doing | "Could a total beginner follow this start to finish and succeed every time?" |
| **How-to guide** | working | reaching a goal | "Does it help someone who already knows the basics get one real task done?" |
| **Reference** | working | looking up facts | "Is it something you consult mid-task, like a map or a dictionary?" |
| **Explanation** | studying | understanding *why* | "Does it make sense to read away from the keyboard, over coffee?" |

Full conventions for each type live in `references/`. Read the matching file before writing or critiquing that type.

## Step 1: Pick the mode

Infer the mode from the request. Ask via `AskUserQuestion` only if it is genuinely unclear.

- **Write a new doc:** the user wants a page that does not exist yet.
- **Critique / improve an existing doc:** the user shares a page or points at a file. *Default to critique first; rewrite only when asked* (see Output behavior).
- **Audit a doc set:** the user wants the whole `docs/` tree assessed. Read `references/quality-and-structure.md` and follow its audit workflow.

## Step 2: Choose the type with the compass

If the user already named the type ("write a tutorial for X"), trust them but sanity-check it against the tell above. If they are unsure, or the content seems mismatched, use the compass. ([compass](https://diataxis.fr/compass/), [map of needs](https://diataxis.fr/needs/))

Ask: **what does the reader need right here?**

| If the reader needs... | the content is... | write a... |
|------------------------|-------------------|------------|
| to learn by doing, guided, safely | action + acquisition | **Tutorial** |
| to accomplish a specific goal | action + application | **How-to guide** |
| factual information while working | cognition + application | **Reference** |
| to understand, see the bigger picture | cognition + acquisition | **Explanation** |

The axes are tools, not cages. Apply them at any scale, from a whole page down to a single paragraph, and do not get hung up on the exact labels: they exist to correct your intuition when a page feels "off," not to win arguments. ([foundations](https://diataxis.fr/foundations/))

When a single requested page clearly needs to serve two needs (a "getting started" that is part tutorial, part reference), say so and propose splitting it. That recommendation is often the most valuable thing this skill produces.

## Cardinal rules

These are the high-leverage principles. Most documentation problems are a violation of one of them.

1. **One document, one type.** Mixing types is the number-one failure. When you find it, name it and separate the strands. ([reference vs explanation](https://diataxis.fr/reference-explanation/))
2. **Each type has a job, and only that job:**
   - Reference **describes**, and *only* describes. No teaching, no persuasion, no opinion. ([reference](https://diataxis.fr/reference/))
   - How-to guides **direct** a competent user to a goal. No teaching from scratch. ([how-to](https://diataxis.fr/how-to-guides/))
   - Tutorials **teach by doing**, under a teacher's full responsibility for the outcome. ([tutorials](https://diataxis.fr/tutorials/))
   - Explanation **discusses**: the why, the history, the alternatives. It does not instruct. ([explanation](https://diataxis.fr/explanation/))
3. **Tutorials remove choice; how-to guides offer it.** A tutorial is one carefully managed path with no forks. A how-to guide branches with the real world ("if you want X, do Y"). ([tutorials vs how-to](https://diataxis.fr/tutorials-how-to/))
4. **Write from the user's perspective, not the machinery's.** Especially in how-to guides: organize around what the user is trying to do, not around what the software happens to expose. ([how-to](https://diataxis.fr/how-to-guides/))

## How to work: little and often

Diataxis is a way of working, not a structure to install. Do not try to design the whole docs tree up front or block on a grand plan. ([how to use Diataxis](https://diataxis.fr/how-to-use-diataxis/))

- Pick one concrete thing, improve it, and stop there. Small correct moves compound.
- Never leave empty placeholder sections or "TODO" stubs. A change should be a real improvement, complete enough to publish even if the doc is not finished.
- When auditing, the output is a *prioritized next step*, not a six-month rewrite plan.

## Output behavior

**New doc.** Read the matching `references/<type>.md`, then draft the page following its rules. Write the file into the project's `docs/` folder (create the folder or the needed subpath if missing). Choose a filename that matches the type and topic (for example `docs/tutorials/getting-started.md`, `docs/how-to/configure-auth.md`, `docs/reference/cli.md`, `docs/explanation/architecture.md`). If the project has an existing docs layout, follow it instead of imposing a new one.

**Existing doc: critique first.** Do not rewrite unprompted. Read the matching reference file, then diagnose and deliver a critique in chat using this shape:

```
## Verdict
[1-2 sentences. What type is this trying to be? Is it conforming, or mixing types? What is the single biggest problem?]

## Issues, by impact
1. **[Label]:** [what is wrong, specific to this doc, tied to a Diataxis rule]
   *Fix:* [concrete suggestion]
2. ...

## Quick wins
[Optional bullets: small, scannable fixes.]
```

Order issues by impact: wrong-type or mixed-type problems first (they are structural), then type-rule violations, then local fixes. Rewrite to a file in `docs/` only when the user says to.

**Audit a doc set.** Follow the workflow in `references/quality-and-structure.md`. Output a `page → current type → issues → proposed action` table plus the single best next step.

## When to read each reference

Read one level deep, only what the task needs:

- `references/tutorials.md`: writing or critiquing a tutorial / getting-started / lesson.
- `references/how-to-guides.md`: writing or critiquing a how-to / guide / recipe.
- `references/reference.md`: writing or critiquing API docs, CLI docs, config tables, any lookup material.
- `references/explanation.md`: writing or critiquing a discussion / background / "why" / architecture / design-rationale page.
- `references/quality-and-structure.md`: quality model, doc-set audits, and how to structure navigation and hierarchies.

## Out of scope

This skill owns *which type a doc is and whether it conforms to Diataxis*. Sentence-level prose polish and AI-slop removal are separate concerns covered by other tooling; do not duplicate them here. Avoid em dashes in anything you write for this user.
