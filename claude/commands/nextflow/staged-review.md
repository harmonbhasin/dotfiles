Your goal is to review this staged code/docs, make sure to review the following: 

Use `git diff --staged` to view the changes.

## Documentation Standards

**Structure**
- Lead with purpose: what problem does this solve?
- Architecture decisions: why this approach vs alternatives
- API first: inputs, outputs, error states
- Examples before edge cases

**Technical Writing**
- One idea per paragraph
- Active voice ("the function returns" not "is returned by")
- Present tense for behavior, past for decisions
- Precise terminology (no "basically", "just", "simply")

**Quality Checks**
- Grammar: subject-verb agreement, parallel construction
- Spelling: automated tooling + manual review
- Naming: consistent with codebase conventions
- Links: all references validated

**Google-style Practices**
- Design docs before implementation
- Document invariants and assumptions
- Include non-goals explicitly
- Version history with migration guides

**Ousterhout Principles**
- Modules should be deep (simple interface, complex implementation)
- Document the why, not the what
- Complexity budget: every abstraction must pay for itself
- Error messages are documentation

**Review Protocol**
1. Does a newcomer understand the system after reading?
2. Are all decisions traceable to requirements?
3. Can someone debug issues using only the docs?
4. Is maintenance burden documented?

**Anti-patterns**
- Comments that repeat code
- Out-of-sync examples
- Missing failure modes
- Assumed context without stating it
