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

            dapui.setup()
            require("nvim-dap-virtual-text").setup()

            -- Auto open/close UI when session starts/ends
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

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
                protocol = "inspector",
                resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
                outFiles = { "${workspaceFolder}/**/*.js" },
                skipFiles = { "<node_internals>/**", "**/node_modules/**" },
            }, common)

            -- === ATTACH 1: attach by picking a process (PID) ===
            local tsnode_attach_pid = vim.tbl_extend("force", {
                type = "pwa-node",
                request = "attach",
                name = "Attach (pick process)",
                processId = require("dap.utils").pick_process, -- Target process must be started with --inspect or --inspect-brk
            }, common)

            -- === ATTACH 2: attach to a port (default 9229) ===
            local function attach_to_port(port)
                dap.run(vim.tbl_extend("force", {
                    type = "pwa-node",
                    request = "attach",
                    name = "Attach (port " .. port .. ")",
                    address = "localhost",
                    port = tonumber(port) or 9229,
                }, common))
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
            vim.keymap.set(
                "n",
                "<leader>db",
                dap.toggle_breakpoint,
                { desc = "DAP Toggle Breakpoint" }
            )
            vim.keymap.set("n", "<leader>du", function()
                require("dapui").toggle()
            end, { desc = "DAP UI Toggle" })

            -- Run current file via npx ts-node
            vim.keymap.set("n", "<leader>dr", function()
                dap.run(tsnode_launch)
            end, { desc = "DAP: Run current TS file via npx ts-node" })

            -- Attach: pick process (PID)
            vim.keymap.set("n", "<leader>da", function()
                dap.run(tsnode_attach_pid)
            end, { desc = "DAP: Attach (pick process)" })

            -- Attach: input port (default 9229)
            vim.keymap.set("n", "<leader>dp", function()
                vim.ui.input({ prompt = "Attach port (default 9229): " }, function(input)
                    attach_to_port(tonumber(input) or 9229)
                end)
            end, { desc = "DAP: Attach (port)" })
        end,
    },
}
