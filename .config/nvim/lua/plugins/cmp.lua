return {
    {
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets' },

        version = '1.*',

        opts = {
            keymap = { preset = 'default' },

            appearance = {
                nerd_font_variant = 'mono'
            },

            -- completion = {
            --     documentation = {
            --         auto_show = true,
            --         auto_show_delay_ms = 50
            --     }
            -- },

            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },

            signature = { enabled = true },
            fuzzy = { implementation = "prefer_rust_with_warning" }
        },
    }
}
