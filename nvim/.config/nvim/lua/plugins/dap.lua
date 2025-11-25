return {
  -- Core DAP + UI
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

  -- C# adapter (netcoredbg via Mason)
  {
    "mfussenegger/nvim-dap",
    dependencies = { "mason-org/mason.nvim" },
    config = function()
      local dap = require("dap")
      -- Resolve Mason path to netcoredbg
      local dbg_path = vim.fn.expand("$MASON/packages/netcoredbg/netcoredbg")
      dap.adapters.coreclr = {
        type = "executable",
        command = dbg_path,
        args = { "--interpreter=vscode" },
      }

      local function pick_dll()
        local tfms = { "net9.0", "net8.0", "net7.0" }
        local cwd = vim.fn.getcwd()
        for _, tfm in ipairs(tfms) do
          local guess = string.format("%s/bin/Debug/%s/", cwd, tfm)
          if vim.uv.fs_stat(guess) then
            return vim.fn.input("1 - Path to .dll: ", guess, "file")
          end
        end
        return vim.fn.input("2 - Path to .dll: ", cwd .. "/", "file")
      end

      -- Launch current project’s DLL (Debug build)
      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "Launch (project)",
          request = "launch",
          env = {
            ASPNETCORE_ENVIRONMENT = "Development", -- picks appsettings.Development.json, etc.
            ASPNETCORE_URLS = "http://localhost:5161",
          },
          program = function()
            vim.fn.jobstart({ "dotnet", "build", "-c", "Debug" }, { detach = true })
            return pick_dll()
          end,
        },
        {
          type = "coreclr",
          name = "Attach (pick process)",
          request = "attach",
          processId = function()
            return require("dap.utils").pick_process()
          end,
        },
      }
    end,
  },
}
