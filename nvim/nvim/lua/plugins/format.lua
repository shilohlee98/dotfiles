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
}
