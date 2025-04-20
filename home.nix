{
  config,
  pkgs,
  lib,
  ...
}: {
  nixpkgs.config = {
    allowUnfree = true;
  };

  fonts.fontconfig.enable = true;
  home = {
    username = "ace";
    homeDirectory = "/home/ace";
    stateVersion = "24.11";
    packages = with pkgs; [
    ];
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch";
      hms = "home-manager switch --flake $HOME/nixos/home-manager#ace";
      pg-shell = "nix-shell $HOME/nixos/shells/postgres.nix";
    };
    initExtra = ''
      export PATH="$PATH:$HOME/go/bin/"
      export PATH="$PATH:$HOME/.config/emacs/bin"

      # Check if in nix-shell and update the prompt
      if [[ -n "$IN_NIX_SHELL" ]]; then
        export PS1="$PS1 (nix-shell)"
      fi
    '';

    oh-my-zsh = {
      enable = true;
      theme = "bira";
      plugins = ["git"];
    };
  };

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
      vim.lsp.trouble.enable = true;

      vim.autocomplete.nvim-cmp.enable = true;
      vim.autocomplete.nvim-cmp.mappings.next = "<C-n>";
      vim.autocomplete.nvim-cmp.mappings.previous = "<C-p>";

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
        # Move to split
        {
          mode = "n";
          key = "<C-h>";
          action = "<C-w>h";
          silent = true;
          noremap = true;
        }
        {
          mode = "n";
          key = "<C-j>";
          action = "<C-w>j";
          silent = true;
          noremap = true;
        }
        {
          mode = "n";
          key = "<C-k>";
          action = "<C-w>k";
          silent = true;
          noremap = true;
        }
        {
          mode = "n";
          key = "<C-l>";
          action = "<C-w>l";
          silent = true;
          noremap = true;
        }
        {
          key = "<leader>e";
          mode = "n";
          silent = true;
          action = "<cmd>lua vim.diagnostic.open_float({ scope = 'line' })<CR>";
        }
      ];

      vim.telescope.enable = true;
      vim.terminal.toggleterm = {
        enable = true;

        setupOpts = {
          direction = "float";
        };

        mappings = {
          open = "<C-p>";
        };
      };
    };
  };
}
