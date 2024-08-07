require("general.set")
require("general.remap")
require("general.lazy-setup")

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank-group', { clear = true }),
    callback = function()
        vim.highlight.on_yank({
            timeout = 40,
        })
    end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    desc = 'Remove trailing whitespace before writing buffer to a file',
    group = vim.api.nvim_create_augroup('buf-pre-write-trim-group', { clear = true }),
    command = [[%s/\s\+$//e]],
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.zig_recommended_style = 0
