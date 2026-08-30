return {
    {
        "aktersnurra/no-clown-fiesta.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            local black = "#000000"
            local colors = {
                bg_alt = "#202020",
                fg = "#E1E1E1",
                fg_alt = "#D0D0D0",
                gray = "#727272",
                selection = "#373737",
                red = "#B46958",
                green = "#90A959",
                yellow = "#F4BF75",
                blue = "#BAD7FF",
                purple = "#AA749F",
                magenta = "#AA759F",
                cyan = "#88AFA2",
            }

            local function set_bg(group)
                local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
                if not ok then
                    hl = {}
                end

                hl.bg = black
                vim.api.nvim_set_hl(0, group, hl)
            end

            local function set_hl(groups)
                for group, val in pairs(groups) do
                    vim.api.nvim_set_hl(0, group, val)
                end
            end

            require("no-clown-fiesta").load({
                theme = "dark",
            })

            for index, color in ipairs({
                colors.bg_alt,
                colors.red,
                colors.green,
                colors.yellow,
                colors.blue,
                colors.purple,
                colors.cyan,
                colors.fg_alt,
                colors.gray,
                colors.red,
                colors.green,
                colors.yellow,
                colors.blue,
                colors.magenta,
                colors.cyan,
                colors.fg,
            }) do
                vim.g["terminal_color_" .. (index - 1)] = color
            end

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

            set_hl({
                Normal = { fg = colors.fg, bg = black },
                NormalNC = { fg = colors.fg, bg = black },
                NormalFloat = { fg = colors.fg, bg = black },
                FloatBorder = { fg = colors.gray, bg = black },
                FloatTitle = { fg = colors.blue, bg = black, bold = true },
                LspHoverNormal = { fg = colors.fg, bg = colors.bg_alt },
                LspHoverBorder = { fg = colors.blue, bg = colors.bg_alt },
                Cursor = { fg = black, bg = colors.fg_alt },
                CursorLine = { bg = black },
                CursorLineNr = { fg = colors.yellow, bg = black, bold = true },
                ColorColumn = { bg = black },
                Visual = { bg = colors.selection },
                Search = { fg = black, bg = colors.yellow },
                IncSearch = { fg = black, bg = colors.yellow },
                LineNr = { fg = colors.gray, bg = black },
                Comment = { fg = colors.gray, italic = true },
                String = { fg = colors.blue },
                Character = { fg = colors.blue },
                Function = { fg = colors.cyan },
                Keyword = { fg = colors.blue },
                Statement = { fg = colors.blue },
                Type = { fg = colors.fg },
                Constant = { fg = colors.fg },
                Identifier = { fg = colors.fg },
                Special = { fg = colors.cyan },
                ErrorMsg = { fg = colors.red, bg = black, bold = true },
                WarningMsg = { fg = colors.yellow, bg = black },
                DiagnosticError = { fg = colors.red },
                DiagnosticWarn = { fg = colors.yellow },
                DiagnosticInfo = { fg = colors.blue },
                DiagnosticHint = { fg = colors.cyan },
                DiagnosticVirtualTextError = { fg = colors.red },
                DiagnosticVirtualTextWarn = { fg = colors.yellow },
                DiagnosticVirtualTextInfo = { fg = colors.blue },
                DiagnosticVirtualTextHint = { fg = colors.cyan },
                GitSignsAdd = { fg = colors.green },
                GitSignsChange = { fg = colors.blue },
                GitSignsDelete = { fg = colors.red },
                GitSignsCurrentLineBlame = { fg = colors.gray },
                DiffAdd = { bg = "#142B22" },
                DiffChange = { bg = "#172033" },
                DiffText = { bg = "#264F78", bold = true },
                DiffDelete = { bg = "#321C20" },
                GitDiffOld = { bg = "#52242B" },
                GitDiffOldText = { bg = "#8B3A44", bold = true },
                GitDiffNew = { bg = "#1D4930" },
                GitDiffNewText = { bg = "#2E7047", bold = true },
                GitDiffFiller = { bg = black },
                Pmenu = { fg = colors.fg, bg = black },
                PmenuSel = { fg = colors.fg, bg = colors.selection },
                PmenuSbar = { bg = black },
                PmenuThumb = { bg = colors.gray },
                StatusLine = { fg = colors.fg_alt, bg = black },
                StatusLineNC = { fg = colors.gray, bg = black },
                WinSeparator = { fg = colors.gray, bg = black },
            })

            -- Snacks picker has no integration in no-clown-fiesta, so its
            -- match/path/row groups fall back to Special/NonText/etc. which
            -- are nearly indistinguishable from the foreground here.
            local picker_hl = {
                SnacksPickerMatch = { fg = colors.yellow, bold = true },
                SnacksPickerDir = { fg = colors.gray },
                SnacksPickerPathHidden = { fg = colors.gray },
                SnacksPickerFile = { fg = colors.fg },
                SnacksPickerRow = { fg = colors.yellow },
                SnacksPickerCol = { fg = colors.yellow },
                SnacksPickerIdx = { fg = colors.gray },
                SnacksPickerLabel = { fg = colors.blue, bold = true },
                SnacksPickerSelected = { fg = colors.yellow, bold = true },
                SnacksPickerSpecial = { fg = colors.blue },
                SnacksPickerTotals = { fg = colors.gray, italic = true },
            }
            set_hl(picker_hl)

            local function set_diff_winhighlight(winid, mappings)
                local replaced = {}
                for _, mapping in ipairs(mappings) do
                    replaced[mapping[1]] = true
                end

                local entries = {}
                for _, entry in ipairs(vim.split(vim.wo[winid].winhighlight, ",", {
                    trimempty = true,
                })) do
                    local source = entry:match("^([^:]+):")
                    if not replaced[source] then
                        table.insert(entries, entry)
                    end
                end

                for _, mapping in ipairs(mappings) do
                    table.insert(entries, mapping[1] .. ":" .. mapping[2])
                end
                vim.wo[winid].winhighlight = table.concat(entries, ",")
            end

            local function apply_two_way_diff_settings()
                if vim.fn.argc() ~= 2 then
                    return
                end

                local diff_windows = vim.tbl_filter(function(winid)
                    return vim.wo[winid].diff
                end, vim.api.nvim_tabpage_list_wins(0))

                if #diff_windows ~= 2 then
                    return
                end

                for _, winid in ipairs(diff_windows) do
                    vim.wo[winid].wrap = true
                end

                table.sort(diff_windows, function(left, right)
                    local left_pos = vim.api.nvim_win_get_position(left)
                    local right_pos = vim.api.nvim_win_get_position(right)
                    if left_pos[2] ~= right_pos[2] then
                        return left_pos[2] < right_pos[2]
                    end
                    return left_pos[1] < right_pos[1]
                end)

                set_diff_winhighlight(diff_windows[1], {
                    { "DiffAdd", "GitDiffOld" },
                    { "DiffChange", "GitDiffOld" },
                    { "DiffText", "GitDiffOldText" },
                    { "DiffDelete", "GitDiffFiller" },
                })
                set_diff_winhighlight(diff_windows[2], {
                    { "DiffAdd", "GitDiffNew" },
                    { "DiffChange", "GitDiffNew" },
                    { "DiffText", "GitDiffNewText" },
                    { "DiffDelete", "GitDiffFiller" },
                })
            end

            local diff_highlight_group = vim.api.nvim_create_augroup(
                "GitDifftoolHighlights",
                { clear = true }
            )
            vim.api.nvim_create_autocmd("VimEnter", {
                group = diff_highlight_group,
                callback = apply_two_way_diff_settings,
            })
        end,
    },
}
