return {
    {
        "github/copilot.vim",
        config = function()
            vim.cmd('imap <silent><script><expr> <c-j> copilot#accept("\\<cr>")')
            vim.cmd("imap <c-l> <plug>(copilot-accept-word)")
            vim.cmd("imap <c-k> <plug>(copilot-dismiss)")
            vim.g.copilot_no_tab_map = true
        end,
    },
    {},
}
