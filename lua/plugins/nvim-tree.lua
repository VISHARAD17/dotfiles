return {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
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
                root_folder_modifier = ":t",
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
                            ignored = "I",       -- Ignored files
                        }
                    },
                },
                indent_markers = {
                    enable = true,
                    inline_arrows = true,
                    icons = {
                        corner = "└─",
                        edge = "│ ",
                        item = "├─",
                        none = "  ",
                    },
                },
            },
            diagnostics = {
                enable = true,
                show_on_dirs = false,
                icons = {
                    hint = "",
                    info = "",
                    warning = "",
                    error = "",
                },
            },
            view = {
                width = 30,
                side = "left",
            },
        })

    end
}
