vim.diagnostic.config({
    virtual_text = true,
    signs = true,
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
