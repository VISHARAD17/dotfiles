return {
  'mfussenegger/nvim-jdtls',
  ft = 'java',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'mfussenegger/nvim-dap',
  },
  config = function()
    -- Exit if jdtls is not installed
    local mason_registry = require('mason-registry')
    if not mason_registry.is_installed('jdtls') then
      vim.notify('jdtls is not installed. Please run :Mason to install it.', vim.log.levels.WARN)
      return
    end

    local jdtls = require('jdtls')
    local root_markers = {'gradlew', '.git', 'mvnw'}
    local root_dir = require('jdtls.setup').find_root(root_markers)
    if root_dir == nil then
      -- No Java project found. Nothing to do.
      return
    end

    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
    local workspace_dir = vim.fn.stdpath('data') .. '/java-workspace/' .. project_name

    -- mason paths
    local mason_path = vim.fn.stdpath('data') .. '/mason'
    local jdtls_path = mason_path .. '/packages/jdtls'
    local java_debug_path = mason_path .. '/packages/java-debug-adapter'
    local vscode_java_test_path = mason_path .. '/packages/vscode-java-test'

    -- The bundles for extensions
    local bundles = {}
    if mason_registry.is_installed('java-debug-adapter') then
        local debug_bundle = vim.fn.glob(java_debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar')
        if debug_bundle ~= '' then
            table.insert(bundles, debug_bundle)
        end
    end
    if mason_registry.is_installed('vscode-java-test') then
        local test_bundles = vim.fn.glob(vscode_java_test_path .. '/extension/server/*.jar', true)
        vim.list_extend(bundles, test_bundles)
    end


    local config = {
      cmd = {
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1.XmlServerApplication',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xms1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-jar', vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
        '-configuration', jdtls_path .. '/config_' .. (vim.fn.has('mac') and 'mac' or (vim.fn.has('win32') and 'win' or 'linux')),
        '-data', workspace_dir
      },

      root_dir = root_dir,
      init_options = {
        bundles = bundles,
        extendedClientCapabilities = {
            progressReportProvider = false,
        },
      },
      on_attach = function(client, bufnr)
        -- Keymaps for Java
        local map = vim.keymap.set
        local opts = { noremap = true, silent = true, buffer = bufnr, desc = "Java" }
        map('n', '<leader>jo', jdtls.organize_imports, opts)
        map('n', '<leader>jt', jdtls.test_class, opts)
        map('n', '<leader>jT', jdtls.test_nearest_method, opts)
        map('v', '<leader>je', { jdtls.extract_variable, mode = 'v' }, opts)
        map('n', '<leader>je', jdtls.extract_variable, opts)
        map('v', '<leader>jc', { jdtls.extract_constant, mode = 'v' }, opts)
        map('n', '<leader>jc', jdtls.extract_constant, opts)
        map('v', '<leader>jm', { jdtls.extract_method, mode = 'v' }, opts)
      end,
    }

    jdtls.start_or_attach(config)
  end
}
