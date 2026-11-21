openclaw models list --refresh --provider ollama    # discover từ /v1/models
openclaw config set agents.defaults.model.primary "ollama/qwen3.5:9b"
openclaw gateway restart
