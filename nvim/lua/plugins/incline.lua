-- plugins to display filename on the right top
return {
    "b0o/incline.nvim",
    event = "VimEnter",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        debounce_threshold = {
            falling = 50,
            rising = 10
        },
        hide = {
            cursorline = false,
            focused_win = false,
            only_win = false
        },
        highlight = {
            groups = {
                InclineNormal = {
                    default = true,
                    group = "NormalFloat"
                },
                InclineNormalNC = {
                    default = true,
                    group = "NormalFloat"
                }
            }
        },
        ignore = {
            buftypes = "special",
            filetypes = {},
            floating_wins = true,
            unlisted_buffers = true,
            wintypes = "special"
        },
        window = {
            margin = {
                horizontal = 1,
                vertical = 1
            },
            options = {
                signcolumn = "no",
                wrap = false
            },
            padding = 1,
            padding_char = " ",
            placement = {
                horizontal = "right",
                vertical = "top"
            },
            width = "fit",
            winhighlight = {
                active = {
                    EndOfBuffer = "None",
                    Normal = "InclineNormal",
                    Search = "None"
                },
                inactive = {
                    EndOfBuffer = "None",
                    Normal = "InclineNormalNC",
                    Search = "None"
                }
            },
            zindex = 50
        },

        render = function(props)
            local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
            local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)

            -- Get modified status icon
            -- below line is depreciated
            -- local modified_icon = vim.api.nvim_buf_get_option(props.buf, "modified") and  "● " or ""
            local modified_icon = vim.bo[props.buf].modified and "● " or ""

            -- Function to get diagnostic labels
            local function get_diagnostic_label()
                local icons = {diagnostics = {
                    Error = "✘",
                    Warn = "▲",
                    Hint = "⚑",
                    Info = " ",

                }}
                local label = {}
                for severity, icon in pairs(icons.diagnostics) do
                    local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
                    if n > 0 then
                        table.insert(label, { icon .. " " .. n .. " ", group = "DiagnosticSign" .. severity })
                    end
                end
                return label
            end

            -- Get diagnostic labels
            local diagnostics = get_diagnostic_label()

            -- Return the rendered components
            local render_components = {}

            -- Add diagnostic labels to render components
            for _, diag in ipairs(diagnostics) do
                table.insert(render_components, diag)
            end

            -- Add modified status icon if present
            if modified_icon ~= "" then
                table.insert(render_components, { modified_icon, group = "DiagnosticSignModified" }) -- You can define a highlight group for this
            end

            -- Add file type icon and file name
            table.insert(render_components, { " ", ft_icon, guifg = ft_color, guibg = '#3f3f3f' })
            table.insert(render_components, { " " , guibg = '#3f3f3f'})
            table.insert(render_components, { filename, " " , gui = 'bold', guibg = '#3f3f3f'})

            return render_components
        end
    }
}
