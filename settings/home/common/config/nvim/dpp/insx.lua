-- lua_add {{{
local auto_pair = require("insx.recipe.auto_pair")
local delete_pair = require("insx.recipe.delete_pair")
local fast_break = require("insx.recipe.fast_break")
local insx = require("insx")
local jump_next = require("insx.recipe.jump_next")
local pair_spacing = require("insx.recipe.pair_spacing")
local esc = insx.helper.regex.esc
insx.add(
    "(",
    auto_pair({
        open = "(",
        close = ")",
    })
)
insx.add(
    "<BS>",
    delete_pair({
        open_pat = esc("("),
        close_pat = esc(")"),
    })
)
insx.add(
    "<CR>",
    fast_break({
        open_pat = esc("("),
        close_pat = esc(")"),
        arguments = true,
        html_attrs = true,
        html_tags = true,
    })
)
insx.add(
    ")",
    jump_next({
        jump_pat = {
            [[\%#]] .. esc(")") .. [[\zs]],
        },
    })
)
require("insx").add(
    "<Space>",
    pair_spacing.increase({
        open_pat = esc("("),
        close_pat = esc(")"),
    })
)
insx.add(
    "{",
    auto_pair({
        open = "{",
        close = "}",
    })
)
insx.add(
    "<BS>",
    delete_pair({
        open_pat = esc("{"),
        close_pat = esc("}"),
    })
)
insx.add(
    "<CR>",
    fast_break({
        open_pat = esc("{"),
        close_pat = esc("}"),
        arguments = true,
        html_attrs = true,
        html_tags = true,
    })
)
insx.add(
    "}",
    jump_next({
        jump_pat = {
            [[\%#]] .. esc("}") .. [[\zs]],
        },
    })
)
require("insx").add(
    "<Space>",
    pair_spacing.increase({
        open_pat = esc("{"),
        close_pat = esc("}"),
    })
)
insx.add(
    "[",
    auto_pair({
        open = "[",
        close = "]",
    })
)
insx.add(
    "<BS>",
    delete_pair({
        open_pat = esc("["),
        close_pat = esc("]"),
    })
)
insx.add(
    "<CR>",
    fast_break({
        open_pat = esc("["),
        close_pat = esc("]"),
        arguments = true,
        html_attrs = true,
        html_tags = true,
    })
)
insx.add(
    "]",
    jump_next({
        jump_pat = {
            [[\%#]] .. esc("]") .. [[\zs]],
        },
    })
)
require("insx").add(
    "<Space>",
    pair_spacing.increase({
        open_pat = esc("["),
        close_pat = esc("]"),
    })
)
insx.add(
    "<",
    auto_pair({
        open = "<",
        close = ">",
    })
)
insx.add(
    "<BS>",
    delete_pair({
        open_pat = esc("<"),
        close_pat = esc(">"),
    })
)
insx.add(
    "'",
    auto_pair.strings({
        open = [[']],
        close = [[']],
    })
)
insx.add(
    "<BS>",
    delete_pair.strings({
        open_pat = esc([[']]),
        close_pat = esc([[']]),
    })
)
insx.add(
    [[']],
    jump_next({
        jump_pat = {
            [[\%#]] .. esc([[']]) .. [[\zs]],
        },
    })
)
insx.add(
    [["]],
    auto_pair.strings({
        open = [["]],
        close = [["]],
    })
)
insx.add(
    "<BS>",
    delete_pair.strings({
        open_pat = esc([["]]),
        close_pat = esc([["]]),
    })
)
insx.add(
    [["]],
    jump_next({
        jump_pat = {
            [[\%#]] .. esc([["]]) .. [[\zs]],
        },
    })
)
vim.keymap.set("i", "<CR>", function()
    return vim.fn["pum#visible"]() and "<Cmd>call pum#map#confirm()<CR>"
        or [[<Cmd>call luaeval("require('insx.kit.Vim.Keymap').send(require('insx').expand('<LT>CR>'))")<CR>]]
end, { expr = true, desc = "insx and pum.vim" })
--}}}
