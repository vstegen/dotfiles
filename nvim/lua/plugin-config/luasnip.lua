local ok, luasnip = pcall(require, "luasnip")
if not ok then
  return
end

require("luasnip.loaders.from_lua").load { paths = vim.fn.expand "~/.config/nvim/snippets/" }

luasnip.config.setup {
  history = true,
  update_events = "TextChanged,TextChangedI",
  enable_autosnippets = true,
  region_check_events = "CursorMoved", -- "CursorHold", "InsertEnter"
  delete_check_events = "TextChanged",
  ext_opts = {
    [require("luasnip.util.types").choiceNode] = {
      active = {
        virt_text = {
          {
            "", --[[, "some color"]] 
          },
        },
      },
    },
  },
}
