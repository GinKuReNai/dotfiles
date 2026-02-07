local wezterm = require 'wezterm'
local config = {}

-- Windows で動作している場合
if wezterm.target_triple:find("windows") then
    -- デフォルトの接続先に WSL を設定
    config.default_domain = "WSL:Ubuntu"

    -- フォントサイズ
    config.font_size = 10.0

    -- ランチャーに WSL2 を追加する
    config.launch_menu = {
        {
            label = "Ubuntu 22.04",
            args = { "wsl.exe", "-d", "Ubuntu" }
        }
    }

    -- WSL 起動時に tmux を実行するように
    config.default_prog = { "wsl.exe", "-d", "Ubuntu", "-e", "tmux" }
end

return config
