local status_ok, rspine = pcall(require, "rose-pine")
if not status_ok then
    return
end
rspine.setup({
    disable_background = true
})

function ColorMyPencils(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils()
