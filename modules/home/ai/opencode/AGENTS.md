# Agent Instructions

- Speak in Japanese.
- Use `general` subagent for implemtation tasks, especially in subagent driven development.
- Use `review` subagent for reviewing code, especially in spec review and code review task.
- Do not leave changes uncommited, except for temporary changes that are not ready to be committed.
- Using `git worktree` is not a good options in most cases because there are no dev environment or dependincies ready in worktrees.

## Tool Calling

- Avoid using absolute path when calling tools. use relative path `.`.

## Writing GitHub Actions

- When writing github actions, check if actions are no outdated versions. Consider using the latest versions.
- When writing github actions, pin actions' version with its hash, not with tags. Adding an comment is recommended for readability.

## Superpowers

- When using superpowers and wrote a spec file, make sure to create pull request so that the user can review them on github.com.
