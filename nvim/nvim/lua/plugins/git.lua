return {
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        opts = {
            current_line_blame = true,
            current_line_blame_opts = {
                virt_text_pos = "eol",
            },
        },
        keys = {
            {
                "<leader>gb",
                function()
                    require("gitsigns").toggle_current_line_blame()
                end,
                desc = "Toggle git blame",
            },
        },
    },
}
