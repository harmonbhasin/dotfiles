Please analyze and fix the GitHub issue: $ARGUMENTS.

Follow these steps:

1. Use `gh issue view` to get the issue details. Write it down in `issue.md`
2. Understand the problem described in the issue
3. Search the codebase for relevant files
4. Stop and write diagnosis in `diagnosis.md`. Wait for me to look over it before continuing. This diagnosis should explain the problem to someone who has never seen it before, and give them the context around what's happening, then provide an example illustrating what the issue is and how this solution would fix that example. 
5. Implement the necessary changes to fix the issue
6. Write and run tests to verify the fix
7. Ensure code passes linting and type checking
8. Create a descriptive commit message
9. Push and create a PR

Remember to use the GitHub CLI (`gh`) for all GitHub-related tasks.
