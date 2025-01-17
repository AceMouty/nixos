{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  # Define the packages to include in the shell
  buildInputs = [
    pkgs.postgresql # Adds PostgreSQL, including the `psql` CLI
  ];

  # Optional: Set environment variables for PostgreSQL
  shellHook = ''
    export SHELL=$(which zsh)
    exec $SHELL
    echo "PostgreSQL CLI is now available. Use 'psql' to connect to a database."
  '';
}
