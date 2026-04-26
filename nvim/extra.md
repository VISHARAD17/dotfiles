## Treesitter Java Highlighting Fix

Treesitter needs two things: the parser binary and query files.

### 1. Install Java parser binary

```bash
git clone https://github.com/tree-sitter/tree-sitter-java /tmp/tree-sitter-java
cd /tmp/tree-sitter-java
cc -shared -fPIC -o java.so src/parser.c -I./src
mkdir -p ~/.local/share/nvim/site/parser
cp java.so ~/.local/share/nvim/site/parser/java.so
```

### 2. Install Java query files

Query files must be in `~/.config/nvim/queries/java/` (must be under nvim config, not data dir).

```bash
# If you have nvim-treesitter installed via vim.pack or lazy:
mkdir -p ~/.config/nvim/queries/java
cp ~/.local/share/nvim/site/pack/core/opt/nvim-treesitter/runtime/queries/java/highlights.scm \
~/.config/nvim/queries/java/highlights.scm

# OR copy from lazy path:
cp ~/.local/share/nvim/lazy/nvim-treesitter/queries/java/highlights.scm \
~/.config/nvim/queries/java/highlights.scm
```

### 3. Verify it works

Open a Java file in Neovim and run:
```
:lua print(pcall(vim.treesitter.language.add, "java")) -- should print: true
:Inspect -- on a keyword like `class`, should show @keyword treesitter captures
```

### Notes
- Semantic tokens are disabled in init.lua (`semanticTokensProvider = nil`) — treesitter handles all highlighting
- If `:Inspect` shows only `@lsp.type.*` entries, treesitter queries are missing (repeat step 2)
- If `:Inspect` shows `no items found`, parser binary is missing (repeat step 1)

## Completion (Native Neovim built-in)

Using native LSP omnifunc completion — no plugins required.

Key settings in `init.lua`:
```lua
vim.opt.completeopt = { "menuone", "noinsert", "noselect", "popup" }
vim.opt.pumheight = 15
vim.opt.pumblend = 10  -- slight transparency
```

Keymaps:
- `<C-Space>` — trigger completion (`<C-x><C-o>`)
- `<C-n>` / `<C-p>` — navigate items
- `<CR>` — accept selection (`<C-y>`)
- `<C-e>` — close menu

LSP hover and signature help use rounded borders (configured via `vim.lsp.handlers`).

blink.cmp config is kept commented out in `init.lua` — uncomment to switch back.

## Java Paths (update for each machine)

In `init.lua`, update these variables:
```lua
local JAVA21_HOME = "/Library/Java/JavaVirtualMachines/amazon-corretto-21.jdk/Contents/Home"
local LOMBOK_JAR = "/Users/<username>/.gradle/caches/modules-2/files-2.1/org.projectlombok/lombok/1.18.42/.../lombok-1.18.42.jar"
```

Find your Lombok jar:
```bash
find ~/.gradle/caches -name "lombok*.jar" | head -1
```

## jdtls Diagnostics Not Working

### Root Cause
brew's jdtls wrapper defaults to openjdk 25 which causes `BadLocationException` in jdtls,
preventing diagnostics from being published to Neovim.

### Fix
Force jdtls to use Java 21 by prepending `env JAVA_HOME=<java21_path>` to the cmd in `init.lua`:

```lua
cmd = {
  "env", "JAVA_HOME=" .. JAVA21_HOME, "jdtls",
  ...
}
```

### Other Requirements
- Working directory must have a `.git` folder for jdtls to attach. Run `git init` if missing.
- If workspace cache is corrupted: `rm -rf ~/.cache/nvim/jdtls/workspaces/`
- After any fix: `:lsp restart` in Neovim, wait ~1 min for indexing.

## Java LSP — "Not a Project File" Warning (Semantic Errors Missing)

### Root Cause
The Java LSP (Eclipse JDT) only reports syntax errors for standalone `.java` files.
Semantic errors (undefined variables, missing imports, typos) require a recognized project context.

### Fix
Add a `pom.xml` at the repo root and place source files under `src/main/java/`:

```bash
mkdir -p src/main/java
mv Solution.java src/main/java/
```

Minimal `pom.xml`:
```xml
<project>
  <modelVersion>4.0.0</modelVersion>
  <groupId>leetcode</groupId>
  <artifactId>leetcode</artifactId>
  <version>1.0</version>
  <properties>
    <maven.compiler.source>17</maven.compiler.source>
    <maven.compiler.target>17</maven.compiler.target>
  </properties>
</project>
```

### Notes
- `src/main/java/` is Maven's standard source directory; JDT only indexes files inside it
- IntelliJ handles standalone `.java` files natively without any project setup
- Quick alternative (no project setup): `javac Solution.java` reports all errors immediately

## Ctrl+Space Completion Not Working

### Root Cause
`omnifunc` was never set, so `<C-x><C-o>` had nothing to call.

### Fix
Add this inside the `LspAttach` autocmd callback in `init.lua`:
```lua
vim.bo[buf].omnifunc = "v:lua.vim.lsp.omnifunc"
```

### Notes
- kitty config already correctly passes `Ctrl+Space` as `\x00` — not a terminal issue
- Verify with `:set omnifunc?` — should show `v:lua.vim.lsp.omnifunc` when LSP is attached
