{ config, pkgs, ... }:
let
  withOptPlugin = plugin: {
    inherit plugin;
    optional = true;
  };

  spring-boot-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "spring-boot.nvim";
    version = "main";
    src = pkgs.fetchFromGitHub {
      owner = "JavaHello";
      repo = "spring-boot.nvim";
      rev = "main";
      hash = "sha256-ioGlxjZIqtNlPedwI/HX3xA3HOWJ50WmWFyYIQPHDrg=";
    };
  };
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      { plugin = lz-n; }
      { plugin = nightfox-nvim; }
      { plugin = nvim-cmp; }
      { plugin = cmp-nvim-lsp; }
      { plugin = cmp-buffer; }
      { plugin = cmp-path; }

      (withOptPlugin telescope-nvim)
      (withOptPlugin gitsigns-nvim)
      (withOptPlugin neo-tree-nvim)
      (withOptPlugin nvim-treesitter)
      (withOptPlugin spring-boot-nvim)

      # parsers
      nvim-treesitter-parsers.nix
      nvim-treesitter-parsers.lua
      nvim-treesitter-parsers.java
      nvim-treesitter-parsers.c
      nvim-treesitter-parsers.cpp
      nvim-treesitter-parsers.javascript
      nvim-treesitter-parsers.typescript
      nvim-treesitter-parsers.go
    ];

    extraPackages = with pkgs; [
      nil
      lua-language-server
      jdt-language-server
      clang-tools
    ];
  }; # programs.neovim
}
