vim.g.mapleader = " "

local options = {
    clipboard = "unnamedplus",
    tabstop = 4, 
    number = true,
    relativenumber = true,
    softtabstop = 4, 
    shiftwidth = 4, 
    expandtab = true, 
    smartindent = true, 
    wrap = true, 
    swapfile = false,
    backup = false, 
    hlsearch = true, 
    incsearch = true, 
    scrolloff = 8, 
    signcolumn = "yes", 
    cmdheight = 1, 
    updatetime = 100, 
    colorcolumn = "80", 
}

vim.opt.shortmess:append "c"

for k, v in pairs(options) do
    vim.opt[k] = v
end
