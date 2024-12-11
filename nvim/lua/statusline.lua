local opt = vim.opt

opt.showmode = false
opt.laststatus = 3

-- Set highlight groups for each mode
vim.api.nvim_set_hl(0, "NormalMode", { bg = "#388bfd", fg = 'Black' })
vim.api.nvim_set_hl(0, "InsertMode", { bg = "#56d364", fg = 'Black' })
vim.api.nvim_set_hl(0, "VisualMode", { bg = "#a371f7", fg = 'Black' })
vim.api.nvim_set_hl(0, "CommandMode", { bg = "#f2cc60", fg = 'Black' })
vim.api.nvim_set_hl(0, "ReplaceMode", { bg = "#f85149", fg = 'Black' })
vim.api.nvim_set_hl(0, "SelectMode", { bg = "#db6d28", fg = 'Black' })
vim.api.nvim_set_hl(0, "VisualLineMode", { bg = "#ff8800", fg = 'Black' })  -- Highlight for Visual Line mode
vim.api.nvim_set_hl(0, "VisualBlockMode", { bg = "#ff00ff", fg = 'Black' })  -- Highlight for Visual Block mode
vim.api.nvim_set_hl(0, "TerminalMode", { bg = "#c678dd", fg = 'Black' })  -- Highlight for Terminal mode

-- Function to return the current mode for the statusline
function ModeHighlight()
    local mode = vim.fn.mode()
    local mode_map = {
        n = "%#NormalMode# NORMAL ",
        i = "%#InsertMode# INSERT ",
        v = "%#VisualMode# VISUAL ",
        V = "%#VisualMode# VISUAL ",
        ['\22'] = "%#VisualBlockMode# V-BLOCK ",  -- Ctrl-V for Visual Block mode
        c = "%#CommandMode# COMMAND ",
        R = "%#ReplaceMode# REPLACE ",
        s = "%#SelectMode# SELECT ",
        t = "%#TerminalMode# TERMINAL "  -- Terminal mode
    }
    return mode_map[mode] or mode
end

-- Function to get the current Git branch
function GetGitBranch()
    local handle = io.popen("git rev-parse --abbrev-ref HEAD 2>/dev/null")
    if handle then
        local branch_name = handle:read("*a")
        handle:close()
        return branch_name ~= "" and branch_name:gsub("\n", "") or ""
    end
end

-- Set the statusline with colorful current mode
vim.o.statusline = '%{%v:lua.ModeHighlight()%}%#StatusLine#  %f %=[ %{v:lua.GetGitBranch()} ] %l'
