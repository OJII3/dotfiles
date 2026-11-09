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

# Langfuse telemetry

Antigravity has no OTLP exporter, so Home Manager registers hooks that turn
agent events into spans and sends them to Langfuse Cloud (JP region):

```text
~/.gemini/config/hooks.json      hook registration
~/.local/lib/agy-langfuse/hook   wrapper that runs the exporter
```

The wrapper reads the Langfuse keys from the sops secret files at run time. The
hooks run inside the T3 Code service, which does not inherit the shell's
`OTEL_*` variables, so the keys cannot come from the environment.

The exporter covers `PostToolUse`, `PostInvocation`, and `Stop`. Spans of one
conversation share a trace id, and `langfuse.session.id` carries the
conversation id. Model calls become `generation` observations with
`gen_ai.usage.*`; tool calls become `span` observations with
`gen_ai.tool.name`.

Token counts and the model name are not part of the hook payload. The exporter
reads them from `transcriptPath` and from the conversation's SQLite
`gen_metadata`, both of which are Antigravity internals. If either format
changes, the affected attributes are dropped and the span is still sent.
Subagent usage is not attributed to the parent conversation. Prompts and
responses are never sent.

Langfuse prices a generation only when the model exists in its model list.
`gemini-3.8-flash-high` and the other Antigravity aliases are not built in, so
add them under Settings → Models to get cost figures.

