# Đường Ollama — chạy model local bằng Ollama thay vì llama.cpp thuần

> Lựa chọn thay thế cho mục 9 trong [README.md](README.md): thay vì tự quản
> `llama-server`, dùng **Ollama** — cài nhẹ nhàng hơn, model tự load/unload,
> nhưng đánh đổi ít tinh chỉnh được flag hơn.
>
> - OpenClaw đang cài: **2026.10.7** · Ollama bản mới nhất lúc ghi chú: **v0.40.11 (24/10/2026)**
> - ⚠️ Ollama **không dùng llama.cpp thuần** — nó bundle llama.cpp đã patch + engine
>   riêng (MLX trên macOS). Đừng copy lệnh flag giữa Ollama và `llama-server`.

---

## 1. Cài Ollama

```bash
brew install ollama
# hoặc tải app từ https://ollama.com/download

ollama --version
# nên từ v0.40.11 trở lên (24/10/2026)
```

Chạy server (nếu không dùng app menu bar):

```bash
ollama serve          # hoặc: brew services start ollama
```

## 2. Tải model

Model đích tương đương setup llama.cpp (`qwen3.5:9b` Q4_K_M, ~6.4GB RAM):

```bash
ollama pull qwen3.5:9b
ollama ls                        # xác nhận model đã về máy
ollama run qwen3.5:9b "Xin chào" # test nhanh, /bye để thoát
```

Khi `ollama serve` đang chạy, model serve ở `http://127.0.0.1:11434`
(API tương thích OpenAI tại `/v1`).

## 3. Cấu hình OpenClaw dùng Ollama

Sửa `~/.openclaw/openclaw.json` thêm provider (giữ nguyên các mục khác —
trộn bằng `"mode": "merge"`):

```json
"models": {
  "mode": "merge",
  "providers": {
    "ollama": {
      "baseUrl": "http://127.0.0.1:11434/v1",
      "api": "openai-completions",
      "request": { "allowPrivateNetwork": true },
      "models": []
    }
  }
}
```

> 💡 Khác với đường llama.cpp (mục 9 README), Ollama **không đòi API key
> placeholder** — nhưng nếu gateway vẫn báo `missing-provider-auth`, thêm
> `"env": { "vars": { "OLLAMA_API_KEY": "ollama-local" } }` như way llama.cpp
> đã làm (xem [TROUBLESHOOTING.md](TROUBLESHOOTING.md) mục 4).

## 4. Kích hoạt

```bash
openclaw models list --refresh --provider ollama    # discover từ /v1/models
openclaw config set agents.defaults.model.primary "ollama/qwen3.5:9b"
openclaw gateway restart
```

Kiểm tra: mở dashboard (`openclaw dashboard`) → chọn model `ollama/qwen3.5:9b`
→ chat thử. Log kiểm tra thêm: `openclaw logs | grep -i ollama`.

## 5. Sau khi tắt máy — mở lại

| Thành phần | Có cần làm gì? | Lệnh |
|---|---|---|
| Gateway OpenClaw | ❌ Không — LaunchAgent tự bật | `openclaw gateway status` |
| Ollama server (brew) | ✅ Có nếu cài qua brew (app menu bar thì tự chạy) | `ollama serve` |
| Model | ❌ Không — Ollama tự load model vào RAM khi có request đầu tiên | — |

```bash
# Quy trình ngày mới:
openclaw gateway status
ollama serve &                  # nếu chưa chạy
openclaw dashboard
```

## 6. Ollama vs llama.cpp thuần — khi nào chọn đường nào?

| Tiêu chí | Ollama | llama.cpp thuần (`llama-server`) |
|---|---|---|
| Cài đặt | 1 lệnh brew, model 1 lệnh pull | tự tải GGUF + tự quản binary |
| Load model | tự động, unload sau idle | phải giữ server chạy sẵn |
| Tinh chỉnh flag (context, flash-attn...) | giới hạn (qua env `OLLAMA_*`) | full tuỳ biến |
| Engine | llama.cpp đã patch + MLX (macOS) | llama.cpp nguyên bản |
| Cập nhật model/flag | theo nhịp release Ollama | theo nhịp release llama.cpp |

> Kết luận: máy cá nhân muốn "bật máy là chạy" → **Ollama**. Cần can thiệp sâu
> context length, quantization, benchmark flags → **llama.cpp thuần** (mục 9 README).

## 7. Tham khảo

- Ollama releases: https://github.com/ollama/ollama/releases (bản mới nhất v0.40.11, 24/10/2026)
- Tin tức/blog Ollama: https://ollama.com/blog
- Docs OpenClaw models/providers: https://openclaw.ai/docs
- Đường llama.cpp tương ứng: [README.md mục 9](README.md)
