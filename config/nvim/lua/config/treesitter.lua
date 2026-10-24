-- nvim-treesitter in nixpkgs 26.05 is the rewritten `main` branch:
-- `require("nvim-treesitter.configs")` no longer exists and highlighting is
-- not enabled for you. Grammars + queries come from Nix (withPlugins), so
-- there is nothing to install; just start treesitter per buffer.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
  callback = function(args)
    -- Fails quietly for filetypes without a grammar.
    if not pcall(vim.treesitter.start, args.buf) then
      return
    end
    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
