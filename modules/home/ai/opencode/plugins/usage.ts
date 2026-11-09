import { Plugin } from "@opencode/plugin"

// opencode2 の session.step.started/ended から、モデル呼び出し 1 回ぶんの
// 使用量を組み立てて usage サーバーへ送る。
// 送信先と認証は opencode2 のラッパーが設定する USAGE_* を使う。

type ModelRef = {
  providerID: string
  id: string
}

type TokenUsage = {
  input: number
  output: number
  reasoning: number
  cache: { read: number; write: number }
}

const endpoint = process.env.USAGE_ENDPOINT
const token = process.env.USAGE_TOKEN

// プラグインは location ごとに setup されるため、購読と送信は 1 回に絞る。
const started = Symbol.for("opencode.usage.started")

async function send(record: unknown): Promise<void> {
  await fetch(endpoint!, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify(record),
  })
}

export default Plugin.define({
  id: "usage",
  setup(ctx) {
    if (!endpoint || !token) return
    const global = globalThis as unknown as Record<symbol, boolean>
    if (global[started]) return
    global[started] = true

    const pending = new Map<string, ModelRef>()
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
          }
          pending.set(data.assistantMessageID, data.model)
          continue
        }

        const data = event.data as unknown as {
          sessionID: string
          assistantMessageID: string
          cost?: number
          tokens?: TokenUsage
        }
        const model = pending.get(data.assistantMessageID)
        pending.delete(data.assistantMessageID)
        if (!model) continue

        const tokens = data.tokens ?? {
          input: 0,
          output: 0,
          reasoning: 0,
          cache: { read: 0, write: 0 },
        }

        void send({
          id: data.assistantMessageID,
          ts: Date.now(),
          provider: model.providerID,
          model: model.id,
          input: tokens.input,
          output: tokens.output,
          reasoning: tokens.reasoning,
          cacheRead: tokens.cache.read,
          cacheWrite: tokens.cache.write,
          cost: typeof data.cost === "number" ? data.cost : null,
          sessionId: data.sessionID,
        }).catch(() => {})
      }
    })().catch(() => {})

    return () => controller.abort()
  },
})
