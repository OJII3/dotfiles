# Antigravity ACP prompt proxy

Home Manager installs a proxy and its `localharness_external` sidecar at:

```text
~/.local/lib/agy-acp-rules-proxy/
```

After activating Home Manager, set Antigravity's **Binary path** in T3 Code to
the absolute path `/home/ojii3/.local/lib/agy-acp-rules-proxy/agy-acp-rules-proxy`
(adjust the home directory for your machine). T3 does not expand `~` in this
setting. Then start a new thread.

The proxy forwards ACP traffic to T3's active managed server and prepends
`~/.gemini/AGENTS.md` to the first `session/prompt` for each session. ACP has no
standard system-prompt field, so the instructions are sent as user-message
content and may be visible in the transcript or lost after context compaction.
