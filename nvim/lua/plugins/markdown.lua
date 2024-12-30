return
    {
    "OXY2DEV/markview.nvim",
    lazy = false,      -- Recommended
    -- ft = "markdown" -- If you decide to lazy-load anyway
    opts = {
        hybrid_modes = {"n", "v", "i"},
        modes = { "n", "no", "c", "i", "v" }
    },

    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    }
}
