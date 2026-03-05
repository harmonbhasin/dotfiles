---
description: Deep research on a topic using parallel web-search agents, outputting a structured report
argument-hint: [research question]
model: opus
---

# Research Report

Ultrathink about the research question below, then execute.

## Question
$ARGUMENTS

## Process

1. **Decompose** the question into 3-5 independent research angles. Each angle should target a different facet: technical architecture, key players, tradeoffs, alternatives, real-world usage.

2. **Launch 3-5 parallel web-search-researcher subagents**, one per angle. Each agent prompt must:
   - State the specific sub-question it's answering
   - List 2-3 search queries to start with
   - Require linked sources next to every claim
   - Return findings in structured markdown

3. **Wait for all agents to complete.** Do not write the report until every agent has returned.

4. **Synthesize** into this exact format:

---

### Question
One sentence. What we're trying to learn and why.

### Bottom Line
2-3 sentences. The answer, before the evidence.

### How It Works
Architecture or approach breakdown. Use bullet points or a table. Diagrams in ASCII if useful.

### Key Players & Implementations
Who does this, what's known about their approach. Link sources inline.

### Build vs. Buy Assessment
What's available off-the-shelf vs. what you'd need to build. Include specific product names and links.

### Open Questions
What we still don't know. Be honest about gaps.

---

## Writing Style
- Write for an intelligent reader in a rush. Lead with the point, then the evidence.
- One idea per sentence. Short sentences. No throat-clearing ("It is worth noting that...").
- Use the smallest word that does the job. "Use" not "utilize." "But" not "however."
- Cut every word that doesn't earn its place. If removing it changes nothing, remove it.
- Be specific. Numbers, names, and examples beat abstractions. "Latency dropped 40ms" not "performance improved significantly."
- Use active voice and strong verbs. "X causes Y" not "Y is caused by X."
- If you can say it in a table, don't say it in prose.
- No hedging without reason. Say what you know and what you don't. Don't soften everything with "may" and "potentially."

## Rules
- Every factual claim must have a [linked source](url) inline. No bibliography section.
- Prefer primary sources (docs, papers, official blogs) over summaries.
- If agents return conflicting information, flag the conflict explicitly.
- Do NOT create any files. Output the report directly in the conversation.
