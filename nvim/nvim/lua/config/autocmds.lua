vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.diagnostic.enable(false, { bufnr = 0 })
        vim.opt_local.spell = false
    end,
})
