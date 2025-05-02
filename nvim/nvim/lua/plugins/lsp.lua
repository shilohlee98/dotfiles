vim.keymap.set("n", "<Leader>d", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.diagnostic.config({
    float = { border = "rounded" },
})

vim.diagnostic.config({
    virtual_text = {
        prefix = "●",
        spacing = 4,
        severity = nil,
    },
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<Leader>a", vim.lsp.buf.code_action, { noremap = true, silent = true })
    end,
})

return {
    {
        "neovim/nvim-lspconfig",
        event = "VeryLazy",
    },
    {
        "williamboman/mason.nvim",
        event = "VeryLazy",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        dependencies = { "mason.nvim" },
        config = function()
            require("mason-lspconfig").setup()
            require("mason-lspconfig").setup_handlers({
                function(server_name)
                    require("lspconfig")[server_name].setup({})
                end,
            })
        end,

        ["pyright"] = function()
            lspconfig.pyright.setup({
                on_attach = function(client)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                end,
                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = "off",
                        },
                    },
                },
            })
        end,
    },
}
