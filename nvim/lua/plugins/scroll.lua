return
    {
        "karb94/neoscroll.nvim",
        event = "WinScrolled",
        config = function()
            require('neoscroll').setup({
                hide_cursor = false,          -- Hide cursor while scrolling
            })
        end
    }
