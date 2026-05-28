# Developer Guide

Reference for contributors to the <repo>. Assumes you have not opened this codebase before. For the quick start, see [`README.md`](../README.md); for the system map and code layout, see [`architecture.md`](./architecture.md).

## Contents

- [Reference](#reference)
  - [Stack](#stack)
  - [Environment variables](#environment-variables)
  - [Observability](#observability)
  - [Commands](#commands)
  - [Testing strategy](#testing-strategy)
  - [CI/CD](#cicd)
  - [Branch protection](#branch-protection)
  - [Documentation map](#documentation-map)
- [How-to guides](#how-to-guides)
  - [Set up your local environment](#set-up-your-local-environment)
  - [Open a pull request](#open-a-pull-request)
  - [Cut a release](#cut-a-release)
  - [Ship a hotfix](#ship-a-hotfix)
  - [Update documentation](#update-documentation)
---

## Reference

Material you look up while working.

### Stack

### Environment variables

### Backend reference

### Observability

### Commands

### Testing strategy

### CI/CD

### Branch protection

Branch model:

```
                      release (non-squash merge)
   main  ──●──────────────●──────────────●──▶   (auto-deploys to prod)
            │              ▲              ▲
            │        merge dev       merge dev
            │              │              │
   dev   ──●─●─●─●──●──●──●──●──●──●─────●──▶   (no auto-deploy; issue #33)
                 ▲       ▲         ▲
                 │       │         │
             feature/   fix/   feature/
             careers   resume  verify

   hotfix/*  branches from main, PRs back to main, then merges to dev.
```

### Documentation map

---

## How-to guides

Recipes for common tasks.

### Set up your local environment

### Open a pull request

The default contribution flow is: branch off `dev`, make your change, open a PR back to `dev`, squash-merge after CI green + one code-owner approval. `main` is release-only — never branch off it or target it with a PR unless you are following [Cut a release](#cut-a-release) or [Ship a hotfix](#ship-a-hotfix). Vercel deploys `main` straight to production, which is why branch protection there is strict (see [Branch protection](#branch-protection) and [Branch protection is strict](#branch-protection-is-strict-1)).

1. Branch off `dev` (or `main` for a hotfix). Names follow `type/short-description` in kebab-case:

   | Type        | Use for                               |
   | ----------- | ------------------------------------- |
   | `feature/`  | New functionality                     |
   | `fix/`      | Bug fixes                             |
   | `hotfix/`   | Urgent prod fix, branched from `main` |
   | `refactor/` | Restructuring without behavior change |
   | `chore/`    | Tooling, deps, CI, config             |
   | `docs/`     | Docs only                             |

2. Fill in the PR template (`.github/pull_request_template.md`). Target `dev` by default; target `main` only for releases or hotfixes.
3. Wait for CI green and one code-owner approval. See [Branch protection](#branch-protection).
4. Squash-merge into `dev`. Use a regular (non-squash) merge when merging `dev` → `main` for releases, to preserve per-PR history.

Do not merge `dev` into your branch before review — it creates noise. If the base branch moves, rebase or let GitHub squash.

For large features, stack PRs:

```
PR #1: feature/foo-client  → dev
PR #2: feature/foo-wire    → feature/foo-client
PR #3: feature/foo-tests   → feature/foo-wire
```

After a parent merges, change the child's base to `dev` via GitHub UI (Edit → Base).

**Changelog norms.** Update `CHANGELOG.md` under `[Unreleased]` when a PR changes something a user will notice: a new route, a new field, a behavior change, a breaking API change. Skip it for pure refactors, test additions, and internal tooling. `CHANGELOG.md` is the canonical user-facing record of what shipped. Commit messages and PR titles change shape as commits are squashed and rebased; a changelog entry, written in human language at PR time, stays stable.

### Cut a release

We use [Semantic Versioning](https://semver.org/): MAJOR for breaking, MINOR for features, PATCH for fixes.

1. Check for drift that the merge itself will not fix. Nothing in CI catches these; they are silent-break paths:
2. Confirm `dev` compiles cleanly:
3. Run all tests and confirm they pass:
4. Move `[Unreleased]` content in `CHANGELOG.md` under `## [X.Y.Z] - YYYY-MM-DD`. Leave an empty `[Unreleased]` stub at the top. Commit to `dev`.
5. Merge `dev` → `main` (non-squash):
   ```bash
   git checkout main && git pull
   git merge dev --no-ff -m "Release vX.Y.Z"
   git push origin main
   ```
6. Tag and push:
   ```bash
   git tag -a vX.Y.Z -m "Release vX.Y.Z"
   git push origin vX.Y.Z
   ```
7. Create the GitHub release:
   ```bash
   gh release create vX.Y.Z --title "vX.Y.Z" --notes-from-tag
   ```
8. `git checkout dev` for the next cycle.

### Ship a hotfix

For production emergencies that cannot wait:

1. `git checkout -b hotfix/short-description main`
2. Apply the minimal fix. Update `CHANGELOG.md` with a patch version.
3. PR directly to `main` — the only time this is allowed.
4. After merge, tag the patch release.
5. Merge `main` back to `dev` so the branches stay in sync.

### Update documentation

Which file to edit:

| Change                              | File                                |
| ----------------------------------- | ----------------------------------- |
| User-visible behavior               | `CHANGELOG.md` under `[Unreleased]` |
| System shape or code layout         | `docs/architecture.md`              |
| Workflow, infra, or reference facts | `docs/developers.md`                |
| Project pitch or quick start        | `README.md`                         |

---

## References

This doc's structure and prose style draw from:

- [**Diátaxis**](https://docs.divio.com/documentation-system/) by Daniele Procida — the four-quadrant framework (tutorial, how-to, reference, explanation) that determines how sections are organized here. See also the individual quadrant pages: [tutorials](https://docs.divio.com/documentation-system/tutorials/), [how-to guides](https://docs.divio.com/documentation-system/how-to-guides/), [reference](https://docs.divio.com/documentation-system/reference/), [explanation](https://docs.divio.com/documentation-system/explanation/).
- [**On Writing Well**](https://en.wikipedia.org/wiki/On_Writing_Well) by William Zinsser — simplicity, clutter, active voice, word economy. Summary notes: [Calvin Rosser](https://calvinrosser.com/notes/on-writing-well-william-zinsser/), [Will Patrick](https://www.willpatrick.co.uk/notes/on-writing-well-william-zinsser).
- [**Google developer documentation style guide**](https://developers.google.com/style) — [highlights](https://developers.google.com/style/highlights), [voice](https://developers.google.com/style/voice), [tone](https://developers.google.com/style/tone), [lists and tables](https://developers.google.com/tech-writing/one/lists-and-tables).
- [**Microsoft writing style guide**](https://learn.microsoft.com/style-guide) — [top tips for style and voice](https://learn.microsoft.com/en-us/style-guide/top-10-tips-style-voice).
- [**The Elements of Style**](https://faculty.washington.edu/heagerty/Courses/b572/public/StrunkWhite.pdf) by Strunk & White — "Omit needless words."
- [**BLUF (Bottom Line Up Front)**](<https://en.wikipedia.org/wiki/BLUF_(communication)>) — the pattern of leading every paragraph with its conclusion.
