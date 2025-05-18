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

local signs = {
    Error = "✘",
    Warn = "▲",
    Hint = "⚑",
    Info = "»"
}

-- for type, icon in pairs(signs) do
--     local hl = "DiagnosticSign" .. type
--     vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
-- end

-- dimming the color of unused variables to this color insted of chaning them to comment color
vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { fg = "#808080" })
