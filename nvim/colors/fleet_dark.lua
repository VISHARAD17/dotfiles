-- Fleet Dark theme for Neovim
-- Based on JetBrains Fleet theme

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

vim.o.background = "dark"
vim.g.colors_name = "fleet_dark"

local colors = {
  -- Grays
  white = "#ffffff",
  gray120 = "#d1d1d1",
  gray110 = "#c2c2c2",
  gray100 = "#a0a0a0",
  gray90 = "#898989",
  gray80 = "#767676",
  gray70 = "#5d5d5d",
  gray60 = "#484848",
  gray50 = "#383838",
  gray40 = "#333333",
  gray30 = "#2d2d2d",
  gray20 = "#292929",
  gray15 = "#1F1F1F",
  gray10 = "#181818",
  black = "#000000",
  
  -- Blues
  blue110 = "#6daaf7",
  blue100 = "#4d9bf8",
  blue90 = "#3691f9",
  blue80 = "#1a85f6",
  blue70 = "#0273eb",
  blue60 = "#0c6ddd",
  blue50 = "#195eb5",
  blue40 = "#194176",
  blue30 = "#163764",
  blue20 = "#132c4f",
  blue10 = "#0b1b32",
  
  -- Reds
  red80 = "#ec7388",
  red70 = "#ea4b67",
  red60 = "#d93953",
  red50 = "#ce364d",
  red40 = "#c03248",
  red30 = "#a72a3f",
  red20 = "#761b2d",
  red10 = "#390813",
  
  -- Greens
  green50 = "#4ca988",
  green40 = "#3ea17f",
  green30 = "#028764",
  green20 = "#134939",
  green10 = "#081f19",
  
  -- Yellows
  yellow60 = "#f8ab17",
  yellow50 = "#e1971b",
  yellow40 = "#b5791f",
  yellow30 = "#7c511a",
  yellow20 = "#5a3a14",
  yellow10 = "#281806",
  
  -- Theme colors
  blue = "#87C3FF",
  blue_light = "#ADD1DE",
  coral = "#CC7C8A",
  cyan = "#82D2CE",
  cyan_dark = "#779E9E",
  lime = "#A8CC7C",
  orange = "#E09B70",
  pink = "#E394DC",
  violet = "#AF9CFF",
  yellow = "#EBC88D",
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Editor
hi("Normal", { fg = colors.gray120, bg = colors.gray10 })
hi("NormalFloat", { fg = colors.gray120, bg = colors.gray20 })
hi("Cursor", { reverse = true })
hi("CursorLine", { bg = colors.gray15 })
hi("LineNr", { fg = colors.gray70 })
hi("CursorLineNr", { fg = colors.gray110 })
hi("Visual", { bg = colors.blue40 })
hi("VisualNOS", { bg = colors.gray50 })
hi("Search", { bg = colors.blue30 })
hi("IncSearch", { bg = colors.blue40 })

-- Syntax
hi("Comment", { fg = colors.gray90 })
hi("Constant", { fg = colors.violet })
hi("String", { fg = colors.pink })
hi("Character", { fg = colors.yellow })
hi("Number", { fg = colors.yellow })
hi("Boolean", { fg = colors.cyan })
hi("Float", { fg = colors.yellow })
hi("Identifier", { fg = colors.gray120 })
hi("Function", { fg = colors.yellow })
hi("Statement", { fg = colors.cyan })
hi("Conditional", { fg = colors.cyan })
hi("Repeat", { fg = colors.cyan })
hi("Label", { fg = colors.yellow })
hi("Operator", { fg = colors.cyan })
hi("Keyword", { fg = colors.cyan })
hi("Exception", { fg = colors.cyan })
hi("PreProc", { fg = colors.lime })
hi("Include", { fg = colors.cyan })
hi("Define", { fg = colors.lime })
hi("Macro", { fg = colors.lime })
hi("PreCondit", { fg = colors.lime })
hi("Type", { fg = colors.blue })
hi("StorageClass", { fg = colors.cyan })
hi("Structure", { fg = colors.blue })
hi("Typedef", { fg = colors.blue })
hi("Special", { fg = colors.lime })
hi("SpecialChar", { fg = colors.cyan })
hi("Tag", { fg = colors.blue })
hi("Delimiter", { fg = colors.gray120 })
hi("SpecialComment", { fg = colors.gray90 })
hi("Debug", { fg = colors.lime })

-- UI
hi("StatusLine", { fg = colors.gray120, bg = colors.gray20 })
hi("StatusLineNC", { fg = colors.gray90, bg = colors.gray20 })
hi("Pmenu", { fg = colors.gray120, bg = colors.gray20 })
hi("PmenuSel", { fg = colors.white, bg = colors.blue40 })
hi("PmenuSbar", { bg = colors.gray30 })
hi("PmenuThumb", { bg = colors.gray60 })
hi("WildMenu", { fg = colors.white, bg = colors.blue40 })
hi("Folded", { fg = colors.gray90, bg = colors.gray20 })
hi("FoldColumn", { fg = colors.gray70, bg = colors.gray10 })
hi("SignColumn", { fg = colors.gray70, bg = colors.gray10 })
hi("VertSplit", { fg = colors.gray50 })
hi("ColorColumn", { bg = colors.gray20 })

-- Diagnostics
hi("DiagnosticError", { fg = colors.red50 })
hi("DiagnosticWarn", { fg = colors.yellow60 })
hi("DiagnosticInfo", { fg = "#A366C4" })
hi("DiagnosticHint", { fg = colors.gray80 })
hi("DiagnosticUnderlineError", { underline = true, sp = colors.red50 })
hi("DiagnosticUnderlineWarn", { underline = true, sp = colors.yellow60 })
hi("DiagnosticUnderlineInfo", { underline = true, sp = "#A366C4" })
hi("DiagnosticUnderlineHint", { underline = true, sp = colors.gray80 })

-- LSP
hi("LspReferenceText", { bg = colors.gray30 })
hi("LspReferenceRead", { bg = colors.gray30 })
hi("LspReferenceWrite", { bg = colors.gray30 })

-- Treesitter
hi("@attribute", { fg = colors.lime })
hi("@type", { fg = colors.blue })
hi("@type.builtin", { fg = colors.blue_light })
hi("@constructor", { fg = colors.yellow })
hi("@constant", { fg = colors.violet })
hi("@constant.builtin", { fg = colors.cyan })
hi("@string", { fg = colors.pink })
hi("@string.regexp", { fg = colors.cyan })
hi("@string.escape", { fg = colors.cyan })
hi("@character", { fg = colors.yellow })
hi("@number", { fg = colors.yellow })
hi("@boolean", { fg = colors.cyan })
hi("@comment", { fg = colors.gray90 })
hi("@variable", { fg = colors.gray120 })
hi("@variable.builtin", { fg = colors.coral })
hi("@variable.member", { fg = colors.violet })
hi("@label", { fg = colors.yellow })
hi("@keyword", { fg = colors.cyan })
hi("@function", { fg = colors.yellow })
hi("@function.builtin", { fg = colors.lime })
hi("@function.macro", { fg = colors.lime })
hi("@tag", { fg = colors.blue })
hi("@namespace", { fg = colors.blue })

-- Markdown
hi("@markup.heading", { fg = colors.cyan, bold = true })
hi("@markup.list", { fg = colors.pink })
hi("@markup.list.numbered", { fg = colors.cyan })
hi("@markup.list.unnumbered", { fg = colors.cyan })
hi("@markup.link.url", { fg = colors.pink, italic = true, underline = true })
hi("@markup.link.text", { fg = colors.cyan })
hi("@markup.quote", { fg = colors.pink })
hi("@markup.raw", { fg = colors.pink })
hi("@markup.raw.block", { fg = "#EB83E2" })

-- Diff
hi("DiffAdd", { fg = colors.green50 })
hi("DiffChange", { fg = colors.blue80 })
hi("DiffDelete", { fg = colors.red50 })
hi("DiffText", { fg = colors.blue80, bold = true })

-- Git
hi("gitcommitComment", { fg = colors.gray90 })
hi("gitcommitUnmerged", { fg = colors.red50 })
hi("gitcommitOnBranch", { fg = colors.gray90 })
hi("gitcommitBranch", { fg = colors.pink })
hi("gitcommitDiscardedType", { fg = colors.red50 })
hi("gitcommitSelectedType", { fg = colors.green50 })
hi("gitcommitHeader", { fg = colors.gray90 })
hi("gitcommitUntrackedFile", { fg = colors.cyan })
hi("gitcommitDiscardedFile", { fg = colors.red50 })
hi("gitcommitSelectedFile", { fg = colors.green50 })
hi("gitcommitUnmergedFile", { fg = colors.yellow })
hi("gitcommitFile", { fg = colors.gray120 })