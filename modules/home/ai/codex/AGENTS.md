# Basic Instructions

- Speak in Japanese.
- Do not leave changes uncommited, except for temporary changes that are not ready to be committed.
- Using `git worktree` is not a good options in most cases because there are no dev environment or dependincies ready in worktrees.
- Do not commit main branch directly except for when explicitly asked to do so. Use a feature branch instead.
- If you expect the changes to be large, delegate the task to a subagent to avoid losing main context. If you are not sure, ask for confirmation.
- When delegating tasks to a subagent, do not select top-tier models such as Gemini Argon, GPT Astra, or Claude Fable.
- When instructed to merge a PR, squash-merge it and delete the branch locally and remotely.

## Writing Japanese

- 一文一義。読点で節を繋げず、文を分ける。
- 主語は人間に置く。「課題が浮き彫りになる」のように、モノに人間の動詞をさせない。
- 見出しは名詞句にする。「○○は△△だ」という主張を見出しにしない。
- 言い切れることは言い切る。「〜と考えられます」「〜と言えるでしょう」で濁さない。
- 「〜することができます」は「〜できる」に、「〜という」の連発は削る。
- 全角ダッシュ ──、全角の英数字、中黒での3項並列、装飾絵文字、`**` の残骸を残さない。
- 「です・ます」と「だ・である」を混ぜない。文書内でどちらかに統一する。
- 箇条書きは文末表現を揃える。「〜する」と体言止めを混ぜない。

## Writing GitHub Actions

- When writing github actions, check if all actions are no outdated versions. Consider using the latest versions. You should not skip checking even for basic actions like checkout.
- Manage GitHub Actions dependencies with `gh actions-lock`. Use release refs such as `@v4` in workflows instead of manually pinning commit SHAs. Install the extension with `gh extension install github/gh-actions-lock` if needed, then run `gh actions-lock` after adding workflows or changing `uses` dependencies and commit `.github/workflows/actions.lock`. Run `gh actions-lock --relock` to update existing pins to the current upstream commits.

## Development Environment

- Most repositories have nix devShell (flake.nix) and direnv.
- When starting a nearly empty new project, consider using flake-parts to create its `flake.nix`.
- When adding a `flake.nix`, add `.envrc` and `.direnv/` to `.gitignore`.
- If there is a missing cli or utility tools, try using direnv or nix-develop.

---

# Karpathy Guidelines (ojii3 edition)

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
