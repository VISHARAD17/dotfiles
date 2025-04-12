return
    {
        "folke/trouble.nvim",
        event = "BufReadPost", -- load after the current buffer is read
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        keys = {
            {
                "<leader>xd",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics in directory",
            },
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Current File Diagnostics",
            },
            {
                "<leader>xq",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List",
            },
        },
    }
