-- lua_add {{{
local auto_pair = require("insx.recipe.auto_pair")
local delete_pair = require("insx.recipe.delete_pair")
local insx = require("insx")
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
--}}}
