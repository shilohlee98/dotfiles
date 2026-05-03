return {
    {
        "aktersnurra/no-clown-fiesta.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            local black = "#000000"

            local function set_bg(group)
                local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
                if not ok then
                    hl = {}
                end

                hl.bg = black
                vim.api.nvim_set_hl(0, group, hl)
            end

            require("no-clown-fiesta").load({
                theme = "dark",
            })

            for _, group in ipairs({
                "Normal",
                "NormalNC",
                "NormalFloat",
                "FloatBorder",
                "FloatTitle",
                "SignColumn",
                "FoldColumn",
                "LineNr",
                "CursorLine",
                "CursorLineNr",
                "ColorColumn",
                "EndOfBuffer",
                "WinSeparator",
                "StatusLine",
                "StatusLineNC",
                "TabLine",
                "TabLineFill",
                "TabLineSel",
                "Pmenu",
                "PmenuSbar",
                "LazyNormal",
                "MasonNormal",
                "WhichKeyFloat",
                "SnacksPicker",
                "SnacksPickerBorder",
                "SnacksPickerInput",
                "SnacksPickerList",
                "SnacksPickerPreview",
                "SnacksPickerTitle",
                "TreesitterContext",
            }) do
                set_bg(group)
            end

            -- Snacks picker has no integration in no-clown-fiesta, so its
            -- match/path/row groups fall back to Special/NonText/etc. which
            -- are nearly indistinguishable from the foreground here.
            local picker_hl = {
                SnacksPickerMatch = { fg = "#E1A700", bold = true },
                SnacksPickerDir = { fg = "#727272" },
                SnacksPickerPathHidden = { fg = "#727272" },
                SnacksPickerFile = { fg = "#E1E1E1" },
                SnacksPickerRow = { fg = "#FFA557" },
                SnacksPickerCol = { fg = "#FFA557" },
                SnacksPickerIdx = { fg = "#727272" },
                SnacksPickerLabel = { fg = "#BAD7FF", bold = true },
                SnacksPickerSelected = { fg = "#E1A700", bold = true },
                SnacksPickerSpecial = { fg = "#BAD7FF" },
                SnacksPickerTotals = { fg = "#727272", italic = true },
            }
            for group, val in pairs(picker_hl) do
                vim.api.nvim_set_hl(0, group, val)
            end
        end,
    },
}
