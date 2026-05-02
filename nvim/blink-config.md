# Blink.cmp Configuration

```lua
local ok, blink = pcall(require, "blink.cmp")
if ok then
  blink.setup({
    keymap = {
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },
    completion = {
      trigger = { 
        show_on_insert_on_trigger_character = false,
        show_in_snippet = false,
      },
      menu = {
        auto_show = false,
        draw = {
          columns = { { "label", "label_description", gap = 1 }, { "kind" } },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
    },
    sources = {
      default = { "lsp", "path", "buffer" },
    },
    signature = { enabled = true },
  })
  
  -- Set fuzzy match highlight to blue
  vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { fg = "#569cd6", bold = true })
end
```

## Keymaps
- `<C-Space>`: Trigger completion (manual only)
- `<C-n>`: Next item
- `<C-p>`: Previous item
- `<CR>`: Accept completion


## Features
- Manual trigger only (no auto-popup)
- Blue fuzzy match highlighting
- No icons (clean text-only display)
- LSP, path, and buffer sources
- Signature help enabled
