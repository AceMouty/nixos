-- Plugin-specific keymaps live with their plugin spec in lua/plugins/*.
local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("i", "jk", "<Esc>", { silent = true })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

-- Window navigation
map("n", "<C-h>", "<C-w><C-h>", { desc = "Window left" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Window right" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Window down" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Window up" })

-- Buffers (NvChad-style)
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>x", function() Snacks.bufdelete() end, { desc = "Close buffer" })

-- Disable arrow keys; Alt+hjkl moves in insert/command-like modes
for _, mode in ipairs({ "n", "i", "v", "o", "t", "s", "x" }) do
  for _, key in ipairs({ "<Up>", "<Down>", "<Left>", "<Right>" }) do
    map(mode, key, "<Nop>", { silent = true })
  end
end

for _, mode in ipairs({ "i", "c", "o", "t", "s", "x" }) do
  map(mode, "<A-h>", "<Left>", { silent = true })
  map(mode, "<A-j>", "<Down>", { silent = true })
  map(mode, "<A-k>", "<Up>", { silent = true })
  map(mode, "<A-l>", "<Right>", { silent = true })
end
