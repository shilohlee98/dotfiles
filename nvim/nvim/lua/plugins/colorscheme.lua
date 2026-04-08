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
                        Normal = { fg = "#d8d8d8", bg = "#000000" },
                        NormalNC = { bg = "#000000" },

                        SnacksPicker = { bg = "#000000" },
                        SnacksPickerBorder = { fg = "#303030", bg = "#000000" },
                        SnacksPickerTitle = { fg = "#c8c8c8", bg = "#000000" },
                        SnacksPickerList = { bg = "#000000" },
                        SnacksPickerSelection = { bg = "#111111" },

                        NormalFloat = { bg = "#000000" },
                        FloatBorder = { fg = "#303030", bg = "#000000" },

                        CursorLine = { bg = "#111111" },
                        Visual = { bg = "#3E424A" },
                        WinSeparator = { fg = "#303030", bg = "#000000" },

                        Comment = { fg = "#707070" },
                    }
                end,
            })

            vim.cmd.colorscheme("kanso")
        end,
    },
}
