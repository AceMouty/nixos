return {
  {
    -- Installed (and pinned in flake.lock) but not loaded until a Java file opens.
    -- spring-boot.nvim is designed to feed bundles to nvim-jdtls; if you want
    -- the full Spring tooling, add `nvim-jdtls` to the Nix plugin list and
    -- start jdtls through it instead of vim.lsp.enable("jdtls").
    "spring-boot.nvim",
    ft = "java",
    after = function()
      pcall(function() require("spring_boot").setup({}) end)
    end,
  },
}
