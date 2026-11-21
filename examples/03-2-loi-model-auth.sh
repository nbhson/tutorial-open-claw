openclaw models status                                 # xem dòng Allowed models + auth readiness
openclaw models auth list                              # key đã lưu cho provider nhánh nào
openclaw models list --provider opencode-go            # model nhánh Go discover được (Auth=yes)
openclaw config unset agents.entries.main.modelPolicy       # allowlist theo-agent
openclaw config unset agents.defaults.models                # allowlist mặc định
openclaw models set opencode-go/<model-muon-mac-dinh>        # chọn model mặc định
openclaw gateway restart
# rồi Cmd+Shift+R để dashboard tải lại danh sách model
