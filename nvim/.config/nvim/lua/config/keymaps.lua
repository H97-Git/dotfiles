-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("x", "p", '"_dP', { desc = "Paste without yanking replaced text" })
vim.keymap.set("n", "gx", "<esc>:URLOpenUnderCursor<cr>", { desc = "Open URL under cursor" })
vim.keymap.set("n", "<leader>ci", function()
  vim.lsp.buf.code_action({
    context = { only = { "source.organizeImports", "source.addMissingImports" } },
    apply = true,
  })
end, { desc = "Auto-import / organize imports" })
-- Next diagnostic
vim.keymap.set("n", "<leader>dn", function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = "Next diagnostic" })

-- Previous diagnostic
vim.keymap.set("n", "<leader>dp", function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = "Previous diagnostic" })

vim.keymap.set("n", "<leader>de", function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next error only" })

vim.keymap.set("n", "<leader>xd", "<cmd>Trouble lsp_definitions<CR>", { desc = "Show definitions in Trouble" })
-- 1) Keep your live, auto-updating view (follows cursor)
vim.keymap.set("n", "<leader>xr", "<cmd>Trouble lsp_references<CR>", { desc = "References (live, follows cursor)" })

vim.keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<CR>", { desc = "Telescope live_grep" })
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Telescope live_grep" })

-- 2) Snapshot references at the moment you press the key, then show them in Trouble's QF view
vim.keymap.set("n", "<leader>xR", function()
  vim.lsp.buf.references({ includeDeclaration = false }, {
    on_list = function(list)
      vim.fn.setqflist({}, " ", list) -- write snapshot to quickfix
      vim.cmd("Trouble qflist open") -- open static list in Trouble
    end,
  })
end, { desc = "References (snapshot → Trouble QF)" })

local dap = require("dap")
local dapui = require("dapui")

vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP Continue/Start" })
vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "DAP Toggle Breakpoint" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP Step Over" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP Step Into" })
vim.keymap.set("n", "<S-F11>", dap.step_out, { desc = "DAP Step Out" })
vim.keymap.set("n", "<leader>db", function()
  dap.set_breakpoint(vim.fn.input("Condition: "))
end, { desc = "DAP Conditional BP" })
vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "DAP UI Toggle" })

-- Grow/shrink vertically (height)
vim.keymap.set("n", "<A-Up>", "<cmd>resize +3<CR>", { desc = "Resize +height" })
vim.keymap.set("n", "<A-Down>", "<cmd>resize -3<CR>", { desc = "Resize -height" })

-- Grow/shrink horizontally (width)
vim.keymap.set("n", "<A-Left>", "<cmd>vertical resize -10<CR>", { desc = "Resize -width" })
vim.keymap.set("n", "<A-Right>", "<cmd>vertical resize +10<CR>", { desc = "Resize +width" })

-- Equalize all windows quickly
vim.keymap.set("n", "<leader>w=", "<C-w>=", { desc = "Windows: equalize" })
