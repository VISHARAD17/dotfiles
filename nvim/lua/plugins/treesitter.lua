return
    {   "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = {
                    "c","cpp", "lua", "vim", "vimdoc", "query", "elixir",
                    "heex", "javascript", "typescript", "html", "dockerfile", "json", "vim", "regex","sql", "graphql",
                    "java", "markdown", "markdown_inline", "bash", "tsx", "python"
                },
                auto_install = true,
                sync_install = false,
                highlight = {
                    enable = true,
                    disable = function(lang, buf)
                        local max_filesize = 1000 * 1024 -- 1000 KB(1 MB)
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then
                            return true
                        end
                    end,
                    additional_vim_regex_highlighting = true, --additional lighting using regex if available
                },
                indent = { enable = true },
                rainbow = {
                    enable = true,
                    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
                    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
                    max_file_lines = nil, -- Do not enable for files with more than n lines, int
                    -- colors = {}, -- table of hex strings
                    -- termcolors = {} -- table of colour name strings
                },
                -- to complete html tags
                -- autotag = {
                --     enable = true,
                --     enable_rename = true,
                --     enable_close = true,
                --     filetypes = {'html', 'xml', 'javascript', 'typescript'},
                -- },

            })
        end
    }
