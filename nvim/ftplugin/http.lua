vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<CR>",
    "<cmd>lua require('kulala').run()<cr>",
    { noremap = true, silent = true, desc = "Execute the request" }
)

vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "[",
    "<cmd>lua require('kulala').jump_prev()<cr>",
    { noremap = true, silent = true, desc = "Jump to the previous request" }
)
vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "]",
    "<cmd>lua require('kulala').jump_next()<cr>",
    { noremap = true, silent = true, desc = "Jump to the next request" }
)

vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>hr",
    "<cmd>lua require('kulala').run()<cr>",
    { noremap = true, silent = true, desc = "Execute the request" }
)

vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>h[",
    "<cmd>lua require('kulala').jump_prev()<cr>",
    { noremap = true, silent = true, desc = "Jump to the previous request" }
)
vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>h]",
    "<cmd>lua require('kulala').jump_next()<cr>",
    { noremap = true, silent = true, desc = "Jump to the next request" }
)

vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>hi",
    "<cmd>lua require('kulala').inspect()<cr>",
    { noremap = true, silent = true, desc = "Inspect the current request" }
)

vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>ht",
    "<cmd>lua require('kulala').toggle_view()<cr>",
    { noremap = true, silent = true, desc = "Toggle between body and headers" }
)

vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>hc",
    "<cmd>lua require('kulala').copy()<cr>",
    { noremap = true, silent = true, desc = "Copy the current request as a curl command" }
)

vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>ha",
    "<cmd>lua require('kulala').run_all()<cr>",
    { noremap = true, silent = true, desc = "Run all requests" }
)

vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>hr",
    "<cmd>lua require('kulala').replay()<cr>",
    { noremap = true, silent = true, desc = "Run all requests" }
)

vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>hs",
    "<cmd>lua require('kulala').scratchpad()<cr>",
    { noremap = true, silent = true, desc = "Run all requests" }
)
