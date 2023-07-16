local status_ok, todo = pcall(require, "todo-comments")
if not status_ok then
    return
end

--[[
Keywords:
FIX FIXME BUG FIXIT ISSUE
TODO
HACK
WARN WARNING XXX
PERF OPTIM PERFORMANCE OPTIMIZE
NOTE INFO
TEST TESTING PASSED FAILED
]]
-- NOTE:
-- FIX:
-- PERF:
-- TODO:
-- HACK:
todo.setup {
    highlight = {
        keyword = "bg", -- "fg", "bg", "wide", or empty
        pattern = [[.*<(KEYWORDS)(\(.*\))?\s*:]],
    },
    -- list of named colors
    -- a list of hex colors or highlight groups
    -- will use the first valid one
    colors = {
        error = { O.palette.red, "DiagnosticError", "ErrorMsg", "#DC2626" },
        warning = { O.palette.yellow, "DiagnosticWarn", "WarningMsg", "#FBBF24" },
        info = { O.palette.blue, "DiagnosticInfo", "#2563EB" },
        hint = { O.palette.green, "DiagnosticHint", "#10B981" },
        default = { O.palette.pink, O.palette.purple, "Identifier", "#7C3AED" },
    },
    search = {
        pattern = [[\b(KEYWORDS)(\(.*\))?:]], -- ripgrep regex
    },
}
