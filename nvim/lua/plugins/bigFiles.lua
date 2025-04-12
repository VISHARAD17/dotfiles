return {
    "LunarVim/bigfile.nvim",
    lazy = true,
    config = function ()
        -- default config
        require("bigfile").setup {
            filesize = 2, -- size of the file in MiB, the plugin round file sizes to the closest MiB
            pattern = { "*" }, -- autocmd pattern or function see <### Overriding the detection of big files>
            features = { -- features to disable
                "treesitter",
                "syntax",
                "matchparen",
                "filetype",
            },
        }
    end
}
