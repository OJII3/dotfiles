# NixOS PostgreSQL Server module
# Local-only PostgreSQL (listens on localhost/127.0.0.1 via TCP + Unix socket).
#
# Options:
#   dot.server.postgresql.enable               - Enable PostgreSQL server
#   dot.server.postgresql.port                 - TCP port (default: 5432)
#   dot.server.postgresql.ensureDatabases       - Databases to ensure exist
#   dot.server.postgresql.ensureUsers           - Users to ensure exist (with plaintext password)
#
{
  config,
  lib,
  ...
}:
let
  cfg = config.dot.server.postgresql;
in
{
  options.dot.server.postgresql = {
    enable = lib.mkEnableOption "PostgreSQL server (local-only)";

    port = lib.mkOption {
      type = lib.types.port;
      default = 5432;
      description = "TCP port for PostgreSQL to listen on";
    };

    ensureDatabases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Databases to ensure exist";
    };

    ensureUsers = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Name of the user to ensure";
            };

            password = lib.mkOption {
              type = lib.types.str;
              description = ''
                Plaintext password for the user. Stored in the Nix store
                (world-readable to local users) and hashed by PostgreSQL on
                first apply.
              '';
            };

            ensureDBOwnership = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Grant the user ownership of the same-named database";
            };
          };
        }
      );
      default = [ ];
      description = "Users to ensure exist";
    };
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      settings.port = cfg.port;
      ensureDatabases = cfg.ensureDatabases;
      ensureUsers = map (u: {
        name = u.name;
        ensureDBOwnership = u.ensureDBOwnership;
        ensureClauses.password = u.password;
      }) cfg.ensureUsers;
      # ICU locale provider を使うことで、collation データが postgresql パッケージに
      # ピン留めされ、host の glibc アップデートによる collation version mismatch を避ける。
      initdbArgs = [
        "--locale-provider=icu"
        "--icu-locale=und-x-icu"
      ];
    };
  };
}
