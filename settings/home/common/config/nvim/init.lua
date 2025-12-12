vim.loader.enable()

-- syntax off -- もし本当に無効化したい場合。通常はカラースキームなどで管理されます。
-- vim.cmd("syntax off")
vim.g.mapleader = " "

-- Core settings
require("core.vars")
require("core.opts")
require("core.keys")
require("core.dpp").setup()
require("core.commands")
require("core.treesitter")

-- NVUI specific settings (if used)
-- pcall(require, 'core.nvui')

vim.cmd("filetype plugin indent on")

vim.api.nvim_create_user_command("ToggleNum", function()
    vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, {})

vim.api.nvim_create_user_command("InlayHintToggle", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, {})
