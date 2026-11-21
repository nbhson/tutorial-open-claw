# 1. Chrome đang dùng → chrome://inspect/#remote-debugging → bật debugging
# 2. Kết nối vào session thật:
openclaw browser --browser-profile user start       # Chrome sẽ prompt "Allow" → bấm Allow
openclaw browser --browser-profile user tabs        # xác nhận thấy tab thật
openclaw config set browser.defaultProfile "user"   # làm mặc định (tuỳ chọn)
