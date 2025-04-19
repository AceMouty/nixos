{
  config,
  lib,
  pkgs,
  ...
}: let
  sdkmanDir = "${config.xdg.configHome}/sdkman";
  sdkmanInitScript = ''
    export SDKMAN_DIR="${sdkmanDir}"
    if [ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then
      source "$SDKMAN_DIR/bin/sdkman-init.sh"
    fi
  '';
in {
  options.sdkman.enable = lib.mkEnableOption "Enable SDKMAN setup";

  config = lib.mkIf config.sdkman.enable {
    home.packages = with pkgs; [
      curl
      unzip
      zip
    ];

    home.activation.installSdkman = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ ! -d "${sdkmanDir}" ]; then
        echo "Installing SDKMAN into ${sdkmanDir}..."
        export SDKMAN_DIR="${sdkmanDir}"
        export SDKMAN_FORCE_NO_RC="true"
        export SDKMAN_NON_INTERACTIVE="true"

        export PATH="${pkgs.unzip}/bin:${pkgs.zip}/bin:${pkgs.curl}/bin:${pkgs.bash}/bin:${pkgs.gnutar}/bin:$PATH"

        ${lib.getExe pkgs.curl} -s "https://get.sdkman.io" | bash || echo "SDKMAN install script failed, continuing anyway"
      else
        echo "SDKMAN already installed at ${sdkmanDir}"
      fi
    '';

    programs.zsh.initExtra = lib.mkAfter sdkmanInitScript;
  };
}
