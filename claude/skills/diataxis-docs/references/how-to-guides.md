# How-to guides

Source: [diataxis.fr/how-to-guides](https://diataxis.fr/how-to-guides/), [tutorials vs how-to](https://diataxis.fr/tutorials-how-to/)

## Purpose and reader

A how-to guide is a **recipe**: directions that take a competent user through the steps to reach a specific real-world goal. The reader is *working*, not studying. They already have the basic skills; they need to get one particular job done correctly. Position on the axes: **action + application**.

A how-to guide answers "how do I...?" for a real task, not "teach me about...".

## Writing rules

- **Address a real-world goal, stated in the title.** Name the task precisely: "How to back up a database to S3," not "Database backups" and not "Backup tutorial." A good title lets a user scanning a list know instantly whether this is their guide. ([how-to](https://diataxis.fr/how-to-guides/))
- **Write from the user's perspective, not the machinery's.** Organize around what the user wants to accomplish, not around the order the software's features happen to come in.
- **Assume competence.** The reader knows the basics. Do not re-teach them. Link to reference for full option lists and to explanation for the why.
- **Branch with the real world.** Use conditional steps: "If you are on Postgres, do X; if on MySQL, do Y." Real tasks have forks; serve them.
- **Sequence logically and keep the flow.** Order steps the way the work actually happens. Keep a usable rhythm; do not bog the user down.
- **Be practical, not complete.** Omit what is not needed for this goal. Start and end at sensible points so the user can slot the guide into their own work. Completeness is reference's job, not yours.
- **No teaching, no digression.** Anything that is not moving the user toward the goal is a distraction. Cut it.

## Voice

- Second person, imperative: "Create a bucket. Set its region. Grant the role access."
- Conditional framing for forks: "If you want X, do Y."
- Brisk and focused. The user is mid-task and wants to finish.

## Before / after

**Before** (teaches from scratch and digresses, ignoring that the reader is competent):

> Authentication is the process of verifying identity. There are many strategies, including sessions, tokens, and OAuth. In this guide we will first learn what a JWT is. A JWT, or JSON Web Token, consists of three parts separated by dots...

**After** (goal-directed, assumes competence, branches):

> ## How to protect an endpoint with a JWT
>
> 1. Add the middleware to the route:
>    ```js
>    app.get('/account', requireAuth, handler)
>    ```
> 2. Set the signing secret in `AUTH_SECRET`.
> 3. If your tokens come from an external provider, set `AUTH_ISSUER` to its URL. Otherwise skip this step.
>
> See the [auth reference](#) for all middleware options.

## Anti-patterns

- Teaching foundational concepts the competent reader already has.
- Forcing one rigid path when real use has several valid routes.
- Opening with history, motivation, or background before the steps.
- Organizing by feature ("the Export menu") instead of by user goal ("export your data").
- Trying to be exhaustive; that turns it into reference.

## How to tell it apart from a tutorial

See the tutorial file for the full comparison. Short version: a tutorial teaches a beginner on one safe path and you own the result; a how-to guide directs a competent user through a real task that branches, and they own the result. It is about the reader's state (learning vs working), not the topic's difficulty.

## How to tell it apart from reference

- A how-to guide is a **narrative sequence** toward a goal; reference is a **lookup** structure you dip into.
- A how-to guide may omit optional parameters to stay focused; reference must list them all.
- If the user reads it front to back to get something done, it is a how-to. If they jump to one entry to check a fact, it is reference.

## Conformance checklist

When critiquing a how-to guide, check:

- [ ] Does the title name a specific real-world goal?
- [ ] Is it written around the user's goal, not the software's structure?
- [ ] Does it assume competence and link out instead of re-teaching?
- [ ] Does it branch for real-world variation rather than forcing one path?
- [ ] Is every step pulling toward the goal, with no teaching or digression?
- [ ] Does it start and end at sensible points, omitting the irrelevant?
