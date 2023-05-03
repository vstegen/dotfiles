local ok, npairs = pcall(require, "nvim-autopairs")
if not ok then
    return
end

local Rule = require "nvim-autopairs.rule"
local cond = require "nvim-autopairs.conds"

npairs.setup {
    check_ts = true,
    enable_check_bracket_line = false,
    map_bs = false,
    ts_config = {
        lua = { "string" }, -- it will not add a pair on that treesitter node
        javascript = { "template_string" },
        java = false, -- don't check treesitter on java
    },
}

local ts_conds = require "nvim-autopairs.ts-conds"

-- press % => %% only while inside a comment or string
npairs.add_rules {
    Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node { "string", "comment" }),
    Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node { "function" }),
}

npairs.add_rule(Rule("$$", "$$", "tex"))

-- you can use some built-in conditions

npairs.add_rules(
    {
        Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
                cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
    },
    -- disable for .vim files, but it work for another filetypes
    Rule("a", "a", "-vim")
)

npairs.add_rules {
    Rule("$$", "$$", "tex"):with_pair(function(opts)
        if opts.line == "aa $$" then
            -- don't add pair on that line
            return false
        end
    end),
}

-- you can use regex
-- press u1234 => u1234number
npairs.add_rules {
    Rule("u%d%d%d%d$", "number", "lua"):use_regex(true),
}

-- press x1234 => x12341234
npairs.add_rules {
    Rule("x%d%d%d%d$", "number", "lua"):use_regex(true):replace_endpair(function(opts)
        -- print(vim.inspect(opts))
        return opts.prev_char:sub(#opts.prev_char - 3, #opts.prev_char)
    end),
}

-- you can do anything with regex +special key
-- example press tab to uppercase text:
-- press b1234s<tab> => B1234S1234S

npairs.add_rules {
    Rule("b%d%d%d%d%w$", "", "vim"):use_regex(true, "<tab>"):replace_endpair(function(opts)
        return opts.prev_char:sub(#opts.prev_char - 4, #opts.prev_char) .. "<esc>viwU"
    end),
}

-- you can exclude filetypes
npairs.add_rule(Rule("$$", "$$"):with_pair(cond.not_filetypes { "lua" }))
--- check ./lua/nvim-autopairs/rules/basic.lua

local cmp_autopairs = require "nvim-autopairs.completion.cmp"
local cmp_ok, cmp = pcall(require, "cmp")
if cmp_ok then
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end
