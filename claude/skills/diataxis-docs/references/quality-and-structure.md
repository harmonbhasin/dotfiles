# Quality, audits, and structure

Source: [diataxis.fr/quality](https://diataxis.fr/quality/), [complex hierarchies](https://diataxis.fr/complex-hierarchies/), [how to use Diataxis](https://diataxis.fr/how-to-use-diataxis/)

## Two kinds of quality

Documentation quality has two distinct dimensions. They are different in kind, not degree. ([quality](https://diataxis.fr/quality/))

**Functional quality** is measurable and objective: accuracy, completeness, consistency, usefulness, precision. These are the floor. They can be checked against reality, and they are largely independent of each other. Failing any one is a defect.

**Deep quality** is felt, not measured: the docs flow, fit the reader's actual need, anticipate the next question, feel good to use. This is what separates docs that are technically correct from docs people trust and enjoy.

The key relationship: **deep quality is conditional on functional quality.** You cannot make inaccurate, incomplete docs feel good by polishing prose. Get the facts and the structure right first; then the experience can be made good. Diataxis itself is largely a tool for deep quality: by organizing around the four real user needs, it keeps the reader in flow instead of forcing them to wade through the wrong kind of content.

When critiquing, separate the two: name the functional defects (wrong, missing, inconsistent) before the experiential ones (awkward, disorienting, mistyped).

## Auditing a doc set

Use this workflow when the user wants the whole `docs/` tree assessed. Keep it lightweight and end with one concrete next step, not a rewrite plan. ([how to use Diataxis](https://diataxis.fr/how-to-use-diataxis/))

1. **Inventory.** List the existing pages. A quick `find docs -name '*.md'` or reading the nav config is enough.
2. **Classify each page.** Assign every page to one of the four types, or flag it as **mixed** (serving two needs) or **unclear** (serving none well). Mixed and unclear pages are where the value is.
3. **Map coverage.** Across the four types, where are the gaps? Common findings: lots of reference and zero tutorials (nobody can get started), or how-to guides that are secretly tutorials (beginners and experts both underserved).
4. **Propose actions per page.** For each problem page: split (if mixed), retype, relocate, merge, or leave alone.
5. **Recommend the single best next step.** Not everything at once. Pick the one change that most improves the reader's experience, and say why.

Output as a table:

| Page | Current type | Issue | Proposed action |
|------|--------------|-------|-----------------|
| `docs/intro.md` | mixed (tutorial + reference) | beginners hit a wall of config tables | split into `tutorials/getting-started.md` and `reference/config.md` |
| `docs/api.md` | reference | sound | leave as is |
| ... | | | |

Then: **"Start here: [the one next step], because [reason]."**

## Structure and navigation

Diataxis is a way of working, not a four-folder template to impose. Structure should serve real user needs, and may be as complex as those needs require. ([complex hierarchies](https://diataxis.fr/complex-hierarchies/))

- **Group around user needs, not a rigid four-box layout.** The four types are a lens for classifying and writing each page. The site's top-level navigation can mirror them (Tutorials / How-to / Reference / Explanation), and that is a good default, but a large product with distinct audiences may need a richer hierarchy.
- **Keep each navigation level to roughly seven items.** Beyond that, add a layer of grouping. This manages the reader's cognitive load.
- **Landing pages are overviews, not bare link lists.** A section's index page should orient the reader with a sentence or two of context before the links, guiding them to the right child page.
- **Be as complex as you need to be, and no more.** Complexity is fine when it maps to genuine user needs; it is a problem only when it is arbitrary.

## A note on the iterative workflow

Whatever the audit turns up, resist the urge to plan a total reorganization. The Diataxis method is to improve continuously in small steps: assess one thing, make one real improvement, publish it, repeat. Documentation can be *complete* (usable and sound) long before it is *finished*. Never create empty placeholder sections to fill in later. ([how to use Diataxis](https://diataxis.fr/how-to-use-diataxis/))
