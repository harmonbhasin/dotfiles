---
name: go
description: Verifies the work just completed end-to-end, simplifies the diff, and opens a PR. Use when the user appends "/go" to a request or invokes /go directly after coding work — it's the "ship it" skill.
---

## Purpose

Close the loop on a coding task. Don't just claim done — prove it works, tighten the code, and put it up for review.

Run these three phases in order. Don't skip phases. Stop and report back if any phase reveals a real problem.

## Phase 1 — Verify end-to-end

Pick the verification path that matches the change. The goal is to exercise the actual user-facing behavior, not just typecheck.

| Change type | How to verify |
|-------------|---------------|
| Backend / API / CLI | Start the server or run the binary via Bash. Hit the endpoint or run the command. Check the response and logs. |
| Frontend / web UI | Start the dev server. Drive the page with the Claude Chromium extension (or Playwright MCP if available). Click through the golden path and one edge case. |
| Desktop app | Use computer use to launch and interact with the app. |
| Library / pure logic | Run the existing test suite. If no tests cover the change, write a focused one before claiming done. |
| Migration / infra | Apply against a scratch/dev target, not prod. Verify the resulting state matches expectations. |

Rules:
- Run typecheck and lint too, but do not treat them as sufficient. They verify code correctness, not feature correctness.
- If you can't verify (no dev server, no browser tooling, sandboxed env), say so explicitly — do NOT claim success.
- Watch for regressions in adjacent features, not just the thing you changed.
- If verification fails, fix the issue and re-verify before moving on. Do not proceed to Phase 2 with a broken build.

## Phase 2 — Simplify

Invoke the `code-simplifier` agent on the diff (the recently modified code, not the whole repo). It tightens for clarity, removes dead branches, collapses needless abstraction, and surfaces inconsistencies.

Apply its suggestions that preserve behavior. Skip ones that expand scope beyond the task. Re-run Phase 1 verification if simplification touched runtime paths.

## Phase 3 — Put up a PR

1. Check `git status` and `git diff` so the commit reflects only intended changes.
2. Stage files explicitly by name (no `git add -A`) — avoid sweeping in env files, build artifacts, or unrelated edits.
3. Commit with a message that explains *why*, not just what. Match the repo's recent commit style (`git log` to check).
4. Push the branch.
5. Open the PR with `gh pr create`. Title under 70 chars; body has a Summary (1-3 bullets) and a Test plan (bulleted checklist of what you actually verified in Phase 1).
6. Return the PR URL.

If the user is on `main`/`master`, create a feature branch first — never commit work-in-progress directly to the trunk.

## Output back to the user

End with a tight summary:
- What was verified and how (one line).
- What simplifier changed, if anything (one line).
- PR URL.

If a phase was skipped or failed, lead with that — don't bury it.

## When NOT to run /go

- The task is exploratory ("what would it take to…") with no code changes.
- The user is mid-debugging and just wants a checkpoint, not a PR.
- Changes touch shared/production state in ways that need explicit human review before pushing.

In those cases, do Phase 1 verification only and ask before committing or pushing.
