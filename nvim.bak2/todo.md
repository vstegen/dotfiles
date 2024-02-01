# TODO

- [X] auto commands
- [ ] keymaps
- [X] options
- [ ] plugins
- [X] colorscheme
- [X] globals
- [ ] lsp config
    - [ ] set keymaps based on currently running server:
        - [ ] rust
            - [ ] { "K", "<cmd>RustHoverActions<cr>", desc = "Hover Actions (Rust)" },
            - [ ] { "<leader>cR", "<cmd>RustCodeAction<cr>", desc = "Code Action (Rust)" },
            - [ ] { "<leader>dr", "<cmd>RustDebuggables<cr>", desc = "Run Debuggables (Rust)" },
        - [ ] tsserver [map](https://github.com/pmizio/typescript-tools.nvim#custom-user-commands)
            - [ ] go to definition should use the plugin config instead of the lsp one because it would go to an type declaration file
