-- This file can be loaded by calling `lua require('plugins')` from your init.vim
local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
    print("Installing packer close and reopen Neovim...")
    vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerSync
augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "rounded" })
        end,
    },
})
-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)

    use 'wbthomason/packer.nvim'          -- Packer can manage itself

    use({ -- Port of VSCode's Tokio Night theme
    "folke/tokyonight.nvim",
    config = function()
        vim.g.tokyonight_style = "night" -- Possible values: storm, night and day
    end,
    })

    use({ -- Install and configure tree-sitter languages
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    })

    use {'nvim-treesitter/nvim-treesitter-context'}

    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    use({ -- Configure LSP client and Use an LSP server installer.
        "neovim/nvim-lspconfig",
        requires = {
            "williamboman/mason.nvim",         -- Installs servers within neovim
            "williamboman/mason-lspconfig.nvim",
            "onsails/lspkind-nvim",            -- adds vscode-like pictograms to neovim built-in lsp
        },
  -- config = function()
    --   require("config.lsp")
  -- end,
    })

    use({
        "hrsh7th/cmp-nvim-lsp", 
        "saadparwaiz1/cmp_luasnip", 
        "hrsh7th/cmp-path", 
        "hrsh7th/cmp-buffer", 
        "hrsh7th/nvim-cmp", 
        "L3MON4D3/LuaSnip", 
    })

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use { 'windwp/nvim-autopairs' }
    use {"rafamadriz/friendly-snippets"}
    use {'jose-elias-alvarez/null-ls.nvim'}

end)
