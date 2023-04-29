local ok, cmp = pcall(require, "cmp")
if not ok then
    return
end

local luasnip_ok, luasnip = pcall(require, "luasnip")
if not luasnip_ok then
    return
end

require("luasnip/loaders/from_vscode").lazy_load()

local icons = {
    Class = " ",
    Color = " ",
    Constant = "ﲀ ",
    Constructor = " ",
    Enum = "練",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = "",
    Folder = " ",
    Function = " ",
    Interface = "ﰮ ",
    Keyword = " ",
    Method = " ",
    Module = " ",
    Operator = "",
    Property = " ",
    Reference = " ",
    Snippet = " ",
    Struct = " ",
    Text = " ",
    TypeParameter = " ",
    Unit = "塞",
    Value = " ",
    Variable = " ",
}

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

local check_backspace = function()
    local col = vim.fn.col "." - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

local function T(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function feedkeys(key, mode)
    vim.fn.feedkeys(T(key), mode)
end

local is_emmet_active = function()
    local clients = vim.lsp.buf_get_clients()

    for _, client in pairs(clients) do
        if client.name == "emmet_ls" then
            return true
        end
    end
    return false
end

cmp.setup {
    enabled = true,
    preselect = cmp.PreselectMode.None,
    completion = { completeopt = "menu,menuone,noinsert,noselect" },
    -- view = {
    --     entries = "native",
    -- },
    window = {
        completion = { border = "single" },
        documentation = { border = "single" },
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            vim_item.kind = icons[vim_item.kind]
            vim_item.menu = ({
                nvim_lsp = "(LSP)",
                nvim_lua = "(Lua)",
                emoji = "(Emoji)",
                path = "(Path)",
                calc = "(Calc)",
                vsnip = "(Snippet)",
                luasnip = "(Snippet)",
                buffer = "(Buffer)",
                treesitter = "(Treesitter)",
                crates = "(Crates)",
                ["nvim_lsp_signature_help"] = "(SignatureHelp)",
            })[entry.source.name]
            vim_item.dup = ({
                buffer = 0,
                path = 0,
                nvim_lsp = 1,
                luasnip = 0,
            })[entry.source.name] or 0
            return vim_item
        end,
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = {
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "c" }),
        ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "c" }),
        ["<C-e>"] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        },
        ["<CR>"] = cmp.mapping.confirm { select = true, behavior = cmp.ConfirmBehavior.Insert },

        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            elseif check_backspace() then
                vim.fn.feedkeys(T "<Tab>", "n")
            elseif is_emmet_active() then
                return vim.fn["cmp#complete"]()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<C-Space>"] = function(fallback)
            if cmp.visible() then
                cmp.close()
            elseif cmp.visible() ~= 1 then
                cmp.complete()
            else
                fallback()
            end
        end,
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "path" },
        { name = "buffer", keyword_length = 5 },
        { name = "luasnip" },
        { name = "calc" },
        { name = "emoji" },
        { name = "treesitter" },
        { name = "crates" },
    }, {
        { name = "buffer" },
    }),
    experimental = {
        ghost_text = true,
    },
}

cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
        { name = "cmp_git" },
    }, {
        { name = "buffer" },
    }),
})

local define_autocmd = require("vstegen.utils").define_autocmd

define_autocmd {
    "FileType",
    {
        group = "NvimCmp",
        pattern = "TelescopePrompt",
        callback = function()
            cmp.setup.buffer {
                enable = false,
                sources = {},
            }
        end,
    },
}
