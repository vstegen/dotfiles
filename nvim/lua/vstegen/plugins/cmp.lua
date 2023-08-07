return {
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
        },
        config = function()
            vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

            local cmp = require "cmp"
            local luasnip = require "luasnip"
            require("luasnip/loaders/from_vscode").lazy_load()

            local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
            end

            local check_backspace = function()
                local col = vim.fn.col "." - 1
                return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
            end

            local function T(str)
                return vim.api.nvim_replace_termcodes(str, true, true, true)
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
                window = {
                    completion = { border = "single" },
                    documentation = { border = "single" },
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, item)
                        local icons = require("vstegen.lsp.icons").kinds
                        if icons[item.kind] then
                            item.kind = icons[item.kind] .. item.kind
                            -- item.menu = ({
                            --     nvim_lsp = "(LSP)",
                            --     nvim_lua = "(Lua)",
                            --     emoji = "(Emoji)",
                            --     path = "(Path)",
                            --     calc = "(Calc)",
                            --     vsnip = "(Snippet)",
                            --     luasnip = "(Snippet)",
                            --     buffer = "(Buffer)",
                            --     treesitter = "(Treesitter)",
                            --     crates = "(Crates)",
                            --     copilot = "(Copilot)",
                            --     ["nvim_lsp_signature_help"] = "(SignatureHelp)",
                            -- })[entry.source.name]
                            -- item.dup = ({
                            --     buffer = 0,
                            --     path = 0,
                            --     nvim_lsp = 1,
                            --     luasnip = 0,
                            -- })[entry.source.name] or 0
                            -- return item

                            return require("tailwindcss-colorizer-cmp").formatter(entry, item)
                        end

                        return item
                    end,
                },
                mapping = {
                    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
                    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
                    ["<C-j>"] = cmp.mapping(
                        cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
                        { "c" }
                    ),
                    ["<C-k>"] = cmp.mapping(
                        cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
                        { "c" }
                    ),
                    ["<C-e>"] = cmp.mapping {
                        i = cmp.mapping.abort(),
                        c = cmp.mapping.close(),
                    },
                    ["<CR>"] = cmp.mapping.confirm { select = true, behavior = cmp.ConfirmBehavior.Insert },

                    -- copilot
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
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
                },

                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "nvim_lua" },
                    { name = "luasnip" },
                    { name = "path" },
                    { name = "treesitter" },
                    { name = "crates" },
                }, {
                    { name = "buffer", keyword_length = 5 },
                }),
                experimental = {
                    ghost_text = false,
                    -- ghost_text = {
                    --     hl_group = "CmpGhostText",
                    -- },
                },
            }

            cmp.setup.filetype("gitcommit", {
                sources = cmp.config.sources({
                    { name = "cmp_git" },
                }, {
                    { name = "buffer" },
                }),
            })

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("vstegen_NvimCmp", { clear = true }),
                pattern = "TelescopePrompt",
                callback = function()
                    cmp.setup.buffer {
                        enable = false,
                        sources = {},
                    }
                end,
            })
        end,
    },
    {
        "roobert/tailwindcss-colorizer-cmp.nvim",
        config = true,
    },
}
