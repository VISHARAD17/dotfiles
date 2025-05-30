return {
    {
        "echasnovski/mini.indentscope",
        event = { "BufReadPre", "BufNewFile" },
        version = false, -- wait till new 0.7.0 release to put it back on semver
        -- event = "LazyFile",
        opts = {
            symbol = "│",
            options = { try_as_border = true },
        },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "Trouble",
                    "fzf",
                    "help",
                    "lazy",
                    "trouble",
                    "NvimTree",
                },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("ibl").setup({
                indent = {
                    char =  "│",
                },
                scope = { enabled = false },
            })

        end
    },

}
