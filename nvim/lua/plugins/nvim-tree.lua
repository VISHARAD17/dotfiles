return {
    'nvim-tree/nvim-tree.lua',
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        lazy = true
    },
    config = function()

        require('nvim-web-devicons').setup({
            default = true,
        })
        require("nvim-tree").setup({
            update_focused_file = {
                enable = true,
                update_root = true,
                ignore_list = {},
                update_cwd = true,
            },
            filters = {
                custom = {
                    "^.git$",
                    "node_modules",
                },
            },
            git = {
                enable=true,
                ignore=false,
                timeout=500
            },
            renderer = {
                highlight_opened_files = "all",
                -- root_folder_label = true, -- disable this when using left side file-tree
                root_folder_modifier = ":t", -- comment this out when using left size file-tree
                -- These icons are visible when you install web-devicons
                icons = {
                    glyphs = {
                        default = "",
                        symlink = "",
                        folder = {
                            arrow_open = "",
                            arrow_closed = "",
                            default = "",
                            open = "",
                            empty = "",
                            empty_open = "",
                            symlink = "",
                            symlink_open = "",
                        },
                        git = {
                            unstaged = "M",      -- Modified (unstaged changes)
                            staged = "S",        -- Staged changes
                            unmerged = "U",      -- Unmerged changes (conflicts)
                            renamed = "R",       -- Renamed files
                            untracked = "?",      -- Untracked files
                            deleted = "D",       -- Deleted files
                            ignored = "◌",       -- Ignored files
                        }
                    },
                },
                indent_markers = {
                    enable = true,
                    inline_arrows = true,
                    icons = {
                        --     corner = "└─",
                        edge = "│",
                        --     item = "├─",
                        --     none = "  ",
                    },
                },
            },
            diagnostics = {
                enable = true,
                show_on_dirs = false,
                icons = {
                    error = "✘",
                    warning = "▲",
                    hint = "⚑",
                    info = "»"
                },
            },
            view = {
                float = {
                    enable = true,
                    open_win_config = function()
                        local screen_w = vim.opt.columns:get()
                        local w_h = 100
                        local s_h = 42
                        local center_x = (screen_w - w_h) / 2
                        local center_y = ((vim.opt.lines:get() - s_h) / 5) - vim.opt.cmdheight:get()
                        return {
                            border = "rounded",
                            relative = "editor",
                            row = center_y,
                            col = center_x,
                            width = w_h,
                            height = s_h,
                        }
                    end,
                },
                width = function()
                    return math.floor(vim.opt.columns:get() * 5)
                end,
            },
            --  use this for left side  nvim-tree
            -- view = {
            --     width = 30,
            --     side = "left"
            -- },
        })

    end
}
