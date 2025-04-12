return
{
    "pmizio/typescript-tools.nvim",
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" , lazy = true},
    opts = {},
    config = function()
        require("typescript-tools").setup {}
    end,}
