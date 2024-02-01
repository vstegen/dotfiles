return {
    -- { "simrat39/rust-tools.nvim" },
    {
        "mrcjkb/rustaceanvim",
        version = "^3", -- Recommended
        ft = { "rust" },
        opts = {
            server = vim.tbl_deep_extend("force", require "vstegen.lsp.servers.rust_analyzer", {}),
        },
        config = function(_, opts)
            vim.g.rustaceanvim = function()
                local ok, mason_registry = pcall(require, "mason-registry")
                local adapter_config ---@type any
                if ok then
                    -- rust tools configuration for debugging support
                    local codelldb = mason_registry.get_package "codelldb"
                    local extension_path = codelldb:get_install_path() .. "/extension/"
                    local codelldb_path = extension_path .. "adapter/codelldb"
                    local liblldb_path = extension_path .. "lldb/lib/liblldb"
                    local this_os = vim.uv.os_uname().sysname

                    liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
                    local cfg = require "rustaceanvim.config"
                    adapter_config = cfg.get_codelldb_adapter(codelldb_path, liblldb_path)
                end

                return vim.tbl_deep_extend("force", ok and {
                    dap = {
                        adapter = adapter_config,
                    },
                } or {}, opts or {})
            end
        end,
    },
    {
        "saecki/crates.nvim",
        config = function()
            local crates = require "crates"
            crates.setup()
            crates.show()
        end,
        ft = { "rust", "toml" },
        dependencies = { "nvim-lua/plenary.nvim" },
    },
}
