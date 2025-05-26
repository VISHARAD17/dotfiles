
-- Set custom highlight colors for diagnostics
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#ff5555", bg = "NONE" })
vim.api.nvim_set_hl(0, "DiagnosticWarn",  { fg = "#f1fa8c", bg = "NONE" })
vim.api.nvim_set_hl(0, "DiagnosticInfo",  { fg = "#8be9fd", bg = "NONE" })
vim.api.nvim_set_hl(0, "DiagnosticHint",  { fg = "#50fa7b", bg = "NONE" })

vim.diagnostic.config({
    virtual_text = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN]  = "▲",
            [vim.diagnostic.severity.HINT]  = "⚑",
            [vim.diagnostic.severity.INFO]  = "»",
        }
    },
    underline = true,
    update_in_insert = true,
    severity_sort = true,
    float = {
        source = true,
        border = "rounded",
    },
})



-- dimming the color of unused variables to this color insted of chaning them to comment color
vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { fg = "#808080" })
