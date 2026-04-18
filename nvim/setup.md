# Neovim Setup — Intel Mac

## Already Installed (on current machine)
- Neovim v0.12.0
- Java 21 (Amazon Corretto) — `/Library/Java/JavaVirtualMachines/amazon-corretto-21.jdk`
- jdtls — `/opt/homebrew/bin/jdtls`
- ripgrep — `/opt/homebrew/bin/rg`
- git 2.49.0
- node v25.8.1
- fzf — `/opt/homebrew/bin/fzf`
- Homebrew 5.1.6

---

## Setup on a New Intel Mac

### 1. Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Neovim
```bash
brew install neovim
```

### 3. Java 21 (Amazon Corretto)
```bash
brew install --cask corretto21
```
Add to `~/.zshrc`:
```bash
export JAVA_HOME=/Library/Java/JavaVirtualMachines/amazon-corretto-21.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH
```

### 4. jdtls
```bash
brew install jdtls
```

### 5. Essential tools
```bash
brew install ripgrep fzf git node
```

### 6. Lua Language Server (optional, for editing init.lua)
```bash
brew install lua-language-server
```

### 7. Copy Neovim config
```bash
mkdir -p ~/.config/nvim/colors
cp init.lua ~/.config/nvim/
cp colors/fleet_dark.lua ~/.config/nvim/colors/
```

### 8. First launch
```bash
nvim
# Plugins auto-install on first launch, wait ~30 seconds
```

### 9. Verify
```bash
# Inside Neovim
:checkhealth vim.lsp
```

---

## Key Bindings Reference

| Key | Action |
|-----|--------|
| `Space + f` | Fuzzy find files |
| `Space + b` | Find buffers |
| `Space + g` | Live grep |
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Hover docs |
| `Space + ca` | Code actions |
| `Space + rn` | Rename symbol |
| `Ctrl + o` | Jump back |
| `]q` / `[q` | Navigate quickfix |
| `Ctrl + s` | Save |