{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./modules/neovim
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  fonts.fontconfig.enable = true;
  home = {
    username = "ace";
    homeDirectory = "/home/ace";
    stateVersion = "24.11";
    packages = with pkgs; [
      seahorse
      libsecret
    ];
    pointerCursor = {
      name = "macOS";
      package = pkgs.apple-cursor;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.gnome-shell = {
    enable = true;
    extensions = with pkgs; [
      {package = gnomeExtensions.dash-to-dock;}
    ];
  };

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = ["dash-to-dock@micgx.gmail.com"];
    };
  };

  # load hyprland
  wayland.windowManager.hyprland.enable = true;
  xdg.configFile."hypr".source = ./config/hypr;
  xdg.configFile."hypr/hyprland.conf" = {
    source = pkgs.replaceVars ./config/hypr/hyprland.conf {
      gnomePolkit = pkgs.polkit_gnome;
      # get nix to STFU
      "DEFAULT_AUDIO_SINK" = null;
      "DEFAULT_AUDIO_SOURCE" = null;
    };
  };
  xdg.configFile."nvim".source = ./config/nvim;

  programs.zsh = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake .";
      pg-shell = "nix-shell $HOME/nixos/shells/postgres.nix";
    };
    initContent = ''
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

  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      confirm_os_window_close = 0;
    };
  };
}
