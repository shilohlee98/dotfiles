local function map(mode, lhs, rhs, opts)
    -- set default value if not specify
    if opts.noremap == nil then
        opts.noremap = true
    end
    if opts.silent == nil then
        opts.silent = true
    end

    vim.keymap.set(mode, lhs, rhs, opts)
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map(
    { "n", "x" },
    "<Down>",
    "v:count == 0 ? 'gj' : 'j'",
    { desc = "Down", expr = true, silent = true }
)
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
--
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bd", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
--
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
--
map("v", "<", "<gv", {})
map("v", ">", ">gv", {})
--
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })
--
-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
--
-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
--
-- diagnostic
local diagnostic_goto = function(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        go({ severity = severity })
    end
end

map("n", "<leader>dy", function()
    local line_nr = vim.fn.line(".") - 1
    local diagnostics = vim.diagnostic.get(0, { lnum = line_nr })

    if vim.tbl_isempty(diagnostics) then
        print("ℹ No diagnostics on this line.")
        return
    end

    local messages = vim.tbl_map(function(d)
        return d.message
    end, diagnostics)

    local joined = table.concat(messages, " | ")
    vim.fn.setreg("+", joined)
    print("✔ Yanked " .. #messages .. " diagnostics to clipboard.")
end, { desc = "Yank diagnostics on current line to clipboard" })

map("n", "<leader>ds", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
--
map({ "n", "v" }, "<leader>y", '"+y', { desc = "System Clipboard Yank" })
map("n", "<leader>yy", '"+yy', { desc = "System Clipboard Yank Line" })
--
map({ "n", "v" }, "<leader>p", '"+p', { desc = "System Clipboard Paste" })
--
map("n", "<C-u>", "<C-u>zz", {})
map("n", "<C-d>", "<C-d>zz", {})
--
map("n", "n", "nzzzv", {})
map("n", "N", "Nzzzv", {})

local function copy_and_notify(expr, label)
    local s = vim.fn.expand(expr)
    vim.fn.setreg("+", s)

    local msg = string.format("Copied %s: %s", label, s)
    if type(vim.notify) == "function" then
        vim.notify(msg)
    else
        vim.api.nvim_echo({ { msg, "None" } }, false, {})
    end
end

map("n", "<leader>cp", function()
    copy_and_notify("%:p", "full path")
end, { desc = "Copy full file path" })

map("n", "<leader>cn", function()
    copy_and_notify("%:t", "file name")
end, { desc = "Copy file name" })

map("n", "<leader>cr", function()
    local s = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
    vim.fn.setreg("+", s)
    local msg = string.format("Copied relative path (cwd): %s", s)
    if type(vim.notify) == "function" then
        vim.notify(msg)
    else
        vim.api.nvim_echo({ { msg, "None" } }, false, {})
    end
end, { desc = "Copy relative path (to CWD)" })
