-- Server binaries come from `extraPackages` in modules/neovim/default.nix.
-- Default configs (cmd, filetypes, root markers) come from nvim-lspconfig's
-- lsp/*.lua files; only list what you want to change.

vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = { border = "rounded" },
})

-- Applies to every server.
vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

vim.lsp.config("clangd", {
  cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed", "--header-insertion=iwyu" },
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
      telemetry = { enable = false },
    },
  },
})

-- Values from Nix arrive in vim.g.nix (set by `initLua` in the Nix module).
-- lspconfig's jdtls reads JDTLS_JVM_ARGS and keeps a per-project workspace.
local nix = vim.g.nix or {}
if nix.lombok_jar then
  vim.env.JDTLS_JVM_ARGS = "-javaagent:" .. nix.lombok_jar
end

vim.lsp.enable({ "clangd", "lua_ls", "nil_ls", "jdtls" })

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach-keymaps", { clear = true }),
  callback = function(args)
    local buf = args.buf
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = buf, silent = true, desc = desc })
    end

    map("gd", vim.lsp.buf.definition, "Go to definition")
    map("gD", vim.lsp.buf.declaration, "Go to declaration")
    map("gr", vim.lsp.buf.references, "References")
    map("gi", vim.lsp.buf.implementation, "Implementation")
    map("K", vim.lsp.buf.hover, "Hover")
    map("<leader>rn", vim.lsp.buf.rename, "Rename")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("<leader>ih", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
    end, "Toggle inlay hints")
    -- Formatting is conform.nvim's job: <leader>fm (lua/plugins/formatting.lua)
  end,
})
