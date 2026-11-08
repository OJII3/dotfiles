import { Plugin } from "@opencode/plugin"

// opencode2 の組み込み OTel は span に usage を載せないため、ステップの開始と終了から
// モデル呼び出し 1 回ぶんの span を組み立てて Langfuse に送る。
// 送信先と認証は opencode2 のラッパーが設定する OTEL_* をそのまま使う。

type ModelRef = {
  providerID: string
  id: string
  variant?: string
}

type TokenUsage = {
  input: number
  output: number
  reasoning: number
  cache: { read: number; write: number }
}

const endpoint = process.env.OTEL_EXPORTER_OTLP_ENDPOINT
const headers = parseHeaders(process.env.OTEL_EXPORTER_OTLP_HEADERS)

// プラグインは location ごとに setup されるため、購読と送信は 1 回に絞る。
const started = Symbol.for("opencode.langfuse-usage.started")

function parseHeaders(value: string | undefined): Record<string, string> {
  if (!value) return {}
  const out: Record<string, string> = {}
  for (const pair of value.split(",")) {
    const at = pair.indexOf("=")
    if (at < 1) continue
    out[pair.slice(0, at).trim()] = pair.slice(at + 1).trim()
  }
  return out
}

function hex(bytes: number): string {
  const buf = new Uint8Array(bytes)
  globalThis.crypto.getRandomValues(buf)
  return Array.from(buf, (b) => b.toString(16).padStart(2, "0")).join("")
}

function attr(key: string, value: string | number) {
  if (typeof value === "string") return { key, value: { stringValue: value } }
  if (Number.isInteger(value)) return { key, value: { intValue: String(value) } }
  return { key, value: { doubleValue: value } }
}

function tracesUrl(): string {
  const base = endpoint!.replace(/\/+$/, "")
  return base.endsWith("/v1/traces") ? base : `${base}/v1/traces`
}

async function send(spans: unknown[]): Promise<void> {
  await fetch(tracesUrl(), {
    method: "POST",
    headers: { "Content-Type": "application/json", ...headers },
    body: JSON.stringify({
      resourceSpans: [
        {
          resource: { attributes: [attr("service.name", "opencode")] },
          scopeSpans: [{ scope: { name: "opencode.langfuse-usage", version: "1" }, spans }],
        },
      ],
    }),
  })
}

export default Plugin.define({
  id: "langfuse-usage",
  setup(ctx) {
    if (!endpoint) return
    const global = globalThis as unknown as Record<symbol, boolean>
    if (global[started]) return
    global[started] = true

    const pending = new Map<string, { model: ModelRef; started: number }>()
    const controller = new AbortController()

    void (async () => {
      for await (const event of ctx.event.subscribe({
        types: ["session.step.started", "session.step.ended"],
        signal: controller.signal,
      })) {
        if (event.type === "session.step.started") {
          const data = event.data as unknown as {
            assistantMessageID: string
            model: ModelRef
            started: number
          }
          pending.set(data.assistantMessageID, { model: data.model, started: data.started })
          continue
        }

        const data = event.data as unknown as {
          sessionID: string
          assistantMessageID: string
          finish?: string
          cost?: number
          tokens?: TokenUsage
        }
        const start = pending.get(data.assistantMessageID)
        pending.delete(data.assistantMessageID)
        if (!start) continue

        const tokens = data.tokens ?? {
          input: 0,
          output: 0,
          reasoning: 0,
          cache: { read: 0, write: 0 },
        }
        const end = Date.now()

        const attributes = [
          attr("gen_ai.operation.name", "chat"),
          attr("gen_ai.provider.name", start.model.providerID),
          attr("gen_ai.request.model", start.model.id),
          attr("gen_ai.usage.input_tokens", tokens.input),
          attr("gen_ai.usage.output_tokens", tokens.output),
          attr("gen_ai.usage.total_tokens", tokens.input + tokens.output),
          attr("gen_ai.usage.reasoning_tokens", tokens.reasoning),
          attr("gen_ai.usage.cache_read_input_tokens", tokens.cache.read),
          attr("gen_ai.usage.cache_write_input_tokens", tokens.cache.write),
          attr("langfuse.observation.type", "generation"),
          attr("langfuse.observation.model.name", start.model.id),
          attr("langfuse.session.id", data.sessionID),
          attr("langfuse.trace.name", `${start.model.providerID}/${start.model.id}`),
        ]
        if (typeof data.cost === "number") {
          attributes.push(attr("gen_ai.usage.cost", data.cost))
          attributes.push(attr("langfuse.observation.cost_details", JSON.stringify({ total: data.cost })))
        }
        if (data.finish) attributes.push(attr("gen_ai.response.finish_reasons", data.finish))

        void send([
          {
            traceId: hex(16),
            spanId: hex(8),
            name: `chat ${start.model.id}`,
            kind: 3,
            startTimeUnixNano: String(BigInt(Math.round(start.started)) * 1_000_000n),
            endTimeUnixNano: String(BigInt(end) * 1_000_000n),
            attributes,
          },
        ]).catch(() => {})
      }
    })().catch(() => {})

    return () => controller.abort()
  },
})
