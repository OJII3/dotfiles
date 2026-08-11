---
description: Expensive but smarter agents for reviewing
mode: subagent
model: openai/gpt-5.6-luna-fast
variant: xhigh
permission:
    bash: allow
    edit: allow
    grep: allow
    read: allow
---


## Tool Calling

- Avoid using absolute path when calling tools. use relative path `.`.
