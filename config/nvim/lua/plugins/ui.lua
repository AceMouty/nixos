-- The "NvChad feel": theme, dashboard, statusline, buffer tabs, key hints.
-- Every name below is a plugin from modules/neovim/default.nix.
--
-- `load = noop` marks a *start* plugin: Nix already put it on the runtimepath,
-- so lz.n should only run `after`, not `:packadd` it (packadd of a start
-- plugin errors once startup has finished).
local noop = function() end

return {
  {
    "nightfox.nvim",
    load = noop,
    lazy = false,
    priority = 1000, -- before anything that reads highlight groups
    after = function()
      require("nightfox").setup({})
      vim.cmd.colorscheme("nightfox") -- try carbonfox / nordfox / terafox
    end,
  },

  {
    "snacks.nvim",
    load = noop,
    lazy = false,
    priority = 900,
    after = function()
      require("snacks").setup({
        bigfile = { enabled = true },
        notifier = { enabled = true },
        indent = { enabled = true },
        terminal = { enabled = true },
        dashboard = {
          enabled = true,
          preset = {
            keys = {
              { icon = " ", key = "f", desc = "Find file", action = ":Telescope find_files" },
              { icon = " ", key = "g", desc = "Live grep", action = ":Telescope live_grep" },
              { icon = " ", key = "r", desc = "Recent files", action = ":Telescope oldfiles" },
              { icon = " ", key = "e", desc = "Explorer", action = ":Neotree toggle" },
              { icon = " ", key = "c", desc = "Config", action = ":e $MYVIMRC" },
              { icon = " ", key = "q", desc = "Quit", action = ":qa" },
            },
          },
          sections = {
            { section = "header" },
            { section = "keys", gap = 1, padding = 1 },
          },
        },
      })
      vim.keymap.set({ "n", "t" }, "<A-i>", function() Snacks.terminal.toggle() end, { desc = "Toggle terminal" })
    end,
  },

  {
    "lualine.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          globalstatus = true,
          section_separators = { left = "", right = "" },
          component_separators = "",
        },
      })
    end,
  },

  {
    "bufferline.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          close_command = function(n) Snacks.bufdelete(n) end,
          offsets = { { filetype = "neo-tree", text = "Explorer", separator = true } },
        },
      })
    end,
  },

  {
    "which-key.nvim",
    event = "DeferredUIEnter",
    after = function()
      local wk = require("which-key")
      wk.setup({ preset = "modern" })
      wk.add({
        { "<leader>f", group = "find / format" },
        { "<leader>g", group = "git" },
        { "<leader>c", group = "code" },
      })
    end,
  },
}
