-- treesitter
return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = "VeryLazy",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "c",
                    "cpp",
                    "lua",
                    "python",
                    "vim",
                    "vimdoc",
                    "comment",
                    "tsx",
                    "javascript",
                    "typescript",
                    "go",
                    "rust",
                    "dockerfile",
                },

                auto_install = true,

                highlight = {
                    enable = true,
                },
                indent = {
                    enable = true,
                },
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-treesitter.configs").setup({
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },
                },
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "VeryLazy",
        config = function()
            require("treesitter-context").setup({
                enable = true, -- Enable this plugin
                max_lines = 10, -- How many lines to show (0 = no limit)
                trim_scope = "outer", -- Which context lines to trim
                mode = "cursor", -- Show context at cursor or top line
                zindex = 20, -- UI z-index
            })
        end,
    },
}
