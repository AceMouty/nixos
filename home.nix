{
  config,
  pkgs,
  lib,
  ...
}: {
  nixpkgs.config = {
    allowUnfree = true;
  };

  home = {
    username = "ace";
    homeDirectory = "/home/ace";
    stateVersion = "24.11";
    packages = with pkgs; [
      flameshot
      brave
      bat
      git
      dotnetCorePackages.sdk_8_0_3xx
      jetbrains.rider
      vscode
      go
    ];
  };

  programs.bash = {
    enable = true;
    shellAliases = {
    };
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch";
      hms = "home-manager switch";
    };
    initExtra = ''
      export PATH="$PATH:$HOME/go/bin/"
    '';

    oh-my-zsh = {
      enable = true;
      theme = "bira";
      plugins = ["git"];
    };
  };

  #programs.neovim = {
  # enable = true;
  # defaultEditor = true;
  # vimAlias = true;
  # vimdiffAlias = true;
  # withNodeJs = false;
  # };

  programs.nvf = {
    enable = true;
    enableManpages = true;
    settings = {
      vim.viAlias = true;
      vim.vimAlias = true;
      vim.useSystemClipboard = true;

      vim.languages.enableLSP = true;
      vim.languages.enableTreesitter = true;
      vim.languages.enableFormat = true;
      vim.lsp.formatOnSave = true;

      vim.languages.nix.enable = true;
      vim.languages.go.enable = true;
      vim.languages.lua.enable = true;

      vim.globals = {
        mapleader = " ";
      };

      vim.options = {
        tabstop = 2;
        shiftwidth = 2;
        softtabstop = 2;
        expandtab = true;
        backup = false;
      };

      vim.keymaps = [
        {
          key = "jk";
          mode = "i";
          silent = true;
          noremap = true;
          action = "<Esc>";
        }
      ];

      vim.telescope.enable = true;
      vim.terminal.toggleterm = {
        enable = true;

        setupOpts = {
          direction = "float";
        };

        mappings = {
          open = "<c-j>";
        };
      };
    };
  };
}
