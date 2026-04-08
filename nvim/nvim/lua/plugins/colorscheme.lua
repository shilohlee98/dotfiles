-- return {
--     {
--         "catppuccin/nvim",
--         lazy = true,
--         name = "catppuccin",
--         opts = {
--             integrations = {
--                 cmp = true,
--                 fzf = true,
--                 gitsigns = true,
--                 indent_blankline = { enabled = true },
--                 lsp_trouble = true,
--                 mason = true,
--                 markdown = true,
--                 mini = true,
--                 native_lsp = {
--                     enabled = true,
--                     underlines = {
--                         errors = { "undercurl" },
--                         hints = { "undercurl" },
--                         warnings = { "undercurl" },
--                         information = { "undercurl" },
--                     },
--                 },
--                 navic = { enabled = true, custom_bg = "lualine" },
--                 neotest = true,
--                 neotree = true,
--                 semantic_tokens = true,
--                 snacks = true,
--                 telescope = true,
--                 treesitter = true,
--                 treesitter_context = true,
--                 which_key = true,
--             },
--             color_overrides = {
--                 mocha = {
--                     base = "#202020",
--                     mantle = "#202020",
--                 },
--             },
--         },
--         specs = {
--             {
--                 "akinsho/bufferline.nvim",
--                 optional = true,
--                 opts = function(_, opts)
--                     if (vim.g.colors_name or ""):find("catppuccin") then
--                         opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
--                     end
--                 end,
--             },
--         },
--         init = function()
--             vim.cmd.colorscheme("catppuccin")
--         end,
--     },
-- }

return {
    {
        "webhooked/kanso.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("kanso").setup({
                background = {
                    dark = "mist",
                },
                overrides = function(colors)
                    return {
                        ----------------------------------------------------------------
                        -- 🌑 基礎（純黑 + 提亮）
                        ----------------------------------------------------------------
                        Normal = { fg = "#e6e6e6", bg = "#000000" },
                        NormalNC = { bg = "#000000" },
                        SignColumn = { bg = "#000000" },
                        EndOfBuffer = { bg = "#000000" },

                        ----------------------------------------------------------------
                        -- 🪟 浮動視窗
                        ----------------------------------------------------------------
                        NormalFloat = { bg = "#000000" },
                        FloatBorder = { fg = "#505050", bg = "#000000" },

                        ----------------------------------------------------------------
                        -- 🔍 Snacks
                        ----------------------------------------------------------------
                        SnacksPicker = { bg = "#000000" },
                        SnacksPickerBorder = { fg = "#505050", bg = "#000000" },
                        SnacksPickerTitle = { fg = "#ffffff", bg = "#000000" },
                        SnacksPickerList = { bg = "#000000" },
                        SnacksPickerSelection = { bg = "#1a1a1a" },

                        ----------------------------------------------------------------
                        -- 🎯 UI
                        ----------------------------------------------------------------
                        CursorLine = { bg = "#1a1a1a" },
                        Visual = { bg = "#3E424A" },
                        WinSeparator = { fg = "#505050", bg = "#000000" },

                        ----------------------------------------------------------------
                        -- 💬 註解（不要太灰）
                        ----------------------------------------------------------------
                        Comment = { fg = "#a0a0a0", italic = true },

                        ----------------------------------------------------------------
                        -- 🔥 語法（關鍵：全部亮一階）
                        ----------------------------------------------------------------
                        Keyword = { fg = "#ff9e64" },
                        Statement = { fg = "#ff9e64" },

                        Identifier = { fg = "#dcdcdc" },
                        Function = { fg = "#7fb4ca" },

                        String = { fg = "#a3d4a5" },
                        Character = { fg = "#a3d4a5" },

                        Number = { fg = "#f0c674" },
                        Constant = { fg = "#f0c674" },

                        Type = { fg = "#e5c07b" },

                        Operator = { fg = "#dcdcdc" },
                        TreesitterContext = { bg = "#101010" },

                        ----------------------------------------------------------------
                        -- 📦 import / from / path（你圖最灰的地方）
                        ----------------------------------------------------------------
                        Include = { fg = "#7fb4ca" },

                        ----------------------------------------------------------------
                        -- 🔧 額外（讓 code 更清楚）
                        ----------------------------------------------------------------
                        Variable = { fg = "#e6e6e6" },
                        Title = { fg = "#ffffff" },
                    }
                end,
            })

            vim.cmd.colorscheme("kanso")
        end,
    },
}
