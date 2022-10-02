local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

require'nvim-treesitter.configs'.setup {
    ensure_installed = "all",
    sync_install = false,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

