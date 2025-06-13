vim.loader.enable()

-- syntax off -- もし本当に無効化したい場合。通常はカラースキームなどで管理されます。
-- vim.cmd("syntax off")
vim.env.BASE_DIR = vim.fn.stdpath("config")
vim.g.mapleader = " "

-- Core settings
require("core.vars")
require("core.opts")
require("core.keys")
require("core.dpp").setup({})

-- NVUI specific settings (if used)
-- pcall(require, 'core.nvui')

vim.cmd("filetype plugin indent on")

vim.api.nvim_create_user_command("ToggleNum", function()
    vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, {})

vim.api.nvim_create_user_command("InlayHintToggle", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(0), { bufnr = 0 })
end, {})
