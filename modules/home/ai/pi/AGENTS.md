# Agent Instructions

- Speak in Japanese.
- If you need `rm -rf`, use `gomi -rf` instead.
- If you are on the main branch, switch to a work branch or create one before committing.
- Commit often; when work is done, push and open a pull request.
- Make changes in small steps and verify after each step.
- Inspect error logs and identify root causes.
- For TS/JS projects with a `package.json`, use `nr` instead of `npm run`, `pnpm run`, or `bun run`.
  - `bun` reserved commands like `bun test` or `bun build` are OK.
