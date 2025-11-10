return {
    "lervag/vimtex",
    init = function()
        vim.g.vimtex_compiler_method = "latexmk"
        vim.g.vimtex_compiler_latexmk = {
            build_dir = "build",
            options = {
                "-xelatex",
                "-interaction=nonstopmode",
                "-synctex=1",
            },
        }
        vim.g.vimtex_view_method = "skim"
    end,
}
