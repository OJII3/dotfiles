# Basic Instructions

- Speak in Japanese.
- Do not leave changes uncommited, except for temporary changes that are not ready to be committed.
- Using `git worktree` is not a good options in most cases because there are no dev environment or dependincies ready in worktrees.
- Do not commit main branch directly except for when explicitly asked to do so. Use a feature branch instead.
- If you expect the changes to be large, delegate the task to a subagent to avoid losing main context. If you are not sure, ask for confirmation.

## Tool Calling

- Avoid using absolute path when calling tools like opencode-builtin `read`, `glob` and `grep`. Relative path `.` can be used in these cases.
- When you got error with missing file or directory, you should check not only cwd and ls but also (absolute/relative) path construction.
- Using `~` may cause unexpected failure, due to opencode's specifications.

## Writing GitHub Actions

- When writing github actions, check if all actions are no outdated versions. Consider using the latest versions. You should not skip checking even for basic actions like checkout.
- When writing github actions, pin actions' version with its hash, not with tags. Adding an comment is recommended for readability.

## Development Environment

- Most repositories have nix devShell (flake.nix) and direnv.
- If there is a missing cli or utility tools, try using direnv or nix-develop.

---

# Karpathy Guidelines

Behavioral guidelines to reduce common LLM coding mistakes, derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on LLM coding pitfalls.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment. These guidelines do not applicable to large tasks such as wide refactoring.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

## 5. Finishing Jobs (added by User)

**Don't leave work half-done.**

When you finish a task:
- Ensure all tests or validations pass.
- Ensure all code is committed, pushed, and PRs are created.
- Ensure all CI/CD pipelines pass.
