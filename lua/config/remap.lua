-- Set space as the leader key
vim.g.mapleader = " "

-- Open file explorer (netrw)
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Format the current buffer asynchronously using Conform
vim.keymap.set("n", "<leader>f", function()
	require("conform").format({ async = true })
end, { noremap = true, silent = true })

-- Move selected line(s) down/up in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Run Plenary tests for the current file
vim.api.nvim_set_keymap("n", "<leader>tf", "<Plug>PlenaryTestFile", { noremap = false, silent = false })

-- Join lines while preserving the cursor position
vim.keymap.set("n", "J", "mzJ`z")

-- Scroll down/up and center the cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Search next/previous and center the screen
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Re-indent around a paragraph and return cursor to original position
vim.keymap.set("n", "=ap", "ma=ap'a")

-- Restart LSP server
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

-- Paste over selection without overwriting the default register
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Yank to system clipboard (normal and visual mode)
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]]) -- Yank line to system clipboard

-- Delete without affecting default register
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

-- Exit insert mode using Ctrl+C (alternative to Esc)
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Disable Q (often used accidentally)
vim.keymap.set("n", "Q", "<nop>")

-- Navigate quickfix list and center screen
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

-- Navigate location list and center screen
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Replace word under cursor throughout the file (interactive)
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])


-- Insert Go error handling: if err != nil { return err }
vim.keymap.set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")

-- Insert Go assertion: assert.NoError(err, "")
vim.keymap.set("n", "<leader>ea", 'oassert.NoError(err, "")<Esc>F";a')

-- Insert Go fatal log: log.Fatalf(...)
vim.keymap.set("n", "<leader>ef", 'oif err != nil {<CR>}<Esc>Olog.Fatalf("error: %s\\n", err.Error())<Esc>jj')

-- Insert Go structured logger error
vim.keymap.set("n", "<leader>el", 'oif err != nil {<CR>}<Esc>O.logger.Error("error", "error", err)<Esc>F.;i')

-- Source (reload) current file
vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("so")
end)
