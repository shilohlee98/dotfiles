return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            dapui.setup({
                layouts = {
                    {
                        elements = {
                            { id = "repl", size = 0.5 },
                            { id = "console", size = 0.5 },
                        },
                        position = "bottom",
                        size = 15,
                        direction = "vertical",
                    },
                },
            })
            require("nvim-dap-virtual-text").setup()
            -- === js-debug adapter (pwa-node) ===
            local mason = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug"
            local node = vim.fn.exepath("node")
            if node == "" then
                node = "node"
            end
            dap.adapters["pwa-node"] = {
                type = "server",
                host = "localhost",
                port = "${port}",
                executable = {
                    command = node,
                    args = { mason .. "/src/dapDebugServer.js", "${port}" },
                    options = { cwd = mason },
                },
            }

            -- === Run current file with npx ts-node ===
            local npx = vim.fn.exepath("npx")
            if npx == "" then
                npx = "npx"
            end
            local common = {
                cwd = "${workspaceFolder}",
                sourceMaps = true,
                resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
                skipFiles = { "<node_internals>/**", "**/node_modules/**" },
            }

            local tsnode_launch = vim.tbl_extend("force", {
                type = "pwa-node",
                request = "launch",
                name = "Run current file (npx ts-node)",
                runtimeExecutable = npx,
                runtimeArgs = { "ts-node", "--files" }, -- For ESM projects, use { "ts-node", "--esm" }
                program = "${file}",
                cwd = "${workspaceFolder}",
                sourceMaps = true,
                console = "integratedTerminal",
                protocol = "inspector",
                resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
                outFiles = { "${workspaceFolder}/**/*.js" },
                skipFiles = { "<node_internals>/**", "**/node_modules/**" },
            }, common)

            local launch_npm_dev = {
                type = "pwa-node",
                request = "launch",
                name = "Launch npm run dev (inspect)",
                runtimeExecutable = "npm",
                runtimeArgs = { "run", "dev" },
                env = { NODE_OPTIONS = "--inspect=9229" },
                cwd = vim.loop.cwd(),
                console = "integratedTerminal",
                sourceMaps = true,
                protocol = "inspector",
                outFiles = { "${workspaceFolder}/**/*.js" },
                resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
                skipFiles = { "<node_internals>/**", "**/node_modules/**" },
            }

            local function prompt_js_command_launch()
                local cmd = vim.trim(vim.fn.input("cmd: "))
                if cmd == "" then
                    vim.notify("DAP: empty JS command", vim.log.levels.WARN)
                    return nil
                end

                local parts = vim.split(cmd, "%s+", { trimempty = true })
                local runtime = table.remove(parts, 1)
                if not runtime or runtime == "" then
                    vim.notify("DAP: invalid JS command", vim.log.levels.ERROR)
                    return nil
                end

                return vim.tbl_extend("force", {
                    type = "pwa-node",
                    request = "launch",
                    name = "Run JS command (prompt)",
                    runtimeExecutable = runtime,
                    runtimeArgs = parts,
                    cwd = "${workspaceFolder}",
                    console = "integratedTerminal",
                    protocol = "inspector",
                    outFiles = { "${workspaceFolder}/**/*.js" },
                }, common)
            end

            dap.configurations.typescript = { tsnode_launch, tsnode_attach_pid }
            dap.configurations.typescriptreact = { tsnode_launch, tsnode_attach_pid }
            dap.configurations.javascript = { tsnode_launch, tsnode_attach_pid }
            dap.configurations.javascriptreact = { tsnode_launch, tsnode_attach_pid }

            -- === keymaps ===
            vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP Continue" })
            vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP Step Over" })
            vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP Step Into" })
            vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP Step Out" })
            vim.keymap.set("n", "<leader>dq", function()
                require("dap").terminate()
            end, { desc = "Stop Debugging" })
            vim.keymap.set(
                "n",
                "<leader>db",
                dap.toggle_breakpoint,
                { desc = "DAP Toggle Breakpoint" }
            )

            -- vim.keymap.set("n", "<F6>", function()
            --     require("dapui").float_element("breakpoints")
            -- end, { desc = "DAP float" })
            --
            vim.keymap.set("n", "<leader>du", function()
                require("dapui").toggle()
            end, { desc = "DAP UI Toggle" })

            -- Run current file via npx ts-node
            vim.keymap.set("n", "<leader>dr", function()
                dap.run(tsnode_launch)
            end, { desc = "DAP: Run current TS file via npx ts-node" })

            vim.keymap.set("n", "<leader>dd", function()
                dap.run(launch_npm_dev)
            end, { desc = "DAP: Launch npm run dev (inspect)" })

            vim.keymap.set("n", "<leader>dj", function()
                local cfg = prompt_js_command_launch()
                if cfg then
                    dap.run(cfg)
                end
            end, { desc = "DAP: Prompt and run JS command" })
        end,
    },
}
