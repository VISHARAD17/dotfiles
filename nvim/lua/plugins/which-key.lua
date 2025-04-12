return {
    "folke/which-key.nvim",
    event = 'VimEnter',
    opts = {
        win = {
            border = "rounded", -- none, single, double, shadow
            title = true,
        },
    },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
}
