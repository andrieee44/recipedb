{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  languages.nix.enable = true;

  env = lib.mkDefault {
    PGDATABASE = "";
    PGHOST = "";
    PGPASSWORD = "";
    PGPORT = "";
    PGSCHEMA_PLAN_DB = "";
    PGSCHEMA_PLAN_HOST = "";
    PGSCHEMA_PLAN_PASSWORD = "";
    PGSCHEMA_PLAN_PORT = "";
    PGSCHEMA_PLAN_SSLMODE = "";
    PGSCHEMA_PLAN_USER = "";
    PGUSER = "";
    SSHPASS = "";
    SSH_HOST = "";
    SSH_PORT = "";
    SSH_USER = "";
  };

  packages = with pkgs; [
    git
    inputs.pgschema.packages.${pkgs.stdenv.system}.default
    lsof
    nixfmt
    openssh
    postgres-language-server
    postgresql
    sshpass
    tbls
    vscode-json-languageserver
    yaml-language-server
  ];

  tasks = {
    "ssh:pgtunnel" = {
      exec = ''
        sshpass -e ssh -NfL "$PGPORT:$PGHOST:$PGPORT" -p "$SSH_PORT" \
          "$SSH_USER@$SSH_HOST"
      '';

      status = "pg_isready";
      before = [ "devenv:enterShell" ];
    };
  };

  scripts = {
    pgmigrate.exec = ''
      set -x

      for schema in public auth api; do
        pgschema apply --schema $schema \
          --file "${config.git.root}/schema/$schema/main.sql"
      done

      psql -d recipedb -v ON_ERROR_STOP=1 --echo-all <<'EOF'
        NOTIFY pgrst;
      EOF
    '';

    documentation.exec = ''
      set -x

      tbls lint
      tbls doc -f
    '';
  };
}
