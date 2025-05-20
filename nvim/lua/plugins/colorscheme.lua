--darkplus theme from lunarvim
return {
    -- "lunarvim/darkplus.nvim",
    "askfiy/visual_studio_code",
    lazy = false,
    priority = 1000,
    config = function()
        vim.opt.termguicolors = true
		vim.cmd("colorscheme visual_studio_code")

        -- overwrite default theme colors
        vim.api.nvim_set_hl(0, "Normal", {fg = "#ffffff", bg = '#181818'})
        vim.api.nvim_set_hl(0, "NormalNC", {fg = "#ffffff", bg = "#181818"})
        vim.api.nvim_set_hl(0, "NormalFloat", {fg = "#ffffff", bg = "#181818"})
        vim.api.nvim_set_hl(0, "MsgArea", {fg = "#ffffff", bg = "#181818"})
        vim.api.nvim_set_hl(0, "ModeMsg", {fg = "#ffffff", bg = "#181818"})
        vim.api.nvim_set_hl(0, "SignColumn", { fg = 'none', bg = "#181818" })
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = '#ffffff', bg = 'NONE', bold = true, })
        vim.api.nvim_set_hl(0, "StatusLine", {fg = "#ffffff", bg="#1e1e1e"})
        vim.api.nvim_set_hl(0, "StatusLineNC", {fg = "#ffffff", bg="#1e1e1e"})
        vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", {fg ='#8c8a8a', bg = 'none' })
        vim.api.nvim_set_hl(0, "FloatBorder", {fg = '#6e7681', bg = 'none'})
        vim.api.nvim_set_hl(0, "NvimTreeWinSeparator",{fg = '#a9a9a9', bg = 'none'})
        vim.api.nvim_set_hl(0, "NvimTreeNormal",{fg = '#a9a9a9', bg = '#181818'})
        vim.api.nvim_set_hl(0, "NvimTreeFolderName",{fg = '#ffffff', bg = 'none'})
        vim.api.nvim_set_hl(0, "EndOfBuffer", {fg = '#6e7681', bg = 'none'})
        -- vim.api.nvim_set_hl(0, "WinBarNC", { fg = '#a9a9a9', bg = '#181818'})
        -- vim.api.nvim_set_hl(0, "WinBar", { fg = 'none', bg = 'none' })
        -- vim.api.nvim_set_hl(0, "WinBarInactive", { fg = "#a9a9a9", bg = '#3f3f3f' })
        -- vim.api.nvim_set_hl(0, "RenderMarkdownCode", { fg = "none", bg = '#222222' })
        -- vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline", { fg = "none", bg = '#222222' })
    end
}
