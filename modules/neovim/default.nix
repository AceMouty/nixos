{ config, pkgs, ...}:
let
 withOptPlugin = plugin: { inherit plugin; optional = true; };
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
      (withOptPlugin nvim-treesitter)
      (withOptPlugin telescope-nvim)
      (withOptPlugin gitsigns-nvim)

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
    ];
  }; # programs.neovim
}
