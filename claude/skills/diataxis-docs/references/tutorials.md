# Tutorials

Source: [diataxis.fr/tutorials](https://diataxis.fr/tutorials/), [tutorials vs how-to](https://diataxis.fr/tutorials-how-to/)

## Purpose and reader

A tutorial is a **lesson**. The reader is a beginner who is *studying*: acquiring skill and confidence by doing, under your guidance. They do not yet know what they need to know, so they cannot be asked to make choices. Position on the axes: **action + acquisition**.

Success is measured by one thing: the learner finishes, it worked, and they feel capable. The tutorial is not about the subject matter; it is about the learner's experience of learning it.

## Writing rules

- **Take full responsibility for the outcome.** You are the teacher. If a step fails for the learner, that is your failure, not theirs.
- **Guarantee every step works, every time.** A tutorial that breaks halfway destroys confidence. This demands real testing and watching real people run it.
- **One path, no choices.** Remove all alternatives, options, and "you could also." Decisions are yours to make for the learner. ([tutorials vs how-to](https://diataxis.fr/tutorials-how-to/))
- **Show concrete, visible results early and often.** Each step should produce something the learner can see. Tell them what to expect: "The output should look like this."
- **Minimize explanation.** A line of why is fine; a paragraph is a detour. Link out to explanation for the curious. Teaching the concepts is not this page's job.
- **Start from zero.** Assume no prior knowledge of the tool, the language, or the setup. State prerequisites plainly at the top.
- **Make it reproducible and self-contained.** A contrived, controlled setting is correct here. The point is learning, not a real-world deliverable.

## Voice

- First person plural: "we will," "now we add," "let's run it." You and the learner do it together.
- Direct, present-tense imperatives for actions: "Run `npm start`. Open `localhost:3000`."
- Confirmatory cues throughout: "Notice that the counter now shows 1," "You should see a green checkmark."

## Before / after

**Before** (explains and offers choices, breaking the lesson):

> Now you need a database. You could use PostgreSQL, MySQL, or SQLite depending on your needs. PostgreSQL is generally preferred for production because of its concurrency model and rich type system, though SQLite is simpler for local development. Configure whichever you choose in `config.yml`.

**After** (one path, action, visible result):

> Now we will add a database. We will use SQLite, because it needs no setup. Create a file called `config.yml` and paste in:
>
> ```yaml
> database: sqlite:///app.db
> ```
>
> Run `app init-db`. You should see `Created app.db with 3 tables`.

## Anti-patterns

- Offering options or asking the learner to decide.
- Explaining theory mid-lesson instead of linking it out.
- Steps whose results are invisible or not stated, so the learner cannot tell if it worked.
- Assuming setup the learner does not have.
- Steps that work on your machine but not reliably for everyone.
- Treating it as a feature tour instead of a learning experience.

## How to tell it apart from a how-to guide

Both are practical and step-based, so they are the easiest pair to confuse. The difference is the reader's state, not the topic's difficulty:

- A **tutorial** serves a learner at study who needs to acquire competence. It runs in a controlled setting on a single path, and you own the result.
- A **how-to guide** serves a competent person at work who needs to get a real task done. It meets the real world, so it branches, and the user owns the result.

The same advanced topic can be either. "Deploying to Kubernetes" is a tutorial when the goal is to teach a newcomer the concepts by doing; it is a how-to when an experienced engineer just needs the steps for their cluster.

## Conformance checklist

When critiquing a tutorial, check:

- [ ] Does it start from zero and state prerequisites?
- [ ] Is there exactly one path, with no choices or alternatives?
- [ ] Does every step work reliably, and does each show a visible, stated result?
- [ ] Is explanation kept minimal and linked out rather than inline?
- [ ] Is the voice "we," collaborative and encouraging?
- [ ] Would a real beginner reach the end and feel they succeeded?
