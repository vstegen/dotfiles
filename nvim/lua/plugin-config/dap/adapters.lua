local dap = require "dap"

dap.adapters.lldb = {
  type = "executable",
  -- command = "/usr/bin/lldb",
  command = "/opt/homebrew/Cellar/llvm/14.0.6_1/bin/lldb-vscode",
  name = "lldb",
}

dap.adapters.rt_lldb = {
  type = "executable",
  -- command = "/usr/bin/lldb",
  command = "/opt/homebrew/Cellar/llvm/14.0.6_1/bin/lldb-vscode",
  name = "rt_lldb",
}

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},

    -- 💀
    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    -- runInTerminal = false,
  },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

local dap_go_ok, dap_go = pcall(require, "dap-go")
if dap_go_ok then
  dap_go.setup()
end
