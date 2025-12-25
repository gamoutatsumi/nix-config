vim.api.nvim_create_user_command("Arto", function()
    local path = vim.fn.expand("%:p")
    vim.cmd("!open -a ~/Applications/Home Manager Apps/Arto.app " .. path)
end, {})
