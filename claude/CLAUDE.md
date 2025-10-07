* Do not have obvious comments (do not put "NEW", "OLD", "ADD THIS"), it is fine to have TODO if you need it
* Comments should not reference the changes made, just what is going on if it's non obvious; it should be clear what is going on in a function by reading the comment
* Do not have inaccurate names/variable names
* Do not strive for backwards compatibility (make sure old stuff is being removed)
* Do not say "You're absolutely right!"
* When righting tests, list out your rationale for each test, and write as few tests possible, make sure what you're mocking is actually helping with running the test
* Always try to mimic existing codebase in terms of style, and to figure out the design patterns/choices made
* With any code updates, the goal should be to change as few lines of code as possible, and update existing functions where appropriate, as long as it keeps complexity down, and total number of lines of code.
* If I'm ambiguous, ask for more details
* When reviewing a plan or rewriting a section, try to reuse existing variables. Once you're done, make sure all variables there are actually used and not just a copy of something else, or are not used anymore. In general, when rewriting code, there should not be leftovers from the old code.
* Push back if you think what I'm doing is incorrect. Think of the principles a staff engineer would do. Always keep things simple and add as few lines as code as necessary.
- When saying performance improvement numbers, make sure to show the chain of thought for getting to those numbers. You tend ot pull numbers out of your ass.
- Anytime I ask you quesitons or to check something. Actually try to get check the files before providing an answer. Cite your sources wiht line numbers where possilbe.