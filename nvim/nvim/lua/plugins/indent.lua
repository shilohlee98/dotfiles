return {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {
        indent = {
            char = "│",
            tab_char = "│",
        },
        scope = { show_start = false, show_end = false },
        exclude = {
            filetypes = {
                "dashboard",
                "lazy",
                "mason",
                "yazi",
                "notify",
                "help",
            },
        },
    },
}
