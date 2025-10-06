return {
    {
        "stevearc/conform.nvim",
        event = "VeryLazy",
        config = function()
            require("conform").setup({
                format_on_save = {
                    timeout_ms = 500,
                    lsp_fallback = true,
                },
                formatters_by_ft = {
                    lua = { "stylua" },
                    -- python = { "black" },
                    javascript = { "prettier" },
                    typescript = { "prettier" },
                    json = { "prettier" },
                    -- sh = { "shfmt" },
                },
            })
        end,
    },
    {
        "folke/ts-comments.nvim",
        opts = {},
        event = "VeryLazy",
        enabled = vim.fn.has("nvim-0.10.0") == 1,
    },
    {
        "Wansmer/treesj",
        keys = {
            {
                "<leader>[",
                function()
                    require("treesj").toggle()
                end,
                desc = "Treesj Toggle",
            },
        },
        dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
        config = function()
            require("treesj").setup({
                use_default_keymaps = false,
            })
        end,
    },
}
