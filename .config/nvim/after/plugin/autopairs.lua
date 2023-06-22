local status_ok, npairs = pcall(require, "nvim-autopairs")
if not status_ok then
    return
end
local status_ok, Rule = pcall(require, "nvim-autopairs.rule")
if not status_ok then
    return
end

npairs.setup({
    check_ts = true,
    ts_config = {
        lua = { 'string' }, -- it will not add a pair on that treesitter node
        javascript = { 'template_string' },
        java = false,     -- don't check treesitter on java
    }
})

local status_ok, ts_conds = pcall(require, 'nvim-autopairs.ts-conds')
if not status_ok then
    return
end

-- press % => %% only while inside a comment or string
npairs.add_rules({
    Rule("%", "%", "lua")
        :with_pair(ts_conds.is_ts_node({ 'string', 'comment' })),
    Rule("$", "$", "lua")
        :with_pair(ts_conds.is_not_ts_node({ 'function' }))
})
