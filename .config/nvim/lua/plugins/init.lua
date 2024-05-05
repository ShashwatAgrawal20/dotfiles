return {
    "github/copilot.vim",
    { 'numToStr/Comment.nvim',                   opts = {} },
    { 'nvim-treesitter/nvim-treesitter-context', opts = {} },
    {
        'nvim-lualine/lualine.nvim',
        opts = {},
        dependencies = { 'kyazdani42/nvim-web-devicons', opt = true }
    },
}
