return {
    "neovim/nvim-lspconfig",
    dependencies = {
        {
            'mason-org/mason.nvim',
            dependencies = { 'mason-org/mason-lspconfig.nvim' },
        },
        'saghen/blink.cmp',
        { 'folke/lazydev.nvim', ft = 'lua', opts = {} },
        { 'j-hui/fidget.nvim',  opts = {} },
    },
    config = function()
        --  This function gets run when an LSP connects to a particular buffer.
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),

            callback = function(event)
                local nmap = function(keys, func, desc)
                    if desc then
                        desc = 'LSP: ' .. desc
                    end

                    vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
                end

                nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

                nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
                nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
                nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
                nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
                nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

                nmap('H', vim.lsp.buf.signature_help, 'Signature Documentation')
            end
        })

        -- Diagnostic keymaps
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, { desc = '[V]im [D]iagnostic' })
        vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

        require('mason').setup()
        require("mason-lspconfig").setup {
            ensure_installed = { "lua_ls", "clangd" },
            automatic_enable = true,
        }

        vim.lsp.config.clangd = {
            cmd = {
                vim.fn.stdpath("data") .. "/mason/bin/clangd", -- Correct path using stdpath
                "--clang-tidy",
                "--background-index",
                "--header-insertion=never",
            },
            root_markers = { '.clangd', 'compile_commands.json' },
            filetypes = { 'c', 'cpp' },
        }
    end
}
