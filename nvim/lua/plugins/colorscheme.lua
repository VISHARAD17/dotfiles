--darkplus theme from lunarvim
return {
    "lunarvim/darkplus.nvim",
    priority = 1000,
    config = function()
        vim.opt.termguicolors = true
        vim.cmd("colorscheme darkplus")
        -- overwrite default theme colors
        vim.api.nvim_set_hl(0, "Normal", {fg = "#ffffff", bg = "#181818"})
        vim.api.nvim_set_hl(0, "NormalNC", {fg = "#ffffff", bg = "#181818"})
        vim.api.nvim_set_hl(0, "NormalFloat", {fg = "#ffffff", bg = "#181818"})
        vim.api.nvim_set_hl(0, "MsgArea", {fg = "#ffffff", bg = "#181818"})
        vim.api.nvim_set_hl(0, "ModeMsg", {fg = "#ffffff", bg = "#181818"})
        vim.api.nvim_set_hl(0, "SignColumn", { fg = 'none', bg = "#181818" })
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = '#ffffff', bg = 'NONE', bold = true, })
        vim.api.nvim_set_hl(0, "StatusLine", {fg = "#ffffff", bg="#3f3f3f"})
        vim.api.nvim_set_hl(0, "StatusLineNC", {fg = "#ffffff", bg="#3f3f3f"})
        vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", {fg ='#3f3f3f', bg = 'none' })
        vim.api.nvim_set_hl(0, "FloatBorder", {fg = '#6e7681', bg = 'none'})
        vim.api.nvim_set_hl(0, "NvimTreeWinSeparator",{fg = '#3f3f3f', bg = 'none'})
    end
}
