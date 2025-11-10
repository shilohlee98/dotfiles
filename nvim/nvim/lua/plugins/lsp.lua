return {
    {
        "neovim/nvim-lspconfig",
        event = "VeryLazy",
        config = function()
            vim.diagnostic.config({
                float = { border = "rounded" },
                virtual_text = {
                    prefix = "●",
                    spacing = 4,
                },
            })
        end,
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
        dependencies = {
            "mason.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.offsetEncoding = { "utf-16" }
            local lspconfig = require("lspconfig")

            require("mason-lspconfig").setup({
                ensure_installed = { "pyright", "lua_ls", "ts_ls" },
                automatic_installation = true,
            })

            require("mason-lspconfig").setup_handlers({
                -- Default handler
                function(server_name)
                    lspconfig[server_name].setup({
                        capabilities = capabilities,
                    })
                end,

                -- Custom pyright handler
                ["pyright"] = function()
                    lspconfig.pyright.setup({
                        capabilities = capabilities,
                        settings = {
                            python = {
                                analysis = {
                                    typeCheckingMode = "off",
                                },
                            },
                        },
                        on_attach = function(client)
                            client.server_capabilities.documentFormattingProvider = false
                            client.server_capabilities.documentRangeFormattingProvider = false
                        end,
                    })
                end,
                ["ts_ls"] = function()
                    lspconfig.ts_ls.setup({
                        capabilities = capabilities,
                        settings = {
                            javascript = {
                                format = {
                                    insertSpaceBeforeFunctionParenthesis = true,
                                },
                            },
                            typescript = {
                                format = {
                                    insertSpaceBeforeFunctionParenthesis = true,
                                },
                            },
                        },
                    })
                end,
                ["lua_ls"] = function()
                    lspconfig.lua_ls.setup({
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "LuaJIT" },
                                diagnostics = {
                                    globals = { "vim" },
                                },
                                workspace = {
                                    library = vim.api.nvim_get_runtime_file("", true),
                                    checkThirdParty = false,
                                },
                                telemetry = { enable = false },
                            },
                        },
                    })
                end,
            })
        end,
    },
}
