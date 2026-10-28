# TROUBLESHOOTING — Xử lý lỗi thường gặp

> Toàn bộ lỗi đã gặp thật (kèm ngày) khi cài và chạy OpenClaw trên macOS.
> Repo gốc: [README.md](README.md) — mục 8 và mục 10 đã gom về đây.

---

## 1. Lỗi khi cài đặt

**Gateway kẹt ở "Starting..."** — có thể zombie process giữ port 18789:

```bash
openclaw gateway stop
lsof -nP -iTCP:18789 -sTCP:LISTEN   # tìm process giữ port
```

**Lỗi preinstall khi `npm install -g`:**
`this OpenClaw release requires Node >=24.22.1 <25 || >=26.12.1` → Node đang dùng
quá cũ, `nvm use 26` rồi cài lại.

**Cảnh báo `install-scripts` của npm 11/12** → cài lại với `--allow-scripts=...`
như mục 3 trong README:

```bash
npm install -g openclaw@latest --allow-scripts=@google/genai,esbuild,koffi,openclaw,protobufjs
```

---

## 2. Lỗi model & auth

**Model không hiện trên thanh chat (dashboard)** → có allowlist khoá model.
Kiểm tra: `openclaw models status` (xem dòng `Allowed models`) và
`grep -n "modelPolicy\|models" ~/.openclaw/openclaw.json`. Xoá hạn chế:

```bash
openclaw models status                                 # xem dòng Allowed models + auth readiness
openclaw models auth list                              # key đã lưu cho provider nhánh nào
openclaw models list --provider opencode-go            # model nhánh Go discover được (Auth=yes)
openclaw config unset agents.entries.main.modelPolicy       # allowlist theo-agent
openclaw config unset agents.defaults.models                # allowlist mặc định
openclaw models set opencode-go/<model-muon-mac-dinh>        # chọn model mặc định
openclaw gateway restart
# rồi Cmd+Shift+R để dashboard tải lại danh sách model
```

Lưu ý: catalog OpenCode có 2 nhánh prefix — `opencode/...` (Zen) và
`opencode-go/...` (Go, cần subscription Go riêng). Key chỉ lưu cho nhánh nào
thì model nhánh đó mới auth được; kiểm tra bằng `openclaw models list
--provider <prefix>` và `openclaw models status`.

📍 Lỗi này đã gặp thật ngày 2026-10-23: allowlist nằm ở
`agents.entries.main.modelPolicy.allow` (chỉ chứa 2 model không có auth).

**Chat lỗi "Couldn't sign in to the AI service" / "Provider opencode-go has
auth issue"** → mở log xem lỗi thật:
`grep -i "rawErrorPreview" /tmp/openclaw/openclaw-<ngày>.log | tail -3`.
Đã gặp ngày 2026-10-23: `403 ... An active OpenCode Go subscription is
required to use Go models` — API key hợp lệ nhưng **tài khoản chưa có
subscription OpenCode Go**. Fix đã áp dụng: nhập cùng 1 key cho nhánh Zen
(`openclaw models auth paste-api-key --provider opencode --profile-id
opencode:default`) và đổi default sang model free:
`openclaw config set agents.defaults.model.primary "opencode/glm-5.3-flash-free"`
rồi `openclaw gateway restart`. Muốn lại dùng Go: subscribe tại opencode.ai
→ bảo mình restart gateway là config cũ chạy lại.

**Lỗi "Unknown model: opencode-go/..." sau khi chọn model mới** → cache
catalog gateway chưa refresh:
`openclaw models list --refresh --provider <prefix>`.

---

## 3. Lỗi llama-server / model local

**llama-server lỗi flag sau khi upgrade llama.cpp (vd `unrecognized argument: --reasoning`)**
→ các flag của llama.cpp **đổi giữa các bản** (nhánh stable hiện là v3). Đối chiếu:
`llama-server --help | grep -E "reasoning|flash"`, rồi sửa `start-llama.sh` cho khớp
cú pháp bản mới. Sau khi sửa, test trực tiếp trước:

```bash
llama-server --version
bash ~/Github/open-claw/start-llama.sh   # script có check "đang chạy rồi thì thôi"
curl -s http://127.0.0.1:8080/v1/models   # phải trả JSON model qwen3.5:9b
```

**`command not found: llama` / `llama-server`** (script `start-llama.sh` exit sớm) →
binary không nằm trong PATH của shell hiện tại (hay gặp khi cài qua brew ở
terminal khác, hoặc build tay ở thư mục khác). Sửa biến `LLAMA_BIN` trong
`start-llama.sh` trỏ đường dẫn tuyệt đối tới binary, hoặc `brew link` lại.

**Port 8080 bị chiếm bởi process khác** → `lsof -nP -iTCP:8080 -sTCP:LISTEN`
tìm process; nếu không phải llama-server cũ thì đổi port trong `start-llama.sh`
+ sửa `baseUrl` trong `~/.openclaw/openclaw.json` cho khớp rồi
`openclaw gateway restart`.

---

## 4. Lỗi hay gặp sau khi mở máy

**`command not found: openclaw`** trong terminal mới → Node mặc định của nvm
vẫn là 22, trong khi openclaw cài trên Node 26:

```bash
nvm alias default 26    # chạy 1 lần duy nhất
```

**"No API key found for provider llama-cpp" khi chat** → cần credential
placeholder (llama.cpp không check key nhưng OpenClaw vẫn đòi): thêm
`"env": { "vars": { "LLAMA_SERVER_API_KEY": "llama-local" } }` vào
`~/.openclaw/openclaw.json` + `openclaw gateway restart`. Đích thân lỗi này
đã gặp ngày 2026-10-23 — fix trong 1 phút.

**Dashboard trắng + "Couldn't connect to OpenClaw" sau khi sửa config** →
config invalid làm gateway không boot. Xem lỗi thật:
`openclaw config validate`. CNTT hay gặp: `auth: "none"` trái schema
plugin llama-cpp. Rollback nhanh: `cp ~/.openclaw/openclaw.json.bak
~/.openclaw/openclaw.json && openclaw gateway restart`.

**Chat báo lỗi nhắc "Couldn't sign in / model failed" sau khi reboot** → 90%
là llama-server chưa chạy (gateway tự sống nhưng model local thì không).
Fix: chạy lại `start-llama.sh` rồi thử chat lại.

**Dashboard trắng / không kết nối được** → gateway chưa kịp nạp (30s đầu sau
login). Chờ ít giây rồi refresh; nếu vẫn lỗi: `openclaw gateway restart`.

Muốn llama-server tự khởi động luôn như gateway: tạo LaunchAgent riêng
(`llctl` của llama.cpp hoặc run script này qua launchd) — hỏi mình khi cần.

---

## 5. Xác nhận cấu hình cá nhân

Config nằm ở `~/.openclaw/openclaw.json`, workspace ở `~/.openclaw/workspace`
— nên tự giữ riêng làm git repo private.
