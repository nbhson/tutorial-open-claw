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

Signpost: mục này cài đặt Ollama lên máy — bước đầu tiên của cả con đường.

> 📄 **Code ví dụ:** [`examples/01-1-cai-ollama.sh`](examples/01-1-cai-ollama.sh)

Chạy server (nếu không dùng app menu bar):

> 📄 **Code ví dụ:** [`examples/02-1-cai-ollama.sh`](examples/02-1-cai-ollama.sh)

## 2. Tải model

Signpost: mục này đưa "bộ não" về máy — tải đúng model tương đương với setup llama.cpp cũ.

Model đích tương đương setup llama.cpp (`qwen3.5:9b` Q4_K_M, ~6.4GB RAM):

> 📄 **Code ví dụ:** [`examples/03-2-tai-model.sh`](examples/03-2-tai-model.sh)

Hãy hình dung Ollama như quán cà phê có tủ lạnh thông minh: model là nguyên liệu, khi có khách gọi thì tự lấy ra pha, hết giờ thì cất vào tủ — không cần bạn phải giữ bếp nóng liên tục. Khi `ollama serve` đang chạy, model serve ở `http://127.0.0.1:11434`
(API tương thích OpenAI tại `/v1`).

## 3. Cấu hình OpenClaw dùng Ollama

Signpost: mục này "giới thiệu" OpenClaw với Ollama bằng cách thêm 1 provider vào config — sửa ít, hiệu quả nhiều.

Sửa `~/.openclaw/openclaw.json` thêm provider (giữ nguyên các mục khác —
trộn bằng `"mode": "merge"`):

> 📄 **Code ví dụ:** [`examples/04-3-cau-hinh-openclaw-dung-ollama.json`](examples/04-3-cau-hinh-openclaw-dung-ollama.json)

> 💡 Khác với đường llama.cpp (mục 9 README), Ollama **không đòi API key
> placeholder** — nhưng nếu gateway vẫn báo `missing-provider-auth`, thêm
> `"env": { "vars": { "OLLAMA_API_KEY": "ollama-local" } }` như way llama.cpp
> đã làm (xem [TROUBLESHOOTING.md](TROUBLESHOOTING.md) mục 4).

> **Tóm gọn 1 câu:** Thêm Ollama vào OpenClaw chỉ là 1 mục `merge` trong config — như thêm một kênh liên lạc mới vào danh bạ, những kênh cũ vẫn nguyên.

## 4. Kích hoạt

Signpost: mục này bật công tắc và thử nói chuyện — để biết mọi thứ đã nối đúng mạch chưa.

> 📄 **Code ví dụ:** [`examples/05-4-kich-hoat.sh`](examples/05-4-kich-hoat.sh)

Kiểm tra: mở dashboard (`openclaw dashboard`) → chọn model `ollama/qwen3.5:9b`
→ chat thử. Log kiểm tra thêm: `openclaw logs | grep -i ollama`.

> **Tóm gọn 1 câu:** Bật máy là chạy — chọn model trong dashboard, chat thử một câu là biết mạch đã nối đúng chưa.

## 5. Sau khi tắt máy — mở lại

Signpost: mục này trả lời câu hỏi "sáng mai mở máy lên thì phải làm gì lại?" — spoilers: gần như không phải làm gì.

| Thành phần | Có cần làm gì? | Lệnh |
|---|---|---|
| Gateway OpenClaw | ❌ Không — LaunchAgent tự bật | `openclaw gateway status` |
| Ollama server (brew) | ✅ Có nếu cài qua brew (app menu bar thì tự chạy) | `ollama serve` |
| Model | ❌ Không — Ollama tự load model vào RAM khi có request đầu tiên | — |

> **Cách đọc bảng này:** đọc theo từng dòng thành phần, cột giữa trả lời "có phải làm gì không" (❌ = tự lo được, ✅ = phải tay một nhịp), cột phải là lệnh để kiểm tra/chạy lại.

> 📄 **Code ví dụ:** [`examples/06-5-sau-khi-tat-may-mo-lai.sh`](examples/06-5-sau-khi-tat-may-mo-lai.sh)

## 6. Ollama vs llama.cpp thuần — khi nào chọn đường nào?

Signpost: mục này là bản so sánh quyết định — đọc để biết đường Ollama hay đường llama.cpp hợp với mình hơn.

| Tiêu chí | Ollama | llama.cpp thuần (`llama-server`) |
|---|---|---|
| Cài đặt | 1 lệnh brew, model 1 lệnh pull | tự tải GGUF + tự quản binary |
| Load model | tự động, unload sau idle | phải giữ server chạy sẵn |
| Tinh chỉnh flag (context, flash-attn...) | giới hạn (qua env `OLLAMA_*`) | full tuỳ biến |
| Engine | llama.cpp đã patch + MLX (macOS) | llama.cpp nguyên bản |
| Cập nhật model/flag | theo nhịp release Ollama | theo nhịp release llama.cpp |

> **Cách đọc bảng này:** cột giữa (Ollama) là "xe số tự động" — tiện, ít đụng tay; cột phải (llama.cpp thuần) là "xe số tay" — vất vả hơn nhưng quay được đúng cái mình muốn. Đọc theo dòng tiêu chí quan trọng với bạn nhất.

> Kết luận: máy cá nhân muốn "bật máy là chạy" → **Ollama**. Cần can thiệp sâu
> context length, quantization, benchmark flags → **llama.cpp thuần** (mục 9 README).

## 7. Tham khảo

Signpost: mục này là các link gốc — vào đây khi muốn tra cứu ngoài phạm vi ghi chú.

- Ollama releases: https://github.com/ollama/ollama/releases (bản mới nhất v0.40.11, 24/10/2026)
- Tin tức/blog Ollama: https://ollama.com/blog
- Docs OpenClaw models/providers: https://openclaw.ai/docs
- Đường llama.cpp tương ứng: [README.md mục 9](README.md)

> **Tóm gọn 1 câu:** Con đường Ollama = cài một lần, pull một model, merge một mục config — rồi cứ thế "bật máy là chạy".
