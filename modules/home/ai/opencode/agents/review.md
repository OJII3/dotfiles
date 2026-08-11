---
description: Expensive but smarter agents for reviewing
mode: subagent
model: openai/gpt-5.6-luna-fast
variant: xhigh
permission:
    edit: allow
    bash: allow
---

## File Access

- avoid using absolute path to avoid the risk of accessing files outside the repo.
- pay attention to `pwd` when using absolute path, and make sure the path exists.
