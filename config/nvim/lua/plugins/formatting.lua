-- Formatter binaries come from `extraPackages` in the Nix module.
-- Filetypes not listed fall back to LSP formatting.
local format_on_save = { c = true, cpp = true, lua = true, nix = true, java = true }

return {
  {
    "conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      { "<leader>fm", function() require("conform").format({ async = true }) end, desc = "Format buffer" },
    },
    after = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          nix = { "nixfmt" },
          -- javascript = { "prettierd" }, -- add the binary to extraPackages too
        },
        default_format_opts = { lsp_format = "fallback" },
        format_on_save = function(buf)
          if format_on_save[vim.bo[buf].filetype] then
            return { timeout_ms = 2000 }
          end
        end,
      })
    end,
  },
}
