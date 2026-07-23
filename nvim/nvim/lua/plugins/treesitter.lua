local parser_install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "treesitter-parsers")
local markdown_lang_aliases = {
    ex = "elixir",
    pl = "perl",
    sh = "bash",
    ts = "typescript",
    uxn = "uxntal",
}

return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = "VeryLazy",
        build = ":TSUpdate",
        init = function()
            vim.opt.runtimepath:append(parser_install_dir)
        end,
        config = function()
            require("nvim-treesitter.configs").setup({
                parser_install_dir = parser_install_dir,
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

            -- nvim-treesitter's legacy branch expects a single TSNode here,
            -- while Neovim 0.12 passes a list of captured nodes.
            if vim.fn.has("nvim-0.12") == 1 then
                vim.treesitter.query.add_directive(
                    "set-lang-from-info-string!",
                    function(match, _, bufnr, pred, metadata)
                        local node = match[pred[2]]
                        node = type(node) == "table" and node[1] or node
                        if not node then
                            return
                        end

                        local alias = vim.treesitter.get_node_text(node, bufnr):lower()
                        metadata["injection.language"] = vim.filetype.match({
                            filename = "a." .. alias,
                        }) or markdown_lang_aliases[alias] or alias
                    end,
                    { force = true, all = false }
                )
            end
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = "VeryLazy",
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
