-- lua_add {{{
require("claudecode").setup({ terminal = { provider = "native" } })
vim.keymap.set("n", "<Leader>ac", "<Cmd>ClaudeCode<CR>", { desc = "Toggle Claude" })
vim.keymap.set("n", "<Leader>ac", "<Cmd>ClaudeCode<CR>", { desc = "Toggle Claude" })
vim.keymap.set("n", "<Leader>af", "<Cmd>ClaudeCodeFocus<CR>", { desc = "Focus Claude" })
vim.keymap.set("n", "<Leader>ar", "<Cmd>ClaudeCode --resume<CR>", { desc = "Resume Claude" })
vim.keymap.set("n", "<Leader>aC", "<Cmd>ClaudeCode --continue<CR>", { desc = "Continue Claude" })
vim.keymap.set("n", "<Leader>ab", "<Cmd>ClaudeCodeAdd %<CR>", { desc = "Add current buffer" })
vim.keymap.set("v", "<Leader>as", "<Cmd>ClaudeCodeSend<CR>", { desc = "Send to Claude" })
-- Diff management
vim.keymap.set("n", "<Leader>aa", "<Cmd>ClaudeCodeDiffAccept<CR>", { desc = "Accept diff" })
vim.keymap.set("n", "<Leader>ad", "<Cmd>ClaudeCodeDiffDeny<CR>", { desc = "Deny diff" })
-- }}}
