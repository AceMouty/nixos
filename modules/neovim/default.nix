{
  config,
  pkgs,
  inputs,
  ...
}:
let
  # Mark a plugin as `opt` so lz.n decides when it loads.
  lazy = plugin: {
    inherit plugin;
    optional = true;
  };

  # Plugins not in nixpkgs come from flake inputs, so `flake.lock` pins the
  # revision and `nix flake update spring-boot-nvim` bumps it. No hand-edited hashes.
  spring-boot-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "spring-boot.nvim";
    version = inputs.spring-boot-nvim.shortRev or "flake";
    src = inputs.spring-boot-nvim;
    doCheck = false; # its modules expect jdtls to be running
  };

  # One place to add a language: grammar + highlight/indent queries together.
  treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (
    p: with p; [
      bash
      c
      cpp
      go
      java
      javascript
      json
      lua
      markdown
      markdown_inline
      nix
      tsx
      typescript
      vim
      vimdoc
      yaml
    ]
  );
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true; # sets EDITOR; replaces the zsh sessionVariable
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withRuby = false; # no Ruby/Python remote plugins in this config
    withPython3 = false;

    # Never let Home Manager write ~/.config/nvim/init.lua. That directory is
    # yours (symlinked below); Nix-provided values come in through initLua,
    # which the wrapper runs *before* your init.lua.
    sideloadInitLua = true;
    initLua = ''
      vim.g.nix = {
        lombok_jar = "${pkgs.lombok}/share/java/lombok.jar",
      }
    '';

    plugins = with pkgs.vimPlugins; [
      # --- start plugins: always on the runtimepath ---
      lz-n
      plenary-nvim
      nvim-web-devicons
      snacks-nvim # dashboard, notifier, indent guides, terminal
      nightfox-nvim
      nvim-lspconfig # default server configs for vim.lsp.enable()
      nvim-cmp # on rtp at startup so cmp-* sources can register; configured on InsertEnter
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      telescope-fzf-native-nvim # compiled .so, no startup cost
      treesitter # upstream: nvim-treesitter must not be lazy-loaded

      # --- lazy plugins: loaded by lz.n specs in lua/plugins/*.lua ---
      (lazy telescope-nvim)
      (lazy gitsigns-nvim)
      (lazy neo-tree-nvim)
      (lazy which-key-nvim)
      (lazy lualine-nvim)
      (lazy bufferline-nvim)
      (lazy conform-nvim)
      (lazy spring-boot-nvim)
    ];

    # Everything Neovim shells out to. Only Neovim's PATH sees these.
    extraPackages = with pkgs; [
      # language servers
      nil
      lua-language-server
      jdt-language-server
      clang-tools
      # formatters
      nixfmt
      stylua
      # used by telescope / snacks
      ripgrep
      fd
    ];
  };

  # Live-edit the Lua config: ~/.config/nvim points at the repo checkout, so
  # changing Lua never needs a rebuild. Only plugin/tool changes do.
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/config/nvim";
}
