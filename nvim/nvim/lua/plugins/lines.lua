return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = function()
            local lualine = require("lualine")
            local theme = require("lualine.themes.auto")

            local white = "#ffffff"
            local black = "#000000"
            local gray = "#4a4a4a"

            theme.normal.a = { fg = black, bg = white }
            theme.insert.a = { fg = black, bg = white }
            theme.visual.a = { fg = black, bg = white }
            theme.replace.a = { fg = black, bg = white }
            theme.command.a = { fg = black, bg = white }
            theme.inactive.a = { fg = black, bg = white }
            theme.terminal.a = { fg = black, bg = white }

            theme.normal.b = { fg = white, bg = gray }
            theme.insert.b = { fg = white, bg = gray }
            theme.visual.b = { fg = white, bg = gray }
            theme.replace.b = { fg = white, bg = gray }
            theme.command.b = { fg = white, bg = gray }
            theme.inactive.b = { fg = white, bg = gray }
            theme.terminal.b = { fg = white, bg = gray }

            lualine.setup({
                options = {
                    icons_enabled = false,
                    globalstatus = true,
                    always_divide_middle = true,
                    disabled_filetypes = {
                        statusline = {},
                        winbar = {},
                    },
                    refresh = {
                        statusline = 100,
                        tabline = 100,
                        winbar = 100,
                    },
                    section_separators = { left = "", right = "" },
                    theme = theme,
                },

                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch" },
                    lualine_c = {
                        -- { "filename", path = 1, color = { fg = white, bg = gray } },
                        { "filename", path = 1 },
                    },
                    lualine_x = {},
                    lualine_y = {
                        {
                            function()
                                local ok, sc = pcall(vim.fn.searchcount, { maxcount = 9999 })
                                if not ok or not sc.total or sc.total == 0 then
                                    return ""
                                end
                                return sc.current .. "/" .. sc.total
                            end,
                            cond = function()
                                local ok, sc = pcall(vim.fn.searchcount, { maxcount = 1 })
                                return vim.v.hlsearch == 1 and ok and sc.total and sc.total > 0
                            end,
                        },
                    },
                    lualine_z = {},
                },

                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },

                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {},
            })
        end,
    },

    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("bufferline").setup({
                options = {
                    always_show_bufferline = false,
                    diagnostics = "nvim_lsp",
                    show_buffer_close_icons = false,
                    show_close_icon = false,
                },
            })
        end,
        keys = {
            { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
            {
                "<leader>bP",
                "<Cmd>BufferLineGroupClose ungrouped<CR>",
                desc = "Delete Non-Pinned Buffers",
            },
            { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
            { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
            { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
            { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
            { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
            { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
            { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
            { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
        },
    },
}
