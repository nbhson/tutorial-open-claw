openclaw config set browser.defaultProfile "chrome"
openclaw config set browser.profiles.chrome '{"driver": "extension"}' --strict-json --merge
openclaw browser extension install          # mở Chrome Web Store → Add "OpenClaw"
openclaw browser extension status           # Extension + native host phải "owned"
openclaw browser --browser-profile chrome tabs   # thấy tab thật = OK
