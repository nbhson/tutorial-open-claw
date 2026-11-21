openclaw models list           # các model khả dụng
openclaw models set            # đặt model mặc định
openclaw models status         # model đang dùng + trạng thái auth
openclaw models auth list      # profiles xác thực với từng provider
openclaw models auth login     # thêm xác thực provider
openclaw models auth paste-api-key --provider <p> --profile-id <p>:default
                               # lưu API key non-interactive (nhắc paste key)
openclaw status --usage        # quota/tỷ lệ dùng của Anthropic, OpenAI, z.ai...
