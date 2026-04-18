-- =============================================================================
-- init_fast.lua — Neovim 0.12 | Java 8 & 17+ | Maximum Performance
-- Uses: vim.pack (builtin), vim.lsp.config/enable (0.11+), builtin treesitter
-- No legacy syntax highlighting. No lazy.nvim. No require('lspconfig').setup()
-- =============================================================================

-- Set leader key FIRST
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
opt.signcolumn     = "yes"        -- always show; prevents layout shift
opt.cursorline     = true
opt.termguicolors  = true
opt.laststatus     = 2
opt.showmode       = false        -- mode shown in statusline instead
opt.pumheight      = 10           -- smaller popup menu
opt.scrolloff      = 8
opt.sidescrolloff  = 8

-- Performance
opt.updatetime     = 100          -- faster CursorHold / diagnostics
opt.timeoutlen     = 300
opt.redrawtime     = 1500
opt.ttyfast        = true
opt.lazyredraw     = false        -- keep false; true breaks floating windows
opt.synmaxcol      = 0           -- no regex syntax (treesitter handles it)

-- Enable syntax highlighting (required for treesitter to work)
vim.cmd("syntax enable")

-- Editing
opt.expandtab      = true
opt.tabstop        = 4
opt.shiftwidth     = 4
opt.smartindent    = true
opt.wrap           = false
opt.breakindent    = true
opt.undofile       = true
opt.undolevels     = 10000

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

-- Folding via treesitter (0.10+)
opt.foldmethod     = "expr"
opt.foldexpr       = "v:lua.vim.treesitter.foldexpr()"
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
})

-- ── 3. COLORSCHEME ───────────────────────────────────────────────────────────
-- Ensure termguicolors is set before loading colorscheme
vim.opt.termguicolors = true
vim.cmd.colorscheme("fleet_dark")

-- ── 4. TREESITTER ────────────────────────────────────────────────────────────

-- Force treesitter highlighting for all supported filetypes
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  callback = function()
    local ft = vim.bo.filetype
    if ft == "" then return end
    
    vim.schedule(function()
      local lang = vim.treesitter.language.get_lang(ft)
      if lang and pcall(vim.treesitter.language.add, lang) then
        pcall(vim.treesitter.start, 0, lang)
      end
    end)
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

vim.lsp.config("jdtls", {
  -- jdtls wrapper script must be on PATH; it handles the java invocation.
  -- If you installed manually without the wrapper, replace with full java cmd.
  cmd = {
    "jdtls",
    -- Give jdtls plenty of heap for large repos; tune to your machine
    "--jvm-arg=-Xms512m",
    "--jvm-arg=-Xmx4g",
    -- Disable metadata files being dropped into your project root
    "--jvm-arg=-Djava.import.generatesMetadataFilesAtProjectRoot=false",
    -- Faster incremental compilation
    "--jvm-arg=-XX:+UseG1GC",
    "--jvm-arg=-XX:+UseStringDeduplication",
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
      maxConcurrentBuilds = 4,

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

      -- IntelliSense inlay hints
      inlayHints = {
        parameterNames = { enabled = "all" },
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
    map("n", "<leader>f",  function()
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
  end,
})

-- ── 7. DIAGNOSTICS ───────────────────────────────────────────────────────────
-- Disable diagnostics completely
vim.diagnostic.config({
  virtual_text    = {
    spacing = 4,
    source  = "if_many",
    prefix  = "●",
  },
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

-- <Space>d → show current buffer diagnostics in a quickfix list
-- Uses vim.diagnostic.setqflist() — available natively, no plugin needed.
-- In 0.12 it also supports a `format` function for custom display.
vim.keymap.set("n", "<leader>d", function()
  vim.diagnostic.setqflist({
    open   = true,
    title  = "Buffer Diagnostics",
    severity = nil,              -- all severities; set e.g. ERROR to filter
    format = function(diag)
      return string.format("[%s] %s", vim.diagnostic.severity[diag.severity], diag.message)
    end,
  })
end, { desc = "Show diagnostics in quickfix", silent = true })

-- <Space>D → workspace-wide diagnostics
vim.keymap.set("n", "<leader>D", function()
  vim.diagnostic.setqflist({
    open       = true,
    title      = "Workspace Diagnostics",
    namespace  = nil,            -- all namespaces
    format = function(diag)
      return string.format("[%s] %s", vim.diagnostic.severity[diag.severity], diag.message)
    end,
  })
end, { desc = "Show workspace diagnostics in quickfix", silent = true })

-- Navigate diagnostics inline
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show Diagnostic Float" })

-- ── 8. COMPLETION (blink.cmp — fast Rust-powered, wraps native complete) ─────
local ok, blink = pcall(require, "blink.cmp")
if ok then
  blink.setup({
    keymap = {
      preset = "default",
      ["<Tab>"]   = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<CR>"]    = { "accept", "fallback" },
      ["<C-e>"]   = { "hide" },
      ["<C-d>"]   = { "scroll_documentation_down" },
      ["<C-u>"]   = { "scroll_documentation_up" },
    },
    completion = {
      menu = {
        draw = {
          -- treesitter = { "lsp" },  -- use treesitter for menu highlighting
        },
      },
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
      ghost_text    = { enabled = true },
    },
    sources = {
      default = { "lsp", "path", "buffer" },
    },
    -- Force Lua implementation — avoids pre-built binary download warning
    -- The Lua fallback is perfectly fast for most use cases
    fuzzy = { implementation = "lua" },
  })
end

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
  
  map("n", "<leader>f", "<cmd>Pick files<cr>", { desc = "Find Files" })
  map("n", "<C-p>", "<cmd>Pick files<cr>", { desc = "Find Files" })
  map("n", "<leader>b", "<cmd>Pick buffers<cr>", { desc = "Find Buffers" })
  map("n", "<leader>g", "<cmd>Pick grep_live<cr>", { desc = "Live Grep" })
else
  -- Fallback
  map("n", "<leader>f", "<cmd>find **/*<Left><Left>", { desc = "Find Files" })
  map("n", "<C-p>", "<cmd>find **/*<Left><Left>", { desc = "Find Files" })
end

-- ── 11. STATUSLINE (minimal, no plugin needed) ───────────────────────────────
local function git_branch()
  local branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
  if branch and branch ~= "" then
    return " " .. branch
  end
  return ""
end

_G.statusline = function()
  local mode_map = {
    n = "NORMAL", i = "INSERT", v = "VISUAL", V = "V-LINE",
    ["\22"] = "V-BLOCK", c = "COMMAND", s = "SELECT", S = "S-LINE",
    R = "REPLACE", t = "TERMINAL",
  }
  local m = mode_map[vim.fn.mode()] or vim.fn.mode()
  return table.concat({
    " " .. m .. " ",
    "%f",              -- filename
    "%m%r",            -- modified / readonly
    "%=",              -- right-align
    git_branch(),
  }, "  ")
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
