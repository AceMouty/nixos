{ pkgs, ... }:
{
  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus-Dark-Maia";
      package = pkgs.papirus-maia-icon-theme;
    };

    #theme = {
    #  name = "WhiteSur-Dark";
    #  package = pkgs.whitesur-gtk-theme;
    #};

    theme = {
      name = "Matcha-dark-sea";
      package = pkgs.matcha-gtk-theme;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  #xfconf.settings = {
  #  xsettings = {
  #    "/Net/IconThemeName" = "Papirus-Dark";
  #    "/Net/ThemeName" = "WhiteSur-Dark";
  #    "/Gtk/CursorThemeName" = "Bibata-Modern-Classic";
  #  };
  #};
}
