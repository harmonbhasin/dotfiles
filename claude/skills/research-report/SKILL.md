---
name: research-report
description: Deep research on a topic via 3-5 parallel web-search agents, synthesized into a structured report with linked sources next to every claim. Use when the user asks for research, a deep dive, a build-vs-buy assessment, a landscape scan, or "what should I know about X" — anything that needs real sources, not vibes.
---

## Task

Answer a research question with a tight, sourced report. The user's question arrives as the skill argument (treat it as the research question verbatim). If no question is provided, ask the user for one — do not guess.

Think hard before launching agents. A bad decomposition wastes 5 agent runs.

## Process

Run these phases in order. Do not skip phases. Do not start writing the report until every agent has returned.

### Phase 1 — Decompose

Break the question into **3-5 independent angles**. Each angle must:
- Cover a *different facet* — not overlapping. Good facets: technical architecture, key players/vendors, tradeoffs, alternatives, real-world adoption, pricing, failure modes, regulatory/legal context.
- Be answerable on its own. If two angles have to share findings, merge them.
- Be specific enough that an agent knows when it's done.

Write the angles down in your reply before launching agents, so the user can course-correct.

### Phase 2 — Launch agents in parallel

Send **one message containing all agent invocations** so they run concurrently. Sequential launches defeat the point.

Use `web-search-researcher` agents (one per angle). Each prompt must include:
- The exact sub-question this agent owns.
- 2-3 starter search queries (specific, not generic — "Cloudflare Workers cold start latency 2025" not "serverless performance").
- Hard requirement: every factual claim returned must carry a `[linked source](url)` inline. No claim, no link, no inclusion.
- Preference for primary sources: official docs, vendor pricing pages, papers, engineering blogs, RFCs. Treat aggregator/SEO sites as last resort.
- Return format: structured markdown with H2/H3 sections matching the angle.
- Scope cap: agent should return in under ~600 words of synthesis. They are researchers, not essayists.

### Phase 3 — Verify before synthesis

Before writing the report, sanity-check the agent outputs:
- Are the linked URLs real? If an agent cites a suspiciously specific stat with a vague link, flag it. Hallucinated citations are the #1 failure mode here.
- Did any agent come back with thin findings? If yes, re-run that one agent with sharper queries before proceeding. Do not paper over gaps in the synthesis.
- Do agents disagree on a fact? Note the conflict explicitly — do not silently pick one.

If verification fails materially, fix it. Do not move to Phase 4 with known bad inputs.

### Phase 4 — Synthesize

Output the report directly in the conversation using **this exact structure**. Do not add or remove sections. Do not write to a file.

```
### Question
One sentence. What we're trying to learn and why it matters.

### Bottom Line
2-3 sentences. The answer, before the evidence. Lead with what the user should do or believe.

### How It Works
Architecture or approach breakdown. Bullets or a table. ASCII diagram only if it actually clarifies.

### Key Players & Implementations
Who does this, what's known about their approach, what's distinctive. Link sources inline.

### Build vs. Buy Assessment
What's available off-the-shelf vs. what you'd need to build. Specific product names, pricing if known, links.

### Open Questions
What we still don't know. Be honest about gaps. Do not pad.
```

If the question genuinely doesn't fit a section (e.g., a pure-technical question with no vendors), write `N/A — [one-line reason]` rather than padding. Better to admit a section is irrelevant than fabricate content.

## Writing Style

- Lead with the point. Evidence after.
- One idea per sentence. Short sentences. No throat-clearing ("It is worth noting that…", "In today's landscape…").
- Smallest word that does the job. "Use" not "utilize." "But" not "however." "Now" not "currently."
- Cut every word that doesn't earn its place.
- Specific beats abstract. "Latency dropped 40ms on p99" beats "performance improved significantly."
- Active voice. Strong verbs. "X causes Y" not "Y is caused by X."
- If a table works, use a table. Do not narrate what the table already says.
- Don't hedge without reason. Say what you know and what you don't. Drop reflexive "may" and "potentially."

## Hard Rules

- Every factual claim has a `[linked source](url)` inline. No bibliography section. No claim ships unsourced — if you can't link it, cut it or label it as inference.
- Primary sources beat summaries. Vendor docs beat blog rehashes beat AI-generated SEO pages.
- Conflicting information gets flagged explicitly, not averaged or silently resolved.
- Output the report in the chat. Do **not** create files. Do **not** offer to save it unless the user asks.
- Stop when the report is written. Do not proactively launch follow-up research, send messages, or take further actions without being asked.

## When NOT to use this skill

- Question is answerable from the codebase or local files — use code-search agents instead.
- User wants a quick fact, not a report — just answer them.
- User explicitly says "no web search" or "from your own knowledge."
