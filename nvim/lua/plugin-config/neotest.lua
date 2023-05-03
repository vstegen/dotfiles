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
                "rust",
                "go",
                "javascript",
                "typescript",
            },
        },
        -- can only run individual tests or files
        -- assumes tests are in main.rs, lib.rs, mod.rs or in tests/
        require "neotest-rust" {
            dap_adapter = "lldb",
        },
        require "neotest-go" {
            experimental = {
                test_table = true,
            },
        },
        require "neotest-python" {
            dap = { justMyCode = false },
            args = { "--log-level", "DEBUG" },
            runner = "pytest", -- alternative 'python-unittest', function is also possible
            is_test_file = function(file_path)
                if string.find(file_path, "_test.py") ~= nil then
                    return true
                end

                return false
            end,
        },
        require "neotest-jest" {
            jestCommand = "npm test --",
            jestConfigFile = "custom.jest.config.ts",
            env = { CI = true },
            cwd = function(path)
                return vim.fn.getcwd()
            end,
        },
    },
}
