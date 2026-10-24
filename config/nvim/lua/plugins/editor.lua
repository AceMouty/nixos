return {
  {
    "telescope.nvim",
    cmd = "Telescope",
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
      { "<leader>fo", function() require("telescope.builtin").oldfiles() end, desc = "Recent files" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help" },
      { "<leader>fk", function() require("telescope.builtin").keymaps() end, desc = "Keymaps" },
    },
    after = function()
      local telescope = require("telescope")
      telescope.setup({})
      pcall(telescope.load_extension, "fzf") -- telescope-fzf-native, built by Nix
    end,
  },

  {
    "neo-tree.nvim",
    cmd = "Neotree",
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Explorer" },
    },
    after = function()
      require("neo-tree").setup({
        filesystem = {
          window = {
            mappings = {
              ["l"] = "open", -- default `l` is focus_preview
              ["h"] = "close_node",
              ["<space>"] = "toggle_node",
            },
          },
        },
      })
    end,
  },

  {
    "gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    after = function()
      require("gitsigns").setup({
        on_attach = function(buf)
          local gs = require("gitsigns")
          local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
          end
          map("]h", function() gs.nav_hunk("next") end, "Next hunk")
          map("[h", function() gs.nav_hunk("prev") end, "Previous hunk")
          map("<leader>gp", gs.preview_hunk, "Preview hunk")
          map("<leader>gb", gs.blame_line, "Blame line")
          map("<leader>gr", gs.reset_hunk, "Reset hunk")
        end,
      })
    end,
  },
}
