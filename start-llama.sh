#!/bin/bash
# Khởi động llama.cpp server cho OpenClaw (đã cài ngày 2026-10-23)
# Lệnh gốc đã capture từ chính server đang chạy của bạn:

set -e
LOG="$HOME/.openclaw/llama-server.log"

# 1. Đang chạy rồi thì thôi (chống chạy đúp)
if curl -s --max-time 2 http://127.0.0.1:8080/v1/models > /dev/null 2>&1; then
  echo "✅ llama-server đã chạy sẵn ở :8080 — không cần làm gì"
  exit 0
fi

# 2. Tìm binary llama
LLAMA_BIN="$(command -v llama || command -v llama-server || true)"
if [ -z "$LLAMA_BIN" ]; then
  echo "❌ Không tìm thấy lệnh 'llama'. Bạn chạy server bằng tool gì? Sửa biến LLAMA_BIN trong script này."
  exit 1
fi

# 3. Khởi động nền + log
echo "⏳ Đang khởi động llama-server (model Qwen3.5-9B)..."
nohup "$LLAMA_BIN" serve \
  --model "$HOME/AI/models/GGUF/Qwen3.5-9B/qwen3.5-9b-Q4_K_M.gguf" \
  --alias qwen3.5:9b \
  --host 127.0.0.1 --port 8080 \
  --ctx-size 32600 --n-predict -1 --n-gpu-layers all \
  --parallel 1 --threads 4 --batch-size 2048 --ubatch-size 512 \
  --flash-attn on --reasoning off \
  > "$LOG" 2>&1 &

# 4. Chờ đến khi /v1/models trả lời (tối đa 30s)
for i in $(seq 1 15); do
  if curl -s --max-time 2 http://127.0.0.1:8080/v1/models > /dev/null 2>&1; then
    echo "✅ llama-server sẵn sàng: http://127.0.0.1:8080 (log: $LOG)"
    exit 0
  fi
  sleep 2
done

echo "⚠️ Server chưa trả lời sau 30s — xem log: tail -30 $LOG"
exit 1
