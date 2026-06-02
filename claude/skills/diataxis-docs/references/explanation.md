# Explanation

Source: [diataxis.fr/explanation](https://diataxis.fr/explanation/), [reference vs explanation](https://diataxis.fr/reference-explanation/)

## Purpose and reader

Explanation is **understanding-oriented discussion**. It answers "can you tell me about...?" It gives context, background, and the reasons behind things, weaving scattered facts into a coherent picture. The reader is *studying*, but reflectively, away from the keyboard, trying to deepen their grasp of the subject. Position on the axes: **cognition + acquisition**.

Explanation is the documentation you read to *get it*, not to do something right now.

## Writing rules

- **Discuss; do not instruct.** Explanation talks *about* the subject. It does not give steps and does not describe the machinery entry by entry. ([explanation](https://diataxis.fr/explanation/))
- **Give the why.** Design decisions, trade-offs, historical reasons, constraints. Explain why the system is the way it is, not just what it is.
- **Make connections.** Link concepts to each other and to the bigger picture. Show how the parts relate and why the whole hangs together.
- **Admit alternatives and other views.** Explanation can and should consider other approaches, counter-examples, and even competing opinions. This is the one type where "on the other hand" belongs.
- **Bound the topic.** Frame the discussion around a question or theme ("Why does the scheduler use a priority queue?"). Without a boundary, explanation sprawls.
- **Do not absorb other types.** Keep instructions, steps, and exhaustive parameter lists out. They belong in how-to guides and reference. Explanation that swallows them loses its focus.

## Voice

- Reflective and discursive. It is allowed to be a good read.
- Discusses and weighs: "One reason for this is...", "An alternative would be..., but that trades X for Y."
- Not imperative. If you find yourself writing "do this," you have drifted into a how-to guide.

## Before / after

**Before** (a how-to wearing an explanation's title; it instructs instead of discussing):

> ## Why we use connection pooling
> To enable pooling, set `pool_size` in `config.yml`, then restart the server. Verify with `app status`. If you see `pool: active`, it worked.

**After** (actually discusses the why, and names a trade-off):

> ## Why we use connection pooling
> Opening a database connection is expensive: a TCP handshake, authentication, and session setup, often tens of milliseconds. Under load, paying that cost per request dominates latency. A pool keeps a set of connections open and hands them out, trading a little idle memory for a large drop in tail latency. The cost is complexity: pooled connections can carry stale session state, which is why we reset each one on release. An alternative, a new connection per request, is simpler and fine at low traffic, but it falls over under bursts.

## Anti-patterns

- Slipping into step-by-step instructions (that is a how-to guide).
- Turning into a parameter list or API description (that is reference).
- Presenting only one view as if no alternatives exist.
- Sprawling with no guiding question, so it reads as a brain dump.
- Trying to be useful *during* active work; explanation serves reflection, not the live task.

## How to tell it apart from reference

See the reference file. The test is *when* it is used: reference is consulted mid-task and is deliberately dry; explanation is read away from work to build understanding and is free to discuss, connect, and weigh alternatives.

## How to tell it apart from a tutorial

Both serve a reader who is studying (acquisition), so they can blur. The difference is action vs cognition: a tutorial has the learner *doing* things and learning by the doing; explanation has the reader *thinking*, with no hands on the keyboard. If there are no steps to perform, it is explanation.

## Conformance checklist

When critiquing explanation, check:

- [ ] Does it discuss and illuminate rather than instruct or list?
- [ ] Does it give real reasons (the why), not just restate the what?
- [ ] Does it make connections to the bigger picture?
- [ ] Does it acknowledge alternatives or other perspectives where relevant?
- [ ] Is it bounded by a clear question or theme?
- [ ] Is it free of steps and of exhaustive reference detail?
