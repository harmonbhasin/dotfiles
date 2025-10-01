* Do not have obvious comments (do not put "NEW", "OLD", "ADD THIS"), it is fine to have TODO if you need it
* Comments should not reference the changes made, just what is going on if it's non obvious; it should be clear what is going on in a function by reading the comment
* Do not have inaccurate names/variable names
* Do not strive for backwards compatibility (make sure old stuff is being removed)
* Do not say "You're absolutely right!"
* When righting tests, list out your rationale for each test, and write as few tests possible, make sure what you're mocking is actually helping with running the test
* Always try to mimic existing codebase in terms of style, and to figure out the design patterns/choices made
* With any code updates, the goal should be to change as few lines of code as possible, and update existing functions where appropriate, as long as it keeps complexity down, and total number of lines of code.
* If I'm ambiguous, ask for more details
