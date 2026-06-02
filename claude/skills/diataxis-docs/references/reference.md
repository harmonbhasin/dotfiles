# Reference

Source: [diataxis.fr/reference](https://diataxis.fr/reference/), [reference vs explanation](https://diataxis.fr/reference-explanation/)

## Purpose and reader

Reference is **technical description**: the authoritative, factual account of how the machinery works. The reader is *working* and needs truth and certainty, a firm platform to stand on while they get something done. They are not learning and not being persuaded; they are looking something up. Position on the axes: **cognition + application**.

The model is a map, a dictionary, or an encyclopedia: you do not read it through, you consult it.

## Writing rules

- **Describe, and only describe.** State what is. No instructions, no explanation of why, no opinion, no marketing. The moment reference starts teaching or arguing, it stops being trustworthy reference. ([reference](https://diataxis.fr/reference/))
- **Mirror the product's structure.** Organize the docs the way the code is organized, so a user can move through both in step. If the product has modules, the reference has matching sections.
- **Be consistent.** Same layout, same order, same vocabulary for every entry. Users should find each fact where they expect it, in the format they expect.
- **Be accurate, complete, and precise.** These are non-negotiable. List every parameter, every return value, every error, every default. Omissions are bugs.
- **Stay neutral and austere.** A reference reads like a specification or a nutrition label: standardized, factual, a little boring on purpose. That austerity is what makes it dependable.
- **Use examples for illustration, not instruction.** A short example showing the shape of a call is valuable context. It must not turn into a lesson or a how-to.

## Voice

- Third person, declarative, present tense: "Returns the number of rows affected. Raises `IOError` if the file is missing."
- No "you," no "we," no "should," no "let's."
- Tables and lists over prose. Reference is structured for scanning, not reading.

## Before / after

**Before** (instructs, explains, and editorializes, all out of place):

> ### `timeout`
> You should always set a timeout, because leaving it unset is dangerous and can hang your app. We recommend 30 seconds for most use cases. Honestly, the default here is a bit of a footgun.

**After** (describes, and only describes):

> ### `timeout`
> Type: `int` (seconds). Default: `0` (no timeout).
> Maximum time to wait for a response before raising `TimeoutError`. A value of `0` waits indefinitely.

(The advice about *always setting a timeout* belongs in a how-to guide; the judgment that the default is a footgun belongs in explanation.)

## Anti-patterns

- Explanatory content creeping in ("the reason this works is..."). Move it to explanation.
- Instructional tone or steps. Move it to a how-to guide.
- Omitting optional parameters, edge cases, or error conditions.
- Organizing by user task instead of by the product's own structure.
- Marketing language, recommendations, or speculation.
- Inconsistent formatting between entries that should match.

## How to tell it apart from explanation

This is the subtle pair, because both are cognition (knowing, not doing). The test is *when* the reader uses it: ([reference vs explanation](https://diataxis.fr/reference-explanation/))

- **Reference** is consulted *while working*. It is the dry list of classes, methods, flags, and parameters you check mid-task. It is "boring and unmemorable" by design.
- **Explanation** is read *away from work*, to deepen understanding. It discusses, connects, and considers alternatives.

If you would dip into it to confirm a fact while coding, it is reference. If you would read it on the couch to understand the system better, it is explanation.

## How to tell it apart from a how-to guide

A how-to guide is a narrative sequence toward a goal and may skip irrelevant options; reference is a comprehensive, random-access description with no goal of its own. How-to directs; reference describes.

## Conformance checklist

When critiquing reference, check:

- [ ] Does it only describe, with no instruction, persuasion, or opinion?
- [ ] Is it accurate, complete (all params, returns, errors, defaults), and precise?
- [ ] Is formatting consistent across comparable entries?
- [ ] Does the structure mirror the product's own structure?
- [ ] Are examples illustrative, not instructional?
- [ ] Is the tone neutral and declarative, with no "you should"?
