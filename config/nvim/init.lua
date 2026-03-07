-- ### OPTIONS ###
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`

-- Make line numbers default
vim.opt.number = true
-- Relative line numbers, to help with jumping.
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

--Use Spaces instad of taps
vim.opt.expandtab = true
-- size for spaces using << and >>
vim.opt.shiftwidth = 2
-- size for spaces for tab
vim.opt.tabstop = 2
-- how many spaces when prassing tab
vim.opt.softtabstop = 2

-- indetation opthions
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- ### END OPTIONS ###

-- ### KEY MAPS ###
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })

-- Disable arrow keys in all modes
-- local modes = { 'n', 'i', 'v', 'c', 't', 'o', 's', 'x' } -- All possible modes
local modes = { 'n', 'i', 'v', 'o', 't', 's', 'x' } -- All possible modes
local arrows = { '<Up>', '<Down>', '<Left>', '<Right>' }

for _, mode in ipairs(modes) do
  for _, key in ipairs(arrows) do
    vim.keymap.set(mode, key, '<Nop>', { noremap = true, silent = true })
  end
end

local enabledModes = { 'i', 'c', 'o', 't', 's', 'x' }
-- Map Alt + hjkl in Insert mode
for _, mode in ipairs(enabledModes) do
  vim.keymap.set(mode, '<A-h>', '<Left>', { noremap = true, silent = true })
  vim.keymap.set(mode, '<A-j>', '<Down>', { noremap = true, silent = true })
  vim.keymap.set(mode, '<A-k>', '<Up>', { noremap = true, silent = true })
  vim.keymap.set(mode, '<A-l>', '<Right>', { noremap = true, silent = true })
end
-- ### END KEY MAPS ###


require("lz.n").load({
  -- Nightfox (load via colorscheme trigger)
  {
    "nightfox.nvim",
    after = function()
      require("nightfox").setup({})
      vim.cmd.colorscheme("nightfox")
    end,
  },

  -- Treesitter (your grammars are provided by Nix; don't ensure_installed)
  {
    "nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    after = function()
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Gitsigns
  {
    "gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    after = function()
      require("gitsigns").setup({})
    end,
  },

  -- Telescope
  {
    "telescope.nvim",
    cmd = "Telescope",
    after = function()
      require("telescope").setup({})
    end,
  },

  -- Neotree
  {
    "neo-tree.nvim",
    cmd = "Neotree",
    after = function()
      require("neo-tree").setup({
        filesystem = {
          window = {
            mappings = {
              -- NOTE: default `l` is focus_preview in neo-tree; override it.
              ["l"] = "open",       -- expand dir / open file
              ["h"] = "close_node", -- collapse node
              -- keep space toggle if you like:
              ["<space>"] = "toggle_node",
            },
          },
        },
      })
    end,
  },
  {
    "nvim-cmp",
    event = "InsertEnter",
    after = function()
      local cmp = require("cmp")

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer" },
        }),
      })
    end,
  },
})

-- Telescope keymaps
do
  local tmap = require("lz.n").keymap({
    "telescope.nvim",
    cmd = "Telescope",
  })

  tmap.set("n", "<leader>ff", function()
    require("telescope.builtin").find_files()
  end, { desc = "Find files" })

  tmap.set("n", "<leader>fg", function()
    require("telescope.builtin").live_grep()
  end, { desc = "Live grep" })

  tmap.set("n", "<leader>fb", function()
    require("telescope.builtin").buffers()
  end, { desc = "Buffers" })
end

-- Neotree keymaps
local nmap = require("lz.n").keymap({
  "neo-tree.nvim",
  cmd = "Neotree",
})

nmap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Explorer (neo-tree)" })

--- ### LSP & Diagnostics ###
vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = { border = "rounded" },
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
    end

    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
    map("n", "gr", vim.lsp.buf.references, "References")
    map("n", "gi", vim.lsp.buf.implementation, "Implementation")
    map("n", "K", vim.lsp.buf.hover, "Hover")
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, "Format")

    if vim.lsp.inlay_hint then
      map("n", "<leader>ih", function()
        local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
        vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
      end, "Toggle inlay hints")
    end
  end,
})

-- ========== Native LSP server configs ==========
-- Notes:
-- - "cmd" must exist on PATH (Nix: add the language server binaries via home-manager packages)
-- - "filetypes" decide which buffers should start the server
-- - "root_markers" determine project root detection
local function lsp_capabilities()
  local base = vim.lsp.protocol.make_client_capabilities()
  local ok, cmp = pcall(require, "cmp_nvim_lsp")
  if ok then
    return cmp.default_capabilities(base)
  end
  return base
end


vim.lsp.config("clangd", {
  cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed", "--header-insertion=iwyu" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_markers = { "compile_commands.json", "compile_flags.txt", ".clangd", ".git" },
  capabilities = lsp_capabilities()
})

vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".stylua.toml", "stylua.toml", ".git" },
  capabilities = lsp_capabilities(),
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config("nil_ls", {
  cmd = { "nil" },
  filetypes = { "nix" },
  root_markers = { "flake.nix", "shell.nix", "default.nix", ".git" },
  capabilities = lsp_capabilities()
})

-- Java: basic jdtls (works, but "real Java" usually wants nvim-jdtls later)
vim.lsp.config("jdtls", {
  cmd = { "jdtls" },
  filetypes = { "java" },
  root_markers = { "mvnw", "gradlew", "pom.xml", "build.gradle", "settings.gradle", ".git" },
  capabilities = lsp_capabilities()
})

vim.lsp.enable({ "clangd", "lua_ls", "nil_ls", "jdtls" })

-- LSP Format on save
do
  local formatters_by_ft = {
    c = { "clangd" },
    cpp = { "clangd" },
    -- go = { "gopls" },
    lua = { "lua_ls" },
    nix = { "nil_ls" },
    java = { "jdtls" },
    -- javascript/typescript: use a dedicated formatter (prettier) instead of LSP
    -- python: use ruff or black
  }

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("LspFormatOnSaveByFt", { clear = true }),
    callback = function(args)
      local ft = vim.bo[args.buf].filetype
      local preferred = formatters_by_ft[ft]
      if not preferred then return end

      vim.lsp.buf.format({
        bufnr = args.buf,
        timeout_ms = 2000,
        filter = function(client)
          return client.supports_method("textDocument/formatting")
              and vim.tbl_contains(preferred, client.name)
        end,
      })
    end,
  })
end
