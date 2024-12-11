--darkplus theme from lunarvim
return {
   "lunarvim/darkplus.nvim",
    priority = 1000,
    config = function()
        vim.opt.termguicolors = true
        vim.cmd("colorscheme darkplus")
        -- overwrite default theme colors
        vim.api.nvim_set_hl(0, "Normal", {fg = "#181818", bg = "#181818"})
        vim.api.nvim_set_hl(0, "NormalNC", {fg = "#181818", bg = "#181818"})
        vim.api.nvim_set_hl(0, "NormalFloat", {fg = "#181818", bg = "#181818"})
        vim.api.nvim_set_hl(0, "MsgArea", {fg = "#ffffff", bg = "#181818"})
        vim.api.nvim_set_hl(0, "ModeMsg", {fg = "#ffffff", bg = "#181818"})
        vim.api.nvim_set_hl(0, "SignColumn", { fg = 'NONE', bg = "#181818" })

        vim.api.nvim_set_hl(0, "StatusLine", {fg = "#1e1e1e", bg="#1e1e1e"})
        vim.api.nvim_set_hl(0, "StatusLineNC", {fg = "#1e1e1e", bg="#1e1e1e"})
    end
}
