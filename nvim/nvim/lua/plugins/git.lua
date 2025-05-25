return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("gitsigns").setup({
            on_attach = function(bufnr)
                local gitsigns = require("gitsigns")

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map("n", "]c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gitsigns.nav_hunk("next")
                    end
                end)

                map("n", "[c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gitsigns.nav_hunk("prev")
                    end
                end)

                -- Actions
                map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage Hunk" })
                map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset Hunk" })

                map("v", "<leader>hs", function()
                    gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end)

                map("v", "<leader>hr", function()
                    gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end)

                map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage Buffer" })
                map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset Buffer" })
                map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Previe Hunk" })
                map(
                    "n",
                    "<leader>hi",
                    gitsigns.preview_hunk_inline,
                    { desc = "Hunk Preview Inline" }
                )

                map("n", "<leader>hb", function()
                    gitsigns.blame_line({ full = true })
                end, { desc = "Blane Line" })

                map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff This" })

                -- Toggles
                map(
                    "n",
                    "<leader>tb",
                    gitsigns.toggle_current_line_blame,
                    { desc = "Toggle Current Line Blame" }
                )
                map(
                    "n",
                    "<leader>tw",
                    gitsigns.toggle_word_diff,
                    { desc = "Toggle Current Word Diff" }
                )

                -- Text object
                map({ "o", "x" }, "ih", gitsigns.select_hunk)
            end,
        })
    end,
}
