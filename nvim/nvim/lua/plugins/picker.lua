local function git_diff_filter(item, ctx)
    if not ctx.picker.opts.hide_test_and_docs then
        return
    end

    local file = (item.file or ""):lower():gsub("\\", "/")
    local path = "/" .. file .. "/"
    local name = vim.fs.basename(file)

    if file:match("%.mdx?$") then
        return false
    end

    local excluded_dirs = {
        "test",
        "tests",
        "__tests__",
        "integration",
        "integration-tests",
        "e2e",
        "__e2e__",
    }
    for _, dir in ipairs(excluded_dirs) do
        if path:find("/" .. dir .. "/", 1, true) then
            return false
        end
    end

    if
        name:find("%.test%.")
        or name:find("%.spec%.")
        or name:find("%.integration%.")
        or name:match("^test_.+%.py$")
        or name:match(".+_test%.py$")
        or name:match(".+_test%.go$")
    then
        return false
    end
end

return {
    "folke/snacks.nvim",
    opts = {
        image = { enabled = false },
        picker = {
            win = {
                input = {
                    keys = {
                        ["<C-h>"] = { "<Left>", mode = "i", expr = true },
                        ["<C-j>"] = { "list_down", mode = { "i", "n" } },
                        ["<C-k>"] = { "list_up", mode = { "i", "n" } },
                        ["<C-l>"] = { "<Right>", mode = "i", expr = true },
                    },
                },
            },
            layout = {
                layout = {
                    backdrop = false,
                    row = 1,
                    width = 0.9,
                    min_width = 80,
                    height = 0.9,
                    border = "none",
                    box = "vertical",
                    {
                        win = "input",
                        height = 1,
                        border = "top",
                        title = "{title} {live} {flags}",
                        title_pos = "center",
                    },
                    { win = "list", height = 0.35, border = "top" },
                    { win = "preview", title = "{preview}", border = "top" },
                },
            },
            sources = {
                files = { hidden = true },
                git_diff = {
                    hide_test_and_docs = false,
                    toggles = {
                        hide_test_and_docs = "t",
                    },
                    transform = git_diff_filter,
                    win = {
                        input = {
                            keys = {
                                ["<A-t>"] = {
                                    "toggle_hide_test_and_docs",
                                    mode = { "i", "n" },
                                    desc = "Toggle tests, integration, and Markdown",
                                },
                            },
                        },
                        list = {
                            keys = {
                                ["<A-t>"] = {
                                    "toggle_hide_test_and_docs",
                                    mode = "n",
                                    desc = "Toggle tests, integration, and Markdown",
                                },
                            },
                        },
                    },
                },
            },
            formatters = {
                file = {
                    filename_first = true,
                    truncate = 300,
                },
            },
        },
    },
    keys = {
        -- Top Pickers & Explorer
        {
            "<leader><space>",
            function()
                Snacks.picker.smart()
            end,
            desc = "Smart Find Files (with hidden)",
        },
        {
            "<leader>/",
            function()
                Snacks.picker.grep()
            end,
            desc = "Grep",
        },
        -- git
        {
            "<leader>gb",
            function()
                Snacks.picker.git_branches()
            end,
            desc = "Git Branches",
        },
        {
            "<leader>gl",
            function()
                Snacks.picker.git_log()
            end,
            desc = "Git Log",
        },
        {
            "<leader>gs",
            function()
                Snacks.picker.git_status()
            end,
            desc = "Git Status",
        },
        {
            "<leader>gS",
            function()
                Snacks.picker.git_stash()
            end,
            desc = "Git Stash",
        },
        {
            "<leader>gd",
            function()
                Snacks.picker.git_diff()
            end,
            desc = "Git Diff (Hunks)",
        },
        {
            "<leader>gf",
            function()
                Snacks.picker.git_log_file()
            end,
            desc = "Git Log File",
        },
        -- LSP
        {
            "gd",
            function()
                Snacks.picker.lsp_definitions()
            end,
            desc = "Goto Definition",
        },
        {
            "gD",
            function()
                Snacks.picker.lsp_declarations()
            end,
            desc = "Goto Declaration",
        },
        {
            "gr",
            function()
                Snacks.picker.lsp_references()
            end,
            nowait = true,
            desc = "References",
        },
        {
            "ge",
            function()
                Snacks.picker.lsp_implementations()
            end,
            desc = "Goto Implementation",
        },
        {
            "gy",
            function()
                Snacks.picker.lsp_type_definitions()
            end,
            desc = "Goto T[y]pe Definition",
        },
        {
            "gai",
            function()
                Snacks.picker.lsp_incoming_calls()
            end,
            desc = "C[a]lls Incoming",
        },
        {
            "gao",
            function()
                Snacks.picker.lsp_outgoing_calls()
            end,
            desc = "C[a]lls Outgoing",
        },
        {
            "<leader>sd",
            function()
                Snacks.picker.diagnostics_buffer()
            end,
            desc = "Buffer Diagnostics",
        },
        {
            "<leader>sw",
            function()
                Snacks.picker.grep_word()
            end,
            desc = "Visual selection or word",
            mode = { "n", "x" },
        },
    },
}
