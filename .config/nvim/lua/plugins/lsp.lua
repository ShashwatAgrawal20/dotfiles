return {
    "neovim/nvim-lspconfig",
    dependencies = {
        {
            'williamboman/mason.nvim',
            dependencies = { 'williamboman/mason-lspconfig.nvim' },
        },
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
        require('mason-lspconfig').setup()

        -- Enable the following language servers
        --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
        --
        --  Add any additional override configuration in the following tables. They will be passed to
        --  the `settings` field of the server config. You must look up that documentation yourself.
        --
        --  If you want to override the default filetypes that your language server will attach to you can
        --  define the property 'filetypes' to the map in question.
        local servers = {
            clangd = {
                cmd = {
                    "clangd",                   -- Ensure the full path to clangd is specified
                    "--background-index",       -- Enable background indexing
                    "--header-insertion=never", -- Disable header insertion
                },
            },
            -- gopls = {},
            -- pyright = {},
            -- rust_analyzer = {},
            -- tsserver = {},
            -- html = { filetypes = { 'html', 'twig', 'hbs'} },

            lua_ls = {
                Lua = {
                    workspace = { checkThirdParty = false },
                    telemetry = { enable = false },
                },
            },
        }

        -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

        -- Ensure the servers above are installed
        local mason_lspconfig = require 'mason-lspconfig'

        mason_lspconfig.setup {
            ensure_installed = vim.tbl_keys(servers),
        }

        -- require('lspconfig').clangd.setup({})

        require("mason-lspconfig").setup_handlers {
            function(server)
                local config = vim.tbl_deep_extend("force", {
                    capabilities = capabilities,
                    -- on_attach = on_attach,
                }, servers[server] or {})

                require("lspconfig")[server].setup(config)
            end
        }
    end
}
