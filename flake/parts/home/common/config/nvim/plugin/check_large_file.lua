local function check_large_file()
    local max_file_size = 500 * 1000 -- 500KB
    local file_path = vim.fn.expand("%")
    if file_path == "" then
        return
    end

    local fsize = vim.fn.getfsize(file_path)
    local line_num = vim.fn.line("$")

    if fsize > max_file_size then
        local choice = vim.fn.input(
            string.format('"%s" is a large file (%s lines, %s bytes). Continue? [y/N]: ', file_path, line_num, fsize)
        )
        if string.lower(choice or "") ~= "y" then
            vim.cmd("bwipeout!")
            return
        else
            vim.cmd("syntax off")
            pcall(vim.cmd, "TSDisable highlight") -- TSDisable が存在する場合のみ実行
        end
    end
end

vim.api.nvim_create_autocmd("BufReadPre", {
    pattern = "*",
    callback = check_large_file,
})
