return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile", "BufWritePost" },
    dependencies = {
        -- Uncomment if using rainbow delimiters or autotag
        -- { "HiPhish/rainbow-delimiters.nvim" },
        -- { "windwp/nvim-ts-autotag" },
    },
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            -- List of language parsers to ensure are installed
            ensure_installed = {
                "c", "cpp", "lua", "vim", "vimdoc", "query", "elixir",
                "heex", "javascript", "typescript", "html", "dockerfile",
                "json", "regex", "sql", "graphql", "java", "markdown",
                "markdown_inline", "bash", "tsx", "python"
            },
            -- Required: Specify modules to enable (e.g., highlight, indent)
            modules = {
                "highlight",
                "indent",
                "rainbow",
                -- Add "autotag" if enabled below
            },
            -- Required: Languages to ignore during auto-installation
            ignore_install = {}, -- Empty table means no languages are ignored
            auto_install = true, -- Automatically install missing parsers
            sync_install = false, -- Install parsers asynchronously
            highlight = {
                enable = true, -- Enable syntax highlighting
                -- Disable highlighting for large files to improve performance
                disable = function(lang, buf)
                    local max_filesize = 1000 * 1024 -- 1 MB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
            },
            indent = { enable = true }, -- Enable Treesitter-based indentation
            rainbow = {
                enable = true, -- Enable rainbow brackets (requires rainbow-delimiters.nvim or similar)
                extended_mode = true, -- Highlight non-bracket delimiters (e.g., HTML tags)
                max_file_lines = nil, -- No line limit for rainbow highlighting
            },
            -- Uncomment to enable autotag for HTML/XML/JS/TS
            -- autotag = {
            --     enable = true,
            --     enable_rename = true,
            --     enable_close = true,
            --     filetypes = { "html", "xml", "javascript", "typescript" },
            -- },
        })
    end,
}
