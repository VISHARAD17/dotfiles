return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local fzf = require("fzf-lua")

        fzf.setup({
            -- Pick a style: 'dropdown', 'ivy', or 'vertical'
            winopts = {
                height     = 0.85,
                width      = 0.80,
                preview = {
                    layout   = 'vertical',
                    vertical = 'down:45%',
                },
            },

            files = {
                -- 'fd' is used for file searches
                -- Added --exclude '*.class'
                fd_opts = [[--color=never --type f --hidden --follow --exclude bin --exclude '*.class' --exclude build]],
            },
            grep = {
                -- 'rg' (ripgrep) is used for live grep searches
                -- Added -g '!*.class'
                rg_opts = [[--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -g '!bin/*' -g '!*.class' -g '!build/*']],
            },

            keymap = {
                builtin = {
                    -- Inside the fzf window, use these to scroll the preview
                    ["<F1>"]     = "toggle-help",
                    ["<F2>"]     = "toggle-fullscreen",
                    ["<C-f>"]    = "preview-page-down",
                    ["<C-b>"]    = "preview-page-up",
                },
            },
        })

        -- --- Keybindings ---
        local map = vim.keymap.set

        map('n', '<leader>ff', fzf.files, { desc = "Fzf Files" })
        map('n', '<leader>fg', fzf.live_grep, { desc = "Fzf Live Grep" })
        map('n', '<leader>fb', fzf.buffers, { desc = "Fzf Buffers" })
        map('n', '<leader>fh', fzf.help_tags, { desc = "Fzf Help" })
        map('n', '<leader>fr', fzf.resume, { desc = "Fzf Resume last search" })
    end
}
