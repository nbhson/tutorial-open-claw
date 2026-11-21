openclaw gateway start | stop | restart    # điều khiển gateway thủ công
openclaw gateway install | uninstall       # quản lý service chạy nền (launchd/systemd)
openclaw gateway probe                     # kiểm tra gateway còn phản hồi
openclaw gateway run --port 18789 --verbose  # chạy foreground để debug
openclaw daemon status                     # alias của gateway service
