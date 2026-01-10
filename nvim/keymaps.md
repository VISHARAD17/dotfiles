# Neovim Keymaps Guide

This guide provides a summary of the keymaps configured in your Neovim setup, designed to help you test and verify your shortcuts, especially for Java development.

**Note:** `<leader>` is the `Space` key.

---

## 🏆 General & Navigation

These keymaps are for general editing, window management, and buffer navigation.

| Keybinding        | Mode     | Description                      |
| ----------------- | -------- | -------------------------------- |
| `<C-h>`           | Normal   | Move to the window on the left   |
| `<C-j>`           | Normal   | Move to the window below         |
| `<C-k>`           | Normal   | Move to the window above         |
| `<C-l>`           | Normal   | Move to the window on the right  |
| `<C-d>`           | Normal   | Scroll down half a page          |
| `<C-u>`           | Normal   | Scroll up half a page            |
| `<Tab>`           | Normal   | Go to the next buffer            |
| `<S-Tab>`         | Normal   | Go to the previous buffer        |
| `<Esc>`           | Normal   | Clear search highlight           |
| `<leader>e`       | Normal   | Toggle file explorer (NvimTree)  |
| `<leader>p`       | Normal   | Open Plugin Manager (Lazy)       |
| `<leader>kc`      | Normal   | Close (kill) the current buffer  |
| `<leader>ko`      | Normal   | Close all buffers except current |
| `<`               | Visual   | Indent left (and stay in visual) |
| `>`               | Visual   | Indent right (and stay in visual)|
| `<S-j>`           | Visual   | Move selected line(s) down       |
| `<S-k>`           | Visual   | Move selected line(s) up         |

---

## ☕ Java & LSP (Language Server Protocol)

These keymaps are essential for code intelligence and are perfect for testing in the `tmp/java-test` project. Place your cursor on a class, method, or variable in `Main.java` to try them out.

| Keybinding        | Mode     | Description                            |
| ----------------- | -------- | -------------------------------------- |
| `<leader>ld`      | Normal   | **Go to Definition** of the symbol under the cursor. |
| `<leader>lD`      | Normal   | **Go to Declaration** of the symbol.   |
| `<leader>lg`      | Normal   | **Go to References** of the symbol.    |
| `<leader>lr`      | Normal   | **Rename** the symbol under the cursor across all files. |
| `<leader>la`      | Normal   | Show **Code Actions** available at the cursor position (e.g., "implement interface"). |
| `<leader>lk`      | Normal   | **Hover Documentation** for the symbol under the cursor. |
| `<leader>lK`      | Normal   | Show **Signature Help** for the function/method call. |
| `<leader>lf`      | Normal   | **Format** the current document.       |
| `<leader>d`       | Normal   | Show line **diagnostics** (errors/warnings) in a floating window. |
| `<leader>q`       | Normal   | Open all diagnostics in the **Quickfix list**. |
| `<leader>ls`      | Normal   | List all **Document Symbols** (classes, methods, etc.) in Telescope. |
| `<leader>fr`      | Normal   | **Find References** for the symbol under the cursor in Telescope. |
| `<leader>li`      | Normal   | Show LSP **Info** for the current buffer. |

---

## 🔭 Telescope (Fuzzy Finder)

Telescope provides powerful fuzzy finding capabilities.

| Keybinding        | Mode     | Description                               |
| ----------------- | -------- | ----------------------------------------- |
| `<leader>ff`      | Normal   | **Find Files** anywhere in the project.   |
| `<leader>ft`      | Normal   | **Find Text** (live grep) in all files.   |
| `<leader>fo`      | Normal   | Find **Old Files** (recently opened).     |
| `<leader>fb`      | Normal   | Find currently open **Buffers**.          |
| `<leader>fc`      | Normal   | Find text in the **Current File**.        |
| `<leader>fd`      | Normal   | Find files in the **Current Directory**.  |
| `<leader>fk`      | Normal   | Search and view **Keymaps**.              |
| `<leader>fh`      | Normal   | Search **Help Tags**.                     |

---

##  Git Integration (Gitsigns & Telescope)

| Keybinding        | Mode     | Description                               |
| ----------------- | -------- | ----------------------------------------- |
| `<leader>gs`      | Normal   | Show **Git Status** in Telescope.         |
| `<leader>gb`      | Normal   | Show **Git Branches** in Telescope.       |
| `<leader>gc`      | Normal   | Show **Git Commits** in Telescope.        |
| `<leader>gj`      | Normal   | Go to the **Next Git Hunk** (change).     |
| `<leader>gk`      | Normal   | Go to the **Previous Git Hunk**.          |
| `<leader>gS`      | Normal   | **Stage Hunk** under the cursor.          |
| `<leader>gU`      | Normal   | **Undo Stage Hunk**.                      |
| `<leader>gr`      | Normal   | **Reset Hunk** (discard changes).         |
| `<leader>gR`      | Normal   | **Reset Buffer** (discard all changes in the file). |
| `<leader>gp`      | Normal   | **Preview Hunk**.                         |
| `<leader>gl`      | Normal   | **Blame Line** (show who last changed the line). |
| `<leader>gd`      | Normal   | **Diff This** against `HEAD`.             |

---

## 🤖 Copilot

| Keybinding        | Mode     | Description                               |
| ----------------- | -------- | ----------------------------------------- |
| `<C-y>`           | Insert   | Accept Copilot suggestion.                |
