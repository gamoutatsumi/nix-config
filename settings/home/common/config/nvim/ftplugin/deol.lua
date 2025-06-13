vim.wo.signcolumn = "no"
vim.wo.number = false
vim.keymap.set("t", "<C-o>", "<cmd>Deol -split=otherwise -toggle -winheight=10<CR>", { silent = true, buffer = true })
