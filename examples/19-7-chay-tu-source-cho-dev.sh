git clone https://github.com/openclaw/openclaw.git
cd openclaw
pnpm install        # ⚠️ phải dùng pnpm — npm install không được hỗ trợ
pnpm build
pnpm ui:build
pnpm openclaw setup  # lần đầu config workspace
pnpm gateway:watch   # gateway chế độ dev, tự reload khi sửa TypeScript
