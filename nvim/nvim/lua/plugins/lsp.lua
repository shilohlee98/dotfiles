local servers = { "pyright", "lua_ls", "tsgo" }

local mason_packages = {
    "pyright",
    "lua-language-server",
    "tsgo",
}

local function restart_lsp_for_open_buffers()
    if vim.v.vim_did_enter ~= 1 then
        return
    end

    vim.schedule(function()
        pcall(vim.cmd.doautoall, "FileType")
    end)
end

local function ensure_mason_packages_installed(packages)
    local registry = require("mason-registry")

    registry.refresh(function()
        for _, package_name in ipairs(packages) do
            local ok, pkg = pcall(registry.get_package, package_name)

            if not ok then
                vim.notify(
                    ("Mason package not found: %s"):format(package_name),
                    vim.log.levels.WARN
                )
            elseif not pkg:is_installed() then
                pkg:once("install:success", restart_lsp_for_open_buffers)
                pkg:install()
            end
        end
    end)
end

local function tsgo_root_dir(bufnr, on_dir)
    local root_markers = {
        "tsconfig.json",
        "jsconfig.json",
        "package.json",
    }

    local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
    local deno_lock_root = vim.fs.root(bufnr, { "deno.lock" })
    local project_root = vim.fs.root(bufnr, root_markers)

    if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then
        return
    end

    if deno_root and (not project_root or #deno_root >= #project_root) then
        return
    end

    if project_root then
        on_dir(project_root)
    end
end

local function tsgo_cmd(dispatchers, config)
    config = config or {}

    local cmd = "tsgo"

    if type(config.root_dir) == "string" then
        local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules/.bin", cmd)

        if vim.fn.executable(local_cmd) == 1 then
            cmd = local_cmd
        end
    end

    return vim.lsp.rpc.start({ cmd, "--lsp", "--stdio" }, dispatchers, {
        cwd = config.cmd_cwd,
        env = config.cmd_env,
        detached = config.detached,
    })
end

return {
    {
        "williamboman/mason.nvim",
        event = "VeryLazy",
        config = function()
            require("mason").setup()
            ensure_mason_packages_installed(mason_packages)

            vim.diagnostic.config({
                float = { border = "rounded" },
                virtual_text = {
                    prefix = "●",
                    spacing = 4,
                },
            })

            local capabilities = vim.lsp.protocol.make_client_capabilities()

            local has_blink, blink = pcall(require, "blink.cmp")
            if has_blink then
                capabilities = blink.get_lsp_capabilities(capabilities)
            end

            vim.lsp.config("*", {
                capabilities = capabilities,
            })

            vim.lsp.config("pyright", {
                cmd = { "pyright-langserver", "--stdio" },
                filetypes = { "python" },
                root_markers = {
                    "pyproject.toml",
                    "setup.py",
                    "setup.cfg",
                    "requirements.txt",
                    "Pipfile",
                    "pyrightconfig.json",
                    ".git",
                },
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            diagnosticMode = "openFilesOnly",
                            typeCheckingMode = "off",
                            useLibraryCodeForTypes = true,
                        },
                    },
                },
                on_attach = function(client)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                end,
            })

            vim.lsp.config("tsgo", {
                cmd = tsgo_cmd,
                cmd_env = {
                    GOGC = "50",
                    GOMEMLIMIT = "768MiB",
                },
                filetypes = {
                    "javascript",
                    "javascriptreact",
                    "javascript.jsx",
                    "typescript",
                    "typescriptreact",
                    "typescript.tsx",
                },
                root_dir = tsgo_root_dir,
                settings = {
                    typescript = {
                        disableAutomaticTypeAcquisition = true,
                        inlayHints = {
                            parameterNames = {
                                enabled = "none",
                                suppressWhenArgumentMatchesName = true,
                            },
                            parameterTypes = { enabled = false },
                            variableTypes = { enabled = false },
                            propertyDeclarationTypes = { enabled = false },
                            functionLikeReturnTypes = { enabled = false },
                            enumMemberValues = { enabled = false },
                        },
                        preferences = {
                            includePackageJsonAutoImports = "off",
                        },
                        suggest = {
                            autoImports = false,
                            includeCompletionsForImportStatements = false,
                        },
                        workspaceSymbols = {
                            excludeLibrarySymbols = true,
                            scope = "currentProject",
                        },
                        format = {
                            insertSpaceBeforeFunctionParenthesis = true,
                        },
                    },
                    javascript = {
                        inlayHints = {
                            parameterNames = {
                                enabled = "none",
                                suppressWhenArgumentMatchesName = true,
                            },
                            parameterTypes = { enabled = false },
                            variableTypes = { enabled = false },
                            propertyDeclarationTypes = { enabled = false },
                            functionLikeReturnTypes = { enabled = false },
                        },
                        suggest = {
                            autoImports = false,
                            includeCompletionsForImportStatements = false,
                        },
                        format = {
                            insertSpaceBeforeFunctionParenthesis = true,
                        },
                    },
                },
            })

            vim.lsp.config("lua_ls", {
                cmd = { "lua-language-server" },
                filetypes = { "lua" },
                root_markers = {
                    ".luarc.json",
                    ".luarc.jsonc",
                    ".luacheckrc",
                    ".stylua.toml",
                    "stylua.toml",
                    "selene.toml",
                    "selene.yml",
                    ".git",
                },
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        diagnostics = {
                            globals = { "vim", "Snacks" },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = { enable = false },
                    },
                },
            })

            vim.lsp.enable(servers)
        end,
    },
}
