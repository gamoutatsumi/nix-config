-- lua_add {{{
local hop = require("hop")
hop.setup()
local directions = require("hop.hint").HintDirection
local opts = { remap = true }
vim.keymap.set({ "v", "n" }, "gff", function()
    hop.hint_words({})
end, opts)
vim.keymap.set({ "v", "n", "o" }, "f", function()
    hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, opts)
vim.keymap.set({ "v", "n", "o" }, "F", function()
    hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, opts)
vim.keymap.set({ "v", "n", "o" }, "t", function()
    hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, opts)
vim.keymap.set({ "v", "n", "o" }, "T", function()
    hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, opts)
-- }}}
