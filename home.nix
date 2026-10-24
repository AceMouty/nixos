{
  config,
  pkgs,
  lib,
  inputs,
  pkgs-unstable,
  ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
    ./modules/neovim
    ./modules/thunar
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  fonts.fontconfig.enable = true;
  home = {
    username = "ace";
    homeDirectory = "/home/ace";
    stateVersion = "24.11";
    packages =
      (with pkgs; [
        seahorse
        libsecret
        maven
      ])
      ++ [
        # needed for noctalia
        #    pkgs-unstable.quickshell
        #    pkgs-unstable.qt6.qtwayland
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
  programs.noctalia = {
    enable = true;
    settings = {
      widget.network.show_label = false;
    };
  };

  programs.gnome-shell = {
    enable = true;
    extensions = with pkgs; [
      { package = gnomeExtensions.dash-to-dock; }
    ];
  };

  programs.java = {
    enable = true;
    package = pkgs.javaPackages.compiler.temurin-bin.jdk-25;
  };

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [ "dash-to-dock@micgx.gmail.com" ];
    };
  };

  #xdg.configFile."noctalia/colorschemes".source = ./config/noctalia/colorschemes;
  #  programs.noctalia-shell = {
  #    enable = true;
  #    systemd.enable = true;
  #    settings = {
  #      colorSchemes.predefinedScheme = "MatchaDarkSea";
  #      lockScreen = {
  #        behavior = {
  #          lockOnSuspend = true;
  #        };
  #      };
  #    };
  #  };

  # load hyprland
  xdg.configFile."hypr".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/config/hypr";
  #  wayland.windowManager.hyprland.enable = true;
  #  xdg.configFile."hypr".source = ./config/hypr;
  #  xdg.configFile."hypr/hyprland.conf" = {
  #    source = pkgs.replaceVars ./config/hypr/hyprland.conf {
  #      gnomePolkit = pkgs.polkit_gnome;
  #      # get nix to STFU
  #      "DEFAULT_AUDIO_SINK" = null;
  #      "DEFAULT_AUDIO_SOURCE" = null;
  #    };
  #  };
  # nvim config symlink lives in modules/neovim

  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      confirm_os_window_close = 0;
    };
  };

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
      plugins = [ "git" ];
    };
  };
}
