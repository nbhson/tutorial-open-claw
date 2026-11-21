# OpenClaw 🦞 — Ghi chú cài đặt trên macOS

> Trợ lý AI mã nguồn mở chạy ngay trên máy của bạn, kết nối vào các kênh chat đang dùng:
> Discord, iMessage, Slack, Teams, Telegram, WhatsApp, Zalo... (hỗ trợ 20+ kênh).
> State, memory, credentials nằm trên máy bạn — không phụ thuộc cloud của bên thứ ba.
>
> - Repo: https://github.com/openclaw/openclaw
> - Trang chủ: https://openclaw.ai
> - Bản cài lúc ghi chú này: **OpenClaw 2026.10.7** · Node **v26.12.1** · npm **11.20.0** · macOS 27

## Mục lục

1. [Yêu cầu hệ thống](#1-yêu-cầu-hệ-thống)
2. [Cài Node 26 bằng nvm](#2-cài-node-26-bằng-nvm)
3. [Cài OpenClaw bằng npm](#3-cài-openclaw-bằng-npm)
4. [Onboarding lần đầu](#4-onboarding-lần-đầu)
5. [Lệnh CLI hữu ích](#5-lệnh-cli-hữu-ích)
   - [5.11a. Profile chrome (khuyến nghị)](#511a-profile-chrome-khuyến-nghị)
   - [5.11b. Profile user (ABANDONED)](#511b-profile-user-️-abandoned--chỉ-để-tham-khảo)
6. [Cách khác: app macOS native](#6-cách-khác-app-macos-native)
7. [Chạy từ source (cho dev)](#7-chạy-từ-source-cho-dev)
8. [Xử lý lỗi thường gặp](#8-xử-lý-lỗi-thường-gặp) → chi tiết ở [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
9. [Dùng model local qua llama.cpp](#9-dùng-model-local-qua-llamacpp) · [đường Ollama](2-ollama-path.md)
10. [Sau khi tắt máy — mở lại hằng ngày](#10-sau-khi-tắt-máy--mở-lại-hằng-ngày)
11. [Tham khảo](#11-tham-khảo)

---

## 1. Yêu cầu hệ thống

| Thành phần | Yêu cầu |
|---|---|
| Node.js | **≥ 24.22.1 (nhánh 24)** hoặc **≥ 26.12.1 (nhánh 26)** — khuyên dùng Node 26 |
| npm | 12+ hoặc 11.16+ (để dùng `--allow-scripts`) |
| Hệ điều hành | macOS 15+, Apple Silicon hoặc Intel |

> **Cách đọc bảng này:** mỗi dòng là một thành phần bắt buộc phải có trước khi cài — kiểm tra đủ cả 3 dòng rồi hẵng sang bước sau.

⚠️ Node 22 **không đủ** — cài đặt sẽ báo lỗi ngay ở bước preinstall.

> **Tóm gọn 1 câu:** Cần Node 26 (hoặc 24.22.1+), npm 11.16+/12+ và macOS 15+ — thiếu Node 26 là cài không được.

## 2. Cài Node 26 bằng nvm

Mục này nâng Node lên bản 26 bằng nvm — công cụ cho phép máy cài nhiều phiên bản Node và đổi qua lại như đổi kênh TV.

> 📄 **Code ví dụ:** [`examples/01-2-cai-node-26-bang-nvm.sh`](examples/01-2-cai-node-26-bang-nvm.sh)

Kiểm tra:

> 📄 **Code ví dụ:** [`examples/02-2-cai-node-26-bang-nvm.sh`](examples/02-2-cai-node-26-bang-nvm.sh)

> **Tóm gọn 1 câu:** Chạy script cài Node 26 qua nvm rồi chạy script kiểm tra — ra đúng số phiên bản là xong.

## 3. Cài OpenClaw bằng npm

> 📄 **Code ví dụ:** [`examples/03-3-cai-openclaw-bang-npm.sh`](examples/03-3-cai-openclaw-bang-npm.sh)

Giải thích:
- npm 11.16+ / 12 mặc định **chặn install scripts**. Nếu bỏ `--allow-scripts`, các package
  `openclaw` (bundled plugins), `esbuild`, `koffi` (native bindings) sẽ KHÔNG được build đúng
  → phải cài lại có cờ này.
- Cài xong kiểm tra:

> 📄 **Code ví dụ:** [`examples/04-3-cai-openclaw-bang-npm.sh`](examples/04-3-cai-openclaw-bang-npm.sh)

> **Tóm gọn 1 câu:** Cài bằng npm kèm cờ `--allow-scripts` (bắt buộc, để plugins/native bindings build đúng), xong chạy script kiểm tra xác nhận.

## 4. Onboarding lần đầu

Mục này là lần "lạc kính" đầu tiên: chạy wizard để cấu hình model, kênh chat và workspace. Làm một lần là các lần sau tự chạy.

> 📄 **Code ví dụ:** [`examples/05-4-onboarding-lan-au.sh`](examples/05-4-onboarding-lan-au.sh)

Wizard (trình hướng dẫn dạng hỏi—đáp) sẽ:
1. Cài **daemon Gateway** vào launchd (chạy nền, tự bật cùng máy)
2. Hỏi chọn model (Claude / Codex / local...) và đăng nhập API key
3. Tạo workspace tại `~/.openclaw/workspace`
4. Cho phép kết nối kênh chat (Discord, Telegram, WhatsApp, Zalo...)

> **Tóm gọn 1 câu:** Onboarding là wizard 4 bước: cài gateway chạy nền, chọn model, tạo workspace, nối kênh chat — làm đúng một lần.

## 5. Lệnh CLI hữu ích

> Danh mục đầy đủ: https://docs.openclaw.ai/cli · hoặc gõ `openclaw --help`

### 5.1. Dùng hằng ngày

> 📄 **Code ví dụ:** [`examples/06-5-1-dung-hang-ngay.sh`](examples/06-5-1-dung-hang-ngay.sh)

### 5.2. Cấu hình

> 📄 **Code ví dụ:** [`examples/07-5-2-cau-hinh.sh`](examples/07-5-2-cau-hinh.sh)

Lưu ý: `configure` cần terminal tương tác (TTY) — tức là cửa sổ gõ lệnh bình thường, không phải chạy trong script tự động; chạy trong script sẽ được in ra
lệnh `config get|set` tương đương để dùng thay thế.

> **Tóm gọn 1 câu:** Nhóm lệnh cấu hình cần terminal tương tác; nếu chạy script mà muốn xem config thì dùng cặp `config get|set`.

### 5.3. Gateway & daemon

> 📄 **Code ví dụ:** [`examples/08-5-3-gateway-daemon.sh`](examples/08-5-3-gateway-daemon.sh)

### 5.4. Chẩn đoán sự cố

> 📄 **Code ví dụ:** [`examples/09-5-4-chan-oan-su-co.sh`](examples/09-5-4-chan-oan-su-co.sh)

### 5.5. Models & auth

> 📄 **Code ví dụ:** [`examples/10-5-5-models-auth.sh`](examples/10-5-5-models-auth.sh)

### 5.6. Kênh chat (WhatsApp, Telegram, Discord...)

> 📄 **Code ví dụ:** [`examples/11-5-6-kenh-chat-whatsapp-telegram-discord.sh`](examples/11-5-6-kenh-chat-whatsapp-telegram-discord.sh)

### 5.7. Skills & plugins

> 📄 **Code ví dụ:** [`examples/12-5-7-skills-plugins.sh`](examples/12-5-7-skills-plugins.sh)

### 5.8. Gửi tin nhắn & agents

> 📄 **Code ví dụ:** [`examples/13-5-8-gui-tin-nhan-agents.sh`](examples/13-5-8-gui-tin-nhan-agents.sh)

### 5.9. Cập nhật, backup, reset

> 📄 **Code ví dụ:** [`examples/14-5-9-cap-nhat-backup-reset.sh`](examples/14-5-9-cap-nhat-backup-reset.sh)

### 5.10. Tự động hoá (cron)

> 📄 **Code ví dụ:** [`examples/15-5-10-tu-ong-hoa-cron.sh`](examples/15-5-10-tu-ong-hoa-cron.sh)

### 5.11a. Profile chrome (khuyến nghị)

**Nodes & browser** (điều khiển máy khác/thiết bị):

> 📄 **Code ví dụ:** [`examples/16-5-11a-profile-chrome-khuyen-nghi.sh`](examples/16-5-11a-profile-chrome-khuyen-nghi.sh)

**Browser profiles** — trạng thái đã cấu hình xong ngày 2026-10-23/24:
mặc định là profile **`chrome`** (extension) để điều khiển browser thật của bạn:

> 📄 **Code ví dụ:** [`examples/17-5-11a-profile-chrome-khuyen-nghi.sh`](examples/17-5-11a-profile-chrome-khuyen-nghi.sh)

Lưu ý sống còn (đã đắt giá học):
- Extension đi qua `chrome.debugger` — không cần debugging port, không bị
  macOS chặn (khác hẳn profile user bên dưới → đã ABANDONED).
- Sau mỗi lần **restart gateway**, extension mất nối relay → bấm icon OpenClaw
  trên toolbar → "Use local OpenClaw" → chờ "Connected" rồi mới chat browser được.
- Tab `chrome://...` và trang Web Store **không script được** — nếu agent kẹt
  enumerate tabs, đóng các tab đặc biệt đó.
- Access mode trong popup để "All tabs" cho agent thấy mọi tab.

> **Tóm gọn 1 câu:** Profile chrome qua extension là đường chính thức: bền, không bị macOS chặn, chỉ nhớ nề nếp "restart gateway là phải bấm reconnect".

---

### 5.11b. Profile user (⚠️ ABANDONED — chỉ để tham khảo)

> ❌ Con đường CDP (CDP/file `DevToolsActivePort` của profile `user`) **bị macOS
> chặn đọc file ở mọi process** (kể cả Terminal) → đã bỏ, dùng extension ở
> 5.11a thay. Nội dung dưới đây chỉ giữ lại để tham khảo.

> 📄 **Code ví dụ:** [`examples/18-5-11b-profile-user-abandoned-chi-e-tham.sh`](examples/18-5-11b-profile-user-abandoned-chi-e-tham.sh)

Cảnh báo: profile user cho agent quyền truy cập session đã đăng nhập —
dùng có chủ đích, đừng để làm default khi model còn nhỏ/đang thử nghiệm.

> **Tóm gọn 1 câu:** Profile user đã bị bỏ vì macOS chặn CDP — chỉ đọc để tham khảo, thực tế dùng profile chrome ở 5.11a.

### 5.12. Flags toàn cục

Mục này liệt kê các cờ (flag) dùng chung cho mọi lệnh `openclaw` — gõ thêm đằng sau là có hiệu lực ngay.

| Flag | Chức năng |
|---|---|
| `--dev` | isolate state vào `~/.openclaw-dev`, port gateway 19001 — cho test |
| `--profile <name>` | chạy setup riêng biệt `~/.openclaw-<name>` (phân tách cá nhân / công việc) |
| `--container <name>` | chạy CLI trong container Docker/Podman đang chạy |
| `--log-level <level>` | đổi mức log cho file + console |
| `--no-color` | tắt màu ANSI |
| `-V`, `--version` | in phiên bản |

> **Cách đọc bảng này:** mỗi dòng là một cờ thêm vào cuối lệnh `openclaw`; hay dùng nhất là `--profile` để tách dữ liệu riêng tư và công việc.

> **Tóm gọn 1 câu:** Flags toàn cục là "công tắc" đằng sau lệnh: `--dev` cho môi trường thử, `--profile` tách vùng dữ liệu, `--no-color` tắt màu.

### 5.13. Lệnh slash trong chat

Mục này là bộ lệnh gõ ngay trong khung chat, không cần ra terminal.

- `/status` — chẩn doán nhanh phiên đang chat
- `/config` — thay đổi config persist
- `/debug` — override config tạm thời (cần `commands.debug: true`)
- `/trace` — bật trace/debug của plugin trong phiên

> **Tóm gọn 1 câu:** Trong khung chat có 4 lệnh slash: `/status` soi phiên, `/config` đổi config, `/debug` ghi đè tạm, `/trace` bật debug plugin.

## 6. Cách khác: app macOS native

Mục này dành cho người ngán terminal: cài app macOS và thao tác bằng giao diện.

Tải từ https://openclaw.ai (macOS 15+, bản Universal) — app chạy ở menu bar,
tự quản gateway, chat, node, đỡ phải thao tác terminal.
Bên trong app: **General → Install CLI** để cài CLI tương ứng.

> **Tóm gọn 1 câu:** Không thích terminal thì cài app native từ openclaw.ai — app tự lo gateway và chat, trong app có nút Install CLI.

## 7. Chạy từ source (cho dev)

> 📄 **Code ví dụ:** [`examples/19-7-chay-tu-source-cho-dev.sh`](examples/19-7-chay-tu-source-cho-dev.sh)

Build app macOS từ source: `./scripts/package-mac-app.sh` (ra `dist/OpenClaw.app`,
cần Xcode 26.2+ / Swift 6.2; không có cert Apple Developer thì tự ký ad-hoc).

> **Tóm gọn 1 câu:** Dev muốn nghịch code gốc thì chạy từ source; build app bằng một script, thiếu chứng chỉ Apple thì tự ký ad-hoc.

## 8. Xử lý lỗi thường gặp

> 📁 **Toàn bộ danh mục lỗi + cách xử lý đã chuyển sang [TROUBLESHOOTING.md](TROUBLESHOOTING.md)** —
> gồm: gateway kẹt "Starting...", lỗi preinstall/`--allow-scripts`, allowlist khoá model,
> lỗi auth "Couldn't sign in", llama-server sai flag / sai PATH / trùng port,
> và các lỗi hay gặp sau khi mở máy.

**Xác nhận cấu hình cá nhân:** config nằm ở `~/.openclaw/openclaw.json`,
workspace ở `~/.openclaw/workspace` — nên tự giữ riêng làm git repo private.

> **Tóm gọn 1 câu:** Lỗi đã dồn hết vào TROUBLESHOOTING.md; nhớ luôn vị trí hai file quan trọng: config và workspace trong `~/.openclaw/`.

## 9. Dùng model local qua llama.cpp

Mục này chỉ đường chạy model AI trên chính máy bạn (không tốn phí API, không gửi dữ liệu đi đâu) và nối OpenClaw vào server đó. "Model local" giống tự nấu ăn ở nhà thay vì đặt đồ ăn: chủ động hơn, nhưng tự lo bếp.

> 📌 **Cập nhật 28/10/2026 (versions):** llama.cpp hiện ở nhánh stable **v3** (repo
> ggml-org/llama.cpp, xem https://github.com/ggml-org/llama.cpp/releases); các flag của `llama-server`
> **đổi giữa các bản** — nếu sau khi upgrade server báo lỗi flag lạ (vd `--reasoning`, `--flash-attn`),
> chạy `llama-server --help` đối chiếu rồi sửa `start-llama.sh` cho khớp. Về Ollama (nếu đi đường
> Ollama thay vì llama.cpp thuần — xem [2-ollama-path.md](2-ollama-path.md)):
> Ollama **không dùng llama.cpp thuần** — nó bundle bản llama.cpp đã patch + engine riêng (MLX trên
> macOS); bản mới nhất 10/2026 là **v0.40.11 (24/10/2026, cập nhật llama.cpp)**, xem
> https://ollama.com/blog và https://github.com/ollama/ollama/releases . Nghĩa là: flag/model behavior
> giữa **Ollama** và **llama-server standalone** không giống nhau — đừng copy lệnh giữa 2 hệ.

OpenClaw chơi được với llama.cpp qua plugin chính thức (chế độ "Existing
llama-server" — OpenClaw chỉ kết nối, bạn tự quản server):

> 📄 **Code ví dụ:** [`examples/20-9-dung-model-local-qua-llama-cpp.sh`](examples/20-9-dung-model-local-qua-llama-cpp.sh)

Chuẩn bị server — nên đặt `--alias` để model ref ổn định qua các lần restart:

> 📄 **Code ví dụ:** [`examples/21-9-dung-model-local-qua-llama-cpp.sh`](examples/21-9-dung-model-local-qua-llama-cpp.sh)

Sửa `~/.openclaw/openclaw.json` thêm:

> 📄 **Code ví dụ:** [`examples/22-9-dung-model-local-qua-llama-cpp.json`](examples/22-9-dung-model-local-qua-llama-cpp.json)

> ⚠️ BẮT BUỘC có `env.vars.LLAMA_SERVER_API_KEY` (giá trị gì cũng được)
> — agent runtime đòi 1 credential cho provider llama-cpp dù server local
> không check key. Thiếu nó → lỗi "missing-provider-auth" mỗi lần chat.
> ❌ KHÔNG đặt `"auth": "none"` vào `models.providers.llama-cpp` — schema
> plugin không cho phép (allowed: api-key/aws-sdk/oauth/token), config sẽ
> invalid và gateway không boot được (dashboard trắng, "Couldn't connect").

Kích hoạt:

> 📄 **Code ví dụ:** [`examples/23-9-dung-model-local-qua-llama-cpp.sh`](examples/23-9-dung-model-local-qua-llama-cpp.sh)

Đã cài xong ngày 2026-10-23, hiện tại: server **`qwen3.5:9b`
(Qwen3.5-9B Q4_K_M, ~6.4GB RAM)** @ 127.0.0.1:8080, context 33k, default =
`llama-cpp/qwen3.5:9b`. Backup config cũ ở
`~/.openclaw/openclaw.json.backup-user`. File `start-llama.sh` đã sync đúng
lệnh server này (script có check "đang chạy rồi thì thôi").

⚠️ Lưu ý:
- Chế độ này server **phải đang chạy** mới chat được — OpenClaw không tự mở.
- Đường đi khác: interactive `openclaw onboard` → chọn "Existing
  llama-server" (có verify tự động) hoặc "Managed local server"
  (OpenClaw tự cài llama-server + tải GGUF, có đưa model recommend theo RAM).

> **Tóm gọn 1 câu:** Chạy model local qua llama.cpp: cắm API key giả vào config (bắt buộc), đừng đặt `auth: none`, và nhớ tự khởi động server mỗi lần mở máy.

## 10. Sau khi tắt máy — mở lại hằng ngày

Mục này trả lời câu hỏi "sáng ra mở máy xong phải làm gì": cái nào tự dậy, cái nào phải bạn gọi. Đọc bảng là biết ngay.

| Thứ | Có cần làm gì không? | Lệnh |
|---|---|---|
| **Gateway OpenClaw** | ❌ KHÔNG — LaunchAgent `ai.openclaw.gateway` có `RunAtLoad` + `KeepAlive`: tự bật khi login + tự revive khi chết | kiểm tra: `openclaw gateway status` |
| **llama-server** | ✅ CÓ — bạn tự quản server, reboot là tắt | `bash ~/Github/open-claw/start-llama.sh` |
| **Dashboard web** | Là tab trình duyệt thôi | `http://127.0.0.1:18789/` hoặc `openclaw dashboard` |

> **Cách đọc bảng này:** mỗi dòng là một thành phần cần "bật" sau khi mở máy; cột giữa nói có phải làm gì không, cột phải là lệnh kiểm tra/chạy tương ứng.

Quy trình ngày mới (30 giây):

> 📄 **Code ví dụ:** [`examples/24-10-sau-khi-tat-may-mo-lai-hang.sh`](examples/24-10-sau-khi-tat-may-mo-lai-hang.sh)

Xong 3 bước là chat hoạt động.

> **Tóm gọn 1 câu:** Gateway tự dậy nhờ LaunchAgent; chỉ có llama-server là phải bạn bật tay mỗi sáng — chạy `start-llama.sh` là xong.

### Lỗi hay gặp sau khi mở máy

> 📁 Danh mục lỗi + fix chi tiết: [TROUBLESHOOTING.md](TROUBLESHOOTING.md) (mục 4).
> Tóm tắt: `command not found: openclaw` → `nvm alias default 26`;
> "No API key for provider llama-cpp" → thêm `LLAMA_SERVER_API_KEY` vào config;
> dashboard trắng sau khi sửa config → `openclaw config validate` + rollback;
> chat lỗi sau reboot → 90% là llama-server chưa chạy, chạy lại `start-llama.sh`.

> **Tóm gọn 1 câu:** Sau reboot, 90% chuyện chat lỗi là do llama-server chưa chạy — còn lại tra TROUBLESHOOTING.md.

## 11. Tham khảo

- Getting started: https://openclaw.ai/getting-started
- Docs / Channels / Skills / Plugins: https://openclaw.ai/docs
- macOS app README (dev + signing): https://github.com/openclaw/openclaw/blob/main/apps/macos/README.md
- Discord cộng đồng: xem link trên trang chủ
- **llama.cpp:** https://github.com/ggml-org/llama.cpp/releases · nhánh stable v3
- **Ollama releases:** https://github.com/ollama/ollama/releases · bản mới nhất: **v0.40.11** (24/10/2026) · tin tức: https://ollama.com/blog
