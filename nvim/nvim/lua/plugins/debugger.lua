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

            -- Automatically open/close UI
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            local jsdbg = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug"
            require("dap").adapters["pwa-node"] = {
                type = "server",
                host = "localhost",
                port = "${port}",
                executable = {
                    command = vim.fn.exepath("node"), -- Use the actual node executable
                    args = { jsdbg .. "/src/dapDebugServer.js", "${port}" },
                    options = { cwd = jsdbg }, -- Important: cwd must be the root of js-debug
                },
            }

            -- Automatically find the inspector port of ts-node index.ts process and attach by port
            local function auto_attach_express()
                local function sh(cmd)
                    local f = io.popen(cmd)
                    if not f then
                        return nil
                    end
                    local out = f:read("*a")
                    f:close()
                    return (out or ""):gsub("%s+$", "")
                end

                -- 1) Find the most likely Express process (ts-node ... index.ts)
                local pid = sh([[pgrep -fl "ts-node.*index.ts" | awk '{print $1}' | tail -n1]])
                if pid == "" or not pid then
                    vim.notify(
                        "Could not find ts-node index.ts process (run npm run dev first)",
                        vim.log.levels.WARN
                    )
                    return
                end

                -- 2) From that PID, get the inspector listening port (127.0.0.1:xxxxx)
                local port = sh(
                    [[lsof -a -p ]]
                        .. pid
                        .. [[ -nP -iTCP -sTCP:LISTEN | \
                   awk '/127\.0\.0\.1:[0-9]+/ {print $9}' | sed 's/.*://' | tail -n1]]
                )
                if port == "" or not tonumber(port) then
                    vim.notify(
                        "Could not find inspector port for that process (no result from lsof)",
                        vim.log.levels.ERROR
                    )
                    return
                end

                -- 3) Attach using port instead of PID (more reliable)
                require("dap").run({
                    type = "pwa-node",
                    request = "attach",
                    name = "Auto-attach Express (:" .. port .. ")",
                    address = "localhost",
                    port = tonumber(port),
                    cwd = vim.loop.cwd(),
                    sourceMaps = true,
                    autoAttachChildProcesses = true,
                    skipFiles = { "<node_internals>/**", "**/node_modules/**" },
                })
            end

            -- Keymap: auto attach
            vim.keymap.set(
                "n",
                "<leader>da",
                auto_attach_express,
                { desc = "DAP Auto-attach Express" }
            )
            -- Basic keymaps (LazyVim default leader is <Space>)
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
        end,
    },
}
