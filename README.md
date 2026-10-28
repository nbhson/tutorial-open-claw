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

⚠️ Node 22 **không đủ** — cài đặt sẽ báo lỗi ngay ở bước preinstall.

## 2. Cài Node 26 bằng nvm

Máy dùng nvm, mặc định đang là Node 22 nên phải nâng lên:

```bash
source ~/.nvm/nvm.sh
nvm install 26          # tải bản v26 mới nhất (lúc cài: v26.12.1)
nvm use 26              # dùng cho phiên làm việc hiện tại
nvm alias default 26    # đưa Node 26 lên mặc định (nên làm, vì OpenClaw cần Node 26)
```

Kiểm tra:

```bash
node --version   # phải là v26.x
```

## 3. Cài OpenClaw bằng npm

```bash
npm install -g openclaw@latest --allow-scripts=@google/genai,esbuild,koffi,openclaw,protobufjs
```

Giải thích:
- npm 11.16+ / 12 mặc định **chặn install scripts**. Nếu bỏ `--allow-scripts`, các package
  `openclaw` (bundled plugins), `esbuild`, `koffi` (native bindings) sẽ KHÔNG được build đúng
  → phải cài lại có cờ này.
- Cài xong kiểm tra:

```bash
openclaw --version
# OpenClaw 2026.10.7 (fe06181)
```

## 4. Onboarding lần đầu

Chạy trong terminal riêng (wizard tương tác, cần nhập lựa chọn + xác thực qua trình duyệt):

```bash
openclaw onboard --install-daemon
```

Wizard sẽ:
1. Cài **daemon Gateway** vào launchd (chạy nền, tự bật cùng máy)
2. Hỏi chọn model (Claude / Codex / local...) và đăng nhập API key
3. Tạo workspace tại `~/.openclaw/workspace`
4. Cho phép kết nối kênh chat (Discord, Telegram, WhatsApp, Zalo...)

## 5. Lệnh CLI hữu ích

> Danh mục đầy đủ: https://docs.openclaw.ai/cli · hoặc gõ `openclaw --help`

### 5.1. Dùng hằng ngày

```bash
openclaw status            # tổng quan: channels, sessions; thêm --usage để xem quota, --deep để quét sâu
openclaw gateway status    # Gateway có đang chạy không
openclaw dashboard         # mở dashboard điều khiển trên trình duyệt
openclaw health            # kiểm tra sức khỏe tổng thể
openclaw chat              # chat với assistant ngay trong terminal (alias của `tui --local`)
openclaw logs              # xem log gần đây nhất
```

### 5.2. Cấu hình

```bash
openclaw configure                          # wizard tương tác: model, channels, gateway, plugins, skills...
openclaw configure --section model          # chỉ chỉnh một mục (model | channels | gateway | daemon |
                                            #   memory | web | workspace | plugins | skills | health)
openclaw config get gateway.port            # đọc giá trị config (không tương tác)
openclaw config set gateway.port 18789      # gán giá trị
openclaw config file                        # in đường dẫn file config
openclaw config validate                    # kiểm tra file config hợp lệ
openclaw completion                         # cài autocomplete cho shell
```

Lưu ý: `configure` cần terminal tương tác (TTY); chạy trong script sẽ được in ra
lệnh `config get|set` tương đương để dùng thay thế.

### 5.3. Gateway & daemon

```bash
openclaw gateway start | stop | restart    # điều khiển gateway thủ công
openclaw gateway install | uninstall       # quản lý service chạy nền (launchd/systemd)
openclaw gateway probe                     # kiểm tra gateway còn phản hồi
openclaw gateway run --port 18789 --verbose  # chạy foreground để debug
openclaw daemon status                     # alias của gateway service
```

### 5.4. Chẩn đoán sự cố

```bash
openclaw doctor                # chẩn đoán: config, gateway, plugins, model routing...
openclaw doctor --fix          # tự sửa các lỗi phát hiện được
openclaw doctor --deep         # quét cả system service cài thừa
openclaw triage                # chuyên gia đọc log chỉ ra vấn đề
openclaw channels status --probe   # probe từng kênh đang cấu hình
openclaw channels logs         # log gần đây của các kênh
openclaw audit                 # rà soát session/alarm
```

### 5.5. Models & auth

```bash
openclaw models list           # các model khả dụng
openclaw models set            # đặt model mặc định
openclaw models status         # model đang dùng + trạng thái auth
openclaw models auth list      # profiles xác thực với từng provider
openclaw models auth login     # thêm xác thực provider
openclaw models auth paste-api-key --provider <p> --profile-id <p>:default
                               # lưu API key non-interactive (nhắc paste key)
openclaw status --usage        # quota/tỷ lệ dùng của Anthropic, OpenAI, z.ai...
```

### 5.6. Kênh chat (WhatsApp, Telegram, Discord...)

```bash
openclaw channels list --all   # kênh đã cấu hình + các kênh cài được
openclaw channels add          # wizard thêm kênh
openclaw channels add --channel telegram --account alerts --token $TELEGRAM_BOT_TOKEN
openclaw channels remove --channel discord --account work --delete
openclaw channels login        # đăng nhập kênh (VD: quét QR WhatsApp)
openclaw channels logout
openclaw pairing list          # xem ai đang xin ghép đôi vào kênh
openclaw pairing approve <channel> <code>   # duyệt ghép đôi
```

### 5.7. Skills & plugins

```bash
openclaw skills search "calendar"    # tìm skill trên ClawHub
openclaw skills install <name>       # cài skill
openclaw skills list                 # skills đã có trong workspace
openclaw plugins list                # plugin đang tải
openclaw plugins install <name>      # cài plugin
openclaw plugins enable|disable <name>
openclaw plugins doctor              # báo lỗi load plugin
openclaw mcp list                    # các MCP server đã cấu hình
```

### 5.8. Gửi tin nhắn & agents

```bash
openclaw message send --channel telegram --chat <id> "Chào"
openclaw message broadcast "Hello everyone"    # gửi tới mọi kênh đã cấu hình
openclaw agents list          # các agent trong bộ
openclaw agents add           # thêm agent riêng biệt
```

### 5.9. Cập nhật, backup, reset

```bash
openclaw update               # cập nhật bản mới (--update là shorthand)
openclaw update wizard        # cập nhật kèm wizard hướng dẫn
openclaw update repair        # sửa cài đặt bị hỏng
openclaw backup create        # backup state/config
openclaw backup verify        # kiểm tra backup còn dùng được
openclaw backup restore <backup>   # phục hồi
openclaw migrate plan|apply <provider>   # chuyển nhà database (sqlite ↔ postgres)
openclaw reset                # reset toàn bộ setup (cẩn trọng!)
openclaw uninstall            # gỡ sạch
```

### 5.10. Tự động hoá (cron)

```bash
openclaw cron add             # thêm job chạy định kỳ cho agent
openclaw cron list            # danh sách automation
openclaw cron run <id>        # chạy ngay một job
openclaw cron enable|disable <id>
openclaw hooks list           # hooks (tác động theo sự kiện)
openclaw webhooks gmail setup # nhận thư Gmail trigger agent
```

### 5.11a. Profile chrome (khuyến nghị)

**Nodes & browser** (điều khiển máy khác/thiết bị):

```bash
openclaw nodes list           # các node (điện thoại, máy khác) đã ghép đôi
openclaw nodes approve        # duyệt node mới xin kết nối
openclaw node install         # biến máy này thành node điều khiển từ xa
openclaw browser start        # bật trình duyệt tự động (nếu status vẫn running:false)
openclaw browser open https://example.com   # cho agent điều khiển trình duyệt
openclaw browser screenshot   # chụp ảnh trang đang mở
```

**Browser profiles** — trạng thái đã cấu hình xong ngày 2026-10-23/24:
mặc định là profile **`chrome`** (extension) để điều khiển browser thật của bạn:

```bash
openclaw config set browser.defaultProfile "chrome"
openclaw config set browser.profiles.chrome '{"driver": "extension"}' --strict-json --merge
openclaw browser extension install          # mở Chrome Web Store → Add "OpenClaw"
openclaw browser extension status           # Extension + native host phải "owned"
openclaw browser --browser-profile chrome tabs   # thấy tab thật = OK
```

Lưu ý sống còn (đã đắt giá học):
- Extension đi qua `chrome.debugger` — không cần debugging port, không bị
  macOS chặn (khác hẳn profile user bên dưới → đã ABANDONED).
- Sau mỗi lần **restart gateway**, extension mất nối relay → bấm icon OpenClaw
  trên toolbar → "Use local OpenClaw" → chờ "Connected" rồi mới chat browser được.
- Tab `chrome://...` và trang Web Store **không script được** — nếu agent kẹt
  enumerate tabs, đóng các tab đặc biệt đó.
- Access mode trong popup để "All tabs" cho agent thấy mọi tab.

---

### 5.11b. Profile user (⚠️ ABANDONED — chỉ để tham khảo)

> ❌ Con đường CDP (CDP/file `DevToolsActivePort` của profile `user`) **bị macOS
> chặn đọc file ở mọi process** (kể cả Terminal) → đã bỏ, dùng extension ở
> 5.11a thay. Nội dung dưới đây chỉ giữ lại để tham khảo.

```bash
# 1. Chrome đang dùng → chrome://inspect/#remote-debugging → bật debugging
# 2. Kết nối vào session thật:
openclaw browser --browser-profile user start       # Chrome sẽ prompt "Allow" → bấm Allow
openclaw browser --browser-profile user tabs        # xác nhận thấy tab thật
openclaw config set browser.defaultProfile "user"   # làm mặc định (tuỳ chọn)
```

Cảnh báo: profile user cho agent quyền truy cập session đã đăng nhập —
dùng có chủ đích, đừng để làm default khi model còn nhỏ/đang thử nghiệm.

### 5.12. Flags toàn cục

| Flag | Chức năng |
|---|---|
| `--dev` | isolate state vào `~/.openclaw-dev`, port gateway 19001 — cho test |
| `--profile <name>` | chạy setup riêng biệt `~/.openclaw-<name>` (phân tách cá nhân / công việc) |
| `--container <name>` | chạy CLI trong container Docker/Podman đang chạy |
| `--log-level <level>` | đổi mức log cho file + console |
| `--no-color` | tắt màu ANSI |
| `-V`, `--version` | in phiên bản |

### 5.13. Lệnh slash trong chat

Trong khung chat (dashboard hoặc TUI) có thể dùng:

- `/status` — chẩn doán nhanh phiên đang chat
- `/config` — thay đổi config persist
- `/debug` — override config tạm thời (cần `commands.debug: true`)
- `/trace` — bật trace/debug của plugin trong phiên

## 6. Cách khác: app macOS native

Tải từ https://openclaw.ai (macOS 15+, bản Universal) — app chạy ở menu bar,
tự quản gateway, chat, node, đỡ phải thao tác terminal.
Bên trong app: **General → Install CLI** để cài CLI tương ứng.

## 7. Chạy từ source (cho dev)

```bash
git clone https://github.com/openclaw/openclaw.git
cd openclaw
pnpm install        # ⚠️ phải dùng pnpm — npm install không được hỗ trợ
pnpm build
pnpm ui:build
pnpm openclaw setup  # lần đầu config workspace
pnpm gateway:watch   # gateway chế độ dev, tự reload khi sửa TypeScript
```

Build app macOS từ source: `./scripts/package-mac-app.sh` (ra `dist/OpenClaw.app`,
cần Xcode 26.2+ / Swift 6.2; không có cert Apple Developer thì tự ký ad-hoc).

## 8. Xử lý lỗi thường gặp

> 📁 **Toàn bộ danh mục lỗi + cách xử lý đã chuyển sang [TROUBLESHOOTING.md](TROUBLESHOOTING.md)** —
> gồm: gateway kẹt "Starting...", lỗi preinstall/`--allow-scripts`, allowlist khoá model,
> lỗi auth "Couldn't sign in", llama-server sai flag / sai PATH / trùng port,
> và các lỗi hay gặp sau khi mở máy.

**Xác nhận cấu hình cá nhân:** config nằm ở `~/.openclaw/openclaw.json`,
workspace ở `~/.openclaw/workspace` — nên tự giữ riêng làm git repo private.

## 9. Dùng model local qua llama.cpp

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

```bash
openclaw plugins install @openclaw/llama-cpp-provider
```

Chuẩn bị server — nên đặt `--alias` để model ref ổn định qua các lần restart:

```bash
llama-server --model /path/to/model.gguf --alias qwen3.5:9b \
  --host 127.0.0.1 --port 8080
```

Sửa `~/.openclaw/openclaw.json` thêm:

```json
"env": {
  "vars": {
    "LLAMA_SERVER_API_KEY": "llama-local"
  }
},
"models": {
  "mode": "merge",
  "providers": {
    "llama-cpp": {
      "baseUrl": "http://127.0.0.1:8080/v1",
      "api": "openai-completions",
      "request": { "allowPrivateNetwork": true },
      "models": []
    }
  }
}
```

> ⚠️ BẮT BUỘC có `env.vars.LLAMA_SERVER_API_KEY` (giá trị gì cũng được)
> — agent runtime đòi 1 credential cho provider llama-cpp dù server local
> không check key. Thiếu nó → lỗi "missing-provider-auth" mỗi lần chat.
> ❌ KHÔNG đặt `"auth": "none"` vào `models.providers.llama-cpp` — schema
> plugin không cho phép (allowed: api-key/aws-sdk/oauth/token), config sẽ
> invalid và gateway không boot được (dashboard trắng, "Couldn't connect").

Kích hoạt:

```bash
openclaw models list --refresh --provider llama-cpp   # discover từ /models + /props
openclaw config set agents.defaults.model.primary "llama-cpp/<model-id>"
openclaw gateway restart
```

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

## 10. Sau khi tắt máy — mở lại hằng ngày

| Thứ | Có cần làm gì không? | Lệnh |
|---|---|---|
| **Gateway OpenClaw** | ❌ KHÔNG — LaunchAgent `ai.openclaw.gateway` có `RunAtLoad` + `KeepAlive`: tự bật khi login + tự revive khi chết | kiểm tra: `openclaw gateway status` |
| **llama-server** | ✅ CÓ — bạn tự quản server, reboot là tắt | `bash ~/Github/open-claw/start-llama.sh` |
| **Dashboard web** | Là tab trình duyệt thôi | `http://127.0.0.1:18789/` hoặc `openclaw dashboard` |

Quy trình ngày mới (30 giây):

```bash
# 1. Mở máy — gateway tự chạy, xác nhận lại nếu muốn:
openclaw gateway status

# 2. Bật llama-server (script có check "đang chạy rồi thì thôi"):
bash ~/Github/open-claw/start-llama.sh

# 3. Mở dashboard:
openclaw dashboard
```

Xong 3 bước là chat hoạt động.

### Lỗi hay gặp sau khi mở máy

> 📁 Danh mục lỗi + fix chi tiết: [TROUBLESHOOTING.md](TROUBLESHOOTING.md) (mục 4).
> Tóm tắt: `command not found: openclaw` → `nvm alias default 26`;
> "No API key for provider llama-cpp" → thêm `LLAMA_SERVER_API_KEY` vào config;
> dashboard trắng sau khi sửa config → `openclaw config validate` + rollback;
> chat lỗi sau reboot → 90% là llama-server chưa chạy, chạy lại `start-llama.sh`.

## 11. Tham khảo

- Getting started: https://openclaw.ai/getting-started
- Docs / Channels / Skills / Plugins: https://openclaw.ai/docs
- macOS app README (dev + signing): https://github.com/openclaw/openclaw/blob/main/apps/macos/README.md
- Discord cộng đồng: xem link trên trang chủ
- **llama.cpp:** https://github.com/ggml-org/llama.cpp/releases · nhánh stable v3
- **Ollama releases:** https://github.com/ollama/ollama/releases · bản mới nhất: **v0.40.11** (24/10/2026) · tin tức: https://ollama.com/blog
