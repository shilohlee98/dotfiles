return {
    "folke/snacks.nvim",
    opts = {
        picker = {
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
            "gI",
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
