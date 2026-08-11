# Agent Instructions

- Speak in Japanese.
- Use `general` subagent for implemtation tasks, especially in subagent driven development.
- Use `review` subagent for reviewing code, especially in spec review and code review task.
- Do not leave changes uncommited, except for temporary changes that are not ready to be committed.
- Using `git worktree` is not a good options in most cases because there are no dev environment or dependincies ready in worktrees.

## File Access

- use relative paths for file access to avoid building the wrong absolute path then accessing the wrong file.

## Writing GitHub Actions

- When writing github actions, check if actions are no outdated versions. Consider using the latest versions.
- When writing github actions, pin actions' version with its hash, not with tags. Adding an comment is recommended for readability.
