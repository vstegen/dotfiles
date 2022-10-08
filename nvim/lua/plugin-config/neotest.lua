local ok, neotest = pcall(require, "neotest")
if not ok then
  return
end

neotest.setup {
  adapters = {
    -- https://github.com/vim-test/vim-test
    require "neotest-vim-test" {
      ignore_filetypes = {
        "python",
        -- "rust",
        "go",
        "javascript",
        "typescript",
      },
    },
    -- can only run individual tests or files
    -- assumes tests are in main.rs, lib.rs, mod.rs or in tests/
    -- TODO: enable once neovim 0.8 is stable
    -- require "neotest-rust",
    require "neotest-go" {
      experimental = {
        test_table = true,
      },
    },
    require "neotest-python" {
      dap = { justMyCode = false },
      -- Command line arguments for runner
      -- Can also be a function to return dynamic values
      args = { "--log-level", "DEBUG" },
      runner = "pytest", -- alternative 'python-unittest', function is also possible
      is_test_file = function(file_path)
        if string.find(file_path, "_test.py") ~= nil then
          return true
        end

        return false
      end,
    },
    -- NOTE: might want to diasble this for js/ts tested with mocha
    require "neotest-jest" {
      jestCommand = "npm test --",
      jestConfigFile = "custom.jest.config.ts",
      env = { CI = true },
      cwd = function(path)
        return vim.fn.getcwd()
      end,
    },
  },
  consumers = {},
  default_strategy = "integrated",
  diagnostic = {
    enabled = true,
  },
  discovery = {
    enabled = true,
  },
  floating = {
    border = "single",
    max_height = 0.6,
    max_width = 0.6,
    options = {},
  },
  highlights = {
    adapter_name = "NeotestAdapterName",
    border = "NeotestBorder",
    dir = "NeotestDir",
    expand_marker = "NeotestExpandMarker",
    failed = "NeotestFailed",
    file = "NeotestFile",
    focused = "NeotestFocused",
    indent = "NeotestIndent",
    marked = "NeotestMarked",
    namespace = "NeotestNamespace",
    passed = "NeotestPassed",
    running = "NeotestRunning",
    select_win = "NeotestWinSelect",
    skipped = "NeotestSkipped",
    target = "NeotestTarget",
    test = "NeotestTest",
    unknown = "NeotestUnknown",
  },
  icons = {
    child_indent = "│",
    child_prefix = "├",
    collapsed = "─",
    expanded = "╮",
    failed = "✖",
    final_child_indent = " ",
    final_child_prefix = "╰",
    non_collapsible = "─",
    passed = "✔",
    running = "🗘",
    skipped = "ﰸ",
    unknown = "?",
  },
  jump = {
    enabled = true,
  },
  output = {
    enabled = true,
    open_on_run = "short",
  },
  run = {
    enabled = true,
  },
  status = {
    enabled = true,
    signs = true,
    virtual_text = false,
  },
  strategies = {
    integrated = {
      height = 40,
      width = 120,
    },
  },
  summary = {
    enabled = true,
    expand_errors = true,
    follow = true,
    mappings = {
      attach = "a",
      clear_marked = "M",
      clear_target = "T",
      expand = { "<CR>", "<2-LeftMouse>" },
      expand_all = "e",
      jumpto = "i",
      mark = "m",
      output = "o",
      run = "r",
      run_marked = "R",
      short = "O",
      stop = "u",
      target = "t",
    },
  },
}

vim.keymap.set("n", "[n", function()
  neotest.jump.prev { status = "failed" }
end, { desc = "Prev Failed Test" })

vim.keymap.set("n", "]n", function()
  neotest.jump.next { status = "failed" }
end, { desc = "Next Failed Test" })
