-- Plugins are installed by Nix (modules/neovim/default.nix).
-- This file only wires up configuration; nothing here downloads anything.
--
--   lua/config/*   editor settings that don't depend on plugins
--   lua/plugins/*  one lz.n spec list per area (merged automatically)

-- Leader must be set before any plugin keymaps are created.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.treesitter")
require("config.lsp")

-- Loads every lua/plugins/*.lua and merges the specs.
require("lz.n").load("plugins")
