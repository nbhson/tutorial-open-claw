openclaw models list --refresh --provider llama-cpp   # discover từ /models + /props
openclaw config set agents.defaults.model.primary "llama-cpp/<model-id>"
openclaw gateway restart
