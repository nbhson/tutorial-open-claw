openclaw channels list --all   # kênh đã cấu hình + các kênh cài được
openclaw channels add          # wizard thêm kênh
openclaw channels add --channel telegram --account alerts --token $TELEGRAM_BOT_TOKEN
openclaw channels remove --channel discord --account work --delete
openclaw channels login        # đăng nhập kênh (VD: quét QR WhatsApp)
openclaw channels logout
openclaw pairing list          # xem ai đang xin ghép đôi vào kênh
openclaw pairing approve <channel> <code>   # duyệt ghép đôi
