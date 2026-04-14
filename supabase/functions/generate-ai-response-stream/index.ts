import { serve } from "https://deno.land/std/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  // ===== CORS =====
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  // ===== 1. 创建 Admin Client =====
  const supabaseAdmin = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
  );

  // ===== 2. 验证用户 =====
  const authHeader = req.headers.get("Authorization");
  if (!authHeader) {
    return new Response("Unauthorized", { status: 401, headers: corsHeaders });
  }

  const token = authHeader.replace("Bearer ", "");
  const {
    data: { user },
    error,
  } = await supabaseAdmin.auth.getUser(token);

  if (error || !user) {
    console.error(error);
    return new Response("Invalid user", { status: 401, headers: corsHeaders });
  }

  // ===== 3. 获取请求体 =====
  const { messages, tools } = await req.json();

  if (!messages || !Array.isArray(messages)) {
    return new Response(
      JSON.stringify({ error: "messages array is required" }),
      { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }

  // ===== 4. 构建 DeepSeek 请求体 =====
  const deepseekBody: Record<string, unknown> = {
    model: "deepseek-chat",
    messages,
    stream: true,
  };

  if (tools && Array.isArray(tools) && tools.length > 0) {
    deepseekBody.tools = tools;
    deepseekBody.tool_choice = "auto";
  }

  // ===== 5. 调用 DeepSeek（流式） =====
  const aiResponse = await fetch(
    "https://api.deepseek.com/v1/chat/completions",
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${Deno.env.get("DEEPSEEK_API_KEY")}`,
      },
      body: JSON.stringify(deepseekBody),
    }
  );

  if (!aiResponse.ok) {
    const errText = await aiResponse.text();
    console.error("DeepSeek error:", errText);
    return new Response(errText, { status: 500, headers: corsHeaders });
  }

  // ===== 6. 转换 DeepSeek SSE → 客户端 SSE =====
  // DeepSeek 返回标准 OpenAI SSE 格式，我们精简后转发给客户端
  const reader = aiResponse.body!.getReader();
  const decoder = new TextDecoder();

  const stream = new ReadableStream({
    async start(controller) {
      const encoder = new TextEncoder();
      let buffer = "";
      let closed = false;

      function processLine(trimmed: string) {
        if (!trimmed.startsWith("data: ")) return;

        const data = trimmed.substring(6);
        if (data === "[DONE]") {
          controller.enqueue(encoder.encode("data: [DONE]\n\n"));
          if (!closed) { closed = true; controller.close(); }
          return;
        }

        try {
          const json = JSON.parse(data);
          const choice = json.choices?.[0];
          if (!choice) return;

          const delta = choice.delta ?? {};
          const finishReason = choice.finish_reason ?? null;

          // 构建精简的 SSE 事件
          const event: Record<string, unknown> = {};

          // 文本内容
          if (delta.content) {
            event.content = delta.content;
          }

          // tool_calls 增量
          if (delta.tool_calls && Array.isArray(delta.tool_calls)) {
            event.tool_calls = delta.tool_calls;
          }

          // 完成原因
          if (finishReason) {
            event.finish_reason = finishReason;
          }

          // 有内容才发送
          if (Object.keys(event).length > 0) {
            controller.enqueue(
              encoder.encode(`data: ${JSON.stringify(event)}\n\n`)
            );
          }
        } catch {
          // 跳过解析失败的行
        }
      }

      try {
        while (true) {
          const { done, value } = await reader.read();
          if (done) break;

          buffer += decoder.decode(value, { stream: true });
          const parts = buffer.split("\n");
          buffer = parts.pop() ?? "";

          for (const line of parts) {
            const trimmed = line.trim();
            if (closed) return;
            processLine(trimmed);
          }
          if (closed) return;
        }

        // 处理 buffer 中剩余的数据
        if (buffer.trim()) {
          for (const line of buffer.split("\n")) {
            const trimmed = line.trim();
            if (trimmed) processLine(trimmed);
            if (closed) return;
          }
        }

        // 如果 DeepSeek 没有发 [DONE] 就关闭了连接，我们补发一个
        if (!closed) {
          controller.enqueue(encoder.encode("data: [DONE]\n\n"));
        }
      } catch (err) {
        console.error("Stream processing error:", err);
      } finally {
        if (!closed) { closed = true; controller.close(); }
      }
    },
  });

  return new Response(stream, {
    headers: {
      ...corsHeaders,
      "Content-Type": "text/event-stream",
      "Cache-Control": "no-cache",
      Connection: "keep-alive",
    },
  });
});

