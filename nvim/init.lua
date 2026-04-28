-- =============================================================================
-- init_fast.lua — Neovim 0.12 | Java 8 & 17+ | Maximum Performance
-- Uses: vim.pack (builtin), vim.lsp.config/enable (0.11+), builtin treesitter
-- No legacy syntax highlighting. No lazy.nvim. No require('lspconfig').setup()
-- =============================================================================

-- Set leader key FIRST ( change )
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ── 0. PERFORMANCE: disable built-in plugins we don't need ──────────────────
local disabled_builtins = {
  "gzip", "zip", "zipPlugin", "tar", "tarPlugin",
  "getscript", "getscriptPlugin", "vimball", "vimballPlugin",
  "2html_plugin", "matchit", "matchparen",
  "logiPat", "rrhelper", "netrw", "netrwPlugin",
  "netrwSettings", "netrwFileHandlers",
}
for _, plugin in ipairs(disabled_builtins) do
  vim.g["loaded_" .. plugin] = 1
end

-- Disable netrw in favour of built-in :Ex or a file picker
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

-- ── 1. OPTIONS ───────────────────────────────────────────────────────────────
local opt = vim.opt

-- UI
opt.number         = true
opt.relativenumber = false
opt.signcolumn     = "yes:1"      -- fixed width; prevents layout shift
opt.cursorline     = true
opt.termguicolors  = true
opt.laststatus     = 2
opt.showmode       = false        -- mode shown in statusline instead
opt.pumheight      = 10           -- smaller popup menu
opt.scrolloff      = 8
opt.sidescrolloff  = 8

-- Performance
opt.updatetime     = 250          -- diagnostic update frequency (was 100ms)
opt.timeoutlen     = 300
opt.redrawtime     = 1500
opt.ttyfast        = true
opt.lazyredraw     = false        -- keep false; true breaks floating windows
opt.synmaxcol      = 240          -- limit syntax highlighting per line

vim.cmd("syntax on")

-- Editing
opt.expandtab      = true
opt.tabstop        = 4
opt.shiftwidth     = 4
opt.smartindent    = true
opt.wrap           = false
opt.breakindent    = true
opt.undofile       = true
opt.undolevels     = 10000

-- Cursor
opt.guicursor = "a:blinkwait0-blinkoff0-blinkon0,n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

-- Spell checking (disabled globally for perf; enable per-filetype if needed)
opt.spell = false
opt.spelllang = { "en_us" }

-- Search
opt.ignorecase     = true
opt.smartcase      = true
opt.hlsearch       = true
opt.incsearch      = true

-- Clipboard
opt.clipboard      = "unnamedplus"  -- use system clipboard for all yank/paste

-- Splits
opt.splitbelow     = true
opt.splitright     = true

-- Completion (builtin, 0.11+)
opt.completeopt    = { "menuone", "noinsert", "noselect", "popup" }

-- Folding (manual = no computation on scroll)
opt.foldmethod     = "manual"
opt.foldlevel      = 99           -- open all folds by default
opt.foldlevelstart = 99

-- ── 2. BOOTSTRAP: vim.pack (Neovim 0.12 builtin package manager) ─────────────
-- vim.pack.add() clones/updates plugins from git into the stdpath('data') pack
-- path and immediately adds them to the runtimepath.
vim.pack.add({
  -- nvim-lspconfig: provides lsp/ config files discovered by vim.lsp.config()
  -- require('lspconfig').setup() is DEPRECATED; we use vim.lsp.enable() instead
  "https://github.com/neovim/nvim-lspconfig",

  -- Builtin autocompletion source (0.11+ native completion, no extra engine needed)
  -- blink.cmp is the modern, fast completion plugin that wraps native complete
  { src = "https://github.com/saghen/blink.cmp", version = "main" },

  -- Colorscheme (fast, pure Lua, treesitter-aware)
  "https://github.com/folke/tokyonight.nvim",

  -- Mini.pick - fast fuzzy finder
  "https://github.com/echasnovski/mini.pick",

  -- Mini.files - file explorer
  "https://github.com/echasnovski/mini.files",

  -- Diffview: side-by-side git diff with file history
  "https://github.com/sindrets/diffview.nvim",
})

-- ── 3. COLORSCHEME ───────────────────────────────────────────────────────────
-- Ensure termguicolors is set before loading colorscheme
vim.opt.termguicolors = true
vim.cmd.colorscheme("fleet_dark")

-- Brighter cursorline
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2e2e2e" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ffffff", bold = true })

-- ── 4. TREESITTER ────────────────────────────────────────────────────────────

-- Force treesitter highlighting for supported filetypes (skip large files)
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    if ft == "" then return end

    -- Skip large files (>1MB) for performance
    local max_filesize = 1024 * 1024
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if ok and stats and stats.size > max_filesize then return end

    local lang = vim.treesitter.language.get_lang(ft)
    if lang and pcall(vim.treesitter.language.add, lang) then
      pcall(vim.treesitter.start, args.buf, lang)
    end
  end,
})

-- ── 5. LSP CONFIGURATION (vim.lsp.config / vim.lsp.enable — 0.11+ native) ───
--
-- nvim-lspconfig ships lsp/<server>.lua files that vim.lsp.config() auto-finds.
-- We override / extend with vim.lsp.config() and then call vim.lsp.enable().
-- Do NOT use require('lspconfig').<server>.setup{} — that API is deprecated.

-- Global LSP capabilities: enable snippet support + additional completion items
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}

-- Disable expensive file-watching on large repos (big Java monorepos will choke)
if capabilities.workspace then
  capabilities.workspace.didChangeWatchedFiles = { dynamicRegistration = false }
end

-- Apply capabilities globally to all LSP servers
vim.lsp.config("*", { capabilities = capabilities })

-- ── 5a. JDTLS — Eclipse JDT Language Server (Java 8 & 17+) ─────────────────
-- Prerequisites:
--   1. Install jdtls:  brew install jdtls  (macOS)
--                      OR  sudo snap install jdtls  (Ubuntu)
--                      OR  manually: https://github.com/eclipse/eclipse.jdt.ls
--   2. java executable must be in $PATH (Java 21+ required by recent jdtls)
--   3. The jdtls wrapper script must be in $PATH
--
-- Per-project workspace isolation: each Maven/Gradle root gets its own cache.
-- Java 8 and Java 17 source compatibility are configured via runtimes below.
-- Adjust JAVA8_HOME / JAVA17_HOME to match your local install paths.

local JAVA21_HOME = "/Library/Java/JavaVirtualMachines/amazon-corretto-21.jdk/Contents/Home"
local LOMBOK_JAR = "/Users/visharad/.gradle/caches/modules-2/files-2.1/org.projectlombok/lombok/1.18.42/8365263844ebb62398e0dc33057ba10ba472d3b8/lombok-1.18.42.jar"

vim.lsp.config("jdtls", {
  -- jdtls wrapper script must be on PATH; it handles the java invocation.
  -- If you installed manually without the wrapper, replace with full java cmd.
  cmd = {
    "env", "JAVA_HOME=" .. JAVA21_HOME, "jdtls",
    -- Give jdtls plenty of heap for large repos; tune to your machine
    "--jvm-arg=-Xms512m",
    "--jvm-arg=-Xmx4g",
    -- Disable metadata files being dropped into your project root
    "--jvm-arg=-Djava.import.generatesMetadataFilesAtProjectRoot=false",
    -- Faster incremental compilation
    "--jvm-arg=-XX:+UseG1GC",
    "--jvm-arg=-XX:+UseStringDeduplication",
    "--jvm-arg=-javaagent:" .. LOMBOK_JAR,
  },

  -- Root markers: jdtls starts one server per project root
  root_markers = {
    "pom.xml",          -- Maven
    "build.gradle",     -- Gradle
    "build.gradle.kts", -- Gradle Kotlin DSL
    ".git",
    "mvnw",
    "gradlew",
  },

  filetypes = { "java" },

  settings = {
    java = {
      -- Use Java 21 as default runtime
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = {
          {
            name    = "JavaSE-21",
            path    = JAVA21_HOME,
            default = true,
          },
        },
      },

      -- Performance: disable scanning things we don't need
      maxConcurrentBuilds = 8,

      import = {
        gradle = { enabled = true },
        maven  = { enabled = true },
        exclusions = {
          "**/node_modules/**",
          "**/.metadata/**",
          "**/archetype-resources/**",
          "**/META-INF/maven/**",
        },
      },

      -- Code style
      format = {
        enabled   = true,
        comments  = { enabled = true },
        tabSize   = 4,
        insertSpaces = true,
      },

      -- IntelliSense inlay hints (disabled for performance)
      inlayHints = {
        parameterNames = { enabled = "none" },
      },

      -- Show warnings for unused variables/fields/params
      diagnostics = {
        enable = true,
        unused = {
          variable = "warning",
          field = "warning",
          parameter = "warning",
        },
      },

      -- Save actions
      saveActions = {
        organizeImports = false, -- enable if desired; can be slow on big files
      },

      -- Completion
      completion = {
        favoriteStaticMembers = {
          "org.junit.Assert.*",
          "org.junit.Assume.*",
          "org.junit.jupiter.api.Assertions.*",
          "org.mockito.Mockito.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
        },
        guessMethodArguments = true,
      },

      -- Content provider
      contentProvider = { preferred = "fernflower" },

      -- Sources
      sources = {
        organizeImports = {
          starThreshold          = 9999,
          staticStarThreshold    = 9999,
        },
      },

      -- Code generation
      codeGeneration = {
        toString   = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" },
        useBlocks  = true,
      },
    },
  },

  -- Per-project workspace isolation (prevents data dir collisions across repos)
  on_new_config = function(config, root_dir)
    local project_name = vim.fs.basename(root_dir)
    local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/workspaces/" .. project_name
    -- Append workspace -data arg to cmd
    local cmd = vim.deepcopy(config.cmd)
    vim.list_extend(cmd, { "-data", workspace_dir })
    config.cmd = cmd
  end,
})

vim.lsp.enable("jdtls")

-- ── 5b. Lua LSP (for editing this config file itself) ────────────────────────
-- Install: brew install lua-language-server  OR  npm i -g lua-language-server
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime  = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
      diagnostics = { globals = { "vim" } },
      telemetry = { enable = false },
    },
  },
})
vim.lsp.enable("lua_ls")

-- ── 6. LSP KEYMAPS (set on LspAttach — only active when LSP is running) ──────
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local buf  = args.buf
    vim.bo[buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    local map  = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc, silent = true })
    end

    -- Navigation
    map("n", "gd",         vim.lsp.buf.definition,       "Go to Definition")
    map("n", "gD",         vim.lsp.buf.declaration,      "Go to Declaration")
    map("n", "gi",         vim.lsp.buf.implementation,   "Go to Implementation")
    map("n", "gr",         vim.lsp.buf.references,       "Find References")
    map("n", "gt",         vim.lsp.buf.type_definition,  "Go to Type Definition")

    -- Info
    map("n", "K",          vim.lsp.buf.hover,            "Hover Documentation")
    map("n", "<C-k>",      vim.lsp.buf.signature_help,   "Signature Help")

    -- Actions
    map("n", "<leader>rn", vim.lsp.buf.rename,           "Rename Symbol")
    map("n", "<leader>ca", vim.lsp.buf.code_action,      "Code Action")
    map("v", "<leader>ca", vim.lsp.buf.code_action,      "Code Action (visual)")
    map("n", "<leader>lf",  function()
      vim.lsp.buf.format({ async = true })
    end, "Format Buffer")

    -- Workspace
    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder,    "Add Workspace Folder")
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder")
    map("n", "<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "List Workspace Folders")

    -- LSP control (0.12 new :lsp command)
    map("n", "<leader>li", "<cmd>checkhealth vim.lsp<cr>",  "LSP Info")
    map("n", "<leader>lr", "<cmd>lsp restart<cr>",          "LSP Restart")

    -- Disable semantic tokens (treesitter handles highlighting)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})

-- ── 7. DIAGNOSTICS ───────────────────────────────────────────────────────────
-- Only signs and underline (no virtual text for performance)
vim.diagnostic.config({
  virtual_text    = false,        -- disabled for performance
  signs           = true,
  underline       = true,
  update_in_insert = false,       -- do NOT update diagnostics while typing
  severity_sort   = true,
  float = {
    focusable = false,
    style     = "minimal",
    border    = "rounded",
    source    = "always",
    header    = "",
    prefix    = "",
  },
})

-- Diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- <Space>cd → current buffer diagnostics
vim.keymap.set("n", "<leader>cd", function()
  local diags = vim.diagnostic.get(0)
  if #diags == 0 then
    vim.notify("No diagnostics in current buffer", vim.log.levels.INFO)
    return
  end
  
  local items = {}
  for _, d in ipairs(diags) do
    local severity = vim.diagnostic.severity[d.severity]
    table.insert(items, string.format("[%s] Line %d: %s", severity, d.lnum + 1, d.message))
  end
  
  vim.ui.select(items, {
    prompt = "Buffer Diagnostics:",
    format_item = function(item) return item end,
  }, function(_, idx)
    if idx then
      vim.api.nvim_win_set_cursor(0, {diags[idx].lnum + 1, diags[idx].col})
    end
  end)
end, { desc = "Show current buffer diagnostics", silent = true })

-- <Space>d → show current buffer diagnostics
vim.keymap.set("n", "<leader>d", function()
  local diags = vim.diagnostic.get(0)
  if #diags == 0 then
    vim.notify("No diagnostics in current buffer", vim.log.levels.INFO)
    return
  end
  
  local items = {}
  for _, d in ipairs(diags) do
    local severity = vim.diagnostic.severity[d.severity]
    table.insert(items, string.format("[%s] Line %d: %s", severity, d.lnum + 1, d.message))
  end
  
  vim.ui.select(items, {
    prompt = "Buffer Diagnostics:",
    format_item = function(item) return item end,
  }, function(_, idx)
    if idx then
      vim.api.nvim_win_set_cursor(0, {diags[idx].lnum + 1, diags[idx].col})
    end
  end)
end, { desc = "Show diagnostics", silent = true })

-- <Space>D → workspace-wide diagnostics
vim.keymap.set("n", "<leader>D", function()
  local diags = vim.diagnostic.get()
  if #diags == 0 then
    vim.notify("No diagnostics in workspace", vim.log.levels.INFO)
    return
  end
  
  local items = {}
  for _, d in ipairs(diags) do
    local severity = vim.diagnostic.severity[d.severity]
    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(d.bufnr), ":~:.")
    table.insert(items, string.format("[%s] %s:%d: %s", severity, filename, d.lnum + 1, d.message))
  end
  
  vim.ui.select(items, {
    prompt = "Workspace Diagnostics:",
    format_item = function(item) return item end,
  }, function(_, idx)
    if idx then
      local d = diags[idx]
      vim.api.nvim_set_current_buf(d.bufnr)
      vim.api.nvim_win_set_cursor(0, {d.lnum + 1, d.col})
    end
  end)
end, { desc = "Show workspace diagnostics", silent = true })

-- Navigate diagnostics inline
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show Line Diagnostic" })

-- ── 8. COMPLETION (blink.cmp — fast Rust-powered, wraps native complete) ─────
-- ── 8. COMPLETION (Neovim built-in) ────────────────────────────────────────
-- VSCode-like completion UI with borders and better formatting

-- Completion menu appearance
vim.opt.pumblend = 10  -- slight transparency
vim.opt.pumheight = 15 -- max items shown

-- Bordered floating windows for LSP
vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
  config = config or {}
  config.border = "rounded"
  config.max_width = 80
  return vim.lsp.handlers.hover(_, result, ctx, config)
end

vim.lsp.handlers["textDocument/signatureHelp"] = function(_, result, ctx, config)
  config = config or {}
  config.border = "rounded"
  return vim.lsp.handlers.signature_help(_, result, ctx, config)
end

-- Customize floating preview windows
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  opts.max_width = opts.max_width or 80
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- Keymaps: Ctrl+Space to trigger, Ctrl+n/p to navigate, Enter to select
vim.keymap.set("i", "<C-Space>", "<C-x><C-o>", { desc = "Trigger completion" })
vim.keymap.set("i", "<C-n>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-n>"
end, { expr = true, desc = "Next completion" })
vim.keymap.set("i", "<C-p>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<C-p>"
end, { expr = true, desc = "Prev completion" })
vim.keymap.set("i", "<CR>", function()
  return vim.fn.pumvisible() == 1 and "<C-y>" or "<CR>"
end, { expr = true, desc = "Accept completion" })
vim.keymap.set("i", "<C-e>", function()
  return vim.fn.pumvisible() == 1 and "<C-e>" or "<C-e>"
end, { expr = true, desc = "Close completion" })

-- ── BLINK.CMP (commented out - uncomment to use) ─────────────────────────────
--[[
local ok, blink = pcall(require, "blink.cmp")
if ok then
  blink.setup({
    keymap = {
      preset = "default",
      ["<CR>"] = { "accept", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-y>"] = { "accept" },
      ["<C-e>"] = { "hide", "fallback" },
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },
    completion = {
      trigger = {
        show_on_insert_on_trigger_character = true,
      },
      menu = {
        draw = {
          columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      ghost_text = { enabled = true },
    },
    sources = {
      default = { "lsp", "path", "buffer" },
    },
    signature = { enabled = true },
  })
end
--]]

-- ── 9. JAVA-SPECIFIC FILETYPE SETTINGS ───────────────────────────────────────
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    local opt_local = vim.opt_local
    opt_local.tabstop     = 4
    opt_local.shiftwidth  = 4
    opt_local.expandtab   = true
    opt_local.textwidth   = 120
    opt_local.colorcolumn = "120"
  end,
})

-- ── 10. GENERAL KEYMAPS ───────────────────────────────────────────────────────
local map = vim.keymap.set

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Window Left"  })
map("n", "<C-j>", "<C-w>j", { desc = "Window Down"  })
map("n", "<C-k>", "<C-w>k", { desc = "Window Up"    })
map("n", "<C-l>", "<C-w>l", { desc = "Window Right" })

-- Resize windows
map("n", "<C-Up>",    "<cmd>resize +2<cr>")
map("n", "<C-Down>",  "<cmd>resize -2<cr>")
map("n", "<C-Left>",  "<cmd>vertical resize -2<cr>")
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>")

-- Buffer nav
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>",     { desc = "Next Buffer" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>noh<cr><Esc>", { desc = "Clear Search Highlight" })

-- Always center search results
map("n", "n", "nzz", { silent = true })
map("n", "N", "Nzz", { silent = true })
map("n", "*", "*zz", { silent = true })

-- Stay in indent mode when indenting in visual
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move lines up/down
map("n", "<A-j>", "<cmd>m .+1<cr>==",        { desc = "Move Line Down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==",        { desc = "Move Line Up"   })
map("v", "<A-j>", ":m '>+1<cr>gv=gv",        { desc = "Move Block Down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv",        { desc = "Move Block Up"   })

-- Quickfix navigation
map("n", "<leader>qo", "<cmd>copen<cr>",  { desc = "Open Quickfix" })
map("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Close Quickfix" })
map("n", "[q",         "<cmd>cprev<cr>",  { desc = "Prev Quickfix" })
map("n", "]q",         "<cmd>cnext<cr>",  { desc = "Next Quickfix" })

-- Save / Quit
map({ "n", "i" }, "<C-s>", "<cmd>w<cr><Esc>", { desc = "Save" })
map("n",          "<leader>q", "<cmd>q<cr>",  { desc = "Quit" })

-- ── DIFFVIEW ─────────────────────────────────────────────────────────────────
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>",                    { desc = "Diff all changed files" })
map("n", "<leader>gf", "<cmd>DiffviewOpen -- %<cr>",               { desc = "Diff current file vs HEAD" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>",           { desc = "File history" })
map("n", "<leader>gx", "<cmd>DiffviewClose<cr>",                   { desc = "Close diffview" })
map("n", "<leader>gb", function()
  local current = vim.fn.system("git branch --show-current"):gsub("%s+$", "")
  local b2 = vim.fn.input("Compare with branch: ")
  if b2 ~= "" then
    vim.cmd("DiffviewOpen " .. current .. ".." .. b2 .. " -- %")
  end
end, { desc = "Diff current file: current branch vs branch" })

-- ── MINI.PICK FUZZY FINDER ───────────────────────────────────────────────────
local pick_ok, pick = pcall(require, "mini.pick")
if pick_ok then
  pick.setup({
    window = {
      config = {
        relative = 'editor',
        anchor = 'NW',
        width = math.floor(0.8 * vim.o.columns),
        height = math.floor(0.8 * vim.o.lines),
        row = math.floor(0.1 * vim.o.lines),
        col = math.floor(0.1 * vim.o.columns),
        border = 'rounded',
      }
    }
  })
  
  map("n", "<leader>ff", "<cmd>Pick files<cr>", { desc = "Find Files" })
  map("n", "<C-p>", "<cmd>Pick files<cr>", { desc = "Find Files" })
  map("n", "<leader>c", function()
    local dir = vim.fn.expand("%:p:h")
    vim.cmd("lcd " .. dir)
    require("mini.pick").builtin.files()
  end, { desc = "Find Files (current file dir)" })
  map("n", "<leader>b", "<cmd>Pick buffers<cr>", { desc = "Find Buffers" })
  map("n", "<leader>g", "<cmd>Pick grep_live<cr>", { desc = "Live Grep" })
else
  -- Fallback
  map("n", "<leader>ff", "<cmd>find **/*<Left><Left>", { desc = "Find Files" })
  map("n", "<C-p>", "<cmd>find **/*<Left><Left>", { desc = "Find Files" })
end

-- ── MINI.FILES ───────────────────────────────────────────────────────────────
local mf_ok, mfiles = pcall(require, "mini.files")
if mf_ok then
  mfiles.setup({
    windows = {
      preview = false,
    },
  })
  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
      vim.keymap.set("n", "<CR>", function()
        local entry = mfiles.get_fs_entry()
        if entry and entry.fs_type == "file" then
          mfiles.close()
          vim.cmd("edit " .. vim.fn.fnameescape(entry.path))
        end
      end, { buffer = args.data.buf_id })
    end,
  })
  map("n", "<leader>e", function()
    if not mfiles.close() then
      mfiles.open(vim.fn.expand("%:p:h"))
    end
  end, { desc = "File explorer" })
end

-- ── 11. STATUSLINE (minimal, no plugin needed) ───────────────────────────────
-- Cache git branch (shelling out on every statusline redraw kills scroll perf)
local _git_branch_cache = ""
local _git_branch_timer = nil

local function refresh_git_branch()
  vim.system({"git", "rev-parse", "--is-inside-work-tree"}, { text = true }, function(obj)
    if obj.code == 0 then
      vim.system({"git", "branch", "--show-current"}, { text = true }, function(result)
        _git_branch_cache = (result.stdout or ""):gsub("%s+$", "")
      end)
    else
      _git_branch_cache = ""
      if _git_branch_timer then
        _git_branch_timer:stop()
        _git_branch_timer = nil
      end
    end
  end)
end

-- Only start timer if in git repo
vim.defer_fn(function()
  refresh_git_branch()
  if _git_branch_cache ~= "" or vim.fn.isdirectory(".git") == 1 then
    _git_branch_timer = vim.uv.new_timer()
    _git_branch_timer:start(0, 5000, vim.schedule_wrap(refresh_git_branch))
  end
end, 100)

-- Stop timer on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    if _git_branch_timer then
      _git_branch_timer:stop()
      _git_branch_timer:close()
    end
  end,
})

_G.statusline = function()
  local mode_map = {
    n = "NORMAL", i = "INSERT", v = "VISUAL", V = "V-LINE",
    ["\22"] = "V-BLOCK", c = "COMMAND", s = "SELECT", S = "S-LINE",
    R = "REPLACE", t = "TERMINAL",
  }
  local m = mode_map[vim.fn.mode()] or vim.fn.mode()
  local branch = _git_branch_cache ~= "" and (" " .. _git_branch_cache) or ""
  return " " .. m .. "  %f %m%r%= " .. branch .. " "
end

opt.statusline = "%!v:lua.statusline()"

-- ── 12. AUTO-UPDATE PARSERS ON CONFIG RELOAD ─────────────────────────────────
-- Run :TSUpdate manually after first install, or uncomment the line below
-- to auto-update every time you open Neovim (slow on first run):


-- ── DONE ──────────────────────────────────────────────────────────────────────
-- First run checklist:
--   1. :checkhealth vim.lsp      — verify jdtls is found & configured
--   2. :checkhealth nvim         — check treesitter parsers
--   3. Open a Java file          — parsers auto-install, jdtls attaches
--   4. <Space>d                  — diagnostics → quickfix list
--   5. gd / gr / K / <leader>ca — LSP navigation & actions
--   6. :lsp restart              — restart jdtls if stuck
-- =============================================================================
