require'nvim-treesitter.configs'.setup {
    ensure_installed = {"c", "css", "cpp", "html", "lua", "javascript", "typescript"},
    sync_install = false,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}
