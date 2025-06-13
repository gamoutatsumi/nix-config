local function open_junk_file()
    local home = vim.env.HOME
    local date_path = vim.fn.strftime("/%Y/%m/%d")
    local junk_dir_base = home .. "/Repositories/github.com/gamoutatsumi/my-orgs/junk"
    local junk_dir = junk_dir_base .. date_path

    if vim.fn.isdirectory(junk_dir) == 0 then
        vim.fn.mkdir(junk_dir, "p")
    end

    local default_filename_stem = vim.fn.strftime("/%H%M%S.")
    local filename = vim.fn.input("Junk Code: ", junk_dir .. default_filename_stem)
    if filename ~= "" then
        vim.cmd("edit " .. vim.fn.fnameescape(filename))
    end
end

vim.api.nvim_create_user_command("JunkFile", open_junk_file, { nargs = 0 })
