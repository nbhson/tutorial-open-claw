# TROUBLESHOOTING — Xử lý lỗi thường gặp

> Toàn bộ lỗi đã gặp thật (kèm ngày) khi cài và chạy OpenClaw trên macOS.
> Repo gốc: [README.md](README.md) — mục 8 và mục 10 đã gom về đây.

---

## 1. Lỗi khi cài đặt

Signpost: mục này xử lý các vấp ngã ngay bước "về đích đầu tiên" — cài chưa xong đã kẹt.

**Gateway kẹt ở "Starting..."** — có thể zombie process giữ port 18789:

> 📄 **Code ví dụ:** [`examples/01-1-loi-khi-cai-at.sh`](examples/01-1-loi-khi-cai-at.sh)

**Lỗi preinstall khi `npm install -g`:**
`this OpenClaw release requires Node >=24.22.1 <25 || >=26.12.1` → Node đang dùng
quá cũ, `nvm use 26` rồi cài lại.

**Cảnh báo `install-scripts` của npm 11/12** → cài lại với `--allow-scripts=...`
như mục 3 trong README:

> 📄 **Code ví dụ:** [`examples/02-1-loi-khi-cai-at.sh`](examples/02-1-loi-khi-cai-at.sh)

> **Tóm gọn 1 câu:** Lỗi cài đặt thường là "kẹt cửa" chứ không phải "hỏng nhà" — bắt đúng process/port/version kẹt là đi tiếp được ngay.

---

## 2. Lỗi model & auth

Signpost: mục này xử lý nhóm lỗi phổ biến nhất: model không hiện, không auth được, hoặc chọn nhầm nhánh model cần subscription riêng.

**Model không hiện trên thanh chat (dashboard)** → có allowlist khoá model.
Kiểm tra: `openclaw models status` (xem dòng `Allowed models`) và
`grep -n "modelPolicy\|models" ~/.openclaw/openclaw.json`. Xoá hạn chế:

> 📄 **Code ví dụ:** [`examples/03-2-loi-model-auth.sh`](examples/03-2-loi-model-auth.sh)

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

Giống như bạn cầm chìa khóa đúng cửa nhưng chìa khóa đó chưa được đăng ký trong sổ của bảo vệ — key hợp lệ không đủ, nó phải được cấp cho **đúng nhánh** model đó và tài khoản phải có subscription tương ứng. Lỗi nhóm này gần như luôn tra được bằng log trước, sửa config sau.

> **Tóm gọn 1 câu:** Lỗi model/auth: mở log đọc lỗi thật trước — 9/10 là sai nhánh prefix hoặc thiếu subscription, không phải key hỏng.

---

## 3. Lỗi llama-server / model local

Signpost: mục này dành cho đường llama.cpp thuần — các lỗi flag, PATH và port xung đột khi tự quản server model.

**llama-server lỗi flag sau khi upgrade llama.cpp (vd `unrecognized argument: --reasoning`)**
→ các flag của llama.cpp **đổi giữa các bản** (nhánh stable hiện là v3). Giống như điện thoại cập nhật OS xong đổi chỗ mấy nút bấm — app cũ bấm theo trí nhớ là báo lỗi; đối chiếu:
`llama-server --help | grep -E "reasoning|flash"`, rồi sửa `start-llama.sh` cho khớp
cú pháp bản mới. Sau khi sửa, test trực tiếp trước:

> 📄 **Code ví dụ:** [`examples/04-3-loi-llama-server-model-local.sh`](examples/04-3-loi-llama-server-model-local.sh)

**`command not found: llama` / `llama-server`** (script `start-llama.sh` exit sớm) →
binary không nằm trong PATH của shell hiện tại (hay gặp khi cài qua brew ở
terminal khác, hoặc build tay ở thư mục khác). Sửa biến `LLAMA_BIN` trong
`start-llama.sh` trỏ đường dẫn tuyệt đối tới binary, hoặc `brew link` lại.

**Port 8080 bị chiếm bởi process khác** → `lsof -nP -iTCP:8080 -sTCP:LISTEN`
tìm process; nếu không phải llama-server cũ thì đổi port trong `start-llama.sh`
+ sửa `baseUrl` trong `~/.openclaw/openclaw.json` cho khớp rồi
`openclaw gateway restart`.

> **Tóm gọn 1 câu:** Model local trục trặc thì đoán bằng cách "hỏi trực tiếp bản thân nó": chạy `--help`, check PATH, check port — rồi mới sửa script.

---

## 4. Lỗi hay gặp sau khi mở máy

Signpost: mục này cho buổi sáng mở máy lên mà mọi thứ "lập dị" — từ `command not found` tới dashboard trắng.

**`command not found: openclaw`** trong terminal mới → Node mặc định của nvm
vẫn là 22, trong khi openclaw cài trên Node 26:

> 📄 **Code ví dụ:** [`examples/05-4-loi-hay-gap-sau-khi-mo-may.sh`](examples/05-4-loi-hay-gap-sau-khi-mo-may.sh)

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

Hãy hình dung buổi mở máy như buổi sớm quán ăn: gateway là nhân viên luôn có mặt trước, còn llama-server là bếp — bếp chưa bật thì order bao nhiêu cũng "món chưa làm được". 90% lỗi sau reboot chỉ là bếp chưa bật.

> **Tóm gọn 1 câu:** Lỗi sau mở máy: chờ 30 giây cho gateway nạp, chạy lại `start-llama.sh` cho model — hai việc đó xử lý phần lớn trường hợp.

---

## 5. Xác nhận cấu hình cá nhân

Signpost: mục này chốt việc lưu trữ config — làm một lần để lần sau khỏi tìm lại từ đầu.

Config nằm ở `~/.openclaw/openclaw.json`, workspace ở `~/.openclaw/workspace`
— nên tự giữ riêng làm git repo private.

> **Tóm gọn 1 câu:** Config là "sổ tay căn cước" của OpenClaw — đưa nó vào git private là có bản sao, có lịch sử, và rollback được mỗi khi config sai.
