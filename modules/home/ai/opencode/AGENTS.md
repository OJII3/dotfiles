# Basic Instructions

- Speak in Japanese.
- Do not leave changes uncommited, except for temporary changes that are not ready to be committed.
- Do not commit main branch directly except for when explicitly asked to do so. Use a feature branch instead.
- Delegate tasks to a subagent to avoid losing main context.
- When delegating tasks to a subagent, do not select top-tier models such as Gemini Argon, GPT Astra, or Claude Fable.
- When instructed to merge a PR, squash-merge it and delete the branch locally and remotely.

## Writing GitHub Actions

- When writing github actions, check if all actions are no outdated versions. Consider using the latest versions. You should not skip checking even for basic actions like checkout.
- Manage GitHub Actions dependencies with `gh actions-lock`. Use release refs such as `@v4` in workflows instead of manually pinning commit SHAs. Install the extension with `gh extension install github/gh-actions-lock` if needed, then run `gh actions-lock` after adding workflows or changing `uses` dependencies and commit `.github/workflows/actions.lock`. Run `gh actions-lock --relock` to update existing pins to the current upstream commits.

## Development Environment

- Most repositories have nix devShell (flake.nix) and direnv.
- When starting a nearly empty new project, consider using flake-parts to create its `flake.nix`.
- When adding a `flake.nix`, add `.envrc` and `.direnv/` to `.gitignore`.
- If there is a missing cli or utility tools, try using direnv or nix-develop.

## Naming

- Folder names, file names, and symbols must always describe what they contain.
- The layers of the code design and the semantic layers of the names must match. For example, keep the names in an abstraction layer consistently abstract.
- Sibling parts that sit at the same abstraction level must have names at that same abstraction level.
- Do not hesitate to rename existing code even outside the scope of the current change. Breaking changes are always allowed.

---

# Coding Guidelines

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment. They do not apply to large tasks such as wide refactoring.

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

## 5. Finishing Jobs

**Don't leave work half-done.**

When you finish a task:
- Ensure all tests or validations pass.
- Ensure all code is committed, pushed, and PRs are created.
- Ensure all CI/CD pipelines pass.

Creating a PR is always your goal. Rreate a PR before being asked.

### Completion Report

When a task changes code or repository state, end your reply with the block below. Skip this block for Q&A or investigation-only replies.

```markdown
## 変更内容

変更内容を箇条書きで

## 確認

確認したことを箇条書きで

## 状態

- **branch**: <head branch name>, or "なし: <reason>"
- **PR**: [#<number> <title>](<url>), or "なし: <reason>"
- **merge status**: <mergeable | blocked | merged | closed>, or "none: <reason>"
- **checks**: <k/n passed>, or "なし" if no checks exist
```
