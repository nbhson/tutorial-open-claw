openclaw configure                          # wizard tương tác: model, channels, gateway, plugins, skills...
openclaw configure --section model          # chỉ chỉnh một mục (model | channels | gateway | daemon |
                                            #   memory | web | workspace | plugins | skills | health)
openclaw config get gateway.port            # đọc giá trị config (không tương tác)
openclaw config set gateway.port 18789      # gán giá trị
openclaw config file                        # in đường dẫn file config
openclaw config validate                    # kiểm tra file config hợp lệ
openclaw completion                         # cài autocomplete cho shell
