local map = vim.keymap.set
local del = vim.keymap.del

-- Normal mode mappings
map("n", "x", '"_x')
map("n", "j", "gj")
map("n", "k", "gk")

map("n", "i", function()
    if vim.fn.len(vim.fn.getline(".")) > 0 then
        return "i"
    else
        return "cc"
    end
end, { expr = true })

map("n", "A", function()
    if vim.fn.len(vim.fn.getline(".")) > 0 then
        return "A"
    else
        return "cc"
    end
end, { expr = true })

map("n", "0", function()
    local current_line = vim.fn.getline(".")
    local before_cursor = current_line:sub(1, vim.fn.col(".") - 1)
    if before_cursor:match("^%s+$") then
        return "0"
    else
        return "^"
    end
end, { expr = true })

map("n", "<Leader>w", "<Cmd>update<CR>")
map("n", "<Leader>q", "<Cmd>confirm quit<CR>")
map("n", "Q", "<Nop>")

-- Unmap
del("n", "gra")
del("n", "gri")
del("x", "gra")
