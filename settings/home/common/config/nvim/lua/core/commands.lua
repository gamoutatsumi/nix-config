vim.api.nvim_create_user_command("Arto", function()
    local path = vim.fn.expand("%:p")
    vim.cmd("!open -a /Applications/Arto.app " .. path)
end, {})
