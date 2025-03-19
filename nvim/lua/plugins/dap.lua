return
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "leoluz/nvim-dap-go",              -- Go debugging
            "rcarriga/nvim-dap-ui",            -- DAP UI
            "theHamsta/nvim-dap-virtual-text", -- Virtual text for variables
            "nvim-neotest/nvim-nio",           -- Required by dap-ui
            "williamboman/mason.nvim",         -- Manage debug adapters
            "jay-babu/mason-nvim-dap.nvim",    -- Mason DAP integration
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            -- Setup Mason for debug adapters
            require("mason").setup()
            require("mason-nvim-dap").setup({
                ensure_installed = { "codelldb", "delve" }, -- C++ and Go adapters
                handlers = {
                    function(config)
                        require("mason-nvim-dap").default_setup(config)
                    end,
                },
            })

            -- C++ (codelldb) configuration
            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = "codelldb",
                    args = { "--port", "${port}" },
                },
            }
            dap.configurations.cpp = {
                {
                    name = "Launch C++",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    args = {},
                },
            }
            dap.configurations.c = dap.configurations.cpp -- Reuse for C

            -- Go (delve) configuration (from nvim-dap-go)
            require("dap-go").setup()

            -- DAP UI setup
            dapui.setup({
                layouts = {
                    {
                        elements = { "scopes", "breakpoints", "stacks", "watches" },
                        size = 40,
                        position = "left",
                    },
                    {
                        elements = { "repl", "console" },
                        size = 10,
                        position = "bottom",
                    },
                },
            })

            -- Virtual text setup
            require("nvim-dap-virtual-text").setup()

            -- Breakpoint sign
            vim.fn.sign_define("DapBreakpoint", {
                text = "🔴",
                texthl = "DapBreakpoint",
                linehl = "DapBreakpoint",
                numhl = "DapBreakpoint",
            })

            -- Auto-open/close UI
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- Keybindings
            vim.keymap.set("n", "<leader>dt", ":DapUiToggle<CR>", { noremap = true, desc = "Toggle DAP UI" })
            vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { noremap = true, desc = "Toggle Breakpoint" })
            vim.keymap.set("n", "<leader>dc", dap.continue, { noremap = true, desc = "Continue" })
            vim.keymap.set("n", "<leader>dr", function() dapui.open({ reset = true }) end, { noremap = true, desc = "Reset DAP UI" })
            vim.keymap.set("n", "<F5>", dap.continue, { desc = "Continue" })
            vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
            vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
            vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })
        end,
    }
